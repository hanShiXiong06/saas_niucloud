<template>
    <view class="order-info-component">
        <view class="component-header">
            <view class="header-title">{{ value.text || '订单中心' }}</view>
            <view class="header-more" @click="goToOrderList">
                {{ value.more?.text || '全部订单' }}
                <text class="iconfont icon-right"></text>
            </view>
        </view>

        <view class="order-status-cards">
            <view v-for="(item, index) in orderStatusList" :key="index" class="status-card"
                @click="goToOrderList(item.status)">
                <view class="card-icon" :class="item.iconClass">
                    <text class="iconfont" :class="item.icon"></text>
                </view>
                <text class="card-title" :style="getTextStyle()">{{ item.title }}</text>
                <view class="badge" v-if="item.count > 0">{{ item.count }}</view>
            </view>
        </view>
    </view>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { getOrderStatistics } from '@/addon/running/api/order'

// 组件属性定义
const props = defineProps({
    value: {
        type: Object as PropType<{
            textColor?: string;
            fontSize?: number;
            fontWeight?: string;
            text?: string;
            more?: {
                text: string;
                color: string;
            },
            item?: {
                fontSize?: number;
                fontWeight?: string;
                color?: string;
            }
        }>,
        default: () => ({})
    }
})

// 订单状态列表
const orderStatusList = reactive([
    { title: '待付款', status: 1, icon: 'icon-pay', iconClass: 'bg-yellow', count: 0 },
    { title: '待接单', status: 2, icon: 'icon-takeaway', iconClass: 'bg-blue', count: 0 },
    { title: '已接单', status: 3, icon: 'icon-delivery', iconClass: 'bg-green', count: 0 },
    { title: '配送中', status: 4, icon: 'icon-delivery', iconClass: 'bg-green', count: 0 },
    { title: '已完成', status: 5, icon: 'icon-success', iconClass: 'bg-purple', count: 0 }
])

// 获取文本样式
const getTextStyle = () => {
    const style = {
        color: props.value.item?.color || props.value.textColor || '#303133',
        fontSize: `${props.value.item?.fontSize || 12}px`,
        fontWeight: props.value.item?.fontWeight || 'normal'
    }
    return style
}

// 获取订单统计数据
onMounted(async () => {
    try {
        const response = await getOrderStatistics()
        if (response && response.data) {
            const { data } = response

            // 更新订单数量
            orderStatusList.forEach(item => {
                switch (item.status) {
                    case 1:
                        item.count = data.unpaid || 0
                        break
                    case 2:
                        item.count = data.untaken || 0
                        break
                    case 3:
                        item.count = data.taken || 0
                        break
                    case 4:
                        item.count = data.delivering || 0
                        break
                    case 5:
                        item.count = data.completed || 0
                        break
                }
            })
        }
    } catch (error) {
        console.error('获取订单统计失败', error)
    }
})

// 跳转到订单列表页
const goToOrderList = (status?: number) => {
    let url = '/addon/running/pages/order/list'


    if (!isNaN(status)) {
        url += `?status=${status}`
    }

    uni.navigateTo({
        url,
        fail: (err) => {
            console.error('导航失败:', err)
            uni.showToast({
                title: '页面跳转失败',
                icon: 'none'
            })
        }
    })
}
</script>

<style lang="scss" scoped>
.order-info-component {
    background-color: #fff;
    border-radius: 16rpx;
    margin: 20rpx;
    padding: 30rpx;
    box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);

    .component-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30rpx;

        .header-title {
            font-size: v-bind('`${props.value.fontSize || 16}px`');
            font-weight: v-bind('props.value.fontWeight || "600"');
            color: v-bind('props.value.textColor || "#303133"');
        }

        .header-more {
            font-size: 24rpx;
            color: v-bind('props.value.more?.color || "#999999"');
            display: flex;
            align-items: center;

            .iconfont {
                font-size: 22rpx;
                margin-left: 4rpx;
            }

            &:active {
                opacity: 0.7;
            }
        }
    }

    .order-status-cards {
        display: flex;
        justify-content: space-between;

        .status-card {
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            flex: 1;
            padding: 20rpx 0;

            &:active {
                opacity: 0.7;
            }

            .card-icon {
                width: 80rpx;
                height: 80rpx;
                border-radius: 50%;
                display: flex;
                justify-content: center;
                align-items: center;
                margin-bottom: 12rpx;

                .iconfont {
                    font-size: 36rpx;
                    color: #fff;
                }

                &.bg-yellow {
                    background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
                }

                &.bg-blue {
                    background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
                }

                &.bg-green {
                    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                }

                &.bg-purple {
                    background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
                }
            }

            .card-title {
                font-size: 24rpx;
            }

            .badge {
                position: absolute;
                top: 10rpx;
                right: 50%;
                transform: translateX(30rpx);
                background-color: #ef4444;
                color: #fff;
                font-size: 20rpx;
                min-width: 32rpx;
                height: 32rpx;
                border-radius: 16rpx;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 0 6rpx;
            }
        }
    }
}
</style>