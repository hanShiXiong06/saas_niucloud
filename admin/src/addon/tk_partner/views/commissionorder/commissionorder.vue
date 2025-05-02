<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{ pageName }}</span>

            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="commissionOrderTable.searchParam" ref="searchFormRef">
                    <el-form-item label="会员" prop="member_id">
                        <el-select class="input-width" v-model="commissionOrderTable.searchParam.member_id" clearable
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

                    <el-form-item :label="t('orderId')" prop="order_id">
                        <el-input v-model="commissionOrderTable.searchParam.order_id"
                            :placeholder="t('orderIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="commissionOrderTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('type')" prop="type">
                        <el-input v-model="commissionOrderTable.searchParam.type" :placeholder="t('typePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('status')" prop="status">
                        <el-input v-model="commissionOrderTable.searchParam.status"
                            :placeholder="t('statusPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="commissionOrderTable.searchParam.create_time" type="datetimerange"
                            format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadCommissionOrderList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="commissionOrderTable.data" size="large" v-loading="commissionOrderTable.loading">
                    <template #empty>
                        <span>{{ !commissionOrderTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="order_id" :label="t('orderId')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="type_name" :label="t('type')" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag type="success">{{ row.type_name }}</el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column prop="m_commission" label="会员分润" min-width="120"
                    :show-overflow-tooltip="true" />

                    <el-table-column prop="commission" :label="t('commission')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="profit" :label="t('profit')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="order_money" :label="t('orderMoney')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="pid_name" :label="t('pid')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="status_name" :label="t('status')" min-width="120"
                        :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag type="success">{{ row.status_name }}</el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column prop="is_js" label="结算状态" min-width="120"
                        :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag type="success" v-if="row.is_js==1">已结算</el-tag>
                            <el-tag v-else>未结算</el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <!-- <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button> -->
                            <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="commissionOrderTable.page"
                        v-model:page-size="commissionOrderTable.limit" layout="total, sizes, prev, pager, next, jumper"
                        :total="commissionOrderTable.total" @size-change="loadCommissionOrderList()"
                        @current-change="loadCommissionOrderList" />
                </div>
            </div>

            <edit ref="editCommissionOrderDialog" @complete="loadCommissionOrderList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getCommissionOrderList, deleteCommissionOrder, getWithMemberList } from '@/addon/tk_partner/api/commissionorder'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance } from 'element-plus'
import Edit from '@/addon/tk_partner/views/commissionorder/components/commissionorder-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let commissionOrderTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "member_id": "",
        "order_id": "",
        "name": "",
        "type": "",
        "status": "",
        "create_time": []
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据


/**
 * 获取订单结算列表
 */
const loadCommissionOrderList = (page: number = 1) => {
    commissionOrderTable.loading = true
    commissionOrderTable.page = page

    getCommissionOrderList({
        page: commissionOrderTable.page,
        limit: commissionOrderTable.limit,
        ...commissionOrderTable.searchParam
    }).then(res => {
        commissionOrderTable.loading = false
        commissionOrderTable.data = res.data.data
        commissionOrderTable.total = res.data.total
    }).catch(() => {
        commissionOrderTable.loading = false
    })
}
loadCommissionOrderList()

const editCommissionOrderDialog: Record<string, any> | null = ref(null)

/**
 * 添加订单结算
 */
const addEvent = () => {
    editCommissionOrderDialog.value.setFormData()
    editCommissionOrderDialog.value.showDialog = true
}

/**
 * 编辑订单结算
 * @param data
 */
const editEvent = (data: any) => {
    editCommissionOrderDialog.value.setFormData(data)
    editCommissionOrderDialog.value.showDialog = true
}

/**
 * 删除订单结算
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('commissionOrderDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteCommissionOrder(id).then(() => {
            loadCommissionOrderList()
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
    loadCommissionOrderList()
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
