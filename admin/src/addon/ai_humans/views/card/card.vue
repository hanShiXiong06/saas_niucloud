<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center"> <el-button type="primary" @click="addEvent">
                    {{ t('addCard') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="cardTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('cardNum')" prop="card_num">
                        <el-input v-model="cardTable.searchParam.card_num" :placeholder="t('cardNumPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('isUse')" prop="is_use">

                        <el-select class="w-[280px]" v-model="cardTable.searchParam.is_use" clearable
                            placeholder="请选择状态">
                            <el-option label="全部" value="" />
                            <el-option label="未兑换" :value="0" />
                            <el-option label="已兑换" :value="1" />
                        </el-select>
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadCardList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="cardTable.data" size="large" v-loading="cardTable.loading">
                    <template #empty>
                        <span>{{ !cardTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="card_num" :label="t('cardNum')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="is_use" label="兑换状态" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.is_use == 1" type="error">已兑换</el-tag>
                            <el-tag v-if="row.is_use == 0" type="success">未兑换</el-tag>
                        </template>
                    </el-table-column>

                    <el-table-column prop="point" :label="t('point')" min-width="120" :show-overflow-tooltip="true" />
                    <el-table-column prop="create_time" label="生成时间" min-width="120" :show-overflow-tooltip="true" />
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">

                            <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="cardTable.page" v-model:page-size="cardTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="cardTable.total"
                        @size-change="loadCardList()" @current-change="loadCardList" />
                </div>
            </div>

            <edit ref="editCardDialog" @complete="loadCardList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getCardList, deleteCard } from '@/addon/ai_humans/api/card'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance } from 'element-plus'
import Edit from '@/addon/ai_humans/views/card/components/card-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let cardTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "card_num": "",
        "is_use": "",
        "status": ""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据


/**
 * 获取卡密管理列表
 */
const loadCardList = (page: number = 1) => {
    cardTable.loading = true
    cardTable.page = page

    getCardList({
        page: cardTable.page,
        limit: cardTable.limit,
        ...cardTable.searchParam
    }).then(res => {
        cardTable.loading = false
        cardTable.data = res.data.data
        cardTable.total = res.data.total
    }).catch(() => {
        cardTable.loading = false
    })
}
loadCardList()

const editCardDialog: Record<string, any> | null = ref(null)

/**
 * 添加卡密管理
 */
const addEvent = () => {
    editCardDialog.value.setFormData()
    editCardDialog.value.showDialog = true
}

/**
 * 编辑卡密管理
 * @param data
 */
const editEvent = (data: any) => {
    editCardDialog.value.setFormData(data)
    editCardDialog.value.showDialog = true
}

/**
 * 删除卡密管理
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('cardDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteCard(id).then(() => {
            loadCardList()
        }).catch(() => {
        })
    })
}



const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadCardList()
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
