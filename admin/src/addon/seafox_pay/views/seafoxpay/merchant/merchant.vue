<template>
    <div class="main-container">
        <!-- 添加商户按钮 -->
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-page-title">{{ pageName }}</span>
                <el-button type="primary" @click="handleChange">
                    添加商户
                </el-button>
            </div>

             <!-- 搜索 -->
            <el-card class="box-card !border-none my-[20px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="tableData.searchParam" ref="searchFormRef">
                    <el-form-item label="商户名称" prop="title">
                        <el-input v-model.trim="tableData.searchParam.title" placeholder="请输入商户名称" />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadMerchantList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

             <!-- 列表 -->
            <div class="mt-[10px]">
                <el-table :data="tableData.data" size="large" v-loading="tableData.loading">
                    <template #empty>
                        <span>{{ !tableData.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="id" label="商户ID" min-width="80" />
					<el-table-column prop="name" label="商户名称" min-width="130" />
                    <el-table-column prop="mch_id" label="商户号" min-width="130" />
                    <el-table-column prop="logo" label="门店LOGO" min-width="130" >
                        <template #default="{ row }">
                            <el-image style="height: 50px;width: 50px;" :src="img(row.logo)"></el-image>
                        </template>
                    </el-table-column>
                    <el-table-column prop="addtime" label="添加时间" min-width="130" />
                    <el-table-column :label="t('operation')" fixed="right" align="right" min-width="280">
                       <template #default="{ row }">
                            <el-button type="primary"  @click="partEvent('/seafoxpay/fenzhang/set',row)" style="background: #409dfd;border-color: #409dfd">分账</el-button>
                            <el-button type="primary"  @click="partEvent('/seafoxpay/maidan/order',row)" style="background: #409dfd;border-color: #409dfd">当面付</el-button>
                           
                            <el-button type="primary"  @click="partEvent('/seafoxpay/part/incoming_parts',row)" style="background: #409dfd;border-color: #409dfd">进件</el-button>
                            <el-button type="primary"  @click="otherop(row)" style="background: #00c4a0;border-color: #00c4a0">其他操作</el-button>
                          <!-- <el-button type="primary" link @click="partEvent('/seafoxpay/part/aliSubMerchantUpdate',row)">二级商户修改（支）</el-button>
                            <el-button type="primary" link @click="partEvent('/seafoxpay/part/appapplyquery',row)">app报备查询</el-button>
                            <el-button type="primary" link @click="partEvent('/seafoxpay/part/bindorauth',row)">代运营授权绑定</el-button>
                            <el-button type="primary" link @click="partEvent('/seafoxpay/part/cardalteration',row)">结算卡信息变更</el-button>
                            <el-button type="primary" link @click="partEvent('/seafoxpay/part/modifyMerchantInfo',row)">商户信息修改</el-button>
                            <el-button type="primary" link @click="partEvent('/seafoxpay/part/modifyProductConfig',row)">产品手续费收取方式</el-button>
                            <el-button type="primary" link @click="partEvent('/seafoxpay/part/activityApplyUrl',row)">活动报名资质</el-button>
                            <el-button type="primary" link @click="partEvent('/seafoxpay/part/activityApply',row)">活动报名</el-button>
                            <el-button type="primary" link @click="partEvent('/seafoxpay/part/activityApplyQuery',row)">活动报名查询</el-button> -->
							 <el-button type="primary"  @click="editChange(row)" style="background: #55aaff;border-color: #55aaff">编辑</el-button>
                            <el-button type="danger"  @click="deleteEvent(row)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="tableData.page" v-model:page-size="tableData.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="tableData.total"
                        @size-change="loadMerchantList()" @current-change="loadMerchantList" />
                </div>
            </div>
        </el-card>
		
		
		 <el-dialog
		    v-model="dialogVisible"
		    title="其他操作"
		    width="700"
		  >
		   <div>
			   <div class="lefttitle">商户信息修改</div>
			   <div>
				   <el-button type="primary"  class="opbtn opbtn1" @click="partEvent('/seafoxpay/part/aliSubMerchantUpdate',rowData.value)" >二级商户修改（支）</el-button>
				 <el-button type="primary" class="opbtn opbtn1"  @click="partEvent('/seafoxpay/part/modifyMerchantInfo',rowData.value)">商户信息修改</el-button>
				   
			   </div>
			   <div class="lefttitle">查询绑定</div>
			   <div>
			   		<el-button type="primary"  class="opbtn opbtn2" @click="partEvent('/seafoxpay/part/appapplyquery',rowData.value)">App报备查询</el-button>
			   		<el-button type="primary" class="opbtn opbtn2"  @click="partEvent('/seafoxpay/part/bindorauth',rowData.value)">代运营授权绑定</el-button>
			   		<el-button type="primary" class="opbtn opbtn2"  @click="partEvent('/seafoxpay/part/cardalteration',rowData.value)">结算卡信息变更</el-button>
			   		
			   		<el-button type="primary" class="opbtn opbtn2"  @click="partEvent('/seafoxpay/part/modifyProductConfig',rowData.value)">产品手续费收取方式</el-button>	 			   
			   </div>
			   <div class="lefttitle">活动相关</div>
			   <div>
			   		<el-button type="primary" class="opbtn opbtn3" @click="partEvent('/seafoxpay/part/activityApplyUrl',rowData.value)">活动报名资质</el-button>
			   		<el-button type="primary" class="opbtn opbtn3" @click="partEvent('/seafoxpay/part/activityApply',rowData.value)">活动报名</el-button>
			   		<el-button type="primary" class="opbtn opbtn3" @click="partEvent('/seafoxpay/part/activityApplyQuery',rowData.value)">活动报名查询</el-button>
			   </div>
		   </div>
		    
		  </el-dialog>
		  
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getMerchantList, deleteMerchant  } from '@/addon/seafox_pay/api/merchant'
import { ElMessageBox, FormInstance } from 'element-plus'
import { t } from '@/lang'
import { img } from '@/utils/common'

const router = useRouter()
const route = useRoute()
const pageName = route.meta.title

// 表单内容
const tableData = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        title: ''
    }
})

const searchFormRef = ref<FormInstance>()

const loadMerchantList = (page: number = 1) => {
    tableData.loading = true
    tableData.page = page

    getMerchantList({
        page: tableData.page,
        limit: tableData.limit,
        ...tableData.searchParam
    }).then(res => {
        console.log(res,'resresresres');
        
        tableData.loading = false
        tableData.data = res.data.lists
        tableData.total = res.data.count
    }).catch(() => {
        tableData.loading = false
    })
}
loadMerchantList()

// 添加商户
const handleChange = () => {
    router.push('/seafoxpay/merchant/merchant_add')
}
// 编辑商户
// const editEvent = (data: any) => {
//     router.push('/seafoxpay/merchant/merchant_edit?id=' + data.id)
// }

const partEvent = (path: any ,row :any) =>{
    localStorage.setItem('seafoxpay_sid',row.id)
    router.push(path)
}
const editChange = (row :any) => {
	localStorage.setItem('seafoxpay_row',JSON.stringify(row))
    router.push('/seafoxpay/merchant/merchant_add?merchant_id='+row.id)
}

/**
 * 删除
 */
const deleteEvent = (data: any) => {
    ElMessageBox.confirm('删除该商户', t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning'
        }
    ).then(() => {
        deleteMerchant({id :data.id}).then(() => {
            loadMerchantList()
        }).catch(() => {
        })
    })
}

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadMerchantList()
}

// 其他操作
const dialogVisible = ref(false)

const rowData = reactive<any>({});
const otherop = (row :any) =>{
	rowData.value = row;
   dialogVisible.value = true;
   // console.log('rowData',rowData.value.name);
}


const handleClose = (done: () => void) => {
  ElMessageBox.confirm('Are you sure to close this dialog?')
    .then(() => {
      done()
    })
    .catch(() => {
      // catch error
    })
}

</script>

<style lang="scss" scoped>
	.lefttitle{
		font-weight: bold;margin:20px 0 10px;padding-left: 10px;border-left: 3px solid #3e9efb;
	}
	.opbtn{
		margin: 0 10px 10px;
	}
	.opbtn1{
		background: #3e9efb;border-color: #3e9efb;
	}
	.opbtn2{
		background: #00c59f;border-color: #00c59f;
	}
	.opbtn3{
		background: #fe9d2c;border-color: #fe9d2c;
	}
	@media screen and (min-width: 220px) and (max-width: 600px) {
	  ::v-deep .el-dialog {
	    width: 95% !important;
	  }
	}
</style>
