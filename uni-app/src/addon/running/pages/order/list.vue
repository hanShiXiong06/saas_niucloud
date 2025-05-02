<template>
  <view class="bg-[var(--page-bg-color)] min-h-screen overflow-hidden order-list" :style="themeColor()">
    <!-- 背景图层 -->
    <view class="bg-layer"></view>

    <!-- 顶部状态标签栏 -->
    <view class="fixed left-0 top-0 right-0 z-10" v-if="statusLoading">
      <scroll-view :scroll-x="true" class="tab-style-2">
        <view class="tab-content">
          <view class="tab-items" :class="{ 'class-select': orderState === item.status.toString() }"
            @click="orderStateFn(item.status)" v-for="(item, index) in orderStateList">{{ item.name }}</view>
        </view>
      </scroll-view>
    </view>

    <mescroll-body ref="mescrollRef" top="98rpx" @init="mescrollInit" :down="{ use: true }" @up="getOrderListFn"
      @down="onPullDownRefresh">
      <view class="sidebar-margin pt-[var(--top-m)]" v-if="list.length">
        <template v-for="(item, index) in list" :key="index">
          <view class="mb-[var(--top-m)] order-card glass-effect">
            <view @click.stop="toLink(item)" class="order-card-content">
              <!-- 订单顶部栏 -->
              <view class="order-header">
                <view class="order-no">
                  <text class="label">{{ t('orderNo') }}:</text>
                  <text class="value">{{ item.order_no }}</text>
                  <text class="copy-icon nc-iconfont nc-icon-fuzhiV6xx1" @click.stop="copy(item.order_no)"></text>
                </view>
                <view class="order-status" :class="{
                  'status-pending': item.status == 2,
                  'status-processing': item.status == 3 || item.status == 4,
                  'status-completed': item.status == 5,
                  'status-canceled': item.status == -1
                }">{{ getStatusName(item.status) }}</view>
              </view>

              <!-- 订单商品列表 -->
              <view class="order-products">
                <block v-for="(subItem, subIndex) in item.runningOrderProduct" :key="subIndex">
                  <view class="product-item">
                    <view class="product-info">
                      <view class="product-name-price">
                        <text class="product-name">{{ subItem.name }}</text>
                        <view class="product-price">
                          <text class="price-symbol">￥</text>
                          <text class="price-integer">{{
                            parseFloat(subItem.price).toFixed(2).split('.')[0]
                            }}</text>
                          <text class="price-decimal">.{{ parseFloat(subItem.price).toFixed(2).split('.')[1] }}</text>
                        </view>
                      </view>
                      <view class="product-meta">
                        <view class="express-info" v-if="subItem.code && subItem.express_name">
                          {{ subItem.express_name }} · 取件码：{{ subItem.code }}
                        </view>
                        <view class="express-info" v-else-if="subItem.code">
                          取件码：{{ subItem.code }}
                        </view>
                        <text class="product-quantity">x{{ subItem.num }}</text>
                      </view>
                    </view>
                  </view>
                </block>
              </view>

              <!-- 订单信息 -->
              <view class="order-footer">
                <view class="order-meta">
                  <view class="school-info"> 校区:{{ item.school_id_name }}</view>
                  <view class="time-info">{{ item.create_time }}</view>
                </view>
                <!-- 骑手信息 只在已接单或进行中时显示 -->
                <view v-if="(item.status == 2 || item.status == 3) && item.runningRider" class="rider-info">
                  <text class="rider-name">骑手：{{ item.runningRider.nickname }}</text>
                  <view class="call-rider-btn" @click.stop="callRider(item.runningRider.mobile)">
                    <text class="nc-iconfont nc-icon-dianhua"></text>
                    <text>联系骑手</text>
                  </view>
                </view>
              </view>
            </view>

            <!-- 订单总金额 -->
            <view class="order-total flex justify-between">
              <!-- 数量 -->
              <view class="order-quantity text-[#6b7280]">
                <text class="quantity-label">数量：</text>
                <text class="quantity-value">{{ item?.runningOrderProduct?.length }}</text>
              </view>
              <view class="payment-info">
                <view v-if="parseFloat(item.delivery_fee)" class="delivery-fee">配送费</view>
                <view class="actual-payment">实际支付：</view>
                <view class="price">
                  <text class="price-symbol">￥</text>
                  <text class="price-integer">{{
                    parseFloat(item.amount).toFixed(2).split('.')[0]
                    }}</text>
                  <text class="price-decimal">.{{ parseFloat(item.amount).toFixed(2).split('.')[1] }}</text>
                </view>
              </view>
            </view>

            <!-- 订单操作按钮 -->
            <view class="order-actions">
              <view class="action-btn cancel-btn" v-if="item.status == 1" @click.stop="orderBtnFn(item, 'cancel')">取消订单
              </view>
              <view class="action-btn pay-btn" v-if="item.status == 1" @click.stop="orderBtnFn(item, 'pay')">去支付</view>
              <view class="action-btn confirm-btn" v-if="item.status == 4" @click.stop="orderBtnFn(item, 'finish')">确认收货
              </view>
              <!-- 删除订单 -->
              <view class="action-btn delete-btn" v-if="item.status == -1 || item.status == 0"
                @click.stop="orderBtnFn(item, 'delete')">删除订单</view>
            </view>
          </view>
        </template>
      </view>
      <mescroll-empty v-if="!list.length && loading" :option="{ tip: '暂无订单' }"></mescroll-empty>
    </mescroll-body>
    <tabbar addon="running" />
    <pay ref="payRef" @close="payClose"></pay>
  </view>
</template>

<script setup lang="ts">
import { cancelOrder, confirmOrder, deleteOrder, getOrderList } from '@/addon/running/api/order'
import useMescroll from '@/components/mescroll/hooks/useMescroll.js'
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue'
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue'
import { t } from '@/locale'
import useConfigStore from '@/stores/config'
import { copy, redirect } from '@/utils/common'
import { onLoad, onPageScroll, onReachBottom, onShow } from '@dcloudio/uni-app'
import { nextTick, ref } from 'vue'

const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom)
const list = ref<Array<any>>([])
const loading = ref<boolean>(false)
const statusLoading = ref<boolean>(true)
const orderState = ref('')
const orderStateList = ref([
  { name: '全部', status: '' },
  { name: '待付款', status: '1' },
  { name: '待接单', status: '2' },
  { name: '已接单', status: '3' },
  { name: '配送中', status: '4' },
  { name: '已完成', status: '5' },
  { name: '已取消', status: '-1' }
])

const payRef = ref(null)

onLoad((option: any) => {
  orderState.value = option.status || ''
})

onShow(() => {
  nextTick(() => {
    if (getMescroll()) {
      getMescroll().resetUpScroll()
    }
  })
})

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
  return statusMap[status.toString()] || '未知状态'
}

const getOrderListFn = (mescroll: any) => {
  loading.value = false
  let data = {
    page: mescroll.num,
    limit: mescroll.size,
    status: orderState.value
  }

  getOrderList(data)
    .then((res: any) => {
      let newArr = res.data.data as Array<any>
      //设置列表数据
      if (mescroll.num == 1) {
        list.value = [] //如果是第一页需手动制空列表
      }

      list.value = list.value.concat(newArr)
      mescroll.endSuccess(newArr.length)
      loading.value = true
    })
    .catch(() => {
      loading.value = true
      mescroll.endErr() // 请求失败, 结束加载
    })
}

const orderStateFn = (status: any) => {
  orderState.value = status.toString()
  list.value = []
  getMescroll().resetUpScroll()
}

const toLink = (data: any) => {
  console.log(11)

  redirect({ url: '/addon/running/pages/order/detail', param: { id: data.id } })
}

// 支付
const orderBtnFn = (data: any, type = '') => {
  if (type == 'pay') {
    //  payRef.value.open('running', orderId.value, '')
    if (payRef.value) {
      payRef.value.open(
        'runningOrderPay',
        data.id,
        `/addon/running/pages/order/detail?id=${data.id}`
      )
      // }
    }
  } else if (type == 'cancel') {
    cancel(data)
  } else if (type == 'finish') {
    finish(data)
  } else if (type == 'delete') {
    _deleteOrder(data)
  }
}

//关闭订单
const cancel = (item: any) => {
  uni.showModal({
    title: '提示',
    content: '您确定要取消该订单吗？',
    confirmColor: useConfigStore().themeColor['--primary-color'],
    success: (res) => {
      if (res.confirm) {
        cancelOrder({ id: item.id }).then(() => {
          uni.showToast({
            title: '订单已取消',
            icon: 'none'
          })
          getMescroll().resetUpScroll()
        })
      }
    }
  })
}

//确认收货
const finish = (item: any) => {
  uni.showModal({
    title: '提示',
    content: '您确定已收到货了吗？',
    confirmColor: useConfigStore().themeColor['--primary-color'],
    success: (res) => {
      if (res.confirm) {
        uni.showLoading({
          title: '处理中'
        })
        confirmOrder({ id: item.id })
          .then(() => {
            uni.hideLoading()
            uni.showToast({
              title: '确认收货成功',
              icon: 'none'
            })
            getMescroll().resetUpScroll()
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

//删除订单
const _deleteOrder = async (item: any) => {
  const res = await uni.showModal({
    title: '提示',
    content: '您确定要删除该订单吗？'
  })

  if (res.confirm) {
    deleteOrder({ id: item.id }).then((res: any) => {
      uni.showToast({
        title: '订单已删除',
        icon: 'none'
      })
      if (res.code == 1) {
        getMescroll().resetUpScroll()
      }
    })
  }
}

const payClose = () => {
  getMescroll().resetUpScroll()
}

// 上拉加载
const onPullDownRefresh = () => {
  getMescroll().resetUpScroll()
}

const themeColor = () => {
  return {}
}

// 添加联系骑手的方法
const callRider = (mobile) => {
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
  }
}
</script>

<style lang="scss" scoped>
.order-list {
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

  .tab-style-2 {
    background-color: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(10px);
    white-space: nowrap;
    position: relative;
    box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.06);
    border-bottom: 1rpx solid rgba(229, 231, 235, 0.8);

    .tab-content {
      display: flex;
      align-items: center;
      padding: 10rpx 0;

      .tab-items {
        position: relative;
        display: inline-block;
        margin: 0 var(--between-sm);
        padding: 20rpx 20rpx;
        font-size: 28rpx;
        color: #6b7280;
        transition: all 0.3s;
        text-align: center;

        &.class-select {
          position: relative;
          color: #2563eb;
          font-weight: 500;

          &::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 48rpx;
            height: 4rpx;
            background-color: #2563eb;
            border-radius: 2rpx;
          }
        }
      }
    }
  }

  // 卡片样式
  .glass-effect {
    background-color: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(10px);
    border-radius: 16rpx;
    box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);
    border: 1rpx solid rgba(229, 231, 235, 0.8);
  }

  .order-card {
    margin: 0 var(--sides);
    margin-bottom: 24rpx;
    padding: 0;
    position: relative;
    overflow: hidden;

    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      width: 6rpx;
      height: 100%;
      background-color: #2563eb;
    }

    &:active {
      transform: scale(0.99);
    }

    .order-card-content {
      padding: 24rpx;
    }

    .order-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding-bottom: 16rpx;
      border-bottom: 1rpx solid rgba(243, 244, 246, 0.8);

      .order-no {
        display: flex;
        align-items: center;

        .label {
          font-size: 26rpx;
          color: #6b7280;
        }

        .value {
          margin-left: 10rpx;
          font-size: 26rpx;
          color: #374151;
        }

        .copy-icon {
          margin-left: 10rpx;
          font-size: 26rpx;
          color: #6b7280;
          padding: 4rpx;
        }
      }

      .order-status {
        font-size: 26rpx;
        font-weight: 500;
        padding: 6rpx 16rpx;
        border-radius: 30rpx;

        &.status-pending {
          color: #2563eb;
          background-color: rgba(37, 99, 235, 0.1);
        }

        &.status-processing {
          color: #f59e0b;
          background-color: rgba(245, 158, 11, 0.1);
        }

        &.status-completed {
          color: #10b981;
          background-color: rgba(16, 185, 129, 0.1);
        }

        &.status-canceled {
          color: #9ca3af;
          background-color: rgba(156, 163, 175, 0.1);
        }
      }
    }

    .order-products {
      padding: 16rpx 0;

      .product-item {
        padding: 10rpx 0;

        .product-info {
          .product-name-price {
            display: flex;
            justify-content: space-between;
            align-items: center;

            .product-name {
              font-size: 28rpx;
              color: #1f2937;
              font-weight: 500;
              max-width: 500rpx;
            }

            .product-price {
              font-family: 'DIN Alternate', sans-serif;
              color: #2563eb;

              .price-symbol {
                font-size: 22rpx;
              }

              .price-integer {
                font-size: 28rpx;
                font-weight: 600;
              }

              .price-decimal {
                font-size: 22rpx;
              }
            }
          }

          .product-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 8rpx;

            .express-info {
              font-size: 24rpx;
              color: #6b7280;
              max-width: 500rpx;
            }

            .product-quantity {
              font-size: 24rpx;
              color: #6b7280;
            }
          }
        }
      }
    }

    .order-footer {
      padding-top: 16rpx;
      border-top: 1rpx solid rgba(243, 244, 246, 0.8);

      .order-meta {
        display: flex;
        justify-content: space-between;
        align-items: center;

        .school-info {
          font-size: 24rpx;
          color: #6b7280;
          max-width: 400rpx;
        }

        .time-info {
          font-size: 24rpx;
          color: #6b7280;
        }
      }

      .rider-info {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-top: 12rpx;

        .rider-name {
          font-size: 24rpx;
          color: #6b7280;
        }

        .call-rider-btn {
          display: flex;
          align-items: center;
          padding: 6rpx 16rpx;
          background-color: rgba(37, 99, 235, 0.1);
          color: #2563eb;
          border-radius: 30rpx;
          font-size: 22rpx;

          .nc-iconfont {
            margin-right: 6rpx;
            font-size: 24rpx;
          }

          &:active {
            opacity: 0.8;
          }
        }
      }
    }

    .order-total {
      padding: 16rpx 24rpx;
      background-color: rgba(249, 250, 251, 0.6);
      border-top: 1rpx solid rgba(243, 244, 246, 0.8);

      .payment-info {
        display: flex;
        align-items: baseline;
        justify-content: flex-end;

        .delivery-fee {
          font-size: 22rpx;
          color: #9ca3af;
          margin-right: 6rpx;
        }

        .actual-payment {
          font-size: 22rpx;
          color: #374151;
          font-weight: 400;
        }

        .price {
          font-family: 'DIN Alternate', sans-serif;
          color: #ef4444;
          margin-left: 6rpx;

          .price-symbol {
            font-size: 22rpx;
          }

          .price-integer {
            font-size: 32rpx;
            font-weight: 600;
          }

          .price-decimal {
            font-size: 22rpx;
          }
        }
      }
    }

    .order-actions {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      padding: 16rpx 24rpx;

      .action-btn {
        height: 56rpx;
        min-width: 150rpx;
        font-size: 24rpx;
        font-weight: 500;
        border-radius: 30rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-left: 16rpx;

        &.cancel-btn {
          color: #6b7280;
          border: 1rpx solid #d1d5db;
          background-color: white;
        }

        &.pay-btn,
        &.confirm-btn {
          color: white;
          background-color: #2563eb;
          box-shadow: 0 2rpx 8rpx rgba(37, 99, 235, 0.2);
        }

        &:active {
          transform: scale(0.95);
          opacity: 0.9;
        }
      }
    }
  }
}

@mixin text-ellipsis {
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}
</style>
