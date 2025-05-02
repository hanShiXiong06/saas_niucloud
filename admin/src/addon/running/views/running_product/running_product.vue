<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addRunningProduct') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="runningProductTable.searchParam" ref="searchFormRef">
                    
                    <el-form-item :label="t('schoolId')" prop="school_id">
                        <el-select class="w-[280px]" v-model="runningProductTable.searchParam.school_id" clearable :placeholder="t('schoolIdPlaceholder')">
                           <el-option
                                       v-for="(item, index) in schoolIdList"
                                       :key="index"
                                       :label="item['name']"
                                       :value="item['id']"
                                   />
                        </el-select>
                    </el-form-item>
                    
                    
                    <el-form-item :label="t('categoryId')" prop="category_id">
                        <el-select class="w-[280px]" v-model="runningProductTable.searchParam.category_id" clearable :placeholder="t('categoryIdPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option
                                v-for="(item, index) in category_idList"
                                :key="index"
                                :label="item.name"
                                :value="item.value"
                            />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="runningProductTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('price')" prop="price">
                        <range-input v-model="runningProductTable.searchParam.price"/>
                    </el-form-item>
                    
                    <el-form-item :label="t('sales')" prop="sales">
                        <el-input v-model="runningProductTable.searchParam.sales" :placeholder="t('salesPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="runningProductTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option
                                v-for="(item, index) in statusList"
                                :key="index"
                                :label="item.name"
                                :value="item.value"
                            />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('sort')" prop="sort">
                        <el-input v-model="runningProductTable.searchParam.sort" :placeholder="t('sortPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="runningProductTable.searchParam.create_time" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-input v-model="runningProductTable.searchParam.update_time" :placeholder="t('updateTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadRunningProductList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="runningProductTable.data" size="large" v-loading="runningProductTable.loading">
                    <template #empty>
                        <span>{{ !runningProductTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="school_id_name" :label="t('schoolId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('categoryId')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in category_idList">
                                <div v-if="item.value == row.category_id">{{ item.name }}</div>
                            </div>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="price" :label="t('price')" min-width="120" :show-overflow-tooltip="true"/>
                    
                     <el-table-column :label="t('image')" width="100" align="left">
                        <template #default="{ row }">
                            <el-avatar v-if="row.image" :src="img(row.image)" />
                            <el-avatar v-else icon="UserFilled" />
                        </template>
                    </el-table-column>
                    <el-table-column prop="sales" :label="t('sales')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <div v-if="item.value == row.status">{{ item.name }}</div>
                            </div>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="runningProductTable.page" v-model:page-size="runningProductTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="runningProductTable.total"
                        @size-change="loadRunningProductList()" @current-change="loadRunningProductList" />
                </div>
            </div>

            <edit ref="editRunningProductDialog" @complete="loadRunningProductList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getRunningProductList, deleteRunningProduct, getWithRunningSchoolList } from '@/addon/running/api/running_product'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/running/views/running_product/components/running-product-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let runningProductTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "school_id":"",
      "category_id":"",
      "name":"",
      "price":[],
      "image":"",
      "sales":"",
      "status":"",
      "sort":"",
      "create_time":[],
      "update_time":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    const category_idList = ref([] as any[])
    const category_idDictList = async () => {
    category_idList.value = await (await useDictionary('school_business_type')).data.dictionary
    }
    category_idDictList();
    const statusList = ref([] as any[])
    const statusDictList = async () => {
    statusList.value = await (await useDictionary('status')).data.dictionary
    }
    statusDictList();

/**
 * 获取产品列表
 */
const loadRunningProductList = (page: number = 1) => {
    runningProductTable.loading = true
    runningProductTable.page = page

    getRunningProductList({
        page: runningProductTable.page,
        limit: runningProductTable.limit,
         ...runningProductTable.searchParam
    }).then(res => {
        runningProductTable.loading = false
        runningProductTable.data = res.data.data
        runningProductTable.total = res.data.total
    }).catch(() => {
        runningProductTable.loading = false
    })
}
loadRunningProductList()

const editRunningProductDialog: Record<string, any> | null = ref(null)

/**
 * 添加产品
 */
const addEvent = () => {
    editRunningProductDialog.value.setFormData()
    editRunningProductDialog.value.showDialog = true
}

/**
 * 编辑产品
 * @param data
 */
const editEvent = (data: any) => {
    editRunningProductDialog.value.setFormData(data)
    editRunningProductDialog.value.showDialog = true
}

/**
 * 删除产品
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('runningProductDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteRunningProduct(id).then(() => {
            loadRunningProductList()
        }).catch(() => {
        })
    })
}

    
    const schoolIdList = ref([])
    const setSchoolIdList = async () => {
    schoolIdList.value = await (await getWithRunningSchoolList({})).data
    }
    setSchoolIdList()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadRunningProductList()
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
