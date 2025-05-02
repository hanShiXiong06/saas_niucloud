<template>
    <el-dialog v-model="dialogVisible" title="设备质检" width="600px" :destroy-on-close="true" class="check-device-dialog">
        <div class="device-header">
            <div class="device-info">
                <div class="model">{{ deviceData.model || '未知型号' }}</div>
                <div class="imei">IMEI: {{ deviceData.imei || '无IMEI' }}</div>
            </div>
            <div class="price-tag">
                <div class="label">预估回收价</div>
                <div class="value">¥{{ deviceData.initial_price || '0.00' }}</div>
            </div>
        </div>

        <el-divider content-position="center">质检信息</el-divider>

        <el-form :model="deviceForm" label-position="top" class="check-form" :rules="rules" ref="formRef">
            <el-form-item label="质检结果" prop="check_result">
                <el-input type="textarea" v-model="deviceForm.check_result" :rows="3" placeholder="请详细描述设备的情况、功能和外观状态"
                    maxlength="500" show-word-limit />
            </el-form-item>

            <el-form-item label="质检图片" prop="check_images">
                <upload-image v-model="deviceForm.check_images" :limit="10" />
                <div class="qrcode-container">
                    <div class="qrcode">
                        <img class="main-qr-image"
                            src="data:image/png;base64,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8KoMPdXxn7/vgqVIDs65+bFWwU5klNab0jOI7GqJ9F4xkppWYb7wsnrWBetpbFWGnurogqUI/uCcmx9rFexERmm9KT0/iO5KqfReMZKaViC++JJ61gXraXxVhp7q6IKlCP7gnJsfaxXsREZpvSk9P4juSqn0XjGSmlYgvviSetYF62l8VYae6uiCpQj+4JybH2sV7ERGab0pPT+I7kqp9F4xkppWIL74knrWBetpfFWGnurogqUI/uCcmx9rFexERmm9KT0/iO5KqfReMZKaViC++JJ61gXraXxVhp7q6IKlCP7gnJsfaxXsREZpvSk9P4juSqn0XjGSmlYgvviSetYF62l8VYae6uiCpQj+4JybH2sV7ERGab0pPT+I7kqp9F4xkppWIL74knrWBetpfFWGnurogqUI/uCcmx9rFexERmm9KT0/iO5KqfReMZKaViC++JJ61gXraXxVhp7q6IKlCP7gnJsfaxXsREZpvSk9P4juSqn0XjGSmlYgvviSetYF62l8VYae6uiCpQj+4JybH2sV7ERGab0pPT+I7kqp9F4xkppWIL74knrWBetpfFWGnurogqUI/uCcmx9rFexERmm9KT0/iO5KqfReMZKaViC++JJ61gXraXxVhp7q6IKlCP7gnJsfaxXsREZpvSk9P4juSqn0XjGSmlYgvviSetYF62l8VYae6uiCpQj+4JybH2sV7ERGab0pPT+I7kqp9F4xkppWIL74knrWBetpfFWGnurogqUI/uCcmx9rFexERmm9KT0/iO5KqfReMZKaViC++JJ61gXraXxVhp7q6IKlCP7gnJsfaxXsREZpvSk9P4juSqn0XjGSmlYgvviSetYF62l8VYae6uiCpQj+4JybH2sV7ERGab0pPT+I7kqp9F4xkppWIL74knrWBetpfFWGnuqIXrDUo5YGW5kmz1Gspaae9S4Cas4Ss5jWm9IjE5bom+gvjXUi5zRGwnd5xq+/AwmpIAW2Jr0jZynWREwPeSUBNWeJWUzrTemRQUv0TfSXxjqRcxoj4bs8owuWpPnCsxKH9oUYPy1ZPbKJWUzrTemRgU30TfSXxjqRcxoj4bs8owuWpPnCsxKH9oUYPy1ZPbKJWUzrTemRgU30TfSXxjqRcxoj4bs8owuWpPnCsxKH9oUYPy1ZPbKJWUzrTemRgU30TfSXxjqRcxoj4bs8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"
                            alt="">
                    </div>
                    <div class="qrcode-text">扫码上传图片</div>
                </div>
            </el-form-item>

            <el-form-item label="最终价格" prop="final_price">
                <el-input-number v-model="deviceForm.final_price" placeholder="请输入最终价格" :step="10" :precision="2"
                    :min="0" style="width: 100%;" />
            </el-form-item>

            <el-form-item label="备注信息" prop="remark">
                <el-input type="textarea" v-model="deviceForm.remark" :rows="3" placeholder="请输入备注信息（选填）"
                    maxlength="200" show-word-limit />
            </el-form-item>
        </el-form>

        <template #footer>
            <span class="dialog-footer">
                <el-button @click="handleCancel">取消</el-button>
                <el-button type="primary" @click="handleConfirm" :loading="submitting">
                    提交质检
                </el-button>
            </span>
        </template>
    </el-dialog>
</template>

<script setup lang="ts">
import { ref, defineProps, defineEmits, watch, reactive, nextTick, onMounted } from 'vue'
import { ElMessage, FormInstance, FormRules } from 'element-plus'


// 定义设备信息接口
interface DeviceInfo {
    id?: string | number;
    model?: string;
    imei?: string;
    initial_price?: string | number;
    final_price?: string | number;
    check_result?: string;
    check_images?: string;
    check_status?: number;
    remark?: string;
    status?: number;
    [key: string]: any;
}

const props = defineProps({
    visible: {
        type: Boolean,
        default: false
    },
    device: {
        type: Object as () => DeviceInfo,
        default: () => ({})
    }
})

const emit = defineEmits(['update:visible', 'confirm', 'cancel'])

// 内部状态
const dialogVisible = ref(props.visible)
const deviceData = ref<DeviceInfo>({ ...props.device })
const submitting = ref(false)
const formRef = ref<FormInstance>()


// 表单验证规则
const rules = reactive<FormRules>({
    check_result: [
        { required: true, message: '请输入质检结果', trigger: 'blur' },
        { min: 5, message: '质检结果至少5个字符', trigger: 'blur' }
    ],
    final_price: [
        // { required: true, message: '请输入最终价格', trigger: 'change' }
    ]
})

// 表单数据
const deviceForm = reactive<{
    check_result: string;
    check_images: string;
    final_price: number | undefined;
    remark: string;
}>({
    check_result: props.device.check_result || '',
    check_images: props.device.check_images || '',
    final_price: typeof props.device.final_price === 'number'
        ? props.device.final_price
        : typeof props.device.final_price === 'string'
            ? parseFloat(props.device.final_price) || undefined
            : undefined,
    remark: props.device.remark || ''
})

// 监听visible属性变化
watch(() => props.visible, (newVal) => {
    dialogVisible.value = newVal
})

// 监听device属性变化
watch(() => props.device, (newVal) => {
    deviceData.value = { ...newVal }
    deviceForm.check_result = newVal.check_result || ''
    deviceForm.check_images = newVal.check_images || ''
    deviceForm.final_price = typeof newVal.final_price === 'number'
        ? newVal.final_price
        : typeof newVal.final_price === 'string'
            ? parseFloat(newVal.final_price) || undefined
            : undefined
    deviceForm.remark = newVal.remark || ''
}, { deep: true })

// 监听内部visible状态变化，同步到父组件
watch(dialogVisible, (newVal) => {
    emit('update:visible', newVal)
})

// 处理取消操作
const handleCancel = () => {
    dialogVisible.value = false
    emit('cancel')
}

// 处理确认操作
const handleConfirm = async () => {
    if (!formRef.value) return

    await formRef.value.validate(async (valid, fields) => {
        if (!valid) {
            console.log('表单验证失败:', fields)
            return
        }

        submitting.value = true
        try {
            // 准备提交的数据
            const submitData = {
                id: deviceData.value.id,
                check_result: deviceForm.check_result,
                check_images: deviceForm.check_images,
                remark: deviceForm.remark,
                check_status: 1, // 已质检
                final_price: deviceForm.final_price,
                action: 'check' // 标识这是质检操作
            }
            console.log(submitData)

            emit('confirm', submitData)
            // // 成功后自动关闭对话框
            dialogVisible.value = false
        } finally {
            submitting.value = false
        }
    })
}



</script>

<style lang="scss" scoped>
.check-device-dialog {
    :deep(.el-dialog__body) {
        padding-top: 10px;
    }
}

.device-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 20px;
    background-color: #f9f9f9;
    padding: 16px;
    border-radius: 8px;
}

.device-info {
    .model {
        font-size: 16px;
        font-weight: 600;
        margin-bottom: 4px;
    }

    .imei {
        font-size: 13px;
        color: #606266;
    }
}

.price-tag {
    text-align: right;

    .label {
        font-size: 12px;
        color: #909399;
        margin-bottom: 4px;
    }

    .value {
        font-size: 18px;
        font-weight: 600;
        color: #ff6b00;
    }
}

.check-form {
    margin-top: 16px;
}

.dialog-footer {
    display: flex;
    justify-content: flex-end;
}

.qrcode-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 10px;
    padding: 10px;
    border: 1px dashed #dcdfe6;
    border-radius: 4px;
    background-color: #f8f9fa;
    width: fit-content;
}

.qrcode {
    width: 120px;
    height: 120px;
}

.qrcode-text {
    margin-top: 8px;
    font-size: 12px;
    color: #909399;
}
</style>