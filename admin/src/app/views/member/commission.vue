<template>
    <!--会员佣金-->
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-page-title">{{ pageName }}</span>
            </div>

            <el-card class="box-card !border-none !px-[35px]" shadow="never">
                <el-row class="flex">
                    <el-col :span="6" class="min-w-[100px]">
                        <div class="statistic-card">
                            <el-statistic :value="commissionStatistics.total_commission ? Number.parseFloat(commissionStatistics.total_commission).toFixed(2) : '0.00'"></el-statistic>
                            <div class="statistic-footer">
                                <div class="footer-item text-[14px] text-[#666]">
                                    <span>{{ t('totalCommission') }}</span>
                                </div>
                            </div>
                        </div>
                    </el-col>
                    <el-col :span="6" class="min-w-[100px]">
                        <div class="statistic-card">
                            <el-statistic :value="commissionStatistics.commission ? Number.parseFloat(commissionStatistics.commission).toFixed(2) : '0.00'"></el-statistic>
                            <div class="statistic-footer">
                                <div class="footer-item text-[14px] text-[#666]">
                                    <span>{{ t('commission') }}</span>
                                </div>
                            </div>
                        </div>
                    </el-col>
                    <el-col :span="6" class="min-w-[100px]">
                        <div class="statistic-card">
                            <el-statistic :value="commissionStatistics.withdrawn_commission ? Number.parseFloat(commissionStatistics.withdrawn_commission).toFixed(2) : '0.00'"></el-statistic>
                            <div class="statistic-footer">
                                <div class="footer-item text-[14px] text-[#666]">
                                    <span>{{ t('withdrawnCommission') }}</span>
                                </div>
                            </div>
                        </div>
                    </el-col>
                    <el-col :span="6" class="min-w-[100px]">
                        <div class="statistic-card">
                            <el-statistic :value="commissionStatistics.commission_cash_outing ? Number.parseFloat(commissionStatistics.commission_cash_outing).toFixed(2) : '0.00'"></el-statistic>
                            <div class="statistic-footer">
                                <div class="footer-item text-[14px] text-[#666]">
                                    <span>{{ t('cashOutingCommission') }}</span>
                                </div>
                            </div>
                        </div>
                    </el-col>
                </el-row>
            </el-card>

            <el-card class="box-card !border-none mb-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="memberAccountLogTableData.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('memberInfo')" prop="keywords">
                        <el-input v-model.trim="memberAccountLogTableData.searchParam.keywords" class="w-[240px]" :placeholder="t('memberInfoPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('fromType')" prop="from_type">
                        <el-select v-model="memberAccountLogTableData.searchParam.from_type" clearable :placeholder="t('fromTypePlaceholder')" class="input-width">
                            <el-option :label="t('selectPlaceholder')" value="" />
                            <el-option :label="item.name" :value="key" v-for="(item, key) in fromTypeList" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="memberAccountLogTableData.searchParam.create_time" type="datetimerange"
                            value-format="YYYY-MM-DD HH:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadMemberAccountLogList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="memberAccountLogTableData.data" size="large" v-loading="memberAccountLogTableData.loading">

                    <template #empty>
                        <span>{{ !memberAccountLogTableData.loading ? t('emptyData') : '' }}</span>
                    </template>

                    <el-table-column prop="member_id" :label="t('memberId')" min-width="80" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            {{ row.member.member_no }}
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('memberInfo')" min-width="150" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div class="flex items-center cursor-pointer" @click="toMember(row.member_id)">
                                <img class="w-[50px] h-[50px] mr-[10px]" v-if="row.member.headimg" :src="img(row.member.headimg)" alt="">
                                <img class="w-[50px] h-[50px] mr-[10px] rounded-full" v-else src="@/app/assets/images/member_head.png" alt="">
                                <div class="flex flex-col">
                                    <span>{{ row.member.nickname || '' }}</span>
                                </div>
                            </div>
                        </template>
                    </el-table-column>
                    <el-table-column prop="mobile" :label="t('mobile')" min-width="100">
                        <template #default="{ row }">
                            {{ row.member.mobile || '' }}
                        </template>
                    </el-table-column>

                    <el-table-column prop="account_data" :label="t('accountData')" min-width="80" align="right">
                        <template #default="{ row }">
                            <span v-if="row.account_data >= 0">+{{ row.account_data }}</span>
                            <span v-else>{{ row.account_data }}</span>
                        </template>
                    </el-table-column>

                    <el-table-column prop="account_sum" :label="t('accountSum')" min-width="120" align="right" />
                    <el-table-column prop="from_type_name" :label="t('fromType')" min-width="180" align="center" />
                    <el-table-column prop="create_time" :show-overflow-tooltip="true" :label="t('createTime')" min-width="150" />

                    <el-table-column :label="t('operation')" align="right" fixed="right" width="100">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="infoEvent(row)">{{ t('info') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="memberAccountLogTableData.page"
                        v-model:page-size="memberAccountLogTableData.limit" layout="total, sizes, prev, pager, next, jumper"
                        :total="memberAccountLogTableData.total" @size-change="loadMemberAccountLogList()"
                        @current-change="loadMemberAccountLogList" />
                </div>
            </div>
        </el-card>

        <money-info ref="moneyDialog" @complete="loadMemberAccountLogList" />

    </div>
</template>

<script lang="ts" setup>
import { reactive, ref } from 'vue'
import { t } from '@/lang'
import { FormInstance } from 'element-plus'
import { getChangeTypeList, getCommissionList, getCommissionSum } from '@/app/api/member'
import { img } from '@/utils/common'
import moneyInfo from '@/app/views/member/components/member-commission-info.vue'
import { useRouter, useRoute } from 'vue-router'

const route = useRoute()
const pageName = route.meta.title

const member_id: number = parseInt(route.query.id || 0)

const memberAccountLogTableData = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        keywords: '',
        from_type: '',
        create_time: '',
        mobile: '',
        member_id
    }
})

const fromTypeList = ref([])

const setFromTypeList = async () => {
    fromTypeList.value = await (await getChangeTypeList('commission')).data
}

setFromTypeList()

/**
 * 获取佣金总计
 */
const commissionStatistics = ref([])
const checkCommissionInfo = () => {
    getCommissionSum({
        member_id
    }).then(res => {
        commissionStatistics.value = res.data
    })
}
checkCommissionInfo()

const searchFormRef = ref<FormInstance>()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadMemberAccountLogList()
}

/**
 *
 * 获取会员账单表列表
 */
const loadMemberAccountLogList = (page: number = 1) => {
    memberAccountLogTableData.loading = true
    memberAccountLogTableData.page = page

    getCommissionList({
        page: memberAccountLogTableData.page,
        limit: memberAccountLogTableData.limit,
        ...memberAccountLogTableData.searchParam
    }).then(res => {
        memberAccountLogTableData.loading = false
        memberAccountLogTableData.data = res.data.data
        memberAccountLogTableData.total = res.data.total
    }).catch(() => {
        memberAccountLogTableData.loading = false
    })
}
loadMemberAccountLogList()

const moneyDialog: Record<string, any> | null = ref(null)

/**
 * 查看详情
 * @param data
 */
const infoEvent = (data: any) => {
    moneyDialog.value.setFormData(data)
    moneyDialog.value.showDialog = true
}

const router = useRouter()

/**
 * 会员详情
 */
const toMember = (member_id: number) => {
    router.push(`/member/detail?id=${member_id}`)
}

</script>

<style lang="scss" scoped></style>
