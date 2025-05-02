<template>
    <view class="bg-[var(--page-bg-color)] min-h-screen" :style="themeColor()">
        <view class="text-white p-2 rounded-lg w-full box-border">

            <view class="mb-4 w-full">
                <view class="mb-4 w-full">
                    <view class="flex items-center justify-between w-full">
                        <view class="flex items-center mb-2">
                            <view
                                class="w-2 h-[36rpx] bg-gradient-to-b from-[var(--primary-color)] to-[var(--primary-help-color)] rounded mr-[16rpx]"
                                :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color))' }">
                            </view>
                            <view class="text-[32rpx] font-bold text-[var(--primary-color)]">视频名称</view>
                        </view>
                        <view class="text-sm text-[var(--primary-color)]"
                            @click="redirect({ url: '/addon/ai_humans/pages/video/clone' })">新增形象</view>
                    </view>

                    <view class="mt-2">
                        <input class="p-2 bg-[var(--primary-color-light2)] rounded-md text-[var(--primary-color-light)]"
                            v-model="form.name" placeholder="请输入视频名称" />
                    </view>
                </view>
            </view>
            <view class="" v-if="!form.scene_task_id" @click="selectedCloneVideoEvent()">
                <view class="flex flex-col items-center p-4 border rounded-lg"
                    style="border-image: linear-gradient(45deg, var(--primary-color), var(--primary-help-color)) 1; box-shadow: 0 0 4px var(--primary-color-light);">
                    <view class="">
                        <u-icon name="plus" size="44" color="var(--primary-color)"></u-icon>
                    </view>
                    <view class="text-[22rpx] text-[var(--primary-color)] mt-6 p-2 rounded-[12rpx]"
                        style="border: 1px solid var(--primary-color);">选择形象</view>
                </view>
            </view>
            <view v-else class="flex" @click="selectedCloneVideoEvent()">
                <view class="w-2/3 h-[240rpx] relative">
                    <!-- 使用内置样式替代图片 - 使用更可靠的实现方式 -->
                    <view class="w-full h-full rounded-lg video-cover" @click.stop="playVideo(selectedCloneVideo)">
                        <!-- 视频图标 -->
                        <view class="flex flex-col items-center justify-center h-full">
                            <u-icon name="video" color="#FFFFFF" size="40"></u-icon>
                            <text class="text-white text-[24rpx] mt-2 font-bold truncate px-2 text-center">{{
                                selectedCloneVideo.name }}</text>
                        </view>

                        <!-- 播放按钮 -->
                        <view class="play-btn-overlay">
                            <view class="play-btn">
                                <u-icon name="play-right-fill" color="#FFFFFF" size="28"></u-icon>
                            </view>
                        </view>
                    </view>
                </view>
                <view class="ml-2">
                    <view class="rounded-lg text-[24rpx] text-[var(--primary-color)] font-bold">{{
                        selectedCloneVideo.name }}</view>

                    <view v-if="selectedCloneVideo.channel && selectedCloneVideo.channel == 'common'"
                        class=" rounded-lg text-[24rpx] text-[var(--primary-color-light)] mt-4 h-[40rpx] leading-[40rpx]">
                        当前是普通形象，最长只能生成60s内视频，超过60s会生成失败;文本字数建议控制在150字左右
                    </view>
                    <view class="mt-8 flex items-center justify-center rounded-lg text-[24rpx] px-3 py-2 hover-scale transition-all duration-300 bg-gradient-to-r from-[var(--primary-color-light2)] to-[var(--primary-color-light2)] hover:from-[var(--primary-color)] hover:to-[var(--primary-help-color)]"
                        style="border: 1px solid var(--primary-color); box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                        <u-icon name="" size="16" color="var(--primary-color)" class="mr-1"></u-icon>
                        <text class="font-medium text-[var(--primary-color)]">重选形象</text>
                    </view>
                </view>
            </view>
            <view class="mt-4">
                <view class="flex flex-col items-center p-4 border rounded-lg w-full box-border"
                    style="border-image: linear-gradient(45deg, var(--primary-color), var(--primary-help-color)) 1; box-shadow: 0 0 4px var(--primary-color-light);">
                    <view class="flex items-center mt-2 bg-[var(--primary-color-light2)] rounded-lg p-1 mb-4 w-full">
                        <block v-for="(item, index) in createTypeList" :key="index">
                            <view @click="createTypeChange(item)"
                                :hover-class="form.type === item.type ? '' : 'button-hover'" :style="form.type === item.type
                                    ? {
                                        background: `linear-gradient(to right, var(--primary-color), var(--primary-help-color))`,
                                        color: 'var(--primary-color-light2)'
                                    }
                                    : {
                                        backgroundColor: 'transparent',
                                        color: 'var(--primary-color-light)'
                                    }"
                                class="text-28rpx px-6 flex items-center justify-center h-80rpx rounded-lg transition-all duration-300 flex-1">
                                <view class="flex items-center">
                                    <u-icon :name="item.type === 'audio' ? 'mic' : 'edit-pen'" size="18" :color="form.type === item.type ? 'var(--primary-color-light2)' : 'var(--primary-color-light)'"></u-icon>
                                    <text class="ml-1">{{ item.name }}</text>
                                </view>
                            </view>
                        </block>
                    </view>

                    <view v-if="form.type == 'audio'">
                        <UploadVoice @success="voiceSuccess" />
                    </view>
                    <!-- 优化输入框边距 -->
                    <view v-if="form.type == 'text'" class="p-0 w-full">
                        <!-- 添加提示 -->
                        <view class="flex items-center justify-between mb-2 px-2">
                            <view class="text-[24rpx] text-[var(--primary-color)]">请输入或粘贴配音文案</view>
                            <view v-if="form.content.length > 0" 
                                  class="text-[24rpx] text-[var(--primary-color-light)] bg-[var(--primary-color-light2)] py-1 px-2 rounded-full"
                                  @click="form.content = ''">
                                清空全部
                            </view>
                        </view>
                        
                        <view class="textarea-container w-full px-0">
                            <textarea
                                class="p-4 bg-[var(--primary-color-light2)] rounded-lg text-[var(--primary-color-light)] text-[28rpx] resize-none w-full"
                                :class="{'textarea-focus': textareaFocus}"
                                v-model="form.content" 
                                placeholder="请输入合适的配音文案"
                                :maxlength="form.channel == 'common' ? 200 : 900"
                                :style="{ minHeight: textareaHeight + 'px', width: '100%' }"
                                @input="textareaInput"
                                auto-height
                                show-confirm-bar="false"
                                adjust-position
                                cursor-spacing="120"
                                @focus="handleTextareaFocus"
                                @blur="handleTextareaBlur"></textarea>
                            <!-- 字数统计指示器 - 固定在右下角 -->

                        </view>
                        <view class="flex justify-between items-center mt-4">
                            <view class="flex items-center">
                                <view class="flex flex-col items-center"
                                    @click="redirect({ url: '/addon/ai_humans/pages/model/model' })">
                                    <view>
                                        <u-icon name="file-text" color="var(--primary-color-light)" size="18"></u-icon>
                                    </view>
                                    <view class="text-[22rpx] text-[var(--primary-color-light)] mt-1">AI文案</view>
                                </view>
                                <view class="flex flex-col items-center ml-4" @click="selectedCloneVoiceEvent()">
                                    <view>
                                        <u-icon name="server-man" color="var(--primary-color-light)" size="18"></u-icon>
                                    </view>
                                    <view class="text-[22rpx] text-[var(--primary-color-light)] mt-1">
                                        {{ form.voice_id ? '重选' : '声音' }}
                                    </view>
                                </view>
                                <view v-if="form.voice_id" class="flex flex-col items-center ml-4"
                                    @click="playSelectedVoice()">
                                    <view>
                                        <u-icon :name="isPlaying ? 'close' : 'volume'"
                                            color="var(--primary-color-light)" size="18"></u-icon>
                                    </view>
                                    <view class="text-[22rpx] text-[var(--primary-color-light)] mt-1">
                                        {{ isPlaying ? '停止' : '播放' }}
                                    </view>
                                </view>
                            </view>

                            <view class="flex justify-end items-center">
                                <view v-if="form.voice_id && form.voice_name"
                                    class="text-xs text-[var(--primary-color)] mr-2">
                                    当前: {{ form.voice_name }}
                                </view>
                            </view>
                            <view class="word-count" 
                                  :class="{'text-red-500': form.content.length >= (form.channel == 'common' ? 180 : 850)}">
                                {{ form.content.length }}/{{ form.channel == 'common' ? 200 : 900 }}
                            </view>
                        </view>
                        <view class="text-[24rpx] text-[var(--primary-color)] mt-2">音频合成将额外消耗{{
                            form.voice_channel == 'common' ? config.create_voice : config.create_voice_pro }}{{
                                config.name }}/分钟
                        </view>
                    </view>
                </view>
            </view>
            <view class="mb-4 mt-4">
                <view class="flex items-center mb-2">
                    <view
                        class="w-2 h-[36rpx] bg-gradient-to-b from-[var(--primary-color)] to-[var(--primary-help-color)] rounded mr-[16rpx]"
                        :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color))' }">
                    </view>
                    <view class="text-[32rpx] font-bold text-[var(--primary-color)]">消耗{{ config.name }}</view>
                </view>
                <view class="text-xs text-gray-400 mt-2">
                    <text
                        style="background: linear-gradient(to right, var(--primary-color), var(--primary-help-color)); -webkit-background-clip: text; color: transparent;">*</text>
                    <text
                        class="text-[var(--primary-color-dark)] text-[24rpx] h-[44rpx] leading-[44rpx]">如无抵扣额度,本次视频合成将消耗{{
                            form.channel == 'common' ? config.create_video : config.create_video_pro }}{{ config.name
                        }}/分钟</text>
                </view>
            </view>
        </view>
        <view class="h-22"></view>
        <view class="w-full footer bg-[var(--page-bg-color)]">
            <view
                class="py-[var(--top-m)] px-[var(--sidebar-m)] footer w-full fixed bottom-0 left-0 right-0 box-border bg-[var(--page-bg-color)] safe-area-inset-bottom">
                <view class="flex items-center ml-4">
                    <checkbox-group class="flex items-center uni-list" @change="checkboxChange">
                        <u-checkbox v-model="isOpenAgreement" shape="circle" :name="true" size="22"
                            activeColor="var(--primary-color)" @change="checkboxChange"></u-checkbox>
                        <view
                            class="ml-1 text-[var(--primary-color-light)] hover:text-gray-500 active:text-gray-600 inline-flex items-center  text-[24rpx]"
                            role="button" tabindex="0">
                            阅读并同意
                            <span @click="
                                redirect({
                                    url: '/app/pages/auth/agreement?key=ai_humans_privacy',
                                })
                                " class="text-[24rpx]"
                                style="background: linear-gradient(to right, var(--primary-color), var(--primary-help-color)); -webkit-background-clip: text; color: transparent;">
                                《 {{ "隐私条款" }}》
                            </span>和
                            <span @click="
                                redirect({
                                    url: '/app/pages/auth/agreement?key=ai_humans_service',
                                })" class="text-[24rpx]"
                                style="background: linear-gradient(to right, var(--primary-color), var(--primary-help-color)); -webkit-background-clip: text; color: transparent;">
                                《{{ "服务协议" }}》
                            </span>
                        </view>
                    </checkbox-group>
                </view>
                <view class="flex items-center justify-between ml-4 mr-4 mt-2">
                    <view class="flex items-cente">
                        <view class="flex flex-col items-center"
                            @click="redirect({ url: '/addon/ai_humans/pages/video/create_list' })">
                            <view>
                                <u-icon name="grid" color="var(--primary-color-light)" size="22"></u-icon>
                            </view>
                            <view class="text-[26rpx] text-[var(--primary-color-light)] mt-2">我的作品</view>
                        </view>
                        <view class="flex flex-col items-center ml-4"
                            @click="redirect({ url: '/addon/ai_humans/pages/member/my_create' })">
                            <view>
                                <u-icon name="rmb-circle" color="var(--primary-color-light)" size="22"></u-icon>
                            </view>
                            <view class="text-[26rpx] text-[var(--primary-color-light)] mt-2">数字资产</view>
                        </view>
                        <view class="flex flex-col items-center ml-4"
                            @click="redirect({ url: '/addon/ai_humans/pages/member/log' })">
                            <view>
                                <u-icon name="integral" color="var(--primary-color-light)" size="22"></u-icon>
                            </view>
                            <view class="text-[26rpx] text-[var(--primary-color-light)] mt-2">{{ config.name }}消耗</view>
                        </view>
                    </view>
                    <view>
                        <button hover-class="none"
                            class="h-[88rpx] leading-[88rpx] rounded-[24rpx] text-[28rpx] font-500 text-[var(--primary-color-light2)] w-[228rpx]"
                            :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color))' }"
                            @click=" throttle(createVideoEvent, 500)">立 即 创 作</button>
                    </view>

                </view>
                <u-safe-bottom></u-safe-bottom>
            </view>
        </view>
        <u-popup :show="showCloneVideoPopup" @close="showCloneVideoPopup = false" mode="bottom" round="16">
            <view class="bg-[var(--primary-color-light2)]">
                <!-- 添加顶部固定区域 -->
                <view
                    class="h-[40rpx] bg-[var(--primary-color-light2)] flex justify-between items-center px-4 pt-4 pb-2">
                    <view class="text-[28rpx] font-bold text-[var(--primary-color)]">选择形象</view>
                    <view class="text-[28rpx] font-bold text-[var(--primary-color)]"
                        @click.stop="redirect({ url: '/addon/ai_humans/pages/video/clone' })">新增形象</view>
                    <u-icon name="close" size="22" color="var(--primary-color)" @click="showCloneVideoPopup = false" />
                </view>
                <scroll-view scroll-y style="max-height: 60vh;min-height: 40vh;">
                    <view class="p-2 flex flex-wrap">
                        <view v-for="(item, index) in cloneVideoList" :key="index" class="w-1/3 px-1 mb-2 box-border">
                            <view class="p-2 rounded-[8rpx] shadow-sm"
                                :style="{ background: 'linear-gradient(to right, var(--primary-color-light2), var(--primary-color-light2))' }">
                                <view class="w-full relative" @click.stop="playVideo(item)">
                                    <!-- 视频封面区域 - 使用更可靠的实现方式 -->
                                    <view class="w-full aspect-video rounded-lg video-cover-small" :style="{
                                        background: 'linear-gradient(72deg, var(--primary-color-light) 0%, var(--primary-color) 100%)',
                                        position: 'relative',
                                        overflow: 'hidden'
                                    }">
                                        <!-- 视频图标 -->
                                        <view class="absolute inset-0 flex flex-col items-center justify-center">
                                         
                                            <text class="text-white text-[24rpx] mt-2 font-bold">{{ item.name }}</text>
                                        </view>

                                        <!-- 播放按钮 -->
                                        <view class="play-btn-overlay">
                                            <view class="play-btn-small">
                                                <u-icon name="play-right-fill" color="#FFFFFF" size="24"></u-icon>
                                            </view>
                                        </view>
                                    </view>
                                </view>
                                <view class="flex justify-between items-center mt-1">
                                    <view class="text-[24rpx] font-bold truncate w-3/5">{{ item.name }}</view>
                                    <view class="text-[24rpx] text-[var(--primary-color)] p-1 rounded-[8rpx]"
                                        style="border: 1px solid var(--primary-color);"
                                        @click.stop="selectedCloneVideoFn(item)">
                                        选择
                                    </view>
                                </view>
                            </view>
                        </view>
                    </view>
                </scroll-view>
            </view>
        </u-popup>

        <!-- 添加视频播放弹窗 -->
        <u-popup :show="showVideoPlayer" @close="closeVideoPlayer" mode="center" round="16" :closeable="true"
            close-icon-pos="top-right" close-icon-color="#ffffff" :mask-close-able="true" safe-area-inset-bottom
            :z-index="9999">
            <view class="video-player-container">
                <video :src="currentVideoUrl" id="videoPlayer" class="video-player" autoplay controls
                    show-fullscreen-btn show-play-btn show-center-play-btn @ended="closeVideoPlayer"></video>
            </view>
        </u-popup>

        <u-popup :show="showCloneVoicePopup" @close="showCloneVoicePopup = false" mode="bottom" round="16">
            <view class="bg-[var(--primary-color-light2)]">
                <!-- 添加顶部固定区域 -->
                <view
                    class="h-[40rpx] bg-[var(--primary-color-light2)] flex justify-between items-center px-4 pt-4 pb-2">
                    <view class="text-[28rpx] font-bold text-[var(--primary-color)]">选择音色</view>
                    <view class="text-[28rpx] font-bold text-[var(--primary-color)]"
                        @click="redirect({ url: '/addon/ai_humans/pages/voice/clone' })">添加音色</view>
                    <u-icon name="close" size="22" color="var(--primary-color)" @click="showCloneVoicePopup = false" />
                </view>
                <scroll-view scroll-y style="max-height: 60vh;min-height: 40vh;">
                    <view class="p-2 flex flex-wrap">
                        <view v-for="(item, index) in cloneVoiceList" :key="index" class="w-1/3 px-1 mb-2 box-border">
                            <view class="p-2 rounded-[8rpx] shadow-sm"
                                :style="{ background: 'linear-gradient(to right, var(--primary-color-light2), var(--primary-color-light2))' }">
                                <view class="w-full relative">
                                    <!-- 替换为音频播放控制UI -->
                                    <view class="w-full h-[120rpx] rounded-lg flex items-center justify-center relative"
                                        :class="{
                                            'bg-gradient-to-r from-[var(--primary-color)] to-[var(--primary-help-color)]': currentPlayingIndex === index,
                                            'bg-[var(--primary-color)]': currentPlayingIndex !== index
                                        }">
                                        <view class="absolute inset-0 flex items-center justify-center"
                                            @click="togglePlayVoice(item, index)">
                                            <u-icon :name="currentPlayingIndex === index ? 'volume-off' : 'volume'"
                                                size="40" color="var(--primary-color-light2)"></u-icon>
                                        </view>
                                        <view v-if="currentPlayingIndex === index"
                                            class="absolute bottom-2 right-2 text-[20rpx] text-white">
                                            {{ currentPlayTime }}s
                                        </view>
                                    </view>
                                </view>
                                <view class="flex justify-between items-center mt-2">
                                    <view class="text-[24rpx] font-bold truncate w-3/5">{{ item.name }}</view>
                                    <view class="text-[24rpx] text-[var(--primary-color)] p-1 rounded-[8rpx]"
                                        style="border: 1px solid var(--primary-color);"
                                        @click="selectedCloneVoiceFn(item)">
                                        选择
                                    </view>
                                </view>
                            </view>
                        </view>
                    </view>
                </scroll-view>
            </view>
        </u-popup>
    </view>
    <!-- #ifdef MP-WEIXIN -->
    <!-- 小程序隐私协议 -->
    <wx-privacy-popup ref="wxPrivacyPopupRef"></wx-privacy-popup>
    <!-- #endif -->

</template>

<script setup lang="ts">
import {
    ref,
    reactive,
    onMounted,
    onUnmounted,
    nextTick
} from 'vue'
import {
    onLoad
} from '@dcloudio/uni-app'
import { throttle } from 'uview-plus';
import { img, copy, redirect } from '@/utils/common'
import UploadVoice from '@/addon/ai_humans/pages/components/upload-voice.vue'
import { uploadVoiceApi } from '@/addon/ai_humans/api/upload'
import { cloneVoice } from '@/addon/ai_humans/api/voice'
import { getCloneVideoList, createVideo } from '@/addon/ai_humans/api/video'
import { getCloneVoiceList } from '@/addon/ai_humans/api/voice'
import { checkAccountEvent } from '@/addon/ai_humans/utils/ts/common'
checkAccountEvent('create_video')
import { getConfig } from '@/addon/ai_humans/api/config';
const config = ref<any>({});
getConfig().then((res) => {
    config.value = res.data;
})

// 文本区域高度控制
const textareaHeight = ref<number>(120);
const textareaFocus = ref<boolean>(false);

// 处理文本域获取焦点
const handleTextareaFocus = () => {
    textareaFocus.value = true;
};

// 处理文本域失去焦点
const handleTextareaBlur = () => {
    textareaFocus.value = false;
};

// 防抖函数
const debounce = (fn: Function, delay: number) => {
    let timer: any = null;
    return function(...args: any) {
        if (timer) clearTimeout(timer);
        timer = setTimeout(() => {
            fn.apply(this, args);
        }, delay);
    }
}

// 优化的文本输入处理，带防抖
const textareaInput = debounce(() => {
    // 根据内容长度动态调整最小高度
    const contentLength = form.value.content.length;
    if (contentLength < 50) {
        textareaHeight.value = 120;
    } else if (contentLength < 150) {
        textareaHeight.value = 160;
    } else if (contentLength < 300) {
        textareaHeight.value = 200;
    } else {
        textareaHeight.value = 240;
    }
    
    // 本地存储当前输入内容，防止意外丢失
    try {
        uni.setStorageSync('ai_humans_content_cache', form.value.content);
    } catch (e) {
        // 存储失败不影响主流程
    }
}, 300);

// 页面加载时检查是否有缓存的文本
onMounted(() => {
    try {
        const cachedContent = uni.getStorageSync('ai_humans_content_cache');
        if (cachedContent && !form.value.content) {
            form.value.content = cachedContent;
            textareaInput();
        }
    } catch (e) {
        // 读取失败不影响主流程
    }
});

const form = ref({
    channel: 'common',
    name: '',
    voice_url: '',
    voice_id: '',
    voice_name: '',
    voice_channel: 'common',
    content: '',
    type: 'audio',
    scene_task_id: '',
})
const channel = ref('common')
const createTypeList = ref([
    {
        name: '语音驱动',
        type: 'audio'
    },
    {
        name: '文本驱动',
        type: 'text'
    }
])
const createTypeChange = (item) => {
    form.value.type = item.type
}
const createVideoEvent = async () => {

    let scene = 'create_video'
    if (form.value.channel == 'common') {
        scene = 'create_video'
    } else {
        scene = 'create_video_pro'
    }
    checkAccountEvent(scene)
    if (!form.value.scene_task_id) {
        uni.$u.toast('请选择演员')
        return
    }
    if (!form.value.name) {
        uni.$u.toast('请输入合成视频名称')
        return
    }
    if (!isOpenAgreement.value) {
        uni.$u.toast('请阅读并勾选协议')
        return
    }

    if (form.value.type == 'audio') {
        if (voiceRecord.value.duration > 60 && selectedCloneVideo.value.channel == 'common') {
            uni.$u.toast('普通演员形象声音不能大于60秒')
            return
        }
        uni.showLoading({
            title: '音频上传中...',
            mask: true
        })
        uploadVoiceApi({
            filePath: voiceRecord.value.url,
            name: 'file'
        }).then((res: any) => {
            uni.hideLoading()
            form.value.voice_url = res.data.url
            uni.showLoading({
                title: '创建合成任务...',
                mask: true
            })
            //验证完成后进行合成
            createVideo({
                ...form.value
            }).then((res: any) => {
                uni.hideLoading()
                // 清除缓存
                clearFormCache()
                redirect({ url: '/addon/ai_humans/pages/video/create_list' })
            }).catch((err: any) => {
                uni.hideLoading()
            })
        }).catch((err: any) => {
            uni.hideLoading()
        })
    } else {
        if (form.value.content == '') {
            uni.$u.toast('请输入配音文案')
            return
        }
        if (form.value.content.length > 900) {
            uni.$u.toast('配音文案不能大于900字')

            return
        }
        if (form.value.voice_id == '') {
            showCloneVoicePopup.value = true
            uni.$u.toast('请选择音色')
            return
        }
        uni.showLoading({
            title: '创建合成任务中...',
            mask: true
        })
        //验证完成后进行合成
        createVideo({
            ...form.value
        }).then((res: any) => {
            uni.hideLoading()
            // 清除缓存
            clearFormCache()
            redirect({ url: '/addon/ai_humans/pages/video/create_list' })
        }).catch((err: any) => {
            uni.hideLoading()
        })
    }


}
const channelChange = (type) => {
    channel.value = type
    form.value.channel = type
}
const isOpenAgreement = ref(false);
const checkboxChange = (e) => {
    if (isOpenAgreement.value == true) {
        isOpenAgreement.value = false;
    } else {
        isOpenAgreement.value = true;
    }
};
const voiceRecord = ref({
    url: '',
    file: '',
    duration: 0
})
const voiceSuccess = (res: any) => {
    // #ifdef H5
    voiceRecord.value.file = res.file;
    // #endif
    voiceRecord.value.duration = res.duration;
    voiceRecord.value.url = res.url;
    form.value.duration = res.duration
    if (res.duration > 60 && form.value.channel == 'common') {
        uni.$u.toast('普通演员声音不能大于60秒')
        return
    }
}

const showCloneVideoPopup = ref<boolean>(false)
const cloneVideoList = ref<Array<any>>([])
const selectedCloneVideo = ref<any>(null)
const selectedCloneVideoEvent = (item: any) => {
    getCloneVideoListData()
    showCloneVideoPopup.value = true
}
const selectedCloneVideoFn = (item: any) => {
    channel.value = item.channel
    form.value.channel = item.channel
    getCloneVideoListData()
    form.value.scene_task_id = item.task_id
    selectedCloneVideo.value = item
    showCloneVideoPopup.value = false
}
const getCloneVideoListData = async () => {
    try {
        const res = await getCloneVideoList({
            page: 1,
            limit: 50,
            status: 2
        })
        cloneVideoList.value = res.data.data
    } catch (error) {
        uni.$u.toast('获取演员列表失败')
    }
}

const showCloneVoicePopup = ref<boolean>(false)
const cloneVoiceList = ref<Array<any>>([])
const selectedCloneVoice = ref<any>(null)
const selectedCloneVoiceEvent = (item: any) => {
    getCloneVoiceListData()
    showCloneVoicePopup.value = true
}
const selectedCloneVoiceFn = (item: any) => {
    form.value.voice_id = item.voice_id
    form.value.voice_name = item.name
    selectedCloneVoice.value = item
    showCloneVoicePopup.value = false
    // 停止当前正在播放的音频
    stopCurrentAudio()
}
const getCloneVoiceListData = async () => {
    try {
        const res = await getCloneVoiceList({
            page: 1,
            limit: 50,
            status: 2
        })
        cloneVoiceList.value = res.data.data
    } catch (error) {
        uni.$u.toast('获取音色列表失败')
    }
}

// 音频播放相关
const audioContext = ref<UniApp.InnerAudioContext | null>(null)
const currentPlayingIndex = ref<number>(-1)
const currentPlayTime = ref<number>(0)
const playTimer = ref<number | null>(null)
const isPlaying = ref<boolean>(false)

// 播放或暂停音频
const togglePlayVoice = (item: any, index: number) => {
    // 如果点击的是当前正在播放的音频
    if (currentPlayingIndex.value === index && audioContext.value) {
        // 暂停播放
        audioContext.value.pause()
        currentPlayingIndex.value = -1
        isPlaying.value = false
        clearInterval(playTimer.value as number)
        playTimer.value = null
        return
    }

    // 停止当前正在播放的音频
    stopCurrentAudio()

    // 播放新的音频
    audioContext.value = uni.createInnerAudioContext()
    audioContext.value.src = img(item.voice_url)
    audioContext.value.autoplay = true
    currentPlayingIndex.value = index
    isPlaying.value = true
    currentPlayTime.value = 0

    // 更新播放时间显示
    playTimer.value = setInterval(() => {
        if (audioContext.value) {
            currentPlayTime.value = Math.floor(audioContext.value.currentTime)
        }
    }, 1000) as unknown as number

    // 设置音频播放结束的回调
    audioContext.value.onEnded(() => {
        // 如果是最后一个音频，从第一个开始播放
        if (index === cloneVoiceList.value.length - 1 && cloneVoiceList.value.length > 0) {
            setTimeout(() => {
                // 延迟一点播放第一个，避免播放过快
                togglePlayVoice(cloneVoiceList.value[0], 0)
            }, 500)
        } else {
            stopCurrentAudio()
        }
    })

    // 设置音频播放错误的回调
    audioContext.value.onError((res) => {
        uni.$u.toast('音频播放失败')
        stopCurrentAudio()
    })
}

// 手动切换到下一个音频
const playNextVoice = () => {
    if (currentPlayingIndex.value === -1 || cloneVoiceList.value.length === 0) return

    // 计算下一个索引，如果是最后一个则回到第一个
    const nextIndex = (currentPlayingIndex.value + 1) % cloneVoiceList.value.length
    togglePlayVoice(cloneVoiceList.value[nextIndex], nextIndex)
}

// 播放或停止当前选择的音色
const playSelectedVoice = () => {
    // 如果正在播放，则停止播放
    if (isPlaying.value) {
        stopCurrentAudio()
        return
    }

    if (!form.value.voice_id || !selectedCloneVoice.value) {
        uni.$u.toast('请先选择音色')
        return
    }

    // 停止当前正在播放的音频
    stopCurrentAudio()

    // 播放选择的音色音频
    audioContext.value = uni.createInnerAudioContext()
    audioContext.value.src = img(selectedCloneVoice.value.voice_url)
    audioContext.value.autoplay = true

    // 设置播放状态
    currentPlayingIndex.value = -2 // 使用-2表示正在播放选中的音色而非列表中的音色
    isPlaying.value = true
    currentPlayTime.value = 0

    // 更新播放时间显示
    playTimer.value = setInterval(() => {
        if (audioContext.value) {
            currentPlayTime.value = Math.floor(audioContext.value.currentTime)
        }
    }, 1000) as unknown as number

    // 设置音频播放结束的回调
    audioContext.value.onEnded(() => {
        stopCurrentAudio()
    })

    // 设置音频播放错误的回调
    audioContext.value.onError((res) => {
        uni.$u.toast('音频播放失败')
        stopCurrentAudio()
    })
}

// 停止当前正在播放的音频
const stopCurrentAudio = () => {
    if (audioContext.value) {
        audioContext.value.stop()
        audioContext.value.destroy()
        audioContext.value = null
    }
    currentPlayingIndex.value = -1
    isPlaying.value = false
    currentPlayTime.value = 0
    if (playTimer.value !== null) {
        clearInterval(playTimer.value as number)
        playTimer.value = null
    }
}

// 视频播放相关变量和函数
const showVideoPlayer = ref<boolean>(false)
const currentVideoUrl = ref<string>('')

// 获取视频封面（第一帧）
const getVideoCover = (videoUrl: string): string => {
    // 修改为直接返回视频链接，由image组件自动获取封面
    if (videoUrl) {
        // 去掉OSS处理参数，这种方式在很多环境下不适用
        return img(videoUrl)
    }
    // 返回默认封面图片
    return '/static/img/video-cover.png'
}

// 播放视频
const playVideo = (item: { video_url: string, name: string, task_id: string, channel: string }): void => {
    // 停止可能正在播放的音频
    stopCurrentAudio()

    // 设置当前播放的视频URL
    currentVideoUrl.value = img(item.video_url)

    // 使用nextTick确保DOM更新后再显示弹窗
    nextTick(() => {
        showVideoPlayer.value = true

        // 在小程序环境中可能需要手动调用播放
        // #ifdef MP
        setTimeout(() => {
            const videoContext = uni.createVideoContext('videoPlayer');
            if (videoContext) {
                videoContext.play();
            }
        }, 300);
        // #endif
    })
}

// 关闭视频播放器
const closeVideoPlayer = (): void => {
    // 先暂停视频
    try {
        // #ifdef H5
        const videoElement = document.getElementById('videoPlayer');
        if (videoElement && videoElement instanceof HTMLVideoElement) {
            videoElement.pause();
        }
        // #endif

        // #ifndef H5
        const videoContext = uni.createVideoContext('videoPlayer');
        if (videoContext) {
            videoContext.pause();
        }
        // #endif
    } catch (error) {
        console.log('视频暂停失败', error);
    }

    // 然后关闭弹窗
    showVideoPlayer.value = false;
    currentVideoUrl.value = '';
}

// 清除表单缓存
const clearFormCache = () => {
    try {
        uni.removeStorageSync('ai_humans_content_cache');
    } catch (e) {
        // 清除失败不影响主流程
    }
}

// 组件卸载时清理资源
onUnmounted(() => {
    stopCurrentAudio()
    closeVideoPlayer()
})
</script>

<style lang="scss">
@import '@/addon/ai_humans/utils/styles/common.scss';

.u-popup {
    border-radius: 16rpx 16rpx 0 0;
    overflow: hidden;
}

/* 确保视频播放弹窗在最顶层 */
:deep(.u-popup__content) {
    z-index: 9999 !important;
}

/* 确保视频播放蒙层在最顶层 */
:deep(.u-overlay) {
    z-index: 9998 !important;
}

.video-player-container {
    width: 650rpx;
    height: 480rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #000;
    border-radius: 16rpx;
    overflow: hidden;
    box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.2);
    z-index: 10000;
    /* 确保视频容器也有高层级 */
}

.video-player {
    width: 100%;
    height: 100%;
}

/* 视频封面样式 */
.video-cover {
    position: relative;
    background: linear-gradient(135deg, #4a6bff 0%, #2541b8 100%);
    overflow: hidden;
    box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.15);
    border-radius: 12rpx;
}

.video-cover-small {
    position: relative;
    background: linear-gradient(135deg, #4a6bff 0%, #2541b8 100%);
    overflow: hidden;
    box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.15);
    border-radius: 8rpx;
    height: 240rpx;
}

/* 播放按钮覆盖层 */
.play-btn-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(0, 0, 0, 0.2);
}

/* 播放按钮样式 */
.play-btn {
    width: 80rpx;
    height: 80rpx;
    border-radius: 50%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.3);
}

.play-btn-small {
    width: 60rpx;
    height: 60rpx;
    border-radius: 50%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4rpx 8rpx rgba(0, 0, 0, 0.3);
}

/* 原有的按钮样式 */
.play-button {
    width: 80rpx;
    height: 80rpx;
    border-radius: 50%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    transition: transform 0.2s;
}

.play-button:active {
    transform: scale(0.95);
}

.button-hover {
    background-color: var(--primary-color-light) !important;
    opacity: 0.9;
}

/* 小程序textarea样式优化 */
textarea {
    box-sizing: border-box;
    width: 100% !important;
    min-height: 120px !important;
    font-size: 28rpx !important;
}

/* #ifdef MP-WEIXIN || MP-ALIPAY || MP-BAIDU || MP-TOUTIAO || MP-QQ */
textarea {
    padding: 20rpx !important;
    line-height: 1.6 !important;
    margin-bottom: 20rpx;
    border-radius: 12rpx;
    width: 100% !important;
}

/* 增加点击面积 */
.textarea-container {
    position: relative;
    padding: 0;
    margin-bottom: 30rpx;
    width: 100% !important;
}

/* 字数显示样式优化 */
.word-count {
    background-color: rgba(0, 0, 0, 0.5);
    color:var(--primary-color-light);
    padding: 6rpx 16rpx;
    border-radius: 30rpx;
    font-size: 24rpx;
    position: absolute;
    bottom: 20rpx;
    right: 20rpx;
    z-index: 2;
}

/* 文本区域焦点样式 */
.textarea-focus {
    box-shadow: 0 0 0 4rpx rgba(var(--primary-color-rgb), 0.3);
    border: 1px solid var(--primary-color);
}
/* #endif */

/* 新增hover缩放效果 */
.hover-scale {
    transition: transform 0.3s ease;
}

.hover-scale:active {
    transform: scale(0.95);
}
</style>