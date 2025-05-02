<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">
            <div class="flex justify-between items-center">
                <span class="text-page-title">{{ pageName }}</span>
                <el-button type="primary" class="w-[100px]" @click="addEvent">
                    {{ t('addMarkdown') }}
                </el-button>
            </div>
            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="markdownTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('markdownName')" prop="filename">
                        <el-input v-model.trim="markdownTable.searchParam.filename"
                            :placeholder="t('markdownNamePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="markdownTable.searchParam.create_time" type="datetimerange"
                            value-format="YYYY-MM-DD HH:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadMarkdownList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="markdownTable.data" size="large" v-loading="markdownTable.loading">
                    <template #empty>
                        <span>{{ !markdownTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column :label="t('vaultName')" min-width="100" align="left">
                        <template #default="{ row }">
                            <div class="flex items-center">
                               {{ row.vault_name}}
                            </div>
                        </template>
                    </el-table-column>
                    <el-table-column prop="path_name" :label="t('pathName')" min-width="100">
                        <template #default="{ row }">
                            {{ row.path_name }}
                        </template>
                    </el-table-column>
                    <el-table-column prop="title" :label="t('title')" min-width="150" />
                    <el-table-column prop="create_time" :label="t('createTime')" min-width="150" />
                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="markdownTable.page" v-model:page-size="markdownTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="markdownTable.total"
                        @size-change="loadMarkdownList()" @current-change="loadMarkdownList" />
                </div>
            </div>

        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref } from 'vue'
import { t } from '@/lang'
import { getIndex } from '@/addon/ydc_docvite/api/markdown'
import { ElMessageBox, FormInstance } from 'element-plus'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const pageName = route.meta.title

interface TableType {
    page: number
    limit: number
    total: number
    loading: boolean
    data: any[]
    searchParam: {
        filename: string
        create_time: []
        hotel_status?: number|string
    }
}
const markdownTable = reactive<TableType>({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        filename: '',
        create_time: []
    }
})

const star = reactive<any>({
    1: t('oneStar'),
    2: t('twoStar'),
    3: t('threeStar'),
    4: t('fourStar'),
    5: t('fiveStar')
})

const searchFormRef = ref<FormInstance>()


const loadMarkdownList = (page: number = 1) => {
    markdownTable.loading = true
    markdownTable.page = page

    getIndex({
        page: markdownTable.page,
        limit: markdownTable.limit,
        ...markdownTable.searchParam
    }).then(res => {
        markdownTable.loading = false
        markdownTable.data = res.data.data
        markdownTable.total = res.data.total
    }).catch(() => {
        markdownTable.loading = false
    })
}
loadMarkdownList()

const router = useRouter()

/**
 * 添加酒店
 */
const addEvent = () => {
    router.push('/tourism/product/hotel/edit')
}


// 重置
const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadMarkdownList()
}
</script>

<style lang="scss" scoped></style>