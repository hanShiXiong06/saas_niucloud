<template>
    <el-dialog v-model="showDialog" title="订单审核" width="700px" class="diy-dialog-wrap" :destroy-on-close="true"
        top="5vh">
        <el-form :model="formData" label-width="100px" ref="formRef" :rules="formRules"
            class="page-form bg-gray-50 p-3 rounded-lg" v-loading="loading">

            <!-- 头部状态信息 -->
            <div
                class="bg-gradient-to-r from-blue-500/10 via-indigo-500/15 to-blue-500/10 p-3 border-b border-gray-200 shadow-sm mb-3 rounded-lg">
                <div class="flex justify-between items-center">
                    <div class="flex items-center gap-2">
                        <span class="text-base font-semibold text-gray-800">订单 #{{ formData.id || '-' }}</span>
                        <el-tag v-if="formData.status_name" size="small"
                            class="!border-0 !font-medium !text-xs !px-2 !py-0.5"
                            :type="formData.status_name === '已完成' ? 'success' : 'warning'" effect="dark">
                            {{ formData.status_name }}
                        </el-tag>
                    </div>
                </div>

                <!-- 佣金信息区域 -->
                <div class="grid grid-cols-3 gap-2 mt-2">
                    <!-- 推广佣金 -->
                    <div class="bg-white rounded-md shadow-sm border-0 p-2 relative">
                        <div class="absolute left-0 inset-y-0 w-1 bg-blue-500"></div>
                        <div class="pl-3">
                            <div class="text-gray-500 text-xs font-medium flex items-center">
                                <el-icon class="mr-1 text-blue-500">
                                    <Position />
                                </el-icon>
                                推广佣金
                            </div>
                            <div class="text-blue-600 text-lg font-bold flex items-baseline">
                                <span class="text-xs mr-0.5">￥</span>{{ formData.commission || '0.00' }}
                            </div>
                        </div>
                    </div>

                    <!-- 入账佣金 -->
                    <div class="bg-white rounded-md shadow-sm border-0 p-2 relative">
                        <div class="absolute left-0 inset-y-0 w-1 bg-orange-500"></div>
                        <div class="pl-3">
                            <div class="text-gray-500 text-xs font-medium flex items-center">
                                <el-icon class="mr-1 text-orange-500">
                                    <Coin />
                                </el-icon>
                                入账佣金
                            </div>
                            <div class="text-orange-600 text-lg font-bold flex items-baseline">
                                <span class="text-xs mr-0.5">￥</span>{{ formData.xgzShareFee || '0.00' }}
                            </div>
                        </div>
                    </div>

                    <!-- 结算状态 -->
                    <div class="bg-white rounded-md shadow-sm border-0 p-2 relative">
                        <div class="absolute left-0 inset-y-0 w-1"
                            :class="formData.is_js === '1' ? 'bg-green-500' : 'bg-red-500'"></div>
                        <div class="pl-3">
                            <div class="text-gray-500 text-xs font-medium flex items-center">
                                <el-icon class="mr-1"
                                    :class="formData.is_js === '1' ? 'text-green-500' : 'text-red-500'">
                                    <component
                                        :is="formData.is_js === '1' ? 'CircleCheckFilled' : 'CircleCloseFilled'" />
                                </el-icon>
                                结算状态
                            </div>
                            <div class="font-bold text-base"
                                :class="formData.is_js === '1' ? 'text-green-600' : 'text-red-500'">
                                {{ formData.is_js === '1' ? '已结算' : '未结算' }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-1 gap-3">
                <!-- 结算信息 -->
                <div class="bg-white rounded-md shadow-sm overflow-hidden">
                    <div class="bg-gray-50 border-b border-gray-100 px-3 py-2">
                        <div class="flex items-center text-gray-700">
                            <el-icon class="mr-1.5 text-blue-500">
                                <Wallet />
                            </el-icon>
                            <span class="font-medium text-sm">结算信息</span>
                            <span class="ml-1 text-xs text-gray-500">(可编辑)</span>
                        </div>
                    </div>

                    <div class="p-3">
                        <div class="grid grid-cols-2 gap-2 mb-2">
                            <!-- 入账佣金编辑 -->
                            <div class="relative bg-orange-50 rounded-md p-2 border border-orange-100">
                                <div class="flex items-center gap-1 text-xs text-gray-600 mb-1">
                                    <el-icon class="text-orange-500">
                                        <Coin />
                                    </el-icon>
                                    <span>入账佣金</span>
                                    <el-tooltip content="本笔订单的平台到账佣金" placement="top" effect="light" class="ml-1">
                                        <el-icon class="text-gray-400 cursor-help">
                                            <QuestionFilled />
                                        </el-icon>
                                    </el-tooltip>
                                </div>
                                <el-form-item prop="xgzShareFee" class="!mb-0">
                                    <el-input v-model="formData.xgzShareFee" clearable
                                        :placeholder="t('xgzShareFeePlaceholder')"
                                        class="!border-orange-200 focus:!border-orange-400" />
                                </el-form-item>
                            </div>

                            <!-- 结算状态编辑 -->
                            <div class="relative bg-blue-50 rounded-md p-2 border border-blue-100">
                                <div class="flex items-center gap-1 text-xs text-gray-600 mb-1">
                                    <el-icon class="text-blue-500">
                                        <CircleCheck />
                                    </el-icon>
                                    <span>结算状态</span>
                                    <el-tooltip content="设置订单是否已入账，已入帐的订单才会结算给用户" placement="top" effect="light"
                                        class="ml-1">
                                        <el-icon class="text-gray-400 cursor-help">
                                            <QuestionFilled />
                                        </el-icon>
                                    </el-tooltip>
                                </div>
                                <el-form-item prop="xgzSettleStatus" class="!mb-0">
                                    <el-radio-group v-model="formData.xgzSettleStatus" size="small">
                                        <el-radio :label="0" class="mr-4">未入账</el-radio>
                                        <el-radio :label="1">已入账</el-radio>
                                    </el-radio-group>
                                </el-form-item>
                            </div>
                        </div>

                        <!-- 订单状态 -->
                        <div class="grid grid-cols-1 gap-2">
                            <div class="relative bg-gray-50 rounded-md p-2 border border-gray-200">
                                <div class="flex items-center gap-1 text-xs text-gray-600 mb-1">
                                    <el-icon class="text-gray-500">
                                        <InfoFilled />
                                    </el-icon>
                                    <span>订单状态</span>
                                    <el-tooltip content="设置当前订单处理状态" placement="top" effect="light" class="ml-1">
                                        <el-icon class="text-gray-400 cursor-help">
                                            <QuestionFilled />
                                        </el-icon>
                                    </el-tooltip>
                                </div>
                                <el-form-item prop="status" class="!mb-0">
                                    <el-select v-model="formData.status" clearable placeholder="请选择订单状态" class="w-full"
                                        size="default">
                                        <el-option v-for="(label, value) in orderStatus" :key="value" :label="label"
                                            :value="Number(value)" />
                                    </el-select>
                                </el-form-item>
                            </div>

                            <!-- 备注信息 -->
                            <div class="relative bg-yellow-50 rounded-md p-2 border border-yellow-100">
                                <div class="flex items-center gap-1 text-xs text-gray-600 mb-1">
                                    <el-icon class="text-yellow-500">
                                        <ChatDotRound />
                                    </el-icon>
                                    <span>订单备注</span>
                                    <el-tooltip content="添加订单处理备注信息" placement="top" effect="light" class="ml-1">
                                        <el-icon class="text-gray-400 cursor-help">
                                            <QuestionFilled />
                                        </el-icon>
                                    </el-tooltip>
                                </div>
                                <el-form-item prop="remark" class="!mb-0">
                                    <el-input v-model="formData.remark" type="textarea" :rows="2"
                                        placeholder="请输入订单备注信息（选填）" maxlength="200" show-word-limit
                                        class="!border-yellow-200 focus:!border-yellow-400" />
                                </el-form-item>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 表单记录显示 -->
                <div v-if="formData.form_record_data?.recordsFieldList && Object.keys(formData.form_record_data.recordsFieldList).length > 0"
                    class="bg-white rounded-md shadow-sm overflow-hidden">
                    <div class="bg-gray-50 border-b border-gray-100 px-3 py-2">
                        <div class="flex items-center text-gray-700">
                            <el-icon class="mr-1.5 text-blue-500">
                                <Document />
                            </el-icon>
                            <span class="font-medium text-sm">表单记录</span>
                        </div>
                    </div>

                    <div class="p-3">
                        <el-collapse>
                            <el-collapse-item title="表单详情" name="1">
                                <el-form-item v-for="(field, fieldKey) in formData.form_record_data.recordsFieldList"
                                    :key="fieldKey" :label="field.field_name" min-width="200" class="!mb-2">
                                    <component v-if="formComponents[fieldKey]" :is="formComponents[fieldKey]"
                                        :data="field" />
                                    <span v-else>{{ field.value || '' }}</span>
                                </el-form-item>
                            </el-collapse-item>
                        </el-collapse>
                    </div>
                </div>

                <!-- 基本信息 -->
                <div class="bg-white rounded-md shadow-sm overflow-hidden">
                    <div class="bg-gray-50 border-b border-gray-100 px-3 py-2">
                        <div class="flex items-center text-gray-700">
                            <el-icon class="mr-1.5 text-blue-500">
                                <Document />
                            </el-icon>
                            <span class="font-medium text-sm">基本与会员信息</span>
                        </div>
                    </div>

                    <div class="p-3">
                        <el-collapse>
                            <el-collapse-item title="详细信息" name="1">
                                <div class="grid grid-cols-2 gap-x-4 gap-y-0">
                                    <!-- 第一列 - 基本信息 -->
                                    <div class="info-group">
                                        <div class="info-title">
                                            <el-icon class="text-blue-500">
                                                <Document />
                                            </el-icon>
                                            <span>基本信息</span>
                                        </div>
                                        <div class="info-item">
                                            <span class="label">订单标题:</span>
                                            <span class="value text-blue-600 font-medium">{{ formData.orderTitle || '-'
                                            }}</span>
                                        </div>
                                        <div class="info-item">
                                            <span class="label">产品类型:</span>
                                            <span class="value">
                                                <el-tag type="info" size="small" effect="light" class="!rounded-md">
                                                    {{ formData.type_name || '-' }}
                                                </el-tag>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <span class="label">父订单ID:</span>
                                            <span class="value">{{ formData.parentOrderId || '-' }}</span>
                                        </div>
                                        <div class="info-item">
                                            <span class="label">下单时间:</span>
                                            <span class="value">{{ formData.orderTime || '-' }}</span>
                                        </div>
                                        <div class="info-item">
                                            <span class="label">更新时间:</span>
                                            <span class="value">{{ formData.modifiedTime || '-' }}</span>
                                        </div>
                                    </div>

                                    <!-- 第二列 - 会员信息 -->
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
                                                    <el-avatar :size="20" class="mr-1" icon="Avatar" />
                                                    {{ formData.member_id_name || '-' }}
                                                </div>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <span class="label">SID:</span>
                                            <span class="value">
                                                <el-tag size="small" effect="plain"
                                                    class="!border-blue-200 bg-blue-50 !rounded-md">
                                                    {{ formData.sid || '-' }}
                                                </el-tag>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </el-collapse-item>
                        </el-collapse>
                    </div>
                </div>
            </div>
        </el-form>

        <template #footer>
            <div class="flex justify-end gap-2">
                <el-button @click="showDialog = false">
                    {{ t('cancel').toUpperCase() }}
                </el-button>
                <el-button type="primary" :loading="loading" @click="confirm(formRef)">
                    {{ t('confirm').toUpperCase() }}
                </el-button>
            </div>
        </template>
    </el-dialog>
</template>

<script setup lang="ts">
import { ref, reactive, computed, defineAsyncComponent, } from 'vue'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import {
    Document,
    Wallet,
    Picture,
    Coin,
    Check,
    CircleCheck,
    InfoFilled,
    ChatLineRound,
    ChatDotRound,
    Money,
    Position,
    User,
    CircleCheckFilled,
    CircleCloseFilled,
    WarningFilled,
    Timer,
    QuestionFilled
} from '@element-plus/icons-vue'
import { addOrder, editOrder, getOrderInfo, getWithMemberList, getOrderStatus } from '@/addon/tk_cpa/api/order'
// 处理异步组件导入
const importComponent = (path: string) => {
    if (!path) return null;
    return defineAsyncComponent(() => import(path));
}
// 状态数据
const orderStatus = ref<Record<string, string>>({})
const loadOrderStatus = async () => {
    try {
        const res = await getOrderStatus()
        orderStatus.value = res.data
    } catch (error) {
        console.error('获取订单状态失败', error)
    }
}
loadOrderStatus()

const showDialog = ref(false)
const loading = ref(false)
const formRef = ref<FormInstance>()
const emit = defineEmits(['complete'])

// 表单数据类型定义
interface FormDataType {
    id: string;
    member_id: string;
    sid: string;
    actName: string;
    actType: string;
    parentOrderId: string;
    orderSn: string;
    xgzUuid: string;
    orderTitle: string;
    orderTime: string;
    payTime: string;
    modifiedTime: string;
    payPrice: string;
    xgzShareRate: string;
    xgzShareFee: string;
    status: number;
    xgzSettleStatus: number;
    xgzSettleTime: string;
    settleTime: string;
    platformType: string;
    sourcePlatform: string;
    picUrl: string;
    refundTag: string;
    refundMoney: string;
    orderChannel: string;
    commission: string;
    is_js: string;
    relate_id: string;
    form_record_id: string;
    member_id_name: string;
    type_name: string;
    status_name: string;
    remark: string;
    nickname: string; // 增加会员昵称
    create_time: string; // 增加创建时间
    js_time: string; // 增加结算时间
    [key: string]: any; // 修改索引签名，允许任意类型的属性值
    form_record_data: any;
}

/**
 * 表单数据初始值
 */
const initialFormData: FormDataType = {
    id: '',
    member_id: '',
    sid: '',
    actName: '',
    actType: '',
    parentOrderId: '',
    orderSn: '',
    xgzUuid: '',
    orderTitle: '',
    orderTime: '',
    payTime: '',
    modifiedTime: '',
    payPrice: '',
    xgzShareRate: '',
    xgzShareFee: '',
    status: 0,
    xgzSettleStatus: 0,
    xgzSettleTime: '',
    settleTime: '',
    platformType: '',
    sourcePlatform: '',
    picUrl: '',
    refundTag: '',
    refundMoney: '',
    orderChannel: '',
    commission: '',
    is_js: '',
    relate_id: '',
    form_record_id: '',
    member_id_name: '',
    type_name: '',
    status_name: '',
    remark: '',
    nickname: '',
    create_time: '',
    js_time: '',
    form_record_data: {}
}

const formData = reactive<FormDataType>({ ...initialFormData })

// 表单验证规则
const formRules = computed(() => ({
    xgzShareFee: [
        { required: true, message: t('xgzShareFeePlaceholder'), trigger: 'blur' },
    ],
    status: [
        { required: true, message: t('statusPlaceholder'), trigger: 'blur' },
    ],
    xgzSettleStatus: [
        { required: true, message: t('xgzSettleStatusPlaceholder'), trigger: 'blur' },
    ]
}))

/**
 * 确认提交
 */
const confirm = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return

    try {
        await formEl.validate()
        loading.value = true

        // 确保状态为数字类型
        formData.status = Number(formData.status)
        formData.xgzSettleStatus = Number(formData.xgzSettleStatus)

        const save = formData.id ? editOrder : addOrder
        await save(formData)

        loading.value = false
        showDialog.value = false
        emit('complete')
    } catch (err) {
        loading.value = false
        console.error('表单验证或提交失败', err)
    }
}

/**
 * 加载会员列表
 */
const memberIdList = ref([] as any[])
const setMemberIdList = async () => {
    try {
        const res = await getWithMemberList({})
        memberIdList.value = res.data
    } catch (error) {
        console.error('获取会员列表失败', error)
    }
}
setMemberIdList()
// 使用reactive存储组件
const formComponents: Record<string, any> = reactive({});
/**
 * 设置表单数据
 */
const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true

    if (row) {
        try {
            const res = await getOrderInfo(row.id)
            const data = res.data

            if (data) {
                Object.keys(formData).forEach((key: string) => {
                    if (data[key] !== undefined) {
                        // 确保状态是数字类型
                        if (key === 'status' || key === 'xgzSettleStatus') {
                            formData[key] = Number(data[key])
                        } else {
                            formData[key] = data[key]
                        }

                    }
                })
                // 处理表单记录组件加载
                if (formData.form_record_data?.recordsFieldList) {
                    Object.keys(formData.form_record_data.recordsFieldList).forEach(key => {
                        const item = formData.form_record_data.recordsFieldList[key];
                        if (item.detailComponent) {
                            formComponents[key] = importComponent(item.detailComponent);
                        }
                    });
                }
            }
        } catch (error) {
            console.error('获取订单信息失败', error)
        }
    }

    loading.value = false
}

defineExpose({
    showDialog,
    setFormData
})
</script>

<style lang="scss" scoped>
:deep(.el-form-item__label) {
    font-weight: 500;
    color: #374151;
    font-size: 13px;
}

:deep(.el-dialog__header) {
    border-bottom: 1px solid #e5e7eb;
    padding: 12px 16px;
    margin-right: 0;
    background-color: #f8fafc;
}

:deep(.el-dialog__body) {
    padding: 12px;
}

:deep(.el-dialog__footer) {
    border-top: 1px solid #e5e7eb;
    padding: 10px 16px;
    background-color: #f8fafc;
}

.info-group {
    margin-bottom: 8px;
}

.info-title {
    display: flex;
    align-items: center;
    gap: 4px;
    font-size: 13px;
    font-weight: 600;
    color: #4b5563;
    margin-bottom: 6px;
    padding-bottom: 4px;
    border-bottom: 1px dashed #e9ecef;
}

.info-item {
    display: flex;
    align-items: center;
    font-size: 12px;
    padding: 3px 0;

    .label {
        color: #64748b;
        flex-shrink: 0;
        width: 70px;
        font-weight: 500;
    }

    .value {
        flex: 1;
        word-break: break-all;
        color: #334155;
    }
}

:deep(.el-tag--small) {
    height: 20px;
    padding: 0 8px;
    font-size: 11px;
}

:deep(.el-collapse-item__header) {
    font-size: 13px;
    padding: 4px 0;
    height: auto;
}

:deep(.el-collapse-item__content) {
    padding-bottom: 8px;
}

:deep(.el-radio) {
    margin-right: 16px;

    .el-radio__label {
        font-size: 13px;
    }
}

:deep(.el-input) {
    --el-input-height: 32px;
}

:deep(.el-select) {
    --el-select-height: 32px;
}
</style>
