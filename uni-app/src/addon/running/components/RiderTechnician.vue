<template>
    <view :style="wrapCss">
        <view :style="maskLayer"></view>
        <view class="rider-technician relative">
            <view class="leading-0 overflow-hidden" :style="{ height: imgHeight }" v-if="isRider">
                <view @click="redirect({ url: '/addon/running/pages/rider/hall' })">
                    <image v-if="diyComponent.imageUrl" :src="img(diyComponent.imageUrl)" :style="{ height: imgHeight }"
                        mode="heightFix" class="w-full" :show-menu-by-longpress="true" />
                    <image v-else :src="img('static/resource/images/diy/figure.png')" :style="{ height: imgHeight }"
                        mode="heightFix" class="w-full" :show-menu-by-longpress="true" />
                </view>
            </view>

            <!-- 自定义骑手入口 -->
            <view v-if="diyComponent.customStyle && isRider" class="custom-rider-entrance"
                @click="redirect({ url: diyComponent.linkUrl || '/addon/running/pages/rider/hall' })">
                <view class="entrance-card" :style="cardStyle">
                    <view class="card-left">
                        <view class="icon-wrapper" :style="iconWrapperStyle">
                            <text class="iconfont icon-rider" :style="iconStyle"></text>
                        </view>
                        <view class="text-content">
                            <text class="main-text" :style="mainTextStyle">{{ diyComponent.mainTitle || '骑手中心' }}</text>
                            <text class="sub-text" :style="subTextStyle">{{ diyComponent.subTitle || '查看接单大厅' }}</text>
                        </view>
                    </view>
                    <view class="card-right" :style="buttonStyle">
                        <text class="btn-text">{{ diyComponent.buttonText || '立即前往' }}</text>
                        <text class="iconfont icon-right"></text>
                    </view>
                </view>
            </view>
        </view>
    </view>
</template>

<script lang="ts" setup>
import { ref, computed, watch, onMounted, nextTick, getCurrentInstance } from 'vue';
import { img, redirect } from '@/utils/common';
import { getRiderInfo } from '@/addon/running/api/rider';
import useDiyStore from '@/app/stores/diy';

const props = defineProps(['component', 'index']);

const diyStore = useDiyStore();

const diyComponent = computed(() => {
    if (diyStore.mode == 'decorate') {
        return diyStore.value[props.index];
    } else {
        return props.component || {
            customStyle: true,
            imageHeight: 100,
            mainTitle: '骑手中心',
            subTitle: '查看接单大厅',
            buttonText: '立即前往',
            linkUrl: '/addon/running/pages/rider/hall',
            bgColor: '#3b82f6',
            textColor: '#ffffff'
        };
    }
});

const wrapCss = computed(() => {
    var style = '';
    style += 'position:relative;';
    if (diyComponent.value.componentStartBgColor) {
        if (diyComponent.value.componentStartBgColor && diyComponent.value.componentEndBgColor)
            style += `background:linear-gradient(${diyComponent.value.componentGradientAngle},${diyComponent.value.componentStartBgColor},${diyComponent.value.componentEndBgColor});`;
        else
            style += 'background-color:' + diyComponent.value.componentStartBgColor + ';';
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
});

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

// 自定义卡片样式
const cardStyle = computed(() => {
    const bgColor = diyComponent.value.bgColor || '#3b82f6';
    return {
        background: `linear-gradient(135deg, ${bgColor} 0%, ${lightenColor(bgColor, -20)} 100%)`,
        margin: `${diyComponent.value.marginTop || 20}rpx ${diyComponent.value.marginRight || 20}rpx ${diyComponent.value.marginBottom || 20}rpx ${diyComponent.value.marginLeft || 20}rpx`
    };
});

const iconWrapperStyle = computed(() => {
    return {
        backgroundColor: 'rgba(255, 255, 255, 0.2)'
    };
});

const iconStyle = computed(() => {
    return {
        color: diyComponent.value.iconColor || '#ffffff'
    };
});

const mainTextStyle = computed(() => {
    return {
        color: diyComponent.value.textColor || '#ffffff',
        fontSize: `${diyComponent.value.mainFontSize || 32}rpx`,
        fontWeight: diyComponent.value.fontWeight || '600'
    };
});

const subTextStyle = computed(() => {
    return {
        color: diyComponent.value.textColor || '#ffffff',
        opacity: 0.8,
        fontSize: `${diyComponent.value.subFontSize || 24}rpx`
    };
});

const buttonStyle = computed(() => {
    return {
        backgroundColor: 'rgba(255, 255, 255, 0.2)',
        color: diyComponent.value.textColor || '#ffffff'
    };
});

// 颜色处理函数 - 变亮或变暗
function lightenColor(color: string, percent: number) {
    if (!color) return '#2563eb';

    // 去掉可能的 # 前缀
    let hex = color.replace('#', '');

    // 转为RGB
    let r = parseInt(hex.substring(0, 2), 16);
    let g = parseInt(hex.substring(2, 4), 16);
    let b = parseInt(hex.substring(4, 6), 16);

    // 调整亮度
    r = Math.min(255, Math.max(0, r + percent));
    g = Math.min(255, Math.max(0, g + percent));
    b = Math.min(255, Math.max(0, b + percent));

    // 转回十六进制
    return `#${r.toString(16).padStart(2, '0')}${g.toString(16).padStart(2, '0')}${b.toString(16).padStart(2, '0')}`;
}

onMounted(() => {
    refresh();
    // 装修模式下刷新
    if (diyStore.mode == 'decorate') {
        watch(
            () => diyComponent.value,
            (newValue, oldValue) => {
                if (newValue && newValue.componentName == 'RiderTechnician') {
                    refresh();
                }
            }
        );
    }
});

const instance = getCurrentInstance();
const height = ref(0);

const refresh = () => {
    nextTick(() => {
        const query = uni.createSelectorQuery().in(instance);
        query.select('.rider-technician').boundingClientRect((data: any) => {
            if (data) {
                height.value = data.height;
            }
        }).exec();
    });
};

const imgHeight = computed(() => {
    return (diyComponent.value.imageHeight * 2) + 'rpx';
});

// 验证是否是骑手
const isRider = ref(false);
const checkRiderFn = () => {
    if (diyStore.mode == 'decorate') {
        return isRider.value = true;
    } else {
        getRiderInfo().then((res: any) => {
            if (res && res.data) {
                isRider.value = true;
            } else {
                isRider.value = false;
            }
        }).catch(() => {
            isRider.value = false;
        });
    }
};

checkRiderFn();
</script>

<style lang="scss" scoped>
.rider-technician {
    width: 100%;
}

.custom-rider-entrance {
    margin: 20rpx;

    .entrance-card {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 30rpx;
        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
        border-radius: 16rpx;
        box-shadow: 0 4rpx 16rpx rgba(37, 99, 235, 0.2);
        color: #ffffff;

        &:active {
            transform: scale(0.98);
            opacity: 0.95;
        }

        .card-left {
            display: flex;
            align-items: center;

            .icon-wrapper {
                width: 80rpx;
                height: 80rpx;
                border-radius: 50%;
                background-color: rgba(255, 255, 255, 0.2);
                display: flex;
                justify-content: center;
                align-items: center;
                margin-right: 20rpx;

                .iconfont {
                    font-size: 40rpx;
                }
            }

            .text-content {
                display: flex;
                flex-direction: column;

                .main-text {
                    font-size: 32rpx;
                    font-weight: 600;
                    margin-bottom: 6rpx;
                }

                .sub-text {
                    font-size: 24rpx;
                    opacity: 0.8;
                }
            }
        }

        .card-right {
            display: flex;
            align-items: center;
            background-color: rgba(255, 255, 255, 0.2);
            padding: 12rpx 20rpx;
            border-radius: 30rpx;

            .btn-text {
                font-size: 26rpx;
                margin-right: 6rpx;
            }

            .iconfont {
                font-size: 24rpx;
            }
        }
    }
}
</style>