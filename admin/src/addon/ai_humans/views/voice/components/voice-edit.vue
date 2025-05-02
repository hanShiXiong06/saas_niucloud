<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updateVoice') : t('addVoice')" width="50%" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
                <el-form-item :label="t('siteId')" >
                    <el-input v-model="formData.site_id" clearable :placeholder="t('siteIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('memberId')" >
                    <el-select class="input-width" v-model="formData.member_id" clearable :placeholder="t('memberIdPlaceholder')">
                       <el-option label="请选择" value=""></el-option>
                        <el-option
                            v-for="(item, index) in memberIdList"
                            :key="index"
                            :label="item['nickname']"
                            :value="item['member_id']"
                        />
                    </el-select>
                </el-form-item>
                
                <el-form-item :label="t('name')" >
                    <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('catId')" >
                    <el-input v-model="formData.cat_id" clearable :placeholder="t('catIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('desc')" >
                    <el-input v-model="formData.desc" clearable :placeholder="t('descPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('voiceUrl')" >
                    <el-input v-model="formData.voice_url" clearable :placeholder="t('voiceUrlPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('duration')" >
                    <el-input v-model="formData.duration" clearable :placeholder="t('durationPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('content')" >
                    <el-input v-model="formData.content" clearable :placeholder="t('contentPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('platform')" >
                    <el-input v-model="formData.platform" clearable :placeholder="t('platformPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('taskId')" >
                    <el-input v-model="formData.task_id" clearable :placeholder="t('taskIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('voiceId')" >
                    <el-input v-model="formData.voice_id" clearable :placeholder="t('voiceIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('status')" >
                    <el-input v-model="formData.status" clearable :placeholder="t('statusPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('isAudit')" >
                    <el-input v-model="formData.is_audit" clearable :placeholder="t('isAuditPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('isOpen')" >
                    <el-input v-model="formData.is_open" clearable :placeholder="t('isOpenPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('point')" >
                    <el-input v-model="formData.point" clearable :placeholder="t('pointPlaceholder')" class="input-width" />
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
import { addVoice, editVoice, getVoiceInfo, getWithMemberList } from '@/addon/ai_humans/api/voice'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    member_id: '',
    name: '',
    cat_id: '',
    desc: '',
    voice_url: '',
    duration: '',
    content: '',
    platform: '',
    task_id: '',
    voice_id: '',
    status: '',
    is_audit: '',
    is_open: '',
    point: '',
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
    name: [
        { required: true, message: t('namePlaceholder'), trigger: 'blur' },
        
    ]
,
    cat_id: [
        { required: true, message: t('catIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    desc: [
        { required: true, message: t('descPlaceholder'), trigger: 'blur' },
        
    ]
,
    voice_url: [
        { required: true, message: t('voiceUrlPlaceholder'), trigger: 'blur' },
        
    ]
,
    duration: [
        { required: true, message: t('durationPlaceholder'), trigger: 'blur' },
        
    ]
,
    content: [
        { required: true, message: t('contentPlaceholder'), trigger: 'blur' },
        
    ]
,
    platform: [
        { required: true, message: t('platformPlaceholder'), trigger: 'blur' },
        
    ]
,
    task_id: [
        { required: true, message: t('taskIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    voice_id: [
        { required: true, message: t('voiceIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    status: [
        { required: true, message: t('statusPlaceholder'), trigger: 'blur' },
        
    ]
,
    is_audit: [
        { required: true, message: t('isAuditPlaceholder'), trigger: 'blur' },
        
    ]
,
    is_open: [
        { required: true, message: t('isOpenPlaceholder'), trigger: 'blur' },
        
    ]
,
    point: [
        { required: true, message: t('pointPlaceholder'), trigger: 'blur' },
        
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
    let save = formData.id ? editVoice : addVoice

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
        const data = await (await getVoiceInfo(row.id)).data
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
