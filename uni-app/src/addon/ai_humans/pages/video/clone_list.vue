<template>
    <view class="bg-[var(--page-bg-color)] min-h-screen p-2" :style="themeColor()">
        <mescroll-body ref="mescrollRef" top="64rpx" @init="mescrollInit" @down="downCallback"
            @up="getCloneVideoListFn">
            <view v-if="list.length > 0" class="flex flex-wrap -mx-1">
                <view v-for="(item, index) in list" :key="index" class="w-1/2 px-1 mb-2 box-border">
                    <view class="p-2 rounded-[8rpx] shadow-sm"
                        :style="{ background: 'linear-gradient(to right, var(--primary-color-light2), var(--primary-color-light2))' }">
                        <!-- 视频封面区域 -->
                        <view class="w-full relative" @click="playVideoInPopup(item)">
                            <!-- 视频封面区域 - 使用内置样式，不依赖外部图片 -->
                            <view class="w-full aspect-video rounded-lg shadow-lg flex items-center justify-center"
                                :style="{
                                    background: 'linear-gradient(135deg, var(--primary-color-light) 0%, var(--primary-color-light2) 100%)',
                                    position: 'relative',
                                    overflow: 'hidden'
                                }">
                                <!-- 视频图标 -->
                                <view class="absolute inset-0 flex flex-col items-center justify-center">
                                    <u-icon name="" color="#FFFFFF" size="50"></u-icon>
                                    <text class="text-[var(--primary-color-light)] text-[24rpx] mt-2 font-bold">{{ item.name }}</text>
                                </view>

                                <!-- 播放按钮 -->
                                <view class="absolute inset-0 flex items-center justify-center">
                                    <view class="bg-black bg-opacity-30 rounded-full p-3 shadow-xl">
                                        <u-icon name="play-right-fill" color="#FFFFFF" size="40"></u-icon>
                                    </view>
                                </view>
                            </view>

                            <!-- 状态标签 -->
                            <view v-if="item.status !== undefined"
                                class="absolute top-2 right-2 px-2 py-1 rounded text-[20rpx] text-white"
                                :class="getStatusClass(item.status)">
                                {{ item.status_name }}
                            </view>
                        </view>
                        <view class="flex justify-between items-center mt-2">
                            <view class="text-[24rpx] font-bold truncate w-4/5">{{ item.name }}</view>
                            <view class="text-[24rpx] text-[var(--primary-color-light))] font-medium"
                                @click="selectedVideoEvent(item)">
                                操作
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

        <!-- 操作弹窗 -->
        <u-popup :show="showPopup" safeAreaInsetBottom="true" @close="showPopup = false" bgColor="transparent"
            customStyle="border-radius: 16rpx;background: var(--page-bg-color);border: 1px solid var(--primary-color);">
            <view v-if="selectedVideo.status == 2" class="p-4 text-center"
                style="border-bottom: 1px solid var(--primary-color);"
                @click.stop="redirect({ url: '/addon/ai_humans/pages/video/create' })">
                <view class="text-sm font-medium text-[var(--primary-color)]">使用形象</view>
            </view>
            <view class="p-4 text-center" style="border-bottom: 1px solid var(--primary-color);"
                @click="downloadFileEvent(img(selectedVideo.video_url))">
                <view class="text-sm font-medium text-[var(--primary-color-light)]">下载</view>
            </view>
            <view class="p-4 text-center" style="border-bottom: 1px solid var(--primary-color);"
                @click="copy(img(selectedVideo.video_url),'')">
                <view class="text-sm font-medium text-[var(--primary-color-light)]">复制链接</view>
            </view>
            <view class="p-4 text-center" @click.stop="deleteEvent(selectedVideo.id)">
                <view class="text-sm font-medium text-[var(--primary-color-dark)]">删除</view>
            </view>
        </u-popup>

        <!-- 视频播放弹窗 -->
        <u-popup :show="showVideoPopup" mode="center" @close="closeVideoPopup" bgColor="transparent"
            customStyle="border-radius: 16rpx; background: var(--page-bg-color); padding: 20rpx; width: 90%; max-width: 650rpx;">
            <view class="relative">
                <view class="absolute top-2 right-2 z-10" @click="closeVideoPopup">
                    <view class="bg-black bg-opacity-50 rounded-full p-1">
                        <u-icon name="close" color="#FFFFFF" size="24"></u-icon>
                    </view>
                </view>
                <video v-if="showVideoPopup" :id="currentVideoId" :src="img(currentVideoSrc)" controls autoplay
                    class="w-full rounded-lg" style="max-height: 80vh;"></video>
            </view>
        </u-popup>
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
import { getCloneVideoList, deleteCloneVideo } from "@/addon/ai_humans/api/video";
import MescrollBody from "@/components/mescroll/mescroll-body/mescroll-body.vue";
import MescrollEmpty from "@/components/mescroll/mescroll-empty/mescroll-empty.vue";
import useMescroll from "@/components/mescroll/hooks/useMescroll.js";
import { onLoad, onPageScroll, onReachBottom } from "@dcloudio/uni-app";

// 定义类型
interface VideoItem {
    id: number | string;
    name: string;
    video_url: string;
    status?: number;
    cover_url?: string;
    [key: string]: any;
}

interface MescrollInstance {
    num: number;
    size: number;
    endSuccess: (length: number) => void;
    endErr: () => void;
}

const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
const showPopup = ref<boolean>(false);
const list = ref<VideoItem[]>([]);
const loading = ref<boolean>(false);
const selectedVideo = ref<VideoItem>({} as VideoItem);

// 视频播放弹窗相关状态
const showVideoPopup = ref<boolean>(false);
const currentVideoId = ref<string>('');
const currentVideoSrc = ref<string>('');

// 打开视频播放弹窗
const playVideoInPopup = (item: VideoItem) => {
    currentVideoId.value = `popup_video_${item.id}`;
    currentVideoSrc.value = item.video_url;
    showVideoPopup.value = true;
};

// 关闭视频播放弹窗
const closeVideoPopup = () => {
    if (currentVideoId.value) {
        const videoContext = uni.createVideoContext(currentVideoId.value);
        videoContext?.pause();
    }
    showVideoPopup.value = false;
};

// 获取状态文本
const getStatusText = (status: number | undefined) => {
    if (status === undefined) return '';

    switch (status) {
        case 0: return '处理中';
        case 1: return '失败';
        case 2: return '成功';
        default: return '未知';
    }
};

// 获取状态样式类
const getStatusClass = (status: number | undefined) => {
    if (status === undefined) return '';

    switch (status) {
        case 0: return 'var(--primary-color-light2)';
        case 1: return 'var(--primary-color-light2)';
        case 2: return 'var(--primary-color-light)';
        default: return 'bg-red-500';
    }
};

const reload = () => {
    getMescroll().resetUpScroll();
}

const deleteEvent = (id: number | string) => {
    showPopup.value = false;
    confirm('确认删除此形象吗？', del, id);
}

const del = async (id: number | string) => {
    await deleteCloneVideo(id);
    uni.showToast({
        title: '删除成功',
        icon: 'none'
    });
    reload();
}

const selectedVideoEvent = (item: VideoItem) => {
    selectedVideo.value = item;
    showPopup.value = true;
}

const getCloneVideoListFn = (mescroll: MescrollInstance) => {
    loading.value = false;
    const data = {
        page: mescroll.num,
        limit: mescroll.size,
    };

    getCloneVideoList(data)
        .then((res: any) => {
            const newArr = res.data.data as VideoItem[];
            if (mescroll.num == 1) {
                list.value = [];
            }
            list.value = list.value.concat(newArr);
            mescroll.endSuccess(newArr.length);
            loading.value = true;
        })
        .catch(() => {
            loading.value = true;
            mescroll.endErr();
        });
};

// 修复themeColor未定义的问题
const staticThemeColor = computed(() => {
    return {}; // 如果需要静态主题样式，可以在这里添加
});

// 组件卸载时清理视频上下文
onUnmounted(() => {
    if (currentVideoId.value) {
        const videoContext = uni.createVideoContext(currentVideoId.value);
        videoContext?.pause();
    }
});
</script>

<style lang="scss">
@import "@/addon/ai_humans/utils/styles/common.scss";

.aspect-video {
    aspect-ratio: 16/9;
}

/* 确保图片容器有最小高度 */
.image-container {
    min-height: 120rpx;
}
</style>
