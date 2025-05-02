<template>
    <view class="bg-gray-50 min-h-screen" :style="themeColor()" v-if="sidInfo">
        <!-- 顶部卡片 -->
        <view class="card-template py-[10rpx] mb-[var(--top-m)]" v-if="sidInfo.act_info.form_id">
            <diy-form ref="diyFormRef" :form_id="sidInfo.act_info.form_id"
                :storage_name="'diyFormStorageByCpaSubmit'" />
        </view>
        <!-- 底部操作栏 -->
        <view
            class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-100 p-4 flex items-center justify-between shadow-lg">

            <view class="flex-1 ml-4">
                <u-button type="error" shape="circle" @click="submitForm"
                    class="shadow-lg h-12 text-base font-semibold">提交订单</u-button>
            </view>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, reactive, computed } from 'vue';
import { getSidInfoBySid } from '@/addon/tk_cpa/api/sid'
import { onLoad } from '@dcloudio/uni-app'
import { copy } from '@/utils/common';
import { useLogin } from "@/hooks/useLogin";
import diyForm from '@/addon/tk_cpa/pages/diy-form/index.vue'
import { addOrder } from '@/addon/tk_cpa/api/order'
const diyFormRef: any = ref(null)
const submitLoading = ref(false)
const submitData = ref({})
const submitForm = () => {
    let realvalue = diyFormRef.value.getData().value;
    // 过滤掉componentType不等于diy_form的组件
    let filteredValue = realvalue.filter((item: any) => item.componentType === 'diy_form');
    let formValid = true;
    filteredValue.forEach((item: any) => {
        if (item.field.required === true && (!item.field.value || item.field.value.length === 0)) {
            uni.showToast({
                title: `${item.field.name}为必填项`,
                icon: 'none'
            });
            formValid = false;
        }
    });

    if (!formValid) return;
    submitData.value = diyFormRef.value.getData();
    // 确保submitData.value是一个对象
    if (typeof submitData.value !== 'object' || submitData.value === null) {
        submitData.value = {};
    }
    submitData.value.value = filteredValue;
    addOrder({
        sid: sidInfo.value.sid,
        form_data: submitData.value
    }).then((res: any) => {
        uni.showToast({
            title: '提交成功',
            icon: 'success'
        });
    });
}

// URL弹窗相关
const showUrlDialog = (url: string) => {
    uni.showModal({
        title: '完整链接',
        content: url,
        confirmText: '复制',
        cancelText: '关闭',
        success: (res) => {
            if (res.confirm) {
                copy(url, '链接已复制');
            }
        }
    });
}

// 打开URL链接
const openUrl = (url: string) => {
    // 检查URL是否有http前缀，如果没有则添加
    let finalUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
        finalUrl = 'https://' + url;
    }

    // 使用系统浏览器打开链接
    uni.showModal({
        title: '打开链接',
        content: '是否使用浏览器打开此链接？',
        confirmText: '打开',
        cancelText: '取消',
        success: (res) => {
            if (res.confirm) {
                // #ifdef H5
                window.open(finalUrl, '_blank');
                // #endif

                // #ifdef APP-PLUS
                plus.runtime.openURL(finalUrl);
                // #endif

                // #ifdef MP
                uni.setClipboardData({
                    data: finalUrl,
                    success: () => {
                        uni.showModal({
                            title: '提示',
                            content: '小程序内无法直接打开链接，链接已复制到剪贴板，请在浏览器中粘贴打开',
                            showCancel: false
                        });
                    }
                });
                // #endif
            }
        }
    });
}

// 格式化URL，超长时截断
const formatUrl = (url: string): string => {
    if (!url) return '';
    if (url.length > 60) {
        return url.substring(0, 30) + '...' + url.substring(url.length - 20);
    }
    return url;
}

// 主题颜色函数
const themeColor = () => {
    return {
        "--theme-color": "#f56c6c",
        "--theme-color-light": "rgba(245, 108, 108, 0.1)"
    }
}



const sidInfo = ref<any>();

// 处理标签数据
const labels = computed(() => {
    if (sidInfo.value?.act_info?.labelText && Array.isArray(sidInfo.value.act_info.labelText)) {
        return sidInfo.value.act_info.labelText.filter((item: string) => item !== '');
    }
    return [];
});

onLoad((query: any) => {
    if (query?.sid) {
        getSidInfoBySid(query.sid).then((res: any) => {
            sidInfo.value = res.data;
        });
    }
});
</script>

<style lang="scss" scoped>
.tab-container {
    display: flex;
    justify-content: center;
    padding: 14px 20px;
    background-color: rgba(255, 255, 255, 0.9);
    border-radius: 0;
    max-width: 750rpx;
    margin: 0 auto;
}

.tab-item {
    flex: 1;
    max-width: 160px;
    text-align: center;
    font-size: 15px;
    font-weight: 500;
    padding: 12px 20px;
    margin: 0 10px;
    border-radius: 12px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    cursor: pointer;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);

    &:hover {
        background-color: rgba(245, 108, 108, 0.08);
    }

    &.tab-active {
        color: #f56c6c;
        font-weight: 600;
        background-color: rgba(245, 108, 108, 0.12);
        box-shadow: 0 2px 4px rgba(245, 108, 108, 0.15);

        &::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 50%;
            transform: translateX(-50%);
            width: 24px;
            height: 3px;
            background-color: #f56c6c;
            border-radius: 2px;
        }
    }
}

:deep(.u-tabs__wrapper) {
    display: flex;
    justify-content: center;
    background-color: white;
    padding: 10px 0;
    border-radius: 16px;
}

:deep(.u-tabs__wrapper__nav) {
    display: flex;
    justify-content: center;
    width: 100%;
    padding: 0 12px;
}

:deep(.u-tabs__wrapper__nav__item) {
    flex: 1;
    max-width: 140px;
    text-align: center;
    font-size: 15px;
    font-weight: 500;
    padding: 10px 16px;
    margin: 0 8px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    border-radius: 10px;
    position: relative;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);

    &:hover {
        background-color: rgba(245, 108, 108, 0.08);
    }
}

:deep(.u-tabs__wrapper__nav__item--active) {
    background-color: rgba(245, 108, 108, 0.12) !important;
    position: relative;
    box-shadow: 0 2px 4px rgba(245, 108, 108, 0.15);
}

:deep(.u-tabs__wrapper__nav__line) {
    height: 3px;
    width: 20px !important;
    border-radius: 2px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    bottom: 0;
    background-color: #f56c6c !important;
    left: 50% !important;
    transform: translateX(-50%) !important;
}

:deep(.u-button) {
    height: 44px;
    font-size: 16px;
    font-weight: 600;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    border-radius: 12px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

    &:active {
        transform: scale(0.97);
    }

    &.u-button--plain {
        background-color: #fff !important;
        border: 1px solid #f56c6c !important;
        color: #f56c6c !important;

        &:active {
            background-color: rgba(245, 108, 108, 0.05) !important;
        }
    }
}

:deep(.u-parse) {
    padding: 6px 0;

    img {
        border-radius: 8px;
        margin: 8px 0;
    }
}
</style>
