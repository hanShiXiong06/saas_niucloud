<template>
    <view class="min-h-[100vh] w-full bg-[#f5f5f5]" :style="themeColor()">
        <!-- 顶部导航 -->
        <view class="fixed top-0 left-0 right-0 z-50">
            <u-navbar title="推广产品" :autoBack="true" bgColor="var(--primary-color)"
                titleStyle="color: #ffffff"></u-navbar>
        </view>

        <view class="pt-[44px] pb-20 px-4">
            <!-- 产品列表 -->
            <view class="mt-4">
                <view v-if="productList.length > 0">
                    <view v-for="(item, index) in productList" :key="index"
                        class="mb-4 bg-white rounded-lg shadow-sm overflow-hidden">
                        <view class="flex p-3">
                            <image :src="img(item.image)" class="w-24 h-24 rounded-md" mode="aspectFill"></image>
                            <view class="ml-3 flex-1">
                                <view class="text-gray-800 font-medium line-clamp-2">{{ item.title }}</view>
                                <view class="flex items-center mt-1">
                                    <text class="text-red-500 text-lg font-medium">¥{{ item.price }}</text>
                                    <text class="text-gray-400 text-xs ml-2 line-through">¥{{ item.market_price
                                        }}</text>
                                </view>
                                <view class="flex justify-between mt-2">
                                    <view class="text-sm text-orange-500">佣金: ¥{{ item.commission }}</view>
                                    <view class="bg-[var(--primary-color)] text-white text-sm px-3 py-1 rounded-full"
                                        @click="shareProduct(item)">分享推广</view>
                                </view>
                            </view>
                        </view>
                    </view>
                </view>
                <view v-else class="py-20 flex flex-col items-center justify-center">
                    <u-empty mode="data" icon="http://cdn.uviewui.com/uview/empty/data.png"></u-empty>
                    <text class="text-gray-500 mt-3">暂无可推广产品</text>
                </view>
            </view>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { img, redirect, copy } from '@/utils/common';
import useConfigStore from '@/stores/config'

const configStore = useConfigStore();
const themeColor = () => {
    return configStore.getThemeColor();
}

// 模拟产品数据
const productList = ref([
    {
        id: 1,
        title: '示例产品1 - 高品质商品',
        image: 'static/resource/images/default_goods.png',
        price: '99.00',
        market_price: '199.00',
        commission: '19.80'
    },
    {
        id: 2,
        title: '示例产品2 - 热销爆款',
        image: 'static/resource/images/default_goods.png',
        price: '129.00',
        market_price: '259.00',
        commission: '25.80'
    },
    {
        id: 3,
        title: '示例产品3 - 限时折扣',
        image: 'static/resource/images/default_goods.png',
        price: '79.00',
        market_price: '158.00',
        commission: '15.80'
    }
]);

// 分享产品
const shareProduct = (item: any) => {
    uni.showToast({
        title: '准备分享产品: ' + item.title,
        icon: 'none'
    });
    // 实际项目中可以跳转到分享页或调用分享API
}

onMounted(() => {
    // 实际项目中这里可以请求API获取产品列表
});
</script>

<style lang="scss" scoped>
@import '@/addon/tk_partner/utils/styles/common.scss';
</style>
