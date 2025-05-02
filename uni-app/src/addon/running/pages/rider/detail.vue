<template>
  <view class="detail-container">
    <!-- 状态背景 -->
    <view class="status-header">
      <view class="pattern-bg"></view>
      <view class="status-content">
        <view class="top-row">
          <view class="order-id-box">
            <text class="order-id-label">订单编号</text>
            <text class="order-id-value">{{ orderInfo.order_no }}</text>
          </view>
          <view class="order-type-tag">{{ orderInfo.type === 1 ? '快递代取' : '跑腿服务' }}</view>
        </view>
        <view class="status-display">
          <view class="status-label">{{ getOrderStatusText(orderInfo.status) }}</view>
          <view class="status-time">{{ orderInfo.create_time }}</view>
        </view>
      </view>
    </view>

    <!-- 进度条 -->
    <view class="progress-wrap">
      <up-steps :current="getStepsCurrent(orderInfo.status)" direction="column">
        <up-steps-item title="下单" :desc="formatTime(orderInfo.create_time) || '---'"
          :activeIcon="orderInfo.status >= 0 ? 'checkbox-mark' : ''" />
        <up-steps-item title="接单" :desc="formatTime(orderInfo.accept_time) || '---'"
          :activeIcon="orderInfo.status >= 3 ? 'checkbox-mark' : ''" />
        <up-steps-item title="配送" :desc="formatTime(orderInfo.deliver_time) || '---'"
          :activeIcon="orderInfo.status >= 4 ? 'checkbox-mark' : ''" />
        <up-steps-item title="完成" :desc="formatTime(orderInfo.complete_time) || '---'"
          :activeIcon="orderInfo.status >= 5 ? 'checkbox-mark' : ''" />
      </up-steps>
    </view>

    <!-- 订单信息 -->
    <view class="info-card order-card">
      <view class="card-header">
        <text class="card-title">订单详情</text>
        <view class="card-tag">{{ orderInfo.school_id_name }}</view>
      </view>

      <!-- 订单基本信息 -->
      <view class="order-basic-info">
        <view class="info-item">
          <text class="info-label">订单编号</text>
          <text class="info-value">{{ orderInfo.order_no }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">订单ID</text>
          <text class="info-value">{{ orderInfo.id }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">下单时间</text>
          <text class="info-value">{{ orderInfo.create_time }}</text>
        </view>
        <view class="info-item">
          <text class="info-label">更新时间</text>
          <text class="info-value">{{ orderInfo.update_time }}</text>
        </view>
      </view>

      <!-- 商品信息 -->
      <view class="product-section">
        <view class="section-title">商品信息</view>
        <view class="product-item" v-for="(item, index) in orderInfo.runningOrderProduct" :key="index">
          <view class="product-icon" :class="orderInfo.type === 1 ? 'express-icon' : 'errand-icon'">
            <text>{{ orderInfo.type === 1 ? '递' : '跑' }}</text>
          </view>
          <view class="product-info">
            <view class="product-name">{{ item.name }}</view>
            <view class="product-meta">
              <text class="product-code" v-if="item.code">取货码: {{ item.code }}</text>
              <text class="express-name" v-if="item.express_name">{{ item.express_name }}</text>
            </view>
            <view class="product-quantity">× {{ item.num }}</view>
          </view>
          <view class="product-price">¥{{ item.price }}</view>
        </view>
      </view>

      <!-- 费用信息 -->
      <view class="price-section">
        <view class="section-title">费用详情</view>
        <view class="price-item">
          <text>商品金额</text>
          <text>¥{{ orderInfo.amount }}</text>
        </view>
        <!-- <view class="price-item">
          <text>配送费</text>
          <text>¥{{ orderInfo.delivery_fee }}</text>
        </view> -->
        <view class="price-item">
          <text>佣金比例</text>
          <text>{{ orderInfo.commission_rate }}%</text>
        </view>
        <view class="price-item">
          <text>骑手佣金</text>
          <text class="commission">¥{{ (parseFloat(orderInfo.amount) * 0.9).toFixed(2) }}</text>
        </view>
        <view class="divider"></view>
        <view class="price-item total">
          <text>合计</text>
          <text class="total-price">¥{{ sumPrice }}</text>
        </view>
      </view>
    </view>

    <!-- 配送信息 -->
    <view class="info-card delivery-card">
      <view class="card-header">
        <text class="card-title">配送信息</text>
        <view class="navigate-btn ripple" @click="handleNavigate()">
          <text class="navigate-icon">📍</text>
          <text>导航</text>
        </view>
      </view>

      <view class="delivery-info">
        <!-- 快递代取 -->
        <template v-if="orderInfo.type === 1 && orderInfo.pickup_address">
          <view class="address-row">
            <view class="address-type pickup">寄</view>
            <view class="address-detail">
              <view class="address-text">{{ orderInfo.pickup_address }}</view>
              <view class="contact-info" v-if="orderInfo.pickup_name">
                {{ orderInfo.pickup_name }} {{ orderInfo.pickup_mobile }}
                <text class="call-btn ripple" @click="handleCallPhone(orderInfo.pickup_mobile)"
                  v-if="orderInfo.pickup_mobile">
                  <text class="call-icon">📞</text>
                </text>
              </view>
            </view>
          </view>

          <view class="address-divider">
            <view class="dotted-line"></view>
            <view class="direction-icon">
              <text class="direction-arrow">↓</text>
            </view>
            <view class="dotted-line"></view>
          </view>
        </template>

        <view class="address-row">
          <view class="address-type delivery">{{ orderInfo.type === 1 ? '收' : '送' }}</view>
          <view class="address-detail">
            <view class="address-text">{{ orderInfo.delivery_address }}</view>
            <view class="contact-info">
              {{ orderInfo.contact_name }} {{ orderInfo.contact_mobile }}
              <text class="call-btn ripple" @click="handleCallPhone(orderInfo.contact_mobile)"
                v-if="orderInfo.contact_mobile">
                <text class="call-icon">📞</text>
              </text>
            </view>
          </view>
        </view>
      </view>

      <!-- 备注信息 -->
      <view class="remark-section" v-if="orderInfo.remark">
        <view class="remark-label">订单备注</view>
        <view class="remark-content">{{ orderInfo.remark }}</view>
      </view>
    </view>

    <!-- 操作区域 -->
    <view class="action-footer">
      <view class="action-divider"></view>

      <view class="action-buttons">
        <view class="home-btn ripple" @click="goHome">
          <text class="home-icon">🏠</text>
          <text>首页</text>
        </view>

        <!-- 状态按钮 -->
        <block v-if="orderInfo.status === 2">
          <button class="primary-btn accept-btn ripple" @click="handleAcceptOrder">接单</button>
        </block>

        <block v-if="orderInfo.status === 3">
          <button class="secondary-btn cancel-btn ripple" @click="handleCancelOrder">
            取消接单
          </button>
          <button class="primary-btn start-btn ripple" @click="handleStartDelivery">
            开始配送
          </button>
        </block>

        <block v-if="orderInfo.status === 4">
          <button class="success-btn complete-btn ripple" @click="handleCompleteOrder">
            完成订单
          </button>
        </block>
      </view>
    </view>

    <!-- 刷新按钮 -->
    <view class="refresh-btn ripple" @click="loadOrderDetail">
      <text class="nc-iconfont nc-icon-shuaxinV6xx"> </text>
    </view>
  </view>
</template>

<script setup lang="ts">
import {
  acceptOrder,
  cancelOrder,
  completeOrder,
  getOrderDetail,
  startDelivery
} from '@/addon/running/api/rider'
import { redirect } from '@/utils/common'
import { onLoad } from '@dcloudio/uni-app'
import { computed, ref } from 'vue'

// 订单状态
const orderStatusMap: Record<string | number, string> = {
  1: '待支付',
  2: '待接单',
  3: '已接单',
  4: '配送中',
  5: '已完成',
  '-1': '已关闭'
}

// 产品类型
interface Product {
  id: number
  name: string
  price: string
  num: number
  code: string
  express_name: string
  order_id: number
  site_id: number
}

// API响应类型
interface ApiResponse<T> {
  code: number
  msg: string
  data: T
}

// 订单信息类型
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
  num: number
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
  runningOrderProduct: Product[]
  accept_time?: string
  deliver_time?: string
  complete_time?: string
}

const orderId = ref(0)
const orderInfo = ref<OrderInfo>({
  id: 0,
  site_id: 0,
  school_id: 0,
  order_no: '',
  member_id: 0,
  rider_id: 0,
  type: 1,
  status: 0,
  amount: '0',
  num: 0,
  delivery_fee: '0',
  commission_rate: '0',
  commission_amount: '0',
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
  runningOrderProduct: []
})

const sumPrice = computed(() => {
  return (parseFloat(orderInfo.value.amount) + parseFloat(orderInfo.value.delivery_fee)).toFixed(2)
})

// 获取订单状态文本
const getOrderStatusText = (status: number | string) => {
  return orderStatusMap[status] || '未知状态'
}

// 格式化时间 - 只显示时:分
const formatTime = (timeString?: string) => {
  if (!timeString) return ''
  const date = new Date(timeString)
  const hours = date.getHours().toString().padStart(2, '0')
  const minutes = date.getMinutes().toString().padStart(2, '0')
  return `${hours}:${minutes}`
}

// 加载订单详情
const loadOrderDetail = async () => {
  if (!orderId.value) return

  try {
    uni.showLoading({ title: '加载中' })
    const res = (await getOrderDetail({ id: orderId.value })) as ApiResponse<OrderInfo>
    if (res.code === 1 && res.data) {
      orderInfo.value = res.data
    } else {
      uni.showToast({
        title: res.msg || '获取订单详情失败',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('获取订单详情失败', error)
    uni.showToast({
      title: '获取订单详情失败',
      icon: 'none'
    })
  } finally {
    uni.hideLoading()
  }
}

// 接单
const handleAcceptOrder = async () => {
  try {
    uni.showLoading({ title: '处理中' })
    const res = (await acceptOrder({ id: orderId.value })) as ApiResponse<any>
    if (res.code === 1) {
      uni.showToast({
        title: '接单成功',
        icon: 'success'
      })
      loadOrderDetail()
    } else {
      uni.showToast({
        title: res.msg || '接单失败',
        icon: 'none'
      })
    }
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
const handleCancelOrder = () => {
  uni.showModal({
    title: '提示',
    content: '确定取消接单吗?',
    success: async (res: UniApp.ShowModalRes) => {
      if (res.confirm) {
        try {
          uni.showLoading({ title: '处理中' })
          const result = (await cancelOrder({ id: orderId.value })) as ApiResponse<any>
          if (result.code === 1) {
            uni.showToast({
              title: '已取消接单',
              icon: 'success'
            })
            loadOrderDetail()
          } else {
            uni.showToast({
              title: result.msg || '取消失败',
              icon: 'none'
            })
          }
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
const handleStartDelivery = () => {
  uni.showModal({
    title: '提示',
    content: '确认开始配送此订单?',
    success: async (res: UniApp.ShowModalRes) => {
      if (res.confirm) {
        try {
          uni.showLoading({ title: '处理中' })
          const result = (await startDelivery({ id: orderId.value })) as ApiResponse<any>
          if (result.code === 1) {
            uni.showToast({
              title: '开始配送',
              icon: 'success'
            })
            loadOrderDetail()
          } else {
            uni.showToast({
              title: result.msg || '操作失败',
              icon: 'none'
            })
          }
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
const handleCompleteOrder = () => {
  uni.showModal({
    title: '提示',
    content: '确认已完成配送?',
    success: async (res: UniApp.ShowModalRes) => {
      if (res.confirm) {
        try {
          uni.showLoading({ title: '处理中' })
          const result = (await completeOrder({ id: orderId.value })) as ApiResponse<any>
          if (result.code === 1) {
            uni.showToast({
              title: '订单已完成',
              icon: 'success'
            })
            loadOrderDetail()
          } else {
            uni.showToast({
              title: result.msg || '操作失败',
              icon: 'none'
            })
          }
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

// 拨打电话
const handleCallPhone = (phone: string) => {
  if (!phone) return
  uni.makePhoneCall({
    phoneNumber: phone
  })
}

// 导航
const handleNavigate = () => {
  // 实现地图导航功能
  uni.showToast({
    title: '暂未实现导航功能',
    icon: 'none'
  })
}

// 返回首页
const goHome = () => {
  redirect({
    url: '/addon/running/pages/index/index'
  })
}

// 获取当前步骤
const getStepsCurrent = (status: number) => {
  if (status >= 5) return 3 // 已完成
  if (status >= 4) return 2 // 配送中
  if (status >= 3) return 1 // 已接单
  if (status >= 0) return 0 // 已下单
  return -1 // 其他状态
}

onLoad((options: any) => {
  if (options && options.id) {
    orderId.value = parseInt(options.id)
    loadOrderDetail()
  }
})
</script>

<style lang="scss" scoped>
.detail-container {
  background-color: #f8f9fc;
  min-height: 100vh;
  padding-bottom: 150rpx;
  position: relative;
}

/* 状态头部 */
.status-header {
  position: relative;
  height: 220rpx;
  background: linear-gradient(135deg, #4285f4, #34a853);
  color: #fff;
  overflow: hidden;
}

.pattern-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  opacity: 0.1;
  background-image: radial-gradient(circle at 20% 80%, rgba(255, 255, 255, 0.4) 0%, transparent 12%),
    radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.4) 0%, transparent 12%);
  background-size: 60rpx 60rpx;
}

.status-header::after {
  content: '';
  position: absolute;
  right: -80rpx;
  bottom: -80rpx;
  width: 300rpx;
  height: 300rpx;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
}

.status-content {
  position: relative;
  z-index: 2;
  padding: 40rpx 30rpx;
}

.top-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}

.order-id-box {
  display: flex;
  flex-direction: column;
}

.order-id-label {
  font-size: 22rpx;
  opacity: 0.8;
  margin-bottom: 6rpx;
}

.order-id-value {
  font-size: 26rpx;
  font-weight: 500;
}

.order-type-tag {
  background: rgba(255, 255, 255, 0.2);
  padding: 6rpx 16rpx;
  border-radius: 100rpx;
  font-size: 22rpx;
}

.status-display {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.status-label {
  font-size: 40rpx;
  font-weight: bold;
}

.status-time {
  font-size: 24rpx;
  opacity: 0.8;
}

/* 进度条 */
.progress-wrap {
  position: relative;
  margin: -40rpx 20rpx 20rpx;
  background: #fff;
  border-radius: 16rpx;
  padding: 30rpx 20rpx;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.08);
  z-index: 10;
}

/* 卡片样式 */
.info-card {
  position: relative;
  background: #fff;
  border-radius: 16rpx;
  padding: 30rpx;
  margin: 20rpx;
  box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.06);
  overflow: hidden;
}

.order-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 6rpx;
  height: 60rpx;
  background: #4285f4;
}

.delivery-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 6rpx;
  height: 60rpx;
  background: #34a853;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30rpx;
}

.card-title {
  font-size: 32rpx;
  font-weight: bold;
  color: #333;
  margin-left: 10rpx;
}

.card-tag {
  background: #f2f7ff;
  color: #4285f4;
  padding: 6rpx 16rpx;
  border-radius: 20rpx;
  font-size: 22rpx;
}

/* 商品信息 */
.product-section {
  margin-bottom: 30rpx;
}

.product-item {
  display: flex;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1px solid #f5f5f5;
}

.product-item:last-child {
  border-bottom: none;
}

.product-icon {
  width: 60rpx;
  height: 60rpx;
  border-radius: 12rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 28rpx;
  font-weight: bold;
  margin-right: 20rpx;
  box-shadow: 0 4rpx 10rpx rgba(0, 0, 0, 0.1);
}

.express-icon {
  background: linear-gradient(135deg, #4285f4, #5b9bff);
}

.errand-icon {
  background: linear-gradient(135deg, #34a853, #4cc966);
}

.product-info {
  flex: 1;
}

.product-name {
  font-size: 28rpx;
  color: #333;
  margin-bottom: 6rpx;
}

.product-quantity {
  font-size: 24rpx;
  color: #999;
}

.product-price {
  font-size: 30rpx;
  color: #ff5722;
  font-weight: 500;
}

/* 费用信息 */
.price-section {
  padding-top: 20rpx;
}

.price-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 16rpx;
  font-size: 26rpx;
  color: #666;
}

.divider {
  height: 1px;
  background: #f0f0f0;
  margin: 20rpx 0;
}

.total {
  font-size: 30rpx;
  color: #333;
  font-weight: bold;
}

.total-price {
  color: #ff5722;
  font-size: 34rpx;
}

/* 配送信息 */
.delivery-info {
  margin-bottom: 30rpx;
}

.navigate-btn {
  display: flex;
  align-items: center;
  background: rgba(66, 133, 244, 0.1);
  padding: 8rpx 20rpx;
  border-radius: 20rpx;
  font-size: 24rpx;
  color: #4285f4;
}

.navigate-icon {
  margin-right: 6rpx;
  font-size: 26rpx;
}

.address-row {
  display: flex;
  align-items: flex-start;
  margin-bottom: 20rpx;
}

.address-type {
  width: 40rpx;
  height: 40rpx;
  border-radius: 10rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 22rpx;
  font-weight: bold;
  margin-right: 20rpx;
  margin-top: 5rpx;
  box-shadow: 0 4rpx 10rpx rgba(0, 0, 0, 0.1);
}

.pickup {
  background: linear-gradient(135deg, #ff9800, #ffb74d);
}

.delivery {
  background: linear-gradient(135deg, #4285f4, #5b9bff);
}

.address-detail {
  flex: 1;
}

.address-text {
  font-size: 28rpx;
  color: #333;
  line-height: 40rpx;
  margin-bottom: 6rpx;
}

.contact-info {
  font-size: 24rpx;
  color: #999;
  display: flex;
  align-items: center;
}

.call-btn {
  margin-left: 10rpx;
  padding: 4rpx 10rpx;
  color: #4285f4;
}

.call-icon {
  font-size: 24rpx;
}

.address-divider {
  display: flex;
  align-items: center;
  margin: 10rpx 0 20rpx 20rpx;
}

.dotted-line {
  flex: 1;
  height: 1px;
  background-image: linear-gradient(to right, #ddd 50%, transparent 50%);
  background-size: 10rpx 1px;
  background-repeat: repeat-x;
}

.direction-icon {
  padding: 0 10rpx;
  color: #999;
}

.direction-arrow {
  font-size: 24rpx;
}

/* 备注部分 */
.remark-section {
  background: #fafafa;
  border-radius: 10rpx;
  padding: 20rpx;
  margin-top: 20rpx;
}

.remark-label {
  font-size: 26rpx;
  color: #666;
  margin-bottom: 10rpx;
  font-weight: 500;
}

.remark-content {
  font-size: 26rpx;
  color: #333;
  line-height: 38rpx;
}

/* 底部操作区 */
.action-footer {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background: #fff;
  z-index: 100;
  box-shadow: 0 -4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.action-divider {
  height: 1px;
  background: #f0f0f0;
}

.action-buttons {
  display: flex;
  align-items: center;
  padding: 20rpx 30rpx;
}

.home-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-right: 40rpx;
  font-size: 22rpx;
  color: #666;
}

.home-icon {
  font-size: 36rpx;
  margin-bottom: 6rpx;
}

button {
  flex: 1;
  height: 80rpx;
  border-radius: 40rpx;
  font-size: 28rpx;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 10rpx;
  border: none;
  box-shadow: 0 4rpx 10rpx rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.primary-btn {
  background: linear-gradient(to right, #4285f4, #5b9bff);
  color: #fff;
}

.secondary-btn {
  background: #fff;
  color: #ff5722;
  border: 1px solid #ff5722;
}

.success-btn {
  background: linear-gradient(to right, #34a853, #4cc966);
  color: #fff;
}

/* 刷新按钮 */
.refresh-btn {
  position: fixed;

  bottom: 180rpx;
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  background: #fff;
  box-shadow: 0 6rpx 20rpx rgba(0, 0, 0, 0.15);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 99;
  transition: transform 0.3s ease;
}

.refresh-btn:active {
  transform: scale(0.95);
}

.refresh-icon {
  font-size: 36rpx;
}

/* 涟漪效果 */
.ripple {
  // position: relative;
  overflow: hidden;
  transform: translate3d(0, 0, 0);
}

.ripple:after {
  content: '';
  display: block;
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  pointer-events: none;
  background-image: radial-gradient(circle, rgba(0, 0, 0, 0.1) 10%, transparent 10.01%);
  background-repeat: no-repeat;
  background-position: 50%;
  transform: scale(10, 10);
  opacity: 0;
  transition: transform 0.5s, opacity 0.5s;
}

.ripple:active:after {
  transform: scale(0, 0);
  opacity: 0.3;
  transition: 0s;
}

/* 订单基本信息 */
.order-basic-info {
  background: #f8f9fc;
  border-radius: 12rpx;
  padding: 20rpx;
  margin-bottom: 30rpx;
}

.info-item {
  display: flex;
  justify-content: space-between;
  font-size: 24rpx;
  color: #666;
  margin-bottom: 12rpx;
}

.info-item:last-child {
  margin-bottom: 0;
}

.info-label {
  color: #999;
}

.info-value {
  color: #333;
  font-weight: 500;
}

.section-title {
  font-size: 28rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
  position: relative;
  padding-left: 16rpx;
}

.section-title::before {
  content: '';
  position: absolute;
  left: 0;
  top: 6rpx;
  height: 24rpx;
  width: 4rpx;
  background-color: #4285f4;
  border-radius: 2rpx;
}

.product-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10rpx;
  margin-bottom: 6rpx;
}

.product-code,
.express-name {
  font-size: 22rpx;
  color: #999;
  background-color: #f5f5f5;
  padding: 2rpx 10rpx;
  border-radius: 8rpx;
}

.commission {
  color: #ff9800;
  font-weight: 500;
}

/* 费用信息 */
.price-section {
  background: #f8f9fc;
  border-radius: 12rpx;
  padding: 20rpx;
}
</style>
