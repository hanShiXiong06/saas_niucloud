<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{ pageName }}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addPhoneShopRecycleOrder') }}
                </el-button>
            </div>


            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="phoneShopRecycleOrderTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('count')" prop="count">
                        <el-input v-model="phoneShopRecycleOrderTable.searchParam.count"
                            :placeholder="t('countPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('expressId')" prop="express_id">
                        <el-input v-model="phoneShopRecycleOrderTable.searchParam.express_id"
                            :placeholder="t('expressIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('sendUsername')" prop="send_username">
                        <el-input v-model="phoneShopRecycleOrderTable.searchParam.send_username"
                            :placeholder="t('sendUsernamePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('telphone')" prop="telphone">
                        <el-input v-model="phoneShopRecycleOrderTable.searchParam.telphone"
                            :placeholder="t('telphonePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('payType')" prop="pay_type">
                        <el-input v-model="phoneShopRecycleOrderTable.searchParam.pay_type"
                            :placeholder="t('payTypePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('account')" prop="account">
                        <el-input v-model="phoneShopRecycleOrderTable.searchParam.account"
                            :placeholder="t('accountPlaceholder')" />
                    </el-form-item>

                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="phoneShopRecycleOrderTable.searchParam.status" clearable
                            :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option v-for="(item, index) in statusList" :key="index" :label="item.name"
                                :value="item.value" />
                        </el-select>
                    </el-form-item>

                    <el-form-item :label="t('createAt')" prop="create_at">
                        <el-date-picker v-model="phoneShopRecycleOrderTable.searchParam.create_at" type="datetimerange"
                            format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item :label="t('overAt')" prop="over_at">
                        <el-date-picker v-model="phoneShopRecycleOrderTable.searchParam.over_at" type="datetimerange"
                            format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item :label="t('closeExpressId')" prop="close_express_id">
                        <el-input v-model="phoneShopRecycleOrderTable.searchParam.close_express_id"
                            :placeholder="t('closeExpressIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadPhoneShopRecycleOrderList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="phoneShopRecycleOrderTable.data" size="large"
                    v-loading="phoneShopRecycleOrderTable.loading">
                    <template #empty>
                        <span>{{ !phoneShopRecycleOrderTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="id" :label="t('id')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="count" :label="t('count')" min-width="120" :show-overflow-tooltip="true" />

                    <!-- <el-table-column prop="express_id" :label="t('expressId')" min-width="120"
                        :show-overflow-tooltip="true" /> -->

                    <el-table-column prop="send_username" :label="t('sendUsername')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="telphone" :label="t('telphone')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <!-- <el-table-column prop="pay_type" :label="t('payType')" min-width="120"
                        :show-overflow-tooltip="true" /> -->

                    <!-- <el-table-column prop="account" :label="t('account')" min-width="120"
                        :show-overflow-tooltip="true" /> -->

                    <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <div v-if="item.value == row.status">
                                    <el-tag v-show="row.status == 1"> {{ item.name }}</el-tag>
                                    <el-tag v-show="row.status == 2"> {{ item.name }}</el-tag>
                                    <el-tag v-show="row.status == 3"> {{ item.name }}</el-tag>
                                    <el-tag type='danger' v-show="row.status == 4"> {{ item.name }}</el-tag>
                                    <el-tag type='success' v-show="row.status == 5"> {{ item.name }}</el-tag>
                                </div>

                            </div>
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('createAt')" min-width="180" align="center"
                        :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            {{ row.create_at || '' }}
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('overAt')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            {{ row.over_at || '' }}
                        </template>
                    </el-table-column>

                    <!-- <el-table-column prop="close_express_id" :label="t('closeExpressId')" min-width="120"
                        :show-overflow-tooltip="true" /> -->

                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                            <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="phoneShopRecycleOrderTable.page"
                        v-model:page-size="phoneShopRecycleOrderTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="phoneShopRecycleOrderTable.total"
                        @size-change="loadPhoneShopRecycleOrderList()"
                        @current-change="loadPhoneShopRecycleOrderList" />
                </div>
            </div>

            <edit ref="editPhoneShopRecycleOrderDialog" @complete="loadPhoneShopRecycleOrderList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, onMounted } from 'vue'
import { t } from '@/lang'
import { getPhoneShopRecycleOrderList, getRecycleOrderStatusDict } from '../../api/phone_shop_recycle_order'

const pageName = '回收订单列表'

let phoneShopRecycleOrderTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "count": "",
        "express_id": "",
        "send_username": "",
        "telphone": "",
        "pay_type": "",
        "account": "",
        "status": "",
        "create_at": [],
        "over_at": "",
        "comment": "",
        "close_express_id": ""
    }
})

const searchFormRef = ref()

// 字典数据
const statusList = ref([] as any[])
const loadStatusDict = async () => {
    const res = await getRecycleOrderStatusDict()
    if (res.code === 0 && res.data) {
        statusList.value = Object.entries(res.data).map(([value, item]: [string, any]) => ({
            value: parseInt(value),
            name: item.name
        }))
    }
}

onMounted(() => {
    loadStatusDict()
    loadPhoneShopRecycleOrderList()
})

/**
 * 获取回收订单列表
 */
const loadPhoneShopRecycleOrderList = (page: number = 1) => {
    phoneShopRecycleOrderTable.loading = true
    phoneShopRecycleOrderTable.page = page

    getPhoneShopRecycleOrderList({
        page: phoneShopRecycleOrderTable.page,
        limit: phoneShopRecycleOrderTable.limit,
        ...phoneShopRecycleOrderTable.searchParam
    }).then(res => {
        phoneShopRecycleOrderTable.loading = false
        phoneShopRecycleOrderTable.data = res.data.data
        phoneShopRecycleOrderTable.total = res.data.total
    }).catch(() => {
        phoneShopRecycleOrderTable.loading = false
    })
}

const editPhoneShopRecycleOrderDialog: Record<string, any> | null = ref(null)

/**
 * 添加回收订单
 */
const addEvent = () => {
    editPhoneShopRecycleOrderDialog.value.setFormData()
    editPhoneShopRecycleOrderDialog.value.showDialog = true
}

/**
 * 编辑回收订单
 * @param data
 */
const editEvent = (data: any) => {
    editPhoneShopRecycleOrderDialog.value.setFormData(data)
    editPhoneShopRecycleOrderDialog.value.showDialog = true
}

/**
 * 删除回收订单
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('phoneShopRecycleOrderDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deletePhoneShopRecycleOrder(id).then(() => {
            loadPhoneShopRecycleOrderList()
        }).catch(() => {
        })
    })
}

const resetForm = (formEl: any) => {
    if (!formEl) return
    formEl.resetFields()
    loadPhoneShopRecycleOrderList()
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
