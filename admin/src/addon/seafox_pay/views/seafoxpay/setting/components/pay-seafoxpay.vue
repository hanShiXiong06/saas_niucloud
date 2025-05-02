<template>
    <el-dialog v-model="showDialog" title="海狐聚合支付配置" width="700px" :destroy-on-close="true">
        <el-form :model="formData" label-width="180px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">

            <!-- <el-form-item :label="t('seafoxPayKey')" prop="config.key">
                <el-input v-model.trim="formData.config.key" :placeholder="t('seafoxPayKeyPlaceholder')" class="input-width" show-word-limit clearable />
            </el-form-item> -->
            <el-form-item label="海狐聚合商户号" prop="config.customer_number">
                <el-input v-model.trim="formData.config.customer_number" placeholder="请输入海狐聚合商户号" class="input-width"  show-word-limit clearable ></el-input>
            </el-form-item>

        </el-form>

        <template #footer>
            <span class="dialog-footer">
                <el-button @click="showDialog = false">{{ t('cancel') }}</el-button>
                <el-button type="primary" :loading="loading" @click="confirm(formRef)">{{ t('confirm') }}</el-button>
            </span>
        </template>
    </el-dialog>
</template>

<script lang="ts" setup>
import { ref, reactive, computed } from 'vue'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import Test from '@/utils/test'

const showDialog = ref(false)
const loading = ref(true)

/**
 * 表单数据
 */
 const initialFormData = {
    type: 'seafoxpay',
    config: {
        // key: '',
        customer_number: '',
    },
    channel: '',
    status: 0,
    is_default: 0
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
        // 'config.key': [
        //     { required: true, message: t('seafoxKeyPlaceholder'), trigger: 'blur' }
        // ],
        'config.customer_number': [
                      { required: true, message: '请输入海狐聚合商户号', trigger: 'blur' }
        ],
    }
})

const emit = defineEmits(['complete'])

const setFormData = async (data: any = null) => {
    loading.value = true
    Object.assign(formData, initialFormData)
    if (data) {
        Object.keys(formData).forEach((key: string) => {
            if (data[key] != undefined) formData[key] = data[key]
        })
        formData.channel = data.redio_key.split('_')[0]
        formData.status = Number(formData.status)
    }
    loading.value = false
}

/**
 * 确认
 * @param formEl
 */
 const confirm = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    await formEl.validate(async (valid) => {
        if (valid) {
            formData.config = {
                customer_number: formData.config.customer_number
            }
            console.log('formData', formData)
            emit('complete', formData)
            showDialog.value = false
        }
    })
}

const enableVerify = () => {
    let verify = true
    if (Test.empty(formData.config.customer_number)) verify = false
    return verify
}

defineExpose({
    showDialog,
    setFormData,
    enableVerify
})

</script>

<style lang="scss" scoped></style>

