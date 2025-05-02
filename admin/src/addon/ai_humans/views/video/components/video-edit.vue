<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updateVideo') : t('addVideo')" width="50%" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">

                
                <el-form-item :label="t('name')" >
                    <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')" class="input-width" />
                </el-form-item>

             
                
                <el-form-item :label="t('sceneTaskId')" >
                    <el-input v-model="formData.scene_task_id" clearable :placeholder="t('sceneTaskIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('videoUrl')" >
                    <el-input v-model="formData.video_url" clearable :placeholder="t('videoUrlPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('voiceUrl')" >
                    <el-input v-model="formData.voice_url" clearable :placeholder="t('voiceUrlPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('voiceId')" >
                    <el-input v-model="formData.voice_id" clearable :placeholder="t('voiceIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('cloudVideoUrl')" >
                    <el-input v-model="formData.cloud_video_url" clearable :placeholder="t('cloudVideoUrlPlaceholder')" class="input-width" />
                </el-form-item>
                
                
                <el-form-item :label="t('platform')" >
                    <el-input v-model="formData.platform" clearable :placeholder="t('platformPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('type')" >
                    <el-input v-model="formData.type" clearable :placeholder="t('typePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('msg')" >
                    <el-input v-model="formData.msg" clearable :placeholder="t('msgPlaceholder')" class="input-width" />
                </el-form-item>
                
        </el-form>
    </el-dialog>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, watch } from 'vue'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import { addVideo, editVideo, getVideoInfo, getWithMemberList } from '@/addon/ai_humans/api/video'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    member_id: '',
    name: '',
    desc: '',
    tag: '',
    scene_task_id: '',
    video_url: '',
    voice_url: '',
    voice_id: '',
    cloud_video_url: '',
    callback_url: '',
    status: '',
    platform: '',
    type: '',
    is_open: '',
    point: '',
    msg: '',
    is_audit: '',
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
    desc: [
        { required: true, message: t('descPlaceholder'), trigger: 'blur' },
        
    ]
,
    tag: [
        { required: true, message: t('tagPlaceholder'), trigger: 'blur' },
        
    ]
,
    scene_task_id: [
        { required: true, message: t('sceneTaskIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    video_url: [
        { required: true, message: t('videoUrlPlaceholder'), trigger: 'blur' },
        
    ]
,
    voice_url: [
        { required: true, message: t('voiceUrlPlaceholder'), trigger: 'blur' },
        
    ]
,
    voice_id: [
        { required: true, message: t('voiceIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    cloud_video_url: [
        { required: true, message: t('cloudVideoUrlPlaceholder'), trigger: 'blur' },
        
    ]
,
    callback_url: [
        { required: true, message: t('callbackUrlPlaceholder'), trigger: 'blur' },
        
    ]
,
    status: [
        { required: true, message: t('statusPlaceholder'), trigger: 'blur' },
        
    ]
,
    platform: [
        { required: true, message: t('platformPlaceholder'), trigger: 'blur' },
        
    ]
,
    type: [
        { required: true, message: t('typePlaceholder'), trigger: 'blur' },
        
    ]
,
    is_open: [
        { required: true, message: t('isOpenPlaceholder'), trigger: 'blur' },
        
    ]
,
    point: [
        { required: true, message: t('pointPlaceholder'), trigger: 'blur' },
        
    ]
,
    msg: [
        { required: true, message: t('msgPlaceholder'), trigger: 'blur' },
        
    ]
,
    is_audit: [
        { required: true, message: t('isAuditPlaceholder'), trigger: 'blur' },
        
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
    let save = formData.id ? editVideo : addVideo

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
        const data = await (await getVideoInfo(row.id)).data
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
