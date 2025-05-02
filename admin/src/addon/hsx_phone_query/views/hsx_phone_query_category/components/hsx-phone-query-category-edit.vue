<template>
    <el-dialog v-model="showDialog"
        :title="formData.id ? t('updateHsxPhoneQueryCategory') : t('addHsxPhoneQueryCategory')" width="50%"
        class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form"
            v-loading="loading">
            <el-form-item :label="t('typeId')" prop="type_id">
                <el-select class="input-width" v-model="formData.type_id" clearable
                    :placeholder="t('typeIdPlaceholder')">
                    <el-option label="请选择" value=""></el-option>
                    <el-option v-for="(item, index) in type_idList" :key="index" :label="item.name"
                        :value="item.value" />
                </el-select>
            </el-form-item>

            <el-form-item :label="t('name')" prop="name">
                <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item :label="t('price')" prop="price">
                <el-input v-model="formData.price" clearable :placeholder="t('pricePlaceholder')" class="input-width" />
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
import { addHsxPhoneQueryCategory, editHsxPhoneQueryCategory, getHsxPhoneQueryCategoryInfo } from '@/addon/hsx_phone_query/api/hsx_phone_query_category'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    
    id: '',
    type_id: '',
    name: '',
    price: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
        type_id: [
            { required: true, message: t('typeIdPlaceholder'), trigger: 'blur' },

        ]
        ,
        name: [
            { required: true, message: t('namePlaceholder'), trigger: 'blur' },

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
    let save = formData.id ? editHsxPhoneQueryCategory : addHsxPhoneQueryCategory

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
let type_idList = ref([])
const type_idDictList = async () => {
    type_idList.value = await (await useDictionary('phone_type')).data.dictionary
}
type_idDictList();
watch(() => type_idList.value, () => { formData.type_id = type_idList.value[0].value })


const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true
    if (row) {
        const data = await (await getHsxPhoneQueryCategoryInfo(row.id)).data
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
