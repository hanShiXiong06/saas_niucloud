<template>
    <view class="bg-[var(--page-bg-color)] min-h-screen p-3" :style="themeColor()">

        <!-- 高级背景效果 -->
        <view class="absolute top-0 left-0 w-full h-full z-0 opacity-30">
            <view class="circuit-pattern"></view>
        </view>

        <!-- 背景光晕装饰 -->
        <view
            class="absolute top-[-10%] left-[-10%] w-[500rpx] h-[500rpx] rounded-full bg-gradient-to-r from-[var(--primary-color)] to-purple-600 opacity-10 blur-3xl">
        </view>
        <view
            class="absolute bottom-[10%] right-[-15%] w-[600rpx] h-[600rpx] rounded-full bg-gradient-to-r from-blue-500 to-[var(--primary-color)] opacity-15 blur-3xl">
        </view>
        <view
            class="absolute top-[40%] left-[50%] w-[400rpx] h-[400rpx] rounded-full bg-gradient-to-r from-purple-400 to-indigo-600 opacity-10 blur-3xl">
        </view>

        <!-- 网格背景 -->
        <view class="grid-bg absolute top-0 left-0 w-full h-full opacity-[0.1]"></view>

        <!-- 动态粒子 -->
        <view class="particles absolute top-0 left-0 w-full h-full"></view>

        <!-- 浮动光点 -->
        <view class="floating-dots"></view>

        <!-- 顶部装饰栏 -->
        <view
            class="absolute top-0 left-0 w-full h-[8rpx] bg-gradient-to-r from-transparent via-[var(--primary-color)] to-transparent opacity-70">
        </view>

        <!-- 标题区域 -->
        <view class="relative pt-[100rpx] px-[40rpx] z-10">
            <!-- 3D文字效果 -->
            <view class="relative">
                <text
                    class="text-white/20 text-[56rpx] font-bold absolute top-[4rpx] left-[4rpx] tracking-wider">卡密兑换</text>
                <view class="text-white text-[56rpx] font-bold tracking-wider flex items-center relative">
                    <text class=" text-[var(--primary-color)]">卡密兑换</text>
                    <view class="ml-3 h-[16rpx] w-[16rpx] bg-[var(--primary-color)] rounded-full pulse-anim"></view>
                </view>
            </view>

            <view class="text-gray-400 text-[28rpx] mt-4 tracking-wide max-w-[75%] ml-[4rpx]">
                输入卡密，快速兑换
            </view>

            <!-- 标题装饰线 -->
            <view
                class="w-[120rpx] h-[4rpx] bg-gradient-to-r from-[var(--primary-color)] to-transparent mt-[20rpx] mb-[30rpx]">
            </view>
        </view>

        <!-- 主卡片 -->
        <view class="px-[40rpx] mt-[40rpx] relative z-10">
            <view class="card-blur rounded-[30rpx] overflow-hidden backdrop-blur-xl relative border border-white/10">
                <!-- 卡片背景光效 -->
                <view
                    class="absolute top-0 left-0 w-full h-full bg-gradient-to-br from-white/[0.05] to-transparent z-0">
                </view>
                <view
                    class="absolute -top-[150rpx] -right-[150rpx] w-[300rpx] h-[300rpx] rounded-full bg-[var(--primary-color)]/10 blur-3xl">
                </view>

                <!-- 卡片内边框装饰 -->
                <view
                    class="absolute top-[10rpx] left-[10rpx] right-[10rpx] bottom-[10rpx] border border-white/[0.08] rounded-[24rpx] z-0">
                </view>

                <!-- 卡片内容 -->
                <view class="relative z-10 p-[50rpx]">
                    <!-- 闪光点装饰 -->
                    <view
                        class="absolute top-[30rpx] right-[30rpx] w-[8rpx] h-[8rpx] rounded-full bg-[var(--primary-color)] shine-anim">
                    </view>
                    <view
                        class="absolute top-[50rpx] right-[60rpx] w-[5rpx] h-[5rpx] rounded-full bg-blue-400 shine-anim-delayed">
                    </view>

                    <!-- 输入框区域 -->
                    <view class="mt-[30rpx] relative">
                        <!-- 输入框外部装饰 -->
                        <view class="absolute -top-[40rpx] -left-[30rpx] tech-dots"></view>

                        <view class="relative mb-[60rpx]">
                            <!-- 输入框背景装饰 -->
                            <view
                                class="absolute -top-[15rpx] -left-[15rpx] w-[40rpx] h-[40rpx] border-t-2 border-l-2 border-[var(--primary-color)]/70 rounded-tl-[12rpx]">
                            </view>
                            <view
                                class="absolute -bottom-[15rpx] -right-[15rpx] w-[40rpx] h-[40rpx] border-b-2 border-r-2 border-[var(--primary-color)]/70 rounded-br-[12rpx]">
                            </view>
                            <view
                                class="absolute -top-[15rpx] -right-[15rpx] w-[15rpx] h-[15rpx] border-t-2 border-r-2 border-[var(--primary-color)]/40 rounded-tr-[6rpx]">
                            </view>
                            <view
                                class="absolute -bottom-[15rpx] -left-[15rpx] w-[15rpx] h-[15rpx] border-b-2 border-l-2 border-[var(--primary-color)]/40 rounded-bl-[6rpx]">
                            </view>
                            <!-- 输入框 -->
                            <view class="input-wrapper relative">
                                <input class="p-2 rounded-md text-[var(--primary-color)]" v-model="cardNum"
                                    placeholder="请输入有效兑换码" />

                            </view>
                        </view>

                        <!-- 提交按钮 -->
                        <view class="mt-[50rpx]">
                            <u-button @click="submit"
                                class="h-[120rpx] rounded-[32rpx] flex items-center justify-center relative overflow-hidden"
                                :customStyle="{
                                    background: 'linear-gradient(135deg, var(--primary-color), var(--primary-color))',
                                    color: '#ffffff',
                                    border: 'none'
                                }">
                                <view class="btn-glow absolute"></view>
                                <!-- 按钮装饰 -->
                                <view class="relative z-10 flex items-center justify-center">
                                    <text class="i-carbon-send-alt text-[36rpx] mr-3"></text>
                                    <text class="text-[34rpx] font-bold tracking-wider">立即激活</text>
                                </view>
                            </u-button>
                        </view>
                    </view>
                </view>
            </view>

            <!-- 卡密说明 -->
            <view class="mt-[50rpx] px-[20rpx]">
                <view class="flex items-center text-white/90 text-[28rpx] font-medium mb-[20rpx]">
                    <text class="i-carbon-information text-[var(--primary-color)] mr-3 text-[32rpx]"></text>
                    <text class="text-[var(--primary-color)]">使用说明</text>
                </view>
                <view class="text-[var(--primary-color-light)] text-[24rpx] leading-[1.8]">
                    <view class="mb-[16rpx] flex items-start">
                        <view class="w-[6rpx] h-[6rpx] text-[var(--primary-color)] rounded-full mt-[14rpx] mr-[12rpx]">
                        </view>
                        <text class="text-gray-400">卡密一经激活，立即生效</text>
                    </view>
                    <view class="mb-[16rpx] flex items-start">
                        <view class="w-[6rpx] h-[6rpx] text-[var(--primary-color)] rounded-full mt-[14rpx] mr-[12rpx]">
                        </view>
                        <text class="text-gray-400">激活后无法退换不可重复使用</text>
                    </view>
                    <view class="flex items-start">
                        <view class="w-[6rpx] h-[6rpx] text-[var(--primary-color)] rounded-full mt-[14rpx] mr-[12rpx]">
                        </view>
                        <text class="text-gray-400">如遇问题，请联系在线客服</text>
                    </view>
                </view>
            </view>

            <!-- 底部装饰线 -->
            <view class="my-[50rpx] w-full h-[1rpx] bg-gradient-to-r from-transparent via-white/20 to-transparent">
            </view>
        </view>

        <!-- 底部导航 -->
        <view class="mt-[20rpx] mb-[30rpx]">
            <tabbar addon="tk_partner" />
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { img, redirect } from '@/utils/common';
import { verifyCardNum } from '@/addon/tk_partner/api/card';
import useConfigStore from '@/stores/config';
import { onLoad, onPageScroll, onReachBottom } from '@dcloudio/uni-app';
import Tabbar from '@/components/tabbar/tabbar.vue';
const cardNum = ref('');
const configStore = useConfigStore();
const submit = () => {
    if (!cardNum.value) {
        uni.showToast({
            title: '请输入卡密码',
            icon: 'none'
        });
        return;
    }

    verifyCardNum(cardNum.value).then(res => {
        uni.showToast({
            title: '激活成功',
            icon: 'success'
        });
        cardNum.value = '';
        redirect({ url: "/addon/tk_partner/pages/partner/diy" });
    }).catch(err => {
        uni.showToast({
            title: err.msg || '激活失败',
            icon: 'none'
        });
    });
};
</script>

<style lang="scss" scoped>
@import '@/addon/tk_partner/utils/styles/common.scss';

.text-gradient {
    background: linear-gradient(to right, #ffffff, #a2a8ff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    text-fill-color: transparent;
}

.grid-bg {
    background-size: 40rpx 40rpx;
    background-image:
        linear-gradient(to right, rgba(255, 255, 255, 0.05) 1rpx, transparent 1rpx),
        linear-gradient(to bottom, rgba(255, 255, 255, 0.05) 1rpx, transparent 1rpx);
}

.particles {
    background-image:
        radial-gradient(rgba(255, 255, 255, 0.15) 2rpx, transparent 2rpx),
        radial-gradient(rgba(255, 255, 255, 0.1) 1rpx, transparent 1rpx);
    background-size: 60rpx 60rpx, 30rpx 30rpx;
    background-position: 0 0, 15rpx 15rpx;
}

.floating-dots {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    opacity: 0.5;
    z-index: 1;
    pointer-events: none;

    &::before,
    &::after {
        content: '';
        position: absolute;
        width: 8rpx;
        height: 8rpx;
        border-radius: 50%;
        background-color: rgba(var(--primary-color-rgb), 0.6);
        animation: float-dots 15s infinite ease-in-out;
        opacity: 0;
    }

    &::before {
        top: 20%;
        left: 30%;
        animation-delay: 0s;
    }

    &::after {
        top: 70%;
        left: 70%;
        animation-delay: 5s;
    }
}

@keyframes float-dots {
    0% {
        transform: translate(0, 0);
        opacity: 0;
    }

    20% {
        opacity: 1;
    }

    80% {
        opacity: 1;
    }

    100% {
        transform: translate(300rpx, -200rpx) rotate(360deg);
        opacity: 0;
    }
}

.circuit-pattern {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 100 100'%3E%3Cpath fill='none' stroke='rgba(255,255,255,0.05)' stroke-width='1' d='M10,10 L30,10 L30,30 L50,30 L50,50 L70,50 L70,70 L90,70 M10,90 L30,90 L30,70 L10,70 M50,90 L50,70 L70,70 M30,50 L10,50 M90,50 L70,50 M50,30 L50,10 M70,30 L90,30 M30,30 L30,50'/%3E%3C/svg%3E");
    background-size: 200rpx 200rpx;
}

.card-blur {
    position: relative;
    box-shadow: 0 8rpx 10rpx rgba(0, 0, 0, 0.3);
}

.tech-circle {
    border: 1rpx dashed rgba(var(--primary-color-rgb), 0.3);
    border-radius: 50%;
    animation: rotate 20s linear infinite;

    &::before,
    &::after {
        content: '';
        position: absolute;
        border-radius: 50%;
    }

    &::before {
        top: 10rpx;
        left: 10rpx;
        right: 10rpx;
        bottom: 10rpx;
        border: 1rpx dashed rgba(var(--primary-color-rgb), 0.3);
        animation: rotate 15s linear infinite reverse;
    }

    &::after {
        top: 40rpx;
        left: 40rpx;
        right: 40rpx;
        bottom: 40rpx;
        border: 1rpx solid rgba(var(--primary-color-rgb), 0.2);
    }
}

.tech-dots {
    width: 60rpx;
    height: 60rpx;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: repeat(3, 1fr);
    gap: 8rpx;

    &::before {
        content: '';
        grid-column: 1 / span 3;
        grid-row: 1 / span 3;
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        grid-template-rows: repeat(3, 1fr);
        gap: 8rpx;
    }

    &::after {
        content: '';
        width: 4rpx;
        height: 4rpx;
        background-color: rgba(var(--primary-color-rgb), 0.6);
        border-radius: 50%;
        grid-column: 1;
        grid-row: 1;
    }
}

.input-wrapper {
    position: relative;

    .input-field {
        transition: all 0.3s ease;

        &:focus-within {
            border-color: rgba(var(--primary-color-rgb), 0.5);
            box-shadow: 0 0 15rpx rgba(var(--primary-color-rgb), 0.3);
            background-color: rgba(15, 23, 42, 0.8) !important;
        }
    }

    .input-glow {
        position: absolute;
        bottom: -2rpx;
        left: 15%;
        width: 70%;
        height: 10rpx;
        background: radial-gradient(ellipse at center, rgba(var(--primary-color-rgb), 0.4) 0%, transparent 70%);
        filter: blur(5rpx);
        opacity: 0.7;
        z-index: -1;
    }
}

.icon-container {
    position: relative;

    &::after {
        content: '';
        position: absolute;
        bottom: -8rpx;
        left: 15rpx;
        width: 60rpx;
        height: 8rpx;
        background: radial-gradient(ellipse at center, rgba(var(--primary-color-rgb), 0.4) 0%, transparent 70%);
        filter: blur(3rpx);
    }
}

.cyber-button {
    position: relative;
    overflow: hidden;
    transition: all 0.3s;
    box-shadow: 0 8rpx 30rpx rgba(var(--primary-color-rgb), 0.3);

    &:active {
        transform: translateY(2rpx);
        box-shadow: 0 4rpx 15rpx rgba(var(--primary-color-rgb), 0.2);
    }
}

.btn-glow {
    width: 40rpx;
    height: 400rpx;
    background: rgba(255, 255, 255, 0.3);
    transform: rotate(35deg);
    left: -100rpx;
    top: -150rpx;
    transition: all 0.3s;
    animation: btn-shine 3s infinite ease-in-out;
}

@keyframes btn-shine {
    0% {
        left: -100rpx;
    }

    30% {
        left: 150%;
    }

    100% {
        left: 150%;
    }
}

@keyframes rotate {
    from {
        transform: rotate(0deg);
    }

    to {
        transform: rotate(360deg);
    }
}

.pulse-anim {
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0% {
        box-shadow: 0 0 0 0 rgba(var(--primary-color-rgb), 0.6);
    }

    70% {
        box-shadow: 0 0 0 15rpx rgba(var(--primary-color-rgb), 0);
    }

    100% {
        box-shadow: 0 0 0 0 rgba(var(--primary-color-rgb), 0);
    }
}

.shine-anim {
    animation: shine 4s infinite;
}

.shine-anim-delayed {
    animation: shine 4s infinite 2s;
}

@keyframes shine {
    0% {
        opacity: 0.3;
        box-shadow: 0 0 0 0 rgba(var(--primary-color-rgb), 0.5);
    }

    50% {
        opacity: 1;
        box-shadow: 0 0 20rpx 2rpx rgba(var(--primary-color-rgb), 0.7);
    }

    100% {
        opacity: 0.3;
        box-shadow: 0 0 0 0 rgba(var(--primary-color-rgb), 0.5);
    }
}
</style>