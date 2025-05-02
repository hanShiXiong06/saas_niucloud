<template>
    <el-dialog v-model="showDialog" :title="title" width="680" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
            <el-form-item :label="t('type')" prop="type">
				<el-radio-group  v-model="formData.type" @change="getCategoryAllFn()" :placeholder="t('typePlaceholder')">
					<el-radio
						v-for="(item, key) in typeList"
						:value="key" :label="item">
						  {{ item }}
					</el-radio>
				</el-radio-group>
			</el-form-item>
			<el-form-item :label="t('categoryName')" prop="name">
                <el-input v-model.trim="formData.name" clearable :placeholder="t('categoryNamePlaceholder')" class="input-width" maxlength="10" show-word-limit />
            </el-form-item>
            <el-form-item :label="t('pid')" prop="pid">
                <el-select v-model="formData.pid" clearable :disabled="formData.child_count" :placeholder="t('pidPlaceholder')" class="input-width">
                    <el-option label="顶级分类" :value="0" />
                    <el-option v-for="(item) in optionList" :key="item.category_id" :label="item.name" :value="item.category_id" />
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
import { addCategory, editCategory, getCategoryInfo, getCategoryList,getCategoryType } from '@/addon/zzexam/api/study'

const showDialog = ref(false)
const loading = ref(false)
const title = ref('')

/**
 * 表单数据
 */
const initialFormData = {
    category_id: '',
	type:'question',
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
        category_id: [
            { required: true, message: t('categoryIdPlaceholder'), trigger: 'blur' }
        ],
        name: [
            { required: true, message: t('categoryNamePlaceholder'), trigger: 'blur' }
        ],
        pid: [
            { required: true, message: t('pidPlaceholder'), trigger: 'change' }
        ]
    }
})

interface optionListType {
    category_id: number
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
    const save = formData.category_id ? editCategory : addCategory

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

const typeList = ref([])
const typeDictList = async () => {
    typeList.value = await (await getCategoryType()).data
}
typeDictList()

// 获取全部分类
const getCategoryAllFn = () => {
    getCategoryList({
        level: 1,
		type: formData.type
    }).then(res => {
        optionList.value = res.data.filter((el: any) => el.category_id != formData.category_id)
    })
}

const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true

    if (row) {
        title.value = t('updateCategory')
        const data = await (await getCategoryInfo(row.category_id)).data
        if (data) {
            Object.keys(formData).forEach((key: string) => {
                if (data[key] != undefined) formData[key] = data[key]
            })
        }
    } else {
        title.value = t('addCategory')
    }
    getCategoryAllFn()
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
