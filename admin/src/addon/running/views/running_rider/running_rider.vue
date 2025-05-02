<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div class="flex justify-between items-center">
        <span class="text-lg">{{ pageName }}</span>
        <el-button type="primary" @click="addEvent">
          {{ t('addRunningRider') }}
        </el-button>
      </div>

      <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
        <el-form :inline="true" :model="runningRiderTable.searchParam" ref="searchFormRef">
          <el-form-item :label="t('schoolId')" prop="school_id">
            <el-select class="w-[280px]" v-model="runningRiderTable.searchParam.school_id" clearable
              :placeholder="t('schoolIdPlaceholder')">
              <el-option v-for="(item, index) in schoolIdList" :key="index" :label="item['name']" :value="item['id']" />
            </el-select>
          </el-form-item>

          <!-- <el-form-item :label="t('memberId')" prop="member_id">
            <el-input v-model="runningRiderTable.searchParam.member_id" :placeholder="t('memberIdPlaceholder')" />
          </el-form-item> -->
          <el-form-item :label="t('realName')" prop="real_name">
            <el-input v-model="runningRiderTable.searchParam.real_name" :placeholder="t('realNamePlaceholder')" />
          </el-form-item>
          <el-form-item :label="t('idCard')" prop="id_card">
            <el-input v-model="runningRiderTable.searchParam.id_card" :placeholder="t('idCardPlaceholder')" />
          </el-form-item>
          <el-form-item :label="t('mobile')" prop="mobile">
            <el-input v-model="runningRiderTable.searchParam.mobile" :placeholder="t('mobilePlaceholder')" />
          </el-form-item>

          <el-form-item :label="t('status')" prop="status">
            <el-select class="w-[280px]" v-model="runningRiderTable.searchParam.status" clearable
              :placeholder="t('statusPlaceholder')">
              <el-option label="全部" value=""></el-option>
              <el-option v-for="(item, index) in statusList" :key="index" :label="item.name" :value="item.value" />
            </el-select>
          </el-form-item>

          <el-form-item :label="t('createTime')" prop="create_time">
            <el-date-picker v-model="runningRiderTable.searchParam.create_time" type="datetimerange"
              format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="loadRunningRiderList()">{{ t('search') }}</el-button>
            <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <el-tabs v-model="runningRiderTable.searchParam.status" @tab-change="loadRunningRiderList()">

        <el-tab-pane :label="item.name" :name="item.value" v-for="(item, index) in statusList"
          :key="index"></el-tab-pane>

      </el-tabs>

      <div class="mt-[10px]">
        <el-table :data="runningRiderTable.data" size="large" v-loading="runningRiderTable.loading">
          <template #empty>
            <span>{{ !runningRiderTable.loading ? t('emptyData') : '' }}</span>
          </template>
          <el-table-column prop="school_id_name" :label="t('schoolId')" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column prop="real_name" :label="t('realName')" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column prop="id_card" :label="t('idCard')" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column prop="mobile" :label="t('mobile')" min-width="120" :show-overflow-tooltip="true" />


          <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
            <template #default="{ row }">
              <div v-for="(item, index) in statusList">
                <div v-if="item.value == row.status">{{ item.name }}</div>
              </div>
            </template>
          </el-table-column>
          <!-- 
          <el-table-column
            prop="balance"
            :label="t('balance')"
            min-width="120"
            :show-overflow-tooltip="true"
          /> -->

          <!-- <el-table-column prop="total_income" :label="t('totalIncome')" min-width="120"
            :show-overflow-tooltip="true" /> -->

          <el-table-column prop="create_time" :label="t('createTime')" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column :label="t('operation')" fixed="right" min-width="120">
            <template #default="{ row }">
              <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
              <el-button type="primary" link @click="deleteEvent(row.id)">{{
                t('delete')
              }}</el-button>
            </template>
          </el-table-column>
        </el-table>
        <div class="mt-[16px] flex justify-end">
          <el-pagination v-model:current-page="runningRiderTable.page" v-model:page-size="runningRiderTable.limit"
            layout="total, sizes, prev, pager, next, jumper" :total="runningRiderTable.total"
            @size-change="loadRunningRiderList()" @current-change="loadRunningRiderList" />
        </div>
      </div>

      <edit ref="editRunningRiderDialog" @complete="loadRunningRiderList" />
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import {
  deleteRunningRider,
  getRunningRiderList,
  getWithMemberList,
  getWithRunningSchoolList
} from '@/addon/running/api/running_rider'
import Edit from '@/addon/running/views/running_rider/components/running-rider-edit.vue'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance } from 'element-plus'
import { reactive, ref } from 'vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title

const runningRiderTable = reactive({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    school_id: '',
    member_id: '',
    real_name: '',
    id_card: '',
    mobile: '',
    status: '0',
    create_time: []
  }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
const statusList = ref([] as any[])
const statusDictList = async () => {
  statusList.value = await (await useDictionary('rider_status')).data.dictionary
}
statusDictList()

/**
 * 获取跑腿员列表
 */
const loadRunningRiderList = (page: number = 1) => {
  runningRiderTable.loading = true
  runningRiderTable.page = page

  getRunningRiderList({
    page: runningRiderTable.page,
    limit: runningRiderTable.limit,
    ...runningRiderTable.searchParam
  })
    .then((res) => {
      runningRiderTable.loading = false
      runningRiderTable.data = res.data.data
      runningRiderTable.total = res.data.total
    })
    .catch(() => {
      runningRiderTable.loading = false
    })
}
loadRunningRiderList()

const editRunningRiderDialog: Record<string, any> | null = ref(null)

/**
 * 添加跑腿员
 */
const addEvent = () => {
  editRunningRiderDialog.value.setFormData()
  editRunningRiderDialog.value.showDialog = true
}

/**
 * 编辑跑腿员
 * @param data
 */
const editEvent = (data: any) => {
  editRunningRiderDialog.value.setFormData(data)
  editRunningRiderDialog.value.showDialog = true
}

/**
 * 删除跑腿员
 */
const deleteEvent = (id: number) => {
  ElMessageBox.confirm(t('runningRiderDeleteTips'), t('warning'), {
    confirmButtonText: t('confirm'),
    cancelButtonText: t('cancel'),
    type: 'warning'
  }).then(() => {
    deleteRunningRider(id)
      .then(() => {
        loadRunningRiderList()
      })
      .catch(() => { })
  })
}

const schoolIdList = ref([])
const setSchoolIdList = async () => {
  schoolIdList.value = await (await getWithRunningSchoolList({})).data
}
setSchoolIdList()
const memberIdList = ref([])
const setMemberIdList = async () => {
  memberIdList.value = await (await getWithMemberList({})).data
}
setMemberIdList()
const mobileList = ref([])
const setMobileList = async () => {
  mobileList.value = await (await getWithMemberList({})).data
}
setMobileList()

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return
  formEl.resetFields()
  loadRunningRiderList()
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
