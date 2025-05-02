<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-page-title">{{ pageName }}</span>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="treasureTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('treasureName')" prop="keyword">
                        <el-input v-model.trim="treasureTable.searchParam.keyword" :placeholder="t('treasureNamePlaceholder')" maxlength="60" />
                    </el-form-item>
                    <el-form-item :label="t('relateType')">
                        <el-select v-model="treasureTable.searchParam.relate_type" :placeholder="t('relateTypePlaceholder')">
                            <el-option v-for="(item,index) in treasureType" :key="index" :label="item.label" :value="item.value" />
                        </el-select>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadTreasureList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">

                <el-tabs v-model="treasureTable.searchParam.select_type"  @tab-click="tabHandleClick">
                    <el-tab-pane :label="t('all')" name="all"></el-tab-pane>
                    <el-tab-pane :label="t('selected')" name="selected"></el-tab-pane>
                    <el-tab-pane :label="t('unselected')" name="unselected"></el-tab-pane>
                </el-tabs>

                <div class="mb-[10px] flex items-center">
                    <el-checkbox v-model="toggleCheckbox" size="large" class="px-[14px]" @change="toggleChange" :indeterminate="isIndeterminate" />
                    <el-button @click="batchjoinIn(1)" size="small">{{ t('join') }}</el-button>
                    <el-button @click="batchjoinIn(0)" size="small">{{ t('notJoin') }}</el-button>
                </div>

                <el-table :data="treasureTable.data" size="large" v-loading="treasureTable.loading" ref="treasureListTableRef"  @selection-change="handleSelectionChange">
                    <template #empty>
                        <span>{{ !treasureTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column type="selection" width="55" />

                    <el-table-column  :label="t('treasureInfo')" min-width="300">
                        <template #default="{ row }">
                            <div class="flex items-center" >
                                <div class="min-w-[70px] h-[70px] flex items-center justify-center">
                                    <el-image v-if="row.treasure_image" class="w-[70px] h-[70px]" :src="img(row.treasure_image)" fit="contain">
                                        <template #error>
                                            <div class="image-slot">
                                                <img class="w-[70px] h-[70px]" src="@/addon/sow_community/assets/default_img.png" />
                                            </div>
                                        </template>
                                    </el-image>
                                    <img v-else class="w-[70px] h-[70px]" src="@/addon/sow_community/assets/default_img.png" fit="contain" />
                                </div>
                                <div class="ml-2  flex flex-col items-start">
                                    <span :title="row.treasure_name" class="multi-hidden">{{ row.treasure_name }}</span>
                                    <span class="text-primary text-[12px]">{{ row.treasure_sub_name }}</span>
                                </div>
                            </div>
                        </template>
                    </el-table-column>

                    <el-table-column prop="relate_type_name" :label="t('relateTypeName')" min-width="120" />
                    <el-table-column prop="treasure_price" :label="t('treasurePrice')" min-width="120" />
                    <el-table-column  :label="t('isJoin')" min-width="120">
                        <template #default="{ row }">
                            <el-tag class="cursor-pointer" :type="row.is_join  ? 'success' : 'danger'" @click="isJoinChange(row, row.is_join ? 0 : 1)" > {{ row.is_join ? t('selected') : t('unselected') }}</el-tag>
                        </template>
                    </el-table-column>
                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="treasureTable.page" v-model:page-size="treasureTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="treasureTable.total"
                        @size-change="loadTreasureList()" @current-change="loadTreasureList" />
                </div>

            </div>

        </el-card>

    </div>
</template>

<script lang="ts" setup>
import { reactive, ref } from 'vue'
import { t } from '@/lang'
import { img } from '@/utils/common'
import { ElMessage, ElMessageBox, FormInstance } from 'element-plus'
import { useRoute } from 'vue-router'

import { getTreasureList, getTreasureType, treasureJoin } from '@/addon/sow_community/api/treasure'

const route = useRoute()
const pageName = route.meta.title
const repeat = ref(false)

const treasureTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        keyword: '',
        relate_type: '',
        select_type: 'all'
    }
})

/**
 * 获取商品列表
 */
const loadTreasureList = (page: number = 1) => {
    treasureTable.loading = true
    treasureTable.page = page

    getTreasureList({
        page: treasureTable.page,
        limit: treasureTable.limit,
        ...treasureTable.searchParam
    }).then((res: any) => {
        treasureTable.loading = false
        treasureTable.data = res.data.data
        treasureTable.total = res.data.total
        multipleSelection.value = []
    }).catch(() => {
        treasureTable.loading = false
    })
}

const searchFormRef = ref<FormInstance>()

// 宝贝类型下拉框
const treasureType: any = ref([])

// 初始化数据
const initData = () => {
    // 宝贝类型
    getTreasureType().then((res: any) => {
        const data = res.data
        if (data) {
            treasureType.value = []
            for (const k in data) {
                const obj = {
                    value: k,
                    label: data[k]
                }
                treasureType.value.push(obj)
            }
            if (treasureType.value.length) {
                treasureTable.searchParam.relate_type = treasureType.value[0].value
            }
            loadTreasureList()
        }
    })
}

initData()

// 当前选中tab页面
const tabHandleClick = (tab: any, event: Event) => {
    treasureTable.searchParam.select_type = tab.props.name
    loadTreasureList()
}

// 批量复选框
const toggleCheckbox = ref()

// 复选框中间状态
const isIndeterminate = ref(false)

// 监听批量复选框事件
const toggleChange = (value: any) => {
    isIndeterminate.value = false
    treasureListTableRef.value.toggleAllSelection()
}

const treasureListTableRef = ref()

// 选中数据
const multipleSelection: any = ref([])

// 监听表格单行选中
const handleSelectionChange = (val: []) => {
    multipleSelection.value = val

    toggleCheckbox.value = false
    if (multipleSelection.value.length > 0 && multipleSelection.value.length < treasureTable.data.length) {
        isIndeterminate.value = true
    } else {
        isIndeterminate.value = false
    }

    if (multipleSelection.value.length == treasureTable.data.length && treasureTable.data.length && multipleSelection.value.length) {
        toggleCheckbox.value = true
    }
}

// 修改参与不参与
const isJoinChange = (row: any, value: any) => {
    ElMessageBox.confirm(value ? t('participateTip') : t('offParticipateTip'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning'
        }
    ).then(() => {
        if (repeat.value) return
        repeat.value = true
        treasureJoin({
            relate_ids: [row.relate_id],
            relate_type: treasureTable.searchParam.relate_type,
            is_join: value
        }).then((res) => {
            repeat.value = false
            loadTreasureList()
        }).catch(() => {
            repeat.value = false
        })
    }).catch(()=>{})
}

// 批量设置参与不参与
const batchjoinIn = (value: any) => {
    if (multipleSelection.value.length == 0) {
        ElMessage({
            type: 'warning',
            message: `${t('batchEmptySelectedGoodsTips')}`
        })
        return
    }

    const relateIds: any = []
    multipleSelection.value.forEach((item: any) => {
        relateIds.push(item.relate_id)
    })

    ElMessageBox.confirm(value?t('participateTip'):t('offParticipateTip'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning'
        }
    ).then(() => {
        treasureJoin({
            relate_ids: relateIds,
            relate_type: treasureTable.searchParam.relate_type,
            is_join: value
        }).then((res) => {
            loadTreasureList()
        })
    }).catch(()=>{})
}

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadTreasureList()
}
</script>

<style lang="scss" scoped>
</style>
