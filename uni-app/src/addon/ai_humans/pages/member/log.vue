<template>
    <view class="bg-[var(--page-bg-color)] min-h-screen pb-2" :style="themeColor()">



        <mescroll-body ref="mescrollRef" top="20rpx" @init="mescrollInit" @down="downCallback" @up="getMemberLogListFn">
            <!-- 固定顶部导航栏 -->

            <view class="fixed top-2 ml-2 mr-2 left-0 right-0 z-50 bg-white/90 px-2 py-2 !pt-2 rounded-2xl">
                <scroll-view scroll-x class="scroll-Y box-border px-[24rpx]" show-scrollbar="false">
                    <view class="flex whitespace-nowrap justify-around rounded-lg">
                        <view
                            :class="['py-2 px-2 rounded-lg text-[28rpx]', currentTab === idx ? 'active-tab' : 'inactive-tab']"
                            @click="changeTab(idx)" v-for="(tab, idx) in tabs" :key="idx">
                            {{ tab.name }}
                        </view>
                    </view>
                </scroll-view>
            </view>
            <!-- 为固定导航腾出空间 -->
            <view class="h-12 mb-2"></view>
            <view v-if="filteredList.length > 0" class="space-y-3 px-2">
                <view class="bg-white p-4 rounded-xl shadow-sm transition-all duration-300 hover:shadow-md"
                    v-for="(item, index) in filteredList" :key="index">
                    <view class="flex flex-col">
                        <view class="flex justify-between items-start mb-2">
                            <view class="text-base font-medium text-gray-700 flex-1 pr-2">{{ item.desc }}</view>
                            <view class="text-sm text-gray-400">{{ item.create_time }}</view>
                        </view>
                        <view class="flex justify-between items-center">
                            <view class="flex items-center">
                                <text :class="[Number(item.num) >= 0 ? 'text-green-500' : 'text-red-500']"
                                    class="text-lg font-bold">
                                    {{ Number(item.num) >= 0 ? '+' : '' }}{{ item.num }}
                                </text>
                                <text class="text-sm ml-1 text-gray-500" v-if="item.point > 0">{{ config.name }}</text>
                            </view>
                            <view>
                                <text class="text-xs px-2 py-1 rounded-full"
                                    :class="[Number(item.num) >= 0 ? 'bg-green-100 text-green-600' : 'bg-red-100 text-red-600']">
                                    {{ Number(item.num) >= 0 ? '获取' : '消耗' }}
                                </text>
                            </view>
                        </view>
                    </view>
                </view>
            </view>
            <mescroll-empty :option="{
                icon: img('addon/ai_humans/images/empty.png'),
                tip: '暂无数据',
            }" v-if="!filteredList.length && loading">
            </mescroll-empty>
        </mescroll-body>
    </view>
    <!-- #ifdef MP-WEIXIN -->
    <!-- 小程序隐私协议 -->
    <wx-privacy-popup ref="wxPrivacyPopupRef"></wx-privacy-popup>
    <!-- #endif -->
</template>

<script setup lang="ts">
import { ref, reactive, onUnmounted, computed } from "vue";
import { downloadFileEvent } from "@/addon/ai_humans/utils/ts/common"
import { confirm } from "@/addon/ai_humans/utils/ts/alert"
import { img, copy, redirect } from "@/utils/common";
import { getMemberLog } from "@/addon/ai_humans/api/member";
import MescrollBody from "@/components/mescroll/mescroll-body/mescroll-body.vue";
import MescrollEmpty from "@/components/mescroll/mescroll-empty/mescroll-empty.vue";
import useMescroll from "@/components/mescroll/hooks/useMescroll.js";
import { onLoad, onPageScroll, onReachBottom } from "@dcloudio/uni-app";
import useConfigStore from "@/stores/config";
const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);

// 通过mixins定义的方法，手动定义以解决类型错误
const themeColor = () => {
    const configStore = useConfigStore();
    return configStore.getThemeColor();
};

// 定义tab选项
const tabs = [
    { name: '全部', type: 'all' },
    { name: '获取', type: 'income' },
    { name: '消耗', type: 'expense' }
];
const currentTab = ref(0);

let list = ref<Array<any>>([]);
let loading = ref<boolean>(false);
import { getConfig } from '@/addon/ai_humans/api/config';
const config = ref<any>({});

// 根据选中的tab过滤列表
const filteredList = computed(() => {
    if (currentTab.value === 0) return list.value;
    if (currentTab.value === 1) return list.value.filter(item => Number(item.num) >= 0);
    if (currentTab.value === 2) return list.value.filter(item => Number(item.num) < 0);
    return list.value;
});

// 切换tab
const changeTab = (idx: number) => {
    if (currentTab.value === idx) return;
    currentTab.value = idx;
    // 切换tab后重置列表并重新加载
    const mescroll = getMescroll();
    if (mescroll) {
        mescroll.resetUpScroll();
    }
};

getConfig().then((res) => {
    config.value = res.data;
})

const getMemberLogListFn = (mescroll) => {
    loading.value = false;
    let data: object = {
        page: mescroll.num,
        limit: mescroll.size,
        type: tabs[currentTab.value].type === 'all' ? '' : tabs[currentTab.value].type
    };
    getMemberLog(data)
        .then((res) => {
            let newArr = res.data.data as Array<any>;
            //设置列表数据
            if (mescroll.num == 1) {
                list.value = []; //如果是第一页需手动制空列表
            }
            list.value = list.value.concat(newArr);
            mescroll.endSuccess(newArr.length);
            loading.value = true;
        })
        .catch(() => {
            loading.value = true;
            mescroll.endErr(); // 请求失败, 结束加载
        });
};
</script>

<style lang="scss">
@import "@/addon/ai_humans/utils/styles/common.scss";

.active-tab {
    background-color: var(--primary-color);
    color: white;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.inactive-tab {
    background-color: transparent;
    color: var(--primary-color);
}
</style>
