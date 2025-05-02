<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updatePartner') : t('addPartner')" width="50%" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
                <el-form-item :label="t('siteId')" >
                    <el-input v-model="formData.site_id" clearable :placeholder="t('siteIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('type')" >
                    <el-input v-model="formData.type" clearable :placeholder="t('typePlaceholder')" class="input-width" />
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
                
                <el-form-item :label="t('levelId')" >
                    <el-select class="input-width" v-model="formData.level_id" clearable :placeholder="t('levelIdPlaceholder')">
                       <el-option label="请选择" value=""></el-option>
                        <el-option
                            v-for="(item, index) in levelIdList"
                            :key="index"
                            :label="item['name']"
                            :value="item['id']"
                        />
                    </el-select>
                </el-form-item>
                
                <el-form-item :label="t('mobile')" >
                    <el-input v-model="formData.mobile" clearable :placeholder="t('mobilePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('password')" >
                    <el-input v-model="formData.password" clearable :placeholder="t('passwordPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('weappOpenid')" >
                    <el-input v-model="formData.weapp_openid" clearable :placeholder="t('weappOpenidPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('wechatOpenid')" >
                    <el-input v-model="formData.wechat_openid" clearable :placeholder="t('wechatOpenidPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('unionId')" >
                    <el-input v-model="formData.union_id" clearable :placeholder="t('unionIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('name')" >
                    <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('logo')">
                    <upload-image v-model="formData.logo" />
                </el-form-item>
                
                <el-form-item :label="t('banner')" >
                    <el-input v-model="formData.banner" clearable :placeholder="t('bannerPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('pid')" >
                    <el-input v-model="formData.pid" clearable :placeholder="t('pidPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('card')" >
                    <el-input v-model="formData.card" clearable :placeholder="t('cardPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('status')" >
                    <el-input v-model="formData.status" clearable :placeholder="t('statusPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('shareCode')" >
                    <el-input v-model="formData.share_code" clearable :placeholder="t('shareCodePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('expireTime')"  class="input-width">
                    <el-date-picker 
                        class="flex-1 !flex"
                        v-model="formData.expire_time"
                        clearable
                        type="datetime"
                        value-format="YYYY-MM-DD HH:mm:ss"
                        :placeholder="t('expireTimePlaceholder')">
                    </el-date-picker>
                </el-form-item>
                <el-form-item :label="t('loginTime')" >
                    <el-input v-model="formData.login_time" clearable :placeholder="t('loginTimePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('ip')" >
                    <el-input v-model="formData.ip" clearable :placeholder="t('ipPlaceholder')" class="input-width" />
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
import { addPartner, editPartner, getPartnerInfo, getWithMemberList, getWithLevelList } from '@/addon/tk_partner/api/partner'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    type: '',
    member_id: '',
    level_id: '',
    mobile: '',
    password: '',
    weapp_openid: '',
    wechat_openid: '',
    union_id: '',
    name: '',
    logo: '',
    banner: '',
    pid: '',
    card: '',
    status: '',
    share_code: '',
    expire_time: '',
    login_time: '',
    ip: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
    type: [
        { required: true, message: t('typePlaceholder'), trigger: 'blur' },
        
    ]
,
    member_id: [
        { required: true, message: t('memberIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    level_id: [
        { required: true, message: t('levelIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    mobile: [
        { required: true, message: t('mobilePlaceholder'), trigger: 'blur' },
        
    ]
,
    password: [
        { required: true, message: t('passwordPlaceholder'), trigger: 'blur' },
        
    ]
,
    weapp_openid: [
        { required: true, message: t('weappOpenidPlaceholder'), trigger: 'blur' },
        
    ]
,
    wechat_openid: [
        { required: true, message: t('wechatOpenidPlaceholder'), trigger: 'blur' },
        
    ]
,
    union_id: [
        { required: true, message: t('unionIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    name: [
        { required: true, message: t('namePlaceholder'), trigger: 'blur' },
        
    ]
,
    logo: [
        { required: true, message: t('logoPlaceholder'), trigger: 'blur' },
        
    ]
,
    banner: [
        { required: true, message: t('bannerPlaceholder'), trigger: 'blur' },
        
    ]
,
    pid: [
        { required: true, message: t('pidPlaceholder'), trigger: 'blur' },
        
    ]
,
    card: [
        { required: true, message: t('cardPlaceholder'), trigger: 'blur' },
        
    ]
,
    status: [
        { required: true, message: t('statusPlaceholder'), trigger: 'blur' },
        
    ]
,
    share_code: [
        { required: true, message: t('shareCodePlaceholder'), trigger: 'blur' },
        
    ]
,
    expire_time: [
        { required: true, message: t('expireTimePlaceholder'), trigger: 'blur' },
        
    ]
,
    login_time: [
        { required: true, message: t('loginTimePlaceholder'), trigger: 'blur' },
        
    ]
,
    ip: [
        { required: true, message: t('ipPlaceholder'), trigger: 'blur' },
        
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
    let save = formData.id ? editPartner : addPartner

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
    const levelIdList = ref([] as any[])
    const setLevelIdList = async () => {
    levelIdList.value = await (await getWithLevelList({})).data
    }
    setLevelIdList()
const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true
    if(row){
        const data = await (await getPartnerInfo(row.id)).data
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
