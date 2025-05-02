<template>
  <view class="min-h-screen bg-gray-50">
    <!-- 顶部选项卡 -->
    <view class="sticky top-0 z-10 bg-white shadow-sm px-4 py-3">
      <view class="flex w-3/5 mx-auto bg-[#E5E5E5] rounded-full p-0.5">
        <view class="flex-1 text-center py-2 px-4 rounded-full text-sm transition-all duration-300"
          :class="activeTab === 'waiting' ? 'bg-[#007AFF] text-white font-bold' : 'text-gray-600'"
          @click="switchTab('waiting')">
          待接单
        </view>
        <view class="flex-1 text-center py-2 px-4 rounded-full text-sm transition-all duration-300"
          :class="activeTab === 'my' ? 'bg-[#007AFF] text-white font-bold' : 'text-gray-600'" @click="switchTab('my')">
          我的订单
        </view>
      </view>
    </view>

    <!-- 订单列表 -->
    <scroll-view scroll-y refresher-enabled :refresher-triggered="refresherTriggered" @refresherrefresh="onRefresh"
      class="px-4 pb-safe box-border" style="height: calc(100vh - 80rpx);">
      <!-- 待接单选项卡 -->
      <template v-if="activeTab === 'waiting'">
        <!-- 空状态 -->
        <view v-if="orderList.length === 0 && !loading" class="flex flex-col items-center justify-center py-20">
          <view class="text-gray-400 text-lg mt-4">暂无待接单任务</view>
        </view>

        <!-- 加载状态 -->
        <view v-if="loading" class="flex flex-col items-center justify-center py-10">
          <view class="w-10 h-10 border-2 border-[#007AFF] border-t-transparent rounded-full animate-spin"></view>
          <view class="text-[#333333] text-sm mt-3">加载中...</view>
        </view>

        <!-- 订单列表 -->
        <view v-for="(item, index) in orderList" :key="index" class="bg-white rounded-lg shadow-sm p-4 mb-3 box-border"
          @click="viewOrderDetail(item)">
          <!-- 订单头部 -->
          <view class="flex justify-between items-center pb-3 border-b border-[#E5E5E5]">
            <view class="flex items-center text-gray-600 text-sm">
              <view class="mr-2 px-2 py-0.5 text-xs rounded text-white"
                :class="item.type === 1 ? 'bg-[#FF9500]' : 'bg-[#007AFF]'">
                {{ getOrderTypeText(item.type) }}
              </view>
              订单号: {{ item.order_no }}
            </view>
            <view class="text-[#007AFF] font-medium text-sm">{{ getOrderStatusText(item.status) }}</view>
          </view>

          <!-- 订单内容 -->
          <view class="py-3">
            <view class="font-medium text-[#333333] mb-2">{{ item.school_id_name }}</view>

            <!-- 地址信息 -->
            <view class="text-sm text-[#333333] mb-3 leading-relaxed">
              <view v-if="item.type === 1">
                <view v-if="item.pickup_address" class="mb-1">
                  <text class="text-[#333333]">取件地点: </text>
                  <text>{{ item.pickup_address || '无' }}</text>
                </view>
                <view>
                  <text class="text-[#333333]">送至: </text>
                  <text>{{ item.delivery_address }}</text>
                </view>
              </view>
              <view v-else>
                <text class="text-[#333333]">配送地址: </text>
                <text>{{ item.delivery_address }}</text>
              </view>
            </view>

            <!-- 联系人信息 -->
            <view class="text-sm text-[#333333] mb-2">
              <text class="text-[#333333]">联系人: </text>
              <text>{{ item.contact_name }} {{ item.contact_mobile }}</text>
            </view>

            <!-- 商品信息 -->
            <view v-if="item.runningOrderProduct && item.runningOrderProduct.length > 0"
              class="text-xs text-[#333333] mb-2">
              <view v-for="(product, pIndex) in item.runningOrderProduct" :key="pIndex" class="mb-1">
                {{ product.name }} x{{ product.num }}
              </view>
            </view>

            <!-- 下单时间 -->
            <view class="text-xs text-gray-400">
              <text>下单时间: </text>
              <text>{{ item.create_time }}</text>
            </view>
          </view>

          <!-- 订单底部 -->
          <view class="flex justify-between items-center pt-3 border-t border-[#E5E5E5]">
            <view class="text-sm">
              <text class="text-gray-600">订单金额: </text>
              <text class="text-red-500 font-bold">￥{{ parseFloat(item.amount) + parseFloat(item.delivery_fee) }}</text>
              |
              <text class="text-gray-600">佣金: </text>
              <text class="text-red-500 font-bold">￥{{ parseFloat(item.amount) * 0.9 }}</text>
            </view>
            <view>
              <button
                class="bg-[#007AFF] text-white text-sm py-1 px-4 rounded-full hover:bg-blue-600 active:bg-blue-700 transition-colors"
                @click.stop="handleAcceptOrder(item)">
                接单
              </button>
            </view>
          </view>
        </view>
      </template>

      <!-- 我的订单选项卡 -->
      <template v-else>
        <!-- 空状态 -->
        <view v-if="myOrderList.length === 0 && !loading" class="flex flex-col items-center justify-center py-20">
          <view class="text-gray-400 text-lg mt-4">暂无接单记录</view>
        </view>

        <!-- 加载状态 -->
        <view v-if="loading" class="flex flex-col items-center justify-center py-10">
          <view class="w-10 h-10 border-2 border-[#007AFF] border-t-transparent rounded-full animate-spin"></view>
          <view class="text-[#333333] text-sm mt-3">加载中...</view>
        </view>

        <!-- 订单列表 -->
        <view v-for="(item, index) in myOrderList" :key="index"
          class="bg-white rounded-lg shadow-sm p-2 mb-3 box-border" @click="viewOrderDetail(item)">
          <!-- 订单头部 -->
          <view class="flex justify-between items-center pb-3 border-b border-[#E5E5E5]">
            <view class="flex items-center text-gray-600 text-sm">
              <view class="mr-2 px-2 py-0.5 text-xm rounded text-white"
                :class="item.type === 1 ? 'bg-[#FF9500]' : 'bg-[#007AFF]'">
                {{ getOrderTypeText(item.type) }}
              </view>
              订单号: {{ item.order_no }}
            </view>
            <view class="font-medium text-sm" :class="{
              'text-[#007AFF]': item.status === 3,
              'text-green-500': item.status === 4,
              'text-purple-500': item.status === 5,
              'text-[#333333]': item.status === -1
            }">
              {{ getOrderStatusText(item.status) }}
            </view>
          </view>

          <!-- 订单内容 -->
          <view class="py-3">
            <view class="font-medium text-[#333333] mb-2">{{ item.school_id_name }}</view>

            <!-- 地址信息 -->
            <view class="text-sm text-[#333333] mb-3 leading-relaxed">
              <view v-if="item.type === 1">
                <view v-if="item.pickup_address" class="mb-1">
                  <text class="text-[#333333]">取件地点: </text>
                  <text>{{ item.pickup_address || '无' }}</text>
                </view>
                <view>
                  <text class="text-[#333333]">送至: </text>
                  <text>{{ item.delivery_address }}</text>
                </view>
              </view>
              <view v-else>
                <text class="text-[#333333]">配送地址: </text>
                <text>{{ item.delivery_address }}</text>
              </view>
            </view>

            <!-- 联系人信息 -->
            <view class="text-sm text-[#333333] mb-2">
              <text class="text-[#333333]">联系人: </text>
              <text>{{ item.contact_name }} {{ item.contact_mobile }}</text>
            </view>

            <!-- 商品信息 -->
            <view v-if="item.runningOrderProduct && item.runningOrderProduct.length > 0"
              class="text-xs text-[#333333] mb-2">
              <view v-for="(product, pIndex) in item.runningOrderProduct" :key="pIndex" class="mb-1">
                {{ product.name }} x{{ product.num }}
              </view>
            </view>

            <!-- 下单时间 -->
            <view class="text-xs text-gray-400">
              <text>下单时间: </text>
              <text>{{ item.create_time }}</text>
            </view>
          </view>

          <!-- 订单底部 -->
          <view class="flex justify-between items-center pt-3 border-t border-[#E5E5E5]">
            <view class="text-sm">
              <text class="text-gray-600">订单金额: </text>
              <text class="text-red-500 font-bold">￥{{ parseFloat(item.amount) + parseFloat(item.delivery_fee) }}</text>
              |
              <text class="text-gray-600">佣金: </text>
              <text class="text-red-500 font-bold">￥{{ parseFloat(item.amount) * 0.9 }}</text>
            </view>
            <view class="flex">
              <!-- 已接单状态 -->
              <template v-if="item.status === 3">
                <button class="mr-2 bg-red-500 text-white text-xs py-1 px-3 rounded-full"
                  @click.stop="handleCancelOrder(item)">
                  取消接单
                </button>
                <button class="bg-[#007AFF] text-white text-xs py-1 px-3 rounded-full"
                  @click.stop="handleStartDelivery(item)">
                  开始配送
                </button>
              </template>

              <!-- 配送中状态 -->
              <button v-if="item.status === 4" class="bg-green-500 text-white text-xs py-1 px-3 rounded-full"
                @click.stop="handleCompleteOrder(item)">
                完成订单
              </button>
            </view>
          </view>
        </view>
      </template>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import {
  acceptOrder,
  cancelOrder,
  completeOrder,
  getOrderList,
  getHallList,
  startDelivery
} from '@/addon/running/api/rider'
import { redirect } from '@/utils/common'
import { onPullDownRefresh, onShow } from '@dcloudio/uni-app'
import { onMounted, ref } from 'vue'

// 产品类型
interface Product {
  name: string
  price: number
  num: number
}

// 订单项类型
interface OrderItem {
  id: number
  order_no: string
  status: number
  type: number
  school_id: number
  school_id_name: string
  amount: string
  delivery_fee: string
  pickup_address?: string
  pickup_name?: string
  pickup_mobile?: string
  delivery_address: string
  contact_name: string
  contact_mobile: string
  create_time: string
  runningOrderProduct: Product[]
}

// API响应类型
interface ApiResponse<T> {
  code: number
  msg: string
  data: T
}

// 分页数据类型
interface PageData<T> {
  total: number
  per_page: number
  current_page: number
  last_page: number
  data: T[]
}

// 订单状态
const orderStatusMap: Record<string | number, string> = {
  1: '待支付',
  2: '待接单',
  3: '已接单',
  4: '配送中',
  5: '已完成',
  '-1': '已关闭'
}

const activeTab = ref('waiting') // 当前激活的选项卡: waiting-待接单, my-我的订单
const refresherTriggered = ref(false) // 下拉刷新状态
const orderList = ref<OrderItem[]>([]) // 待接单列表
const myOrderList = ref<OrderItem[]>([]) // 我的订单列表
const currentSchoolId = ref(1) // 当前学校ID
const loading = ref(false) // 加载状态

// 切换选项卡
const switchTab = (tab: string) => {
  activeTab.value = tab
  loadData()
}

// 获取订单状态文本
const getOrderStatusText = (status: number | string) => {
  return orderStatusMap[status] || '未知状态'
}

// 接单
const handleAcceptOrder = async (item: OrderItem) => {
  try {
    uni.showLoading({ title: '处理中' })
    await acceptOrder({ id: item.id })
    uni.showToast({
      title: '接单成功',
      icon: 'success'
    })
    loadData()
  } catch (error) {
    uni.showToast({
      title: '接单失败',
      icon: 'none'
    })
  } finally {
    uni.hideLoading()
  }
}

// 取消接单
const handleCancelOrder = async (item: OrderItem) => {
  uni.showModal({
    title: '提示',
    content: '确定取消接单吗?',
    success: async (res: UniApp.ShowModalRes) => {
      if (res.confirm) {
        try {
          uni.showLoading({ title: '处理中' })
          await cancelOrder({ id: item.id })
          uni.showToast({
            title: '已取消接单',
            icon: 'success'
          })
          loadData()
        } catch (error) {
          uni.showToast({
            title: '取消失败',
            icon: 'none'
          })
        } finally {
          uni.hideLoading()
        }
      }
    }
  })
}

// 开始配送
const handleStartDelivery = (item: OrderItem) => {
  uni.showModal({
    title: '提示',
    content: '确认开始配送此订单?',
    success: async (res: UniApp.ShowModalRes) => {
      if (res.confirm) {
        try {
          uni.showLoading({ title: '处理中' })
          await startDelivery({ id: item.id })
          uni.showToast({
            title: '开始配送',
            icon: 'success'
          })
          loadData()
        } catch (error) {
          uni.showToast({
            title: '操作失败',
            icon: 'none'
          })
        } finally {
          uni.hideLoading()
        }
      }
    }
  })
}

// 完成订单
const handleCompleteOrder = (item: OrderItem) => {
  uni.showModal({
    title: '提示',
    content: '确认已完成配送?',
    success: async (res: UniApp.ShowModalRes) => {
      if (res.confirm) {
        try {
          uni.showLoading({ title: '处理中' })
          await completeOrder({ id: item.id })
          uni.showToast({
            title: '订单已完成',
            icon: 'success'
          })
          loadData()
        } catch (error) {
          uni.showToast({
            title: '操作失败',
            icon: 'none'
          })
        } finally {
          uni.hideLoading()
        }
      }
    }
  })
}

// 查看订单详情
const viewOrderDetail = (item: OrderItem) => {
  redirect({
    url: `/addon/running/pages/rider/detail?id=${item.id}`
  })
}

// 获取订单列表数据
const loadData = async () => {
  refresherTriggered.value = true
  loading.value = true
  try {
    if (activeTab.value === 'waiting') {
      // 获取待接单列表
      const params = {
        school_id: currentSchoolId.value,
        status: 2 // 待接单状态
      }
      const res = (await getHallList(params)) as ApiResponse<PageData<OrderItem>>
      if (res.code === 1 && res.data) {
        orderList.value = res.data.data || []
      } else {
        orderList.value = []
      }
    } else {
      // 获取我的订单列表
      const params = {
        school_id: currentSchoolId.value
      }
      const res = (await getOrderList(params)) as ApiResponse<PageData<OrderItem>>
      if (res.code === 1 && res.data) {
        myOrderList.value = res.data.data || []
      } else {
        myOrderList.value = []
      }
    }
  } catch (error) {
    console.error('加载数据失败', error)
    uni.showToast({
      title: '加载数据失败',
      icon: 'none'
    })
  } finally {
    refresherTriggered.value = false
    loading.value = false
    uni.stopPullDownRefresh()
  }
}

// 展示订单类型
const getOrderTypeText = (type: number) => {
  switch (type) {
    case 1:
      return '快递代取'
    case 2:
      return '代跑腿'
    default:
      return '其他服务'
  }
}

// 下拉刷新
const onRefresh = () => {
  loadData()
}

onMounted(() => {
  loadData()
})

onShow(() => {
  loadData()
})

onPullDownRefresh(() => {
  loadData()
})
</script>

<style lang="scss" scoped>
/* 动画 */
@keyframes spin {
  0% {
    transform: rotate(0deg);
  }

  100% {
    transform: rotate(360deg);
  }
}

.animate-spin {
  animation: spin 1s linear infinite;
}
</style>
