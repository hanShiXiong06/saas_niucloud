<template>
    <el-dialog v-model="showDialog" title="修改点数" width="20%" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
               
                <el-form-item :label="t('point')" >
                    <el-input-number v-model="formData.point" clearable :placeholder="t('pointPlaceholder')"  class="input-width"  :min = "0" max = "1000000" />
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
import { addAihumansMember, editAihumansMember, getAihumansMemberInfo, getWithMemberList } from '@/addon/ai_humans/api/aihumansmember'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    member_id: '',
    point: '',
    clone_voice_num: '',
    create_voice_num: '',
    clone_video_num: '',
    create_video_num: '',
    chat_num: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
    member_id: [
        { required: true, message: t('memberIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    point: [
        { required: true, message: t('pointPlaceholder'), trigger: 'blur' },
        { validator: (rule: any, value: string, callback: any) => {  if (value && !/^\d{0,1000000}$/.test(value)) { callback(new Error(t('generateBetween')))} else { callback() }}},
    ]
,
    clone_voice_num: [
        { required: true, message: t('cloneVoiceNumPlaceholder'), trigger: 'blur' },
        { validator: (rule: any, value: string, callback: any) => {  if (value && !/^\d{0,10000000}$/.test(value)) { callback(new Error(t('generateBetween')))} else { callback() }}},
    ]
,
    create_voice_num: [
        { required: true, message: t('createVoiceNumPlaceholder'), trigger: 'blur' },
        { validator: (rule: any, value: string, callback: any) => {  if (value && !/^\d{0,1000000}$/.test(value)) { callback(new Error(t('generateBetween')))} else { callback() }}},
    ]
,
    clone_video_num: [
        { required: true, message: t('cloneVideoNumPlaceholder'), trigger: 'blur' },
        { validator: (rule: any, value: string, callback: any) => {  if (value && !/^\d{0,10000000}$/.test(value)) { callback(new Error(t('generateBetween')))} else { callback() }}},
    ]
,
    create_video_num: [
        { required: true, message: t('createVideoNumPlaceholder'), trigger: 'blur' },
        { validator: (rule: any, value: string, callback: any) => {  if (value && !/^\d{0,100000}$/.test(value)) { callback(new Error(t('generateBetween')))} else { callback() }}},
    ]
,
    chat_num: [
        { required: true, message: t('chatNumPlaceholder'), trigger: 'blur' },
        { validator: (rule: any, value: string, callback: any) => {  if (value && !/^\d{0,1000000}$/.test(value)) { callback(new Error(t('generateBetween')))} else { callback() }}},
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
    let save = formData.id ? editAihumansMember : addAihumansMember

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
    

    
    const memberIdList = ref([] as any[])
    const setMemberIdList = async () => {
    memberIdList.value = await (await getWithMemberList({})).data
    }
    setMemberIdList()
const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true
    if(row){
        const data = await (await getAihumansMemberInfo(row.id)).data
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
