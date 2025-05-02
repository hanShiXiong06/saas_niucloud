<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{ pageName }}</span>
                <div class="flex items-center">
                    <el-button @click="asyncActEvent" :loading="syncLoading">
                        同步活动
                    </el-button>
                    <el-button type="primary" @click="addEvent">
                        {{ t('addAct') }}
                    </el-button>
                </div>

            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="actTable.searchParam" ref="searchFormRef">


                    <el-form-item :label="t('type')" prop="type">
                        <el-select v-model="actTable.searchParam.type" :placeholder="t('typePlaceholder')" clearable>
                            <el-option v-for="(item, index) in actTypeList" :key="index" :label="item" :value="index" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('title')" prop="title">
                        <el-input v-model="actTable.searchParam.title" :placeholder="t('titlePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('status')" prop="status">
                        <el-select v-model="actTable.searchParam.status" :placeholder="t('statusPlaceholder')"
                            clearable>
                            <el-option label="已下架" value="0" />
                            <el-option label="已上架" value="1" />
                        </el-select>
                    </el-form-item>
                    <!-- <el-form-item :label="t('isAudit')" prop="is_audit">
                        <el-input v-model="actTable.searchParam.is_audit" :placeholder="t('isAuditPlaceholder')" />
                    </el-form-item> -->
                    <!-- <el-form-item :label="t('startTime')" prop="start_time">
                        <el-date-picker v-model="actTable.searchParam.start_time" type="datetimerange"
                            format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item :label="t('endTime')" prop="end_time">
                        <el-date-picker v-model="actTable.searchParam.end_time" type="datetimerange"
                            format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item> -->

                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="actTable.searchParam.create_time" type="datetimerange"
                            format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadActList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="actTable.data" size="large" v-loading="actTable.loading">
                    <template #empty>
                        <span>{{ !actTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column :label="t('itemPic')" width="100" align="left">
                        <template #default="{ row }">
                            <el-avatar v-if="row.itemPic" :src="img(row.itemPic)" />
                            <el-avatar v-else icon="UserFilled" />
                        </template>
                    </el-table-column>
                    <el-table-column prop="title" :label="t('title')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="type_name" :label="t('type')" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.type == 'api'">{{ row.type_name }}</el-tag>
                            <el-tag v-else type="success">{{ row.type_name }}</el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column prop="act_id" :label="t('actId')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="minMoney" :label="t('minMoney')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="maxMoney" :label="t('maxMoney')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="labelText" :label="t('labelText')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="status" :label="t('status')" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.status == '1'">上架</el-tag>
                            <el-tag v-else type="danger">下架</el-tag>
                        </template>
                    </el-table-column>

                    <el-table-column prop="simpleDescription" :label="t('simpleDescription')" min-width="120"
                        :show-overflow-tooltip="true" />
                    <!-- 
                    <el-table-column prop="from_id_name" :label="t('fromId')" min-width="120"
                        :show-overflow-tooltip="true" /> -->

                    <!-- <el-table-column prop="is_audit" :label="t('isAudit')" min-width="120"
                        :show-overflow-tooltip="true" /> -->

                    <!-- <el-table-column :label="t('startTime')" min-width="180" align="center"
                        :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            {{ row.start_time || '' }}
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('endTime')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            {{ row.end_time || '' }}
                        </template>
                    </el-table-column> -->

                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                            <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="actTable.page" v-model:page-size="actTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="actTable.total"
                        @size-change="loadActList()" @current-change="loadActList" />
                </div>
            </div>


        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getActList, deleteAct, getWithMemberList, getWithDiyFormList, asyncAct } from '@/addon/tk_cpa/api/act'
import { getActType } from '@/addon/tk_cpa/api/order'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;
const actTypeList = ref([])
const setActTypeList = async () => {
    actTypeList.value = await (await getActType()).data
}
setActTypeList()
const syncLoading = ref(false)
const asyncActEvent = async () => {
    syncLoading.value = true
    try {
        await asyncAct()
        loadActList()
    } finally {
        syncLoading.value = false
    }
}
let actTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "member_id": "",
        "type": "",
        "title": "",
        "status": "",
        "is_audit": "",
        "start_time": [],
        "end_time": [],
        "create_time": []
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据


/**
 * 获取CPA活动列列表
 */
const loadActList = (page: number = 1) => {
    actTable.loading = true
    actTable.page = page

    getActList({
        page: actTable.page,
        limit: actTable.limit,
        ...actTable.searchParam
    }).then(res => {
        actTable.loading = false
        actTable.data = res.data.data
        actTable.total = res.data.total
    }).catch(() => {
        actTable.loading = false
    })
}
loadActList()

const router = useRouter()

/**
 * 添加CPA活动列
 */
const addEvent = () => {
    router.push('/act/act_edit')
}

/**
 * 编辑CPA活动列
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/act/act_edit?id=' + data.id)
}

/**
 * 删除CPA活动列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('actDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteAct(id).then(() => {
            loadActList()
        }).catch(() => {
        })
    })
}


const memberIdList = ref([])
const setMemberIdList = async () => {
    memberIdList.value = await (await getWithMemberList({})).data
}
setMemberIdList()
const fromIdList = ref([])
const setFromIdList = async () => {
    fromIdList.value = await (await getWithDiyFormList({})).data
}
setFromIdList()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadActList()
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
