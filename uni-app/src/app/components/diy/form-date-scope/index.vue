<template>
    <view v-if="diyComponent.viewFormDetail" class="form-item-frame">
        <view class="base-layout-one" v-if="diyGlobal.completeLayout == 'style-1'">
            <view class="detail-one-content" v-if="diyComponent.field.value.start.date || diyComponent.field.value.end.date">
                <text class="detail-one-content-label">{{ diyComponent.field.name }}</text>
                <view class="detail-one-content-value">
                    <text>{{ diyComponent.field.value.start.date }}</text>
                    <text v-if="diyComponent.field.value.start.date && diyComponent.field.value.end.date">-</text>
                    <text>{{ diyComponent.field.value.end.date }}</text>
                </view>
            </view>
        </view>
        <view class="base-layout-two" v-if="diyGlobal.completeLayout == 'style-2'">
            <view class="detail-two-content" v-if="diyComponent.field.value.start.date || diyComponent.field.value.end.date">
                <text class="detail-two-content-label">{{ diyComponent.field.name }}</text>
                <view class="detail-two-content-value w-[80%]">
                    <text>{{ diyComponent.field.value.start.date }}</text>
                    <text v-if="diyComponent.field.value.start.date && diyComponent.field.value.end.date">-</text>
                    <text>{{ diyComponent.field.value.end.date }}</text>
                </view>
            </view>
        </view>
    </view>
    <view v-else :style="warpCss" class="form-item-frame">
        <view class="base-layout-one" v-if="diyGlobal.completeLayout == 'style-1'">
            <view class="layout-one-label">
                <text class="name" :style="{'color': diyComponent.textColor,'font-size': (diyComponent.fontSize * 2) + 'rpx' ,'font-weight': diyComponent.fontWeight}">{{ diyComponent.field.name }}</text>
                <text class="required">{{ diyComponent.field.required ? '*' : '' }}</text>
                <text v-if="diyStore.mode == 'decorate' && diyComponent.isHidden" class="is-hidden">{{ t('diyForm.hidden') }}</text>
            </view>
            <view v-if="diyComponent.field.remark.text" class="layout-one-remark" :style="{ color: diyComponent.field.remark.color, fontSize: (diyComponent.field.remark.fontSize * 2 ) + 'rpx' }">{{ diyComponent.field.remark.text }}</view>
            <view class="layout-one-error-message" v-if="errorInfo && !errorInfo.code">{{ errorInfo.message }}</view>
            <view class="flex items-center">
                <view class="layout-one-content flex-1" @click="openCalendar">
                    <view class="nc-iconfont nc-icon-a-riliV6xx-36 !text-[32rpx] text-[#999] mr-[16rpx]"></view>
                    <view class="flex-1 text-overflow-ellipsis"
                          :class="{'!text-[#999]' : !diyComponent.field.value.start.timestamp && !diyComponent.defaultControl}"
                          :style="{'color': diyComponent.textColor,'font-size': (diyComponent.fontSize * 2) + 'rpx' }">{{ startDate }}</view>
                </view>
                <view class="mx-[10rpx]" :style="{'color': diyComponent.textColor,'font-size': (diyComponent.fontSize * 2) + 'rpx'}">-</view>
                <view class="layout-one-content flex-1" @click="openCalendar">
                    <view class="nc-iconfont nc-icon-a-riliV6xx-36 !text-[32rpx] text-[#999] mr-[16rpx]"></view>
                    <view class="flex-1 text-overflow-ellipsis"
                          :class="{'!text-[#999]' : !diyComponent.field.value.end.timestamp && !diyComponent.defaultControl}"
                          :style="{'color': diyComponent.textColor,'font-size': (diyComponent.fontSize * 2) + 'rpx'}">{{ endDate }}</view>
                </view>
            </view>
            <view class="layout-one-attribute-wrap" v-if="inputAttribute().length">
                <view v-for="(item,index) in inputAttribute()" :key="index" @click="eventFn(item.type)" class="layout-one-attribute-item">{{ item.title }}</view>
            </view>
        </view>
        <view class="base-layout-two" v-if="diyGlobal.completeLayout == 'style-2'">
            <text v-if="diyStore.mode == 'decorate' && diyComponent.isHidden" class="layout-two-is-hidden">{{ t('diyForm.hidden') }}</text>
            <view class="layout-two-wrap" :class="{'no-border': !diyGlobal.borderControl}">
                <view class="layout-two-label" :class="{'justify-start': diyGlobal.completeAlign == 'left', 'justify-end': diyGlobal.completeAlign == 'right'}">
                    <text class="required" v-if="diyComponent.field.required">{{ diyComponent.field.required ? '*' : '' }}</text>
                    <text class="name" :style="{'color': diyComponent.textColor,'font-size': (diyComponent.fontSize * 2) + 'rpx' ,'font-weight': diyComponent.fontWeight}">{{ diyComponent.field.name }}</text>
                </view>
                <view class="layout-two-content" @click="openCalendar">
                    <view class="text-overflow-ellipsis flex justify-center" :class="{'!text-[#999]' : !diyComponent.field.value.start.timestamp && !diyComponent.defaultControl}" :style="{'color': diyComponent.textColor,'font-size': (diyComponent.fontSize * 2) + 'rpx'}">{{ startDate }}</view>
                    <view class="mx-[10rpx]" :style="{'color': diyComponent.textColor,'font-size': (diyComponent.fontSize * 2) + 'rpx'}">-</view>
                    <view class="text-overflow-ellipsis flex justify-center" :class="{'!text-[#999]' : !diyComponent.field.value.end.timestamp && !diyComponent.defaultControl}" :style="{'color': diyComponent.textColor,'font-size': (diyComponent.fontSize * 2) + 'rpx'}">{{ endDate }}</view>
                    <text class="nc-iconfont !text-[#666] !text-[36rpx] nc-icon-youV6xx -mr-[8rpx]"></text>
                </view>
            </view>
            <view class="layout-two-error-message" v-if="errorInfo && !errorInfo.code">{{ errorInfo.message }}</view>
            <view v-if="diyComponent.field.remark.text" class="layout-two-remark" :style="{ color: diyComponent.field.remark.color, fontSize: (diyComponent.field.remark.fontSize * 2 ) + 'rpx' }">{{ diyComponent.field.remark.text }}</view>
            <view class="layout-two-attribute-wrap" v-if="inputAttribute().length">
                <view v-for="(item,index) in inputAttribute()" :key="index" @click="eventFn(item.type)" class="layout-two-attribute-item">{{ item.title }}</view>
            </view>
        </view>
        <view class="calendar-wrap">
            <u-calendar :show="calendarShow" mode="range" @confirm="confirm" @close="calendarShow=false"
                        closeOnClickOverlay="true"
                        :defaultDate="defaultDate" startText="开始" endText="结束" confirmDisabledText="禁止选择"
                        color="var(--primary-color)" ref="calendar" monthNum="2"></u-calendar>
        </view>

        <!-- 遮罩层，装修使用 -->
        <view v-if="diyStore.mode == 'decorate'" class="form-item-mask"></view>
    </view>
</template>

<script setup lang="ts">
// 表单 日期范围组件
import { ref, computed, watch, onMounted } from 'vue';
import { img, timeTurnTimeStamp } from '@/utils/common';
import { t } from '@/locale'
import useDiyStore from '@/app/stores/diy';

const props = defineProps(['component', 'index', 'global']);
const diyStore = useDiyStore();
const calendarShow = ref(false);

const errorInfo: any = ref(null);

const diyComponent = computed(() => {
    if (diyStore.mode == 'decorate') {
        return diyStore.value[props.index];
    } else {
        return props.component;
    }
})

const diyGlobal = computed(() => {
    return props.global;
})

// input属性
const inputAttribute = () => {
    let arr = [];
    if (diyComponent.value.autofill) {
        let obj = {
            title: '已自动填充'
        };
        arr.push(obj);
    }

    arr.forEach((item, index, arr) => {
        if (index != (arr.length - 1)) {
            let obj = {
                title: '|'
            };
            arr.push(obj);
        }
    })
    return arr;
}

const eventFn = (type: any) => {

}

// 开始日期
const startDate = computed(() => {
    let returnDate = '';
    let date = '';
    if (diyComponent.value.field.value.start.date) {
        let timestamp = diyComponent.value.field.value.start.timestamp;
        returnDate = getDateFn(timestamp);
        date = returnDate;
    } else {
        if (diyComponent.value.start.defaultControl) {
            if (diyComponent.value.start.dateWay == 'current') {
                returnDate = getDateFn();
            } else if (diyComponent.value.start.dateWay == 'diy') {
                let timestamp = diyComponent.value.field.default.start.timestamp ? diyComponent.value.field.default.start.timestamp : '';
                returnDate = getDateFn(timestamp);
            }
            date = returnDate;
        } else {
            returnDate = diyComponent.value.start.placeholder;
            date = '';
        }
    }
    diyComponent.value.field.value.start.date = date;
    diyComponent.value.field.value.start.timestamp = date ? timeTurnTimeStamp(date) : 0;
    return returnDate;
})

// 结束日期
const endDate = computed(() => {
    let returnDate = '';
    let date = '';
    if (diyComponent.value.field.value.end.date) {
        let timestamp = diyComponent.value.field.value.end.timestamp;
        returnDate = getDateFn(timestamp);
        date = returnDate;

        diyComponent.value.field.value.end.date = date;
        diyComponent.value.field.value.end.timestamp = timeTurnTimeStamp(date);
    } else {
        if (diyComponent.value.end.defaultControl) {
            if (diyComponent.value.end.dateWay == 'current') {
                returnDate = getDateFn();
            } else if (diyComponent.value.end.dateWay == 'diy') {
                returnDate = getDateFn(diyComponent.value.field.default.end.timestamp);
            }
            date = returnDate;
            diyComponent.value.field.value.end.date = date;
            diyComponent.value.field.value.end.timestamp = timeTurnTimeStamp(date);
        } else {
            returnDate = diyComponent.value.end.placeholder;
        }
    }
    return returnDate;
})

// 默认数据
const defaultDate = computed(() => {
    let arr = [];
    arr[0] = getDateFn(timeTurnTimeStamp(startDate.value), 'YYYY-MM-DD');
    arr[1] = getDateFn(timeTurnTimeStamp(endDate.value), 'YYYY-MM-DD');
    return arr;
})

const warpCss = computed(() => {
    var style = '';
    style += 'position:relative;';
    if (diyComponent.value.componentStartBgColor && diyComponent.value.componentEndBgColor) style += `background:linear-gradient(${ diyComponent.value.componentGradientAngle },${ diyComponent.value.componentStartBgColor },${ diyComponent.value.componentEndBgColor });`;
    else if (diyComponent.value.componentStartBgColor) style += 'background-color:' + diyComponent.value.componentStartBgColor + ';';
    else if (diyComponent.value.componentEndBgColor) style += 'background-color:' + diyComponent.value.componentEndBgColor + ';';

    if (diyComponent.value.componentBgUrl) {
        style += `background-image:url('${ img(diyComponent.value.componentBgUrl) }');`;
        style += 'background-size: cover;background-repeat: no-repeat;';
    }

    if (diyComponent.value.topRounded) style += 'border-top-left-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
    if (diyComponent.value.topRounded) style += 'border-top-right-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
    if (diyComponent.value.bottomRounded) style += 'border-bottom-left-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
    if (diyComponent.value.bottomRounded) style += 'border-bottom-right-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
    return style;
})

onMounted(() => {
    refresh();
    // 装修模式下刷新
    if (diyStore.mode == 'decorate') {
        watch(
            () => diyComponent.value,
            (newValue, oldValue) => {
                if (newValue && newValue.componentName == 'FormDateScope') {
                    refresh();
                }
            }
        )
    }
});

const refresh = () => {
    // todo 开始、结束时间给予默认值
    // {{ diyComponent.start.defaultControl ? diyComponent.field.value.start.date : diyComponent.start.placeholder }}
}

// 表单组件验证
const verify = () => {
    const res = { code: true, message: '' }
    if (diyComponent.value.field.required) {
        if (diyComponent.value.field.value.start.date == '' || !diyComponent.value.field.value.start.timestamp) {
            res.code = false
            res.message = `请选择${ diyComponent.value.start.placeholder }`;
        } else if (diyComponent.value.field.value.end.date == '' || !diyComponent.value.field.value.end.timestamp) {
            res.code = false
            res.message = `请选择${ diyComponent.value.end.placeholder }`;
        }
    }

    errorInfo.value = res;
    return res;
}

// 重置表单组件数据
const reset = () => {
    diyComponent.value.field.value.start.date = '';
    diyComponent.value.field.value.start.timestamp = 0;
    diyComponent.value.field.value.end.date = '';
    diyComponent.value.field.value.end.timestamp = 0;
}

const openCalendar = () => {
    if (diyStore.mode === 'decorate') return;
    calendarShow.value = true;
}

const confirm = (e) => {
    diyComponent.value.field.value.start.date = e[0];
    diyComponent.value.field.value.start.timestamp = timeTurnTimeStamp(e[0]); // todo 需要赋值
    diyComponent.value.field.value.end.date = e[e.length - 1];
    diyComponent.value.field.value.end.timestamp = timeTurnTimeStamp(e[e.length - 1]); // todo 需要赋值
    calendarShow.value = false;
}

const getDateFn = (res: any = '', type: any = diyComponent.value.dateFormat) => {
    let date = res ? new Date(res * 1000) : new Date();
    let year = date.getFullYear();
    let month = String(date.getMonth() + 1).padStart(2, '0');
    let day = String(date.getDate()).padStart(2, '0');

    let str = '';
    if (type == 'YYYY年M月D日') {
        str = `${ year }年${ month }月${ day }日`;
    } else if (type == 'YYYY-MM-DD') {
        str = `${ year }-${ month }-${ day }`;
    } else if (type == 'YYYY/MM/DD') {
        str = `${ year }/${ month }/${ day }`;
    }
    return str;
}

defineExpose({
    verify,
    reset
})
</script>

<style lang="scss" scoped>
@import '@/styles/diy_form.scss';

.text-overflow-ellipsis {
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
    display: inline-block;
}
</style>
<style lang="scss">
.calendar-wrap .u-calendar .u-calendar-header__title, .u-calendar-header__subtitle, .u-calendar-month__title {
    display: block;
}
</style>
