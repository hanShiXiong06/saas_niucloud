<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('添加社群分类') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="shequncateTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="shequncateTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('adddate')" prop="adddate">
                        <el-date-picker v-model="shequncateTable.searchParam.adddate" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadShequncateList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="shequncateTable.data" size="large" v-loading="shequncateTable.loading">
                    <template #empty>
                        <span>{{ !shequncateTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="id" :label="t('ID')" min-width="60" :show-overflow-tooltip="true"/>
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="adddate" :label="t('adddate')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="shequncateTable.page" v-model:page-size="shequncateTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="shequncateTable.total"
                        @size-change="loadShequncateList()" @current-change="loadShequncateList" />
                </div>
            </div>

            <edit ref="editShequncateDialog" @complete="loadShequncateList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getShequncateList, deleteShequncate } from '@/addon/blog/api/shequncate'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/blog/views/shequncate/components/shequncate-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let shequncateTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "name":"",
      "adddate":[]
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取微信社群列表
 */
const loadShequncateList = (page: number = 1) => {
    shequncateTable.loading = true
    shequncateTable.page = page

    getShequncateList({
        page: shequncateTable.page,
        limit: shequncateTable.limit,
         ...shequncateTable.searchParam
    }).then(res => {
        shequncateTable.loading = false
        shequncateTable.data = res.data.data
        shequncateTable.total = res.data.total
    }).catch(() => {
        shequncateTable.loading = false
    })
}
loadShequncateList()

const editShequncateDialog: Record<string, any> | null = ref(null)

/**
 * 添加微信社群
 */
const addEvent = () => {
    editShequncateDialog.value.setFormData()
    editShequncateDialog.value.showDialog = true
}

/**
 * 编辑微信社群
 * @param data
 */
const editEvent = (data: any) => {
    editShequncateDialog.value.setFormData(data)
    editShequncateDialog.value.showDialog = true
}

/**
 * 删除微信社群
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('shequncateDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteShequncate(id).then(() => {
            loadShequncateList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadShequncateList()
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
