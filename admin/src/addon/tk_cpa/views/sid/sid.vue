<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{ pageName }}</span>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="sidTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('sid')" prop="sid">
                        <el-input v-model="sidTable.searchParam.sid" :placeholder="t('sidPlaceholder')" />
                    </el-form-item>

                    <el-form-item :label="t('memberId')" prop="member_id">
                        <el-select class="w-[280px]" v-model="sidTable.searchParam.member_id" clearable
                            :placeholder="t('memberIdPlaceholder')">
                            <el-option v-for="(item, index) in memberIdList" :key="index" :label="item['nickname']"
                                :value="item['member_id']" />
                        </el-select>
                    </el-form-item>


                    <el-form-item :label="t('cpaProjectId')" prop="cpaProjectId">
                        <el-select class="w-[280px]" v-model="sidTable.searchParam.cpaProjectId" clearable
                            :placeholder="t('cpaProjectIdPlaceholder')">
                            <el-option v-for="(item, index) in cpaProjectIdList" :key="index" :label="item['title']"
                                :value="item['act_id']" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('phone')" prop="phone">
                        <el-input v-model="sidTable.searchParam.phone" :placeholder="t('phonePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('status')" prop="status">
                        <el-select v-model="sidTable.searchParam.status" :placeholder="t('statusPlaceholder')"
                            clearable>
                            <el-option v-for="(item, index) in statusList" :key="index" :label="item" :value="index" />
                        </el-select>
                    </el-form-item>

                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="sidTable.searchParam.create_time" type="datetimerange"
                            format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadSidList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="sidTable.data" size="large" v-loading="sidTable.loading">
                    <template #empty>
                        <span>{{ !sidTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="sid" :label="t('sid')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="cpaProjectId_name" :label="t('cpaProjectId')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="nickName" :label="t('nickName')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="phone" :label="t('phone')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="status_name" :label="t('status')" min-width="120"
                        :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.status == 1" type="success">{{ row.status_name }}</el-tag>
                            <el-tag v-else type="danger">{{ row.status_name }}</el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column prop="auditTime" :label="t('auditTime')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="failReason" :label="t('failReason')" min-width="120"
                        :show-overflow-tooltip="true" />




                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                            <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="sidTable.page" v-model:page-size="sidTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="sidTable.total"
                        @size-change="loadSidList()" @current-change="loadSidList" />
                </div>
            </div>

            <edit ref="editSidDialog" @complete="loadSidList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getSidList, deleteSid, getWithMemberList, getWithActList, getSidStatus } from '@/addon/tk_cpa/api/sid'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance } from 'element-plus'
import Edit from '@/addon/tk_cpa/views/sid/components/sid-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;
const statusList = ref([])
const setStatusList = async () => {
    statusList.value = await (await getSidStatus()).data
}
setStatusList()
let sidTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "sid": "",
        "member_id": "",
        "cpaProjectId": "",
        "nickName": "",
        "phone": "",
        "status": "",
        "miniCode": "",
        "promotionCode": "",
        "promotionPoster": "",
        "promotionUrl": "",
        "queryDataUrl": "",
        "systemLink": "",
        "create_time": []
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据


/**
 * 获取CPA开码列列表
 */
const loadSidList = (page: number = 1) => {
    sidTable.loading = true
    sidTable.page = page

    getSidList({
        page: sidTable.page,
        limit: sidTable.limit,
        ...sidTable.searchParam
    }).then(res => {
        sidTable.loading = false
        sidTable.data = res.data.data
        sidTable.total = res.data.total
    }).catch(() => {
        sidTable.loading = false
    })
}
loadSidList()

const editSidDialog: Record<string, any> | null = ref(null)

/**
 * 添加CPA开码列
 */
const addEvent = () => {
    editSidDialog.value.setFormData()
    editSidDialog.value.showDialog = true
}

/**
 * 编辑CPA开码列
 * @param data
 */
const editEvent = (data: any) => {
    editSidDialog.value.setFormData(data)
    editSidDialog.value.showDialog = true
}

/**
 * 删除CPA开码列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('sidDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteSid(id).then(() => {
            loadSidList()
        }).catch(() => {
        })
    })
}


const memberIdList = ref([])
const setMemberIdList = async () => {
    memberIdList.value = await (await getWithMemberList({})).data
}
setMemberIdList()
const cpaProjectIdList = ref([])
const setCpaProjectIdList = async () => {
    cpaProjectIdList.value = await (await getWithActList({})).data
}
setCpaProjectIdList()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadSidList()
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
