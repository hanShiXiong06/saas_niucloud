<template>
  <view class="order-detail bg-[var(--page-bg-color)] min-h-screen pb-1">
    <!-- 背景图层 -->
    <view class="bg-layer"></view>

    <view class="sidebar-margin pt-[var(--sides)]">
      <!-- 订单状态 -->
      <view class="card-template relative overflow-hidden order-state">
        <view class="status-content">
          <view class="status-main">
            <view class="status-title">{{ getStatusName(orderInfo.status) }}</view>
            <view class="order-no">{{ orderInfo.order_no }}</view>
          </view>
          <view class="status-description">{{ getStatusDesc(orderInfo.status) }}</view>
        </view>
        <view class="status-decoration"></view>
      </view>

      <!-- 配送信息 -->
      <view class="card-template mt-2">
        <view class="card-header">
          <view class="card-title">配送信息</view>
        </view>
        <view class="delivery-content">
          <view class="delivery-path">
            <view class="path-line">
              <view class="circle from"></view>
              <view class="line"></view>
              <view class="circle to"></view>
            </view>
            <view class="path-info">
              <view class="pickup-info">
                <view class="contact-info">
                  <text class="name" v-for="(item, index) in pickup_name" :key="index">{{ item }} </text>
                  <text class="mobile">{{
                    orderInfo?.pickup_mobile?.length !== 0
                      ? orderInfo.pickup_mobile
                      : '取件联系方式'
                  }}</text>
                </view>
                <view class="address">{{
                  orderInfo.pickup_address !== 0 ? orderInfo.pickup_address : '取件网点地址'
                  }}</view>
              </view>
              <view class="delivery-info">
                <view class="contact-info">
                  <text class="name">{{ orderInfo.contact_name }}</text>
                  <text class="mobile">{{ orderInfo.contact_mobile }}</text>
                </view>
                <view class="address">{{ orderInfo.delivery_address }}</view>
              </view>
            </view>
          </view>
          <view class="remark" v-if="orderInfo.remark">
            <text class="remark-label">备注：</text>
            <text class="remark-content">{{ orderInfo.remark }}</text>
          </view>
        </view>
      </view>

      <!-- 骑手信息 -->
      <view class="card-template mt-[var(--top-m)]" v-if="orderInfo.rider_id && orderInfo.status > 1">
        <view class="card-header">
          <view class="card-title">骑手信息</view>
        </view>
        <view class="rider-card" v-if="orderInfo.runningRider">
          <image class="rider-avatar" :src="riderAvatar" mode="aspectFill"></image>
          <view class="rider-info">
            <view class="rider-name">{{ orderInfo.runningRider.nickname || '骑手' }}</view>
            <view class="rider-mobile">联系电话：{{ orderInfo.runningRider.mobile || '' }}</view>
          </view>
          <view class="rider-contact">
            <view class="contact-btn" @click="callRider">
              <text class="nc-iconfont nc-icon-dianhua"></text>
              <text class="btn-text">联系骑手</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 订单商品 -->
      <view class="card-template mt-[var(--top-m)]">
        <view class="card-header">
          <view class="card-title">商品信息</view>
        </view>
        <view class="products-list">
          <view class="product-item" v-for="(item, index) in orderInfo.runningOrderProduct" :key="index"
            :class="{ 'border-bottom': index !== orderInfo.runningOrderProduct.length - 1 }">
            <view class="product-main">
              <view class="product-name">{{ item.name }}</view>
              <view class="product-code" v-if="item.code">取件码：{{ item.code }}</view>
            </view>
            <view class="product-meta">
              <view class="product-price">
                <text class="price-symbol">￥</text>{{ parseFloat(item.price).toFixed(2) }}
              </view>
              <view class="product-quantity">x{{ item.num }}</view>
            </view>
          </view>
        </view>
      </view>

      <!-- 订单金额 -->
      <view class="card-template mt-[var(--top-m)]">
        <view class="card-header">
          <view class="card-title">订单金额</view>
        </view>
        <view class="price-details">
          <view class="price-item">
            <text class="price-label">商品金额</text>
            <text class="price-value">￥{{ getProductTotal() }}</text>
          </view>
          <view class="price-item">
            <text class="price-label">配送费</text>
            <text class="price-value">￥{{ parseFloat(orderInfo.delivery_fee || 0).toFixed(2) }}</text>
          </view>
          <view class="price-divider"></view>
          <view class="price-item total">
            <text class="price-label">实付金额</text>
            <text class="price-value highlight">￥{{ parseFloat(orderInfo.amount || 0).toFixed(2) }}</text>
          </view>
        </view>
      </view>

      <!-- 订单信息 -->
      <view class="card-template mt-[var(--top-m)] mb-[150rpx]">
        <view class="card-header">
          <view class="card-title">订单信息</view>
        </view>
        <view class="order-info-list">
          <view class="info-item">
            <text class="info-label">订单编号：</text>
            <view class="info-value">
              <text>{{ orderInfo.order_no || '' }}</text>
              <text class="copy-icon nc-iconfont nc-icon-fuzhiV6xx1" @click="copy(orderInfo.order_no)"></text>
            </view>
          </view>
          <view class="info-item">
            <text class="info-label">创建时间：</text>
            <text class="info-value">{{ orderInfo.create_time || '' }}</text>
          </view>
          <view class="info-item" v-if="orderInfo.pay_time">
            <text class="info-label">支付时间：</text>
            <text class="info-value">{{ orderInfo.pay_time || '' }}</text>
          </view>
          <view class="info-item" v-if="orderInfo.status === 4">
            <text class="info-label">完成时间：</text>
            <text class="info-value">{{ orderInfo.finish_time || '' }}</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 底部按钮 -->
    <view class="fixed-bottom bg-[#fff] safe-area-inset-bottom flex justify-between">
      <!-- 返回主页 -->

      <view class="flex flex-col justify-center items-center ml-[38rpx]"
        @click="redirect({ url: '/addon/running/pages/index/index', mode: 'reLaunch' })">
        <view class="nc-iconfont nc-icon-shouyeV6xx11 text-[36rpx]"></view>
        <text class="text-[20rpx] mt-[10rpx]">首页</text>
      </view>

      <view class="actions-container">
        <view class="action-btn cancel-btn" v-if="orderInfo.status == 1" @click="cancelOrder">取消订单</view>
        <view class="action-btn primary-btn" v-if="orderInfo.status == 1" @click="payOrder">去支付</view>
        <view class="action-btn primary-btn" v-if="orderInfo.status == 3" @click="finishOrder">确认收货</view>
      </view>
    </view>

    <pay ref="payRef" @close="payClose"></pay>
  </view>
</template>

<script setup lang="ts">
import {
  cancelOrder as apiCancelOrder,
  confirmOrder,
  getOrderInfo
} from '@/addon/running/api/order'
import { copy, img, redirect } from '@/utils/common'
import { onLoad } from '@dcloudio/uni-app'
import { computed, ref } from 'vue'

const orderInfo = ref<any>({})
const orderId = ref('')
const payRef = ref(null)
const riderAvatar = computed(() => {
  return orderInfo.value.rider?.avatar || img('static/resource/images/default_avatar.png')
})

onLoad((option: any) => {
  if (option.id) {
    orderId.value = option.id
    getOrderDetail()
  }
})

// 获取订单详情
const getOrderDetail = () => {
  uni.showLoading({
    title: '加载中'
  })
  getOrderInfo({ id: orderId.value })
    .then((res: any) => {
      orderInfo.value = res.data
      // 确保正确访问骑手信息
      if (orderInfo.value.runningRider) {
        console.log('骑手信息:', orderInfo.value.runningRider)
      } else if (orderInfo.value.rider) {
        orderInfo.value.runningRider = orderInfo.value.rider
      }
      uni.hideLoading()
    })
    .catch(() => {
      uni.hideLoading()
      uni.showToast({
        title: '获取订单信息失败',
        icon: 'none'
      })
    })
}

// 获取状态名称
const getStatusName = (status: number | string) => {
  const statusMap: Record<string, string> = {
    '1': '待付款',
    '2': '待接单',
    '3': '已接单',
    '4': '配送中',
    '5': '已完成',
    '-1': '已取消'
  }
  return statusMap[status?.toString()] || '未知状态'
}

// 获取状态描述
const getStatusDesc = (status: number | string) => {
  const statusMap: Record<string, string> = {
    '1': '请尽快完成支付',
    '2': '待骑手接订单',
    '3': '骑手已接单，正在取件',
    '4': '骑手正在配送中',
    '5': '订单已完成，感谢您的使用',
    '-1': '订单已取消'
  }
  return statusMap[status?.toString()] || ''
}

// 计算商品总价
const getProductTotal = () => {
  if (!orderInfo.value.runningOrderProduct || !orderInfo.value.runningOrderProduct.length) {
    return '0.00'
  }

  let total = 0
  orderInfo.value.runningOrderProduct.forEach((item: any) => {
    total += parseFloat(item.price) * parseInt(item.num)
  })

  return total.toFixed(2)
}

// 取消订单
const cancelOrder = () => {
  uni.showModal({
    title: '提示',
    content: '确定要取消订单吗？',
    success: (res) => {
      if (res.confirm) {
        uni.showLoading({ title: '处理中' })
        apiCancelOrder({ id: orderId.value })
          .then(() => {
            uni.hideLoading()
            uni.showToast({
              title: '订单已取消',
              icon: 'none'
            })
            getOrderDetail()
          })
          .catch(() => {
            uni.hideLoading()
            uni.showToast({
              title: '取消订单失败',
              icon: 'none'
            })
          })
      }
    }
  })
}

// 支付订单
const payOrder = () => {
  if (payRef.value) {
    payRef.value.open('runningOrderPay', orderId.value, '')
  }
}

// 确认收货
const finishOrder = () => {
  uni.showModal({
    title: '提示',
    content: '确认已收到商品？',
    success: (res) => {
      if (res.confirm) {
        uni.showLoading({ title: '处理中' })
        confirmOrder({ id: orderId.value })
          .then(() => {
            uni.hideLoading()
            uni.showToast({
              title: '确认收货成功',
              icon: 'none'
            })
            getOrderDetail()
          })
          .catch(() => {
            uni.hideLoading()
            uni.showToast({
              title: '确认收货失败',
              icon: 'none'
            })
          })
      }
    }
  })
}

// 联系骑手
const callRider = () => {
  const mobile = orderInfo.value.runningRider?.mobile || orderInfo.value.rider?.mobile
  if (mobile) {
    uni.makePhoneCall({
      phoneNumber: mobile,
      fail: () => {
        uni.showToast({
          title: '拨打电话失败',
          icon: 'none'
        })
      }
    })
  } else {
    uni.showToast({
      title: '骑手联系方式不可用',
      icon: 'none'
    })
  }
}

const payClose = () => {
  getOrderDetail()
}

// 整合 取货 网点
// orderInfo.runningOrderProduct 

// 取货 网点 
const pickup_name = computed(() => {
  if (!orderInfo.value) return []

  // 快递代取
  if (orderInfo.value.type === 1) {

    return new Set(orderInfo.value.runningOrderProduct?.map(item => item.express_name) || [])
  }

  // 跑腿服务
  if (orderInfo.value.type === 2) {
    return new Set(orderInfo.value.pickup_name ? [orderInfo.value.pickup_name] : [])
  }

  return []
})





</script>

<style lang="scss" scoped>
.order-detail {
  font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'SF Pro Text', 'Helvetica Neue',
    Arial, sans-serif;
  position: relative;
  color: #111827;

  .bg-layer {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: #f9fafb;
    background-image: linear-gradient(to bottom,
        rgba(219, 234, 254, 0.1),
        rgba(255, 255, 255, 0.1));
    z-index: -2;
  }

  .card-template {
    padding: 0;
    background-color: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(10px);
    border-radius: 16rpx;
    box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);
    border: 1rpx solid rgba(229, 231, 235, 0.8);
    overflow: hidden;

    .card-header {
      padding: 24rpx;
      border-bottom: 1rpx solid rgba(243, 244, 246, 0.8);

      .card-title {
        font-size: 30rpx;
        font-weight: 600;
        color: #1f2937;
        position: relative;
        padding-left: 16rpx;

        &::before {
          content: '';
          position: absolute;
          left: 0;
          top: 50%;
          transform: translateY(-50%);
          width: 4rpx;
          height: 24rpx;
          background-color: #2563eb;
          border-radius: 2rpx;
        }
      }
    }
  }

  .order-state {
    background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
    padding: 30rpx var(--between-md);
    position: relative;

    .status-content {
      position: relative;
      z-index: 1;
      padding: 10rpx 20rpx;

      .status-main {
        display: flex;
        justify-content: space-between;
        align-items: center;

        .status-title {
          font-size: 36rpx;
          font-weight: 600;
          color: #ffffff;
        }

        .order-no {
          font-size: 26rpx;
          color: rgba(255, 255, 255, 0.8);
        }
      }

      .status-description {
        margin-top: 16rpx;
        font-size: 26rpx;
        color: rgba(255, 255, 255, 0.8);
      }
    }

    .status-decoration {
      position: absolute;
      bottom: -30rpx;
      right: -30rpx;
      width: 180rpx;
      height: 180rpx;
      border-radius: 50%;
      background-color: rgba(255, 255, 255, 0.1);
    }
  }

  .rider-card {
    display: flex;
    align-items: center;
    padding: 24rpx;

    .rider-avatar {
      width: 88rpx;
      height: 88rpx;
      border-radius: 44rpx;
      background-color: #f3f4f6;
    }

    .rider-info {
      flex: 1;
      margin-left: 20rpx;

      .rider-name {
        font-size: 28rpx;
        font-weight: 500;
        color: #1f2937;
      }

      .rider-mobile {
        font-size: 24rpx;
        color: #6b7280;
        margin-top: 6rpx;
      }
    }

    .rider-contact {
      .contact-btn {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        background-color: rgba(37, 99, 235, 0.1);
        color: #2563eb;
        padding: 12rpx 24rpx;
        border-radius: 12rpx;

        .nc-iconfont {
          font-size: 32rpx;
          margin-bottom: 4rpx;
        }

        .btn-text {
          font-size: 22rpx;
        }

        &:active {
          opacity: 0.8;
          transform: scale(0.98);
        }
      }
    }
  }

  .delivery-content {
    padding: 24rpx;

    .delivery-path {
      display: flex;

      .path-line {
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 40rpx;
        position: relative;

        .circle {
          width: 20rpx;
          height: 20rpx;
          border-radius: 50%;
          z-index: 1;

          &.from {
            background-color: #2563eb;
          }

          &.to {
            background-color: #10b981;
            margin-top: auto;
          }
        }

        .line {
          position: absolute;
          top: 20rpx;
          bottom: 20rpx;
          left: 50%;
          transform: translateX(-50%);
          width: 2rpx;
          background-color: #e5e7eb;
        }
      }

      .path-info {
        flex: 1;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        min-height: 170rpx;

        .pickup-info,
        .delivery-info {
          .contact-info {
            display: flex;
            align-items: center;
            margin-bottom: 6rpx;

            .name {
              font-size: 26rpx;
              font-weight: 500;
              color: #1f2937;
            }

            .mobile {
              font-size: 26rpx;
              color: #6b7280;
              margin-left: 10rpx;
            }
          }

          .address {
            font-size: 24rpx;
            color: #6b7280;
            line-height: 1.5;
          }
        }

        .pickup-info {
          margin-bottom: 40rpx;
        }
      }
    }

    .remark {
      margin-top: 20rpx;
      font-size: 24rpx;
      color: #6b7280;
      line-height: 1.5;
      padding-top: 16rpx;
      border-top: 1rpx solid rgba(243, 244, 246, 0.8);

      .remark-label {
        color: #6b7280;
      }

      .remark-content {
        color: #1f2937;
      }
    }
  }

  .products-list {
    padding: 0 24rpx;

    .product-item {
      display: flex;
      justify-content: space-between;
      padding: 24rpx 0;

      &.border-bottom {
        border-bottom: 1rpx solid rgba(243, 244, 246, 0.8);
      }

      .product-main {
        flex: 1;

        .product-name {
          font-size: 28rpx;
          color: #1f2937;
          margin-bottom: 6rpx;
        }

        .product-code {
          font-size: 24rpx;
          color: #6b7280;
        }
      }

      .product-meta {
        display: flex;
        flex-direction: column;
        align-items: flex-end;

        .product-price {
          font-size: 28rpx;
          color: #1f2937;
          font-weight: 500;
          font-family: 'DIN Alternate', sans-serif;

          .price-symbol {
            font-size: 24rpx;
          }
        }

        .product-quantity {
          font-size: 24rpx;
          color: #6b7280;
          margin-top: 6rpx;
        }
      }
    }
  }

  .price-details {
    padding: 24rpx;

    .price-item {
      display: flex;
      justify-content: space-between;
      margin-bottom: 16rpx;

      .price-label {
        font-size: 26rpx;
        color: #6b7280;
      }

      .price-value {
        font-size: 26rpx;
        color: #1f2937;
        font-family: 'DIN Alternate', sans-serif;
      }

      &.total {
        margin-top: 16rpx;
        margin-bottom: 0;

        .price-label {
          font-size: 28rpx;
          font-weight: 500;
          color: #1f2937;
        }

        .price-value.highlight {
          font-size: 32rpx;
          font-weight: 600;
          color: #ef4444;
        }
      }
    }

    .price-divider {
      height: 1rpx;
      background-color: rgba(243, 244, 246, 0.8);
      margin: 16rpx 0;
    }
  }

  .order-info-list {
    padding: 24rpx;

    .info-item {
      display: flex;
      margin-bottom: 16rpx;

      &:last-child {
        margin-bottom: 0;
      }

      .info-label {
        font-size: 26rpx;
        color: #6b7280;
        width: 140rpx;
      }

      .info-value {
        font-size: 26rpx;
        color: #1f2937;
        flex: 1;
        display: flex;
        align-items: center;

        .copy-icon {
          margin-left: 10rpx;
          font-size: 26rpx;
          color: #6b7280;
          padding: 4rpx;
        }
      }
    }
  }

  .fixed-bottom {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    border-top: 1px solid #efefef;
    background-color: rgba(255, 255, 255, 0.98);
    backdrop-filter: blur(10rpx);
    z-index: 100;

    .actions-container {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      height: 100rpx;
      padding: 0 30rpx;

      .action-btn {
        height: 80rpx;
        min-width: 180rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 40rpx;
        font-size: 28rpx;
        font-weight: 500;
        margin-left: 20rpx;

        &.cancel-btn {
          border: 2rpx solid #d1d5db;
          color: #6b7280;
        }

        &.primary-btn {
          background-color: #2563eb;
          color: white;
          box-shadow: 0 4rpx 12rpx rgba(37, 99, 235, 0.2);
        }

        &:active {
          transform: scale(0.98);
          opacity: 0.9;
        }
      }
    }
  }
}
</style>
