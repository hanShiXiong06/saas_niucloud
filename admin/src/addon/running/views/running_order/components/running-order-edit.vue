<template>
  <el-dialog
    v-model="showDialog"
    :title="t('editRunningOrder')"
    width="800px"
    :close-on-click-modal="false"
    @close="closeDialog"
  >
    <el-form
      ref="formRef"
      :model="formData"
      :rules="rules"
      label-width="120px"
      class="running-order-edit"
    >
      <!-- 只读信息展示 -->
      <el-card class="mb-4">
        <template #header>
          <div class="card-header">
            <span class="title">订单基本信息</span>
          </div>
        </template>
        <el-descriptions :column="2" border>
          <el-descriptions-item label="订单编号">{{ formData.order_no }}</el-descriptions-item>
          <el-descriptions-item label="下单时间">{{ formData.create_time }}</el-descriptions-item>
          <el-descriptions-item label="校区">{{
            getSchoolInfo(formData.school_id).name
          }}</el-descriptions-item>
          <el-descriptions-item label="用户手机">{{
            getUserInfo(formData.member_id).mobile
          }}</el-descriptions-item>
          <el-descriptions-item label="订单类型">
            <el-tag size="small">
              {{ typeName }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="订单金额">
            <span class="text-red-500">￥{{ formData.amount }}</span>
          </el-descriptions-item>
        </el-descriptions>
      </el-card>

      <!-- 商品信息（只读） -->
      <el-card class="mb-4">
        <template #header>
          <div class="card-header">
            <span class="title">商品信息</span>
          </div>
        </template>
        <el-table :data="formData.runningOrderProduct" border style="width: 100%">
          <el-table-column prop="name" label="商品名称" />
          <el-table-column prop="price" label="单价" width="120">
            <template #default="{ row }">￥{{ row.price }}</template>
          </el-table-column>
          <el-table-column prop="num" label="数量" width="100" />
          <el-table-column prop="code" label="取件码" width="120" />
          <el-table-column prop="express_name" label="快递公司" width="120" />
        </el-table>
      </el-card>

      <!-- 可编辑信息 -->
      <el-card class="mb-4">
        <template #header>
          <div class="card-header">
            <span class="title">配送信息</span>
          </div>
        </template>
        <el-form-item :label="t('pickupAddress')" prop="pickup_address">
          <el-input
            v-model="formData.pickup_address"
            :placeholder="t('pickupAddressPlaceholder')"
          />
        </el-form-item>
        <el-form-item :label="t('pickupName')" prop="pickup_name">
          <el-input v-model="formData.pickup_name" :placeholder="t('pickupNamePlaceholder')" />
        </el-form-item>
        <el-form-item :label="t('pickupMobile')" prop="pickup_mobile">
          <el-input v-model="formData.pickup_mobile" :placeholder="t('pickupMobilePlaceholder')" />
        </el-form-item>
        <el-form-item :label="t('deliveryAddress')" prop="delivery_address">
          <el-input
            v-model="formData.delivery_address"
            :placeholder="t('deliveryAddressPlaceholder')"
          />
        </el-form-item>
        <el-form-item :label="t('contactName')" prop="contact_name">
          <el-input v-model="formData.contact_name" :placeholder="t('contactNamePlaceholder')" />
        </el-form-item>
        <el-form-item :label="t('contactMobile')" prop="contact_mobile">
          <el-input
            v-model="formData.contact_mobile"
            :placeholder="t('contactMobilePlaceholder')"
          />
        </el-form-item>
        <el-form-item :label="t('remark')" prop="remark">
          <el-input v-model="formData.remark" :placeholder="t('remarkPlaceholder')" />
        </el-form-item>
      </el-card>

      <!-- 订单状态和骑手信息 -->
      <el-card>
        <template #header>
          <div class="card-header">
            <span class="title">订单状态</span>
          </div>
        </template>

        <el-form-item :label="t('status')" prop="status">
          <el-select v-model="formData.status" :placeholder="t('statusPlaceholder')">
            <el-option
              v-for="(item, index) in statusList"
              :key="index"
              :label="item.name"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item :label="t('riderId')" prop="rider_id">
          <el-select v-model="formData.rider_id" :placeholder="t('riderIdPlaceholder')" clearable>
            <el-option
              v-for="(item, index) in riderIdList"
              :key="index"
              :label="item.real_name"
              :value="item.member_id"
            />
          </el-select>
        </el-form-item>
      </el-card>
    </el-form>
    <template #footer>
      <el-button @click="closeDialog">{{ t('cancel') }}</el-button>
      <el-button type="primary" @click="submitForm(formRef)">{{ t('confirm') }}</el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { editRunningOrder } from '@/addon/running/api/running_order'

import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import { ElMessage } from 'element-plus'
import { computed, defineComponent, ref } from 'vue'

defineComponent({
  name: 'RunningOrderEdit'
})

interface OrderProduct {
  id: number
  name: string
  price: string
  num: number
  code: string
  express_name: string
  order_id: number
  site_id: number
}

interface OrderInfo {
  id: number
  site_id: number
  school_id: number
  order_no: string
  member_id: number
  rider_id: number
  type: number
  status: number
  amount: string
  delivery_fee: string
  commission_rate: string
  commission_amount: string
  pickup_address: string
  pickup_name: string
  pickup_mobile: string
  delivery_address: string
  contact_name: string
  contact_mobile: string
  remark: string
  create_time: string
  update_time: string
  school_id_name: string
  member_id_name: string
  runningOrderProduct: OrderProduct[]
  runningRider: {
    real_name: string
    member_id: number
    mobile: string
  }
}

interface MemberItem {
  id: number
  username: string
  mobile: string
}

interface SchoolItem {
  id: number
  name: string
}

const props = defineProps<{
  memberIdList: MemberItem[]
  riderIdList: MemberItem[]
  schoolIdList: SchoolItem[]
  statusList: any[]
  typeList: any[]
}>()

const emit = defineEmits<{
  (e: 'complete'): void
}>()

// 获取字典数据
// const typeList = ref([])
// const typeDictList = async () => {
//   typeList.value = await (await useDictionary('school_business_type')).data.dictionary
// }
// typeDictList()
// watch(
//   () => typeList.value,
//   () => {
//     formData.value.type = typeList.value[0].value
//   }
// )

const typeName = computed(() => {
  console.log(props.typeList)
  return props.typeList.find((item) => item.value == formData.value.type)?.name || '其他'
})

const showDialog = ref(false)
const formRef = ref<FormInstance>()

const formData = ref<OrderInfo>({
  id: 0,
  site_id: 0,
  school_id: 0,
  order_no: '',
  member_id: 0,
  rider_id: 0,
  type: 1,
  status: 1,
  amount: '0.00',
  delivery_fee: '0.00',
  commission_rate: '0.00',
  commission_amount: '0.00',
  pickup_address: '',
  pickup_name: '',
  pickup_mobile: '',
  delivery_address: '',
  contact_name: '',
  contact_mobile: '',
  remark: '',
  create_time: '',
  update_time: '',
  school_id_name: '',
  member_id_name: '',
  runningOrderProduct: [],
  runningRider: {
    real_name: '',
    member_id: 0,
    mobile: ''
  }
})

const rules = {
  pickup_address: [{ required: true, message: t('pickupAddressRequired'), trigger: 'blur' }],
  pickup_name: [{ required: true, message: t('pickupNameRequired'), trigger: 'blur' }],
  pickup_mobile: [{ required: true, message: t('pickupMobileRequired'), trigger: 'blur' }],
  delivery_address: [{ required: true, message: t('deliveryAddressRequired'), trigger: 'blur' }],
  contact_name: [{ required: true, message: t('contactNameRequired'), trigger: 'blur' }],
  contact_mobile: [{ required: true, message: t('contactMobileRequired'), trigger: 'blur' }],
  status: [{ required: true, message: t('statusRequired'), trigger: 'change' }]
}

// 获取用户信息
const getUserInfo = (memberId: number) => {
  return props.memberIdList.find((item) => item.id === memberId) || { username: '', mobile: '' }
}

// 获取学校信息
const getSchoolInfo = (schoolId: number) => {
  return props.schoolIdList.find((item) => item.id === schoolId) || { name: '' }
}

// 设置表单数据
const setFormData = (data: OrderInfo) => {
  formData.value = { ...data }
  showDialog.value = true
}

// 提交表单
const submitForm = async (formEl: FormInstance | undefined) => {
  if (!formEl) return
  await formEl.validate(async (valid) => {
    if (valid) {
      try {
        await editRunningOrder(formData.value)
        ElMessage.success(t('updateSuccess'))
        closeDialog()
      } catch (error) {
        console.error('更新失败:', error)
      }
    }
  })
}

// 关闭弹窗
const closeDialog = () => {
  showDialog.value = false
  emit('complete')
}

defineExpose({
  setFormData
})
</script>

<style lang="scss" scoped>
.running-order-edit {
  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;

    .title {
      font-size: 16px;
      font-weight: 500;
      color: #1f2937;
    }
  }

  :deep(.el-descriptions__label) {
    width: 120px;
    background-color: #f9fafb;
  }

  :deep(.el-descriptions__content) {
    color: #1f2937;
  }

  .text-red-500 {
    color: #ef4444;
  }
}
</style>
