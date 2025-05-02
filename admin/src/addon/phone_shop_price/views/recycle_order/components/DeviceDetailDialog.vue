<template>
    <el-dialog v-model="dialogVisible" title="设备详情" width="600" class="diy-dialog-wrap" :destroy-on-close="true">
        <div v-if="deviceData" class="device-detail">
            <!-- 设备基本信息 -->
            <div class="detail-section">
                <h3 class="section-title">基本信息</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="label">设备ID:</span>
                        <span class="value">{{ deviceData.id }}</span>
                    </div>
                    <div class="info-item">
                        <span class="label">IMEI:</span>
                        <span class="value">{{ deviceData.imei }}</span>
                    </div>
                    <div class="info-item">
                        <span class="label">型号:</span>
                        <span class="value">{{ deviceData.model }}</span>
                    </div>
                    <div class="info-item">
                        <span class="label">状态:</span>
                        <span class="value status-tag" :class="'status-' + deviceData.status">
                            {{ deviceData.status_name }}
                        </span>
                    </div>
                </div>
            </div>

            <!-- 质检信息 -->
            <div class="detail-section">
                <h3 class="section-title">质检信息</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="label">质检状态:</span>
                        <span class="value">{{ deviceData.check_status === 1 ? '通过' :
                            (deviceData.check_status === 2 ? '退回' : '未质检') }}</span>
                    </div>
                    <div class="info-item">
                        <span class="label">质检结果:</span>
                        <span class="value">{{ deviceData.check_result || '暂无' }}</span>
                    </div>
                    <div class="info-item">
                        <span class="label">质检时间:</span>
                        <span class="value">{{ deviceData.check_at || '暂无' }}</span>
                    </div>
                </div>

                <!-- 质检图片 -->
                <div v-if="deviceData.check_images" class="check-images">
                    <h4>质检图片:</h4>
                    <div class="image-list">

                        <el-image v-for="(imgUrl, index) in checkImagesArray" :key="index" :src="img(imgUrl)"
                            fit="cover" class="check-image-thumbnail" @click="previewImage(checkImagesArray)" />
                    </div>
                </div>
            </div>

            <!-- 价格信息 -->
            <div class="detail-section">
                <h3 class="section-title">价格信息</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="label">初始价格:</span>
                        <span class="value price">¥{{ deviceData.initial_price }}</span>
                    </div>
                    <div class="info-item">
                        <span class="label">最终价格:</span>
                        <span class="value price highlight">¥{{ deviceData.final_price }}</span>
                    </div>
                    <div class="info-item full-width">
                        <span class="label">价格备注:</span>
                        <span class="value">{{ deviceData.price_remark || '无' }}</span>
                    </div>
                </div>
            </div>

            <!-- 订单信息 -->
            <div class="detail-section" v-if="deviceData.order">
                <h3 class="section-title">订单信息</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="label">订单ID:</span>
                        <span class="value">{{ deviceData.order.id }}</span>
                    </div>
                    <div class="info-item">
                        <span class="label">订单状态:</span>
                        <span class="value">{{ deviceData.order.status_name }}</span>
                    </div>
                    <div class="info-item">
                        <span class="label">配送方式:</span>
                        <span class="value">{{ deviceData.order.delivery_type_name }}</span>
                    </div>
                    <div class="info-item">
                        <span class="label">快递单号:</span>
                        <span class="value">{{ deviceData.order.express_no || '无' }}</span>
                    </div>
                </div>
            </div>

            <!-- 备注信息 -->
            <div class="detail-section">
                <h3 class="section-title">备注</h3>
                <div class="remark-content">
                    {{ deviceData.remark || '无备注' }}
                </div>
            </div>

            <!-- 时间信息 -->
            <div class="detail-section">
                <h3 class="section-title">时间信息</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <span class="label">创建时间:</span>
                        <span class="value">{{ deviceData.create_at }}</span>
                    </div>
                    <div class="info-item">
                        <span class="label">更新时间:</span>
                        <span class="value">{{ deviceData.update_at }}</span>
                    </div>
                </div>
            </div>
        </div>
        <div v-else class="empty-data">
            <el-empty description="暂无设备详情数据" />
        </div>
    </el-dialog>

    <el-image-viewer :url-list="previewImageList" v-if="imageViewer.show" @close="imageViewer.show = false"
        :initial-index="imageViewer.index" :zoom-rate="1" />
</template>

<script setup lang="ts">
import { ref, defineProps, defineEmits, watch, computed, reactive } from 'vue'
import { img } from '@/utils/common'

// 定义设备信息接口
interface DeviceOrder {
    id: number | string;
    status_name: string;
    delivery_type_name: string;
    express_no?: string;
    [key: string]: any;
}

interface DeviceDetail {
    id: number | string;
    imei: string;
    model: string;
    status: number | string;
    status_name: string;
    check_status?: number;
    check_result?: string;
    check_at?: string;
    check_images?: string;
    initial_price: number | string;
    final_price?: number | string;
    price_remark?: string;
    remark?: string;
    create_at: string;
    update_at: string;
    order?: DeviceOrder;
    [key: string]: any;
}

const props = defineProps({
    visible: {
        type: Boolean,
        default: false
    },
    device: {
        type: Object as () => DeviceDetail | null,
        default: null
    }
})

const emit = defineEmits(['update:visible', 'closed'])

// 内部状态
const dialogVisible = ref(props.visible)
const deviceData = ref<DeviceDetail | null>(props.device)

// 计算质检图片数组
const checkImagesArray = computed(() => {
    if (!deviceData.value?.check_images) return []
    return deviceData.value.check_images.split(',').filter(url => url)
})

// 监听visible属性变化
watch(() => props.visible, (newVal) => {
    dialogVisible.value = newVal
})

// 监听device属性变化
watch(() => props.device, (newVal) => {
    deviceData.value = newVal
}, { deep: true })

// 监听内部visible状态变化，同步到父组件
watch(dialogVisible, (newVal) => {
    emit('update:visible', newVal)
    if (!newVal) {
        emit('closed')
    }
})

// 预览图片
const imageViewer = reactive({
    show: false,
    index: 0
})
const previewImageList = ref([])
const previewImage = (row: any) => {
    imageViewer.show = true
    // 判断 row.images 中是否是完整路径, 如果是 则不管 如果不是则通过 配置的图片路径 添加完中的路径
    previewImageList.value = row
}

// const getImageUrl = (url) => {
//     // 检查 URL 是否已经包含 http 或 https
//     if (url.startsWith('http://') || url.startsWith('https://')) {
//         // URL 已经包含协议，直接返回
//         return url;
//     } else {
//         // URL 不包含协议，添加 VITE_IMG_DOMAIN 前缀
//         return import.meta.env.VITE_IMG_DOMAIN + url;
//     }
// };

</script>

<style lang="scss" scoped>
.device-detail {
    max-height: 70vh;
    overflow-y: auto;
    padding: 0 10px;

    .detail-section {
        margin-bottom: 20px;

        .section-title {
            font-size: 16px;
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 1px solid #ebeef5;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;

            .info-item {
                display: flex;
                flex-direction: column;

                &.full-width {
                    grid-column: span 2;
                }

                .label {
                    font-size: 12px;
                    color: #909399;
                    margin-bottom: 4px;
                }

                .value {
                    font-size: 14px;
                    color: #303133;

                    &.price {
                        color: #ff6b00;
                        font-weight: 600;
                    }

                    &.highlight {
                        color: #f56c6c;
                        font-size: 16px;
                    }
                }
            }
        }

        .remark-content {
            padding: 12px;
            background-color: #f9f9f9;
            border-radius: 4px;
            line-height: 1.6;
            color: #606266;
        }
    }

    .check-images {
        margin-top: 16px;

        h4 {
            font-size: 14px;
            margin-bottom: 8px;
        }

        .image-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;

            .check-image-thumbnail {
                width: 80px;
                height: 80px;
                border-radius: 4px;
                object-fit: cover;
                cursor: pointer;
                transition: transform 0.2s;

                &:hover {
                    transform: scale(1.05);
                }
            }
        }
    }
}

.status-tag {
    display: inline-block;
    padding: 2px 8px;
    border-radius: 4px;
    font-size: 12px;

    &.status-1 {
        background-color: #e6f7ff;
        color: #1890ff;
    }

    &.status-2 {
        background-color: #f6ffed;
        color: #52c41a;
    }

    &.status-3 {
        background-color: #fff7e6;
        color: #fa8c16;
    }

    &.status-4 {
        background-color: #fff1f0;
        color: #f5222d;
    }

    &.status-5 {
        background-color: #f9f0ff;
        color: #722ed1;
    }
}

.empty-data {
    padding: 40px 0;
}
</style>