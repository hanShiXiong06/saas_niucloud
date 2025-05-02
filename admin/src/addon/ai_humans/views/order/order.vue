<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>

            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="orderTable.searchParam" ref="searchFormRef">
                    
                           
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
                    
                    
                    <el-form-item :label="t('orderId')" prop="order_id">
                        <el-input v-model="orderTable.searchParam.order_id" :placeholder="t('orderIdPlaceholder')" />
                    </el-form-item>
                    <!-- <el-form-item :label="t('orderStatus')" prop="order_status">
                        <el-input v-model="orderTable.searchParam.order_status" :placeholder="t('orderStatusPlaceholder')" />
                    </el-form-item> -->
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="orderTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <!-- <el-form-item :label="t('type')" prop="type">
                        <el-input v-model="orderTable.searchParam.type" :placeholder="t('typePlaceholder')" />
                    </el-form-item> -->
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
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
               
                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="order_from" :label="t('orderFrom')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="order_id" :label="t('orderId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="order_money" :label="t('orderMoney')" min-width="120" :show-overflow-tooltip="true"/>
                    
                     
                    <el-table-column prop="status_name" :label="t('orderStatus')" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.order_status == -1" type="error">已关闭</el-tag>
                            <el-tag v-else type="primary">{{row.status_name}}</el-tag>
                        </template>
                    </el-table-column>

                  
                      
                    <el-table-column prop="type" :label="t('type')" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.type == 'package'" type="success">充值</el-tag>
                            <el-tag v-else type="danger">分销</el-tag>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="point" :label="t('point')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="out_trade_no" :label="t('outTradeNo')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="remark" :label="t('remark')" min-width="120" :show-overflow-tooltip="true"/>
                   

                    
                    <el-table-column prop="close_time" :label="t('closeTime')" min-width="120" :show-overflow-tooltip="true"/>
                    
                     <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                      
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
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
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getOrderList, deleteOrder, getWithMemberList } from '@/addon/ai_humans/api/order'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/ai_humans/views/order/components/order-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let orderTable = reactive({
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
      "type":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取订单列列表
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
 * 添加订单列
 */
const addEvent = () => {
    editOrderDialog.value.setFormData()
    editOrderDialog.value.showDialog = true
}

/**
 * 编辑订单列
 * @param data
 */
const editEvent = (data: any) => {
    editOrderDialog.value.setFormData(data)
    editOrderDialog.value.showDialog = true
}

/**
 * 删除订单列
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
