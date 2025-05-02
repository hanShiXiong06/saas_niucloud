<template>
  <view class="order-create">
    <!-- 服务信息 -->
    <view class="service-info">
      <image class="service-image" :src="serviceInfo.image" mode="aspectFill"></image>
      <view class="service-detail">
        <text class="name">{{ serviceInfo.name }}</text>
        <text class="price">¥{{ serviceInfo.price }}</text>
      </view>
    </view>

    <!-- 订单信息 -->
    <view class="order-form">
      <view class="form-item">
        <text class="label">取件地址</text>
        <input class="input" v-model="form.pickup_address" placeholder="请输入取件地址" />
      </view>
      <view class="form-item">
        <text class="label">取件时间</text>
        <picker mode="time" :value="form.pickup_time" @change="onPickupTimeChange">
          <view class="picker">
            <text>{{ form.pickup_time || '请选择取件时间' }}</text>
            <text class="iconfont icon-arrow-right"></text>
          </view>
        </picker>
      </view>
      <view class="form-item">
        <text class="label">送达地址</text>
        <input class="input" v-model="form.delivery_address" placeholder="请输入送达地址" />
      </view>
      <view class="form-item">
        <text class="label">备注信息</text>
        <textarea class="textarea" v-model="form.remark" placeholder="请输入备注信息（选填）" />
      </view>
    </view>

    <!-- 底部提交栏 -->
    <view class="submit-bar">
      <view class="price-info">
        <text>服务费：</text>
        <text class="price">¥{{ serviceInfo.price }}</text>
      </view>
      <button class="submit-btn" @click="onSubmit">提交订单</button>
    </view>
  </view>
</template>

<script>
import { createOrder, getProductDetail } from '../../api/index'

export default {
  data() {
    return {
      service_id: '',
      school_id: '',
      serviceInfo: {},
      form: {
        pickup_address: '',
        pickup_time: '',
        delivery_address: '',
        remark: ''
      }
    }
  },
  onLoad(options) {
    this.service_id = options.service_id
    this.school_id = options.school_id
    this.getServiceDetail()
  },
  methods: {
    // 获取服务详情
    async getServiceDetail() {
      try {
        const res = await getProductDetail({
          id: this.service_id,
          school_id: this.school_id
        })
        this.serviceInfo = res.data
      } catch (error) {
        uni.showToast({
          title: error.message || '获取服务详情失败',
          icon: 'none'
        })
      }
    },

    // 取件时间选择
    onPickupTimeChange(e) {
      this.form.pickup_time = e.detail.value
    },

    // 表单验证
    validateForm() {
      if (!this.form.pickup_address) {
        uni.showToast({
          title: '请输入取件地址',
          icon: 'none'
        })
        return false
      }
      if (!this.form.pickup_time) {
        uni.showToast({
          title: '请选择取件时间',
          icon: 'none'
        })
        return false
      }
      if (!this.form.delivery_address) {
        uni.showToast({
          title: '请输入送达地址',
          icon: 'none'
        })
        return false
      }
      return true
    },

    // 提交订单
    async onSubmit() {
      if (!this.validateForm()) return

      try {
        const res = await createOrder({
          service_id: this.service_id,
          school_id: this.school_id,
          ...this.form
        })

        uni.showToast({
          title: '下单成功',
          icon: 'success'
        })

        // 跳转到订单详情页
        setTimeout(() => {
          uni.redirectTo({
            url: `/addon/running/pages/order/detail?id=${res.data.id}`
          })
        }, 1500)
      } catch (error) {
        uni.showToast({
          title: error.message || '下单失败',
          icon: 'none'
        })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.order-create {
  min-height: 100vh;
  background-color: #f5f5f5;
  padding-bottom: 120rpx;

  .service-info {
    background-color: #fff;
    padding: 30rpx;
    display: flex;
    align-items: center;
    margin-bottom: 20rpx;

    .service-image {
      width: 160rpx;
      height: 160rpx;
      border-radius: 8rpx;
      margin-right: 20rpx;
    }

    .service-detail {
      flex: 1;

      .name {
        font-size: 32rpx;
        color: #333;
        margin-bottom: 10rpx;
        display: block;
      }

      .price {
        font-size: 36rpx;
        color: #ff6b6b;
        font-weight: bold;
      }
    }
  }

  .order-form {
    background-color: #fff;
    padding: 0 30rpx;

    .form-item {
      padding: 30rpx 0;
      border-bottom: 1rpx solid #eee;

      &:last-child {
        border-bottom: none;
      }

      .label {
        font-size: 28rpx;
        color: #333;
        margin-bottom: 20rpx;
        display: block;
      }

      .input {
        font-size: 28rpx;
        color: #333;
      }

      .textarea {
        width: 100%;
        height: 160rpx;
        font-size: 28rpx;
        color: #333;
      }

      .picker {
        display: flex;
        align-items: center;
        justify-content: space-between;
        font-size: 28rpx;
        color: #333;

        .icon-arrow-right {
          color: #999;
          font-size: 24rpx;
        }
      }
    }
  }

  .submit-bar {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    height: 100rpx;
    background-color: #fff;
    display: flex;
    align-items: center;
    padding: 0 30rpx;
    box-shadow: 0 -2rpx 10rpx rgba(0, 0, 0, 0.05);

    .price-info {
      flex: 1;
      font-size: 28rpx;
      color: #333;

      .price {
        font-size: 36rpx;
        color: #ff6b6b;
        font-weight: bold;
      }
    }

    .submit-btn {
      width: 240rpx;
      height: 80rpx;
      line-height: 80rpx;
      text-align: center;
      background-color: #ff6b6b;
      color: #fff;
      font-size: 32rpx;
      border-radius: 40rpx;
    }
  }
}
</style>
