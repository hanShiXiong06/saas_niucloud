<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addRunningOrderProduct') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="runningOrderProductTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('orderId')" prop="order_id">
                        <el-input v-model="runningOrderProductTable.searchParam.order_id" :placeholder="t('orderIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('productId')" prop="product_id">
                        <el-input v-model="runningOrderProductTable.searchParam.product_id" :placeholder="t('productIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('num')" prop="num">
                        <el-input v-model="runningOrderProductTable.searchParam.num" :placeholder="t('numPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('code')" prop="code">
                        <el-input v-model="runningOrderProductTable.searchParam.code" :placeholder="t('codePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('price')" prop="price">
                        <el-input v-model="runningOrderProductTable.searchParam.price" :placeholder="t('pricePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-input v-model="runningOrderProductTable.searchParam.create_time" :placeholder="t('createTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-input v-model="runningOrderProductTable.searchParam.update_time" :placeholder="t('updateTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadRunningOrderProductList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="runningOrderProductTable.data" size="large" v-loading="runningOrderProductTable.loading">
                    <template #empty>
                        <span>{{ !runningOrderProductTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="order_id" :label="t('orderId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="product_id" :label="t('productId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="num" :label="t('num')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="code" :label="t('code')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="price" :label="t('price')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="runningOrderProductTable.page" v-model:page-size="runningOrderProductTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="runningOrderProductTable.total"
                        @size-change="loadRunningOrderProductList()" @current-change="loadRunningOrderProductList" />
                </div>
            </div>

            <edit ref="editRunningOrderProductDialog" @complete="loadRunningOrderProductList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getRunningOrderProductList, deleteRunningOrderProduct } from '@/addon/running/api/running_order_product'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/running/views/running_order_product/components/running-order-product-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let runningOrderProductTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "order_id":"",
      "product_id":"",
      "num":"",
      "code":"",
      "price":"",
      "create_time":"",
      "update_time":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取订单商品列表
 */
const loadRunningOrderProductList = (page: number = 1) => {
    runningOrderProductTable.loading = true
    runningOrderProductTable.page = page

    getRunningOrderProductList({
        page: runningOrderProductTable.page,
        limit: runningOrderProductTable.limit,
         ...runningOrderProductTable.searchParam
    }).then(res => {
        runningOrderProductTable.loading = false
        runningOrderProductTable.data = res.data.data
        runningOrderProductTable.total = res.data.total
    }).catch(() => {
        runningOrderProductTable.loading = false
    })
}
loadRunningOrderProductList()

const editRunningOrderProductDialog: Record<string, any> | null = ref(null)

/**
 * 添加订单商品
 */
const addEvent = () => {
    editRunningOrderProductDialog.value.setFormData()
    editRunningOrderProductDialog.value.showDialog = true
}

/**
 * 编辑订单商品
 * @param data
 */
const editEvent = (data: any) => {
    editRunningOrderProductDialog.value.setFormData(data)
    editRunningOrderProductDialog.value.showDialog = true
}

/**
 * 删除订单商品
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('runningOrderProductDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteRunningOrderProduct(id).then(() => {
            loadRunningOrderProductList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadRunningOrderProductList()
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
