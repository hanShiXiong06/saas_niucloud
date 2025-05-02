<template>
    <el-dialog v-model="showDialog" :title="formData.paper_id ? t('updatePaper') : t('addPaper')" width="50%" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
                <el-form-item :label="t('siteId')" prop="site_id">
                    <el-input v-model="formData.site_id" clearable :placeholder="t('siteIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('categoryIds')" prop="category_ids">
                    <el-input v-model="formData.category_ids" clearable :placeholder="t('categoryIdsPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('title')" prop="title">
                    <el-input v-model="formData.title" clearable :placeholder="t('titlePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('mode')" >
                    <el-input v-model="formData.mode" clearable :placeholder="t('modePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('questionRules')" >
                    <el-input v-model="formData.question_rules" clearable :placeholder="t('questionRulesPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('questionNum')" >
                    <el-input v-model="formData.question_num" clearable :placeholder="t('questionNumPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('totalScore')" >
                    <el-input v-model="formData.total_score" clearable :placeholder="t('totalScorePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('passScore')" >
                    <el-input v-model="formData.pass_score" clearable :placeholder="t('passScorePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('status')" >
                    <el-input v-model="formData.status" clearable :placeholder="t('statusPlaceholder')" class="input-width" />
                </el-form-item>
                
        </el-form>

        <template #footer>
            <span class="dialog-footer">
                <el-button @click="showDialog = false">{{ t('cancel') }}</el-button>
                <el-button type="primary" :loading="loading" @click="confirm(formRef)">{{
                    t('confirm')
                }}</el-button>
            </span>
        </template>
    </el-dialog>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, watch } from 'vue'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import { addPaper, editPaper, getPaperInfo } from '@/addon/zzexam/api/paper'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    paper_id: '',
    category_ids: '',
    title: '',
    mode: '',
    question_rules: '',
    question_num: '',
    total_score: '',
    pass_score: '',
    status: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
    category_ids: [
        { required: true, message: t('categoryIdsPlaceholder'), trigger: 'blur' },
        
    ]
,
    title: [
        { required: true, message: t('titlePlaceholder'), trigger: 'blur' },
        
    ]
,
    mode: [
        { required: true, message: t('modePlaceholder'), trigger: 'blur' },
        
    ]
,
    question_rules: [
        { required: true, message: t('questionRulesPlaceholder'), trigger: 'blur' },
        
    ]
,
    question_num: [
        { required: true, message: t('questionNumPlaceholder'), trigger: 'blur' },
        
    ]
,
    total_score: [
        { required: true, message: t('totalScorePlaceholder'), trigger: 'blur' },
        
    ]
,
    pass_score: [
        { required: true, message: t('passScorePlaceholder'), trigger: 'blur' },
        
    ]
,
    status: [
        { required: true, message: t('statusPlaceholder'), trigger: 'blur' },
        
    ]

    }
})

const emit = defineEmits(['complete'])

/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    let save = formData.paper_id ? editPaper : addPaper

    await formEl.validate(async (valid) => {
        if (valid) {
            loading.value = true

            let data = formData

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

// 获取字典数据
    

    
const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true
    if(row){
        const data = await (await getPaperInfo(row.paper_id)).data
        if (data) Object.keys(formData).forEach((key: string) => {
            if (data[key] != undefined) formData[key] = data[key]
        })
    }
    loading.value = false
}

// 验证手机号格式
const mobileVerify = (rule: any, value: any, callback: any) => {
    if (value && !/^1[3-9]\d{9}$/.test(value)) {
        callback(new Error(t('generateMobile')))
    } else {
        callback()
    }
}

// 验证身份证号
const idCardVerify = (rule: any, value: any, callback: any) => {
    if (value && !/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/.test(value)) {
        callback(new Error(t('generateIdCard')))
    } else {
        callback()
    }
}

// 验证邮箱号
const emailVerify = (rule: any, value: any, callback: any) => {
    if (value && !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test(value)) {
        callback(new Error(t('generateEmail')))
    } else {
        callback()
    }
}

// 验证请输入整数
const numberVerify = (rule: any, value: any, callback: any) => {
    if (!Number.isInteger(value)) {
        callback(new Error(t('generateNumber')))
    } else {
        callback()
    }
}

defineExpose({
    showDialog,
    setFormData
})
</script>

<style lang="scss" scoped></style>
<style lang="scss">
.diy-dialog-wrap .el-form-item__label{
    height: auto  !important;
}
</style>
