<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="partnerOrderTable.searchParam" ref="searchFormRef">
                    
                    <el-form-item :label="t('memberId')" prop="member_id">
                        <el-select class="w-[280px]" v-model="partnerOrderTable.searchParam.member_id" clearable :placeholder="t('memberIdPlaceholder')">
                           <el-option
                                       v-for="(item, index) in memberIdList"
                                       :key="index"
                                       :label="item['nickname']"
                                       :value="item['member_id']"
                                   />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('orderId')" prop="order_id">
                        <el-input v-model="partnerOrderTable.searchParam.order_id" :placeholder="t('orderIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('orderStatus')" prop="order_status">
                        <el-input v-model="partnerOrderTable.searchParam.order_status" :placeholder="t('orderStatusPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="partnerOrderTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('levelId')" prop="level_id">
                        <el-select class="w-[280px]" v-model="partnerOrderTable.searchParam.level_id" clearable :placeholder="t('levelIdPlaceholder')">
                           <el-option
                                       v-for="(item, index) in levelIdList"
                                       :key="index"
                                       :label="item['name']"
                                       :value="item['id']"
                                   />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="partnerOrderTable.searchParam.create_time" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadPartnerOrderList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="partnerOrderTable.data" size="large" v-loading="partnerOrderTable.loading">
                    <template #empty>
                        <span>{{ !partnerOrderTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="order_from" :label="t('orderFrom')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="order_id" :label="t('orderId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="order_money" :label="t('orderMoney')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <!-- <el-table-column prop="order_discount_money" :label="t('orderDiscountMoney')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <el-table-column prop="order_status_name" :label="t('orderStatus')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <!-- <el-table-column prop="refund_status" :label="t('refundStatus')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="level_id_name" :label="t('levelId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <!-- <el-table-column prop="pid" :label="t('pid')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="type" :label="t('type')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <el-table-column prop="out_trade_no" :label="t('outTradeNo')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <!-- <el-table-column prop="remark" :label="t('remark')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="pay_time" :label="t('payTime')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="is_enable_refund" :label="t('isEnableRefund')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="close_time" :label="t('closeTime')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <!-- <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button> -->
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="partnerOrderTable.page" v-model:page-size="partnerOrderTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="partnerOrderTable.total"
                        @size-change="loadPartnerOrderList()" @current-change="loadPartnerOrderList" />
                </div>
            </div>

            <edit ref="editPartnerOrderDialog" @complete="loadPartnerOrderList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getPartnerOrderList, deletePartnerOrder, getWithMemberList, getWithLevelList } from '@/addon/tk_partner/api/partnerorder'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/tk_partner/views/partnerorder/components/partnerorder-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let partnerOrderTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "member_id":"",
      "order_id":"",
      "order_status":"",
      "name":"",
      "level_id":"",
      "create_time":[]
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取店主开通订单列表
 */
const loadPartnerOrderList = (page: number = 1) => {
    partnerOrderTable.loading = true
    partnerOrderTable.page = page

    getPartnerOrderList({
        page: partnerOrderTable.page,
        limit: partnerOrderTable.limit,
         ...partnerOrderTable.searchParam
    }).then(res => {
        partnerOrderTable.loading = false
        partnerOrderTable.data = res.data.data
        partnerOrderTable.total = res.data.total
    }).catch(() => {
        partnerOrderTable.loading = false
    })
}
loadPartnerOrderList()

const editPartnerOrderDialog: Record<string, any> | null = ref(null)

/**
 * 添加店主开通订单
 */
const addEvent = () => {
    editPartnerOrderDialog.value.setFormData()
    editPartnerOrderDialog.value.showDialog = true
}

/**
 * 编辑店主开通订单
 * @param data
 */
const editEvent = (data: any) => {
    editPartnerOrderDialog.value.setFormData(data)
    editPartnerOrderDialog.value.showDialog = true
}

/**
 * 删除店主开通订单
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('partnerOrderDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deletePartnerOrder(id).then(() => {
            loadPartnerOrderList()
        }).catch(() => {
        })
    })
}

    
    const memberIdList = ref([])
    const setMemberIdList = async () => {
    memberIdList.value = await (await getWithMemberList({})).data
    }
    setMemberIdList()
    const levelIdList = ref([])
    const setLevelIdList = async () => {
    levelIdList.value = await (await getWithLevelList({})).data
    }
    setLevelIdList()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadPartnerOrderList()
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
