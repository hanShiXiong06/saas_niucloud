<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updateBwcOrder') : t('addBwcOrder')" width="50%" class="diy-dialog-wrap"
        :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
                <el-form-item :label="t('memberId')" >
    <el-input v-model="formData.member_id" clearable :placeholder="t('memberIdPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('orderSn')" >
    <el-input v-model="formData.orderSn" clearable :placeholder="t('orderSnPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('orderNo')" >
    <el-input v-model="formData.order_no" clearable :placeholder="t('orderNoPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('userOrderSn')" >
    <el-input v-model="formData.userOrderSn" clearable :placeholder="t('userOrderSnPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('paidAmount')" >
    <el-input v-model="formData.paidAmount" clearable :placeholder="t('paidAmountPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('shopOriginId')" >
    <el-input v-model="formData.shopOriginId" clearable :placeholder="t('shopOriginIdPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('orderTelephone')" >
    <el-input v-model="formData.orderTelephone" clearable :placeholder="t('orderTelephonePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('name')" >
    <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('logo')">
    <upload-image v-model="formData.logo" />
</el-form-item>

                <el-form-item :label="t('address')" >
    <el-input v-model="formData.address" clearable :placeholder="t('addressPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('platform')" >
    <el-input v-model="formData.platform" clearable :placeholder="t('platformPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('platformName')" >
    <el-input v-model="formData.platformName" clearable :placeholder="t('platformNamePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('platformLogo')">
    <upload-image v-model="formData.platformLogo" />
</el-form-item>

                <el-form-item :label="t('source')" >
    <el-input v-model="formData.source" clearable :placeholder="t('sourcePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('actionUrl')" >
    <el-input v-model="formData.actionUrl" clearable :placeholder="t('actionUrlPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('planId')" >
    <el-input v-model="formData.planId" clearable :placeholder="t('planIdPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('planTypeCh')" >
    <el-input v-model="formData.planTypeCh" clearable :placeholder="t('planTypeChPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('planTypeDescCh')" >
    <el-input v-model="formData.planTypeDescCh" clearable :placeholder="t('planTypeDescChPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('plan')" >
    <el-input v-model="formData.plan" clearable :placeholder="t('planPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('commissionType')" >
    <el-input v-model="formData.commissionType" clearable :placeholder="t('commissionTypePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('sid')" >
    <el-input v-model="formData.sid" clearable :placeholder="t('sidPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('minAmount')" >
    <el-input v-model="formData.minAmount" clearable :placeholder="t('minAmountPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('maxAmount')" >
    <el-input v-model="formData.maxAmount" clearable :placeholder="t('maxAmountPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('commission')" >
    <el-input v-model="formData.commission" clearable :placeholder="t('commissionPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('commissionRatio')" >
    <el-input v-model="formData.commissionRatio" clearable :placeholder="t('commissionRatioPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('ecommission')" >
    <el-input v-model="formData.ecommission" clearable :placeholder="t('ecommissionPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('ecommissionRatio')" >
    <el-input v-model="formData.ecommissionRatio" clearable :placeholder="t('ecommissionRatioPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('state')" >
    <el-input v-model="formData.state" clearable :placeholder="t('statePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('createTime')" >
    <el-input v-model="formData.createTime" clearable :placeholder="t('createTimePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('finishedTime')" >
    <el-input v-model="formData.finishedTime" clearable :placeholder="t('finishedTimePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('xgzSettleStatus')" >
    <el-input v-model="formData.xgzSettleStatus" clearable :placeholder="t('xgzSettleStatusPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('xgzSettleTime')" >
    <el-input v-model="formData.xgzSettleTime" clearable :placeholder="t('xgzSettleTimePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('closeTime')" >
    <el-input v-model="formData.close_time" clearable :placeholder="t('closeTimePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('reason')" >
    <el-input v-model="formData.reason" clearable :placeholder="t('reasonPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('fanxian')" >
    <el-input v-model="formData.fanxian" clearable :placeholder="t('fanxianPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('isFanxian')" >
    <el-input v-model="formData.is_fanxian" clearable :placeholder="t('isFanxianPlaceholder')" class="input-width" />
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

import { addBwcOrder, editBwcOrder, getBwcOrderInfo, } from '@/addon/tk_cps/api/bwcorder'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    member_id: '',
    orderSn: '',
    order_no: '',
    userOrderSn: '',
    paidAmount: '',
    shopOriginId: '',
    orderTelephone: '',
    name: '',
    logo: '',
    address: '',
    platform: '',
    platformName: '',
    platformLogo: '',
    source: '',
    actionUrl: '',
    planId: '',
    planTypeCh: '',
    planTypeDescCh: '',
    plan: '',
    commissionType: '',
    sid: '',
    minAmount: '',
    maxAmount: '',
    commission: '',
    commissionRatio: '',
    ecommission: '',
    ecommissionRatio: '',
    state: '',
    createTime: '',
    finishedTime: '',
    xgzSettleStatus: '',
    xgzSettleTime: '',
    close_time: '',
    reason: '',
    fanxian: '',
    is_fanxian: '',
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
    orderSn: [
        { required: true, message: t('orderSnPlaceholder'), trigger: 'blur' },
        
    ]
,
    order_no: [
        { required: true, message: t('orderNoPlaceholder'), trigger: 'blur' },
        
    ]
,
    userOrderSn: [
        { required: true, message: t('userOrderSnPlaceholder'), trigger: 'blur' },
        
    ]
,
    paidAmount: [
        { required: true, message: t('paidAmountPlaceholder'), trigger: 'blur' },
        
    ]
,
    shopOriginId: [
        { required: true, message: t('shopOriginIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    orderTelephone: [
        { required: true, message: t('orderTelephonePlaceholder'), trigger: 'blur' },
        
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
    address: [
        { required: true, message: t('addressPlaceholder'), trigger: 'blur' },
        
    ]
,
    platform: [
        { required: true, message: t('platformPlaceholder'), trigger: 'blur' },
        
    ]
,
    platformName: [
        { required: true, message: t('platformNamePlaceholder'), trigger: 'blur' },
        
    ]
,
    platformLogo: [
        { required: true, message: t('platformLogoPlaceholder'), trigger: 'blur' },
        
    ]
,
    source: [
        { required: true, message: t('sourcePlaceholder'), trigger: 'blur' },
        
    ]
,
    actionUrl: [
        { required: true, message: t('actionUrlPlaceholder'), trigger: 'blur' },
        
    ]
,
    planId: [
        { required: true, message: t('planIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    planTypeCh: [
        { required: true, message: t('planTypeChPlaceholder'), trigger: 'blur' },
        
    ]
,
    planTypeDescCh: [
        { required: true, message: t('planTypeDescChPlaceholder'), trigger: 'blur' },
        
    ]
,
    plan: [
        { required: true, message: t('planPlaceholder'), trigger: 'blur' },
        
    ]
,
    commissionType: [
        { required: true, message: t('commissionTypePlaceholder'), trigger: 'blur' },
        
    ]
,
    sid: [
        { required: true, message: t('sidPlaceholder'), trigger: 'blur' },
        
    ]
,
    minAmount: [
        { required: true, message: t('minAmountPlaceholder'), trigger: 'blur' },
        
    ]
,
    maxAmount: [
        { required: true, message: t('maxAmountPlaceholder'), trigger: 'blur' },
        
    ]
,
    commission: [
        { required: true, message: t('commissionPlaceholder'), trigger: 'blur' },
        
    ]
,
    commissionRatio: [
        { required: true, message: t('commissionRatioPlaceholder'), trigger: 'blur' },
        
    ]
,
    ecommission: [
        { required: true, message: t('ecommissionPlaceholder'), trigger: 'blur' },
        
    ]
,
    ecommissionRatio: [
        { required: true, message: t('ecommissionRatioPlaceholder'), trigger: 'blur' },
        
    ]
,
    state: [
        { required: true, message: t('statePlaceholder'), trigger: 'blur' },
        
    ]
,
    createTime: [
        { required: true, message: t('createTimePlaceholder'), trigger: 'blur' },
        
    ]
,
    finishedTime: [
        { required: true, message: t('finishedTimePlaceholder'), trigger: 'blur' },
        
    ]
,
    xgzSettleStatus: [
        { required: true, message: t('xgzSettleStatusPlaceholder'), trigger: 'blur' },
        
    ]
,
    xgzSettleTime: [
        { required: true, message: t('xgzSettleTimePlaceholder'), trigger: 'blur' },
        
    ]
,
    close_time: [
        { required: true, message: t('closeTimePlaceholder'), trigger: 'blur' },
        
    ]
,
    reason: [
        { required: true, message: t('reasonPlaceholder'), trigger: 'blur' },
        
    ]
,
    fanxian: [
        { required: true, message: t('fanxianPlaceholder'), trigger: 'blur' },
        
    ]
,
    is_fanxian: [
        { required: true, message: t('isFanxianPlaceholder'), trigger: 'blur' },
        
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
    let save = formData.id ? editBwcOrder : addBwcOrder

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
        const data = await (await getBwcOrderInfo(row.id)).data
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
