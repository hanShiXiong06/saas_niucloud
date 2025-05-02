<template>
  <el-dialog v-model="showDialog" :title="t('viewRunningOrder')" width="800px" :close-on-click-modal="false"
    @close="closeDialog">
    <div class="running-order-view">
      <!-- 订单基本信息 -->
      <el-card class="mb-4">
        <template #header>
          <div class="card-header">
            <span class="title">订单信息</span>
            <el-tag :type="getStatusType(orderInfo.status)">{{
              getStatusText(orderInfo.status)
              }}</el-tag>
          </div>
        </template>
        <el-descriptions :column="2" border>
          <el-descriptions-item label="订单编号">{{ orderInfo.order_no }}</el-descriptions-item>
          <el-descriptions-item label="下单时间">{{ orderInfo.create_time }}</el-descriptions-item>
          <el-descriptions-item label="校区">{{
            getSchoolInfo(orderInfo.school_id).name
            }}</el-descriptions-item>
          <el-descriptions-item label="用户手机">{{
            getUserInfo(orderInfo.member_id).mobile
            }}</el-descriptions-item>
          <el-descriptions-item label="订单类型">
            <el-tag size="small">{{ orderInfo.type === 1 ? '快递代取' : '其他' }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="订单金额">
            <span class="text-red-500">￥{{ orderInfo.amount }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="骑手昵称">
            <span>{{ orderInfo.rider_id ? (getRiderInfo(orderInfo.rider_id).nickname || '未分配') : '未分配' }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="骑手手机">
            <span>{{ orderInfo.rider_id ? (getRiderInfo(orderInfo.rider_id).mobile || '未分配') : '未分配' }}</span>
          </el-descriptions-item>
        </el-descriptions>
      </el-card>

      <!-- 商品信息 -->
      <el-card class="mb-4">
        <template #header>
          <div class="card-header">
            <span class="title">商品信息</span>
          </div>
        </template>
        <el-table :data="orderInfo.runningOrderProduct" border style="width: 100%">
          <el-table-column prop="name" label="商品名称" />
          <el-table-column prop="price" label="单价" width="120">
            <template #default="{ row }"> ￥{{ row.price }} </template>
          </el-table-column>
          <el-table-column prop="num" label="数量" width="100" />
          <el-table-column prop="code" label="取件码" width="120" />
          <el-table-column prop="express_name" label="快递公司" width="120" />
        </el-table>
      </el-card>

      <!-- 配送信息 -->
      <el-card class="mb-4">
        <template #header>
          <div class="card-header">
            <span class="title">配送信息</span>
          </div>
        </template>
        <el-descriptions :column="1" border>
          <el-descriptions-item label="取件地址">
            <div class="address-info">
              <p>{{ orderInfo.pickup_name }} {{ orderInfo.pickup_mobile }}</p>
              <p class="text-gray-500">{{ orderInfo.pickup_address || '无' }}</p>
            </div>
          </el-descriptions-item>
          <el-descriptions-item label="送达地址">
            <div class="address-info">
              <p>{{ orderInfo.contact_name }} {{ orderInfo.contact_mobile }}</p>
              <p class="text-gray-500">{{ orderInfo.delivery_address }}</p>
            </div>
          </el-descriptions-item>
          <el-descriptions-item label="备注">
            <span class="text-gray-500">{{ orderInfo.remark || '无' }}</span>
          </el-descriptions-item>
        </el-descriptions>
      </el-card>

      <!-- 费用信息 -->
      <el-card>
        <template #header>
          <div class="card-header">
            <span class="title">费用信息</span>
          </div>
        </template>
        <el-descriptions :column="1" border>
          <el-descriptions-item label="商品总额">
            <span class="text-right">￥{{ getProductTotal() }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="配送费">
            <span class="text-right">￥{{ orderInfo.delivery_fee }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="佣金比例">
            <span class="text-right">{{ orderInfo.commission_rate }}%</span>
          </el-descriptions-item>
          <el-descriptions-item label="佣金金额">
            <span class="text-right">￥{{ orderInfo.commission_amount }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="实付金额">
            <span class="text-right text-red-500 font-bold">￥{{ orderInfo.amount }}</span>
          </el-descriptions-item>
        </el-descriptions>
      </el-card>
    </div>
    <template #footer>
      <el-button @click="closeDialog">{{ t('close') }}</el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { t } from '@/lang'
import { defineComponent, ref } from 'vue'

defineComponent({
  name: 'RunningOrderView'
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
    nickname: string
    member_id: number
    mobile: string
  }
}

interface MemberItem {
  id: number
  member_id?: number
  nickname: string
  username?: string
  real_name?: string
  mobile: string
  headimg?: string
}

interface SchoolItem {
  id: number
  name: string
}

const props = defineProps<{
  memberIdList: MemberItem[]
  riderIdList: MemberItem[]
  schoolIdList: SchoolItem[]
}>()

const emit = defineEmits<{
  (e: 'complete'): void
}>()

const showDialog = ref(false)
const orderInfo = ref<OrderInfo>({
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
    nickname: '',
    member_id: 0,
    mobile: ''
  }
})

// 获取状态类型
const getStatusType = (status: number) => {
  const statusMap: Record<number, string> = {
    1: 'warning', // 待付款
    2: 'info', // 待接单
    3: 'primary', // 已接单
    4: 'success', // 配送中
    5: 'success', // 已完成
    '-1': 'danger' // 已取消
  }
  return statusMap[status] || 'info'
}

// 获取状态文本
const getStatusText = (status: number) => {
  const statusMap: Record<number, string> = {
    1: '待付款',
    2: '待接单',
    3: '已接单',
    4: '配送中',
    5: '已完成',
    '-1': '已取消'
  }
  return statusMap[status] || '未知状态'
}

// 计算商品总额
const getProductTotal = () => {
  if (!orderInfo.value.runningOrderProduct?.length) return '0.00'

  const total = orderInfo.value.runningOrderProduct.reduce((sum: number, item: OrderProduct) => {
    return sum + parseFloat(item.price) * item.num
  }, 0)

  return total.toFixed(2)
}

// 获取用户信息
const getUserInfo = (memberId: number) => {
  return props.memberIdList.find(item => item.id === memberId) || { nickname: '', mobile: '' }
}

// 获取骑手信息
const getRiderInfo = (riderId: number) => {
  if (!props.riderIdList || !Array.isArray(props.riderIdList)) {
    console.error('riderIdList不是有效数组:', props.riderIdList)
    return { nickname: '', mobile: '' }
  }

  // 打印骑手列表和当前骑手ID，帮助调试
  console.log('骑手列表数据:', props.riderIdList, '当前骑手ID:', riderId)

  const rider = props.riderIdList.find(item => {
    // 检查item.id是否存在且匹配riderId
    return item && (item.id === riderId || item.member_id === riderId)
  })

  if (!rider) {
    console.log('未找到匹配的骑手信息，ID:', riderId)
    return { nickname: '', mobile: '' }
  }

  // 返回骑手信息，使用可能的属性名
  return {
    nickname: rider.nickname || rider.username || rider.real_name || '',
    mobile: rider.mobile || ''
  }
}

// 获取学校信息
const getSchoolInfo = (schoolId: number) => {
  return props.schoolIdList.find(item => item.id === schoolId) || { name: '' }
}

// 设置表单数据
const setFormData = (data: OrderInfo) => {
  orderInfo.value = { ...data }
  showDialog.value = true
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
.running-order-view {
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

  .address-info {
    p {
      margin: 4px 0;

      &:first-child {
        color: #1f2937;
        font-weight: 500;
      }
    }
  }

  :deep(.el-descriptions__label) {
    width: 120px;
    background-color: #f9fafb;
  }

  :deep(.el-descriptions__content) {
    color: #1f2937;
  }

  .text-right {
    text-align: right;
  }

  .text-red-500 {
    color: #ef4444;
  }

  .text-gray-500 {
    color: #6b7280;
  }

  .font-bold {
    font-weight: 600;
  }
}
</style>
