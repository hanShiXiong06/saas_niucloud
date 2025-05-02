<template>
    <view class="bg-[var(--page-bg-color)] min-h-screen p-2" :style="themeColor()">
        <mescroll-body ref="mescrollRef" top="64rpx" @init="mescrollInit" @down="downCallback"
            @up="getCloneVoiceListFn">
            <view v-if="list.length > 0" class="">
                <view v-for="(item, index) in list" :key="index">
                    <view class="flex justify-between items-center p-3 rounded-[8rpx] shadow-sm mb-2"
                        :style="{ background: 'linear-gradient(to right, var(--primary-color-light2), var(--primary-color-light2))' }">
                        <view class="flex items-center">
                            <view class="flex items-center">
                                <view class="audio-player relative" @click="togglePlay(item, index)">
                                    <view v-if="currentPlayingIndex !== index || !isPlaying">
                                        <u-icon name="play-circle-fill" color="var(--primary-color)" size="36"></u-icon>
                                    </view>
                                    <view v-else>
                                        <u-icon name="pause-circle-fill" color="var(--primary-color)"
                                            size="36"></u-icon>
                                    </view>
                                    <view v-if="currentPlayingIndex === index && isPlaying"
                                        class="audio-wave flex items-center space-x-1 absolute left-10 top-1/2 transform -translate-y-1/2">
                                        <view v-for="i in 4" :key="i"
                                            class="h-2 w-1 bg-primary-500 rounded-full animate-pulse"
                                            :style="{ animationDelay: `${i * 0.15}s` }"></view>
                                    </view>
                                </view>
                            </view>
                            <view class="flex flex-col ml-2">
                                <view class="text-sm font-medium truncate w-4/5">{{ item.name }}</view>
                                <view class="flex items-center">
                                    <view class="text-[24rpx] mr-2 truncate">{{ item.create_time }}</view>
                                    <view class="status-badge" :class="getStatusClass(item.status)">
                                        {{ item.status_name }}
                                    </view>
                                </view>
                            </view>
                        </view>

                        <view class="flex items-center" @click="selectedVoiceEvent(item)">
                            <u-icon name="more-circle" color="var(--primary-color)" size="24"></u-icon>
                        </view>

                    </view>
                </view>
            </view>
            <mescroll-empty :option="{
                icon: img('addon/ai_humans/images/empty.png'),
                tip: '暂无数据'
            }" v-if="!list.length && loading">
            </mescroll-empty>

            <!-- 加载中状态 -->
            <view v-if="isLoadingData" class="loading-container flex justify-center items-center py-4">
                <view class="loading-spinner mr-2"></view>
                <text class="text-sm text-[var(--primary-color)]">加载中...</text>
            </view>
        </mescroll-body>

        <u-popup :show="showPopup" safeAreaInsetBottom="true" @close="showPopup = false" bgColor="transparent"
            customStyle="border-radius: 16rpx;background: var(--page-bg-color);border: 1px solid var(--primary-color);">
            <view v-if="selectedVoice.status == 2" class="p-4 text-center"
                style="border-bottom: 1px solid var(--primary-color);"
                @click="redirect({ url: '/addon/ai_humans/pages/video/create' })">
                <view class="text-sm font-medium text-[var(--primary-color)]">使用声音</view>
            </view>
            <view class="p-4 text-center" style="border-bottom: 1px solid var(--primary-color);"
                @click="downloadFileEvent(img(selectedVoice.voice_url))">
                <view class="text-sm font-medium text-[var(--primary-color-light)]">下载</view>
            </view>
            <view class="p-4 text-center" style="border-bottom: 1px solid var(--primary-color);"
                @click="copy(img(selectedVoice.voice_url), '')">
                <view class="text-sm font-medium text-[var(--primary-color-light)]">复制链接</view>
            </view>
            <view class="p-4 text-center" @click="deleteEvent(selectedVoice.id)">
                <view class="text-sm font-medium text-[var(--primary-color-dark)]">删除</view>
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
import { getCloneVoiceList, deleteCloneVoice } from "@/addon/ai_humans/api/voice";
import MescrollBody from "@/components/mescroll/mescroll-body/mescroll-body.vue";
import MescrollEmpty from "@/components/mescroll/mescroll-empty/mescroll-empty.vue";
import useMescroll from "@/components/mescroll/hooks/useMescroll.js";
import { onLoad, onPageScroll, onReachBottom } from "@dcloudio/uni-app";

// 定义类型接口
interface VoiceItem {
    id: number | string;
    name: string;
    create_time: string;
    voice_url: string;
    status: number; // 0-处理中, 1-成功, 2-失败
    [key: string]: any;
}

interface MescrollInstance {
    num: number;
    size: number;
    resetUpScroll: () => void;
    endSuccess: (size: number) => void;
    endErr: () => void;
}

// 计算属性
const themeStyle = computed(() => {
    return {
        '--theme-color': 'var(--primary-color)',
    };
});

const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
const showPopup = ref<boolean>(false);
let list = ref<Array<VoiceItem>>([]);
let loading = ref<boolean>(false);
let isLoadingData = ref<boolean>(false);
let audioPlayer = ref<any>(null);
let isPlaying = ref<boolean>(false);
let currentPlayingIndex = ref<number>(-1);
const selectedVoice = ref<VoiceItem>({} as VoiceItem);

// 状态处理函数
const getStatusText = (status: number): string => {
    switch (status) {
        case 0: return '处理中';
        case 1: return '已完成';
        case 2: return '失败';
        default: return '未知状态';
    }
};

const getStatusClass = (status: number): string => {
    switch (status) {
        case 1: return 'status-processing';
        case 2: return 'status-success';
        case 3: return 'status-error';
        default: return 'status-default';
    }
};

const reload = () => {
    getMescroll().resetUpScroll();
};

const deleteEvent = (id: number | string) => {
    showPopup.value = false;
    confirm('确认删除本条音色吗？', del, id);
};

const del = async (id: number | string) => {
    await deleteCloneVoice(id);
    uni.$u.toast('删除成功');
    reload();
};

const selectedVoiceEvent = (item: VoiceItem) => {
    selectedVoice.value = item;
    showPopup.value = true;
};

// 音频播放控制
const togglePlay = (item: VoiceItem, index: number) => {
    // 如果没有音频URL，直接返回
    if (!item.voice_url) {
        uni.showToast({
            title: '音频链接无效',
            icon: 'none'
        });
        return;
    }

    // 如果当前没有播放任何音频
    if (currentPlayingIndex.value === -1) {
        playAudio(img(item.voice_url), index);
        return;
    }

    // 如果点击的是当前正在播放的音频
    if (currentPlayingIndex.value === index) {
        if (isPlaying.value) {
            pauseAudio();
        } else {
            resumeAudio();
        }
        return;
    }

    // 如果点击的是其他音频，先停止当前播放的
    stopAudio();
    playAudio(img(item.voice_url), index);
};

const playAudio = (url: string, index: number) => {
    // 创建新的音频实例
    audioPlayer.value = uni.createInnerAudioContext();
    audioPlayer.value.src = url;
    audioPlayer.value.autoplay = true;

    // 监听播放状态
    audioPlayer.value.onPlay(() => {
        isPlaying.value = true;
        currentPlayingIndex.value = index;
    });

    audioPlayer.value.onPause(() => {
        isPlaying.value = false;
    });

    audioPlayer.value.onStop(() => {
        isPlaying.value = false;
    });

    audioPlayer.value.onEnded(() => {
        isPlaying.value = false;
        currentPlayingIndex.value = -1;
    });

    audioPlayer.value.onError((err: any) => {
        console.error('音频播放错误:', err);
        uni.showToast({
            title: '音频播放失败',
            icon: 'none'
        });
        isPlaying.value = false;
        currentPlayingIndex.value = -1;
    });
};

const pauseAudio = () => {
    if (audioPlayer.value) {
        audioPlayer.value.pause();
        isPlaying.value = false;
    }
};

const resumeAudio = () => {
    if (audioPlayer.value) {
        audioPlayer.value.play();
        isPlaying.value = true;
    }
};

const stopAudio = () => {
    if (audioPlayer.value) {
        audioPlayer.value.stop();
        isPlaying.value = false;
        currentPlayingIndex.value = -1;
    }
};

// 页面卸载时释放音频资源
onUnmounted(() => {
    if (audioPlayer.value) {
        audioPlayer.value.destroy();
    }
});

const getCloneVoiceListFn = (mescroll: MescrollInstance) => {
    loading.value = false;
    isLoadingData.value = true;
    let data = {
        page: mescroll.num,
        limit: mescroll.size,
    };
    getCloneVoiceList(data)
        .then((res: any) => {
            let newArr = res.data.data as Array<VoiceItem>;
            //设置列表数据
            if (mescroll.num == 1) {
                list.value = []; //如果是第一页需手动制空列表
            }
            list.value = list.value.concat(newArr);
            mescroll.endSuccess(newArr.length);
            loading.value = true;
            isLoadingData.value = false;
        })
        .catch(() => {
            loading.value = true;
            isLoadingData.value = false;
            mescroll.endErr(); // 请求失败, 结束加载
        });
};
</script>

<style lang="scss">
@import "@/addon/ai_humans/utils/styles/common.scss";

.audio-wave {
    .animate-pulse {
        animation: pulse 1s cubic-bezier(0.4, 0, 0.6, 1) infinite;

        @for $i from 1 through 4 {
            &:nth-child(#{$i}) {
                animation-delay: #{$i * 0.15}s;
                height: #{10 + $i * 2}px;
            }
        }
    }
}

@keyframes pulse {

    0%,
    100% {
        transform: scaleY(1);
    }

    50% {
        transform: scaleY(1.5);
    }
}

// 状态标签样式
.status-badge {
    font-size: 20rpx;
    padding: 2rpx 10rpx;
    border-radius: 10rpx;
    display: inline-block;
}

.status-processing {
    background-color: rgba(var(--primary-color-rgb), 0.1);
    color: var(--primary-color);
    border: 1px solid var(--primary-color);
}

.status-success {
    background-color: rgba(39, 174, 96, 0.1);
    color: #27ae60;
    border: 1px solid #27ae60;
}

.status-error {
    background-color: rgba(231, 76, 60, 0.1);
    color: #e74c3c;
    border: 1px solid #e74c3c;
}

.status-default {
    background-color: rgba(149, 165, 166, 0.1);
    color: #95a5a6;
    border: 1px solid #95a5a6;
}

// 加载动画
.loading-container {
    height: 80rpx;
}

.loading-spinner {
    width: 30rpx;
    height: 30rpx;
    border: 3rpx solid var(--primary-color);
    border-top-color: transparent;
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
}

@keyframes spin {
    0% {
        transform: rotate(0deg);
    }

    100% {
        transform: rotate(360deg);
    }
}
</style>
