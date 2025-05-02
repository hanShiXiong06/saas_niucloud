<template>
    <view class="min-h-[100vh] w-full bg-gradient-to-b from-gray-50 to-gray-100"
        :style="useConfigStore().getThemeColor()">
        <mescroll-body ref="mescrollRef" @init="mescrollInit" @down="downCallback" @up="getActListFn">
            <view class="px-4 py-3 min-h-screen">
                <mescroll-empty v-if="!listData?.length" :option="{ tip: '暂无活动数据' }"></mescroll-empty>
                <view v-for="(item, index) in listData" :key="index"
                    class="bg-white rounded-xl mb-4 overflow-hidden shadow-sm hover:shadow-lg transition-all duration-300 transform hover:-translate-y-1 border border-gray-100 active:scale-[0.98]"
                    @click="goDetail(item)">
                    <view class="flex items-center p-4">
                        <view class="flex-shrink-0">
                            <image :src="img(item.itemPic)" class="w-16 h-16 rounded-lg object-cover shadow-md"
                                mode="aspectFill">
                            </image>
                        </view>
                        <view class="flex-1 ml-4 min-w-0">
                            <view
                                class="text-base font-medium text-gray-900 mb-2 line-clamp-1 whitespace-nowrap overflow-hidden text-ellipsis">
                                {{ item.title }}
                            </view>
                            <view class="flex items-center gap-2">
                                <view
                                    class="bg-gradient-to-r from-red-50 to-red-100 px-2.5 py-1 rounded-full inline-flex items-center">
                                    <text class="text-red-500 text-xs font-bold">佣金</text>
                                    <view class="flex items-baseline ml-1.5">
                                        <text v-if="item.minMoney === item.maxMoney"
                                            class="text-red-500 font-bold text-sm">{{
                                                item.minMoney }}</text>
                                        <text v-else class="text-red-500 font-bold text-sm">{{ item.minMoney }}-{{
                                            item.maxMoney
                                        }}</text>
                                    </view>
                                </view>
                            </view>
                        </view>
                    </view>
                    <view class="px-4 py-3 bg-gray-50 flex justify-between items-center border-t border-gray-100">
                        <view class="flex flex-wrap gap-2">
                            <block v-for="(item1, index1) in item.labelText.slice(0, 2)" :key="index1">
                                <view v-if="item1" :class="[
                                    'px-2 py-1 rounded text-xs font-medium',
                                    getLabelStyle(index1)
                                ]">
                                    {{ item1 }}
                                </view>
                            </block>
                            <view v-if="item.labelText.length > 2"
                                class="px-2 py-1 rounded text-xs font-medium bg-gray-100 text-gray-500">
                                ...
                            </view>
                        </view>
                        <view class="text-gray-500 text-xs flex items-center max-w-[50%]">
                            <text class="whitespace-nowrap overflow-hidden text-ellipsis">{{ item.simpleDescription
                            }}</text>
                        </view>
                    </view>
                </view>
            </view>
        </mescroll-body>
        <tabbar addon="tk_cpa" />
    </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import {
    getActList
} from '@/addon/tk_cpa/api/act'
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
import useMescroll from '@/components/mescroll/hooks/useMescroll.js'
import { onPageScroll, onReachBottom } from '@dcloudio/uni-app'
import { img, redirect } from '@/utils/common';
import useConfigStore from '@/stores/config';

const configStore = useConfigStore();
const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
const listData = ref();
const loading = ref<boolean>(false);

const getActListFn = (mescroll: any) => {
    const data = ref<{ page?: number, page_size?: number }>({});
    loading.value = false;
    data.value.page = mescroll.num;
    data.value.page_size = mescroll.size;
    getActList(data.value).then((res: any) => {
        const newArr = res.data.data;
        mescroll.endSuccess(newArr.length);
        if (mescroll.num == 1) {
            listData.value = []; //如果是第一页需手动制空列表
        }
        listData.value = listData.value.concat(newArr);
        loading.value = true;
    }).catch((e) => {
        loading.value = true;
        mescroll.endErr(); // 请求失败, 结束加载
    })
}

const goDetail = (item: any) => {
    redirect({ url: `/addon/tk_cpa/pages/act/detail?id=${item.id}` });
}

const getLabelStyle = (index: number) => {
    const styles = [
        'bg-blue-200 text-blue-800 border border-blue-400 shadow-sm',
        'bg-green-200 text-green-800 border border-green-400 shadow-sm',
        'bg-purple-200 text-purple-800 border border-purple-400 shadow-sm',
        'bg-yellow-200 text-yellow-800 border border-yellow-400 shadow-sm',
        'bg-pink-200 text-pink-800 border border-pink-400 shadow-sm',
        'bg-indigo-200 text-indigo-800 border border-indigo-400 shadow-sm',
        'bg-orange-200 text-orange-800 border border-orange-400 shadow-sm',
        'bg-teal-200 text-teal-800 border border-teal-400 shadow-sm'
    ];
    return styles[index % styles.length];
}
</script>

<style lang="scss" scoped>
@import '@/addon/tk_cpa/utils/styles/common.scss';

:deep(.u-image) {
    border-radius: theme('borderRadius.md');
}

.line-clamp-1 {
    display: -webkit-box;
    -webkit-line-clamp: 1;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

/* 增加过渡动画效果 */
.transform {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* 优化卡片阴影 */
.shadow-sm {
    box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
}

.hover\:shadow-lg:hover {
    box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
}

/* 标签动画效果 */
@keyframes labelPulse {
    0% {
        transform: scale(1);
    }

    50% {
        transform: scale(1.05);
    }

    100% {
        transform: scale(1);
    }
}

.px-2 {
    animation: labelPulse 2s infinite;
    transition: all 0.3s ease;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    font-weight: 600;
}

.px-2:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.15);
}

/* 点击效果 */
.active\:scale-\[0\.98\]:active {
    transform: scale(0.98);
}
</style>