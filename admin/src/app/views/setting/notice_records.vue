<template>
    <!--发送记录-->
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-page-title">{{ pageName }}</span>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="recordsTableData.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('searchReceiver')" prop="receiver">
                        <el-input v-model.trim="recordsTableData.searchParam.receiver" :placeholder="t('receiverPlaceholder')" />
                    </el-form-item>

                    <el-form-item :label="t('noticeKey')" prop="key">
                        <el-select v-model="recordsTableData.searchParam.key" clearable :placeholder="t('noticeKeyPlaceholder')" class="input-width" popper-class="notice">
                            <el-option-group v-for="(group, gindex) in templateList" :key="gindex" :label="group.label">
                                <el-option :label="item.name" :value="item.value" :disabled="item.disabled ?? false" v-for="(item, index) in group.list" :key="index" />
                            </el-option-group>
                        </el-select>
                    </el-form-item>

                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="recordsTableData.searchParam.create_time" type="datetimerange" value-format="YYYY-MM-DD HH:mm:ss" :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadNoticeLogList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="recordsTableData.data" size="large" v-loading="recordsTableData.loading">

                    <template #empty>
                        <span>{{ !recordsTableData.loading ? t('emptyData') : '' }}</span>
                    </template>

                    <el-table-column prop="name" :label="t('noticeKey')" min-width="120" />
                    <el-table-column prop="notice_type" :label="t('noticeType')" min-width="120">
                        <template #default="{ row }">
                            <div v-if="row.notice_type == 'sms'">{{ t('sms') }}</div>
                            <div v-if="row.notice_type == 'wechat'">{{ t('wechat') }}</div>
                            <div v-if="row.notice_type == 'weapp'">{{ t('weapp') }}</div>
                        </template>
                    </el-table-column>

                    <el-table-column prop="nickname" :label="t('nickname')" min-width="120" />
                    <el-table-column prop="receiver" :label="t('receiver')" min-width="120" />
                    <el-table-column prop="create_time" :label="t('createTime')" min-width="140" />

                    <el-table-column :label="t('operation')" align="right" fixed="right" width="100">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="infoEvent(row)">{{ t('info') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>

                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="recordsTableData.page" v-model:page-size="recordsTableData.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="recordsTableData.total"
                        @size-change="loadNoticeLogList()" @current-change="loadNoticeLogList" />
                </div>
            </div>

            <records-info ref="recordsDialog" @complete="loadNoticeLogList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref } from 'vue'
import { t } from '@/lang'
import { getNoticeLog, getNoticeList } from '@/app/api/notice'
import RecordsInfo from '@/app/views/setting/components/notice-records-info.vue'
import { FormInstance } from 'element-plus'
import { useRoute } from 'vue-router'

const route = useRoute()
const pageName = route.meta.title

const recordsTableData = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        key: '',
        receiver: '',
        create_time: []
    }
})

const templateList = reactive<Record<string, any>>({
    buyer: {
        label: t('buyerNotice'),
        list: []
    },
    seller: {
        label: t('sellerNotice'),
        list: []
    }
})

const setTemplateList = async () => {
    getNoticeList({}).then(res => {
        templateList.buyer.list = []
        templateList.seller.list = []
        res.data.forEach(item => {
            if (item.notice.length) {
                const buyer = [], seller = []
                Object.keys(item.notice).forEach((key, index) => {
                    const notice = item.notice[key]
                    notice.addon_name = item.title
                    notice.receiver_type == 1 ? buyer.push({ name: notice.name, value: notice.key }) : seller.push({ name: notice.name, value: notice.key })
                })
                if (buyer.length) {
                    buyer.unshift({ name: item.title, value: item.key, disabled: true })
                    templateList.buyer.list = templateList.buyer.list.concat(buyer)
                }
                if (seller.length) {
                    seller.unshift({ name: item.title, value: item.key, disabled: true })
                    templateList.seller.list = templateList.seller.list.concat(seller)
                }
            }
        })
    }).catch((e) => {
    })
}

setTemplateList()

const searchFormRef = ref<FormInstance>()

/**
 * 获取通知记录列表
 */
const loadNoticeLogList = (page: number = 1) => {
    recordsTableData.loading = true
    recordsTableData.page = page

    getNoticeLog({
        page: recordsTableData.page,
        limit: recordsTableData.limit,
        ...recordsTableData.searchParam
    }).then(res => {
        recordsTableData.loading = false
        recordsTableData.data = res.data.data
        recordsTableData.total = res.data.total
    }).catch(() => {
        recordsTableData.loading = false
    })
}
loadNoticeLogList()
const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadNoticeLogList()
}

const recordsDialog: Record<string, any> | null = ref(null)

/**
 * 查看通知记录
 * @param data
 */
const infoEvent = (data: any) => {
    recordsDialog.value.setFormData(data)
    recordsDialog.value.showDialog = true
}

</script>

<style lang="scss">
.notice .el-select-group__title{
    font-size: 14px;;
}

</style>
