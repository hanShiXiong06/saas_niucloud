<template>
    <div class="order-detail-container p-0 bg-gray-50">
        <el-skeleton v-if="loading" :rows="10" animated />

        <template v-else>
            <!-- 头部信息区域 -->
            <div
                class="bg-gradient-to-r from-blue-500/10 via-indigo-500/15 to-blue-500/10 p-5 border-b border-gray-200 shadow-sm">
                <div class="flex justify-between items-center mb-2">
                    <div class="flex items-center gap-2">
                        <span class="text-lg font-semibold text-gray-800">订单 #{{ orderData.id || '-' }}</span>
                        <el-tag size="small" class="!border-0 !font-medium !text-xs !px-3 !py-1"
                            :type="orderData.status_name === '已完成' ? 'success' : 'warning'" effect="dark">
                            {{ orderData.status_name }}
                        </el-tag>
                    </div>

                    <div class="flex items-center gap-2">
                        <el-button size="small" type="info" text @click="closeDrawer"
                            class="hover:bg-gray-100 !text-gray-700">
                            <el-icon>
                                <Close />
                            </el-icon>
                        </el-button>
                    </div>
                </div>

                <!-- 佣金卡片区域 -->
                <div class="grid grid-cols-3 gap-4 mt-4">
                    <!-- 推广佣金卡片 -->
                    <div
                        class="relative bg-white rounded-lg shadow-md hover:shadow-lg border-0 transition-all duration-300 overflow-hidden group">
                        <!-- 左侧装饰 -->
                        <div class="absolute left-0 inset-y-0 w-1 bg-blue-500 group-hover:w-1.5 transition-all"></div>
                        <!-- 右上角装饰图案 -->
                        <div class="absolute right-2 top-2 opacity-10 group-hover:opacity-20 transition-opacity">
                            <el-icon class="text-5xl text-blue-500">
                                <Money />
                            </el-icon>
                        </div>
                        <!-- 内容 -->
                        <div class="p-4 pl-5">
                            <div class="text-gray-500 text-xs font-medium mb-2 flex items-center">
                                <el-icon class="mr-1.5 text-blue-500">
                                    <Position />
                                </el-icon>
                                推广佣金
                            </div>
                            <div class="text-blue-600 text-2xl font-bold flex items-baseline">
                                <span class="text-sm mr-1">￥</span>{{ orderData.commission || '0.00' }}
                            </div>
                        </div>
                    </div>

                    <!-- 入账佣金卡片 -->
                    <div
                        class="relative bg-white rounded-lg shadow-md hover:shadow-lg border-0 transition-all duration-300 overflow-hidden group">
                        <!-- 左侧装饰 -->
                        <div class="absolute left-0 inset-y-0 w-1 bg-orange-500 group-hover:w-1.5 transition-all"></div>
                        <!-- 右上角装饰图案 -->
                        <div class="absolute right-2 top-2 opacity-10 group-hover:opacity-20 transition-opacity">
                            <el-icon class="text-5xl text-orange-500">
                                <Wallet />
                            </el-icon>
                        </div>
                        <!-- 内容 -->
                        <div class="p-4 pl-5">
                            <div class="text-gray-500 text-xs font-medium mb-2 flex items-center">
                                <el-icon class="mr-1.5 text-orange-500">
                                    <Coin />
                                </el-icon>
                                入账佣金
                            </div>
                            <div class="text-orange-600 text-2xl font-bold flex items-baseline">
                                <span class="text-sm mr-1">￥</span>{{ orderData.xgzShareFee || '0.00' }}
                            </div>
                        </div>
                    </div>

                    <!-- 结算状态卡片 -->
                    <div
                        class="relative bg-white rounded-lg shadow-md hover:shadow-lg border-0 transition-all duration-300 overflow-hidden group">
                        <!-- 左侧装饰 -->
                        <div class="absolute left-0 inset-y-0 w-1 group-hover:w-1.5 transition-all"
                            :class="orderData.is_js === 1 ? 'bg-green-500' : 'bg-red-500'"></div>
                        <!-- 右上角装饰图案 -->
                        <div class="absolute right-2 top-2 opacity-10 group-hover:opacity-20 transition-opacity">
                            <el-icon class="text-5xl"
                                :class="orderData.is_js === 1 ? 'text-green-500' : 'text-red-500'">
                                <component :is="orderData.is_js === 1 ? 'Check' : 'WarningFilled'" />
                            </el-icon>
                        </div>
                        <!-- 内容 -->
                        <div class="p-4 pl-5">
                            <div class="text-gray-500 text-xs font-medium mb-2 flex items-center">
                                <el-icon class="mr-1.5"
                                    :class="orderData.is_js === 1 ? 'text-green-500' : 'text-red-500'">
                                    <component
                                        :is="orderData.is_js === 1 ? 'CircleCheckFilled' : 'CircleCloseFilled'" />
                                </el-icon>
                                结算状态
                            </div>
                            <div class="font-bold text-xl"
                                :class="orderData.is_js === 1 ? 'text-green-600' : 'text-red-500'">
                                {{ orderData.is_js === 1 ? '已结算' : '未结算' }}
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 操作按钮区域 -->
                <div class="mt-5 flex justify-end gap-3">
                    <el-button size="small" plain @click="handleEdit"
                        class="!border-gray-300 hover:!border-blue-400 hover:!text-blue-500 transition-all !rounded-md !px-4">
                        <el-icon class="mr-1.5">
                            <Edit />
                        </el-icon>编辑
                    </el-button>
                    <el-button size="small" v-if="orderData.is_js !== 1 && orderData.xgzSettleStatus === 1"
                        type="success" @click="handleSettle" class="!border-0 shadow-sm hover:shadow !rounded-md !px-4">
                        <el-icon class="mr-1.5">
                            <Check />
                        </el-icon>结算
                    </el-button>
                </div>
            </div>

            <!-- 详情内容滚动区域 -->
            <div class="overflow-y-auto p-5 detail-scroll-area">
                <!-- 订单信息 - 两列布局 -->
                <div class="bg-white rounded-lg shadow-md mb-5 overflow-hidden">
                    <div class="bg-gray-50 border-b border-gray-100 px-5 py-3">
                        <div class="flex items-center text-gray-700">
                            <el-icon class="mr-2 text-blue-500 text-lg">
                                <Document />
                            </el-icon>
                            <span class="font-medium">基本与会员信息</span>
                        </div>
                    </div>

                    <div class="p-5">
                        <div class="grid grid-cols-2 gap-x-8 gap-y-0">
                            <!-- 第一列 -->
                            <div class="info-group">
                                <div class="info-title">
                                    <el-icon class="text-blue-500">
                                        <Document />
                                    </el-icon>
                                    <span>基本信息</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">订单标题:</span>
                                    <span class="value text-blue-600 font-medium">{{ orderData.orderTitle }}</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">产品类型:</span>
                                    <span class="value">
                                        <el-tag type="info" size="small" effect="light" class="!rounded-md">{{
                                            orderData.type_name }}</el-tag>
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="label">父订单ID:</span>
                                    <span class="value">{{ orderData.parentOrderId || '-' }}</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">订单号:</span>
                                    <span class="value">{{ orderData.orderId || '-' }}</span>
                                </div>
                            </div>

                            <!-- 第二列 -->
                            <div class="info-group">
                                <div class="info-title">
                                    <el-icon class="text-blue-500">
                                        <User />
                                    </el-icon>
                                    <span>会员信息</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">会员ID:</span>
                                    <span class="value">
                                        <div class="flex items-center">
                                            <el-avatar :size="24" class="mr-2" icon="Avatar" />
                                            {{ orderData.member_id_name }}
                                        </div>
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="label">SID:</span>
                                    <span class="value">
                                        <el-tag size="small" effect="plain"
                                            class="!border-blue-200 bg-blue-50 !rounded-md">{{
                                                orderData.sid }}</el-tag>
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="label">会员昵称:</span>
                                    <span class="value">{{ orderData.nickname || '-' }}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 表单记录显示 -->
                <div v-if="orderData.form_record_show && orderData.form_record_data?.recordsFieldList && Object.keys(orderData.form_record_data.recordsFieldList).length > 0"
                    class="bg-white rounded-lg shadow-md mb-5 overflow-hidden">
                    <div class="bg-gray-50 border-b border-gray-100 px-5 py-3">
                        <div class="flex items-center text-gray-700">
                            <el-icon class="mr-2 text-blue-500 text-lg">
                                <Document />
                            </el-icon>
                            <span class="font-medium">表单记录</span>
                        </div>
                    </div>

                    <div class="p-5">
                        <el-form-item v-for="(field, fieldKey) in orderData.form_record_data.recordsFieldList"
                            :key="fieldKey" :label="field.field_name" min-width="200">
                            <component v-if="formComponents[fieldKey]" :is="formComponents[fieldKey]" :data="field" />
                            <span v-else>{{ field.value || '' }}</span>
                        </el-form-item>
                    </div>
                </div>

                <!-- 结算信息和时间信息 -->
                <div class="bg-white rounded-lg shadow-md mb-5 overflow-hidden">
                    <div class="bg-gray-50 border-b border-gray-100 px-5 py-3">
                        <div class="flex items-center text-gray-700">
                            <el-icon class="mr-2 text-blue-500 text-lg">
                                <Wallet />
                            </el-icon>
                            <span class="font-medium">结算与时间信息</span>
                        </div>
                    </div>

                    <div class="p-5">
                        <div class="grid grid-cols-2 gap-x-8 gap-y-0">
                            <!-- 结算信息 -->
                            <div class="info-group">
                                <div class="info-title">
                                    <el-icon class="text-blue-500">
                                        <Wallet />
                                    </el-icon>
                                    <span>结算信息</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">入账佣金:</span>
                                    <span class="value text-orange-500 font-medium">￥{{ orderData.xgzShareFee }}</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">推广佣金:</span>
                                    <span class="value text-green-600 font-medium">￥{{ orderData.commission }}</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">入账状态:</span>
                                    <span class="value">
                                        <el-tag size="small"
                                            :type="orderData.xgzSettleStatus === 1 ? 'success' : 'danger'"
                                            class="!border-0 !rounded-md">
                                            {{ orderData.xgzSettleStatus === 1 ? '已入账' : '未入账' }}
                                        </el-tag>
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="label">结算状态:</span>
                                    <span class="value">
                                        <el-tag size="small" :type="orderData.is_js === 1 ? 'success' : 'danger'"
                                            class="!border-0 !rounded-md">
                                            {{ orderData.is_js === 1 ? '已结算' : '未结算' }}
                                        </el-tag>
                                    </span>
                                </div>
                                <div class="info-item">
                                    <span class="label">入账时间:</span>
                                    <span class="value">{{ orderData.xgzSettleTime || '-' }}</span>
                                </div>
                            </div>

                            <!-- 时间信息 -->
                            <div class="info-group">
                                <div class="info-title">
                                    <el-icon class="text-blue-500">
                                        <Timer />
                                    </el-icon>
                                    <span>时间信息</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">下单时间:</span>
                                    <span class="value">{{ orderData.orderTime }}</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">更新时间:</span>
                                    <span class="value">{{ orderData.modifiedTime }}</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">创建时间:</span>
                                    <span class="value">{{ orderData.create_time || '-' }}</span>
                                </div>
                                <div class="info-item">
                                    <span class="label">结算时间:</span>
                                    <span class="value">{{ orderData.is_js === 1 ? orderData.js_time : '-' }}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 可能的附加信息 -->
                <div v-if="orderData.remark" class="bg-white rounded-lg shadow-md mb-5 overflow-hidden">
                    <div class="bg-gray-50 border-b border-gray-100 px-5 py-3">
                        <div class="flex items-center text-gray-700">
                            <el-icon class="mr-2 text-blue-500 text-lg">
                                <ChatDotRound />
                            </el-icon>
                            <span class="font-medium">备注信息</span>
                        </div>
                    </div>

                    <div class="p-5">
                        <div
                            class="text-sm text-gray-700 bg-gray-50 p-4 rounded-md border border-gray-200 leading-relaxed">
                            {{ orderData.remark }}
                        </div>
                    </div>
                </div>
            </div>
        </template>
    </div>
</template>

<script lang="ts" setup>
import { ref, defineProps, defineEmits, onMounted, defineAsyncComponent, reactive, markRaw } from 'vue'
import {
    Document, User, Wallet, Timer, ChatDotRound, Close, Edit, Check, Money, Coin,
    Position, CircleCheckFilled, CircleCloseFilled, WarningFilled
} from '@element-plus/icons-vue'

interface RecordField {
    field_name: string;
    detailComponent: string;
    [key: string]: any;
}

interface FormRecordData {
    recordsFieldList?: {
        [key: string]: RecordField;
    };
}

interface OrderData {
    id?: string | number;
    form_record_data?: FormRecordData;
    [key: string]: any;
}

const props = defineProps({
    orderData: {
        type: Object as () => OrderData,
        required: true
    }
})

const emit = defineEmits(['update:visible', 'edit', 'settle'])
const loading = ref(true)

// 使用reactive存储组件
const formComponents: Record<string, any> = reactive({});

// 处理异步组件导入
const importComponent = (path: string) => {
    if (!path) return null;
    return defineAsyncComponent(() => import(path));
}

onMounted(() => {
    // 模拟数据加载
    setTimeout(() => {
        loading.value = false

        // 在数据加载完成后处理组件
        if (props.orderData.form_record_data?.recordsFieldList) {
            Object.keys(props.orderData.form_record_data.recordsFieldList).forEach(key => {
                const item = props.orderData.form_record_data.recordsFieldList[key];
                if (item.detailComponent) {
                    formComponents[key] = importComponent(item.detailComponent);
                }
            });
        }
    }, 300)
})

const closeDrawer = () => {
    emit('update:visible', false)
}

const handleEdit = () => {
    emit('edit', props.orderData)
    closeDrawer()
}

const handleSettle = () => {
    emit('settle', props.orderData)
}
</script>

<style lang="scss" scoped>
.order-detail-container {
    height: 100%;
    display: flex;
    flex-direction: column;
}

.detail-scroll-area {
    flex: 1;
    overflow-y: auto;
    height: calc(100% - 210px);
}

.info-group {
    margin-bottom: 12px;
}

.info-title {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 14px;
    font-weight: 600;
    color: #4b5563;
    margin-bottom: 8px;
    padding-bottom: 6px;
    border-bottom: 1px dashed #e9ecef;
}

.info-item {
    display: flex;
    align-items: center;
    font-size: 13px;
    padding: 6px 0;

    .label {
        color: #64748b;
        flex-shrink: 0;
        width: 80px;
        font-weight: 500;
    }

    .value {
        flex: 1;
        word-break: break-all;
        color: #334155;
    }
}

:deep(.el-tag--small) {
    height: 22px;
    padding: 0 10px;
    font-size: 12px;
}

:deep(.el-avatar--small) {
    --el-avatar-size: 24px;
}

/* 为卡片添加鼠标悬浮效果 */
.order-detail-container :deep(.el-icon.text-5xl) {
    font-size: 3rem;
    line-height: 1;
}

/* 为卡片添加动画过渡效果 */
.order-detail-container .relative.bg-white {
    transition: all 0.3s ease;

    &:hover {
        transform: translateY(-3px);
    }
}
</style>