<template>
    <view class="bg-gray-50 min-h-screen" :style="themeColor()" v-if="sidInfo">
        <!-- 顶部卡片 -->
        <view class="bg-white rounded-b-3xl shadow-sm p-6 mb-4 relative">
            <!-- 项目信息卡片 -->
            <view class="flex items-start">
                <view class="flex-shrink-0">
                    <image :src="img(sidInfo.act_info.itemPic)"
                        class="w-16 h-16 rounded-2xl object-cover shadow-lg ring-2 ring-white ring-offset-2 ring-offset-gray-50"
                        mode="aspectFill">
                    </image>
                </view>
                <view class="flex-1 ml-4 min-w-0 mt-0.5">
                    <view class="text-[38rpx] font-bold text-gray-900 mb-3 line-clamp-2 leading-tight">
                        {{ sidInfo.act_info.title }}
                    </view>
                    <!-- 标签区域 -->
                    <view class="flex flex-wrap gap-2 mt-3 mb-2" v-if="labels.length > 0">
                        <view v-for="(item, index) in labels" :key="index"
                            class="px-3 py-1 text-sm rounded-full bg-gray-50 text-gray-600 border border-gray-200 shadow-sm">
                            {{ item }}
                        </view>
                    </view>
                </view>
            </view>



            <!-- 项目简介 -->
            <view class="text-gray-500 text-[26rpx] leading-relaxed  bg-gray-50 p-2 rounded-xl border border-gray-100">
                <text class="text-red-500 font-medium">*</text>{{ sidInfo.act_info.simpleDescription }}
            </view>
        </view>

        <!-- 用户信息卡片 -->
        <view class="bg-white rounded-xl shadow-sm p-5 mb-3 mx-3">
            <view class="flex justify-between items-center py-2 border-b border-gray-100 mb-2">
                <view class="text-base font-bold text-gray-800 truncate max-w-[70%]">{{ sidInfo.nickName }}</view>
                <view v-if="sidInfo.status == 0"
                    class="px-3 py-1 text-xs rounded-full bg-yellow-100 text-yellow-600 font-medium shadow-sm"
                    @click.stop="refreshEvent(sidInfo.id)">
                    刷新状态
                </view>
                <view v-else-if="sidInfo.status == 1"
                    class="px-3 py-1 text-xs rounded-full bg-green-100 text-green-600 font-medium shadow-sm">
                    成功
                </view>
                <view v-else-if="sidInfo.status == 2"
                    class="px-3 py-1 text-xs rounded-full bg-red-100 text-red-600 font-medium shadow-sm">
                    失败
                </view>
            </view>

            <!-- 内容区域 -->
            <view class="pt-1">
                <!-- 项目信息 -->
                <view class="flex items-center mb-3" style="width: 100%;">
                    <text class="text-gray-500 text-sm">项目：</text>
                    <text class="text-gray-800 text-[28rpx] font-bold flex-1 ml-1">{{ sidInfo.cpaProjectId_name
                        }}</text>
                </view>

                <!-- 二维码和信息部分布局 -->
                <view class="flex" v-if="sidInfo.promotionCode != ''">
                    <!-- 左侧信息 -->
                    <view class="flex-1 bg-gray-50 rounded-xl p-3 mr-3 border border-gray-100">
                        <view class="flex flex-col gap-2.5 text-sm">
                            <view class="flex items-center">
                                <text class="w-[70px] text-gray-500">手机号码:</text>
                                <text class="text-gray-700 font-medium">{{ sidInfo.phone }}</text>
                            </view>

                            <view class="flex items-center">
                                <text class="w-[70px] text-gray-500">推广标识:</text>
                                <text class="text-gray-700 font-medium">{{ sidInfo.sid }}</text>
                            </view>

                            <view class="flex items-center">

                                <text class="text-gray-700 font-medium">{{ sidInfo.create_time }}</text>
                            </view>
                        </view>
                    </view>

                    <!-- 右侧二维码 -->
                    <view
                        class="flex flex-col items-center justify-center bg-gray-50 rounded-xl p-2 border border-gray-100">
                        <image :src="img(sidInfo.promotionCode)"
                            class="w-18 h-18 rounded-md bg-white border border-gray-200 shadow-sm" mode="aspectFit"
                            @click.stop="previewImage(img(sidInfo.promotionCode))">
                        </image>
                        <text class="text-xs text-gray-500 mt-1">点击查看</text>
                    </view>
                </view>
            </view>

            <!-- 链接区域 -->
            <view v-if="sidInfo.promotionUrl != ''"
                class="mt-4 rounded-xl overflow-hidden border border-gray-100 divide-y divide-gray-100 bg-gray-50 shadow-sm">
                <!-- 做单链接部分 -->
                <view class="bg-white p-3">
                    <view class="flex items-center justify-between mb-2">
                        <view class="flex items-center">
                            <text class="text-gray-700 font-medium">做单链接</text>
                            <view class="ml-2 px-2 py-0.5 bg-green-50 text-green-500 text-xs rounded-full shadow-sm">必要
                            </view>
                        </view>
                        <view class="flex items-center">
                            <button @click="copy(sidInfo.promotionUrl, '已复制做单链接')"
                                class="flex items-center px-3 py-1.5 rounded-full bg-gradient-to-r from-green-500 to-green-600 text-white text-xs font-medium shadow-md transform transition hover:scale-105 active:scale-95">
                                <text class="mr-1 text-white text-xs">复制链接</text>
                                <view class="i-carbon-copy text-white text-[14px]"></view>
                            </button>
                        </view>
                    </view>
                    <view
                        class="bg-gray-50 p-3 rounded-lg text-gray-600 text-sm break-all line-clamp-2 border border-gray-100">
                        {{ sidInfo.promotionUrl }}
                    </view>
                </view>

                <!-- 查单链接部分 -->
                <view class="bg-white p-3 mt-3">
                    <view class="flex items-center justify-between mb-2">
                        <view class="flex items-center">
                            <text class="text-gray-700 font-medium">查单链接</text>
                            <view class="ml-2 px-2 py-0.5 bg-green-50 text-green-600 text-xs rounded-full shadow-sm">辅助
                            </view>
                        </view>
                        <view class="flex items-center">
                            <button @click="copy(sidInfo.queryDataUrl, '已复制查单链接')"
                                class="flex items-center px-3 py-1.5 rounded-full bg-gradient-to-r from-green-500 to-green-600 text-white text-xs font-medium shadow-md transform transition hover:scale-105 active:scale-95">
                                <text class="mr-1 text-white text-xs">复制链接</text>
                                <view class="i-carbon-copy text-white text-[14px]"></view>
                            </button>
                        </view>
                    </view>
                    <view
                        class="bg-gray-50 p-3 rounded-lg text-gray-600 text-sm break-all line-clamp-2 border border-gray-100">
                        {{ sidInfo.queryDataUrl }}
                    </view>
                </view>
            </view>
        </view>

        <!-- 选项卡 -->
        <view class="bg-white/80 sticky top-0 z-10 shadow-sm backdrop-blur-sm mb-4">
            <view class="tab-container">
                <view v-for="(item, index) in tabList" :key="index" class="tab-item"
                    :class="{ 'tab-active': currentTab === index }" @click="tabChange(index)">
                    {{ item.name }}
                </view>
            </view>
        </view>

        <!-- 内容区域 -->
        <view class="px-4 pb-28">
            <view v-if="currentTab === 0">
                <view class="bg-white rounded-xl shadow-sm p-4 mb-3">
                    <view class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <view class="w-1 h-5 bg-red-500 rounded-full mr-2"></view>
                        结算说明
                    </view>
                    <view class="text-gray-600 text-sm leading-relaxed">
                        <u-parse :content="sidInfo.act_info.settlementDesc"></u-parse>
                    </view>
                </view>
                <view class="bg-white rounded-xl shadow-lg p-4">
                    <view class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <view class="w-1 h-5 bg-red-500 rounded-full mr-2"></view>
                        项目详情
                    </view>
                    <view class="text-gray-600 text-sm leading-relaxed">
                        <u-parse :content="sidInfo.act_info.projectDesc"></u-parse>
                    </view>
                </view>
            </view>
            <view v-else>
                <view class="bg-white rounded-xl shadow-sm p-4">
                    <view class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <view class="w-1 h-5 bg-red-500 rounded-full mr-2"></view>
                        推广教程
                    </view>
                    <view class="text-gray-600 text-sm leading-relaxed">
                        <u-parse :content="sidInfo.act_info.promotionDesc"></u-parse>
                    </view>
                </view>
            </view>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, reactive, computed } from 'vue';
import { getSidInfo } from '@/addon/tk_cpa/api/sid'
import { onLoad } from '@dcloudio/uni-app'
import { img, getToken, redirect, copy, saveImageToPhotosAlbum } from '@/utils/common';
import { useLogin } from "@/hooks/useLogin";
const currentTab = ref(0);
const isCollected = ref(false);
const tabList = ref([
    { name: '项目详情' },
    { name: '推广教程' }
]);
const tabChange = (index: number) => {
    currentTab.value = index;
};
// 预览图片
const previewImage = (url: string) => {
    uni.previewImage({
        urls: [img(url)],
        current: img(url),
        success: () => {
            // 预览成功后可以保存
            uni.showActionSheet({
                itemList: ['保存到相册'],
                success: (res) => {
                    if (res.tapIndex === 0) {
                        saveImageToPhotosAlbum(img(url));
                    }
                }
            });
        }
    });
}

// 主题颜色函数
const themeColor = () => {
    return {
        "--theme-color": "#f56c6c",
        "--theme-color-light": "rgba(245, 108, 108, 0.1)"
    }
}

// 刷新状态函数
const refreshEvent = (id: string | number) => {
    uni.showLoading({ title: '刷新中...' });
    getSidInfo(id).then((res: any) => {
        if (res.code === 1) {
            sidInfo.value = res.data;
            uni.showToast({ title: '刷新成功', icon: 'success' });
        } else {
            uni.showToast({ title: res.msg || '刷新失败', icon: 'none' });
        }
    }).catch(() => {
        uni.showToast({ title: '网络错误', icon: 'none' });
    }).finally(() => {
        uni.hideLoading();
    });
}

const sidInfo = ref<any>();

// 处理标签数据
const labels = computed(() => {
    if (sidInfo.value?.act_info?.labelText && Array.isArray(sidInfo.value.act_info.labelText)) {
        return sidInfo.value.act_info.labelText.filter((item: string) => item !== '');
    }
    return [];
});

onLoad((query: any) => {
    if (query?.id) {
        getSidInfo(query.id).then((res: any) => {
            sidInfo.value = res.data;
        });
    }
});
</script>

<style lang="scss" scoped>
.tab-container {
    display: flex;
    justify-content: center;
    padding: 14px 20px;
    background-color: rgba(255, 255, 255, 0.9);
    border-radius: 0;
    max-width: 750rpx;
    margin: 0 auto;
}

.tab-item {
    flex: 1;
    max-width: 160px;
    text-align: center;
    font-size: 15px;
    font-weight: 500;
    padding: 12px 20px;
    margin: 0 10px;
    border-radius: 12px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    cursor: pointer;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);

    &:hover {
        background-color: rgba(245, 108, 108, 0.08);
    }

    &.tab-active {
        color: #f56c6c;
        font-weight: 600;
        background-color: rgba(245, 108, 108, 0.12);
        box-shadow: 0 2px 4px rgba(245, 108, 108, 0.15);

        &::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 50%;
            transform: translateX(-50%);
            width: 24px;
            height: 3px;
            background-color: #f56c6c;
            border-radius: 2px;
        }
    }
}

:deep(.u-tabs__wrapper) {
    display: flex;
    justify-content: center;
    background-color: white;
    padding: 10px 0;
    border-radius: 16px;
}

:deep(.u-tabs__wrapper__nav) {
    display: flex;
    justify-content: center;
    width: 100%;
    padding: 0 12px;
}

:deep(.u-tabs__wrapper__nav__item) {
    flex: 1;
    max-width: 140px;
    text-align: center;
    font-size: 15px;
    font-weight: 500;
    padding: 10px 16px;
    margin: 0 8px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    border-radius: 10px;
    position: relative;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);

    &:hover {
        background-color: rgba(245, 108, 108, 0.08);
    }
}

:deep(.u-tabs__wrapper__nav__item--active) {
    background-color: rgba(245, 108, 108, 0.12) !important;
    position: relative;
    box-shadow: 0 2px 4px rgba(245, 108, 108, 0.15);
}

:deep(.u-tabs__wrapper__nav__line) {
    height: 3px;
    width: 20px !important;
    border-radius: 2px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    bottom: 0;
    background-color: #f56c6c !important;
    left: 50% !important;
    transform: translateX(-50%) !important;
}

:deep(.u-button) {
    height: 44px;
    font-size: 16px;
    font-weight: 600;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    border-radius: 12px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

    &:active {
        transform: scale(0.97);
    }

    &.u-button--plain {
        background-color: #fff !important;
        border: 1px solid #f56c6c !important;
        color: #f56c6c !important;

        &:active {
            background-color: rgba(245, 108, 108, 0.05) !important;
        }
    }
}

:deep(.u-parse) {
    padding: 6px 0;

    img {
        border-radius: 8px;
        margin: 8px 0;
    }
}
</style>
