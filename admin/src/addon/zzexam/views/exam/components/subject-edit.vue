<template>
    <el-dialog v-model="showDialog" :title="title" width="680" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
			<el-form-item :label="t('subjectName')" prop="name">
                <el-input v-model="formData.name" clearable :placeholder="t('subjectNamePlaceholder')" class="input-width" maxlength="10" show-word-limit />
            </el-form-item>
            <el-form-item :label="t('pid')" prop="pid">
                <el-select v-model="formData.pid" clearable :disabled="formData.child_count" :placeholder="t('pidPlaceholder')" class="input-width">
                    <el-option label="顶级科目" :value="0" />
                    <el-option v-for="(item) in optionList" :key="item.subject_id" :label="item.name" :value="item.subject_id" />
                </el-select>
            </el-form-item>
            <el-form-item :label="t('image')">
				<upload-image v-model="formData.image" />
            </el-form-item>

            <el-form-item :label="t('Status')" prop="status">
                <el-switch v-model="formData.status" class="input-width" active-value="normal" inactive-value="hidden" />
            </el-form-item>
        </el-form>

        <template #footer>
            <span class="dialog-footer">
                <el-button @click="showDialog = false">{{ t('cancel') }}</el-button>
                <el-button type="primary" :loading="loading" @click="confirm(formRef)">{{ t('confirm') }}</el-button>
            </span>
        </template>
    </el-dialog>
</template>

<script lang="ts" setup>
import { ref, reactive, computed } from 'vue'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import { addSubject, editSubject, getSubjectInfo, getSubjectList,getSubjectType } from '@/addon/zzexam/api/exam'

const showDialog = ref(false)
const loading = ref(false)
const title = ref('')

/**
 * 表单数据
 */
const initialFormData = {
    subject_id: '',
    name: '',
    image: '',
    pid: 0,
    status: 'normal',
    child_count: 0,
    level: 1
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
		type: [
		    { required: true, message: t('typePlaceholder'), trigger: 'blur' }
		],
        subject_id: [
            { required: true, message: t('subjectIdPlaceholder'), trigger: 'blur' }
        ],
        name: [
            { required: true, message: t('subjectNamePlaceholder'), trigger: 'blur' }
        ],
        pid: [
            { required: true, message: t('pidPlaceholder'), trigger: 'change' }
        ]
    }
})

interface optionListType {
    subject_id: number
    name: string
}
const optionList = ref<optionListType[]>([])
const emit = defineEmits(['complete'])

/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    const save = formData.subject_id ? editSubject : addSubject

    await formEl.validate(async (valid) => {
        if (valid) {
            loading.value = true

            const data = formData

            save(data).then(res => {
                loading.value = false
                showDialog.value = false
                emit('complete')
            }).catch(err => {
                loading.value = false
            })
        }
    })
}

// 获取全部科目
const getSubjectAllFn = () => {
    getSubjectList({
        level: 1,
		type: formData.type
    }).then(res => {
        optionList.value = res.data.filter((el: any) => el.subject_id != formData.subject_id)
    })
}

const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true

    if (row) {
        title.value = t('updateSubject')
        const data = await (await getSubjectInfo(row.subject_id)).data
        if (data) {
            Object.keys(formData).forEach((key: string) => {
                if (data[key] != undefined) formData[key] = data[key]
            })
        }
    } else {
        title.value = t('addSubject')
    }
    getSubjectAllFn()
    loading.value = false
}

defineExpose({
    showDialog,
    setFormData
})
</script>

<style lang="scss" scoped></style>
<style lang="scss">
.diy-dialog-wrap .el-form-item__label {
    height: auto !important;
}
</style>
