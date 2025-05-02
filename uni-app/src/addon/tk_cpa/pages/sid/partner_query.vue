<template>
    <view class="bg-gray-50 min-h-screen" :style="themeColor()" v-if="sidInfo">
        <!-- 顶部卡片 -->
        <view class="bg-white rounded-b-3xl shadow-sm p-6 mb-4 relative">
            <!-- 项目信息卡片 -->
            <view class="flex items-start" v-if="sidInfo.act_info">
                <view class="flex-shrink-0">
                    <image :src="img(sidInfo.act_info.itemPic)"
                        class="w-16 h-16 rounded-2xl object-cover shadow-lg ring-2 ring-white ring-offset-2 ring-offset-gray-50"
                        mode="aspectFill">
                    </image>
                </view>
                <view class="flex-1 ml-4 min-w-0 mt-0.5">
                    <view class="text-[38rpx] font-bold text-gray-900 mb-3 line-clamp-2 leading-tight">
                        {{ sidInfo.act_info.title }}
                    </view>
                    <!-- 标签区域 -->
                    <view class="flex flex-wrap gap-2 mt-3 mb-2" v-if="labels.length > 0">
                        <view v-for="(item, index) in labels" :key="index"
                            class="px-3 py-1 text-sm rounded-full bg-gray-50 text-gray-600 border border-gray-200 shadow-sm">
                            {{ item }}
                        </view>
                    </view>
                </view>
            </view>
            <view v-else>
                当前项目暂停推广
            </view>
        </view>
        <view v-if="sidInfo.act_info.extra_data" class="bg-white rounded-xl shadow-sm p-4 mx-4 mb-4">
            <view class="text-base font-bold mb-3 text-gray-800 border-l-4 pl-3"
                style="border-color:var(--theme-color)">项目参数</view>
            <view v-for="(item, index) in sidInfo.act_info.extra_data" :key="index"
                class="mb-4 pb-4 border-b border-gray-100 last:border-0 last:mb-0 last:pb-0">
                <view class="text-gray-700 font-medium mb-2 flex items-center">
                    <view class="w-1.5 h-1.5 rounded-full mr-2" style="background-color:var(--theme-color)"></view>
                    {{ item.name }}
                </view>
                <view v-if="item.type === 'text'" class="mt-2">
                    <view class="bg-gray-50 p-3 rounded-lg flex items-center justify-between">
                        <view class="text-gray-600 text-sm flex-1 break-all overflow-hidden">
                            {{ item.value }}
                        </view>
                        <view class="flex items-center ml-2">
                            <view @click="copy(item.value, '文本已复制')"
                                class="text-xs bg-white px-3 py-1.5 rounded-full shadow-sm text-gray-600 border border-gray-200 active:opacity-75">
                                复制
                            </view>
                        </view>
                    </view>
                </view>
                <view v-if="item.type === 'url'" class="mt-2">
                    <view class="bg-gray-50 p-3 rounded-lg flex items-center justify-between">
                        <view class="text-gray-600 text-sm flex-1 break-all overflow-hidden"
                            @click="openUrl(item.value)">
                            <view class="flex items-center">
                                <view class="i-carbon-link mr-1.5 text-gray-500 flex-shrink-0" style="font-size: 18px;">
                                </view>
                                <view class="truncate">{{ formatUrl(item.value) }}</view>
                            </view>
                        </view>
                        <view class="flex items-center ml-2">
                            <view @click="openUrl(item.value)"
                                class="text-xs px-3 py-1.5 rounded-full shadow-sm text-white border border-transparent active:opacity-75 mr-1.5"
                                style="background-color:var(--theme-color)">
                                打开
                            </view>
                            <view @click="showUrlDialog(item.value)"
                                class="text-xs bg-white px-3 py-1.5 rounded-full shadow-sm text-gray-600 border border-gray-200 active:opacity-75 mr-1.5">
                                详情
                            </view>
                            <view @click="copy(item.value, '链接已复制')"
                                class="text-xs bg-white px-3 py-1.5 rounded-full shadow-sm text-gray-600 border border-gray-200 active:opacity-75">
                                复制
                            </view>
                        </view>
                    </view>
                </view>

                <view v-if="item.type === 'image'" class="mt-2">
                    <image @click="previewImage(item.value)" :src="img(item.value)" mode="aspectFill"
                        class="w-full h-48 rounded-lg object-cover shadow-md" />
                    <view class="flex justify-center mt-2">
                        <view @click="previewImage(item.value)"
                            class="text-xs px-3 py-1.5 rounded-full shadow-sm text-white border border-transparent active:opacity-75 mx-1"
                            style="background-color:var(--theme-color)">
                            预览
                        </view>
                        <view @click="saveImageToPhotosAlbum(img(item.value))"
                            class="text-xs bg-white px-3 py-1.5 rounded-full shadow-sm text-gray-600 border border-gray-200 active:opacity-75 mx-1">
                            保存
                        </view>
                    </view>
                </view>

                <view v-if="item.type === 'rich_text'" class="bg-gray-50 rounded-lg">
                    <view class="text-gray-600 text-sm leading-relaxed">
                        <u-parse :content="item.value"
                            :tagStyle="{ img: 'vertical-align: top;', p: 'overflow: hidden;word-break:break-word;' }"></u-parse>
                    </view>
                </view>
            </view>
        </view>
        <view class="h-24"></view>
        <!-- 底部操作栏 -->
        <view
            class="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-100 p-4 flex items-center justify-between shadow-lg">
            <view class="flex-1">
                <u-button type="error" shape="circle"
                    @click="redirect({ url: '/addon/tk_cpa/pages/sid/partner_order?sid_key=' + sidInfo.sid_key })"
                    class="shadow-lg h-12 text-base font-medium" plain>提单记录</u-button>
            </view>
            <view class="flex-1 ml-4">
                <u-button type="error" shape="circle"
                    @click="redirect({ url: '/addon/tk_cpa/pages/sid/partner_submit?sid=' + sidInfo.sid })"
                    class="shadow-lg h-12 text-base font-semibold">新增订单</u-button>
            </view>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, reactive, computed } from 'vue';
import { getSidInfoBySid } from '@/addon/tk_cpa/api/sid'
import { onLoad } from '@dcloudio/uni-app'
import { img, getToken, redirect, copy } from '@/utils/common';
import { useLogin } from "@/hooks/useLogin";

// 预览图片
const previewImage = (url: string) => {
    uni.previewImage({
        urls: [img(url)],
        current: img(url),
        success: () => {
            // 预览成功后可以保存
            uni.showActionSheet({
                itemList: ['保存到相册'],
                success: (res) => {
                    if (res.tapIndex === 0) {
                        saveImageToAlbum(img(url));
                    }
                }
            });
        }
    });
}
// 保存图片到相册
const saveImageToAlbum = (url: string) => {
    uni.showLoading({
        title: '保存中...'
    });

    uni.downloadFile({
        url: url,
        success: (res) => {
            if (res.statusCode === 200) {
                uni.saveImageToPhotosAlbum({
                    filePath: res.tempFilePath,
                    success: () => {
                        uni.showToast({
                            title: '保存成功',
                            icon: 'success'
                        });
                    },
                    fail: () => {
                        uni.showToast({
                            title: '保存失败',
                            icon: 'error'
                        });
                    }
                });
            }
        },
        fail: () => {
            uni.showToast({
                title: '下载失败',
                icon: 'error'
            });
        },
        complete: () => {
            uni.hideLoading();
        }
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
const queryParams = ref<any>({});

// 处理标签数据
const labels = computed(() => {
    if (sidInfo.value?.act_info?.labelText && Array.isArray(sidInfo.value.act_info.labelText)) {
        return sidInfo.value.act_info.labelText.filter((item: string) => item !== '');
    }
    return [];
});

const addPartnerEvent = () => {
    // 检查是否有活动信息
    if (!sidInfo.value?.act_info) {
        uni.showToast({
            title: '当前项目暂停推广',
            icon: 'none'
        });
        return;
    }

    // 使用保存的sid信息
    if (queryParams.value?.sid) {
        redirect({
            url: '/addon/tk_cpa/pages/sid/partner_add?sid=' + queryParams.value.sid
        });
    } else {
        uni.showToast({
            title: '缺少必要参数',
            icon: 'none'
        });
    }
}

onLoad((query: any) => {
    queryParams.value = query;
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
