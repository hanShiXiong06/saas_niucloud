<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updateOrder') : t('addOrder')" width="50%" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
                <el-form-item :label="t('siteId')" >
                    <el-input v-model="formData.site_id" clearable :placeholder="t('siteIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('orderFrom')" >
                    <el-input v-model="formData.order_from" clearable :placeholder="t('orderFromPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('orderId')" >
                    <el-input v-model="formData.order_id" clearable :placeholder="t('orderIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('orderno')" >
                    <el-input v-model="formData.orderno" clearable :placeholder="t('ordernoPlaceholder')" class="input-width" />
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
                
                <el-form-item :label="t('productId')" >
                    <el-input v-model="formData.product_id" clearable :placeholder="t('productIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('name')" >
                    <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('image')">
                    <upload-image v-model="formData.image" />
                </el-form-item>
                
                <el-form-item :label="t('status')" >
                    <el-input v-model="formData.status" clearable :placeholder="t('statusPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('mobile')" >
                    <el-input v-model="formData.mobile" clearable :placeholder="t('mobilePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('realName')" >
                    <el-input v-model="formData.real_name" clearable :placeholder="t('realNamePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('idcard')" >
                    <el-input v-model="formData.idcard" clearable :placeholder="t('idcardPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('province')" >
                    <el-input v-model="formData.province" clearable :placeholder="t('provincePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('city')" >
                    <el-input v-model="formData.city" clearable :placeholder="t('cityPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('district')" >
                    <el-input v-model="formData.district" clearable :placeholder="t('districtPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('address')" >
                    <el-input v-model="formData.address" clearable :placeholder="t('addressPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('planPhone')" >
                    <el-input v-model="formData.plan_phone" clearable :placeholder="t('planPhonePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('frontImage')">
                    <upload-image v-model="formData.front_image" />
                </el-form-item>
                
                <el-form-item :label="t('backImage')">
                    <upload-image v-model="formData.back_image" />
                </el-form-item>
                
                <el-form-item :label="t('headImage')">
                    <upload-image v-model="formData.head_image" />
                </el-form-item>
                
                <el-form-item :label="t('logisticsName')" >
                    <el-input v-model="formData.logistics_name" clearable :placeholder="t('logisticsNamePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('logisticsno')" >
                    <el-input v-model="formData.logisticsno" clearable :placeholder="t('logisticsnoPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('msg')" >
                    <el-input v-model="formData.msg" clearable :placeholder="t('msgPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('activationCash')" >
                    <el-input v-model="formData.activation_cash" clearable :placeholder="t('activationCashPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('followupCash')" >
                    <el-input v-model="formData.followup_cash" clearable :placeholder="t('followupCashPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('closeTime')" >
                    <el-input v-model="formData.close_time" clearable :placeholder="t('closeTimePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('operatorName')" >
                    <el-input v-model="formData.operator_name" clearable :placeholder="t('operatorNamePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('modeName')" >
                    <el-input v-model="formData.mode_name" clearable :placeholder="t('modeNamePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('isActivation')" >
                    <el-input v-model="formData.is_activation" clearable :placeholder="t('isActivationPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('isFirstCharge')" >
                    <el-input v-model="formData.is_first_charge" clearable :placeholder="t('isFirstChargePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('firstChargeAmount')" >
                    <el-input v-model="formData.first_charge_amount" clearable :placeholder="t('firstChargeAmountPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('commissionStatus')" >
                    <el-input v-model="formData.commission_status" clearable :placeholder="t('commissionStatusPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('commission')" >
                    <el-input v-model="formData.commission" clearable :placeholder="t('commissionPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('memberCommission')" >
                    <el-input v-model="formData.member_commission" clearable :placeholder="t('memberCommissionPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('isJs')" >
                    <el-input v-model="formData.is_js" clearable :placeholder="t('isJsPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('closeReason')" >
                    <el-input v-model="formData.close_reason" clearable :placeholder="t('closeReasonPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('deleteTime')" >
                    <el-input v-model="formData.delete_time" clearable :placeholder="t('deleteTimePlaceholder')" class="input-width" />
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
import { addOrder, editOrder, getOrderInfo, getWithMemberList } from '@/addon/hk/api/order'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    order_from: '',
    order_id: '',
    orderno: '',
    member_id: '',
    product_id: '',
    name: '',
    image: '',
    status: '',
    mobile: '',
    real_name: '',
    idcard: '',
    province: '',
    city: '',
    district: '',
    address: '',
    plan_phone: '',
    front_image: '',
    back_image: '',
    head_image: '',
    logistics_name: '',
    logisticsno: '',
    msg: '',
    activation_cash: '',
    followup_cash: '',
    close_time: '',
    operator_name: '',
    mode_name: '',
    is_activation: '',
    is_first_charge: '',
    first_charge_amount: '',
    commission_status: '',
    commission: '',
    member_commission: '',
    is_js: '',
    close_reason: '',
    delete_time: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
    order_from: [
        { required: true, message: t('orderFromPlaceholder'), trigger: 'blur' },
        
    ]
,
    order_id: [
        { required: true, message: t('orderIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    orderno: [
        { required: true, message: t('ordernoPlaceholder'), trigger: 'blur' },
        
    ]
,
    member_id: [
        { required: true, message: t('memberIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    product_id: [
        { required: true, message: t('productIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    name: [
        { required: true, message: t('namePlaceholder'), trigger: 'blur' },
        
    ]
,
    image: [
        { required: true, message: t('imagePlaceholder'), trigger: 'blur' },
        
    ]
,
    status: [
        { required: true, message: t('statusPlaceholder'), trigger: 'blur' },
        
    ]
,
    mobile: [
        { required: true, message: t('mobilePlaceholder'), trigger: 'blur' },
        
    ]
,
    real_name: [
        { required: true, message: t('realNamePlaceholder'), trigger: 'blur' },
        
    ]
,
    idcard: [
        { required: true, message: t('idcardPlaceholder'), trigger: 'blur' },
        
    ]
,
    province: [
        { required: true, message: t('provincePlaceholder'), trigger: 'blur' },
        
    ]
,
    city: [
        { required: true, message: t('cityPlaceholder'), trigger: 'blur' },
        
    ]
,
    district: [
        { required: true, message: t('districtPlaceholder'), trigger: 'blur' },
        
    ]
,
    address: [
        { required: true, message: t('addressPlaceholder'), trigger: 'blur' },
        
    ]
,
    plan_phone: [
        { required: true, message: t('planPhonePlaceholder'), trigger: 'blur' },
        
    ]
,
    front_image: [
        { required: true, message: t('frontImagePlaceholder'), trigger: 'blur' },
        
    ]
,
    back_image: [
        { required: true, message: t('backImagePlaceholder'), trigger: 'blur' },
        
    ]
,
    head_image: [
        { required: true, message: t('headImagePlaceholder'), trigger: 'blur' },
        
    ]
,
    logistics_name: [
        { required: true, message: t('logisticsNamePlaceholder'), trigger: 'blur' },
        
    ]
,
    logisticsno: [
        { required: true, message: t('logisticsnoPlaceholder'), trigger: 'blur' },
        
    ]
,
    msg: [
        { required: true, message: t('msgPlaceholder'), trigger: 'blur' },
        
    ]
,
    activation_cash: [
        { required: true, message: t('activationCashPlaceholder'), trigger: 'blur' },
        
    ]
,
    followup_cash: [
        { required: true, message: t('followupCashPlaceholder'), trigger: 'blur' },
        
    ]
,
    close_time: [
        { required: true, message: t('closeTimePlaceholder'), trigger: 'blur' },
        
    ]
,
    operator_name: [
        { required: true, message: t('operatorNamePlaceholder'), trigger: 'blur' },
        
    ]
,
    mode_name: [
        { required: true, message: t('modeNamePlaceholder'), trigger: 'blur' },
        
    ]
,
    is_activation: [
        { required: true, message: t('isActivationPlaceholder'), trigger: 'blur' },
        
    ]
,
    is_first_charge: [
        { required: true, message: t('isFirstChargePlaceholder'), trigger: 'blur' },
        
    ]
,
    first_charge_amount: [
        { required: true, message: t('firstChargeAmountPlaceholder'), trigger: 'blur' },
        
    ]
,
    commission_status: [
        { required: true, message: t('commissionStatusPlaceholder'), trigger: 'blur' },
        
    ]
,
    commission: [
        { required: true, message: t('commissionPlaceholder'), trigger: 'blur' },
        
    ]
,
    member_commission: [
        { required: true, message: t('memberCommissionPlaceholder'), trigger: 'blur' },
        
    ]
,
    is_js: [
        { required: true, message: t('isJsPlaceholder'), trigger: 'blur' },
        
    ]
,
    close_reason: [
        { required: true, message: t('closeReasonPlaceholder'), trigger: 'blur' },
        
    ]
,
    delete_time: [
        { required: true, message: t('deleteTimePlaceholder'), trigger: 'blur' },
        
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
    let save = formData.id ? editOrder : addOrder

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
        const data = await (await getOrderInfo(row.id)).data
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
