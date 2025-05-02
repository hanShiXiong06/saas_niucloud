<template>
    <view class="bg-[var(--page-bg-color)] min-h-screen p-2" :style="themeColor()">

        <view class="rounded-[8rpx]">
            <u-parse :content="config.content"
                :tagStyle="{ img: 'vertical-align: top;', p: 'overflow: hidden;word-break:break-word;' }"></u-parse>
        </view>
        <view class="h-22"></view>
        <view class="w-full footer bg-[var(--page-bg-color)]">
            <view
                class="py-[var(--top-m)] px-[var(--sidebar-m)] footer w-full fixed bottom-0 left-0 right-0 box-border bg-[var(--page-bg-color)]">
                <view class="flex items-center ml-4">
                    <checkbox-group class="flex items-center uni-list" @change="checkboxChange">
                        <u-checkbox v-model="isOpenAgreement" shape="circle" :name="true" size="22"
                            activeColor="var(--primary-color)" @change="checkboxChange"></u-checkbox>
                        <view
                            class="text-[var(--primary-color-light)] hover:text-gray-500 active:text-gray-600 inline-flex items-center  text-[24rpx]"
                            role="button" tabindex="0">
                            阅读并同意

                            <span @click="
                                redirect({
                                    url: '/app/pages/auth/agreement?key=ai_humans_service',
                                })" class="text-[24rpx]"
                                style="background: linear-gradient(to right, var(--primary-color), var(--primary-help-color)); -webkit-background-clip: text; color: transparent;">
                                《{{ config.name + "服务协议" }}》
                            </span>
                        </view>
                    </checkbox-group>
                </view>
                <view class="ml-4 mr-4 mt-2">
                    <button hover-class="none"
                        class="h-[80rpx] leading-[80rpx] rounded-[24rpx] text-[26rpx] font-500 text-[var(--primary-color-light2)] w-full"
                        :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color))' }"
                        @click="submit()">支付{{ config?.apply_price }}元成为{{ config.name }}</button>

                </view>
            </view>
        </view>

        <!-- 悬浮按钮 -->
        <view class="float-btn" @click="showFenxiaoDetail = true">
            <u-icon name="info-circle" color="var(--primary-color-light2)" size="26"></u-icon>
        </view>

        <!-- 分销详情弹窗 -->
        <u-popup :show="showFenxiaoDetail" @close="showFenxiaoDetail = false" mode="center" borderRadius="24"
            width="50%" class="rounded-xl overflow-hidden">
            <view class="p-4">
                <view class="text-center text-lg font-bold mb-3">{{ config.name }}分成详情</view>
                <view class="text-sm text-gray-600 mb-3">
                    <view class="mb-2">· 一级比例：{{ config.first_rate || '0' }}%</view>
                    <view class="mb-2">· 二级比例：{{ config.second_rate || '0' }}%</view>
                    <view class="mb-2" v-if="config.is_self == 1">· 自购比例：{{ config.self_rate || '0' }}%</view>
                    <view class="mb-2" v-if="config.min_withdrawal">· 最低提现金额：{{ config.min_withdrawal }}元</view>
                    <view>{{ config.fenxiao_detail || '成为' + config.name + '，您可以获得推广用户消费的佣金奖励。' }}{{ config.is_self == 1
                        ? '自购消费的奖励。' : '' }}</view>
                </view>
                <button @click="showFenxiaoDetail = false"
                    class="w-full h-10 rounded-full text-sm font-medium text-white text-center flex justify-center items-center"
                    :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color))' }">
                    我知道了
                </button>
            </view>
        </u-popup>
        <pay ref="payRef" @close="payLoading = false"></pay>
    </view>
    <!-- #ifdef MP-WEIXIN -->
    <!-- 小程序隐私协议 -->
    <wx-privacy-popup ref="wxPrivacyPopupRef"></wx-privacy-popup>
    <!-- #endif -->
</template>

<script setup lang="ts">
import { ref, reactive, onUnmounted } from "vue";
import { img, copy, redirect } from "@/utils/common";
import { getFenxiaoConfig } from "@/addon/ai_humans/api/config";
import { onLoad, onPageScroll, onReachBottom } from "@dcloudio/uni-app";
import { checkIsFenxiao, createFenxiaoOrder } from "@/addon/ai_humans/api/fenxiao";
const config = ref<any>({});
const isOpenAgreement = ref<boolean>(false);
const showFenxiaoDetail = ref<boolean>(false);

getFenxiaoConfig().then((res) => {
    config.value = res.data;
    if (config.value.is_open_fenxiao == 0) {
        uni.$u.toast('分销功能未开启');
        setTimeout(() => {
            uni.navigateBack();
        }, 1000);
        return;
    }
    checkIsFenxiaoEvent();
})
const checkIsFenxiaoEvent = () => {
    checkIsFenxiao().then((res) => {
        if (res.data.type == 'redirect') {
            redirect({ url: res.data.url });
        }
    })
}
const checkboxChange = (e: any) => {
    isOpenAgreement.value = e;
}
const payRef = ref(null)
const payLoading = ref(false)
const submit = async () => {
    if (!isOpenAgreement.value) {
        uni.$u.toast('请先阅读并同意协议');
        return;
    }
    const res = await createFenxiaoOrder();
    if (res.data.type == 'success') {
        redirect({ url: '/addon/ai_humans/pages/fenxiao/index' });
        uni.$u.toast('申请成功');
        return;
    }
    payLoading.value = true;
    payRef.value?.open(res.data.trade_type, res.data.trade_id, '/addon/ai_humans/pages/fenxiao/index');
}
</script>

<style lang="scss">
@import "@/addon/ai_humans/utils/styles/common.scss";

.float-btn {
    position: fixed;
    right: 30rpx;
    bottom: 240rpx;
    width: 90rpx;
    height: 90rpx;
    border-radius: 50%;
    background: linear-gradient(to right, var(--primary-color-light), var(--primary-color-light));
    display: flex;
    justify-content: center;
    align-items: center;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    z-index: 999;
}

/* 弹窗样式优化 */
:deep(.u-popup) {
    border-radius: 24rpx !important;
    overflow: hidden;
}

:deep(.u-popup__content) {
    border-radius: 24rpx !important;
}
</style>
