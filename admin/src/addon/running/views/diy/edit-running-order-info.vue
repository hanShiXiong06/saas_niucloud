<template>
    <div class="edit-running-order-info">
        <el-form label-width="120px" :model="orderConfig" class="edit-form">
            <el-divider content-position="left">基础设置</el-divider>

            <el-form-item label="组件标题">
                <el-input v-model="orderConfig.text" placeholder="请输入组件标题" />
            </el-form-item>

            <el-form-item label="标题颜色">
                <el-color-picker v-model="orderConfig.textColor" />
            </el-form-item>

            <el-form-item label="标题字号">
                <el-input-number v-model="orderConfig.fontSize" :min="12" :max="30" />
            </el-form-item>

            <el-form-item label="标题粗细">
                <el-select v-model="orderConfig.fontWeight">
                    <el-option label="正常" value="normal" />
                    <el-option label="加粗" value="bold" />
                </el-select>
            </el-form-item>

            <el-divider content-position="left">更多设置</el-divider>

            <el-form-item label="更多文字">
                <el-input v-model="orderConfig.more.text" placeholder="请输入更多文字" />
            </el-form-item>

            <el-form-item label="更多颜色">
                <el-color-picker v-model="orderConfig.more.color" />
            </el-form-item>

            <el-divider content-position="left">状态项设置</el-divider>

            <el-form-item label="项目字号">
                <el-input-number v-model="orderConfig.item.fontSize" :min="10" :max="24" />
            </el-form-item>

            <el-form-item label="项目颜色">
                <el-color-picker v-model="orderConfig.item.color" />
            </el-form-item>

            <el-form-item label="项目粗细">
                <el-select v-model="orderConfig.item.fontWeight">
                    <el-option label="正常" value="normal" />
                    <el-option label="加粗" value="bold" />
                </el-select>
            </el-form-item>

            <el-form-item label="订单状态配置">
                <el-table :data="orderStatusList" border style="width: 100%">
                    <el-table-column prop="title" label="状态名称" width="120">
                        <template #default="{ row, $index }">
                            <el-input v-model="row.title" placeholder="请输入状态名称" />
                        </template>
                    </el-table-column>

                    <el-table-column prop="icon" label="图标" width="120">
                        <template #default="{ row, $index }">
                            <el-select v-model="row.icon" placeholder="请选择图标">
                                <el-option label="支付" value="icon-pay" />
                                <el-option label="快递" value="icon-takeaway" />
                                <el-option label="配送" value="icon-delivery" />
                                <el-option label="完成" value="icon-success" />
                            </el-select>
                        </template>
                    </el-table-column>

                    <el-table-column prop="iconClass" label="图标颜色" width="120">
                        <template #default="{ row, $index }">
                            <el-select v-model="row.iconClass" placeholder="请选择颜色">
                                <el-option label="黄色" value="bg-yellow" />
                                <el-option label="蓝色" value="bg-blue" />
                                <el-option label="绿色" value="bg-green" />
                                <el-option label="紫色" value="bg-purple" />
                            </el-select>
                        </template>
                    </el-table-column>

                    <el-table-column prop="status" label="状态值" width="120">
                        <template #default="{ row, $index }">
                            <el-input-number v-model="row.status" :min="0" :max="10" />
                        </template>
                    </el-table-column>

                    <el-table-column label="操作">
                        <template #default="{ row, $index }">
                            <el-button type="danger" @click="removeOrderStatus($index)"
                                :disabled="orderStatusList.length <= 1">
                                删除
                            </el-button>
                        </template>
                    </el-table-column>
                </el-table>

                <div class="mt-10">
                    <el-button type="primary" @click="addOrderStatus">
                        添加状态
                    </el-button>
                </div>
            </el-form-item>

            <el-form-item>
                <div class="preview-container">
                    <h3>组件预览</h3>
                    <div class="order-info-preview">
                        <div class="component-header">
                            <div class="header-title" :style="titleStyle">
                                {{ orderConfig.text }}
                            </div>
                            <div class="header-more" :style="{ color: orderConfig.more.color }">
                                {{ orderConfig.more.text }}
                                <i class="el-icon-arrow-right"></i>
                            </div>
                        </div>

                        <div class="order-status-cards">
                            <div v-for="(item, index) in orderStatusList" :key="index" class="status-card">
                                <div class="card-icon" :class="item.iconClass">
                                    <i class="el-icon-s-order"></i>
                                </div>
                                <span class="card-title" :style="itemStyle">{{ item.title }}</span>
                                <div class="badge" v-if="index === 0">2</div>
                            </div>
                        </div>
                    </div>
                </div>
            </el-form-item>
        </el-form>
    </div>
</template>

<script lang="ts">
import { defineComponent, reactive, computed } from 'vue'

export default defineComponent({
    name: 'EditRunningOrderInfo',
    setup() {
        // 订单中心配置
        const orderConfig = reactive({
            text: '订单中心',
            textColor: '#303133',
            fontSize: 16,
            fontWeight: 'normal',
            more: {
                text: '全部订单',
                color: '#999999'
            },
            item: {
                fontSize: 12,
                fontWeight: 'normal',
                color: '#303133'
            }
        })

        // 订单状态列表
        const orderStatusList = reactive([
            { title: '待付款', status: 1, icon: 'icon-pay', iconClass: 'bg-yellow' },
            { title: '待接单', status: 2, icon: 'icon-takeaway', iconClass: 'bg-blue' },
            { title: '已接单', status: 3, icon: 'icon-delivery', iconClass: 'bg-green' },
            { title: '配送中', status: 4, icon: 'icon-delivery', iconClass: 'bg-green' },
            { title: '已完成', status: 5, icon: 'icon-success', iconClass: 'bg-purple' }
        ])

        // 添加订单状态
        const addOrderStatus = () => {
            orderStatusList.push({
                title: '新状态',
                status: orderStatusList.length + 1,
                icon: 'icon-takeaway',
                iconClass: 'bg-blue'
            })
        }

        // 删除订单状态
        const removeOrderStatus = (index: number) => {
            if (orderStatusList.length > 1) {
                orderStatusList.splice(index, 1)
            }
        }

        // 标题样式
        const titleStyle = computed(() => {
            return {
                fontSize: `${orderConfig.fontSize}px`,
                fontWeight: orderConfig.fontWeight,
                color: orderConfig.textColor
            }
        })

        // 项目样式
        const itemStyle = computed(() => {
            return {
                fontSize: `${orderConfig.item.fontSize}px`,
                fontWeight: orderConfig.item.fontWeight,
                color: orderConfig.item.color
            }
        })

        return {
            orderConfig,
            orderStatusList,
            addOrderStatus,
            removeOrderStatus,
            titleStyle,
            itemStyle
        }
    }
})
</script>

<style lang="scss" scoped>
.edit-running-order-info {
    padding: 20px;

    .edit-form {
        max-width: 800px;
    }

    .mt-10 {
        margin-top: 10px;
    }

    .preview-container {
        margin-top: 20px;
        padding: 20px;
        border: 1px solid #ebeef5;
        border-radius: 4px;

        h3 {
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 16px;
            font-weight: bold;
        }

        .order-info-preview {
            background-color: #fff;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);

            .component-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;

                .header-title {
                    font-size: 16px;
                    font-weight: 600;
                }

                .header-more {
                    font-size: 12px;
                    color: #999;
                    display: flex;
                    align-items: center;

                    i {
                        font-size: 12px;
                        margin-left: 2px;
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

                    .card-icon {
                        width: 40px;
                        height: 40px;
                        border-radius: 50%;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        margin-bottom: 6px;

                        i {
                            font-size: 18px;
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
                        font-size: 12px;
                    }

                    .badge {
                        position: absolute;
                        top: 0;
                        right: 20px;
                        background-color: #ef4444;
                        color: #fff;
                        font-size: 10px;
                        min-width: 16px;
                        height: 16px;
                        border-radius: 8px;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        padding: 0 3px;
                    }
                }
            }
        }
    }
}
</style>