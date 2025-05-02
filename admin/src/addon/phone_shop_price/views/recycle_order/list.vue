<template>
    <div class="recycle-order-list h-full">
        <el-card class="box-card !border-none h-full relative" shadow="never">
            <div class="flex justify-between items-center">


                <!-- 搜索表单 -->
                <el-form :inline="true" :model="searchForm" class="mb-4">
                    <el-form-item>
                        <el-input v-model="searchForm.search" placeholder="订单号/快递单号" clearable />
                    </el-form-item>
                    <el-form-item>
                        <el-select v-model="searchForm.status" placeholder="订单状态" clearable>
                            <el-option v-for="(status, key) in orderStatusMap" :key="key" :label="status.name"
                                :value="status.status" />
                        </el-select>
                    </el-form-item>
                    <el-form-item>
                        <el-select v-model="searchForm.delivery_type" placeholder="配送方式" clearable>
                            <el-option label="快递" value="1" />
                            <el-option label="自送" value="2" />
                        </el-select>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="getList(1)">搜索</el-button>
                        <el-button @click="resetSearch">重置</el-button>
                    </el-form-item>
                </el-form>

                <div class="btn-wrap">
                    <el-button type="success" @click="showAddOrderDialog">代下单</el-button>
                </div>
            </div>



            <el-tabs v-model="activeTab" @tab-click="handleTabClick">
                <el-tab-pane label="全部" name=""></el-tab-pane>
                <el-tab-pane v-for='(item, key) in orderStatusMap' :label="item.name" :name="item.status"></el-tab-pane>
            </el-tabs>

            <!-- 列表 -->
            <el-table ref="orderTable" v-loading="loading" :data="list" :expand-row-keys="expandedRows.value"
                row-key="id" style="width: 100%" @expand-change="handleExpandChange">
                <el-table-column type="expand">
                    <template #default="{ row }">

                        <el-table :data="row.devices" border
                            @selection-change="(val) => handleDeviceSelectionChange(val, row.id)">
                            <el-table-column type="selection" width="55" />
                            <el-table-column prop="model" label="设备型号" />
                            <el-table-column prop="imei" label="IMEI" />
                            <el-table-column prop="initial_price" label="预估价格" />
                            <el-table-column prop="final_price" label="最终价格" />
                            <el-table-column prop="status_name" label="状态" />
                            <el-table-column label="操作" min-width="180">
                                <template #default="{ row }">
                                    <el-button type="primary"
                                        v-if="row.status === 1 && findOrderStatus(row.order_id) > 1" link
                                        @click="checkDevice(row)">验机</el-button>

                                    <el-button v-if="row.status == 2 || row.status == 3" type="primary" link
                                        @click="priceDevice(row)">定价</el-button>

                                    <el-button v-if="row.status == 4" type="primary" size="small"
                                        @click="batchRecycleDevice(row.id)">
                                        确认
                                    </el-button>
                                    <el-button v-if="row.status == 4" type="danger" size="small"
                                        @click="batchReturnDevice(row.id)">
                                        拒绝
                                    </el-button>
                                    <el-button type="link" @click="viewDetail(row)" size="small"> 查看详情 </el-button>


                                </template>
                            </el-table-column>
                        </el-table>

                        <!-- 批量操作按钮 -->
                        <div class="flex justify-end mt-2" v-if="selectedDevices[row.id] && row.status == 4">
                            <el-button-group>
                                <el-button type="primary" size="small" @click="batchRecycleDevices(row.id)">
                                    批量确认
                                </el-button>
                                <!-- <el-button type="danger" size="small" @click="batchReturnDevices(row.id)" >
                                    批量拒绝
                                </el-button> -->
                            </el-button-group>
                        </div>
                    </template>
                </el-table-column>


                <el-table-column label="订单信息" min-width="200">
                    <template #default="{ row }">
                        <div class="flex flex-col gap-1">
                            <div>订单号：{{ row.id }}</div>
                            <div>配送方式：{{ row.delivery_type_name }}</div>
                            <div v-if="row.delivery_type === '1'">
                                快递单号：{{ row.express_no || '暂无' }}
                            </div>
                        </div>
                    </template>
                </el-table-column>

                <el-table-column label="用户信息" min-width="150">
                    <template #default="{ row }">
                        <div class="flex flex-col gap-1">
                            <div>{{ row.member?.nickname || '未知用户' }}</div>
                            <div>{{ row.member?.mobile || '暂无联系方式' }}</div>
                        </div>
                    </template>
                </el-table-column>

                <el-table-column label="设备数量" width="100">
                    <template #default="{ row }">
                        {{ getDeviceCount(row.devices) }}台
                    </template>
                </el-table-column>

                <el-table-column label="状态" width="120">
                    <template #default="{ row }">
                        <el-tag :type="getStatusType(row.status)">
                            {{ row.status_name }}
                        </el-tag>
                    </template>
                </el-table-column>

                <el-table-column prop="create_at" label="创建时间" width="180" />

                <el-table-column label="操作" width="200" fixed="right">
                    <template #default="{ row }">

                        <el-button-group>
                            <el-button v-for="action in orderStatusMap[row.status]?.action" :key="action" size="small"
                                type="primary" @click="handleAction(row, action)">
                                {{ action.value }}
                            </el-button>
                        </el-button-group>
                    </template>
                </el-table-column>
            </el-table>

            <!-- 分页 -->
            <div class="flex justify-end mt-4">
                <el-pagination v-model:current-page="pagination.page" :page-sizes="[10, 20, 50, 100]"
                    :total="pagination.total" :hide-on-single-page="true" @size-change="handleSizeChange"
                    @current-change="handleCurrentChange" />
            </div>
        </el-card>

        <!-- 使用代下单弹窗组件 -->
        <AddOrderDialog v-model:visible="addOrderDialogVisible" @success="handleAddOrderSuccess" />


        <!-- 设备信息确认对话框组件 -->
        <DeviceConfirmDialog v-model:visible="orderDialogVisible" :device-list="currentDevices"
            :order-id="currentOrderId" @confirm="handleDeviceConfirm" @add-device="addDevice" @edit-device="editDevice"
            @remove-device="removeDevice" @cancel="cancelDeviceEdit" />

        <!-- 添加新的质检对话框组件 -->
        <CheckDeviceDialog v-model:visible="checkDeviceLogVisible" :device="checkDeviceLogForm"
            @confirm="submitDeviceCheck" />

        <PriceFormDialog v-model:visible="priceDeviceLogVisible" :device="checkDeviceLogForm"
            @confirm="submitDevicePrice" />

        <!-- 使用设备详情对话框组件 -->
        <DeviceDetailDialog v-model:visible="deviceLogVisible" :device="deviceDetailData"
            @closed="handleDeviceDetailClosed" />

        <!-- 订单详情 -->
        <OrderDetailDialog v-model:visible="orderDetailVisible" :order-detail="orderDetail" />
        <!-- 支付方式 -->
        <PaymentMethodDialog v-model:visible="paymentDialogVisible" :payment-info="paymentInfo"
            @payment-confirmed="handlePaymentConfirm" />
    </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, nextTick, watch, computed } from 'vue'
import { ElMessage, ElMessageBox, ElLoading } from 'element-plus'
import { Edit, Delete } from '@element-plus/icons-vue'
import { usePageState } from '../../hooks/usePageState'


import {
    getRecycleOrderList,
    getRecycleOrderStatusList,
    updateRecycleOrder,
    getRecycleOrderInfo,
    // 定价
    confirmPrice,
    getDevice,
    updateDevice,
    getMerchantPayInfo,
    paymentConfirm,
    batchRecycleDevices as apiBatchRecycleDevices,
    batchReturnDevices as apiBatchReturnDevices,
    deleteRecycleOrder,
    deleteRecycleDevice
} from '@/addon/phone_shop_price/api/recycle_order'

// 导入代下单弹窗组件
import AddOrderDialog from './components/AddOrderDialog.vue'
// 导入设备列表弹窗组件
// import DeviceListDialog from './components/DeviceListDialog.vue'
// 导入设备详情弹窗组件
// import DeviceDetailDialog from './components/DeviceDetailDialog.vue'
// 导入新的支付方式对话框组件
import PaymentMethodDialog from './components/PaymentMethodDialog.vue'
// 导入订单详情弹窗组件
import OrderDetailDialog from './components/OrderDetailDialog.vue'
// 导入定价表单组件
import PriceFormDialog from './components/PriceFormDialog.vue'
import CheckDeviceDialog from './components/CheckDeviceDialog.vue'
// 导入设备确认对话框组件
import DeviceConfirmDialog from './components/DeviceConfirmDialog.vue'
// 导入设备详情对话框组件
import DeviceDetailDialog from './components/DeviceDetailDialog.vue'

// 引入图片预览工具
import { img, debounce } from '@/utils/common'

// 状态定义
interface OrderStatus {
    name: string;
    status: number;
    action: string[];
}

// 订单列表项定义
interface OrderItem {
    id: number;
    status: number;
    status_name: string;
    delivery_type: string;
    delivery_type_name: string;
    express_no: string;
    create_at: string;
    update_at: string;
    devices: any[];
    member: {
        member_id: number;
        nickname: string;
        mobile: string;
        headimg: string;
    };
}

// 分页参数
interface Pagination {
    page: number;
    limit: number;
    total: number;
}

// 定义订单详情类型
interface OrderDetail {
    id: number | string;
    status: number;
    status_name: string;
    customer_name?: string;
    customer_phone?: string;
    pay_type?: string;
    total_amount?: number | string;
    delivery_type_name?: string;
    express_company?: string;
    express_no?: string;
    device_count?: number;
    pay_time?: number;
    create_at?: string;
    update_at?: string;
    remark?: string;
    member?: {
        member_id: number | string;
        username?: string;
        nickname?: string;
        mobile?: string;
    };
    devices?: any[];
    [key: string]: any;
}

// 状态管理
const orderStatusMap = ref<Record<string, OrderStatus>>({})
const loading = ref(false)
const list = ref<OrderItem[]>([])

// 分页
const {
    expandedRows,
    pagination,
    setExpandedRows,
    setPagination,
    applyExpandedRows
} = usePageState('recycle_order_list')

const orderDialogVisible = ref(false)
const paymentDialogVisible = ref(false)
const currentOrderId = ref<number | string>(0)
const currentDevices = ref<any[]>([])
const orderDetailVisible = ref(false)
const orderDetail = ref<OrderDetail | null>(null)
const originalDevices = ref<any[]>([])
const paymentInfo = ref<any[]>([])
const selectedPayTypeIndex = ref(0)

// 设备管理相关
const openDeviceDialog = async (orderId: number | string) => {
    currentOrderId.value = orderId

    try {
        const res = await getRecycleOrderInfo(orderId)
        if (res.code === 1) {
            // 将设备列表数据标记为非编辑状态
            currentDevices.value = res.data.devices.map((device: any) => ({
                ...device,
                editing: false
            }))
            originalDevices.value = JSON.parse(JSON.stringify(currentDevices.value))
            orderDialogVisible.value = true
        } else {
            ElMessage.error(res.message || '获取订单信息失败')
        }
    } catch (error: any) {
        console.error('获取订单信息失败：', error)
        ElMessage.error('获取订单信息失败：' + (error.message || '未知错误'))
    }
}

// 添加设备
const addDevice = () => {
    // 添加一个新设备到列表中
    currentDevices.value.push({
        imei: '',
        model: '',
        initial_price: 0,
        editing: true
    })
}

// 编辑设备
const editDevice = (row: any) => {
    // 查找设备并设置为编辑状态
    const index = currentDevices.value.findIndex(item => item === row || item.id === row.id)
    if (index !== -1) {
        currentDevices.value[index].editing = true
    }
}

// 删除设备
const removeDevice = async (row: any) => {
    try {
        // 如果设备有ID，则需要确认删除并调用API
        if (row.id) {
            await ElMessageBox.confirm('确定要删除该设备吗？', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            })
            await deleteRecycleDevice(row.id)
            ElMessage.success('删除成功')
        }

        // 从当前设备列表中移除
        currentDevices.value = currentDevices.value.filter(item => item !== row && item.id !== row.id)
    } catch (error: any) {
        if (error === 'cancel') return
        console.error('删除设备失败：', error)
        ElMessage.error('删除失败：' + (error.message || '未知错误'))
    }
}

// 取消设备编辑
const cancelDeviceEdit = () => {
    orderDialogVisible.value = false
    // 清空当前设备列表
    currentDevices.value = []
    currentOrderId.value = 0
}

// 搜索表单
const searchForm = reactive({
    search: '',
    status: '',
    delivery_type: '',
    date_range: []
})

// 获取状态列表
const loadStatusList = async () => {
    try {
        const res = await getRecycleOrderStatusList()
        if (res.code === 1) {
            orderStatusMap.value = res.data
        }
    } catch (error) {
        console.error('获取状态列表失败:', error)
    }
}

// 表格ref
const orderTable = ref(null)

// 获取列表数据
const getList = async (page = 1) => {
    loading.value = true
    try {
        const params = {
            page: page,
            page_size: pagination.limit,
            ...searchForm
        }

        const res = await getRecycleOrderList(params)
        console.log('API响应数据:', res) // 调试日志，查看返回的数据结构

        // 根据实际API返回结构调整
        if (res.data.data) {
            list.value = res.data.data
        } else if (res.data.list) {
            list.value = res.data.list
        } else {
            list.value = []
            console.error('API返回的数据结构不符合预期:', res.data)
        }

        // 更新分页信息，但不触发额外的请求
        setPagination({
            total: res.data.total || res.data.count || 0,
            page: page
        })

        // 不需要手动展开行了，因为我们使用了:expand-row-keys绑定
    } catch (error) {
        console.error('获取列表失败:', error)
        ElMessage.error('获取列表失败')
    } finally {
        loading.value = false
    }
}

const handleSizeChange = (val: number) => {
    // 更新分页大小
    setPagination({
        limit: val,
        page: 1 // 切换每页显示数量时，重置为第一页
    })
    getList(1)
}

const handleCurrentChange = (val: number) => {
    // 更新页码
    setPagination({
        page: val
    })
    getList(val)
}

// 状态标签类型
const getStatusType = (status: number): string => {
    const typeMap: Record<number, string> = {
        1: 'warning',   // 待签收
        2: 'info',      // 已签收
        3: 'primary',   // 质检中
        4: 'success',   // 已质检
        5: 'warning',   // 待确认
        6: 'primary',   // 待打款
        7: 'success',   // 已完成
        8: 'info',      // 已关闭
        9: 'danger',    // 已取消
        10: 'danger'    // 已删除
    }
    return typeMap[status] || 'info'
}

// 处理订单操作
const handleAction = async (row, action) => {
    try {
        // 根据操作类型执行不同的操作
        if (action.key === 'order_cancel') {
            // 取消订单
            await ElMessageBox.confirm('确定要取消该订单吗？', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            })

            // 使用action.key作为操作标识
            await updateRecycleOrder(row.id, { action: 'order_cancel' })
            ElMessage.success('订单已取消')
            await getList() // 刷新列表
        } else if (action.key === 'order_delete') {
            // 删除订单
            await ElMessageBox.confirm('确定要删除该订单吗？', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            })
            await deleteRecycleOrder(row.id)
            ElMessage.success('订单已删除')
            await getList() // 刷新列表
        } else if (action.key === 'order_complete') {
            // 完成订单
            await ElMessageBox.confirm('确定要完成该订单吗？', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            })

            // 使用action.key作为操作标识
            await updateRecycleOrder(row.id, { action: 'order_complete' })
            ElMessage.success('操作成功，订单已完成')
            await getList() // 刷新列表
        } else if (action.key === 'order_sign') {
            // 签收订单
            currentOrderId.value = row.id
            currentDevices.value = row.devices || []
            orderDialogVisible.value = true
        } else if (action.key === 'order_check') {
            // 质检订单
            currentOrderId.value = row.id
            currentDevices.value = row.devices || []
            checkDeviceLogVisible.value = true
        } else if (action.key === 'order_price') {
            // 定价订单
            currentOrderId.value = row.id
            currentDevices.value = row.devices || []
            priceDeviceLogVisible.value = true
        } else if (action.key == 'order_payment') {
            // 确认打款 前 将用户的收款方式 弹出来 展示给财务看 , 财务打完款后 点击确定按钮 , 完成打款
            // row.member_id 需携带

            paymentDialogVisible.value = true;

            const res = await getMerchantPayInfo(row.member_id);
            if (res.data && Array.isArray(res.data)) {
                // 获取当前订单的总数据
                const order = list.value.find(item => item.id === row.id)

                // 计算退回的设备数量
                let returnedDeviceCount = 0;
                if (order && order.devices && Array.isArray(order.devices)) {
                    returnedDeviceCount = order.devices.filter(device => device.status === 6).length;
                }
                // 计算已质检的设备数量
                let checkedDeviceCount = 0;
                if (order && order.devices && Array.isArray(order.devices)) {
                    checkedDeviceCount = order.devices.filter(device => device.status >= 4).length;
                }

                // 计算已确认的设备数量
                let confirmedDeviceCount = 0;
                if (order && order.devices && Array.isArray(order.devices)) {
                    confirmedDeviceCount = order.devices.filter(device => device.status >= 5).length;
                }
                // 计算成功回收的设备数量
                let successDeviceCount = 0;
                if (order && order.devices && Array.isArray(order.devices)) {
                    successDeviceCount = order.devices.filter(device => device.status == 5).length;
                }

                // 计算所有设备 并且同意回收的 最终价格 
                let finalPrice = 0;
                if (order && order.devices && Array.isArray(order.devices)) {


                    finalPrice = order.devices.filter(device => device.status == 5).reduce((sum, device) => sum + (+device.final_price), 0);
                }

                // 准备订单摘要信息
                const orderSummary = {
                    order_id: order ? order.id : row.id,
                    delivery_type: order ? order.delivery_type_text : '',
                    device_count: order && order.devices ? order.devices.length : 0,
                    confirmed_count: confirmedDeviceCount,
                    checked_count: checkedDeviceCount,
                    success_count: successDeviceCount,
                    returned_count: returnedDeviceCount,
                    price_per_device: order ? order.price_per_device : 0,
                    total_amount: order ? finalPrice : 0,
                    customer_name: order ? order.member.nickname : '',
                    customer_mobile: order ? order.member.mobile : '',
                    delivery_type_name: order ? order.delivery_type_name : '',
                    // 添加设备详情列表
                    devices: order && order.devices ? order.devices.map(device => ({
                        id: device.id,
                        model: device.model,
                        imei: device.imei,
                        final_price: device.final_price || 0,
                        status: device.status,
                        status_name: device.status_name || ''
                    })) : []
                };

                // 将订单摘要信息添加到每个支付方式中
                const paymentInfoWithOrder = res.data.map(item => {
                    return {
                        ...item,
                        order_summary: orderSummary
                    };
                });

                paymentInfo.value = paymentInfoWithOrder;

                // 默认选中第一个
                selectedPayTypeIndex.value = paymentInfoWithOrder.length > 0 ? 0 : -1;
            } else {
                paymentInfo.value = [];
            }
        } else if (action.key == 'order_detail') {
            // 查看详情
            const order = list.value.find(item => item.id === row.id)

            if (order) {
                orderDetail.value = order as OrderDetail
                orderDetailVisible.value = true
            } else {
                ElMessage.warning('未找到订单信息')
            }
        } else {
            // 其他操作 - 使用action.key作为操作标识
            await updateRecycleOrder(row.id, { action: action.key })
            ElMessage.success('操作成功')
            await getList() // 刷新列表
        }
    } catch (error) {
        console.error('操作失败：', error)
        ElMessage.error(error.message || '操作失败')
    }
}

// 获取设备数量
const getDeviceCount = (devices: any[]) => {
    if (!devices) return 0
    return devices.length
}

// 重置搜索
const resetSearch = () => {
    searchForm.search = ''
    searchForm.status = ''
    searchForm.delivery_type = ''
    searchForm.date_range = []
    activeTab.value = 'all'
    getList(1)
}

// 获取订单状态
const findOrderStatus = (orderId: number) => {
    const order = list.value.find(item => item.id === orderId)
    return order ? order.status : 0
}

// 表单数据
const checkDeviceLogForm = ref({
    id: 0,
    imei: '',
    model: '',
    initial_price: '',
    check_result: '',
    check_images: '',
    remark: '',
    status: 0,
    final_price: '',
    check_status: 0
})

// 表单验证规则
const checkDeviceLogRules = {
    check_result: [
        { required: true, message: '请输入质检结果', trigger: 'blur' }
    ]
}

//checkDevice
const checkDeviceLogVisible = ref(false)
const priceDeviceLogVisible = ref(false)
const priceForm = ref({}) // 添加空的priceForm对象

//editDevice
const checkDevice = async (row: any) => {
    // 查找当前设备所属的订单
    const orderId = row.order_id
    // 在list中查找对应的订单
    const order = list.value.find(item => item.id === orderId)

    // 如果订单状态是待签收(1)，则提示用户先签收订单
    if (order && order.status === 1) {
        ElMessage.warning('请先签收订单后再进行质检')
        return
    }

    checkDeviceLogVisible.value = true
    const res = await getDevice(row.id)
    if (res.code === 1) {
        checkDeviceLogForm.value = {
            id: res.data.id,
            imei: res.data.imei,
            model: res.data.model,
            initial_price: res.data.initial_price,
            check_result: res.data.check_result || '',
            check_images: res.data.check_images || '',
            final_price: res.data.final_price || '',
            remark: res.data.remark || '',
            status: res.data.status,
            check_status: res.data.check_status
        }
    }
}

const priceDevice = async (row: any) => {
    try {
        const res = await getDevice(row.id)
        if (res.code === 1) {
            checkDeviceLogForm.value = {
                id: res.data.id,
                imei: res.data.imei,
                model: res.data.model,
                initial_price: res.data.initial_price,
                check_result: res.data.check_result || '',
                check_images: res.data.check_images || '',
                final_price: res.data.final_price || '',
                remark: res.data.remark || '',
                status: res.data.status,
                check_status: res.data.check_status
            }
            priceDeviceLogVisible.value = true
        }
    } catch (error) {
        console.error('获取设备信息失败:', error)
        ElMessage.error('获取设备信息失败')
    }
}

// 提交设备质检
const submitDeviceCheck = async (formData) => {

    try {
        // 验证数据是否完整
        if (!formData.check_result) {
            ElMessage.warning('请填写质检结果')
            return
        }

        await updateDevice(formData.id, {
            check_result: formData.check_result,
            check_images: formData.check_images,
            remark: formData.remark,
            check_status: 1, // 已质检
            final_price: formData.final_price,
            action: 'check' // 添加操作类型，表示这是质检操作
        })

        ElMessage.success('质检信息提交成功')
        checkDeviceLogVisible.value = false
        await getList() // 刷新列表
    } catch (error) {
        console.error('提交质检信息失败：', error)
        // 显示后端返回的具体错误信息
        ElMessage.error(error.response?.data?.message || '提交失败，请重试')
    }
}

// 提交设备定价
const submitDevicePrice = async (formData) => {
    try {
        // 验证价格是否有效
        if (!formData || !formData.final_price || formData.final_price <= 0) {
            ElMessage.warning('请输入有效的价格')
            return
        }

        // 提交数据
        await confirmPrice(formData.id, {
            final_price: formData.final_price,
            remark: formData.remark
        })

        ElMessage.success('定价信息提交成功')
        priceDeviceLogVisible.value = false
        await getList() // 刷新列表
    } catch (error) {
        console.error('提交定价信息失败：', error)
        ElMessage.error('提交失败，请重试')
    }
}

// 设备多选
const selectedDevices = ref({})

// 设备多选变化事件
const handleDeviceSelectionChange = (val, orderId) => {
    selectedDevices.value[orderId] = val
}

// 单个确认 
const batchRecycleDevice = async (deviceId) => {
    if (!deviceId) {
        ElMessage.warning('请选择设备')
    }
    console.log(deviceId);

    try {
        await apiBatchRecycleDevices({ ids: deviceId + '', remark: "" })
        getList()
    } catch (error) {
        ElMessage.error('确认失败')
    }

}
// 单个拒绝
const batchReturnDevice = async (deviceId) => {
    if (!deviceId) {
        ElMessage.warning('请选择设备')
        return
    }

    try {
        // 合并确认和输入原因到一个弹窗
        const { value: remark } = await ElMessageBox.prompt(
            '确定要拒绝回收该设备吗？将创建退货订单处理该设备。\n请输入拒绝回收原因：',
            '拒绝回收确认',
            {
                confirmButtonText: '确定拒绝',
                cancelButtonText: '取消',
                type: 'warning',
                inputPlaceholder: '请输入拒绝回收原因'
            }
        )

        const loading = ElLoading.service({
            lock: true,
            text: '正在处理...',
            background: 'rgba(0, 0, 0, 0.7)'
        })
        console.log(deviceId, remark);

         await apiBatchReturnDevices({ ids: deviceId + '', remark: remark || '商户拒绝回收' })
        loading.close()
        ElMessage.success('拒绝成功，已创建退货订单')
        getList() // 刷新列表
    } catch (error) {
        if (error === 'cancel') return // 用户取消操作
        console.error('拒绝失败:', error)
        // ElMessage.error('拒绝失败: ' + (error.message || '未知错误'))
    }
}



// 批量确认设备
const batchRecycleDevices = async (orderId) => {

    try {
        const selectedDeviceIds = selectedDevices.value[orderId].map(device => device.id)
        if (selectedDeviceIds.length === 0) {
            ElMessage.warning('请选择设备')
            return
        }

        // 弹出输入备注的对话框
        const { value: remark } = await ElMessageBox.prompt('请输入操作备注', '批量确认设备', {
            confirmButtonText: '确认',
            cancelButtonText: '取消',
            inputPlaceholder: '请输入备注信息（可选）'
        })

        await apiBatchRecycleDevices({
            ids: selectedDeviceIds.join(','),
            remark: remark || ''
        })
        ElMessage.success('批量确认成功')
        await getList() // 刷新列表
    } catch (error) {
        if (error !== 'cancel') {
            console.error('批量确认失败：', error)
            ElMessage.error('批量确认失败')
        }
    }
}

// 批量拒绝设备
const batchReturnDevices = async (orderId) => {
    try {
        const selectedDeviceIds = selectedDevices.value[orderId].map(device => device.id)
        if (selectedDeviceIds.length === 0) {
            ElMessage.warning('请选择设备')
            return
        }

        // 合并确认和输入原因到一个弹窗
        const { value: remark } = await ElMessageBox.prompt(
            `确定要拒绝回收已选择的 ${selectedDeviceIds.length} 台设备吗？将创建退货订单处理这些设备。\n请输入拒绝回收原因：`,
            '批量拒绝回收确认',
            {
                confirmButtonText: '确定拒绝',
                cancelButtonText: '取消',
                type: 'warning',
                inputPlaceholder: '请输入拒绝回收原因'
            }
        )

        const loading = ElLoading.service({
            lock: true,
            text: '正在处理...',
            background: 'rgba(0, 0, 0, 0.7)'
        })

        await apiBatchReturnDevices({
            ids: selectedDeviceIds.join(','),
            remark: remark || '商户批量拒绝回收'
        })

        loading.close()
        ElMessage.success('批量拒绝成功，已创建退货订单')
        await getList() // 刷新列表
    } catch (error) {
        if (error === 'cancel') return // 用户取消操作
        console.error('批量拒绝失败:', error)
        ElMessage.error('批量拒绝失败: ' + (error.message || '未知错误'))
    }
}

// 表格展开/折叠事件
const handleExpandChange = (row, expanded) => {
    console.log('行展开状态变化:', row.id, expanded)

    if (expanded) {
        // 如果是展开操作，添加到展开行列表
        if (!expandedRows.value.includes(row.id)) {
            expandedRows.value.push(row.id)
            console.log('添加展开行:', row.id, expandedRows.value)
        }
    } else {
        // 如果是折叠操作，从展开行列表中移除
        const index = expandedRows.value.indexOf(row.id)
        if (index !== -1) {
            expandedRows.value.splice(index, 1)
            console.log('移除展开行:', row.id, expandedRows.value)
        }
    }

    // 保存展开状态
    setExpandedRows(expandedRows.value)
}

const deviceLogVisible = ref(false)
const deviceInfo = ref({})

// viewDetail
const viewDetail = async (row) => {
    console.log('查看详情:', row)
    // 直接通过 getDevice 获取设备信息
    try {
        const data = await getDevice(row.id)
        if (data.code !== 1) {
            ElMessage.error(data.msg || '获取设备详情失败')
            return
        }
        deviceDetailData.value = data.data
        deviceLogVisible.value = true
    } catch (error) {
        console.error('获取设备详情失败:', error)
        ElMessage.error('获取设备详情失败')
    }
}

// 代下单相关
const addOrderDialogVisible = ref(false)

// 显示代下单弹窗
const showAddOrderDialog = () => {
    addOrderDialogVisible.value = true
}

// 处理代下单成功
const handleAddOrderSuccess = async () => {
    // 刷新列表
    await getList()
}

// 页面加载
onMounted(async () => {
    await loadStatusList()
    // 使用保存的页码获取数据
    await getList(pagination.page)
})



// 计算属性：获取当前选中的收款方式信息
const currentPaymentInfo = computed(() => {
    if (paymentInfo.value && paymentInfo.value.length > 0 &&
        selectedPayTypeIndex.value >= 0 &&
        selectedPayTypeIndex.value < paymentInfo.value.length) {
        return paymentInfo.value[selectedPayTypeIndex.value]
    }
    return null
})

// tab切换
const activeTab = ref('')
const handleTabClick = (tab) => {

    // 根据tab的name值进行筛选
    // 如果 
    searchForm.status = tab.props.name
    // 重新获取列表数据
    getList()
}

// 处理支付确认
const handlePaymentConfirm = async (paymentData) => {
    try {
        // 调用确认打款API
        await paymentConfirm(paymentData.orderId, {
            pay_type: paymentData.payType,
            remark: '财务已确认打款'
        });

        ElMessage.success('确认打款成功');
        paymentDialogVisible.value = false;

        // 刷新订单列表
        await getList();
    } catch (error) {
        console.error('确认打款失败', error);
        ElMessage.error('确认打款失败');
    }
}

// 设备详情弹窗相关
const deviceDetailData = ref(null)

// 处理设备详情关闭
const handleDeviceDetailClosed = () => {
    deviceDetailData.value = null
}

// 处理设备确认提交
const handleDeviceConfirm = async (data: { orderId: number | string; devices: any[] }) => {
    try {
        const loading = ElLoading.service({
            lock: true,
            text: '正在保存...',
            background: 'rgba(0, 0, 0, 0.7)'
        })

        // 提交设备信息
        const result = await updateRecycleOrder(data.orderId, {
            action: 'order_sign',
            devices: data.devices.map(device => ({
                id: device.id,
                imei: device.imei,
                model: device.model,
                initial_price: device.initial_price
            }))
        })

        if (result.code !== 1) {
            throw new Error(result.message || '操作失败')
        }

        ElMessage.success('订单签收成功')
        orderDialogVisible.value = false
        await getList() // 刷新列表

        loading.close()
    } catch (error: any) {
        console.error('保存设备信息失败：', error)
        ElMessage.error(error.message || '保存失败')
    }
}

// 处理质检图片数组
const checkImagesArray = computed(() => {
    if (!deviceInfo.value?.data?.check_images) return []
    return deviceInfo.value.data.check_images.split(',').filter(url => url)
})

// 预览图片
const previewImage = (url) => {
    img(url)
}
</script>

<style lang="scss" scoped>
.recycle-order-list {
    .el-card {
        height: 100%;
        display: flex;
        flex-direction: column;
    }

    :deep(.el-card__body) {
        flex: 1;
        overflow: auto;
        padding: 20px;
    }

    :deep(.el-table__expanded-cell) {
        padding: 20px !important;
    }
}

.recycle-order-list {
    .el-card {
        height: 100%;
        display: flex;
        flex-direction: column;
    }

    :deep(.el-card__body) {
        flex: 1;
        overflow: auto;
        padding: 20px;
    }

    :deep(.el-table__expanded-cell) {
        padding: 20px !important;
    }
}

.device-detail {
    padding: 0 10px;

    .detail-section {
        margin-bottom: 20px;
        border-bottom: 1px solid #ebeef5;
        padding-bottom: 15px;

        &:last-child {
            border-bottom: none;
        }

        .section-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 12px;
            color: #303133;
            position: relative;
            padding-left: 10px;

            &::before {
                content: '';
                position: absolute;
                left: 0;
                top: 50%;
                transform: translateY(-50%);
                width: 4px;
                height: 16px;
                background-color: #409EFF;
                border-radius: 2px;
            }
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;

            .info-item {
                display: flex;
                align-items: flex-start;

                &.full-width {
                    grid-column: span 2;
                }

                .label {
                    width: 80px;
                    color: #606266;
                    font-size: 14px;
                }

                .value {
                    flex: 1;
                    color: #303133;
                    font-size: 14px;
                    word-break: break-all;

                    &.price {
                        color: #f56c6c;
                        font-weight: 500;
                    }

                    &.highlight {
                        font-size: 16px;
                        font-weight: bold;
                    }
                }

                .status-tag {
                    padding: 2px 8px;
                    border-radius: 4px;
                    font-size: 12px;

                    &.status-1 {
                        background-color: #e6f7ff;
                        color: #1890ff;
                    }

                    &.status-2 {
                        background-color: #fff7e6;
                        color: #fa8c16;
                    }

                    &.status-3 {
                        background-color: #f6ffed;
                        color: #52c41a;
                    }

                    &.status-4 {
                        background-color: #e6fffb;
                        color: #13c2c2;
                    }

                    &.status-5 {
                        background-color: #f9f0ff;
                        color: #722ed1;
                    }

                    &.status-6 {
                        background-color: #fff1f0;
                        color: #f5222d;
                    }
                }
            }
        }

        .check-images {
            margin-top: 15px;

            h4 {
                font-size: 14px;
                margin-bottom: 10px;
                font-weight: 500;
            }

            .image-list {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;

                :deep(.el-image) {
                    width: 80px;
                    height: 80px;
                    border-radius: 4px;
                    cursor: pointer;
                    border: 1px solid #ebeef5;
                    transition: all 0.3s;

                    &:hover {
                        transform: scale(1.05);
                        box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
                    }
                }
            }
        }

        .remark-content {
            padding: 10px;
            background-color: #f5f7fa;
            border-radius: 4px;
            color: #606266;
            min-height: 40px;
        }
    }
}

.empty-data {
    padding: 30px 0;
}

/* 代下单相关样式 */
.user-info {
    display: grid;
    grid-template-columns: 1fr;
    gap: 10px;
}

.user-info div {
    padding: 5px 0;
}

.search-results {
    max-height: 300px;
    overflow-y: auto;
}

.order-info ol {
    padding-left: 20px;
    margin-top: 5px;
    margin-bottom: 0;
}

.order-info p {
    margin-bottom: 5px;
}
</style>