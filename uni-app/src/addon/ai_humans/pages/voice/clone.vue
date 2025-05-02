<template>
    <view class="bg-[var(--page-bg-color)] min-h-screen" :style="themeColor()">
        <view class="text-white p-4 rounded-lg">

            <view class="mb-4">
                <view class="flex items-center">
                    <view
                        class="w-2 h-[36rpx] bg-gradient-to-b from-[var(--primary-color)] to-[var(--primary-help-color)] rounded mr-[16rpx]"
                        :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color))' }">
                    </view>
                    <view class="text-[32rpx] font-bold text-[var(--primary-color)]">声音名称</view>
                </view>
                <view class="mt-2">
                    <input class="p-2 bg-[var(--primary-color-light2)] rounded-md text-[var(--primary-color-light)]"
                        v-model="form.name" placeholder="请输入声音名称" />
                </view>
            </view>
            <view class="mb-4">
                <view class="mb-4">
                    <view class="flex items-center">
                        <view
                            class="w-2 h-[36rpx] bg-gradient-to-b from-[var(--primary-color)] to-[var(--primary-help-color)] rounded mr-[16rpx]"
                            :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color))' }">
                        </view>
                        <view class="text-[32rpx] font-bold text-[var(--primary-color)]">参考文案</view>
                    </view>
                    <view
                        class="p-2 mt-2 bg-[var(--primary-color-light2)] rounded-md text-[var(--primary-color-dark)] text-[28rpx] leading-[52rpx]">
                        {{
                            content }}</view>
                    <view @click="textChange()"
                        class="flex items-center py-2 px-4 rounded-lg text-[24rpx] text-[var(--primary-help-color)] justify-end">
                        <view>
                            <u-icon color="var(--primary-color)" name="reload" size="18"></u-icon>
                        </view>
                        <view class="ml-1 text-[var(--primary-color)]">
                            切换
                        </view>

                    </view>
                </view>
            </view>

            <!-- <view class="mb-4">
                <view class="text-sm mb-2">音色选择</view>
                <scroll-view scroll-x class="scroll-container overflow-x-auto" :show-scrollbar="false" enhanced
                    :bounces="true">
                    <view class="flex space-x-2">
                        <block v-for="(item, index) in channelList" :key="index">
                            <view @click="channelChange(item.channel)"
                                :class="['py-2 px-4 rounded-lg text-[24rpx]', channel == item.channel ? 'bg-[var(--primary-color)] text-[var(--primary-color-light2)]' : 'text-[var(--primary-help-color)]']"
                                :style="channel != item.channel ? 'border: 1px solid var(--primary-help-color);' : ''">
                                <text>{{ item.name }}</text>
                            </view>
                        </block>
                    </view>
                </scroll-view>
                <view class="text-xs text-gray-400 mt-2">
                    <text
                        style="background: linear-gradient(to right, var(--primary-color), var(--primary-help-color)); -webkit-background-clip: text; color: transparent;">*</text>
                    <text
                        class="text-[var(--primary-color-dark)] text-[24rpx] h-[44rpx] leading-[44rpx]">普通音色：打造个人专属声音模型;音声Pro线路：使用专用算力资源，克隆效果更好、速度更快。音声Pro线路的模型只可用于音声Pro通道合成</text>
                </view>
            </view> -->
            <view class="mb-4">
                <view class="mb-4">
                    <view class="flex items-center">
                        <view
                            class="w-2 h-[36rpx] bg-gradient-to-b from-[var(--primary-color)] to-[var(--primary-help-color)] rounded mr-[16rpx]"
                            :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color))' }">
                        </view>
                        <view class="text-[32rpx] font-bold text-[var(--primary-color)]">训练音频</view>
                    </view>
                    <view class="mt-2">
                        <UploadVoice @success="voiceSuccess" />
                    </view>
                </view>
            </view>
            <view class="mb-4">
                <view class="flex items-center">
                    <view
                        class="w-2 h-[36rpx] bg-gradient-to-b from-[var(--primary-color)] to-[var(--primary-help-color)] rounded mr-[16rpx]"
                        :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color))' }">
                    </view>
                    <view class="text-[32rpx] font-bold text-[var(--primary-color)]">注意事项</view>
                </view>

                <view class="text-xs text-gray-400 mt-2">
                    <text
                        style="background: linear-gradient(to right, var(--primary-color), var(--primary-help-color)); -webkit-background-clip: text; color: transparent;">*</text>
                    <text
                        class="text-[var(--primary-color-dark)] text-[24rpx] h-[44rpx] leading-[44rpx]">1.请严格按照要求内容进行录制
                        2.请在安静的环境进行录音 3.吐字清晰语速适当 4.录音时长控制在6-12秒最佳，最多不超过14秒 5.路子完成后先试听看是否到达要求再提交
                    </text>
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
                    <text
                        class="text-[var(--primary-color-dark)] text-[24rpx] h-[44rpx] leading-[44rpx]">如无抵扣额度,本次音色克隆将消耗{{
                            config.clone_voice }}{{ config.name }}</text>
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
                <view class="flex items-center justify-between ml-4 mr-4 mt-2 safe-area-inset-bottom">
                    <view class="flex items-cente">
                        <view class="flex flex-col items-center"
                            @click="redirect({ url: '/addon/ai_humans/pages/voice/clone_list' })">
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
                            @click="throttle(cloneVoiceEvent, 500)">立 即 克 隆</button>
                    </view>

                </view>
                <u-safe-bottom></u-safe-bottom>
            </view>
        </view>
    </view>
    <!-- #ifdef MP-WEIXIN -->
    <!-- 小程序隐私协议 -->
    <wx-privacy-popup ref="wxPrivacyPopupRef"></wx-privacy-popup>
    <!-- #endif -->
</template>

<script setup lang="ts">
import {
    ref,
    reactive
} from 'vue'
import {
    onLoad
} from '@dcloudio/uni-app'
import { img, copy, redirect } from '@/utils/common'
import { throttle } from 'uview-plus';
import { getBaseConfig } from '@/addon/ai_humans/utils/ts/common'
import UploadVoice from '@/addon/ai_humans/pages/components/upload-voice.vue'
import { uploadVoiceApi } from '@/addon/ai_humans/api/upload'
import { cloneVoice, getText } from '@/addon/ai_humans/api/voice'
import { useShare } from '@/hooks/useShare'
import { checkAccountEvent } from '@/addon/ai_humans/utils/ts/common'
import useConfigStore from "@/stores/config";
import { getConfig } from '@/addon/ai_humans/api/config';
const config = ref<any>({});
getConfig().then((res) => {
    config.value = res.data;
})

checkAccountEvent('clone_voice')
const content = ref('')
const text = ref()
const textIndex = ref(0)
getText().then((res: any) => {
    text.value = res.data
    content.value = text.value[textIndex.value].segText
})
const textChange = () => {
    textIndex.value++
    content.value = text.value[textIndex.value].segText
    let len = text.value.length
    if (textIndex.value >= (len - 1)) {
        textIndex.value = 0
        content.value = text.value[textIndex.value].segText
    }
}
const form = ref({
    channel: 'common',
    name: '',
    voice_url: '',
    duration: 0,
})
const channel = ref('common')
const channelList = ref([
    {
        name: '普通音色',
        channel: 'common'
    },
    {
        name: '音色Pro',
        channel: 'vip'
    }
])
const cloneVoiceEvent = async () => {
    let scene = 'clone_voice'
    if (form.value.channel == 'common') {
        scene = 'clone_voice'
    } else {
        scene = 'clone_voice_pro'
    }
    checkAccountEvent(scene)
    if (!isOpenAgreement.value) {
        uni.$u.toast('请阅读并勾选协议')
        return
    }

    if (!form.value.name) {
        uni.$u.toast('请输入声音名称')
        return
    }
    if (form.value.duration < 5&&form.value.duration>0) {
        uni.$u.toast('声音不能小于5秒')
    }
    if (form.value.duration > 30) {
        uni.$u.toast('声音不能大于30秒')
    }
    uni.showLoading({
        title: '声音上传中...',
        mask: true
    })
    uploadVoiceApi({
        filePath: voiceRecord.value.url,
        name: 'file'
    }).then((res: any) => {
        uni.hideLoading()
        form.value.voice_url = res.data.url
        uni.showLoading({
            title: '创建克隆任务...',
            mask: true
        })
        //请求克隆声音接口
        cloneVoice({
            ...form.value
        }).then((res: any) => {
            uni.hideLoading()
            redirect({ url: '/addon/ai_humans/pages/voice/clone_list' })
        }).catch((err: any) => {
            uni.hideLoading()
        })
    }).catch((err: any) => {
        uni.hideLoading()
    })

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
    console.log(res)
    // #ifdef H5
    voiceRecord.value.file = res.file;
    // #endif
    voiceRecord.value.duration = res.duration;
    voiceRecord.value.url = res.url;
    form.value.duration = res.duration
    if (res.duration < 5&&res.duration>0) {
        uni.$u.toast('声音不能小于5秒')
        return
    }
    if (res.duration > 30) {
        uni.$u.toast('声音不能大于30秒')
        return
    }
}

</script>

<style lang="scss">
@import '@/addon/ai_humans/utils/styles/common.scss';
</style>