<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updateSpdrList') : t('addSpdrList')" width="50%" class="diy-dialog-wrap"
        :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
                <el-form-item :label="t('name')" >
    <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('catId')" >
    <el-input v-model="formData.cat_id" clearable :placeholder="t('catIdPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('catName')" >
    <el-input v-model="formData.cat_name" clearable :placeholder="t('catNamePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('flie')" >
    <el-input v-model="formData.flie" clearable :placeholder="t('fliePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('num')" >
    <el-input v-model="formData.num" clearable :placeholder="t('numPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('successNum')" >
    <el-input v-model="formData.success_num" clearable :placeholder="t('successNumPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('failNum')" >
    <el-input v-model="formData.fail_num" clearable :placeholder="t('failNumPlaceholder')" class="input-width" />
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
import { addSpdrList, editSpdrList, getSpdrListInfo } from '@/addon/spdr/api/spdrlist'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    name: '',
    cat_id: '',
    cat_name: '',
    flie: '',
    num: '',
    success_num: '',
    fail_num: '',
    status: '',
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
    cat_id: [
        { required: true, message: t('catIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    cat_name: [
        { required: true, message: t('catNamePlaceholder'), trigger: 'blur' },
        
    ]
,
    flie: [
        { required: true, message: t('fliePlaceholder'), trigger: 'blur' },
        
    ]
,
    num: [
        { required: true, message: t('numPlaceholder'), trigger: 'blur' },
        
    ]
,
    success_num: [
        { required: true, message: t('successNumPlaceholder'), trigger: 'blur' },
        
    ]
,
    fail_num: [
        { required: true, message: t('failNumPlaceholder'), trigger: 'blur' },
        
    ]
,
    status: [
        { required: true, message: t('statusPlaceholder'), trigger: 'blur' },
        
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
    let save = formData.id ? editSpdrList : addSpdrList

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
        const data = await (await getSpdrListInfo(row.id)).data
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
