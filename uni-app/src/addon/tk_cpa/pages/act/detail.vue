<template>
    <view class="bg-[var(--page-bg-color)] min-h-screen" :style="themeColor()" v-if="actInfo">
        <!-- 头部卡片 -->
        <view class="bg-white rounded-b-1xl shadow-lg p-6 mb-4">
            <view class="flex items-center">
                <view class="flex-shrink-0">
                    <image :src="img(actInfo.itemPic)"
                        class="w-20 h-20 rounded-2xl object-cover shadow-xl ring-2 ring-white ring-offset-2 ring-offset-gray-50"
                        mode="aspectFill">
                    </image>
                </view>
                <view class="flex-1 ml-4 min-w-0">
                    <view class="text-[36rpx] font-bold text-gray-900 mb-4 line-clamp-2">
                        {{ actInfo.title }}
                    </view>
                    <view class="flex items-center gap-3">
                        <view
                            class="bg-gradient-to-r from-red-500 to-red-600 px-3 py-1.5 rounded-full inline-flex items-center shadow-md">
                            <text class="text-white text-sm font-medium">佣金</text>
                            <view class="flex items-baseline ml-2">
                                <text v-if="actInfo.minMoney == actInfo.maxMoney"
                                    class="text-white font-semibold text-sm">
                                    {{ actInfo.minMoney }}
                                </text>
                                <text v-else class="text-white font-semibold text-sm">
                                    {{ actInfo.minMoney }}-{{ actInfo.maxMoney }}
                                </text>
                            </view>
                        </view>
                    </view>
                </view>
            </view>
            <view class="flex flex-wrap gap-2 mt-2" v-if="actInfo.labelText && actInfo.labelText.length > 0">
                <view v-for="(item, index) in actInfo.labelText" :key="index"
                    class="px-3 py-1.5 text-sm rounded-full bg-gray-50 text-gray-600 border border-gray-200"
                    v-if="item !== ''">
                    {{ item }}
                </view>
            </view>
            <view class="text-gray-500 text-[26rpx] leading-relaxed mt-2 bg-gray-50 p-3 rounded-xl">
                *{{ actInfo.simpleDescription }}
            </view>
        </view>

        <!-- Tab内容区域 -->
        <view class="bg-white/40 sticky top-0 z-10 shadow-sm rounded-[24rpx] shadow-md">
            <view class="tab-container">
                <view v-for="(item, index) in tabList" :key="index" class="tab-item"
                    :class="{ 'tab-active': currentTab === index }" @click="tabChange(index)">
                    {{ item.name }}
                </view>
            </view>
        </view>

        <view class="p-3 pb-28">
            <view v-if="currentTab === 0">
                <view class="bg-white rounded-xl shadow-sm p-4 mb-2">
                    <view class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <view class="w-1 h-5 bg-red-500 rounded-full mr-2"></view>
                        结算说明
                    </view>
                    <view class="text-gray-600 text-sm leading-relaxed">
                        <u-parse :content="actInfo.settlementDesc"></u-parse>
                    </view>
                </view>
                <view class="bg-white rounded-xl shadow-sm p-4">
                    <view class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <view class="w-1 h-5 bg-red-500 rounded-full mr-2"></view>
                        项目详情
                    </view>
                    <view class="text-gray-600 text-sm leading-relaxed">
                        <u-parse :content="actInfo.projectDesc"></u-parse>
                    </view>
                </view>
            </view>
            <view v-else>
                <view class="bg-white rounded-xl shadow-md p-4">
                    <view class="text-lg font-semibold text-gray-900 mb-4 flex items-center">
                        <view class="w-1 h-5 bg-red-500 rounded-full mr-2"></view>
                        推广教程
                    </view>
                    <view class="text-gray-600 text-sm leading-relaxed">
                        <u-parse :content="actInfo.promotionDesc"></u-parse>
                    </view>
                </view>
            </view>
        </view>

        <!-- 底部操作栏 -->
        <view
            class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-100 p-4 flex items-center justify-between shadow-lg">
            <view class="flex-1">
                <u-button type="error" shape="circle" @click="redirect({ url: '/addon/tk_cpa/pages/sid/index' })"
                    class="shadow-lg h-12 text-base font-medium" plain>报名记录</u-button>
            </view>
            <view class="flex-1 ml-4">
                <u-button type="error" shape="circle" @click="addEvent"
                    class="shadow-lg h-12 text-base font-semibold">立即报名</u-button>
            </view>
        </view>
        <u-popup :show="showPopup" @close="showPopup = false" mode="center" round="10" :closeable="true">
            <view class="w-[600rpx] p-6">
                <view class="text-lg font-semibold text-gray-900 mb-6 text-center">立即报名</view>
                <view class="space-y-4">
                    <view class="space-y-2">
                        <text class="text-sm text-gray-600">联系人</text>
                        <u-input v-model="formData.nickName" placeholder="请输入昵称" class="bg-gray-50 rounded-lg"
                            :custom-style="{ padding: '12px 16px' }" />
                    </view>
                    <view class="space-y-2">
                        <text class="text-sm text-gray-600">手机号</text>
                        <u-input v-model="formData.phone" placeholder="请输入手机号" class="bg-gray-50 rounded-lg"
                            :custom-style="{ padding: '12px 16px' }" />
                    </view>
                </view>
                <view class="mt-8">
                    <u-button type="error" shape="circle" @click="submitForm"
                        class="shadow-lg h-12 text-base font-semibold w-full">确认报名</u-button>
                </view>
            </view>
        </u-popup>
    </view>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue';
import { getActInfo, addPromotionCode } from '@/addon/tk_cpa/api/act'
import { onLoad } from '@dcloudio/uni-app'
import { img, getToken, redirect } from '@/utils/common';
import { useLogin } from "@/hooks/useLogin";
const showPopup = ref(false);
const formData = reactive({
    cpaProjectId: '',
    nickName: '',
    phone: '',
    a_id: ''
});

interface ActInfo {
    id: string;
    itemPic: string;
    title: string;
    minMoney: number;
    maxMoney: number;
    labelText: string[];
    simpleDescription: string;
    settlementDesc: string;
    projectDesc: string;
    promotionDesc: string;
}

const actInfo = ref<ActInfo | null>(null);
const currentTab = ref(0);
const isCollected = ref(false);
const tabList = ref([
    { name: '项目详情' },
    { name: '推广教程' }
]);

const themeColor = () => {
    return {
        '--theme-color': '#f56c6c'
    }
}

const tabChange = (index: number) => {
    currentTab.value = index;
};

const handleShare = () => {
    uni.showShareMenu({
        withShareTicket: true,
        menus: ['shareAppMessage', 'shareTimeline']
    });
};


const handleApply = () => {
    // 处理开码记录逻辑
    uni.navigateTo({
        url: `/addon/tk_cpa/pages/act/record?id=${actInfo.value?.id}`
    });
};
const addEvent = () => {
    if (!getToken()) {
        useLogin().setLoginBack({ url: '/addon/tk_cpa/pages/act/detail?id=' + actInfo.value?.id })
        return;
    }
    else {
        showPopup.value = true;
    }
}
const submitForm = async () => {

    if (!formData.nickName) {
        uni.showToast({
            title: '请输入昵称',
            icon: 'none'
        });
        return;
    }
    if (!formData.phone) {
        uni.showToast({
            title: '请输入手机号',
            icon: 'none'
        });
        return;
    }
    if (!/^1[3-9]\d{9}$/.test(formData.phone)) {
        uni.showToast({
            title: '请输入正确的手机号',
            icon: 'none'
        });
        return;
    }

    try {
        formData.a_id = actInfo.value?.id;
        const res = await addPromotionCode({
            ...formData,
            cpaProjectId: actInfo.value?.act_id
        });
        if (res.code == 1) {
            uni.showToast({
                title: '申请成功',
                icon: 'success'
            });
            showPopup.value = false;
            // 重置表单
            formData.nickName = '';
            formData.phone = '';
            setTimeout(() => {
                redirect({ url: '/addon/tk_cpa/pages/sid/detail?id=' + res.data.id })
            }, 500);
        } else {
            uni.showToast({
                title: res.msg || '申请失败',
                icon: 'none'
            });
        }
    } catch (error) {
        uni.showToast({
            title: '网络错误，请稍后重试',
            icon: 'none'
        });
    }
};

onLoad((query: any) => {
    if (query?.id) {
        getActInfo(query.id).then((res: any) => {
            actInfo.value = res.data;
        });
    }
});
</script>

<style lang="scss" scoped>
.tab-container {
    display: flex;
    justify-content: center;
    padding: 16px 24px;
    background-color: white;
}

.tab-item {
    flex: 1;
    max-width: 160px;
    text-align: center;
    font-size: 16px;
    font-weight: 500;
    padding: 12px 20px;
    margin: 0 12px;
    border-radius: 10px;
    transition: all 0.3s ease-in-out;
    position: relative;
    cursor: pointer;

    &:hover {
        background-color: rgba(245, 108, 108, 0.05);
    }

    &.tab-active {
        color: #f56c6c;
        font-weight: 600;
        background-color: rgba(245, 108, 108, 0.1);

        &::after {
            content: '';
            position: absolute;
            bottom: -3px;
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
    padding: 8px 0;
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
    padding: 8px 16px;
    margin: 0 8px;
    transition: all 0.3s ease-in-out;
    border-radius: 8px;
    position: relative;

    &:hover {
        background-color: rgba(245, 108, 108, 0.05);
    }
}

:deep(.u-tabs__wrapper__nav__item--active) {
    background-color: rgba(245, 108, 108, 0.1) !important;
    position: relative;
}

:deep(.u-tabs__wrapper__nav__line) {
    height: 3px;
    width: 20px !important;
    border-radius: 2px;
    transition: all 0.3s ease-in-out;
    bottom: 0;
    background-color: #f56c6c !important;
    left: 50% !important;
    transform: translateX(-50%) !important;
}

:deep(.u-button) {
    height: 44px;
    font-size: 16px;
    font-weight: 600;
    transition: all 0.3s ease-in-out;

    &:active {
        transform: scale(0.98);
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
</style>
