<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{ pageName }}</span>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="orderTable.searchParam" ref="searchFormRef">

                    <el-form-item :label="t('memberId')" prop="member_id">
                        <el-select class="w-[280px]" v-model="orderTable.searchParam.member_id" clearable
                            :placeholder="t('memberIdPlaceholder')">
                            <el-option v-for="(item, index) in memberIdList" :key="index" :label="item['nickname']"
                                :value="item['member_id']" />
                        </el-select>
                    </el-form-item>

                    <el-form-item :label="t('sid')" prop="sid">
                        <el-input v-model="orderTable.searchParam.sid" :placeholder="t('sidPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('actName')" prop="actName">
                        <el-input v-model="orderTable.searchParam.actName" :placeholder="t('actNamePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('actType')" prop="actType">
                        <el-select v-model="orderTable.searchParam.actType" :placeholder="t('actTypePlaceholder')"
                            clearable>
                            <el-option v-for="(item, index) in actTypeList" :key="index" :label="item" :value="index" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('parentOrderId')" prop="parentOrderId">
                        <el-input v-model="orderTable.searchParam.parentOrderId"
                            :placeholder="t('parentOrderIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('status')" prop="status">
                        <el-select v-model="orderTable.searchParam.status" :placeholder="t('statusPlaceholder')"
                            clearable>
                            <el-option v-for="(item, index) in orderStatus" :key="index" :label="item" :value="index" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('xgzSettleStatus')" prop="xgzSettleStatus">
                        <el-select v-model="orderTable.searchParam.xgzSettleStatus"
                            :placeholder="t('xgzSettleStatusPlaceholder')" clearable>
                            <el-option label="已结算" value="1" />
                            <el-option label="未结算" value="0" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('isJs')" prop="is_js">
                        <el-select v-model="orderTable.searchParam.is_js" :placeholder="t('isJsPlaceholder')" clearable>
                            <el-option label="已结算" value="1" />
                            <el-option label="未结算" value="0" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="orderTable.searchParam.create_time" type="datetimerange"
                            format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadOrderList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="orderTable.data" size="large" v-loading="orderTable.loading" border stripe>
                    <template #empty>
                        <span>{{ !orderTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column label="推广产品" width="260" align="left">
                        <template #default="{ row }">
                            <div class="flex items-center">
                                <div class="font-medium text-blue-600">{{ row.orderTitle }}</div>
                            </div>
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('memberId')" min-width="160" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div class="flex flex-col gap-1">
                                <div class="flex items-center font-medium">
                                    <el-avatar :size="24" class="mr-2" icon="Avatar" />
                                    {{ row.member_id_name }}
                                </div>
                                <div class="text-gray-500 text-sm flex items-center">
                                    <el-tag size="small" effect="plain" class="mr-1">SID:</el-tag>
                                    {{ row.sid }}
                                </div>
                            </div>
                        </template>
                    </el-table-column>

                    <el-table-column prop="type_name" :label="t('actType')" min-width="120"
                        :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag type="info" effect="light">{{ row.type_name }}</el-tag>
                        </template>
                    </el-table-column>

                    <el-table-column prop="parentOrderId" :label="t('parentOrderId')" min-width="130"
                        :show-overflow-tooltip="true" />

                    <el-table-column :label="t('订单时间信息')" min-width="210">
                        <template #default="{ row }">
                            <div class="flex flex-col gap-1">
                                <div class="flex items-center text-sm">
                                    <el-icon class="mr-1">
                                        <Clock />
                                    </el-icon>
                                    <span class="font-medium mr-1">下单:</span>
                                    <span>{{ row.orderTime }}</span>
                                </div>
                                <div class="flex items-center text-sm text-gray-500">
                                    <el-icon class="mr-1">
                                        <EditPen />
                                    </el-icon>
                                    <span class="font-medium mr-1">更新:</span>
                                    <span>{{ row.modifiedTime }}</span>
                                </div>
                            </div>
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('结算信息')" min-width="220">
                        <template #default="{ row }">
                            <div class="flex flex-col gap-2">
                                <div class="flex items-center">
                                    <el-icon class="mr-1">
                                        <Money />
                                    </el-icon>
                                    <span class="font-medium mr-1">入账佣金:</span>
                                    <span class="text-orange-500 font-medium">￥{{ row.xgzShareFee }}</span>
                                </div>
                                <div class="flex items-center">
                                    <el-icon class="mr-1">
                                        <Coin />
                                    </el-icon>
                                    <span class="font-medium mr-1">推广佣金:</span>
                                    <span class="text-green-600 font-medium">￥{{ row.commission }}</span>
                                </div>
                                <div class="flex items-center">
                                    <span class="font-medium mr-1">入账时间:</span>
                                    <span class="text-gray-600">{{ row.xgzSettleTime || '-' }}</span>
                                </div>
                            </div>
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('状态信息')" min-width="180">
                        <template #default="{ row }">
                            <div class="flex flex-col gap-2">
                                <div>
                                    <span class="mr-2">订单状态:</span>
                                    <el-tag :type="row.status_name === '已完成' ? 'success' : 'warning'" effect="dark">
                                        {{ row.status_name }}
                                    </el-tag>
                                </div>
                                <div>
                                    <span class="mr-2">入账状态:</span>
                                    <el-tag :type="row.xgzSettleStatus === 1 ? 'success' : 'danger'">
                                        {{ row.xgzSettleStatus === 1 ? '已入账' : '未入账' }}
                                    </el-tag>
                                </div>
                                <div>
                                    <span class="mr-2">结算状态:</span>
                                    <el-tag :type="row.is_js === 1 ? 'success' : 'danger'">
                                        {{ row.is_js === 1 ? '已结算' : '未结算' }}
                                    </el-tag>
                                </div>
                            </div>
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <div class="flex space-x-2">
                                <el-button type="primary" link @click="editEvent(row)" v-if="row.is_js == 0">
                                    审核订单
                                </el-button>
                                <el-button type="primary" link @click="showOrderDetail(row)">
                                    详情
                                </el-button>
                                <el-button type="danger" link @click="deleteEvent(row.id)">
                                    {{ t('delete') }}
                                </el-button>
                            </div>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="orderTable.page" v-model:page-size="orderTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="orderTable.total"
                        @size-change="loadOrderList()" @current-change="loadOrderList" />
                </div>
            </div>

            <edit ref="editOrderDialog" @complete="loadOrderList" />
        </el-card>

        <!-- 右侧详情抽屉 -->
        <el-drawer v-model="drawerVisible" direction="rtl" size="650px" :destroy-on-close="false" :with-header="true"
            :show-close="true" :title="'订单详情'">
            <order-detail v-if="drawerVisible" :order-data="currentOrderDetail" @update:visible="drawerVisible = $event"
                @edit="handleDetailEdit" @settle="handleSettleOrder" />
        </el-drawer>
    </div>
</template>

<script lang="ts" setup>

import { ref, defineAsyncComponent, watch, reactive } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getOrderList, deleteOrder, getWithMemberList, getOrderInfo, getActType, getOrderStatus } from '@/addon/tk_cpa/api/order'
import { img } from '@/utils/common'
import { ElMessageBox, ElMessage, ElLoading, FormInstance } from 'element-plus'
import Edit from '@/addon/tk_cpa/views/order/components/order-edit.vue'
import OrderDetail from '@/addon/tk_cpa/views/order/components/order-detail.vue'
import { useRoute } from 'vue-router'
import { Clock, EditPen, Money, Coin } from '@element-plus/icons-vue'
const route = useRoute()
const pageName = route.meta.title;
const actTypeList = ref([])
const setActTypeList = async () => {
    actTypeList.value = await (await getActType()).data
}
setActTypeList()

const orderStatus = ref([])
const setOrderStatus = async () => {
    orderStatus.value = await (await getOrderStatus()).data
}
setOrderStatus()
let orderTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "member_id": "",
        "sid": "",
        "actName": "",
        "actType": "",
        "parentOrderId": "",
        "status": "",
        "xgzSettleStatus": "",
        "is_js": "",
        "create_time": []
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据


/**
 * 获取CPA订单列列表
 */
const loadOrderList = (page: number = 1) => {
    orderTable.loading = true
    orderTable.page = page

    getOrderList({
        page: orderTable.page,
        limit: orderTable.limit,
        ...orderTable.searchParam
    }).then(res => {
        orderTable.loading = false
        orderTable.data = res.data.data
        orderTable.total = res.data.total
    }).catch(() => {
        orderTable.loading = false
    })
}
loadOrderList()

const editOrderDialog: Record<string, any> | null = ref(null)

/**
 * 添加CPA订单列
 */
const addEvent = () => {
    editOrderDialog.value.setFormData()
    editOrderDialog.value.showDialog = true
}

/**
 * 编辑CPA订单列
 * @param data
 */
const editEvent = (data: any) => {
    editOrderDialog.value.setFormData(data)
    editOrderDialog.value.showDialog = true
}

/**
 * 删除CPA订单列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('orderDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteOrder(id).then(() => {
            loadOrderList()
        }).catch(() => {
        })
    })
}


const memberIdList = ref([])
const setMemberIdList = async () => {
    memberIdList.value = await (await getWithMemberList({})).data
}
setMemberIdList()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadOrderList()
}

// 抽屉控制
const drawerVisible = ref(false)
const currentOrderDetail = ref<any>(null)

/**
 * 显示订单详情
 * @param data 订单数据
 */
const showOrderDetail = (data: any) => {
    drawerVisible.value = true
    currentOrderDetail.value = data

    // 如果需要获取更详细的订单信息，可以发起API请求
    getOrderInfo(data.id).then((res: any) => {
        if (res.data) {
            currentOrderDetail.value = res.data
        }
    }).catch(() => {
        // 处理错误
    })
}

/**
 * 处理详情页面的编辑事件
 */
const handleDetailEdit = (data: any) => {
    editEvent(data)
}

/**
 * 处理订单结算
 */
const handleSettleOrder = (data: any) => {
    ElMessageBox.confirm('确认要结算此订单吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
    }).then(() => {
        // 这里添加结算API调用
        const loading = ElLoading.service({
            lock: true,
            text: '正在处理结算...',
            background: 'rgba(0, 0, 0, 0.7)',
        })

        // 模拟API调用
        setTimeout(() => {
            loading.close()
            ElMessage.success('订单结算成功')

            // 刷新订单列表和当前订单详情
            loadOrderList()
            showOrderDetail(data)
        }, 1000)
    }).catch(() => {
        // 取消操作
    })
}
</script>

<style lang="scss" scoped>
/* 多行超出隐藏 */
.multi-hidden {
    word-break: break-all;
    text-overflow: ellipsis;
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}

/* 抽屉自定义样式 */
:deep(.el-drawer__header) {
    margin-bottom: 0;
    padding: 16px 20px;
    border-bottom: 1px solid #e4e7ed;
}

:deep(.el-drawer__body) {
    padding: 0;
}
</style>
