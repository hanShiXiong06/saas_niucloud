<template>
    <view :style="warpCss">
        <view class="pt-[34rpx] pb-[30rpx] member-info">
            <view v-if="info" class="flex ml-[32rpx] mr-[52rpx] items-center relative">
                <!-- 唤起获取微信 -->
                <u-avatar :src="img(info.headimg)" size="50" leftIcon="none" class="shadow-sm border-2 border-white/30"
                    :default-url="img('static/resource/images/default_headimg.png')" @click="clickAvatar" />
                <view class="ml-[22rpx]">
                    <view class="text-[#222222] flex pr-[50rpx] flex-wrap items-center">
                        <view class="text-[#222222] truncate max-w-[320rpx] font-bold text-[34rpx] mr-[16rpx]"
                            :style="{ color: diyComponent.textColor }">{{ info.nickname }}</view>
                    </view>
                    <view class="text-[#696B70] text-[24rpx] mt-[14rpx] opacity-80"
                        :style="{ color: diyComponent.textColor }">
                        UID：{{ info.member_no }}</view>
                </view>
                <view class="set-icon flex items-center absolute right-0 top-2">
                    <view @click="redirect({ url: '/app/pages/setting/index' })"
                        class="p-2 rounded-full hover:bg-black/5 active:bg-black/10 transition-all">
                        <text class="nc-iconfont nc-icon-shezhiV6xx-1 text-[40rpx]"
                            :style="{ color: diyComponent.textColor }"></text>
                    </view>
                </view>
            </view>
            <view v-else class="flex ml-[32rpx] mr-[52rpx] items-center relative">
                <u-avatar :src="img('static/resource/images/default_headimg.png')" size="50"
                    class="shadow-sm border-2 border-white/30" @click="toLogin" />
                <view class="ml-[22rpx]" @click="toLogin">
                    <view class="text-[#222222] font-bold text-[34rpx]" :style="{ color: diyComponent.textColor }">{{
                        t('login') }}/{{ t('register') }}</view>
                </view>
                <view class="set-icon flex items-center absolute right-0 top-2"
                    @click="redirect({ url: '/app/pages/setting/index' })">
                    <view class="p-2 rounded-full hover:bg-black/5 active:bg-black/10 transition-all">
                        <text class="nc-iconfont nc-icon-shezhiV6xx-1 text-[40rpx]"
                            :style="{ color: diyComponent.textColor }"></text>
                    </view>
                </view>
            </view>

            <view v-if="stat" @click="redirect({ url: '/addon/tk_partner/pages/partner/diy' })"
                class="stats-card flex justify-between mx-[32rpx] mt-[18rpx] bg-gradient-to-br from-white/20 to-white/10 rounded-2xl p-4 backdrop-blur-md shadow-md transition-all active:scale-98">
                <view class="flex flex-col items-center justify-center flex-1">
                    <view class="text-[24rpx] mb-2 opacity-90" :style="{ color: diyComponent.textColor }">店铺订单
                    </view>
                    <view class="text-[40rpx] font-bold animate-in" :style="{ color: diyComponent.textColor }">{{
                        stat.count || 0
                    }}</view>
                </view>
                <view class="h-12 w-px bg-white/30 self-center"></view>
                <view class="flex flex-col items-center justify-center flex-1">
                    <view class="text-[24rpx] mb-2 opacity-90" :style="{ color: diyComponent.textColor }">店铺销售额
                    </view>
                    <view class="text-[40rpx] font-bold animate-in" :style="{ color: diyComponent.textColor }">
                        ￥{{ stat.order_money.toFixed(2) || 0 }}</view>
                </view>
                <view class="h-12 w-px bg-white/30 self-center"></view>
                <view class="flex flex-col items-center justify-center flex-1">
                    <view class="text-[24rpx] mb-2 opacity-90" :style="{ color: diyComponent.textColor }">店铺利润
                    </view>
                    <view class="text-[40rpx] font-bold animate-in" :style="{ color: diyComponent.textColor }">
                        ￥{{ stat.commission.toFixed(2) || 0 }}</view>
                </view>
            </view>

            <view v-if="baseConfig && !is_partner" @click="redirect({ url: '/addon/tk_partner/pages/partner/apply' })"
                class="partner-btn w-[380rpx] mx-auto mt-[24rpx] flex justify-center items-center py-3 rounded-xl transition-all active:scale-98 relative overflow-hidden hover:translate-y-[-2rpx]"
                :style="partnerBtnStyle">
                <view class="circuit-pattern absolute inset-0 z-0 opacity-10"></view>
                <view class="btn-glow absolute"></view>
                <view class="flex items-center relative z-10">
                    <view class="icon-wrap mr-2">
                        <text class="nc-iconfont nc-icon-huangguan text-[32rpx]"
                            :style="{ color: diyComponent.textColor }"></text>
                    </view>
                    <text class="font-bold text-[30rpx] text-glow" :style="{ color: diyComponent.textColor }">成为{{
                        baseConfig.alias_name }}</text>
                </view>
                <view class="btn-particles"></view>
            </view>
        </view>

        <!-- #ifdef MP-WEIXIN -->
        <information-filling ref="infoFill"></information-filling>
        <!-- #endif -->

    </view>
</template>

<script lang="ts" setup>
import { computed, ref } from 'vue'
import useMemberStore from '@/stores/member'
import { useLogin } from '@/hooks/useLogin'
import { img, isWeixinBrowser, redirect, urlDeconstruction, moneyFormat, getToken } from '@/utils/common'
import { t } from '@/locale'
import { wechatSync } from '@/app/api/system'
import useDiyStore from '@/app/stores/diy'
import useConfigStore from '@/stores/config'
import { checkPartnerOpen } from '@/addon/tk_partner/api/partner'
import { getPartnerInfo, getStat } from '@/addon/tk_partner/api/partner'
const props = defineProps(['component', 'index', 'global']);
import { getConfig } from "@/addon/tk_partner/api/config";
const baseConfig = ref()
// 获取配置信息
getConfig().then((res: any) => {
    baseConfig.value = res.data;
});

const is_partner = ref(false)
const partnerInfo = ref()
const stat = ref()
checkPartnerOpen().then((res: any) => {
    if (res.data.type == 'success') {
        is_partner.value = true
        getPartnerInfo({ type: 'partner' }).then((res: any) => {
            partnerInfo.value = res.data
        })
        getStat().then((res: any) => {
            stat.value = res.data
        })
    }
})

const configStore = useConfigStore()
const diyStore = useDiyStore();

const diyComponent = computed(() => {
    if (diyStore.mode == 'decorate') {
        return diyStore.value[props.index];
    } else {
        return props.component;
    }
})

const partnerBtnStyle = computed(() => {
    let style = '';

    if (diyComponent.value.componentStartBgColor && diyComponent.value.componentEndBgColor) {
        style = `background: linear-gradient(to right, ${diyComponent.value.componentStartBgColor}, ${diyComponent.value.componentEndBgColor});`;
        style += `box-shadow: 0 5px 15px ${diyComponent.value.componentStartBgColor}50;`;
    } else if (diyComponent.value.componentStartBgColor) {
        style = `background-color: ${diyComponent.value.componentStartBgColor};`;
        style += `box-shadow: 0 5px 15px ${diyComponent.value.componentStartBgColor}50;`;
    } else {
        style = 'background: linear-gradient(45deg, var(--primary-400), var(--primary-500), var(--primary-600));';
        style += 'background-size: 200% 100%;';
        style += 'animation: gradient-shift 5s ease infinite;';
        style += 'box-shadow: 0 5px 15px rgba(var(--primary-rgb), 0.3);';
    }

    return style;
})

const warpCss = computed(() => {
    var style = '';
    if (diyComponent.value.componentStartBgColor) {
        if (diyComponent.value.componentStartBgColor && diyComponent.value.componentEndBgColor) style += `background:linear-gradient(${diyComponent.value.componentGradientAngle},${diyComponent.value.componentStartBgColor},${diyComponent.value.componentEndBgColor});`;
        else style += 'background-color:' + diyComponent.value.componentStartBgColor + ';';
    }
    if (diyComponent.value.bgUrl) {
        style += 'background-image:url(' + img(diyComponent.value.bgUrl) + ');';
        style += 'background-size: 100%;';
        style += 'background-repeat: no-repeat;';
    }
    if (diyComponent.value.topRounded) style += 'border-top-left-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
    if (diyComponent.value.topRounded) style += 'border-top-right-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
    if (diyComponent.value.bottomRounded) style += 'border-bottom-left-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
    if (diyComponent.value.bottomRounded) style += 'border-bottom-right-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';

    return style;
})

const memberStore = useMemberStore()

// #ifdef H5
const { query } = urlDeconstruction(location.href)
if (query.code && isWeixinBrowser() && getToken()) {
    wechatSync({ code: query.code }).then(res => {
        memberStore.getMemberInfo()
    })
}
// #endif

const info = computed(() => {
    // 装修模式
    if (diyStore.mode == 'decorate') {
        return {
            headimg: '',
            nickname: '昵称',
            balance: 0,
            point: 0,
            money: 0,
            member_no: 'NIU0000021'
        }
    } else {
        return memberStore.info;
    }
})

const money = computed(() => {
    if (info.value) {
        let m = parseFloat(info.value.balance) + parseFloat(info.value.money)
        return moneyFormat(m.toString());
    } else {
        return 0;
    }
})

const toLogin = () => {
    let normalLogin = !configStore.login.is_username && !configStore.login.is_mobile && !configStore.login.is_bind_mobile; // 未开启普通登录
    let authRegisterLogin = !configStore.login.is_auth_register; // 自动注册登录

    // #ifdef H5
    if (isWeixinBrowser()) {
        // 微信浏览器
        if (normalLogin && authRegisterLogin) {
            uni.showToast({ title: '商家未开启登录注册', icon: 'none' })
        } else if (configStore.login.is_username || configStore.login.is_mobile || configStore.login.is_bind_mobile) {
            useLogin().setLoginBack({ url: '/app/pages/member/index' })
        } else if (normalLogin && configStore.login.is_auth_register && configStore.login.is_force_access_user_info) {
            // 判断是否开启第三方自动注册登录，并且开启强制获取用户信息
            useLogin().getAuthCode({ scopes: 'snsapi_userinfo' })
        } else if (normalLogin && configStore.login.is_auth_register && !configStore.login.is_force_access_user_info) {
            // 判断是否开启第三方自动注册登录，并且关闭强制获取用户信息
            useLogin().getAuthCode({ scopes: 'snsapi_base' })
        }
    } else {
        // 普通浏览器
        if (normalLogin) {
            uni.showToast({ title: '商家未开启登录注册', icon: 'none' })
        } else if (configStore.login.is_username || configStore.login.is_mobile || configStore.login.is_bind_mobile) {
            useLogin().setLoginBack({ url: '/app/pages/member/index' })
        }
    }
    // #endif

    // #ifdef MP
    if (normalLogin && authRegisterLogin) {
        uni.showToast({ title: '商家未开启登录注册', icon: 'none' })
    } else if (configStore.login.is_username || configStore.login.is_mobile || configStore.login.is_bind_mobile) {
        useLogin().setLoginBack({ url: '/app/pages/member/index' })
    } else if (normalLogin && configStore.login.is_auth_register && !configStore.login.is_force_access_user_info) {
        // 判断是否开启第三方自动注册登录
        useLogin().getAuthCode()
    } else if (configStore.login.is_auth_register && configStore.login.is_force_access_user_info) {
        // 开启了第三方自动注册登录，但是需要强制获取昵称
        useLogin().setLoginBack({ url: '/app/pages/member/index' })
    } else if (configStore.login.is_auth_register && configStore.login.is_bind_mobile) {
        // 开启了第三方自动注册登录，但是需要强制获取手机号
        useLogin().setLoginBack({ url: '/app/pages/member/index' })
    }
    // #endif

}

const infoFill: any = ref(false)
const clickAvatar = () => {
    // #ifdef MP-WEIXIN
    infoFill.value.show = true
    // #endif

    // #ifdef H5
    if (isWeixinBrowser()) {
        useLogin().getAuthCode({ scopes: 'snsapi_userinfo' })
    } else {
        redirect({ url: '/app/pages/member/personal' })
    }
    // #endif
}
let menuButtonInfo: any = {};
// 如果是小程序，获取右上角胶囊的尺寸信息，避免导航栏右侧内容与胶囊重叠(支付宝小程序非本API，尚未兼容)
// #ifdef MP-WEIXIN || MP-BAIDU || MP-TOUTIAO || MP-QQ
menuButtonInfo = uni.getMenuButtonBoundingClientRect();
// #endif
</script>

<style lang="scss" scoped>
.member-info {
    padding-bottom: 20rpx;
}

.animate-in {
    animation: fadeInUp 0.6s ease-out forwards;
}

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(10px);
    }

    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.stats-card {
    position: relative;
    overflow: hidden;

    &::before {
        content: '';
        position: absolute;
        width: 200%;
        height: 200%;
        background: linear-gradient(to bottom right,
                rgba(255, 255, 255, 0.2) 0%,
                rgba(255, 255, 255, 0.05) 50%,
                transparent 100%);
        transform: rotate(30deg);
        z-index: -1;
    }
}

@keyframes shine {
    0% {
        left: -100%;
    }

    20% {
        left: 100%;
    }

    100% {
        left: 100%;
    }
}

@keyframes pulse {
    0% {
        transform: scale(1);
    }

    50% {
        transform: scale(1.02);
    }

    100% {
        transform: scale(1);
    }
}

.active\:scale-98:active {
    transform: scale(0.98);
}

.partner-btn {
    position: relative;
    overflow: hidden;
    animation: pulse-btn 2s infinite ease-in-out;
    transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.3s ease;
}

.partner-btn:hover {
    box-shadow: 0 10rpx 25rpx rgba(var(--primary-rgb), 0.4);
}

.text-glow {
    text-shadow: 0 0 8rpx rgba(255, 255, 255, 0.3);
}

.icon-wrap {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    animation: float-icon 3s ease-in-out infinite;
}

@keyframes float-icon {

    0%,
    100% {
        transform: translateY(0);
    }

    50% {
        transform: translateY(-3rpx);
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
    position: absolute;
}

.btn-particles {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    overflow: hidden;
}

.btn-particles::before,
.btn-particles::after {
    content: '';
    position: absolute;
    width: 8rpx;
    height: 8rpx;
    border-radius: 50%;
    background-color: rgba(255, 255, 255, 0.6);
    opacity: 0;
}

.btn-particles::before {
    top: 20%;
    left: 30%;
    animation: float-particles 3s infinite ease-in-out;
}

.btn-particles::after {
    top: 70%;
    left: 70%;
    animation: float-particles 3s 1s infinite ease-in-out;
}

@keyframes float-particles {
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
        transform: translate(100rpx, -60rpx) rotate(360deg);
        opacity: 0;
    }
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

.circuit-pattern {
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100' viewBox='0 0 100 100'%3E%3Cpath fill='none' stroke='rgba(255,255,255,0.15)' stroke-width='1' d='M10,10 L30,10 L30,30 L50,30 L50,50 L70,50 L70,70 L90,70 M10,90 L30,90 L30,70 L10,70 M50,90 L50,70 L70,70 M30,50 L10,50 M90,50 L70,50 M50,30 L50,10 M70,30 L90,30 M30,30 L30,50'/%3E%3C/svg%3E");
    background-size: 200rpx 200rpx;
}

@keyframes pulse-btn {
    0% {
        box-shadow: 0 0 0 0 rgba(var(--primary-rgb), 0.4);
    }

    50% {
        box-shadow: 0 0 15rpx 5rpx rgba(var(--primary-rgb), 0.2);
    }

    100% {
        box-shadow: 0 0 0 0 rgba(var(--primary-rgb), 0);
    }
}

@keyframes gradient-shift {
    0% {
        background-position: 0% 50%;
    }

    50% {
        background-position: 100% 50%;
    }

    100% {
        background-position: 0% 50%;
    }
}
</style>
