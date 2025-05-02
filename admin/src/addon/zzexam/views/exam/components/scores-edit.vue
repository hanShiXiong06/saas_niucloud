<template>
    <el-dialog v-model="showDialog" :title="formData.scores_id ? t('updateScores') : t('addScores')" width="50%" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
                <el-form-item :label="t('subjectId')" prop="subject_id">
                    <el-input v-model="formData.subject_id" clearable :placeholder="t('subjectIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('examId')" prop="exam_id">
                    <el-input v-model="formData.exam_id" clearable :placeholder="t('examIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('examTitle')" >
                    <el-input v-model="formData.exam_title" clearable :placeholder="t('examTitlePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('memberId')" prop="member_id">
                    <el-input v-model="formData.member_id" clearable :placeholder="t('memberIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('realname')" prop="realname">
                    <el-input v-model="formData.realname" clearable :placeholder="t('realnamePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('mobile')" >
                    <el-input v-model="formData.mobile" clearable :placeholder="t('mobilePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('examScore')" >
                    <el-input v-model="formData.exam_score" clearable :placeholder="t('examScorePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('errorNum')" >
                    <el-input v-model="formData.error_num" clearable :placeholder="t('errorNumPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('correctNum')" >
                    <el-input v-model="formData.correct_num" clearable :placeholder="t('correctNumPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('isPass')" >
                    <el-input v-model="formData.is_pass" clearable :placeholder="t('isPassPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('startTime')" >
                    <el-input v-model="formData.start_time" clearable :placeholder="t('startTimePlaceholder')" class="input-width" />
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
import { addScores, editScores, getScoresInfo } from '@/addon/zzexam/api/exam'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    scores_id: '',
    subject_id: '',
    exam_id: '',
    exam_title: '',
    member_id: '',
    realname: '',
    mobile: '',
    exam_score: '',
    error_num: '',
    correct_num: '',
    is_pass: '',
    start_time: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
    subject_id: [
        { required: true, message: t('subjectIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    exam_id: [
        { required: true, message: t('examIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    exam_title: [
        { required: true, message: t('examTitlePlaceholder'), trigger: 'blur' },
        
    ]
,
    member_id: [
        { required: true, message: t('memberIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    realname: [
        { required: true, message: t('realnamePlaceholder'), trigger: 'blur' },
        
    ]
,
    mobile: [
        { required: true, message: t('mobilePlaceholder'), trigger: 'blur' },
        
    ]
,
    exam_score: [
        { required: true, message: t('examScorePlaceholder'), trigger: 'blur' },
        
    ]
,
    error_num: [
        { required: true, message: t('errorNumPlaceholder'), trigger: 'blur' },
        
    ]
,
    correct_num: [
        { required: true, message: t('correctNumPlaceholder'), trigger: 'blur' },
        
    ]
,
    is_pass: [
        { required: true, message: t('isPassPlaceholder'), trigger: 'blur' },
        
    ]
,
    start_time: [
        { required: true, message: t('startTimePlaceholder'), trigger: 'blur' },
        
    ]
,
    }
})

const emit = defineEmits(['complete'])

/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    let save = formData.scores_id ? editScores : addScores

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
        const data = await (await getScoresInfo(row.scores_id)).data
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
