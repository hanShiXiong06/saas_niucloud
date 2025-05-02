<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-[20px]">{{pageName}}</span>
            </div> 
            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="siteAccountLogTable.searchParam" ref="searchFormRef">
                    <el-form-item label="订单分类" class="items-center">
						<el-select style="float:left;width:40%;" v-model="siteAccountLogTable.searchParam.search_type" class="m-2" placeholder="选择下单分类" >
							<el-option
								label="充值订单"
								value="1"
							/>
							<el-option 
								label="充值号码"
								value="2"
							/> 

						</el-select>
						<el-input style="width:50%" v-model="siteAccountLogTable.searchParam.order_sn" placeholder="输入搜索" />
					
                    </el-form-item> 
					<el-form-item label="下单时间" prop="create_time">
					    <el-date-picker v-model="siteAccountLogTable.searchParam.create_time" type="datetimerange" value-format="YYYY-MM-DD HH:mm:ss" start-placeholder="开始时间" end-placeholder="结束时间" />
					</el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadSiteAccountLogList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="siteAccountLogTable.data" size="large" v-loading="siteAccountLogTable.loading">
                    <template #empty>
                        <span>{{ !siteAccountLogTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="goods_name" label="商品名称" min-width="180" />
                    <el-table-column prop="rechargeno" label="充值号码" min-width="120" />
                    <el-table-column prop="orderid" label="订单号" min-width="180" />
                    <el-table-column prop="payprice" label="付款金额" min-width="120" >
                        <template #default="{ row }">
                            {{ row.payprice/100 || '' }}
                        </template>
                    </el-table-column>
                    <el-table-column prop="price" label="充值面额" min-width="120" >
                        <template #default="{ row }">
                            {{ row.price/100 || '' }}
                        </template>
                    </el-table-column>
                    <el-table-column prop="statusstr" label="状态" min-width="120" />
                    <el-table-column label="申请时间" min-width="150" align="center">
                        <template #default="{ row }">
                            {{ row.createdtime || '' }}
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="detailEvent(row)">查看</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="siteAccountLogTable.page" v-model:page-size="siteAccountLogTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="siteAccountLogTable.total"
                        @size-change="loadSiteAccountLogList()" @current-change="loadSiteAccountLogList" />
                </div>
            </div>
        </el-card>
		<el-dialog v-model="showDialog" title="订单详情" width="550px" :destroy-on-close="true">
		    <el-form :model="formData" label-width="110px" ref="formRef" class="page-form">
		 
				<el-form-item label="订单号" >
				<div class="input-width"> {{ formData.orderid }} </div>
				</el-form-item>
		    	<el-form-item label="商品名称" >
			    <div class="input-width"> {{ formData.goods_name }} </div>
				</el-form-item>
				<el-form-item label="充值号码" >
				<div class="input-width"> {{ formData.rechargeno }} </div>
				</el-form-item>
				<el-form-item label="数量" >
				<div class="input-width"> {{ formData.goods_num }} </div>
				</el-form-item>
				<el-form-item label="退款单号" v-if="formData.refundid">
				<div class="input-width"> {{ formData.refundid }} </div>
				</el-form-item>
				<el-form-item label="状态" >
				<div class="input-width"> {{ formData.statusstr }} </div>
				</el-form-item>
				<el-form-item label="佣金结算状态" >
				 <div class="input-width"> {{ formData.isbalance?'已结算':'未结算' }} </div>
				</el-form-item> 
				
				<el-form-item label="付款金额" >
				    <div class="input-width"> {{ formData.payprice/100 }} </div>
				</el-form-item>
				<el-form-item label="充值面额" >
				    <div class="input-width"> {{ formData.price/100 }} </div>
				</el-form-item>
				<el-form-item label="实际到到账面额" v-if="formData.real_num">
				    <div class="input-width"> {{ formData.real_num }} </div>
				</el-form-item>
				<el-form-item label="退款金额" v-if="formData.return_price">
				    <div class="input-width"> {{ formData.return_price/100 }} </div>
				</el-form-item>
				<el-form-item label="佣金" >
				    <div class="input-width"> {{ formData.commission/100 }} </div>
				</el-form-item>
				<el-form-item label="关闭时间" v-if="formData.closetime">
				    <div class="input-width"> {{ formData.closetime }} </div>
				</el-form-item>
				<el-form-item label="关闭原因" v-if="formData.closetxt">
				    <div class="input-width"> {{ formData.closetxt }} </div>
				</el-form-item>
				<el-form-item label="下单时间" >
				    <div class="input-width"> {{ formData.createdtime }} </div>
				</el-form-item>
				<el-form-item label="完成时间" v-if="formData.completetime" >
				    <div class="input-width"> {{ formData.completetime }} </div>
				</el-form-item>
				<el-form-item label="更新时间" >
				    <div class="input-width"> {{ formData.updatedtime }} </div>
				</el-form-item>
		
		    </el-form>
		
		    <template #footer>
		        <span class="dialog-footer">
		            <el-button type="primary" @click="showDialog = false">{{ t('confirm') }}</el-button>
		        </span>
		    </template>
		</el-dialog>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref } from 'vue'
import { t } from '@/lang'
import { getRechargeList } from '@/addon/cps/api/cps'
import { img } from '@/utils/common'
import type { FormInstance } from 'element-plus'
import { useRoute } from 'vue-router'

const route = useRoute()
const pageName = route.meta.title;

let siteAccountLogTable = reactive({
    page: 1,
    limit: 20,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
        search_type: '',
        order_sn: "",
        create_time: ""
    }
})

const searchFormRef = ref<FormInstance>()

/**
 * 获取列表
 */
const loadSiteAccountLogList = (page: number = 1) => {
    siteAccountLogTable.loading = true
    siteAccountLogTable.page = page

    getRechargeList({
        page: siteAccountLogTable.page,
        limit: siteAccountLogTable.limit,
         ...siteAccountLogTable.searchParam
    }).then(res => {
		console.log(res.data)
        siteAccountLogTable.loading = false
        siteAccountLogTable.data = res.data.data
        siteAccountLogTable.total = res.data.count
    }).catch(() => {
        siteAccountLogTable.loading = false
    })
}
loadSiteAccountLogList()



const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadSiteAccountLogList()
}
 
const showDialog = ref(false)
const formData = ref([]);
const detailEvent = (info) => {
	showDialog.value = true
	formData.value = info
} 
</script>

<style lang="scss" scoped></style>