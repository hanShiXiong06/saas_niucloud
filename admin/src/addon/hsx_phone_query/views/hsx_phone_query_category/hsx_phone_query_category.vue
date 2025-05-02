<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{ pageName }}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addHsxPhoneQueryCategory') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="hsxPhoneQueryCategoryTable.searchParam" ref="searchFormRef">

                    <el-form-item :label="t('typeId')" prop="type_id">
                        <el-select class="w-[280px]" v-model="hsxPhoneQueryCategoryTable.searchParam.type_id" clearable
                            :placeholder="t('typeIdPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option v-for="(item, index) in type_idList" :key="index" :label="item.name"
                                :value="item.value" />
                        </el-select>
                    </el-form-item>

                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="hsxPhoneQueryCategoryTable.searchParam.name"
                            :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('price')" prop="price">
                        <el-input v-model="hsxPhoneQueryCategoryTable.searchParam.price"
                            :placeholder="t('pricePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('isShow')" prop="is_show">
                        <el-select v-model="hsxPhoneQueryCategoryTable.searchParam.is_show" clearable>
                            <el-option label="显示" :value="1" />
                            <el-option label="隐藏" :value="0" />
                        </el-select>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadHsxPhoneQueryCategoryList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="hsxPhoneQueryCategoryTable.data" size="large" row-key="id"
                    v-loading="hsxPhoneQueryCategoryTable.loading" @row-drop="handleRowDrop">
                    <template #empty>
                        <span>{{ !hsxPhoneQueryCategoryTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column type="drag" width="40" />
                    <el-table-column prop="id" :label="t('id')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column :label="t('typeId')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in type_idList">
                                <div v-if="item.value == row.type_id">{{ item.name }}</div>
                            </div>
                        </template>
                    </el-table-column>

                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="price" :label="t('price')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="sort" :label="t('sort')" min-width="120">
                        <template #default="{ row }">
                            <el-input-number v-model="row.sort" :min="0" :max="999"
                                @change="(value) => handleSortChange(row.id, value)" />
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('isShow')" min-width="120">
                        <template #default="{ row }">
                            <el-switch v-model="row.is_show" :active-value="1" :inactive-value="0"
                                @change="(value) => handleShowChange(row.id, value)" />
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                            <el-button type="primary" link @click="deleteEvent(row)">{{ t('delete')
                                }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="hsxPhoneQueryCategoryTable.page"
                        v-model:page-size="hsxPhoneQueryCategoryTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="hsxPhoneQueryCategoryTable.total"
                        @size-change="loadHsxPhoneQueryCategoryList()"
                        @current-change="loadHsxPhoneQueryCategoryList" />
                </div>
            </div>

            <edit ref="editHsxPhoneQueryCategoryDialog" @complete="loadHsxPhoneQueryCategoryList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getHsxPhoneQueryCategoryList, deleteHsxPhoneQueryCategory, modifySort, modifyShow } from '@/addon/hsx_phone_query/api/hsx_phone_query_category'

import { ElMessageBox, FormInstance } from 'element-plus'
import Edit from '@/addon/hsx_phone_query/views/hsx_phone_query_category/components/hsx-phone-query-category-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let hsxPhoneQueryCategoryTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "type_id": "",
        "name": "",
        "price": "",
        "is_show": ""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
const type_idList = ref([] as any[])
const type_idDictList = async () => {
    type_idList.value = await (await useDictionary('phone_type')).data.dictionary
}
type_idDictList();

/**
 * 获取分类列表
 */
const loadHsxPhoneQueryCategoryList = (page: number = 1) => {
    hsxPhoneQueryCategoryTable.loading = true
    hsxPhoneQueryCategoryTable.page = page


    getHsxPhoneQueryCategoryList({
        page: hsxPhoneQueryCategoryTable.page,
        limit: hsxPhoneQueryCategoryTable.limit,
        ...hsxPhoneQueryCategoryTable.searchParam
    }).then(res => {
        hsxPhoneQueryCategoryTable.loading = false
        hsxPhoneQueryCategoryTable.data = res.data.data
        hsxPhoneQueryCategoryTable.total = res.data.total
    }).catch(() => {
        hsxPhoneQueryCategoryTable.loading = false
    })
}
loadHsxPhoneQueryCategoryList()

const editHsxPhoneQueryCategoryDialog: Record<string, any> | null = ref(null)

/**
 * 添加分类
 */
const addEvent = () => {
    editHsxPhoneQueryCategoryDialog.value.setFormData()
    editHsxPhoneQueryCategoryDialog.value.showDialog = true
}

/**
 * 编辑分类
 * @param data
 */
const editEvent = (data: any) => {


    editHsxPhoneQueryCategoryDialog.value.setFormData(data)
    editHsxPhoneQueryCategoryDialog.value.showDialog = true
}

/**
 * 删除分类
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('hsxPhoneQueryCategoryDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteHsxPhoneQueryCategory(id).then(() => {
            loadHsxPhoneQueryCategoryList()
        }).catch(() => {
        })
    })
}



const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadHsxPhoneQueryCategoryList()
}

// 处理拖拽排序
const handleRowDrop = ({ newIndex, oldIndex }) => {
    const currentRow = hsxPhoneQueryCategoryTable.data[oldIndex]
    const targetRow = hsxPhoneQueryCategoryTable.data[newIndex]

    // 交换排序值
    const tempSort = currentRow.sort
    currentRow.sort = targetRow.sort
    targetRow.sort = tempSort

    // 更新到服务器
    modifySort(currentRow.id, currentRow.sort)
    modifySort(targetRow.id, targetRow.sort)

    // 重新加载列表
    loadHsxPhoneQueryCategoryList()
}

// 处理排序变化
const handleSortChange = (id: number, value: number) => {
    modifySort(id, value).then(() => {
        loadHsxPhoneQueryCategoryList()
    })
}

// 处理显示状态变化
const handleShowChange = (id: number, value: number) => {
    modifyShow(id, value).then(() => {
        loadHsxPhoneQueryCategoryList()
    })
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

/* 拖拽排序样式 */
:deep(.el-table__row.dragging) {
    opacity: 0.5;
    cursor: move;
}

:deep(.el-table__row.drop-over) {
    background-color: var(--el-color-primary-light-9);
}
</style>
