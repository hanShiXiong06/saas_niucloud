<template>
    <view class="w-screen h-screen bg-[#424040] text-right" :style="themeColor()">
        <image :src="img('static/resource/images/pay/invite_friends_share.png')" mode="heightFix" class="pt-[30rpx] pr-[30rpx] h-[200rpx] w-[auto]" />
        <view class="text-white font-bold pt-[30rpx] pr-[30rpx]">点击右上角跳转到浏览器打开</view>
    </view>
</template>

<script setup lang="ts">
import { img, isWeixinBrowser } from '@/utils/common'
import { onLoad } from '@dcloudio/uni-app'

onLoad((data: any) => {
    if (!isWeixinBrowser() && data.alipay) {
        uni.setStorageSync('paymenting', { trade_type: data.trade_type, trade_id: data.trade_id })
        location.href = data.alipay
    }
})
</script>

<style lang="scss" scoped></style>
