<template>
    <view class="bg-[var(--page-bg-color)] min-h-screen" :style="themeColor()">
        <view class="text-white p-4 rounded-lg">

            <view class="mb-4">
                <view class="mb-4">
                    <view class="flex items-center">
                        <view
                            class="w-2 h-[36rpx] bg-gradient-to-b from-[var(--primary-color)] to-[var(--primary-help-color)] rounded mr-[16rpx]"
                            :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color))' }">
                        </view>
                        <view class="text-[32rpx] font-bold text-[var(--primary-color)]">形象名称</view>
                    </view>
                    <view class="mt-2">
                        <input class="p-2 bg-[var(--primary-color-light2)] rounded-md text-[var(--primary-color-light)]"
                            v-model="form.name" placeholder="请输入形象名称" />
                    </view>
                </view>

            </view>
            <view class="mb-4" v-if="!form.video_url">
                <view class="flex flex-col items-center p-4 border rounded-lg" @click="uploadVideoEvent()"
                    style="border-image: linear-gradient(45deg, var(--primary-color), var(--primary-help-color)) 1; box-shadow: 0 0 4px var(--primary-color-light);">
                    <view class="">
                        <u-icon name="plus" size="44" color="var(--primary-color-light)"></u-icon>
                    </view>
                    <view class="text-[22rpx] text-[var(--primary-color-light)] mt-6">点击上传训练视频</view>
                </view>
            </view>
            <view v-else class="">
                <!-- 视频缩略图 -->
                <view class="relative w-full rounded-lg shadow-lg overflow-hidden" @click="showVideoPopup = true">
                    <image :src="videoThumbnail || defaultThumbnail" mode="aspectFill"
                        class="w-full h-[400rpx] rounded-lg" />
                    <view class="absolute inset-0 flex items-center justify-center bg-black bg-opacity-30">
                        <u-icon name="play-right-fill" size="60" color="#ffffff"></u-icon>
                    </view>
                </view>
                <view class="flex justify-center mt-2">
                    <view @click="reuploadVideo"
                        class="py-2 px-4 rounded-lg text-[24rpx] text-[var(--primary-help-color)]">
                        重新上传
                    </view>
                </view>
            </view>
            <view class="mb-4" v-if="config.is_video_pro == 1">
                <view class="flex items-center mb-2">
                    <view
                        class="w-2 h-[36rpx] bg-gradient-to-b from-[var(--primary-color)] to-[var(--primary-help-color)] rounded mr-[16rpx]"
                        :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color))' }">
                    </view>
                    <view class="text-[32rpx] font-bold text-[var(--primary-color)]">线路选择</view>
                </view>
                <scroll-view scroll-x class="scroll-container overflow-x-auto whitespace-nowrap"
                    :show-scrollbar="false">
                    <view class="flex space-x-2 px-1">
                        <block v-for="(item, index) in channelList" :key="index">
                            <view @tap="channelChange(item.channel)"
                                class="py-2 px-4 rounded-lg text-[24rpx] channel-item"
                                :class="[channel === item.channel ? 'channel-active' : 'channel-inactive']">
                                <text>{{ item.name }}</text>
                            </view>
                        </block>
                    </view>
                </scroll-view>
                <view class="text-xs text-gray-400 mt-2">
                    <text class="text-gradient">*</text>
                    <text
                        class="text-[var(--primary-color-dark)] text-[24rpx] h-[44rpx] leading-[44rpx]">高速Pro线路：使用专用算力资源，克隆效果更好、速度更快。高速Pro线路的模型只可用于高速Pro通道合成</text>
                </view>
            </view>
            <view class="mb-4">
                <view class="p-4 border rounded-lg shadow-lg" style="box-shadow: 0 0 4px var(--primary-color);">
                    <text class="text-lg font-bold text-[var(--primary-color)]">视频要求</text>
                    <view class="flex flex-col gap-2 mt-2 text-sm text-[var(--primary-color-light)]">
                        <view>1. 视频格式要求为 MP4/MOV;</view>
                        <view>2. 视频大小低于 100M;</view>
                        <view>3. 不要使用有多人的视频;</view>
                        <view>4. 不要遮挡面部，确保人脸不出屏幕，并使面部宽度占整体画面的 1/4 以上;</view>
                        <view>5. 分辨率不低于 360p，且不高于 4K。视频长度不少于 10 秒-5 分钟。</view>
                    </view>
                </view>
            </view>
            <view class="mb-4">
                <view class="flex items-center">
                    <view
                        class="w-2 h-[36rpx] bg-gradient-to-b from-[var(--primary-color)] to-[var(--primary-help-color)] rounded mr-[16rpx]"
                        :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color))' }">
                    </view>
                    <view class="text-[32rpx] font-bold text-[var(--primary-color)]">消耗{{ config.name }}</view>
                </view>
                <view class="text-xs text-gray-400 mt-2">
                    <text
                        style="background: linear-gradient(to right, var(--primary-color), var(--primary-help-color)); -webkit-background-clip: text; color: transparent;">*</text>
                    <text class="text-[var(--primary-color-dark)] text-[24rpx] h-[44rpx] leading-[44rpx]">如无抵扣额度,本次视频克隆将消耗{{
                        form.channel == 'common' ? config.clone_video : config.clone_video_pro }}{{ config.name
                        }}</text>
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
                            @click="redirect({ url: '/addon/ai_humans/pages/video/clone_list' })">
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
                            @click="throttle(cloneVideoEvent, 500)">立 即 克 隆</button>
                    </view>

                </view>
                <u-safe-bottom></u-safe-bottom>
            </view>
        </view>

        <!-- 视频播放弹窗 -->
        <u-popup :show="showVideoPopup" mode="center" round="16" closeable @close="showVideoPopup = false"
            :safe-area-inset-bottom="true">
            <view class="p-4 w-[600rpx]">
                <video :src="img(form.video_url)" controls autoplay class="w-full rounded-lg"></video>
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
    nextTick,
    onMounted,
    computed
} from 'vue'
import {
    onLoad
} from '@dcloudio/uni-app'
import { throttle } from 'uview-plus';
import { img, copy, redirect } from '@/utils/common'
import { uploadVideo } from '@/app/api/system'
import { cloneVideo } from '@/addon/ai_humans/api/video'
import { checkAccountEvent } from '@/addon/ai_humans/utils/ts/common'
import useConfigStore from '@/stores/config'

checkAccountEvent('clone_video')
import { getConfig } from '@/addon/ai_humans/api/config';
const config = ref<any>({});
getConfig().then((res) => {
    config.value = res.data;
})

// 修复themeColor未定义的问题
const themeColor = computed(() => {
    return () => useConfigStore().getThemeColor();
})

const form = ref({
    channel: 'common',
    name: '',
    video_url: ''
})
const channel = ref('common')
const channelList = ref([
    {
        name: '普通',
        channel: 'common'
    },
    {
        name: '高速Pro',
        channel: 'vip'
    }
])
const loading = ref(false)
// 视频播放弹窗控制
const showVideoPopup = ref(false)
// 视频缩略图
const videoThumbnail = ref('')
// 默认缩略图
const defaultThumbnail = ref('/static/images/video-thumbnail.png')

const cloneVideoEvent = async () => {
    let scene = 'clone_video'
    if (form.value.channel == 'common') {
        scene = 'clone_video'
    } else {
        scene = 'clone_video_pro'
    }
    checkAccountEvent(scene)
    if (!isOpenAgreement.value) {
        uni.$u.toast('请阅读并勾选协议')
        return
    }
    if (!form.value.video_url) {
        uni.$u.toast('请上传视频')
        return
    }
    if (!form.value.name) {
        uni.$u.toast('请输入视频名称')
        return
    }

    cloneVideo({
        channel: channel.value,
        name: form.value.name,
        video_url: form.value.video_url
    }).then((res: any) => {
        redirect({ url: '/addon/ai_humans/pages/video/clone_list' })
    }).catch((err: any) => {

    })
}
const channelChange = (type: string) => {
    channel.value = type
    form.value.channel = type
    // 强制更新小程序端的视图
    nextTick(() => {
        // 触发视图更新
        uni.createSelectorQuery().selectViewport().boundingClientRect().exec()
    })
}
const isOpenAgreement = ref(false);
const checkboxChange = (e: any) => {
    isOpenAgreement.value = !isOpenAgreement.value
}

const tempUrl = ref('')
const uploadVideoEvent = async () => {

    uni.chooseVideo({
        sourceType: ['album'],
        compressed: false,
        success(res) {
            uni.showLoading({
                title: '视频上传中...',
                mask: true
            })
            // 由于uni-app在某些平台上不直接提供视频缩略图，使用默认图片
            // 可以在实际项目中根据需要在服务端生成视频缩略图
            videoThumbnail.value = '/static/addon/ai_humans/video-poster.jpg'

            uploadVideo({
                filePath: res.tempFilePath,
                name: 'file'
            }).then((res: any) => {
                uni.hideLoading()
                form.value.video_url = res.data.url
                uni.$u.toast('视频上传成功')
            }).catch((err: any) => {
                uni.hideLoading()
            })
        }
    })
};
const reuploadVideo = () => {
    form.value.video_url = '';
    videoThumbnail.value = '';
    uploadVideoEvent()
};
</script>

<style lang="scss">
@import '@/addon/ai_humans/utils/styles/common.scss';

.text-gradient {
    background: linear-gradient(to right, var(--primary-color), var(--primary-help-color));
    -webkit-background-clip: text;
    color: transparent;
}

.channel-item {
    transition: all 0.2s ease;
}

.channel-active {
    background-color: var(--primary-color);
    color: var(--primary-color-light2);
}

.channel-inactive {
    border: 1px solid var(--primary-help-color);
    color: var(--primary-color-light);
}
</style>