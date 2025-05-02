<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="productTable.searchParam" ref="searchFormRef">

                    <el-form-item :label="t('title')" prop="title">
                        <el-input v-model="productTable.searchParam.title" :placeholder="t('titlePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('operator')" prop="operator">

                        <el-select class="w-[280px]" v-model="productTable.searchParam.operator" clearable
                            placeholder="请选择运营商">
                            <el-option v-for="(item, index) in operatorList" :key="index" :label="item['name']"
                                :value="item['operator']" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('mode')" prop="mode">
                        <el-select class="w-[280px]" v-model="productTable.searchParam.mode" clearable
                            placeholder="请选择结算周期">
                            <el-option v-for="(item, index) in modeList" :key="index" :label="item['name']"
                                :value="item['mode']" />
                        </el-select>
                    </el-form-item>

                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="productTable.searchParam.status" clearable
                            placeholder="请选择状态">
                            <el-option label="全部" value="" />
                            <el-option label="仓库中" :value="0" />
                            <el-option label="上架中" :value="1" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('apiStatus')" prop="api_status">
                        <el-select class="w-[280px]" v-model="productTable.searchParam.api_status" clearable
                            placeholder="请选择三方状态">
                            <el-option label="全部" value="" />
                            <el-option label="已下架" :value="2" />
                            <el-option label="正常" :value="1" />
                        </el-select>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadProductList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>
            <el-button :loading="syncProductLoading" type="primary" @click="syncProductEvent">
                同步商品
            </el-button>
            <div class="mt-[10px]">
                <el-table :data="productTable.data" size="large" v-loading="productTable.loading">
                    <template #empty>
                        <span>{{ !productTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column :label="t('img')" width="100" align="left">
                        <template #default="{ row }">
                            <el-avatar shape="square" v-if="row.img" :src="img(row.img)" />
                            <el-avatar shape="square" v-else icon="UserFilled" />
                        </template>
                    </el-table-column>

                    <el-table-column prop="title" :label="t('title')" min-width="160" :show-overflow-tooltip="true" />

                    <el-table-column prop="operator_name" :label="t('operator')" min-width="120"
                        :show-overflow-tooltip="true" />


                    <el-table-column prop="minage" label="办理年龄" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div>{{ row.minage }}~{{ row.maxage }}岁</div>
                        </template>
                    </el-table-column>
                    <el-table-column prop="beizhu" :label="t('beizhu')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="mode_name" :label="t('mode')" min-width="120"
                        :show-overflow-tooltip="true" />
                    <el-table-column prop="activation_cash" :label="t('activationCash')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="followup_cash" :label="t('followupCash')" min-width="120"
                        :show-overflow-tooltip="true" />


                    <el-table-column prop="status" :label="t('status')" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.status == 1">上架</el-tag>
                            <el-tag v-else type="warning">仓库中</el-tag>
                        </template>
                    </el-table-column>

                    <el-table-column prop="api_status" :label="t('apiStatus')" min-width="120"
                        :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.api_status == 1">正常</el-tag>
                            <el-tag v-else type="warning">三方下架</el-tag>
                        </template>
                    </el-table-column>

                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                            <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                            <el-button type="primary" v-if="row.status == 0 && row.api_status == 1" link
                                @click="upProductEvent(row.id)">上架</el-button>
                            <el-button type="primary" v-if="row.status == 1 && row.api_status == 1" link
                                @click="dnProductEvent(row.id)">下架</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="productTable.page" v-model:page-size="productTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="productTable.total"
                        @size-change="loadProductList()" @current-change="loadProductList" />
                </div>
            </div>

            <edit ref="editProductDialog" @complete="loadProductList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getProductList, deleteProduct, syncProduct, getOperator, getMode, upProduct, dnProduct } from '@/addon/hk/api/product'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance } from 'element-plus'
import Edit from '@/addon/hk/views/product/components/product-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;
const operatorList = ref<any[]>([])
const modeList = ref<any[]>([])
getOperator().then(res => {
    operatorList.value = res.data
})
getMode().then(res => {
    modeList.value = res.data
})
const syncProductLoading = ref(false)
const syncProductEvent = () => {
    syncProductLoading.value = true
    syncProduct().then(() => {
        loadProductList()
    }).catch(() => {
        ElMessageBox.error('同步商品出错啦')
    }).finally(() => {
        syncProductLoading.value = false
    })
}
const upProductEvent = async (id) => {
    await upProduct(id)
    loadProductList()
}
const dnProductEvent = async (id) => {
    await dnProduct(id)
    loadProductList()
}
let productTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "product_id": "",
        "title": "",
        "operator": "",
        "is_idcard": "",
        "gztcheckidcard": "",
        "img": "",
        "marketing": "",
        "beizhu": "",
        "mode": "",
        "allow_area": "",
        "prohibit_area": "",
        "detailsimg": "",
        "activation_cash": [],
        "followup_cash": [],
        "status": "",
        "api_status": ""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据


/**
 * 获取号卡产品列表
 */
const loadProductList = (page: number = 1) => {
    productTable.loading = true
    productTable.page = page

    getProductList({
        page: productTable.page,
        limit: productTable.limit,
        ...productTable.searchParam
    }).then(res => {
        productTable.loading = false
        productTable.data = res.data.data
        productTable.total = res.data.total
    }).catch(() => {
        productTable.loading = false
    })
}
loadProductList()

const editProductDialog: Record<string, any> | null = ref(null)

/**
 * 添加号卡产品
 */
const addEvent = () => {
    editProductDialog.value.setFormData()
    editProductDialog.value.showDialog = true
}

/**
 * 编辑号卡产品
 * @param data
 */
const editEvent = (data: any) => {
    editProductDialog.value.setFormData(data)
    editProductDialog.value.showDialog = true
}

/**
 * 删除号卡产品
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('productDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteProduct(id).then(() => {
            loadProductList()
        }).catch(() => {
        })
    })
}



const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadProductList()
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
