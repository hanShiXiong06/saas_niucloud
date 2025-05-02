<template>
    <view :style="warpCss">
        <view :style="maskLayer"></view>
        <view class="tk-card" v-if="diyStore.mode == 'decorate'"
            :style="{ padding: diyComponent.padding * 2 + 'rpx', background: diyComponent.background, borderRadius: diyComponent.radiussize * 2 + 'rpx' }">
            <view class="relative overflow-hidden">
                <!-- 背景纹理 -->
                <view class="absolute inset-0 opacity-10">
                    <view class="absolute inset-0"
                        style="background-image: radial-gradient(circle at 1px 1px, #fff 1px, transparent 0); background-size: 20px 20px;">
                    </view>
                </view>

                <!-- 店主信息 -->
                <view class="flex items-center mb-2 relative z-10">
                    <view class="relative">
                        <image class="w-[120rpx] h-[120rpx] rounded-full mr-2 border-2 border-white/30 shadow-lg"
                            :src="img('static/resource/images/default_headimg.png')" mode="aspectFill">
                        </image>
                    </view>
                    <view class="flex-1">
                        <view class="flex items-center justify-between">
                            <view class="flex items-center">
                                <view class="text-white text-[32rpx] font-medium"
                                    :style="{ color: diyComponent.textcolor }">
                                    {{ '店铺名称' }}</view>
                                <view
                                    class="ml-2 px-2 py-0.5 bg-white/20 rounded-md text-xs text-white/90 backdrop-blur-sm"
                                    :style="{ color: diyComponent.textcolor }">
                                    ID: {{ '--' }}
                                </view>
                            </view>
                            <view class="text-xs px-3 py-0.5 rounded-full inline-flex items-center"
                                :style="{ background: diyComponent.buttoncolor }">
                                <text class="text-amber-300 font-medium text-[28rpx] p-1"
                                    :style="{ color: diyComponent.textcolor }">{{
                                        '店主'
                                    }}</text>
                            </view>
                        </view>

                        <view class="mt-3 flex items-center flex-wrap gap-2 justify-between">
                            <view class="flex items-center">
                                <text class="text-white text-[24rpx]"
                                    :style="{ color: diyComponent.textcolor }">邀请码：</text>
                                <text class="text-white font-medium text-[28rpx] mr-1"
                                    :style="{ color: diyComponent.textcolor }">{{ '------------'
                                    }}</text>
                                <view class="ml-2 bg-white/10 rounded flex items-center justify-center">
                                    <text class="iconfont icon-copy text-white text-xs"
                                        :style="{ color: diyComponent.textcolor }">复制</text>
                                </view>
                            </view>
                            <view class="flex items-center bg-white/10 rounded-full px-2 py-1"
                                @click="redirect({ url: '/addon/tk_partner/pages/partner/share' })">
                                <view>
                                    <u-icon name="share-square" size="22" :color="diyComponent.textcolor"></u-icon>
                                </view>
                                <view class="text-white text-[28rpx] ml-1" :style="{ color: diyComponent.textcolor }">分享
                                </view>
                            </view>
                        </view>
                    </view>
                </view>

                <!-- 数据统计 -->
                <view class="flex justify-between bg-white/10 rounded-xl p-3 backdrop-blur-sm" v-if="stat">
                    <view class="flex flex-col items-center justify-center flex-1">
                        <view class="text-[26rpx] text-white/80 mb-1" :style="{ color: diyComponent.textcolor }">店铺订单
                        </view>
                        <view class="text-[36rpx] font-medium text-white" :style="{ color: diyComponent.textcolor }">{{
                            888
                            }}</view>
                    </view>
                    <view class="h-10 w-px bg-white/20 self-center"></view>
                    <view class="flex flex-col items-center justify-center flex-1">
                        <view class="text-[26rpx] text-white/80 mb-1" :style="{ color: diyComponent.textcolor }">店铺销售额
                        </view>
                        <view class="text-[36rpx] font-medium text-white" :style="{ color: diyComponent.textcolor }">
                            ￥888</view>
                    </view>
                    <view class="h-10 w-px bg-white/20 self-center"></view>
                    <view class="flex flex-col items-center justify-center flex-1">
                        <view class="text-[26rpx] text-white/80 mb-1" :style="{ color: diyComponent.textcolor }">店铺利润
                        </view>
                        <view class="text-[36rpx] font-medium text-white" :style="{ color: diyComponent.textcolor }">
                            ￥888</view>
                    </view>
                </view>
            </view>
        </view>

        <view class="tk-card" v-else
            :style="{ padding: diyComponent.padding * 2 + 'rpx', background: diyComponent.background, borderRadius: diyComponent.radiussize * 2 + 'rpx' }">
            <view class="relative overflow-hidden" v-if="partnerInfo">
                <!-- 背景纹理 -->
                <view class="absolute inset-0 opacity-10 pointer-events-none">
                    <view class="absolute inset-0"
                        style="background-image: radial-gradient(circle at 1px 1px, #fff 1px, transparent 0); background-size: 20px 20px;">
                    </view>
                </view>

                <!-- 店主信息 -->
                <view class="flex items-center mb-2 relative z-10">
                    <view class="relative" @click="redirect({ url: '/addon/tk_partner/pages/partner/manage' })">
                        <image class="w-[120rpx] h-[120rpx] rounded-full mr-2 border-2 border-white/30 shadow-lg"
                            :src="img(partnerInfo.logo && partnerInfo.logo.length > 0 ? partnerInfo.logo[0] : 'static/resource/images/default_headimg.png')"
                            mode="aspectFill">
                        </image>
                    </view>
                    <view class="flex-1">
                        <view class="flex items-center justify-between"
                            @click="redirect({ url: '/addon/tk_partner/pages/partner/manage' })">
                            <view class="flex items-center">
                                <view class="text-white text-[32rpx] font-medium"
                                    :style="{ color: diyComponent.textcolor }">
                                    {{ partnerInfo.name || '店铺名称' }}</view>
                                <view
                                    class="ml-2 px-2 py-0.5 bg-white/20 rounded-md text-xs text-white/90 backdrop-blur-sm"
                                    :style="{ color: diyComponent.textcolor }">
                                    ID: {{ partnerInfo.member_id || '-' }}
                                </view>
                            </view>
                            <view class="text-xs px-3 py-0.5 rounded-full inline-flex items-center"
                                :style="{ background: diyComponent.buttoncolor }">
                                <text class="text-amber-300 font-medium text-[28rpx] p-1"
                                    :style="{ color: diyComponent.textcolor }">{{
                                        partnerInfo.level_id_name || '店主'
                                    }}</text>
                            </view>
                        </view>

                        <view class="mt-3 flex items-center flex-wrap gap-2 justify-between">
                            <view class="flex items-center">
                                <text class="text-white text-[24rpx]"
                                    :style="{ color: diyComponent.textcolor }">邀请码：</text>
                                <text class="text-white font-medium text-[28rpx] mr-1"
                                    :style="{ color: diyComponent.textcolor }">{{ partnerInfo.share_code || '--'
                                    }}</text>
                                <view class="ml-2 bg-white/10 rounded flex items-center justify-center"
                                    @click="copyEvent(partnerInfo.share_code)">
                                    <text class="iconfont icon-copy text-white text-xs"
                                        :style="{ color: diyComponent.textcolor }">复制</text>
                                </view>
                            </view>
                            <view class="flex items-center bg-white/10 rounded-full px-2 py-1"
                                @click="redirect({ url: '/addon/tk_partner/pages/partner/share' })">
                                <view>
                                    <u-icon name="share-square" size="22" :color="diyComponent.textcolor"></u-icon>
                                </view>
                                <view class="text-white text-[28rpx] ml-1" :style="{ color: diyComponent.textcolor }">分享
                                </view>
                            </view>
                        </view>
                    </view>
                </view>

                <!-- 数据统计 -->
                <view @click="redirect({ url: '/addon/tk_partner/pages/partner/order' })"
                    class="flex justify-between bg-white/10 rounded-xl p-3 backdrop-blur-sm" v-if="stat">
                    <view class="flex flex-col items-center justify-center flex-1">
                        <view class="text-[26rpx] text-white/80 mb-1" :style="{ color: diyComponent.textcolor }">店铺订单
                        </view>
                        <view class="text-[36rpx] font-medium text-white" :style="{ color: diyComponent.textcolor }">{{
                            stat.count || 0
                            }}</view>
                    </view>
                    <view class="h-10 w-px bg-white/20 self-center"></view>
                    <view class="flex flex-col items-center justify-center flex-1">
                        <view class="text-[26rpx] text-white/80 mb-1" :style="{ color: diyComponent.textcolor }">店铺销售额
                        </view>
                        <view class="text-[36rpx] font-medium text-white" :style="{ color: diyComponent.textcolor }">
                            ￥{{ stat.order_money.toFixed(2) || 0 }}</view>
                    </view>
                    <view class="h-10 w-px bg-white/20 self-center"></view>
                    <view class="flex flex-col items-center justify-center flex-1">
                        <view class="text-[26rpx] text-white/80 mb-1" :style="{ color: diyComponent.textcolor }">店铺利润
                        </view>
                        <view class="text-[36rpx] font-medium text-white" :style="{ color: diyComponent.textcolor }">
                            ￥{{ stat.commission.toFixed(2) || 0 }}</view>
                    </view>
                </view>
            </view>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, nextTick, getCurrentInstance } from 'vue';
import useDiyStore from '@/app/stores/diy';
import { img, copy, redirect } from '@/utils/common';
import { getPartnerInfo, getStat } from '@/addon/tk_partner/api/partner';
const copyEvent = (value: any) => {
    copy(value, () => {
        uni.showToast({
            title: '邀请码复制成功',
            icon: 'none'
        });
    })
}
const partnerInfo = ref()
getPartnerInfo({ type: 'partner' }).then((res: any) => {
    partnerInfo.value = res.data
})
const stat = ref()
getStat().then((res: any) => {
    stat.value = res.data
})
const props = defineProps(['component', 'index', 'pullDownRefreshCount']);
const diyStore = useDiyStore();
const diyComponent = computed(() => {
    if (diyStore.mode == 'decorate') {
        return diyStore.value[props.index];
    } else {
        return props.component;
    }
})

const warpCss = computed(() => {
    var style = '';
    style += 'position:relative;';
    if (diyComponent.value.componentStartBgColor) {
        if (diyComponent.value.componentStartBgColor && diyComponent.value.componentEndBgColor) style += `background:linear-gradient(${diyComponent.value.componentGradientAngle},${diyComponent.value.componentStartBgColor},${diyComponent.value.componentEndBgColor});`;
        else style += 'background-color:' + diyComponent.value.componentStartBgColor + ';';
    }

    if (diyComponent.value.componentBgUrl) {
        style += `background-image:url('${img(diyComponent.value.componentBgUrl)}');`;
        style += 'background-size: cover;background-repeat: no-repeat;';
    }

    if (diyComponent.value.topRounded) style += 'border-top-left-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
    if (diyComponent.value.topRounded) style += 'border-top-right-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
    if (diyComponent.value.bottomRounded) style += 'border-bottom-left-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
    if (diyComponent.value.bottomRounded) style += 'border-bottom-right-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
    return style;
})

// 背景图加遮罩层
const maskLayer = computed(() => {
    var style = '';
    if (diyComponent.value.componentBgUrl) {
        style += 'position:absolute;top:0;width:100%;';
        style += `background: rgba(0,0,0,${diyComponent.value.componentBgAlpha / 10});`;
        style += `height:${height.value}px;`;

        if (diyComponent.value.topRounded) style += 'border-top-left-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
        if (diyComponent.value.topRounded) style += 'border-top-right-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
        if (diyComponent.value.bottomRounded) style += 'border-bottom-left-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
        if (diyComponent.value.bottomRounded) style += 'border-bottom-right-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
    }

    return style;
});

watch(
    () => props.pullDownRefreshCount,
    (newValue, oldValue) => {
        // 处理下拉刷新业务
    }
)

onMounted(() => {
    refresh();
    // 装修模式下刷新
    if (diyStore.mode == 'decorate') {
        watch(
            () => diyComponent.value,
            (newValue, oldValue) => {
                if (newValue && newValue.componentName == 'RichText') {
                    refresh();
                }
            }
        )
    }
});

const instance = getCurrentInstance();
const height = ref(0)

const refresh = () => {
    nextTick(() => {
        const query = uni.createSelectorQuery().in(instance);
        query.select('.diy-rich-text').boundingClientRect((data: any) => {
            height.value = data.height;
        }).exec();
    })
}


</script>

<style lang="scss" scoped>
@import '@/addon/tk_partner/utils/styles/common.scss';
</style>