<template>
    <view class="bg-[var(--page-bg-color)] min-h-screen p-3" :style="themeColor">
        <!-- 加载中状态弹窗 -->
        <view v-if="loading" class="fixed inset-0 flex items-center justify-center z-50 bg-black/20 backdrop-blur-sm">
            <view class="bg-white/90 rounded-lg p-5 flex flex-col items-center w-[60%] shadow-lg">
                <view class="loading-spinner mb-3"></view>
                <text class="text-gray-700 text-center">{{ loadingText }}</text>
            </view>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { getToken, redirect, handleOnloadParams } from '@/utils/common';
import useConfigStore from '@/stores/config';
import { onLoad } from '@dcloudio/uni-app';
import { getQrcodeInfo } from '@/addon/tk_partner/api/partner';
import { useLogin } from "@/hooks/useLogin";

// 加载状态控制
const loading = ref(false);
const loadingText = ref('正在加载中...');

// 主题色样式
const themeColor = computed(() => useConfigStore().getThemeColor());

// 处理二维码逻辑的组合式函数
const useQrcodeHandler = () => {
    // 显示加载状态
    const showLoading = (text: string) => {
        loading.value = true;
        loadingText.value = text;
    };

    // 隐藏加载状态
    const hideLoading = () => {
        loading.value = false;
    };

    // 显示提示信息
    const showToast = (message: string) => {
        uni.showToast({
            title: message,
            icon: 'none'
        });
    };

    // 处理二维码信息
    const handleQrcode = async (code: string) => {
        try {
            showLoading('正在获取二维码信息...');
            const res = await getQrcodeInfo(code);
            showLoading('正在跳转...');
            // 使用类型断言
            const data = (res as any).data;
            redirect({ url: data.page, mode: 'reLaunch' });
        } catch (error) {
            hideLoading();
            showToast('获取信息失败');
            console.error('二维码处理错误:', error);
        }
    };

    // 处理页面加载
    const handlePageLoad = (option: any) => {
        option = handleOnloadParams(option);
        showLoading('正在加载中...');

        // 获取 code 参数，先尝试从参数中获取，如果没有则从 localStorage 中获取
        const qrcode = option?.code || uni.getStorageSync('qrcode_param');

        // 如果有 code 参数，保存到 localStorage 中
        if (option?.code) {
            uni.setStorageSync('qrcode_param', option.code);
        }

        // 检查登录状态
        if (!getToken()) {
            const login = useLogin();
            // 第三方平台自动登录
            // #ifdef MP
            login.getAuthCode();
            // #endif
            // #ifdef H5
            login.setLoginBack({ url: '/addon/tk_partner/pages/qrcode/index' });
            return;
            // #endif
        }

        // 处理二维码参数
        if (qrcode) {
            // 使用二维码参数
            handleQrcode(qrcode);
            // 使用后清除存储的参数
            uni.removeStorageSync('qrcode_param');
        } else {
            hideLoading();
            showToast('扫描参数异常');
        }
    };

    return {
        handlePageLoad
    };
};

// 初始化并使用二维码处理逻辑
const { handlePageLoad } = useQrcodeHandler();

// 页面加载时处理
onLoad(handlePageLoad);
</script>

<style lang="scss" scoped>
@import '@/addon/tk_partner/utils/styles/common.scss';

/* 加载动画样式 */
.loading-spinner {
    width: 40rpx;
    height: 40rpx;
    border: 4rpx solid var(--primary-color, #5A6BF6);
    border-top-color: transparent;
    border-radius: 50%;
    animation: spin 1s linear infinite;
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