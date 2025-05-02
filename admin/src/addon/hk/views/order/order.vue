<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div style="width: 100%" class="mb-2">
                <el-alert type="info" title="温馨提示：佣金指三方平台结算的佣金，分销佣金指当前订单一二级给推广会员的总佣金;同步订单状态可以更新最新订单状态，同步佣金状态可更新最新佣金状态"
                    show-icon />
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="orderTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('orderId')" prop="order_id">
                        <el-input v-model="orderTable.searchParam.order_id" :placeholder="t('orderIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item label="会员" prop="member_id">
                        <el-select class="input-width" v-model="orderTable.searchParam.member_id" clearable
                            :placeholder="t('memberIdPlaceholder')">
                            <div class="mt-2 mb-2 ml-4">
                                <el-input @change="change" v-model="keyword" style="width: 200px"
                                    placeholder="搜索会员支持昵称/会员名">
                                    <template #append>搜索 </template></el-input>
                            </div>
                            <el-option label="请选择" value=""></el-option>
                            <el-option v-for="(item, index) in memberIdList" :key="index" :label="item['nickname']"
                                :value="item['member_id']" />
                        </el-select>
                    </el-form-item>

                    <el-form-item label="产品名称" prop="name">
                        <el-input v-model="orderTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item label="是否结算" prop="is_js">
                        <el-input v-model="orderTable.searchParam.is_js" :placeholder="t('isJsPlaceholder')" />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadOrderList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="orderTable.data" size="large" v-loading="orderTable.loading">
                    <template #empty>
                        <span>{{ !orderTable.loading ? t('emptyData') : '' }}</span>
                    </template>

                    <el-table-column prop="order_id" label="基本信息" min-width="180" :show-overflow-tooltip="true">
                        <template #default="{ row }">

                            <div class="text-xs p-1">订单号:{{ row.order_id }}</div>
                            <div class="text-xs p-1">三方订单号:{{ row.orderno }}</div>
                            <el-tag class="p-1" type="info">{{ row.order_from }}</el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column prop="operator_name" label="号卡信息" min-width="180" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div class="flex items-center p-1">
                                <div>{{ row.name }}</div>
                                <div>-{{ row.mode_name }}</div>
                            </div>
                            <el-tag type="info">{{ row.operator_name }}</el-tag>
                            <div>{{ row.plan_phone }}</div>
                        </template>
                    </el-table-column>

                    <el-table-column prop="province" label="收货信息" min-width="240" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div class="text-xs">下单人:{{ row.member_id_name }}</div>
                            <div class="text-xs">联系人:{{ row.real_name }}</div>
                            <div class="text-xs">电话:{{ row.mobile }}</div>
                            <div class="flex flex-wrap text-xs">
                                地址: {{ row.province }}{{ row.city }}{{ row.district }}{{ row.address }}
                            </div>
                        </template>
                    </el-table-column>

                    <el-table-column prop="status_name" :label="t('status')" min-width="120"
                        :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag type="error" v-if="row.status == 5">{{ row.status_name }}</el-tag>
                            <el-tag type="success" v-else>{{ row.status_name }}</el-tag>
                        </template>
                    </el-table-column>

                    <el-table-column prop="is_activation" label="号卡状态" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div class="p-1">
                                <el-tag v-if="row.is_activation == 1">已激活</el-tag>
                                <el-tag type="info" v-else>未激活</el-tag>
                            </div>

                            <div class="p-1">
                                <el-tag v-if="row.is_first_charge == 1">已首充</el-tag>
                                <el-tag type="info" v-else>未首充</el-tag>
                            </div>
                            <div class="p-1" v-if="row.is_first_charge == 1">
                                首充:{{ row.first_charge_amount }}
                            </div>
                        </template>
                    </el-table-column>


                    <el-table-column prop="commission_status" label="佣金信息" min-width="160"
                        :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div class="p-1">
                                平台佣金:{{ row.commission }}
                            </div>
                            <div class="p-1">
                                一级佣金:{{ row.first_commission }}
                            </div>
                            <div class="p-1">
                                二级佣金:{{ row.two_commission }}
                            </div>
                            <div class="p-1">
                                平台结算：
                                <el-tag v-if="row.commission_status == 1" type="info">{{ row.commission_status_name
                                    }}</el-tag>
                                <el-tag v-else>{{ row.commission_status_name }}</el-tag>
                            </div>
                            <div class="p-1">
                                分销结算：
                                <el-tag v-if="row.is_js == 1">已结算</el-tag>
                                <el-tag type="info" v-else>未结算</el-tag>
                            </div>
                        </template>
                    </el-table-column>
                    <el-table-column prop="logistics_name" label="物流信息" min-width="180" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div>{{ row.logistics_name }}</div>
                            <div>{{ row.logisticsno }}</div>
                            <el-button v-if="row.logisticsno != ''" type="primary" link
                                @click="queryExpressEvent(row.id)">查询物流</el-button>
                        </template>
                    </el-table-column>
                    <el-table-column prop="msg" label="三方备注" min-width="120" :show-overflow-tooltip="true" />
                    <el-table-column :label="t('operation')" fixed="right" min-width="140">
                        <template #default="{ row }">
                            <div>
                                <el-button type="primary" v-if="row.orderno" link
                                    @click="queryOrderEvent(row.id)">同步订单状态</el-button>
                            </div>
                            <div>
                                <el-button type="primary" v-if="row.orderno" link
                                    @click="queryCommissionEvent(row.id)">同步佣金状态</el-button>
                            </div>
                            <div>
                                <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete')
                                    }}</el-button>
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
    </div>
    <el-dialog v-model="expressShowDialog" title="物流轨迹" width="50%" class="diy-dialog-wrap" destroy-on-close>
        <div v-if="express.length == 0">暂无轨迹</div>
        <el-timeline>
            <el-timeline-item v-for="(activity, index) in express" :key="index" :timestamp="activity.time">
                {{ activity.desc }}
            </el-timeline-item>
        </el-timeline>
    </el-dialog>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getOrderList, deleteOrder, getWithMemberList, queryOrder, queryCommission, queryExpress } from '@/addon/hk/api/order'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance } from 'element-plus'
import Edit from '@/addon/hk/views/order/components/order-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;
const express = ref()
const expressShowDialog = ref(false)
const queryExpressEvent = async (id) => {
    queryExpress(id).then((res) => {
        express.value = res.data
        expressShowDialog.value = true
    })
}

const queryOrderEvent = (e) => {
    queryOrder(e).then(res => {
        loadOrderList()
    })
}
const queryCommissionEvent = (e) => {
    queryCommission(e).then(res => {
        loadOrderList()
    })
}
let orderTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "order_id": "",
        "orderno": "",
        "member_id": "",
        "name": "",
        "status": "",
        "logisticsno": "",
        "msg": "",
        "operator_name": "",
        "is_activation": "",
        "is_js": "",
        "create_time": []
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据


/**
 * 获取号卡订单列表
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
 * 添加号卡订单
 */
const addEvent = () => {
    editOrderDialog.value.setFormData()
    editOrderDialog.value.showDialog = true
}

/**
 * 编辑号卡订单
 * @param data
 */
const editEvent = (data: any) => {
    editOrderDialog.value.setFormData(data)
    editOrderDialog.value.showDialog = true
}

/**
 * 删除号卡订单
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


const change = () => {
    setMemberIdList();
};
const keyword = ref();
const memberIdList = ref([]);
const setMemberIdList = async () => {
    memberIdList.value = await (
        await getWithMemberList({ keyword: keyword.value })
    ).data.data;
};
setMemberIdList();


const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadOrderList()
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
</style>
