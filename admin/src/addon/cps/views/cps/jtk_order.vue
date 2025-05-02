<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-[20px]">{{pageName}}</span>
            </div> 
            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="siteAccountLogTable.searchParam" ref="searchFormRef">
                    <el-form-item label="订单分类" class="items-center">
						<el-select v-model="siteAccountLogTable.searchParam.act_id" class="m-2" placeholder="选择下单分类" >
							<el-option
								v-for="(item, index) in accountType"
								:key="index"
								:label="item"
								:value="index"
							/>
						</el-select>
                    </el-form-item>
                    <el-form-item label="订单号" prop="order_sn">
                        <el-input v-model="siteAccountLogTable.searchParam.order_sn" placeholder="输入订单号搜索" />
                    </el-form-item>
					<el-form-item label="下单时间" prop="create_time">
					    <el-date-picker v-model="siteAccountLogTable.searchParam.create_time" @change="change_date()" type="datetimerange" value-format="YYYY-MM-DD HH:mm:ss" start-placeholder="开始时间" end-placeholder="结束时间" />
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
                    <el-table-column prop="order_title" label="商品名称" min-width="180" />
                    <el-table-column prop="act_name" label="平台名称" min-width="120" />
                    <el-table-column prop="order_sn" label="订单号" min-width="180" />
                    <el-table-column prop="pay_price" label="付款金额" min-width="120" />
                    <el-table-column prop="jtk_share_fee" label="佣金奖励" min-width="120" />
                    <el-table-column prop="status_desc" label="状态" min-width="120" />
                    <el-table-column label="下单时间" min-width="150" align="center">
                        <template #default="{ row }">
                            {{ row.create_time || '' }}
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
		 
				<el-form-item label="商品名称" >
				    <div class="input-width"> {{ formData.order_title }} </div>
				</el-form-item>
				<el-form-item label="平台名称" >
				    <div class="input-width"> {{ formData.act_name }} </div>
				</el-form-item>
				<el-form-item label="订单号" >
				    <div class="input-width"> {{ formData.order_sn }} </div>
				</el-form-item>
				<el-form-item label="付款金额" >
				    <div class="input-width"> {{ formData.pay_price }} </div>
				</el-form-item>
				<el-form-item label="佣金奖励" >
				    <div class="input-width"> {{ formData.jtk_share_fee }} </div>
				</el-form-item>
				<el-form-item label="佣金结算状态" >
				    <div class="input-width"> {{ formData.status_desc }} </div>
				</el-form-item>
				<el-form-item label="下单时间" >
				    <div class="input-width"> {{ formData.create_time }} </div>
				</el-form-item> 
				
				<el-form-item label="付款时间" >
				    <div class="input-width"> {{ formData.pay_time }} </div>
				</el-form-item>
				<el-form-item label="完成时间" >
				    <div class="input-width"> {{ formData.modified_time }} </div>
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
import { getJtkList, getJtkType } from '@/addon/cps/api/cps'
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
        act_id: '',
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

    getJtkList({
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

const accountType = ref([])
const checkAccountType = () => {
	getJtkType().then(res=>{
		accountType.value = res.data
	})
}
checkAccountType()
const showDialog = ref(false)
const formData = ref([]);
const detailEvent = (info) => {
	showDialog.value = true
	formData.value = info
} 
</script>

<style lang="scss" scoped></style>