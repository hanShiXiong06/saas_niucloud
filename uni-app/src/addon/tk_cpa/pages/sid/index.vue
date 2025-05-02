<template>
    <view class="min-h-[100vh] w-full bg-gradient-to-b from-gray-50 to-gray-100" :style="themeColor()">
        <mescroll-body ref="mescrollRef" @init="mescrollInit" @down="downCallback" @up="getSidListFn">
            <view class="px-3 py-2 min-h-screen">
                <!-- 顶部状态筛选 -->
                <view class="bg-white rounded-lg mb-3 shadow-sm p-3">
                    <scroll-view scroll-x class="whitespace-nowrap pb-1">
                        <view class="inline-flex space-x-2">
                            <view
                                class="px-3 py-1.5 rounded-full text-sm transition-all duration-200 flex items-center justify-center"
                                :class="status === '' ? 'bg-primary text-white' : 'bg-gray-100 text-gray-600'"
                                @click="changeStatus('')">
                                全部
                            </view>
                            <view v-for="(item, idx) in statusList" :key="idx"
                                class="px-3 py-1.5 rounded-full text-sm transition-all duration-200 flex items-center justify-center"
                                :class="status === String(idx) ? 'bg-primary text-white' : 'bg-gray-100 text-gray-600'"
                                @click="changeStatus(String(idx))">
                                {{ item }}
                            </view>
                        </view>
                    </scroll-view>
                </view>

                <!-- 顶部标签页 -->
                <mescroll-empty v-if="!listData?.length" :option="{ tip: '暂无推广码数据' }"></mescroll-empty>

                <view v-for="(item, index) in listData" :key="index"
                    class="bg-white rounded-lg mb-3 shadow-sm hover:shadow-md transition-all duration-300 active:scale-[0.98] overflow-hidden"
                    @click="goDetail(item.id)">
                    <!-- 推广码名称和状态 -->
                    <view class="flex justify-between items-center px-3 py-2 border-b border-gray-100">
                        <view class="text-base font-bold text-gray-800 truncate max-w-[70%]">{{ item.nickName }}</view>
                        <view v-if="item.status == 0"
                            class="px-2 py-0.5 text-xs rounded-full bg-yellow-100 text-yellow-600"
                            @click.stop="refreshEvent(item.id)">
                            刷新状态
                        </view>
                        <view v-else-if="item.status == 1"
                            class="px-2 py-0.5 text-xs rounded-full bg-green-100 text-green-600">
                            成功
                        </view>
                        <view v-else-if="item.status == 2"
                            class="px-2 py-0.5 text-xs rounded-full bg-red-100 text-red-600">
                            失败
                        </view>
                    </view>

                    <!-- 内容区域 -->
                    <view class="p-3 pt-0">
                        <!-- 项目信息 -->
                        <view class="flex items-center mb-2">
                            <text class="text-gray-500 text-xs">项目：</text>
                            <text class="text-gray-800 text-[28rpx] font-bold flex-1">{{ item.cpaProjectId_name
                            }}</text>
                        </view>

                        <!-- 二维码和信息部分布局 -->
                        <view class="flex" v-if="item.promotionCode != ''">
                            <!-- 左侧信息 -->
                            <view class="flex-1 bg-gray-50 rounded-lg p-2 mr-2">
                                <view class="flex flex-col gap-1.5 text-xs">
                                    <view class="flex items-center">
                                        <text class="w-[60px] text-gray-500">手机号码:</text>
                                        <text class="text-gray-700 font-medium">{{ item.phone }}</text>
                                    </view>

                                    <view class="flex items-center">
                                        <text class="w-[60px] text-gray-500">推广标识:</text>
                                        <text class="text-gray-700 font-medium">{{ item.sid }}</text>
                                    </view>

                                    <view class="flex items-center">
                                        <text class="w-[60px] text-gray-500">申请时间:</text>
                                        <text class="text-gray-700 font-medium">{{ item.create_time
                                            }}</text>
                                    </view>
                                </view>
                            </view>

                            <!-- 右侧二维码 -->
                            <view class="flex flex-col items-center justify-center bg-gray-50 rounded-lg p-2">
                                <image :src="img(item.promotionCode)"
                                    class="w-16 h-16 rounded-md bg-white border border-gray-100" mode="aspectFit"
                                    @click.stop="previewImage(img(item.promotionCode))">
                                </image>
                            </view>
                        </view>
                    </view>
                </view>
            </view>
        </mescroll-body>
        <tabbar addon="tk_cpa" />
    </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onPullDownRefresh, onShow } from '@dcloudio/uni-app'
import {
    getSidList, asyncStatus, getStatusList
} from '@/addon/tk_cpa/api/sid'
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
import useMescroll from '@/components/mescroll/hooks/useMescroll.js'
import { onPageScroll, onReachBottom } from '@dcloudio/uni-app'
import { img, redirect, copy } from '@/utils/common';
import useConfigStore from '@/stores/config';

const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
const status = ref('');
const statusList = ref<string[]>([]);
getStatusList().then((res: any) => {
    statusList.value = res.data;
});
const listData = ref();
const loading = ref<boolean>(false);
const mescrollRef = ref(null);
const refreshEvent = (id: number) => {
    asyncStatus(id).then((res) => {
        console.log(res);
        getSidListFn(getMescroll());
    })
}
const getSidListFn = (mescroll: any) => {
    const data = ref<{ page?: number, page_size?: number, status?: string }>({});
    loading.value = false;
    data.value.page = mescroll.num;
    data.value.page_size = mescroll.size;
    data.value.status = status.value;
    getSidList(data.value).then((res: any) => {
        const newArr = res.data.data;
        mescroll.endSuccess(newArr.length);
        if (mescroll.num == 1) {
            listData.value = []; //如果是第一页需手动制空列表
        }
        listData.value = listData.value.concat(newArr);
        loading.value = true;
    }).catch((e) => {
        loading.value = true;
        mescroll.endErr(); // 请求失败, 结束加载
    })
}

// 格式化日期，只保留月日和时间
const formatDate = (dateStr: string) => {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    const hour = date.getHours().toString().padStart(2, '0');
    const minute = date.getMinutes().toString().padStart(2, '0');
    return `${month}-${day} ${hour}:${minute}`;
}

const goDetail = (id: number) => {
    redirect({ url: `/addon/tk_cpa/pages/sid/detail?id=${id}` });
}

// 自动模拟一条数据，当数据为空时显示
onShow(() => {

});

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

const changeStatus = (value: string) => {
    if (status.value === value) return; // 避免重复切换
    status.value = value;
    loading.value = true; // 设置加载状态

    // 重置列表并刷新数据
    const mescroll = getMescroll();
    if (mescroll) {
        mescroll.resetUpScroll();
    }
}
</script>

<style lang="scss" scoped>
@import '@/addon/tk_cpa/utils/styles/common.scss';

/* 隐藏滚动条 */
::-webkit-scrollbar {
    display: none;
}

/* 文本截断 */
.line-clamp-1 {
    display: -webkit-box;
    -webkit-line-clamp: 1;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

/* 点击效果 */
.active\:scale-\[0\.98\]:active {
    transform: scale(0.98);
}

/* 过渡动画 */
.transition-all {
    transition-property: all;
    transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

.duration-300 {
    transition-duration: 300ms;
}

.hover\:shadow-md:hover {
    --tw-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
    --tw-shadow-colored: 0 4px 6px -1px var(--tw-shadow-color), 0 2px 4px -2px var(--tw-shadow-color);
    box-shadow: var(--tw-ring-offset-shadow, 0 0 #0000), var(--tw-ring-shadow, 0 0 #0000), var(--tw-shadow);
}

/* 状态筛选按钮样式 */
.bg-primary {
    background-color: var(--primary-color, #3c9cff);
}

/* 滚动容器 */
scroll-view {
    &::-webkit-scrollbar {
        display: none;
    }
}
</style>