<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updateFenxiaoOrder') : t('addFenxiaoOrder')" width="50%" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
                <el-form-item :label="t('memberId')" prop="member_id">
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
                
                <el-form-item :label="t('siteId')" prop="site_id">
                    <el-input v-model="formData.site_id" clearable :placeholder="t('siteIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('orderId')" >
                    <el-input v-model="formData.order_id" clearable :placeholder="t('orderIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('type')" >
                    <el-input v-model="formData.type" clearable :placeholder="t('typePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('state')" >
                    <el-input v-model="formData.state" clearable :placeholder="t('statePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('firstCommission')" >
                    <el-input v-model="formData.first_commission" clearable :placeholder="t('firstCommissionPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('twoCommission')" >
                    <el-input v-model="formData.two_commission" clearable :placeholder="t('twoCommissionPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('firstMemberId')" >
                    <el-input v-model="formData.first_member_id" clearable :placeholder="t('firstMemberIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('twoMemberId')" >
                    <el-input v-model="formData.two_member_id" clearable :placeholder="t('twoMemberIdPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('selfCommission')" >
                    <el-input v-model="formData.self_commission" clearable :placeholder="t('selfCommissionPlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('isSelf')" >
                    <el-input v-model="formData.is_self" clearable :placeholder="t('isSelfPlaceholder')" class="input-width" />
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
import { addFenxiaoOrder, editFenxiaoOrder, getFenxiaoOrderInfo, getWithMemberList } from '@/addon/ai_humans/api/fenxiaoorder'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    member_id: '',
    order_id: '',
    type: '',
    state: '',
    first_commission: '',
    two_commission: '',
    first_member_id: '',
    two_member_id: '',
    self_commission: '',
    is_self: '',
    status: '',
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
    order_id: [
        { required: true, message: t('orderIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    type: [
        { required: true, message: t('typePlaceholder'), trigger: 'blur' },
        
    ]
,
    state: [
        { required: true, message: t('statePlaceholder'), trigger: 'blur' },
        
    ]
,
    first_commission: [
        { required: true, message: t('firstCommissionPlaceholder'), trigger: 'blur' },
        
    ]
,
    two_commission: [
        { required: true, message: t('twoCommissionPlaceholder'), trigger: 'blur' },
        
    ]
,
    first_member_id: [
        { required: true, message: t('firstMemberIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    two_member_id: [
        { required: true, message: t('twoMemberIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    self_commission: [
        { required: true, message: t('selfCommissionPlaceholder'), trigger: 'blur' },
        
    ]
,
    is_self: [
        { required: true, message: t('isSelfPlaceholder'), trigger: 'blur' },
        
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
    let save = formData.id ? editFenxiaoOrder : addFenxiaoOrder

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
        const data = await (await getFenxiaoOrderInfo(row.id)).data
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
