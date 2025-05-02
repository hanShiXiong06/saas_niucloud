<template>
    <view class="bg-[var(--page-bg-color)] min-h-screen p-2" :style="themeColor()">
        <!-- 固定在顶部的状态栏 -->
        <view class="fixed top-2 ml-2 mr-2 left-0 right-0 z-50 bg-white/90 px-2 py-2 !pt-2 rounded-2xl"
            v-if="videoStatusList && videoStatusList.length > 0">
            <scroll-view scroll-x class="scroll-Y box-border px-[24rpx]" show-scrollbar="false">
                <view class="flex whitespace-nowrap justify-around rounded-lg">
                    <view
                        :class="['py-2 px-2 rounded-lg text-[28rpx]', status === item.status ? 'active-tab' : 'inactive-tab']"
                        @click="selectStatusFn(item)" v-for="(item, index) in videoStatusList" :key="index">
                        {{ item.name }}
                    </view>
                </view>
            </scroll-view>
        </view>
        <!-- 调整mescroll-body的top值 -->
        <mescroll-body ref="mescrollRef" top="120rpx" @init="mescrollInit" @down="downCallback"
            @up="getCreateVideoListFn">
            <!-- 调试信息 -->
            <view v-if="showDebug" class="p-2 bg-black/50 text-white text-xs mb-2 rounded">
                <view>状态: {{ status }}</view>
                <view>列表数量: {{ list.length }}</view>
                <view>加载状态: {{ loading ? '已加载' : '加载中' }}</view>
            </view>

            <view v-if="list.length > 0" class="flex flex-wrap -mx-2">
                <view v-for="(item, index) in list" :key="index" class="w-1/2 px-2 mb-4 box-border">
                    <view
                        class="rounded-xl shadow-lg overflow-hidden backdrop-blur-sm transform transition-all duration-300 hover:scale-[1.02] border border-solid border-[var(--primary-color-light2)]"
                        :style="{ background: 'linear-gradient(135deg, rgba(var(--primary-color-rgb), 0.05) 0%, rgba(var(--primary-color-rgb), 0.1) 100%)', boxShadow: '0 0 20px rgba(var(--primary-color-rgb), 0.1)' }">

                        <!-- 处理中的视频 -->
                        <view class="w-full relative" v-if="item.status == 0 || item.status == 1">
                            <!-- 主容器 -->
                            <view class="w-full h-[240rpx] relative overflow-hidden">
                                <!-- 边框发光效果 -->

                                <!-- 背景网格动画 -->
                                <view class="absolute inset-0 opacity-5">
                                    <view class="absolute inset-0" style="background-image: linear-gradient(var(--primary-color) 0.5px, transparent 0.5px),
                                                linear-gradient(90deg, var(--primary-color) 0.5px, transparent 0.5px);
                                                background-size: 16px 16px;
                                                animation: grid-move 20s linear infinite;">
                                    </view>
                                </view>

                                <!-- 光效背景 -->
                                <view class="absolute inset-0">
                                    <!-- 扫描线 -->
                                    <view class="absolute inset-0" style="background: linear-gradient(transparent 0%, rgba(var(--primary-color-rgb), 0.05) 50%, transparent 100%);
                                                animation: scan-line 3s ease-in-out infinite;">
                                    </view>
                                    <!-- 光晕效果 -->
                                    <view class="absolute inset-0" style="background: radial-gradient(circle at 50% 50%, rgba(var(--primary-color-rgb), 0.15) 0%, transparent 70%);
                                                animation: glow 4s ease-in-out infinite;">
                                    </view>
                                </view>

                                <!-- 内容区域 -->
                                <view class="absolute inset-0 flex flex-col items-center justify-center">
                                    <!-- 中央光效容器 -->
                                    <view
                                        class="relative w-full max-w-[80%] aspect-video flex flex-col items-center justify-center">
                                        <!-- 中心光环 -->
                                        <view class="absolute inset-0" style="background: radial-gradient(circle at center, rgba(var(--primary-color-rgb),0.15) 0%, transparent 70%);
                                                   animation: center-glow 4s infinite ease-in-out;">
                                        </view>

                                        <!-- 动态光线 -->
                                        <view class="absolute inset-0 overflow-hidden">
                                            <view class="absolute inset-0" style="background: linear-gradient(90deg, transparent, rgba(var(--primary-color-rgb),0.1), transparent);
                                                       transform: skewX(-45deg);
                                                       animation: light-sweep 3s infinite ease-in-out;">
                                            </view>
                                        </view>

                                        <!-- 文字内容区 -->
                                        <view class="relative z-10 text-center transform transition-all duration-500">


                                            <!-- 进度动画 -->
                                            <view class="flex items-center justify-center space-x-2">
                                                <view v-for="i in 3" :key="i"
                                                    class="w-[4rpx] h-[24rpx] rounded-full relative" :style="{
                                                        'background': 'var(--primary-color)',
                                                        'animation': 'progress-bar 1.2s ease-in-out infinite',
                                                        'animation-delay': (i - 1) * 0.2 + 's',
                                                        'box-shadow': '0 0 8px var(--primary-color)'
                                                    }">
                                                </view>
                                            </view>

                                            <!-- 处理进度提示 -->
                                            <view class="mt-4">
                                                <text class="text-[24rpx] text-[var(--primary-help-color)] opacity-80"
                                                    style="text-shadow: 0 0 10px rgba(var(--primary-color-rgb), 0.3);">
                                                    处理中，请稍候...
                                                </text>
                                            </view>
                                        </view>
                                    </view>
                                </view>
                            </view>

                            <!-- 底部信息栏 -->
                            <view
                                class="px-4 py-3 flex items-center justify-between border-t border-[rgba(var(--primary-color-rgb),0.1)]">
                                <view class="text-[24rpx] text-[var(--primary-color)] truncate flex-1 font-medium">
                                    {{ item.name || '视频生成中...' }}
                                </view>
                                <view @click="selectedVideoEvent(item)"
                                    class="ml-2 px-2 py-1 rounded-full bg-[rgba(var(--primary-color-rgb),0.1)]">
                                    <text class="text-[20rpx] text-[var(--primary-help-color)]">处理中</text>
                                </view>
                            </view>
                        </view>

                        <!-- 已完成视频项 - 改为封面图展示 -->
                        <view class="w-full" v-if="item.status == 2">
                            <view class="relative group">
                                <!-- 视频封面容器 -->
                                <view class="relative overflow-hidden rounded-lg" @click="openVideoPopup(item)">
                                    <!-- 视频封面图 -->
                                    <image :src="getVideoCover(item)"
                                        class="w-full h-[240rpx] rounded-lg shadow-lg transform transition-all duration-300 group-hover:scale-[1.02] object-cover"
                                        mode="aspectFill"></image>

                                    <!-- 渐变遮罩 -->
                                    <view
                                        class="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                                    </view>

                                    <!-- 播放状态指示器 -->
                                    <view
                                        class="absolute top-2 right-2 flex items-center space-x-1 bg-black/30 backdrop-blur-sm px-2 py-1 rounded-full">
                                        <view class="w-2 h-2 rounded-full bg-green-400 animate-pulse"></view>
                                        <text class="text-white text-[20rpx]"></text>
                                    </view>

                                    <!-- 播放按钮 -->
                                    <view class="absolute inset-0 flex items-center justify-center">
                                        <!-- 优化后的播放按钮容器 -->
                                        <view class="w-12 h-12 flex items-center justify-center rounded-full bg-black/60 backdrop-blur-md 
                                                     transform transition-all duration-300 opacity-70 group-hover:opacity-100 group-hover:scale-110
                                                     shadow-md hover:shadow-lg">
                                            <!-- 使用图标库替代边框绘制的三角形 -->
                                            <u-icon name="play-right" color="white" size="24"
                                                class="transform transition-transform duration-300 group-hover:scale-125"></u-icon>
                                        </view>
                                    </view>

                                </view>

                                <!-- 标题和操作区 -->
                                <view
                                    class="mt-2 px-3 py-2 flex justify-between items-center bg-[rgba(var(--primary-color-rgb),0.05)] rounded-lg backdrop-blur-sm">
                                    <view class="flex-1 mr-4">
                                        <text
                                            class="text-[26rpx] font-medium text-[var(--primary-color)] truncate block tk-sltext w-[140rpx]">{{
                                                item.name }}</text>
                                        <text class="text-[20rpx] text-[var(--primary-help-color)] mt-1 block">{{
                                            formatDate(item.create_time) }}</text>
                                    </view>
                                    <view @click="selectedVideoEvent(item)"
                                        class="ml-2 py-1 rounded-full relative overflow-hidden w-[20%]"
                                        style="background: linear-gradient(90deg, rgba(var(--primary-color), 0.8), rgba(var(--primary-help-color-rgb), 0.8));">
                                        <text class="text-[28rpx] text-[var(--primary-color-light)]">操作</text>
                                    </view>
                                </view>
                            </view>
                        </view>

                        <!-- 失败的视频项 -->
                        <view class="w-full" v-if="item.status == 3">
                            <view
                                class="w-full h-[240rpx] relative overflow-hidden rounded-lg bg-gradient-to-br from-[rgba(var(--primary-color-rgb),0.05)] to-[rgba(var(--primary-color-rgb),0.1)]">

                                <!-- 内容区域 -->
                                <view class="absolute inset-0 flex flex-col items-center justify-center p-4">
                                    <!-- 错误图标和光晕 -->
                                    <view class="mb-4 relative">

                                        <!-- 图标 -->
                                        <u-icon name="info-circle" color="var(--primary-color)" size="40"
                                            class="relative z-10">
                                        </u-icon>
                                    </view>

                                    <!-- 错误信息 -->
                                    <view class="text-center relative z-10">
                                        <view class="mb-2">
                                            <text class="text-[28rpx] font-medium text-red">
                                                合成失败
                                            </text>
                                        </view>
                                        <view
                                            class="text-[24rpx] text-[var(--primary-help-color)] leading-4 opacity-80 max-w-[80%] mx-auto">
                                            {{ item.msg || '视频处理出现错误' }}
                                        </view>
                                    </view>
                                </view>
                            </view>

                            <!-- 底部信息栏 -->
                            <view
                                class="px-4 py-3 flex items-center justify-between border-t border-[rgba(var(--primary-color-rgb),0.1)]">
                                <view class="text-[24rpx] text-[var(--primary-color)] truncate flex-1 font-medium">
                                    {{ item.name }}
                                </view>
                                <view @click="selectedVideoEvent(item)"
                                    class="ml-2 px-3 py-1 rounded-full relative overflow-hidden"
                                    style="background: linear-gradient(90deg, rgba(var(--primary-color), 0.8), rgba(var(--primary-help-color-rgb), 0.8));">
                                    <text class="text-[28rpx] text-[var(--primary-color-light)]">操作</text>
                                </view>
                            </view>
                        </view>
                    </view>
                </view>
            </view>
            <mescroll-empty :option="{
                icon: img('addon/ai_humans/images/empty.png'),
                tip: '暂无数据',

            }" v-if="!list.length && loading">
            </mescroll-empty>
        </mescroll-body>

        <!-- 操作菜单弹窗 -->
        <u-popup :show="showPopup" safeAreaInsetBottom="true" @close="showPopup = false" bgColor="transparent"
            customStyle="border-radius: 16rpx;background: var(--page-bg-color);border: 1px solid var(--primary-color);">

            <view class="p-4 text-center" v-if="selectedVideo.status == 2"
                style="border-bottom: 1px solid var(--primary-color);" @click.stop="openVideoPopup(selectedVideo)">
                <!-- 修改为打开视频弹窗 -->
                <view class="text-sm font-medium text-[var(--primary-color-light)]">观看</view>
            </view>
            <view class="p-4 text-center" v-if="selectedVideo.status == 2"
                style="border-bottom: 1px solid var(--primary-color);"
                @click.stop="downloadFileEvent(img(selectedVideo.video_url))">
                <view class="text-sm font-medium text-[var(--primary-color-light)]">下载</view>
            </view>
            <view class="p-4 text-center" v-if="selectedVideo.status == 2"
                style="border-bottom: 1px solid var(--primary-color);"
                @click.stop="copy(img(selectedVideo.video_url), '')">
                <view class="text-sm font-medium text-[var(--primary-color-light)]">复制链接</view>
            </view>
            <view class="p-4 text-center" @click.stop="deleteEvent(selectedVideo.id)">
                <view class="text-sm font-medium text-[var(--primary-color-dark)]">删除</view>
            </view>
        </u-popup>

        <!-- 视频播放弹窗 -->
        <u-popup :show="showVideoPopup" mode="center" @close="closeVideoPopup" bgColor="transparent"
            customStyle="width: 90%; max-width: 650rpx; border-radius: 16rpx; overflow: hidden; background: rgba(0, 0, 0, 0.9);">
            <view class="relative">
                <video v-if="currentVideoUrl" :src="img(currentVideoUrl)" controls autoplay class="w-full aspect-video"
                    style="width: 100%;" @ended="closeVideoPopup"></video>
                <view class="absolute top-2 right-2 z-10 p-2 rounded-full bg-black/50" @click="closeVideoPopup">
                    <u-icon name="close" color="#ffffff" size="20"></u-icon>
                </view>
            </view>
        </u-popup>

        <!-- #ifdef MP-WEIXIN -->
        <!-- 小程序隐私协议 -->
        <wx-privacy-popup ref="wxPrivacyPopupRef"></wx-privacy-popup>
        <!-- #endif -->
    </view>
</template>

<script setup lang="ts">
import { ref, reactive, onUnmounted, onMounted, computed } from "vue";
import { downloadFileEvent } from "@/addon/ai_humans/utils/ts/common"
import { confirm } from "@/addon/ai_humans/utils/ts/alert"
import { img, copy, redirect } from "@/utils/common";
import { getCreateVideoList, deleteCreateVideo, getVideoStatus } from "@/addon/ai_humans/api/video";
import MescrollBody from "@/components/mescroll/mescroll-body/mescroll-body.vue";
import MescrollEmpty from "@/components/mescroll/mescroll-empty/mescroll-empty.vue";
import useMescroll from "@/components/mescroll/hooks/useMescroll.js";
import { onLoad, onPageScroll, onReachBottom } from "@dcloudio/uni-app";

interface VideoItem {
    id: number;
    name: string;
    video_url: string;
    status: number | string; // 修改为可接受数字或字符串类型
    create_time?: string;
    error_msg?: string;
    cover_url?: string;
}

interface VideoStatus {
    status: string | number;
    name: string;
}

// 调试开关
const showDebug = ref<boolean>(false);
const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
const showPopup = ref<boolean>(false);
const list = ref<VideoItem[]>([]);
const loading = ref<boolean>(false);
const videoStatusList = ref<VideoStatus[]>([]);
const status = ref('');
const selectedVideo = ref<VideoItem>({} as VideoItem);

// 视频弹窗相关变量
const showVideoPopup = ref<boolean>(false);
const currentVideoUrl = ref<string>('');

// 添加定时刷新相关变量
const refreshTimer = ref<number | null>(null);

// 视频封面获取函数
const getVideoCover = (item: VideoItem): string => {
    // 如果有封面图则使用封面图
    if (item.cover_url) {
        return img(item.cover_url);
    }
    // 否则可以使用默认封面或者视频截图
    return img('addon/ai_humans/images/video-cover.png');
};

// 格式化日期显示
const formatDate = (dateString?: string): string => {
    if (!dateString) {
        return new Date().toLocaleDateString();
    }
    return new Date(dateString).toLocaleDateString();
};

// 打开视频弹窗播放
const openVideoPopup = (item: VideoItem) => {
    if (item && item.video_url) {
        currentVideoUrl.value = item.video_url;
        showVideoPopup.value = true;
    } else {
        uni.showToast({
            title: '视频地址无效',
            icon: 'none'
        });
    }
};

// 关闭视频弹窗
const closeVideoPopup = () => {
    showVideoPopup.value = false;
    currentVideoUrl.value = '';
};

// 组件卸载时清理
onUnmounted(() => {
    stopAutoRefresh();
});

// 获取视频状态列表
getVideoStatus().then((res: any) => {
    videoStatusList.value.push({
        status: '',
        name: '全部'
    });
    if (res && res.data) {
        Object.entries(res.data).forEach(([key, value]) => {
            videoStatusList.value.push(value as VideoStatus);
        });
    }
});

const selectStatusFn = (item: VideoStatus) => {
    status.value = item.status as string;
    reload();
};

const reload = () => {
    const mescroll = getMescroll();
    if (mescroll) {
        mescroll.resetUpScroll();
    }
};

const deleteEvent = (id: number) => {
    showPopup.value = false;
    confirm('确认删除此视频吗？', del, id);
};

const del = async (id: number) => {
    try {
        await deleteCreateVideo(id);
        uni.showToast({
            title: '删除成功',
            icon: 'success'
        });
        reload();
    } catch (error) {
        uni.showToast({
            title: '删除失败',
            icon: 'none'
        });
    }
};

const selectedVideoEvent = (item: VideoItem) => {
    selectedVideo.value = item;
    showPopup.value = true;
};

const getCreateVideoListFn = (mescroll: any) => {
    loading.value = false;
    let data = {
        page: mescroll.num,
        limit: mescroll.size,
        status: status.value
    };

    getCreateVideoList(data)
        .then((res: any) => {
            console.log("API返回数据:", res); // 调试用
            let newArr: VideoItem[] = [];

            if (res && res.data && res.data.data) {
                newArr = res.data.data;
                // 确保所有项都处理为正确的类型
                newArr = newArr.map(item => {
                    // 确保status是数字类型
                    if (typeof item.status === 'string' && !isNaN(Number(item.status))) {
                        item.status = Number(item.status);
                    }
                    return item;
                });

                //设置列表数据
                if (mescroll.num == 1) {
                    list.value = []; //如果是第一页需手动制空列表
                }
                list.value = [...list.value, ...newArr];
                mescroll.endSuccess(newArr.length);
            } else {
                mescroll.endErr();
            }
            loading.value = true;
        })
        .catch((error) => {
            console.error("加载失败:", error); // 调试用
            loading.value = true;
            mescroll.endErr(); // 请求失败, 结束加载
        });
};

// 获取列表数据的函数
const getListData = async () => {
    try {
        // 重新加载第一页数据
        const mescroll = getMescroll();
        if (mescroll) {
            mescroll.resetUpScroll(false);
        }
    } catch (error) {
        console.error("获取数据失败:", error); // 调试用
        uni.showToast({
            title: '获取列表数据失败',
            icon: 'none'
        });
    }
};

// 设置定时刷新
const startAutoRefresh = () => {
    // 先清除可能存在的定时器
    stopAutoRefresh();

    // 设置新的定时器，每8秒刷新一次
    refreshTimer.value = setInterval(() => {
        getListData();
    }, 8000) as unknown as number;
};

// 停止定时刷新
const stopAutoRefresh = () => {
    if (refreshTimer.value !== null) {
        clearInterval(refreshTimer.value);
        refreshTimer.value = null;
    }
};

// 组件挂载时启动定时刷新
onMounted(() => {
    // 开启调试模式（如需）
    // showDebug.value = true;

    // 先加载一次数据
    getListData();
    // 启动定时刷新
    startAutoRefresh();
});
</script>

<style lang="scss">
@import "@/addon/ai_humans/utils/styles/common.scss";

@keyframes pulse {

    0%,
    100% {
        transform: scale(1);
        opacity: 0.2;
    }

    50% {
        transform: scale(1.2);
        opacity: 0.4;
    }
}

@keyframes dot1 {

    0%,
    100% {
        opacity: 0.3;
        transform: scale(0.8);
    }

    30% {
        opacity: 1;
        transform: scale(1.2);
    }
}

@keyframes dot2 {

    0%,
    100% {
        opacity: 0.3;
        transform: scale(0.8);
    }

    30% {
        opacity: 0.3;
        transform: scale(0.8);
    }

    60% {
        opacity: 1;
        transform: scale(1.2);
    }
}

@keyframes dot3 {

    0%,
    100% {
        opacity: 0.3;
        transform: scale(0.8);
    }

    60% {
        opacity: 0.3;
        transform: scale(0.8);
    }

    90% {
        opacity: 1;
        transform: scale(1.2);
    }
}

@keyframes shine {
    0% {
        transform: translateX(-100%);
    }

    100% {
        transform: translateX(100%);
    }
}

@keyframes pulse-bg {

    0%,
    100% {
        transform: scale(1);
        opacity: 0.2;
    }

    50% {
        transform: scale(1.5);
        opacity: 0.4;
    }
}

@keyframes spin {
    from {
        transform: rotate(0deg);
    }

    to {
        transform: rotate(360deg);
    }
}

@keyframes pulse-ring {
    0% {
        transform: scale(0.8);
        opacity: 0.3;
    }

    50% {
        transform: scale(1.1);
        opacity: 0.6;
    }

    100% {
        transform: scale(0.8);
        opacity: 0.3;
    }
}

@keyframes dot-scale {

    0%,
    100% {
        transform: scale(1);
        opacity: 0.5;
    }

    50% {
        transform: scale(1.5);
        opacity: 1;
    }
}

@keyframes grid-move {
    0% {
        transform: translateY(0) scale(1);
        opacity: 0.5;
    }

    50% {
        transform: translateY(-8px) scale(1.02);
        opacity: 0.3;
    }

    100% {
        transform: translateY(-16px) scale(1);
        opacity: 0.5;
    }
}

@keyframes scan-line {

    0%,
    100% {
        transform: translateY(-100%);
    }

    50% {
        transform: translateY(100%);
    }
}

@keyframes glow {

    0%,
    100% {
        opacity: 0.3;
        transform: scale(1);
    }

    50% {
        opacity: 0.5;
        transform: scale(1.2);
    }
}

@keyframes rotate-out {
    from {
        transform: rotate(0deg);
    }

    to {
        transform: rotate(360deg);
    }
}

@keyframes rotate-in {
    from {
        transform: rotate(0deg);
    }

    to {
        transform: rotate(-360deg);
    }
}

@keyframes progress-bar {

    0%,
    100% {
        height: 24rpx;
        opacity: 0.3;
    }

    50% {
        height: 32rpx;
        opacity: 1;
    }
}

@keyframes border-light-left {
    0% {
        transform: translateX(-200%);
        opacity: 0;
    }

    50% {
        opacity: 1;
    }

    100% {
        transform: translateX(200%);
        opacity: 0;
    }
}

@keyframes border-light-right {
    0% {
        transform: translateX(200%);
        opacity: 0;
    }

    50% {
        opacity: 1;
    }

    100% {
        transform: translateX(-200%);
        opacity: 0;
    }
}

@keyframes border-light-top {
    0% {
        transform: translateY(-200%);
        opacity: 0;
    }

    50% {
        opacity: 1;
    }

    100% {
        transform: translateY(200%);
        opacity: 0;
    }
}

@keyframes border-light-bottom {
    0% {
        transform: translateY(200%);
        opacity: 0;
    }

    50% {
        opacity: 1;
    }

    100% {
        transform: translateY(-200%);
        opacity: 0;
    }
}

@keyframes corner-pulse {

    0%,
    100% {
        opacity: 0.2;
        transform: scale(0.8);
    }

    50% {
        opacity: 0.6;
        transform: scale(1.2);
    }
}

@keyframes center-glow {

    0%,
    100% {
        opacity: 0.3;
        transform: scale(0.95);
    }

    50% {
        opacity: 0.6;
        transform: scale(1.05);
    }
}

@keyframes light-sweep {

    0%,
    100% {
        transform: translateX(-200%) skewX(-45deg);
        opacity: 0;
    }

    50% {
        transform: translateX(200%) skewX(-45deg);
        opacity: 0.5;
    }
}

.gradient-text {
    background: linear-gradient(90deg, var(--primary-color) 0%, var(--primary-help-color) 100%);
    -webkit-background-clip: text;
    color: transparent;
    animation: text-shine 2s linear infinite;
}

.grid-background {
    background-image:
        linear-gradient(var(--primary-color) 1px, transparent 1px),
        linear-gradient(90deg, var(--primary-color) 1px, transparent 1px);
    background-size: 20px 20px;
    opacity: 0.1;
    animation: grid-move 20s linear infinite;
}

.scanning-line {
    background: linear-gradient(to bottom,
            transparent 0%,
            rgba(var(--primary-color-rgb), 0.1) 50%,
            transparent 100%);
    animation: scanning 2s ease-in-out infinite;
}

.marquee-border-horizontal {
    background: linear-gradient(90deg,
            transparent 0%,
            var(--primary-color) 50%,
            transparent 100%);
    animation: marquee-horizontal 2s linear infinite;
}

.marquee-border-vertical {
    background: linear-gradient(180deg,
            transparent 0%,
            var(--primary-color) 50%,
            transparent 100%);
    animation: marquee-vertical 2s linear infinite;
}

.marquee-border-horizontal-reverse {
    background: linear-gradient(90deg,
            transparent 0%,
            var(--primary-color) 50%,
            transparent 100%);
    animation: marquee-horizontal 2s linear infinite reverse;
}

.marquee-border-vertical-reverse {
    background: linear-gradient(180deg,
            transparent 0%,
            var(--primary-color) 50%,
            transparent 100%);
    animation: marquee-vertical 2s linear infinite reverse;
}

.glow-pulse {
    background: radial-gradient(circle,
            rgba(var(--primary-color-rgb), 0.3) 0%,
            transparent 70%);
    animation: glow-pulse 2s ease-in-out infinite;
}

.inner-glow-pulse {
    background: radial-gradient(circle,
            rgba(var(--primary-color-rgb), 0.4) 0%,
            transparent 70%);
    animation: glow-pulse 2s ease-in-out infinite reverse;
}

.icon-pulse {
    animation: icon-pulse 1.5s ease-in-out infinite;
}

.button-glow {
    background: linear-gradient(90deg,
            var(--primary-color) 0%,
            var(--primary-help-color) 100%);
    padding: 8rpx 24rpx;
    border-radius: 30rpx;
    position: relative;
    overflow: hidden;

    &::before {
        content: '';
        position: absolute;
        top: -50%;
        left: -50%;
        width: 200%;
        height: 200%;
        background: radial-gradient(circle,
                rgba(255, 255, 255, 0.2) 0%,
                transparent 60%);
        animation: button-glow 3s ease-in-out infinite;
    }
}

.status-badge {
    background: linear-gradient(90deg,
            rgba(var(--primary-color-rgb), 0.1),
            rgba(var(--primary-help-color-rgb), 0.1));
    padding: 4rpx 16rpx;
    border-radius: 30rpx;
    position: relative;
    overflow: hidden;

    &::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg,
                transparent,
                rgba(255, 255, 255, 0.2),
                transparent);
        animation: badge-shine 2s linear infinite;
    }
}

@keyframes marquee-horizontal {
    0% {
        transform: translateX(-100%);
    }

    100% {
        transform: translateX(100%);
    }
}

@keyframes marquee-vertical {
    0% {
        transform: translateY(-100%);
    }

    100% {
        transform: translateY(100%);
    }
}

@keyframes glow-pulse {

    0%,
    100% {
        transform: scale(0.95);
        opacity: 0.3;
    }

    50% {
        transform: scale(1.05);
        opacity: 0.6;
    }
}

@keyframes icon-pulse {

    0%,
    100% {
        transform: scale(1);
    }

    50% {
        transform: scale(1.1);
    }
}

@keyframes scanning {

    0%,
    100% {
        transform: translateY(-100%);
    }

    50% {
        transform: translateY(100%);
    }
}

@keyframes text-shine {
    0% {
        background-position: -200% center;
    }

    100% {
        background-position: 200% center;
    }
}

@keyframes button-glow {

    0%,
    100% {
        transform: rotate(0deg);
        opacity: 0.5;
    }

    50% {
        transform: rotate(180deg);
        opacity: 0.8;
    }
}

@keyframes badge-shine {
    0% {
        left: -100%;
    }

    100% {
        left: 100%;
    }
}

@keyframes border-move-right {
    0% {
        transform: translateX(-100%);
    }

    100% {
        transform: translateX(100%);
    }
}

@keyframes border-move-left {
    0% {
        transform: translateX(100%);
    }

    100% {
        transform: translateX(-100%);
    }
}

@keyframes border-move-down {
    0% {
        transform: translateY(-100%);
    }

    100% {
        transform: translateY(100%);
    }
}

@keyframes border-move-up {
    0% {
        transform: translateY(100%);
    }

    100% {
        transform: translateY(-100%);
    }
}

@keyframes corner-flash {

    0%,
    100% {
        opacity: 0.3;
    }

    50% {
        opacity: 1;
    }
}

@keyframes button-shine {
    0% {
        transform: translateX(-100%) skewX(-45deg);
    }

    100% {
        transform: translateX(200%) skewX(-45deg);
    }
}

/* 固定状态栏样式 */
.fixed {
    transition: all 0.3s ease;
}

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
