<template>
    <view v-if="diyComponent.viewFormDetail" class="form-item-frame">
        <view class="base-layout-one" v-if="diyGlobal.completeLayout == 'style-1'">
            <view class="detail-one-content">
                <text class="detail-one-content-label">{{ diyComponent.field.name }}</text>
                <view class="detail-one-content-value">
                    <text>{{ formattedPhoneNumber }}</text>
                    <text v-if="diyComponent.field.privacyProtection" class="ml-[20rpx] text-[var(--primary-color)]" @click="viewPrivacy">{{ t('diyForm.view') }}</text>
                </view>
            </view>
        </view>
        <view class="base-layout-two" v-if="diyGlobal.completeLayout == 'style-2'">
            <view class="detail-two-content">
                <text class="detail-two-content-label">{{ diyComponent.field.name }}</text>
                <view class="detail-two-content-value">
                    <text>{{ formattedPhoneNumber }}</text>
                    <text v-if="diyComponent.field.privacyProtection" class="ml-[20rpx] text-[var(--primary-color)]" @click="viewPrivacy">{{ t('diyForm.view') }}</text>
                </view>
            </view>
        </view>
        <form-privacy ref="formDetailPrivacyRef" :data="diyComponent.field.value" />
    </view>
    <view v-else :style="warpCss" class="form-item-frame">
        <view class="base-layout-one" v-if="diyGlobal.completeLayout == 'style-1'">
            <view class="layout-one-label">
                <text class="text-overflow-ellipsis" :style="{'color': diyComponent.textColor,'font-size': (diyComponent.fontSize * 2) + 'rpx' ,'font-weight': diyComponent.fontWeight}">{{ diyComponent.field.name }}</text>
                <text class="required">{{ diyComponent.field.required ? '*' : '' }}</text>
                <text v-if="diyStore.mode == 'decorate' && diyComponent.isHidden" class="is-hidden">{{ t('diyForm.hidden') }}</text>
            </view>
            <view v-if="diyComponent.field.remark.text" class="layout-one-remark" :style="{ color: diyComponent.field.remark.color, fontSize: (diyComponent.field.remark.fontSize * 2 ) + 'rpx' }">{{ diyComponent.field.remark.text }}</view>
            <view class="layout-one-error-message" v-if="errorInfo && !errorInfo.code">{{ errorInfo.message }}</view>
            <input type="number" class="layout-one-content" :placeholder="inputPlaceholder"
                   placeholderClass="layout-one-input-placeholder"
                   :placeholder-style="{'font-size': (diyComponent.fontSize * 2) + 'rpx' }"
                   :style="{'color': diyComponent.textColor,'font-size': (diyComponent.fontSize * 2) + 'rpx'}"
                   v-model="diyComponent.field.value" :disabled="isDisabled" maxlength="11" />
            <view class="layout-one-attribute-wrap" v-if="inputAttribute().length">
                <view v-for="(item,index) in inputAttribute()" :key="index" @click="eventFn(item.type)" class="layout-one-attribute-item">{{ item.title }}</view>
            </view>
        </view>
        <view class="base-layout-two" v-if="diyGlobal.completeLayout == 'style-2'">
            <text v-if="diyStore.mode == 'decorate' && diyComponent.isHidden" class="layout-two-is-hidden">{{ t('diyForm.hidden') }}</text>
            <view class="layout-two-wrap" :class="{'no-border': !diyGlobal.borderControl}">
                <view class="layout-two-label"
                      :class="{'justify-start': diyGlobal.completeAlign == 'left', 'justify-end': diyGlobal.completeAlign == 'right'}">
                    <text class="required" v-if="diyComponent.field.required">{{ diyComponent.field.required ? '*' : '' }}</text>
                    <text class="name" :style="{'color': diyComponent.textColor,'font-size': (diyComponent.fontSize * 2) + 'rpx' ,'font-weight': diyComponent.fontWeight}">{{ diyComponent.field.name }}</text>
                </view>
                <input type="number" class="layout-two-content no-flex" :placeholder="inputPlaceholder"
                       placeholderClass="layout-two-input-placeholder"
                       :placeholder-style="{'font-size': (diyComponent.fontSize * 2) + 'rpx'}"
                       :style="{'color': diyComponent.textColor,'font-size': (diyComponent.fontSize * 2) + 'rpx'}"
                       v-model="diyComponent.field.value" :disabled="isDisabled" maxlength="11" />
            </view>
            <view class="layout-two-error-message" v-if="errorInfo && !errorInfo.code">{{ errorInfo.message }}</view>
            <view v-if="diyComponent.field.remark.text" class="layout-two-remark" :style="{ color: diyComponent.field.remark.color, fontSize: (diyComponent.field.remark.fontSize * 2 ) + 'rpx' }">{{ diyComponent.field.remark.text }}</view>
            <view class="layout-two-attribute-wrap" v-if="inputAttribute().length">
                <view v-for="(item,index) in inputAttribute()" :key="index" @click="eventFn(item.type)" class="layout-two-attribute-item">{{ item.title }}</view>
            </view>
        </view>
        <view v-if="diyStore.mode == 'decorate'" class="form-item-mask"></view>
        <form-privacy-pop ref="formPrivacyRef" :data="formPrivacyData" />
    </view>
</template>

<script setup lang="ts">
// 表单 手机号组件
import { ref, computed, watch, onMounted, nextTick } from 'vue';
import { img } from '@/utils/common';
import { t } from '@/locale'
import formPrivacyPop from './../form-privacy-pop/index.vue';
import useDiyStore from '@/app/stores/diy';
import formPrivacy from './../form-privacy/index.vue'

const props = defineProps(['component', 'index', 'global']);
const diyStore = useDiyStore();
const errorInfo: any = ref(null);
const formPrivacyRef: any = ref(null);
const formDetailPrivacyRef: any = ref(null);

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

const formattedPhoneNumber = computed(() => {
    const phone = String(diyComponent.value.field.value);
    if (diyComponent.value.field.privacyProtection) {
        return phone.replace(/(\d{3})\d{4}(\d{3})/, '$1****$2');
    }
    return phone;
});


const inputPlaceholder = computed(() => {
    let str = '';
    str += diyComponent.value.placeholder
    return str;
})

const formPrivacyData = computed(() => {
    let str = `${ diyComponent.value.field.name }已开启隐私保护，提交后会部分打码，只有你自己和管理员才能查看完整信息`;
    return str;
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
    if (diyComponent.value.field.privacyProtection) {
        let obj = {
            title: '已开启隐私保护',
            type: 'privacy'
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
    if (type == 'privacy') {
        // 查看隐私
        formPrivacyRef.value.open();
    }
}

const viewPrivacy = () => {
    nextTick(() => {
        if (formDetailPrivacyRef.value) {
            formDetailPrivacyRef.value.open();
        } else {
            console.warn('formDetailPrivacyRef is not defined');
        }
    });
}

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
                if (newValue && newValue.componentName == 'FormMobile') {
                    refresh();
                }
            }
        )
    } else {
    }
});

const refresh = () => {
    // 装修模式下，展示默认值
    if (diyStore.mode == 'decorate') {
        diyComponent.value.field.value = diyComponent.value.field.default;
    } else {
        // 实际展示，优先缓存，其次默认值
        if (diyComponent.value.field.value == '' && diyComponent.value.field.default) {
            diyComponent.value.field.value = diyComponent.value.field.default;
        }
    }
}

// 表单组件验证
const verify = () => {
    const res = { code: true, message: '' }
    if (diyComponent.value.field.required && diyComponent.value.field.value == '' && diyStore.mode != 'decorate') {
        res.code = false
        res.message = `${ inputPlaceholder.value }`;
    } else if (!/^1[3-9]\d{9}$/.test(diyComponent.value.field.value) && diyStore.mode != 'decorate') {
        res.code = false
        res.message = `手机号格式不正确，请重新输入`;
    }
    errorInfo.value = res;
    return res;
}

// 重置表单组件数据
const reset = () => {
    diyComponent.value.field.value = '';
}

const isDisabled = computed(() => {
    return diyStore.mode == 'decorate';
});

defineExpose({
    verify,
    reset
})
</script>

<style lang="scss" scoped>
@import '@/styles/diy_form.scss';
</style>
