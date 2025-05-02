<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updateLevel') : t('addLevel')" width="50%" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">

                
                <el-form-item :label="t('name')" prop="name">
                    <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('icon')" prop="icon">
                    <upload-image v-model="formData.icon" />
                </el-form-item>
                
                <el-form-item :label="t('rate')" prop="rate">
                    <el-input type="number" min="0" max="100" v-model="formData.rate" clearable :placeholder="t('ratePlaceholder')" class="input-width" />
                    <span class="text-slate-400 ml-2">10代表10%；实际返佣的百分比作为利润；如订单利润10元，店主应得利润=10x10%=1</span>
                </el-form-item>
                <el-form-item :label="t('price')" prop="price">
                    <el-input v-model="formData.price" type="number" min="0" clearable :placeholder="t('pricePlaceholder')" class="input-width" />
                </el-form-item>
                
                <!-- <el-form-item :label="t('card')" >
                    <el-input-number v-model="formData.card" clearable :placeholder="t('cardPlaceholder')"  class="input-width"  :min = "0" max = "100" />
                </el-form-item> -->
                
                <!-- <el-form-item :label="t('desc')" >
                    <el-input v-model="formData.desc" clearable :placeholder="t('descPlaceholder')" class="input-width" />
                </el-form-item> -->
                
                <el-form-item :label="t('content')" prop="content">
                    <editor v-model="formData.content" />
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
import { addLevel, editLevel, getLevelInfo } from '@/addon/tk_partner/api/level'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    name: '',
    icon: '',
    rate: '',
    card: '',
    desc: '',
    content: '',
    price: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
    name: [
        { required: true, message: t('namePlaceholder'), trigger: 'blur' },
        
    ]
,
    icon: [
        { required: true, message: t('iconPlaceholder'), trigger: 'blur' },
        
    ]
,
    rate: [
        { required: true, message: t('ratePlaceholder'), trigger: 'blur' },
        
    ]
,
    card: [
        { required: true, message: t('cardPlaceholder'), trigger: 'blur' },
        { validator: (rule: any, value: string, callback: any) => {  if (value && !/^\d{0,100}$/.test(value)) { callback(new Error(t('generateBetween')))} else { callback() }}},
    ]
,
    desc: [
        { required: true, message: t('descPlaceholder'), trigger: 'blur' },
        
    ]
,
    content: [
        { required: true, message: t('contentPlaceholder'), trigger: 'blur' },
        
    ]
,
    price: [
        { required: true, message: t('pricePlaceholder'), trigger: 'blur' },
        
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
    let save = formData.id ? editLevel : addLevel

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
        const data = await (await getLevelInfo(row.id)).data
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
