<template>
    <el-dialog v-model="showDialog"
        :title="formData.id ? t('updatePhoneShopRecycleOrder') : t('addPhoneShopRecycleOrder')" width="50%"
        class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form"
            v-loading="loading">
            <el-form-item :label="t('count')" prop="count">
                <el-input v-model="formData.count" clearable :placeholder="t('countPlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item :label="t('expressId')">
                <el-input v-model="formData.express_id" clearable :placeholder="t('expressIdPlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('sendUsername')">
                <el-input v-model="formData.send_username" clearable :placeholder="t('sendUsernamePlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('telphone')" prop="telphone">
                <el-input v-model="formData.telphone" clearable :placeholder="t('telphonePlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('payType')" prop="pay_type">
                <el-input v-model="formData.pay_type" clearable :placeholder="t('payTypePlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('account')" prop="account">
                <el-input v-model="formData.account" clearable :placeholder="t('accountPlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('status')">
                <el-select class="input-width" v-model="formData.status" clearable
                    :placeholder="t('statusPlaceholder')">
                    <el-option label="请选择" value=""></el-option>
                    <el-option v-for="(item, index) in statusList" :key="index" :label="item.name"
                        :value="item.value" />
                </el-select>
            </el-form-item>

            <el-form-item :label="t('closeExpressId')">
                <el-input v-model="formData.close_express_id" clearable :placeholder="t('closeExpressIdPlaceholder')"
                    class="input-width" />
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
import { ref, reactive, computed, watch, onMounted } from 'vue'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import { addPhoneShopRecycleOrder, editPhoneShopRecycleOrder, getPhoneShopRecycleOrderInfo, getWithMemberList, getRecycleOrderStatusDict } from '@/addon/phone_shop_price/api/phone_shop_recycle_order'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    count: '',
    express_id: '',
    send_username: '',
    telphone: '',
    pay_type: '',
    account: '',
    status: '',
    close_express_id: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
        count: [
            { required: true, message: t('countPlaceholder'), trigger: 'blur' },

        ]
        ,
        express_id: [
            { required: true, message: t('expressIdPlaceholder'), trigger: 'blur' },

        ]
        ,
        send_username: [
            { required: true, message: t('sendUsernamePlaceholder'), trigger: 'blur' },

        ]
        ,
        telphone: [
            { required: true, message: t('telphonePlaceholder'), trigger: 'blur' },

        ]
        ,
        pay_type: [
            { required: true, message: t('payTypePlaceholder'), trigger: 'blur' },

        ]
        ,
        account: [
            { required: true, message: t('accountPlaceholder'), trigger: 'blur' },

        ]
        ,
        status: [
            { required: true, message: t('statusPlaceholder'), trigger: 'blur' },

        ]
        ,
        close_express_id: [
            { required: true, message: t('closeExpressIdPlaceholder'), trigger: 'blur' },

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
    let save = formData.id ? editPhoneShopRecycleOrder : addPhoneShopRecycleOrder

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
let statusList = ref([] as any[])
const loadStatusDict = async () => {
    const res = await getRecycleOrderStatusDict()
    if (res.code === 0 && res.data) {
        statusList.value = Object.entries(res.data).map(([value, item]: [string, any]) => ({
            value: parseInt(value),
            name: item.name
        }))
    }
}

onMounted(() => {
    loadStatusDict()
})


const memberIdList = ref([] as any[])
const setMemberIdList = async () => {
    memberIdList.value = await (await getWithMemberList({})).data
}
setMemberIdList()
const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true
    if (row) {
        const data = await (await getPhoneShopRecycleOrderInfo(row.id)).data
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
.diy-dialog-wrap .el-form-item__label {
    height: auto !important;
}
</style>
