<template>
    <el-dialog v-model="dialogVisible" title="设备定价" width="500px" :destroy-on-close="true" class="price-form-dialog">
        <div class="device-summary">
            <div class="device-header">
                <span class="model">{{ deviceData.model || '未知型号' }}</span>
                <el-tag size="small" type="info">{{ deviceData.imei || '无IMEI' }}</el-tag>
            </div>
            <div class="price-compare">
                <div class="price-item">
                    <div class="price-label">预估价格</div>
                    <div class="price-value initial">¥{{ deviceData.initial_price || '0.00' }}</div>
                </div>
                <div class="price-divider">
                    <el-icon>
                        <ArrowRight />
                    </el-icon>
                </div>
                <div class="price-item">
                    <div class="price-label">最终定价</div>
                    <div class="price-value final" :class="priceChangeClass">
                        ¥{{ deviceForm.final_price || '0.00' }}
                    </div>
                </div>
            </div>
        </div>

        <el-divider content-position="center">定价信息</el-divider>

        <el-form :model="deviceForm" label-position="top" class="price-form">
            <el-form-item label="质检结果" class="inspect-result">
                <el-input v-model="deviceData.check_result" type="textarea" rows="2" readonly placeholder="无质检结果" />
            </el-form-item>

            <el-form-item label="最终价格">
                <el-input-number v-model="deviceForm.final_price" placeholder="请输入最终价格" :step="10" :min="0"
                    style="width: 100%;" @change="updatePriceClass" />
            </el-form-item>

            <el-form-item label="价格备注">
                <el-input v-model="deviceForm.remark" type="textarea" rows="3" placeholder="请输入定价理由或其他备注信息"
                    maxlength="200" show-word-limit />
            </el-form-item>
        </el-form>

        <template #footer>
            <span class="dialog-footer">
                <el-button @click="handleCancel">取消</el-button>
                <el-button type="primary" @click="handleConfirm" :disabled="!isFormValid">
                    确认定价
                </el-button>
            </span>
        </template>
    </el-dialog>
</template>

<script setup lang="ts">
import { ref, defineProps, defineEmits, watch, computed, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { ArrowRight } from '@element-plus/icons-vue'

// 定义设备信息接口
interface DeviceInfo {
    id?: string | number;
    model?: string;
    imei?: string;
    initial_price?: string | number;
    check_result?: string;
    final_price?: string | number;
    remark?: string;
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
const deviceForm = reactive<{
    final_price: number | undefined;
    remark: string;
}>({
    final_price: typeof props.device.final_price === 'number'
        ? props.device.final_price
        : typeof props.device.final_price === 'string'
            ? parseFloat(props.device.final_price) || undefined
            : undefined,
    remark: props.device.remark || ''
})

// 计算属性：判断表单是否有效
const isFormValid = computed(() => {
    return typeof deviceForm.final_price === 'number' && deviceForm.final_price >= 0
})

// 计算价格变化比较的样式类
const priceChangeClass = ref('')
const updatePriceClass = () => {
    const initialPrice = typeof deviceData.value.initial_price === 'string'
        ? parseFloat(deviceData.value.initial_price)
        : (deviceData.value.initial_price || 0)

    if (!deviceForm.final_price || initialPrice === 0) {
        priceChangeClass.value = ''
        return
    }

    if (deviceForm.final_price > initialPrice) {
        priceChangeClass.value = 'price-increase'
    } else if (deviceForm.final_price < initialPrice) {
        priceChangeClass.value = 'price-decrease'
    } else {
        priceChangeClass.value = ''
    }
}

// 监听visible属性变化
watch(() => props.visible, (newVal) => {
    dialogVisible.value = newVal
})

// 监听device属性变化
watch(() => props.device, (newVal) => {
    deviceData.value = { ...newVal }
    deviceForm.final_price = typeof newVal.final_price === 'number'
        ? newVal.final_price
        : typeof newVal.final_price === 'string'
            ? parseFloat(newVal.final_price) || undefined
            : undefined
    deviceForm.remark = newVal.remark || ''
    updatePriceClass()
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
const handleConfirm = () => {
    if (!isFormValid.value) {
        ElMessage.warning('请输入有效的价格')
        return
    }

    emit('confirm', {
        id: deviceData.value.id,
        final_price: deviceForm.final_price,
        remark: deviceForm.remark
    })
}
</script>

<style lang="scss" scoped>
.price-form-dialog {
    :deep(.el-dialog__body) {
        padding-top: 10px;
    }
}

.device-summary {
    background-color: #f9f9f9;
    border-radius: 8px;
    padding: 16px;
    margin-bottom: 16px;
}

.device-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;

    .model {
        font-size: 16px;
        font-weight: 600;
    }
}

.price-compare {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.price-item {
    flex: 1;
    text-align: center;
}

.price-divider {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 0 10px;
    color: #909399;
}

.price-label {
    font-size: 12px;
    color: #909399;
    margin-bottom: 4px;
}

.price-value {
    font-size: 18px;
    font-weight: 600;

    &.initial {
        color: #909399;
    }

    &.final {
        color: #67c23a;
    }

    &.price-increase {
        color: #67c23a;
    }

    &.price-decrease {
        color: #f56c6c;
    }
}

.price-form {
    margin-top: 16px;
}

.inspect-result {
    margin-bottom: 16px;

    :deep(.el-textarea__inner) {
        background-color: #f5f7fa;
        color: #606266;
    }
}

.dialog-footer {
    display: flex;
    justify-content: flex-end;
}
</style>