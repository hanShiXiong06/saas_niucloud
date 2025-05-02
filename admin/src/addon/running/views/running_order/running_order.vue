<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div class="flex justify-between items-center">
        <span class="text-lg">{{ pageName }}</span>
        <el-button type="primary" @click="addEvent">
          {{ t('addRunningOrder') }}
        </el-button>
      </div>

      <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
        <el-form :inline="true" :model="runningOrderTable.searchParam" ref="searchFormRef">
          <el-form-item :label="t('schoolId')" prop="school_id">
            <el-select class="w-[280px]" v-model="runningOrderTable.searchParam.school_id" clearable
              :placeholder="t('schoolIdPlaceholder')">
              <el-option v-for="(item, index) in schoolIdList" :key="index" :label="item['name']" :value="item['id']" />
            </el-select>
          </el-form-item>

          <el-form-item :label="t('orderNo')" prop="order_no">
            <el-input v-model="runningOrderTable.searchParam.order_no" :placeholder="t('orderNoPlaceholder')" />
          </el-form-item>

          <el-form-item :label="t('memberId')" prop="member_id">
            <el-select class="w-[280px]" v-model="runningOrderTable.searchParam.member_id" clearable
              :placeholder="t('memberIdPlaceholder')">
              <el-option v-for="(item, index) in memberIdList" :key="index" :label="item['username']"
                :value="item['member_id']" />
            </el-select>
          </el-form-item>

          <el-form-item :label="t('riderId')" prop="rider_id">
            <el-select class="w-[280px]" v-model="runningOrderTable.searchParam.rider_id" clearable
              :placeholder="t('riderIdPlaceholder')">
              <el-option v-for="(item, index) in riderIdList" :key="index" :label="item['username']"
                :value="item['member_id']" />
            </el-select>
          </el-form-item>

          <el-form-item :label="t('type')" prop="type">
            <el-select class="w-[280px]" v-model="runningOrderTable.searchParam.type" clearable
              :placeholder="t('typePlaceholder')">
              <el-option label="全部" value=""></el-option>
              <el-option v-for="(item, index) in typeList" :key="index" :label="item.name" :value="item.value" />
            </el-select>
          </el-form-item>

          <el-form-item :label="t('status')" prop="status">
            <el-select class="w-[280px]" v-model="runningOrderTable.searchParam.status" clearable
              :placeholder="t('statusPlaceholder')">
              <el-option label="全部" value=""></el-option>
              <el-option v-for="(item, index) in statusList" :key="index" :label="item.name" :value="item.value" />
            </el-select>
          </el-form-item>

          <el-form-item :label="t('amount')" prop="amount">
            <range-input v-model="runningOrderTable.searchParam.amount" />
          </el-form-item>

          <el-form-item :label="t('deliveryFee')" prop="delivery_fee">
            <range-input v-model="runningOrderTable.searchParam.delivery_fee" />
          </el-form-item>

          <el-form-item :label="t('commissionRate')" prop="commission_rate">
            <el-input v-model="runningOrderTable.searchParam.commission_rate"
              :placeholder="t('commissionRatePlaceholder')" />
          </el-form-item>
          <el-form-item :label="t('commissionAmount')" prop="commission_amount">
            <el-input v-model="runningOrderTable.searchParam.commission_amount"
              :placeholder="t('commissionAmountPlaceholder')" />
          </el-form-item>
          <el-form-item :label="t('pickupAddress')" prop="pickup_address">
            <el-input v-model="runningOrderTable.searchParam.pickup_address"
              :placeholder="t('pickupAddressPlaceholder')" />
          </el-form-item>
          <el-form-item :label="t('pickupName')" prop="pickup_name">
            <el-input v-model="runningOrderTable.searchParam.pickup_name" :placeholder="t('pickupNamePlaceholder')" />
          </el-form-item>
          <el-form-item :label="t('pickupMobile')" prop="pickup_mobile">
            <el-input v-model="runningOrderTable.searchParam.pickup_mobile"
              :placeholder="t('pickupMobilePlaceholder')" />
          </el-form-item>
          <el-form-item :label="t('deliveryAddress')" prop="delivery_address">
            <el-input v-model="runningOrderTable.searchParam.delivery_address"
              :placeholder="t('deliveryAddressPlaceholder')" />
          </el-form-item>
          <el-form-item :label="t('contactName')" prop="contact_name">
            <el-input v-model="runningOrderTable.searchParam.contact_name" :placeholder="t('contactNamePlaceholder')" />
          </el-form-item>
          <el-form-item :label="t('contactMobile')" prop="contact_mobile">
            <el-input v-model="runningOrderTable.searchParam.contact_mobile"
              :placeholder="t('contactMobilePlaceholder')" />
          </el-form-item>

          <el-form-item :label="t('createTime')" prop="create_time">
            <el-date-picker v-model="runningOrderTable.searchParam.create_time" type="datetimerange"
              format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="loadRunningOrderList()">{{ t('search') }}</el-button>
            <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <div class="mt-[10px]">
        <el-tabs v-model="runningOrderTable.searchParam.school_id" class="demo-tabs"
          @tab-change="loadRunningOrderList()">
          <el-tab-pane :label="t('全部校区')" name=""></el-tab-pane>
          <el-tab-pane v-for="item in schoolIdList" :key="item.id" :label="item.name" :name="item.id"></el-tab-pane>
        </el-tabs>

        <el-table :data="runningOrderTable.data" size="large" v-loading="runningOrderTable.loading">
          <template #empty>
            <span>{{ !runningOrderTable.loading ? t('emptyData') : '' }}</span>
          </template>

          <el-table-column prop="order_no" :label="t('orderNo')" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column prop="contact_name" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true">
            <template #default="{ row }">
              <el-tag v-if="row.contact_name" type="danger">
                <div>{{ row.contact_name }}</div>
              </el-tag>
              <div>{{ row.contact_mobile }}</div>
            </template>
          </el-table-column>

          <!-- <el-table-column
            prop="contact_mobile"
            :label="t('用户手机')"
            min-width="120"
            :show-overflow-tooltip="true"
          /> -->

          <el-table-column prop="rider_id_name" :label="t('接单骑手')" min-width="120" :show-overflow-tooltip="true">
            <template #default="{ row }">
              <el-tag v-if="row.rider_id_name" type="success">
                <div>{{ row.rider_id_name }}</div>
              </el-tag>
              <div>{{ row.rider_id_mobile }}</div>
            </template>
          </el-table-column>

          <el-table-column :label="t('type')" min-width="180" align="center" :show-overflow-tooltip="true">
            <template #default="{ row }">
              <div v-for="(item, index) in typeList">
                <div v-if="item.value == row.type">{{ item.name }}</div>
              </div>
            </template>
          </el-table-column>

          <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
            <template #default="{ row }">
              <div v-for="(item, index) in statusList">
                <el-tag v-if="item.value == row.status" :type="statusBg(item.value)">
                  <div>{{ item.name }}</div>
                </el-tag>
              </div>
            </template>
          </el-table-column>

          <el-table-column prop="create_time" :label="t('createTime')" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column :label="t('operation')" fixed="right" min-width="180">
            <template #default="{ row }">
              <!-- 查看详情 -->
              <el-button type="primary" size="small" link @click="viewEvent(row)">
                <i class="nc-iconfont nc-icon-chakanV6xx"></i>
              </el-button>
              <el-button size="small" link @click="editEvent(row)">
                <i class="nc-iconfont nc-icon-bianjiV6xx1"></i>
              </el-button>

              <el-button type="danger" size="small" @click="deleteEvent(row.id)">
                <el-icon :size="12" class="mr-[2px]">
                  <Delete />
                </el-icon>
              </el-button>
            </template>
          </el-table-column>
        </el-table>
        <div class="mt-[16px] flex justify-end">
          <el-pagination v-model:current-page="runningOrderTable.page" v-model:page-size="runningOrderTable.limit"
            layout="total, sizes, prev, pager, next, jumper" :total="runningOrderTable.total"
            @size-change="loadRunningOrderList()" @current-change="loadRunningOrderList" />
        </div>
      </div>

      <edit ref="editRunningOrderDialog" :memberIdList="memberIdList" :riderIdList="riderIdList"
        :schoolIdList="schoolIdList" :typeList="typeList" :statusList="statusList" @complete="loadRunningOrderList" />

      <running-order-view ref="viewRunningOrderDialog" :memberIdList="memberIdList" :riderIdList="riderIdList"
        :schoolIdList="schoolIdList" @complete="loadRunningOrderList" />
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import {
  deleteRunningOrder,
  getRunningOrderList,
  getWithMemberList,
  getWithRiderList,
  getWithRunningSchoolList
} from '@/addon/running/api/running_order'
import Edit from '@/addon/running/views/running_order/components/running-order-edit.vue'
import RunningOrderView from '@/addon/running/views/running_order/components/running-order-view.vue'

import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import { ElMessageBox, FormInstance } from 'element-plus'
import { reactive, ref } from 'vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title

const runningOrderTable = reactive({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    school_id: '',
    order_no: '',
    member_id: '',
    rider_id: '',
    type: '',
    status: '',
    amount: [],
    delivery_fee: [],
    commission_rate: '',
    commission_amount: '',
    pickup_address: '',
    pickup_name: '',
    pickup_mobile: '',
    delivery_address: '',
    contact_name: '',
    contact_mobile: '',
    remark: '',
    create_time: [],
    update_time: ''
  }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
const typeList = ref([] as any[])
const typeDictList = async () => {
  typeList.value = await (await useDictionary('school_business_type')).data.dictionary
}
typeDictList()
const statusList = ref([] as any[])
const statusDictList = async () => {
  statusList.value = await (await useDictionary('school_order_status')).data.dictionary
}
statusDictList()

/**
 * 获取订单状态背景色
 * @param value
 * @returns
 */
const statusBg = (value: string) => {
  switch (value) {
    case '1':
      return 'success'
    case '2':
      return 'warning'
    case '3':
      return 'danger'
    case '4':
      return 'info'
    case '5':
      return 'success'
    case '-1':
      return 'danger'
    default:
      return 'danger'
  }
}

/**
 * 获取订单列表
 */
const loadRunningOrderList = (page: number = 1) => {
  runningOrderTable.loading = true
  runningOrderTable.page = page

  getRunningOrderList({
    page: runningOrderTable.page,
    limit: runningOrderTable.limit,
    ...runningOrderTable.searchParam
  })
    .then((res) => {
      runningOrderTable.loading = false
      runningOrderTable.data = res.data.data
      runningOrderTable.total = res.data.total
    })
    .catch(() => {
      runningOrderTable.loading = false
    })
}
loadRunningOrderList()

const editRunningOrderDialog: Record<string, any> | null = ref(null)
const viewRunningOrderDialog: Record<string, any> | null = ref(null)

/**
 * 添加订单
 */
const addEvent = () => {
  editRunningOrderDialog.value.setFormData()
  editRunningOrderDialog.value.showDialog = true
}

/**
 * 编辑订单
 * @param data
 */
const editEvent = (data: any) => {
  editRunningOrderDialog.value.setFormData(data)
  editRunningOrderDialog.value.showDialog = true
}

/**
 * 查看详情
 * @param data
 */
const viewEvent = (data: any) => {
  viewRunningOrderDialog.value.setFormData(data)
  viewRunningOrderDialog.value.showDialog = true
}

/**
 * 删除订单
 */
const deleteEvent = (id: number) => {
  ElMessageBox.confirm(t('runningOrderDeleteTips'), t('warning'), {
    confirmButtonText: t('confirm'),
    cancelButtonText: t('cancel'),
    type: 'warning'
  }).then(() => {
    deleteRunningOrder(id)
      .then(() => {
        loadRunningOrderList()
      })
      .catch(() => { })
  })
}

const schoolIdList = ref<any[]>([])
const setSchoolIdList = async () => {
  schoolIdList.value = await (await getWithRunningSchoolList({})).data
}
setSchoolIdList()
const memberIdList = ref<any[]>([])
const riderIdList = ref<any[]>([])
const setMemberIdList = async () => {
  memberIdList.value = await (await getWithMemberList({})).data
}
setMemberIdList()

const setRiderIdList = async () => {
  try {
    const response = await getWithRiderList({})
    console.log('骑手数据原始响应:', response)

    if (response.data && Array.isArray(response.data)) {
      riderIdList.value = response.data
      console.log('成功设置骑手列表，数量:', riderIdList.value.length)
    } else {
      console.error('骑手数据不是数组格式:', response.data)
      riderIdList.value = []
    }
  } catch (error) {
    console.error('获取骑手列表失败:', error)
    riderIdList.value = []
  }
}
setRiderIdList()

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return
  formEl.resetFields()
  loadRunningOrderList()
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
