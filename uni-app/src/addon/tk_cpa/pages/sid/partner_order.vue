<template>
    <view class="min-h-[100vh] w-full bg-gradient-to-b from-gray-50 to-gray-100" :style="themeColor()">
        <mescroll-body ref="mescrollRef" @init="mescrollInit" @down="downCallback" @up="upCallback" :auto="false">
            <!-- 订单为空时显示 -->
            <view v-if="listData.length === 0 && loading" class="flex flex-col items-center justify-center pt-12">
                <image src="/static/images/empty.png" class="w-32 h-32 mb-4" mode="aspectFit"></image>
                <view class="text-gray-400 text-sm">暂无订单数据</view>
            </view>

            <!-- 订单列表 -->
            <view class="px-4 py-3" v-else>
                <view v-for="item in listData" :key="item.id"
                    class="bg-white rounded-xl mb-3 overflow-hidden shadow-sm transition-all duration-300 active:scale-[0.98]"
                    @click="goDetail(item.sid)">
                    <!-- 订单头部 -->
                    <view class="flex items-center justify-between p-3 border-b border-gray-100">
                        <view class="flex items-center">
                            <text class="text-sm font-medium line-clamp-1">订单号: {{ item.parentOrderId }}</text>
                        </view>
                        <view>
                            <u-tag :text="item.status_name" :type="getStatusType(item.status)" size="mini"
                                :plain="true">
                            </u-tag>
                        </view>
                    </view>

                    <!-- 订单内容 -->
                    <view class="p-3">
                        <view class="text-base font-semibold mb-2 line-clamp-1">{{ item.orderTitle }}</view>

                        <!-- 订单信息 -->
                        <view class="flex justify-between items-center mt-2">
                            <view class="text-gray-500 text-xs">
                                创建时间: {{ formatDate(item.create_time) }}
                            </view>
                            <view class="flex items-center">
                                <u-icon name="arrow-right" color="#999" size="14"></u-icon>
                            </view>
                        </view>
                    </view>
                </view>
            </view>

            <!-- 加载中和无更多数据提示 -->
            <u-loadmore v-if="listData.length > 0" :status="loadStatus"></u-loadmore>
        </mescroll-body>
        <tabbar addon="tk_cpa" />
    </view>
</template>

<script lang="ts">
// 声明扩展Vue实例类型
declare module 'vue' {
    interface ComponentCustomProperties {
        themeColor: () => string;
    }
}
</script>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { onPullDownRefresh, onShow } from '@dcloudio/uni-app'
import {
    getOrderBySidKey
} from '@/addon/tk_cpa/api/order'
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
import useMescroll from '@/components/mescroll/hooks/useMescroll.js'
import { onPageScroll, onReachBottom, onLoad } from '@dcloudio/uni-app'
import { redirect } from '@/utils/common';
import useConfigStore from '@/stores/config';

// 定义订单项接口类型
interface OrderItem {
    id: number;
    parentOrderId: string;
    orderTitle: string;
    status: string | number;
    status_name: string;
    create_time: string;
    [key: string]: any; // 允许其他属性
}

const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);

const listData = ref<OrderItem[]>([]);
const loading = ref<boolean>(false);
const mescrollRef = ref(null);
const sid_key = ref('');
const hasValidSid = ref(false);
const loadStatus = ref('loading');

// 上拉回调
const upCallback = (mescroll: any) => {
    // 只有在sid_key有效时才请求数据
    if (hasValidSid.value && sid_key.value) {
        getOrderListFn(mescroll);
    } else {
        // 如果sid_key无效，直接结束加载并显示空数据
        mescroll.endSuccess(0);
        loadStatus.value = 'nomore';
    }
}

onLoad((options: any) => {
    if (options.sid_key) {
        sid_key.value = options.sid_key;
        hasValidSid.value = true;

        // 确保DOM更新后再触发加载
        setTimeout(() => {
            if (mescrollRef.value) {
                const mescroll = getMescroll();
                if (mescroll) {
                    mescroll.resetUpScroll();
                }
            }
        }, 100);
    } else {
        uni.showToast({
            title: '参数错误',
            icon: 'none'
        });
        hasValidSid.value = false;
    }
})

const getOrderListFn = (mescroll: any) => {
    // 确保有sid_key才执行请求
    if (!sid_key.value || !hasValidSid.value) {
        mescroll.endErr();
        uni.showToast({
            title: '缺少必要参数',
            icon: 'none'
        });
        return;
    }

    loading.value = false;
    loadStatus.value = 'loading';
    const data = {
        page: mescroll.num,
        page_size: mescroll.size,
        sid_key: sid_key.value
    };

    getOrderBySidKey(data).then((res: any) => {
        const newArr = res.data.data;
        mescroll.endSuccess(newArr.length);
        if (mescroll.num == 1) {
            listData.value = []; // 如果是第一页需手动制空列表
        }
        listData.value = listData.value.concat(newArr);
        loading.value = true;

        // 更新加载状态
        if (newArr.length < mescroll.size) {
            loadStatus.value = 'nomore';
        } else {
            loadStatus.value = 'loading';
        }
    }).catch((e) => {
        loading.value = true;
        mescroll.endErr(); // 请求失败, 结束加载
        loadStatus.value = 'loadmore';
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

// 根据状态获取tag类型
const getStatusType = (status: number | string) => {
    const statusMap: Record<string, string> = {
        '0': 'warning',  // 待处理
        '1': 'primary',  // 处理中
        '2': 'success',  // 已完成
        '3': 'error',    // 已取消
        '4': 'info'      // 其他状态
    };
    return statusMap[status?.toString()] || 'info';
}

const goDetail = (sid: number) => {
    redirect({ url: `/addon/tk_cpa/pages/sid/partner_query?sid=${sid}` });
}

// 页面显示时执行
onShow(() => {
    // 如果已有有效的sid_key，可以在页面显示时刷新列表
    if (hasValidSid.value && sid_key.value && mescrollRef.value) {
        const mescroll = getMescroll();
        if (mescroll) {
            mescroll.resetUpScroll();
        }
    }
});
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