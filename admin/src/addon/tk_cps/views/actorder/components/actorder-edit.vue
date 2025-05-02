<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updateActorder') : t('addActorder')" width="50%" class="diy-dialog-wrap"
        :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
                <el-form-item :label="t('sid')" >
    <el-input v-model="formData.sid" clearable :placeholder="t('sidPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('siteId')" prop="site_id">
    <el-input v-model="formData.site_id" clearable :placeholder="t('siteIdPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('memberId')" >
    <el-input v-model="formData.member_id" clearable :placeholder="t('memberIdPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('name')" >
    <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('chanel')" >
    <el-input v-model="formData.chanel" clearable :placeholder="t('chanelPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('orderId')" >
    <el-input v-model="formData.order_id" clearable :placeholder="t('orderIdPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('payMoney')" >
    <el-input v-model="formData.pay_money" clearable :placeholder="t('payMoneyPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('rate')" >
    <el-input v-model="formData.rate" clearable :placeholder="t('ratePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('commission')" >
    <el-input v-model="formData.commission" clearable :placeholder="t('commissionPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('status')" >
    <el-input v-model="formData.status" clearable :placeholder="t('statusPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('statusName')" >
    <el-input v-model="formData.status_name" clearable :placeholder="t('statusNamePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('jlJs')" prop="jl_js">
    <el-input v-model="formData.jl_js" clearable :placeholder="t('jlJsPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('ptJs')" >
    <el-input v-model="formData.pt_js" clearable :placeholder="t('ptJsPlaceholder')" class="input-width" />
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
import { addActorder, editActorder, getActorderInfo } from '@/addon/tk_cps/api/actorder'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    sid: '',
    member_id: '',
    name: '',
    chanel: '',
    order_id: '',
    pay_money: '',
    rate: '',
    commission: '',
    status: '',
    status_name: '',
    jl_js: '',
    pt_js: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
    sid: [
        { required: true, message: t('sidPlaceholder'), trigger: 'blur' },
        
    ]
,
    member_id: [
        { required: true, message: t('memberIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    name: [
        { required: true, message: t('namePlaceholder'), trigger: 'blur' },
        
    ]
,
    chanel: [
        { required: true, message: t('chanelPlaceholder'), trigger: 'blur' },
        
    ]
,
    order_id: [
        { required: true, message: t('orderIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    pay_money: [
        { required: true, message: t('payMoneyPlaceholder'), trigger: 'blur' },
        
    ]
,
    rate: [
        { required: true, message: t('ratePlaceholder'), trigger: 'blur' },
        
    ]
,
    commission: [
        { required: true, message: t('commissionPlaceholder'), trigger: 'blur' },
        
    ]
,
    status: [
        { required: true, message: t('statusPlaceholder'), trigger: 'blur' },
        
    ]
,
    status_name: [
        { required: true, message: t('statusNamePlaceholder'), trigger: 'blur' },
        
    ]
,
    jl_js: [
        { required: true, message: t('jlJsPlaceholder'), trigger: 'blur' },
        
    ]
,
    pt_js: [
        { required: true, message: t('ptJsPlaceholder'), trigger: 'blur' },
        
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
    let save = formData.id ? editActorder : addActorder

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
        const data = await (await getActorderInfo(row.id)).data
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
