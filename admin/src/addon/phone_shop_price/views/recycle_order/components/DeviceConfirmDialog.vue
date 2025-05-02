<template>
    <el-dialog v-model="dialogVisible" title="设备信息确认" width="800" center>
        <template #header>
            <div class="flex justify-between items-center">
                <span class="text-lg font-bold">设备信息确认 , 共 {{ devices.length }} 台 </span>
                <el-button type="primary" @click="handleAddDevice">添加设备</el-button>
            </div>
        </template>

        <el-table :data="devices" border v-loading="loading">
            <el-table-column label="IMEI">
                <template #default="{ row }">
                    <div v-if="row.editing">
                        <el-input v-model="row.imei" placeholder="请输入IMEI" />
                    </div>
                    <span v-else>{{ row.imei }}</span>
                </template>
            </el-table-column>
            <el-table-column label="型号">
                <template #default="{ row }">
                    <div v-if="row.editing">
                        <el-input v-model="row.model" placeholder="请输入型号" />
                    </div>
                    <span v-else>{{ row.model }}</span>
                </template>
            </el-table-column>
            <el-table-column label="预估价格">
                <template #default="{ row }">
                    <div v-if="row.editing">
                        <el-input-number v-model="row.initial_price" :min="0" :step="10" />
                    </div>
                    <span v-else>{{ row.initial_price }}</span>
                </template>
            </el-table-column>
            <el-table-column label="操作" width="160">
                <template #default="{ row, $index }">
                    <div v-if="row.editing">
                        <el-button-group>
                            <el-button type="success" size="small" @click="saveDevice(row, $index)">
                                保存
                            </el-button>
                            <el-button type="info" size="small" @click="cancelEdit(row, $index)">
                                取消
                            </el-button>
                        </el-button-group>
                    </div>
                    <el-button-group v-else>
                        <el-button type="primary" size="small" :icon="Edit" @click="handleEditDevice(row, $index)">
                            编辑
                        </el-button>
                        <el-button type="danger" size="small" :icon="Delete" @click="handleRemoveDevice(row, $index)">
                            删除
                        </el-button>
                    </el-button-group>
                </template>
            </el-table-column>
        </el-table>

        <div v-if="devices.length === 0" class="empty-data">
            <el-empty description="暂无设备数据" />
        </div>

        <template #footer>
            <div class="dialog-footer">
                <el-button @click="handleCancel">取消</el-button>
                <el-button type="primary" @click="handleConfirm" :loading="submitting">
                    确认并签收
                </el-button>
            </div>
        </template>
    </el-dialog>
</template>

<script setup lang="ts">
import { ref, defineProps, defineEmits, watch, toRaw, nextTick } from 'vue'
import { Edit, Delete } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'

// 定义设备信息接口
interface Device {
    id?: string | number;
    imei: string;
    model: string;
    initial_price: number;
    editing: boolean;
    isNew?: boolean;
    _originalData?: any; // 用于存储编辑前的原始数据
    [key: string]: any;
}

const props = defineProps({
    visible: {
        type: Boolean,
        default: false
    },
    deviceList: {
        type: Array as () => Device[],
        default: () => []
    },
    orderId: {
        type: [Number, String],
        required: true
    }
})

const emit = defineEmits([
    'update:visible',
    'confirm',
    'cancel',
    'add-device',
    'edit-device',
    'remove-device'
])

// 内部状态
const dialogVisible = ref(props.visible)
const devices = ref<Device[]>([])
const loading = ref(false)
const submitting = ref(false)
// 保存原始设备列表，用于取消操作
const originalDeviceList = ref<Device[]>([])

// 监听visible属性变化
watch(() => props.visible, (newVal) => {
    dialogVisible.value = newVal
    // 当对话框打开时，复制一份设备列表数据以避免直接修改props
    if (newVal) {
        syncDeviceData()
    }
})

// 监听deviceList属性变化
watch(() => props.deviceList, () => {
    // 仅当对话框可见时且原始列表为空时更新内部设备列表
    // 这样可以确保仅在第一次加载时同步数据，之后由组件内部维护
    if (dialogVisible.value && devices.value.length === 0) {
        syncDeviceData()
    }
}, { deep: true })

// 同步设备数据的方法
const syncDeviceData = () => {
    try {
        const devicesCopy = JSON.parse(JSON.stringify(props.deviceList || []))
        devices.value = devicesCopy.map((device: Device) => ({
            ...device,
            editing: false, // 确保所有设备初始时不在编辑状态
            _originalData: null // 清空原始数据
        }))
        // 保存一份原始数据，用于取消操作
        originalDeviceList.value = JSON.parse(JSON.stringify(devices.value))
    } catch (error) {
        console.error('设备数据同步失败:', error)
        devices.value = []
        originalDeviceList.value = []
    }
}

// 监听内部visible状态变化，同步到父组件
watch(dialogVisible, (newVal) => {
    emit('update:visible', newVal)
})

// 添加设备
const handleAddDevice = () => {
    // 检查是否有未保存的编辑中设备
    const editingDevice = devices.value.find(d => d.editing)
    if (editingDevice) {
        ElMessage.warning('请先保存正在编辑的设备')
        return
    }

    // 添加一个新的设备到内部列表，并设置为编辑状态
    const newDevice = {
        imei: '',
        model: '',
        initial_price: 0,
        editing: true,
        isNew: true
    }

    devices.value.push(newDevice)

    // 通知父组件（可选，取决于是否需要父组件知道添加了设备）
    emit('add-device')
}

// 编辑设备
const handleEditDevice = (row: Device, index: number) => {
    // 检查是否有其他正在编辑的设备
    const editingDevice = devices.value.find(d => d.editing)
    if (editingDevice) {
        ElMessage.warning('请先保存正在编辑的设备')
        return
    }

    // 保存原始数据，用于取消编辑
    devices.value[index]._originalData = JSON.parse(JSON.stringify(row))

    // 设置编辑状态
    devices.value[index].editing = true

    // 通知父组件（可选）
    emit('edit-device', row)
}

// 保存设备编辑
const saveDevice = (row: Device, index: number) => {
    // 验证设备信息
    if (!row.imei || !row.model) {
        ElMessage.warning('IMEI和型号不能为空')
        return
    }

    // 关闭编辑状态
    devices.value[index].editing = false
    // 清除原始数据
    devices.value[index]._originalData = null

    ElMessage.success('设备信息已保存')
}

// 取消编辑
const cancelEdit = (row: Device, index: number) => {
    if (row.isNew) {
        // 如果是新增的设备，直接从列表中移除
        devices.value.splice(index, 1)
    } else if (row._originalData) {
        // 如果是编辑现有设备，恢复原始数据
        const { editing, _originalData, ...originalProps } = row._originalData
        Object.assign(devices.value[index], originalProps)
        devices.value[index].editing = false
        devices.value[index]._originalData = null
    } else {
        // 直接关闭编辑状态
        devices.value[index].editing = false
    }
}

// 删除设备
const handleRemoveDevice = async (row: Device, index: number) => {
    try {
        // 弹出确认对话框
        await ElMessageBox.confirm('确定要删除该设备吗？', '提示', {
            type: 'warning'
        })

        // 如果设备已有ID，可以通知父组件进行API删除（可选）
        if (row.id) {
            emit('remove-device', row)
        }

        // 从本地列表中删除
        devices.value.splice(index, 1)

        ElMessage.success('设备已删除')
    } catch (error) {
        // 用户取消删除
        if (error === 'cancel') return
        console.error('删除设备失败:', error)
    }
}

// 处理取消操作
const handleCancel = () => {
    // 检查是否有未保存的更改
    const hasUnsavedChanges = devices.value.some(d => d.editing) ||
        JSON.stringify(devices.value) !== JSON.stringify(originalDeviceList.value)

    if (hasUnsavedChanges) {
        ElMessageBox.confirm('有未保存的更改，确定要取消吗？', '提示', {
            type: 'warning'
        }).then(() => {
            dialogVisible.value = false
            emit('cancel')
        }).catch(() => {
            // 用户取消关闭对话框，不做任何操作
        })
    } else {
        dialogVisible.value = false
        emit('cancel')
    }
}

// 处理确认操作
const handleConfirm = async () => {
    // 检查是否有正在编辑的设备
    const editingDevice = devices.value.find(d => d.editing)
    if (editingDevice) {
        ElMessage.warning('请先保存或取消正在编辑的设备')
        return
    }

    // 验证设备数据的完整性
    const invalidDevice = devices.value.find(device => !device.imei || !device.model)
    if (invalidDevice) {
        ElMessage.warning('请填写完整的设备信息（IMEI和型号）')
        return
    }

    submitting.value = true
    try {
        // 提交前去除编辑状态标志和内部临时属性
        const finalDevices = devices.value.map(device => {
            const rawDevice = toRaw(device)
            const { editing, _originalData, isNew, ...rest } = rawDevice
            return rest
        })

        emit('confirm', {
            orderId: props.orderId,
            devices: finalDevices
        })
    } catch (error) {
        console.error('确认提交失败:', error)
        ElMessage.error('提交失败，请重试')
    } finally {
        submitting.value = false
    }
}
</script>

<style lang="scss" scoped>
.dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    padding-top: 20px;
}

.empty-data {
    display: flex;
    justify-content: center;
    padding: 30px 0;
}
</style>