<template>
    <view class="min-h-[100vh] w-full bg-gradient-to-b from-gray-50 to-gray-100" :style="themeColor()">
        <!-- 固定顶部筛选栏 -->
        <view class="sticky top-0 left-0 right-0 z-50">
            <view class="bg-white shadow-md p-3 transition-all duration-300">
                <scroll-view scroll-x class="whitespace-nowrap pb-2">
                    <view class="inline-flex space-x-3">
                        <view
                            class="px-4 py-1.5 rounded-full text-sm transition-all duration-300 transform hover:scale-105 flex items-center justify-center"
                            :class="status === '' ? 'bg-primary text-white font-medium shadow-sm' : 'bg-gray-100 text-gray-600'"
                            @click="changeStatus('')">
                            全部
                        </view>
                        <view v-for="(item, idx) in statusList" :key="idx"
                            class="px-4 py-1.5 rounded-full text-sm transition-all duration-300 transform hover:scale-105 flex items-center justify-center"
                            :class="status === idx ? 'bg-primary text-white font-medium shadow-sm' : 'bg-gray-100 text-gray-600'"
                            @click="changeStatus(idx)">
                            {{ item }}
                        </view>
                    </view>
                </scroll-view>
            </view>
        </view>

        <mescroll-body ref="mescrollRef" @init="mescrollInit" @down="downCallback" @up="getOrderListFn">
            <view class="px-3 pt-2 pb-3 min-h-screen">
                <!-- 顶部标签页 -->
                <view v-if="!loading && !listData?.length" class="flex flex-col items-center justify-center py-12">
                    <image src="/static/images/empty.png" mode="aspectFit" class="w-32 h-32 mb-4 opacity-70"></image>
                    <view class="text-gray-400 text-sm">暂无推广数据</view>
                </view>

                <!-- 加载动画，只在加载中且没有骨架屏时显示 -->
                <view v-if="loading && listData.length > 0" class="flex justify-center items-center py-10">
                    <view class="loader ease-linear rounded-full border-4 border-t-4 border-gray-200 h-12 w-12"></view>
                </view>

                <!-- 骨架屏 -->
                <template v-if="loading && listData.length === 0">
                    <view v-for="i in 3" :key="i" class="bg-white rounded-lg mb-3 shadow-sm p-3">
                        <view class="flex items-center justify-between mb-2.5">
                            <view class="h-5 bg-gray-200 rounded w-2/3 animate-pulse"></view>
                            <view class="h-5 bg-gray-200 rounded-full w-20 animate-pulse"></view>
                        </view>
                        <view class="flex items-center space-x-3">
                            <view class="flex-shrink-0 w-20 h-20 bg-gray-200 rounded-lg animate-pulse"></view>
                            <view class="flex-1 flex flex-col justify-between h-20">
                                <view class="h-4 bg-gray-200 rounded w-1/3 animate-pulse"></view>
                                <view class="h-6 bg-gray-200 rounded w-1/4 animate-pulse"></view>
                                <view class="flex justify-end">
                                    <view class="h-4 bg-gray-200 rounded w-20 animate-pulse"></view>
                                </view>
                            </view>
                        </view>
                    </view>
                </template>

                <view v-for="(item, index) in listData" :key="index"
                    class="bg-white rounded-lg mb-3 shadow-sm hover:shadow-md transition-all duration-300 active:scale-[0.98] overflow-hidden p-3 transform transition-transform list-item"
                    :style="{ transitionDelay: index * 50 + 'ms' }" @click="goDetail(item.id)">
                    <view class="flex items-center justify-between mb-2.5">
                        <view class="text-base font-medium text-gray-800 line-clamp-1 max-w-[70%]">{{ item.orderTitle }}
                        </view>
                        <view class="text-sm px-2.5 py-1 rounded-full flex items-center" :class="item.status == 1 ? 'bg-green-100 text-green-600' :
                            item.status == 2 ? 'bg-blue-100 text-blue-600' :
                                item.status == 3 ? 'bg-yellow-100 text-yellow-600' :
                                    'bg-gray-100 text-gray-500'">
                            <view class="w-1.5 h-1.5 rounded-full mr-1" :class="item.status == 1 ? 'bg-green-500' :
                                item.status == 2 ? 'bg-blue-500' :
                                    item.status == 3 ? 'bg-yellow-500' :
                                        'bg-gray-400'"></view>
                            {{ item.status_name }}
                        </view>
                    </view>
                    <view class="flex items-center space-x-3">
                        <view class="flex-shrink-0 relative">
                            <image :src="img(item.picUrl)" mode="aspectFill" class="w-16 h-16 rounded-lg"></image>
                            <view v-if="item.tag"
                                class="absolute top-0 left-0 px-1.5 py-0.5 text-[10px] rounded-tl-lg rounded-br-lg bg-red-500 text-white">
                                {{ item.tag }}
                            </view>
                        </view>
                        <view class="flex-1 flex flex-col justify-between">
                            <view class="flex items-center space-x-2">
                                <text class="text-sm text-gray-500">佣金：</text>
                                <text class="text-lg font-medium text-primary">￥{{ item.commission }}</text>
                            </view>
                            <view class="mb-1.5 mt-4 text-sm text-gray-500 flex items-center">
                                <view class="i-mdi-clock-outline mr-1 text-gray-400"></view>
                                <text>{{ item.orderTime }}</text>
                            </view>
                        </view>
                    </view>
                </view>
            </view>
        </mescroll-body>
        <tabbar addon="tk_cpa" />
    </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { onPullDownRefresh, onShow } from '@dcloudio/uni-app'
import {
    getOrderList, getOrderStatus
} from '@/addon/tk_cpa/api/order'
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
import useMescroll from '@/components/mescroll/hooks/useMescroll.js'
import { onPageScroll, onReachBottom } from '@dcloudio/uni-app'
import { img, redirect } from '@/utils/common';
import useConfigStore from '@/stores/config';

const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
const status = ref<string | number>('');
const statusList = ref<string[]>([]);
const listData = ref<any[]>([]);
const loading = ref<boolean>(true);
const mescrollRef = ref(null);

// 加载状态列表
onMounted(() => {
    getOrderStatus().then((res: any) => {
        statusList.value = res.data;
    });
});

const getOrderListFn = (mescroll: any) => {
    const data = ref<{ page?: number, page_size?: number, status?: string | number }>({});
    loading.value = true;
    data.value.page = mescroll.num;
    data.value.page_size = mescroll.size;
    data.value.status = status.value;
    getOrderList(data.value).then((res: any) => {
        const newArr = res.data.data;
        mescroll.endSuccess(newArr.length);
        if (mescroll.num == 1) {
            listData.value = []; //如果是第一页需手动制空列表
        }
        listData.value = listData.value.concat(newArr);
        loading.value = false;
    }).catch((e) => {
        loading.value = false;
        mescroll.endErr(); // 请求失败, 结束加载
    })
}



const goDetail = (id: number) => {
    redirect({ url: `/addon/tk_cpa/pages/order/detail?id=${id}` });
}



const changeStatus = (value: string | number) => {
    if (status.value === value) return; // 避免重复切换
    status.value = value;
    loading.value = true; // 设置加载状态

    // 重置列表并刷新数据
    const mescroll = getMescroll();
    if (mescroll) {
        mescroll.resetUpScroll();
    }
}
</script>

<style lang="scss" scoped>
@import '@/addon/tk_cpa/utils/styles/common.scss';

/* 隐藏滚动条 */
::-webkit-scrollbar {
    display: none;
}

/* 文本截断 */
.line-clamp-1 {
    display: -webkit-box;
    -webkit-line-clamp: 1;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

/* 点击效果 */
.active\:scale-\[0\.98\]:active {
    transform: scale(0.98);
}

/* 过渡动画 */
.transition-all {
    transition-property: all;
    transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

.duration-300 {
    transition-duration: 300ms;
}

.hover\:shadow-md:hover {
    --tw-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
    --tw-shadow-colored: 0 4px 6px -1px var(--tw-shadow-color), 0 2px 4px -2px var(--tw-shadow-color);
    box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
}

/* 悬停时缩放效果 */
.hover\:scale-105:hover {
    transform: scale(1.05);
}

/* 列表项动画 */
.list-item {
    opacity: 0;
    transform: translateY(20px);
    animation: fadeInUp 0.5s ease forwards;
}

@keyframes fadeInUp {
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* 状态筛选按钮样式 */
.bg-primary {
    background-color: var(--primary-color, #3c9cff);
}

.text-primary {
    color: var(--primary-color, #3c9cff);
}

/* 滚动容器 */
scroll-view {
    &::-webkit-scrollbar {
        display: none;
    }
}

/* 订单卡片样式 */
.mb-3 {
    margin-bottom: 0.75rem;
}

.rounded-lg {
    border-radius: 0.5rem;
}

.shadow-sm {
    box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
}

.hover\:shadow-md:hover {
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}

.bg-white {
    background-color: #ffffff;
    border: 1px solid rgba(0, 0, 0, 0.05);
}

/* 加载动画 */
.loader {
    border-top-color: var(--primary-color, #3c9cff);
    animation: spinner 1s linear infinite;
}

@keyframes spinner {
    0% {
        transform: rotate(0deg);
    }

    100% {
        transform: rotate(360deg);
    }
}

/* 骨架屏脉冲动画 */
.animate-pulse {
    animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

@keyframes pulse {

    0%,
    100% {
        opacity: 1;
    }

    50% {
        opacity: 0.5;
    }
}

/* 吸顶相关样式 */
.sticky {
    position: sticky;
    z-index: 999;
}

.shadow-md {
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}
</style>