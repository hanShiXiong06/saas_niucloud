<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addPackage') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="packageTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="packageTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadPackageList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="packageTable.data" size="large" v-loading="packageTable.loading">
                    <template #empty>
                        <span>{{ !packageTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="price" :label="t('price')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="point" :label="t('point')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="packageTable.page" v-model:page-size="packageTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="packageTable.total"
                        @size-change="loadPackageList()" @current-change="loadPackageList" />
                </div>
            </div>

            <edit ref="editPackageDialog" @complete="loadPackageList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getPackageList, deletePackage } from '@/addon/ai_humans/api/package'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/ai_humans/views/package/components/package-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let packageTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "name":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取套餐列列表
 */
const loadPackageList = (page: number = 1) => {
    packageTable.loading = true
    packageTable.page = page

    getPackageList({
        page: packageTable.page,
        limit: packageTable.limit,
         ...packageTable.searchParam
    }).then(res => {
        packageTable.loading = false
        packageTable.data = res.data.data
        packageTable.total = res.data.total
    }).catch(() => {
        packageTable.loading = false
    })
}
loadPackageList()

const editPackageDialog: Record<string, any> | null = ref(null)

/**
 * 添加套餐列
 */
const addEvent = () => {
    editPackageDialog.value.setFormData()
    editPackageDialog.value.showDialog = true
}

/**
 * 编辑套餐列
 * @param data
 */
const editEvent = (data: any) => {
    editPackageDialog.value.setFormData(data)
    editPackageDialog.value.showDialog = true
}

/**
 * 删除套餐列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('packageDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deletePackage(id).then(() => {
            loadPackageList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadPackageList()
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
