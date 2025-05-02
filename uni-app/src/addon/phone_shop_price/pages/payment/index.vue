<template>
    <view class="payment-page">

        <!-- 收款方式列表 -->
        <view class="payment-list" v-if="paymentList.length">
            <view class="payment-item" v-for="item in paymentList" :key="item.id">
                <view class="payment-info">
                    <view class="payment-type">
                        <up-icon :name="getPayTypeIcon(item.pay_type)" size="24" color="#3b82f6"></up-icon>


                        <text class="type-label">{{ item.pay_type }}收款 </text>
                        <text class="default-tag" v-if="item.is_default">默认</text>
                    </view>
                    <view class="account-info">{{ item.account }}</view>
                    <view class="create-time" v-if="item.create_time">创建时间: {{ item.create_time }}</view>
                </view>
                <view class="payment-actions">
                    <button class="btn-default" v-if="!item.is_default" @tap="handleSetDefault(item.id)">
                        <up-icon name="checkmark-circle" size="16" color="#ffffff"></up-icon>
                        <text>设为默认</text>
                    </button>
                    <button class="btn-edit" @tap="handleEdit(item)">
                        <up-icon name="edit-pen" size="16" color="#3b82f6"></up-icon>
                        <text>编辑</text>
                    </button>
                    <button class="btn-delete" @tap="handleDelete(item.id)">
                        <up-icon name="trash" size="16" color="#ef4444"></up-icon>
                        <text>删除</text>
                    </button>
                </view>
            </view>
        </view>
        <view v-else class="empty-state">
            <up-icon name="info-circle" size="48" color="#94a3b8"></up-icon>
            <text class="empty-text">暂无收款方式</text>
            <text class="empty-subtext">可以添加多个收款方式</text>
        </view>

        <!-- 添加收款方式按钮 -->
        <view class="add-payment">
            <button class="btn-add" @tap="openPopup">
                <up-icon name="plus-circle" size="24" color="#ffffff"></up-icon>
                <text>添加收款方式</text>
            </button>
        </view>

        <!-- 添加/编辑弹窗 -->
        <uni-popup ref="popup" type="center" :mask-click="false">
            <view class="popup-content">
                <view class="popup-header">
                    <view class="popup-title">{{ isEdit ? '编辑收款方式' : '添加收款方式' }}</view>
                    <view class="popup-close" @tap="hidePopup">
                        <up-icon name="close" size="24" color="#94a3b8"></up-icon>
                    </view>
                </view>
                <view class="popup-body">
                    <view class="form-item">
                        <view class="label">收款方式</view>
                        <picker @change="handleTypeChange" :value="typeIndex" :range="payTypes">
                            <view class="picker">
                                <up-icon :name="getPayTypeIcon(payTypes[typeIndex])" size="20"
                                    color="#3b82f6"></up-icon>
                                <text>{{ payTypes[typeIndex] }}</text>
                            </view>
                        </picker>
                    </view>
                    <view class="form-item">
                        <view class="label">收款账号</view>
                        <input type="text" v-model="formData.account" placeholder="请输入收款账号" />
                    </view>
                    <view class="form-item" v-if="formData.pay_type !== '银行卡'">
                        <view class="label">收款码</view>
                        <view class="upload-qrcode" @tap="chooseImage">
                            <view class="upload-content" :class="{ 'is-loading': isUploading }">
                                <image v-if="formData.qrcode_image" :src="img(formData.qrcode_image)" mode="aspectFit">
                                </image>
                                <view v-else class="upload-placeholder">
                                    <up-icon name="camera" size="32" color="#94a3b8"></up-icon>
                                    <text>上传收款码</text>
                                </view>
                                <view class="loading-overlay" v-if="isUploading">
                                    <view class="loading-spinner"></view>
                                    <text class="loading-text">上传中...</text>
                                </view>
                            </view>
                        </view>
                    </view>
                </view>
                <view class="popup-footer">
                    <button class="btn-cancel" @tap="hidePopup">取消</button>
                    <button class="btn-confirm" @tap="handleSubmit">确定</button>
                </view>
            </view>
        </uni-popup>
    </view>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getPaymentList, addPayment, updatePayment, deletePayment, setDefaultPayment, type PaymentInfo } from '../../api/payment'

import { img } from '@/utils/common'
import { uploadImage } from '@/app/api/system'


const popup = ref<any>(null)
const paymentList = ref<PaymentInfo[]>([])
const isEdit = ref(false)
const editId = ref<number | null>(null)
const payTypes = ['微信', '支付宝', '银行卡']
const typeIndex = ref(0)
const formData = ref<Partial<PaymentInfo>>({
    pay_type: '微信',
    account: '',
    qrcode_image: '',
    is_default: 0
})
const isUploading = ref(false)

onMounted(() => {
    loadPaymentList()
})

// 打开弹窗
const openPopup = () => {
    resetForm()
    popup.value?.open()
}

// 获取收款方式列表
const loadPaymentList = async () => {
    try {
        const res = await getPaymentList()
        if (res.code === 1 && res.data) {
            console.log(res.data);

            paymentList.value = Array.isArray(res.data) ? res.data : []
        } else {
            uni.showToast(res.msg || '获取列表失败')
        }
    } catch (error) {
        uni.showToast('获取列表失败')
    }
}

// 处理收款方式选择
const handleTypeChange = (e: any) => {
    typeIndex.value = e.detail.value
    formData.value.pay_type = payTypes[typeIndex.value]
}

// 选择图片
const chooseImage = () => {
    uni.chooseImage({
        count: 1,
        success: (res) => {
            uploadPaymentImage(res.tempFilePaths[0])
        },
        fail: () => {
            uni.showToast('选择图片失败')
        }
    })
}

// 上传图片
const uploadPaymentImage = async (filePath: string) => {
    isUploading.value = true
    try {
        const res = await uploadImage({
            filePath: filePath,
            name: 'file'
        })

        if (res.code === 1) {
            formData.value.qrcode_image = res.data.url
        } else {
            uni.showToast({
                title: res.msg || '上传失败',
                icon: 'none'
            })
        }
    } catch (error) {
        uni.showToast({
            title: '上传失败',
            icon: 'none'
        })
    } finally {
        isUploading.value = false
    }
}

// 设置默认收款方式
const handleSetDefault = async (id: number) => {
    try {
        const res = await setDefaultPayment(id)
        if (res.code === 1) {
            uni.showToast('设置成功', 'success')
            loadPaymentList()
        } else {
            uni.showToast(res.msg || '设置失败')
        }
    } catch (error) {
        uni.showToast('设置失败')
    }
}

// 编辑收款方式
const handleEdit = (item: PaymentInfo) => {
    isEdit.value = true
    editId.value = item.id
    formData.value = { ...item }
    typeIndex.value = payTypes.indexOf(item.pay_type)
    popup.value?.open()
}

// 删除收款方式
const handleDelete = (id: number) => {


    uni.showModal({
        title: '提示',
        content: '确定要删除该收款方式吗？',
        success: async (res) => {
            if (res.confirm) {
                try {
                    const res = await deletePayment(id)
                    if (res.code === 1) {
                        uni.showToast('删除成功', 'success')
                        loadPaymentList()
                    } else {
                        uni.showToast(res.msg || '删除失败')
                    }
                } catch (error) {
                    uni.showToast('删除失败')
                }
            }
        }
    })
}

// 提交表单
const handleSubmit = async () => {
    if (!formData.value.account) {
        uni.showToast('请输入收款账号')
        return
    }

    if (formData.value.pay_type !== '银行卡' && !formData.value.qrcode_image) {
        uni.showToast('请上传收款码')
        return
    }

    try {
        let res
        if (isEdit.value && editId.value) {
            res = await updatePayment(editId.value, formData.value)
        } else {
            res = await addPayment(formData.value)
        }

        if (res.code === 1) {
            uni.showToast(isEdit.value ? '编辑成功' : '添加成功', 'success')
            hidePopup()
            loadPaymentList()
        } else {
            uni.showToast(res.msg || (isEdit.value ? '编辑失败' : '添加失败'))
        }
    } catch (error) {
        uni.showToast(isEdit.value ? '编辑失败' : '添加失败')
    }
}

// 隐藏弹窗
const hidePopup = () => {
    popup.value?.close()
    resetForm()
}

// 重置表单
const resetForm = () => {
    isEdit.value = false
    editId.value = null
    formData.value = {
        pay_type: '微信',
        account: '',
        qrcode_image: '',
        is_default: 0
    }
    typeIndex.value = 0
}

// 获取支付方式图标
const getPayTypeIcon = (type: string) => {
    switch (type) {
        case '微信':
            return 'weixin-fill'
        case '支付宝':
            return 'zhifubao'
        case '银行卡':
            return 'rmb'
        default:
            return 'rmb-circle'
    }
}
</script>

<style lang="scss">
.payment-page {
    padding: 30rpx;
    background: linear-gradient(180deg, #f0f9ff 0%, #f7f8fa 100%);
    min-height: 100vh;
}

.payment-list {
    .payment-item {
        background: #fff;
        border-radius: 24rpx;
        padding: 40rpx;
        margin-bottom: 30rpx;
        box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
        transform: translateY(0);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        position: relative;
        overflow: hidden;
        border: 2rpx solid #e2e8f0;

        &:active {
            transform: translateY(2rpx);
            box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.03);
        }

        .payment-info {
            position: relative;
            padding-left: 20rpx;

            .payment-type {
                display: flex;
                align-items: center;
                margin-bottom: 24rpx;
                gap: 12rpx;

                .type-label {
                    font-size: 36rpx;
                    font-weight: 600;
                    color: #1e293b;
                    letter-spacing: 1rpx;
                }

                .default-tag {
                    background: linear-gradient(135deg, #3b82f6, #2563eb);
                    color: #fff;
                    font-size: 22rpx;
                    padding: 6rpx 20rpx;
                    border-radius: 30rpx;
                    margin-left: 20rpx;
                    font-weight: 500;
                    box-shadow: 0 2rpx 8rpx rgba(59, 130, 246, 0.2);
                }
            }

            .account-info {
                font-size: 30rpx;
                color: #475569;
                margin-bottom: 16rpx;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 12rpx;

                &::before {
                    content: '';
                    display: inline-block;
                    width: 8rpx;
                    height: 8rpx;
                    background: #3b82f6;
                    border-radius: 50%;
                }
            }

            .create-time {
                font-size: 24rpx;
                color: #94a3b8;
                display: flex;
                align-items: center;
                gap: 8rpx;
            }
        }

        .payment-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 30rpx;
            gap: 20rpx;

            button {
                min-width: 160rpx;
                height: 72rpx;
                line-height: 72rpx;
                font-size: 26rpx;
                padding: 0 32rpx;
                border-radius: 36rpx;
                font-weight: 600;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8rpx;

                &.btn-default {
                    background: linear-gradient(135deg, #3b82f6, #2563eb);
                    color: #fff;
                    box-shadow: 0 4rpx 12rpx rgba(59, 130, 246, 0.2);
                }

                &.btn-edit {
                    background: #fff;
                    color: #3b82f6;
                    border: 2rpx solid #3b82f6;
                    box-shadow: 0 2rpx 8rpx rgba(59, 130, 246, 0.1);
                }

                &.btn-delete {
                    background: #fff;
                    color: #ef4444;
                    border: 2rpx solid #ef4444;
                    box-shadow: 0 2rpx 8rpx rgba(239, 68, 68, 0.1);
                }
            }
        }
    }
}

.empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 120rpx 0;

    .empty-text {
        font-size: 32rpx;
        color: #1e293b;
        margin-top: 24rpx;
        font-weight: 500;
    }

    .empty-subtext {
        font-size: 26rpx;
        color: #94a3b8;
        margin-top: 12rpx;
    }
}

.add-payment {
    margin-top: 40rpx;
    padding: 0 20rpx;
    position: fixed;
    bottom: 20rpx;
    left: 0;
    right: 0;

    .btn-add {
        width: 100%;
        height: 96rpx;
        line-height: 96rpx;
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: #fff;
        font-size: 32rpx;
        border-radius: 48rpx;
        font-weight: 600;
        box-shadow: 0 4rpx 20rpx rgba(59, 130, 246, 0.3);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12rpx;

        &:active {
            transform: translateY(2rpx);
            box-shadow: 0 2rpx 10rpx rgba(59, 130, 246, 0.2);
        }
    }
}

.popup-content {
    background: #fff;
    border-radius: 32rpx;
    width: 680rpx;
    position: relative;
    overflow: hidden;
    box-sizing: border-box;

    .popup-header {
        padding: 40rpx;
        border-bottom: 2rpx solid #f1f5f9;
        display: flex;
        justify-content: space-between;
        align-items: center;

        .popup-title {
            font-size: 40rpx;
            font-weight: 600;
            color: #1e293b;
            letter-spacing: 1rpx;
        }

        .popup-close {
            padding: 10rpx;
        }
    }

    .popup-body {
        padding: 40rpx;

        .form-item {
            margin-bottom: 36rpx;

            .label {
                font-size: 28rpx;
                color: #475569;
                margin-bottom: 16rpx;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 12rpx;

                &::before {
                    content: '';
                    display: inline-block;
                    width: 6rpx;
                    height: 6rpx;
                    background: #3b82f6;
                    border-radius: 50%;
                }
            }

            input {
                width: 100%;
                height: 88rpx;
                border: 2rpx solid #e2e8f0;
                border-radius: 16rpx;
                padding: 0 24rpx;
                font-size: 28rpx;
                background: #f8fafc;
                transition: all 0.3s ease;
                box-sizing: border-box;
                color: #1e293b;

                &::placeholder {
                    color: #94a3b8;
                }

                &:focus {
                    border-color: #3b82f6;
                    background: #fff;
                    box-shadow: 0 0 0 4rpx rgba(59, 130, 246, 0.1);
                }
            }

            .picker {
                width: 100%;
                height: 88rpx;
                line-height: 88rpx;
                border: 2rpx solid #e2e8f0;
                border-radius: 16rpx;
                padding: 0 24rpx;
                font-size: 28rpx;
                background: #f8fafc;
                position: relative;
                box-sizing: border-box;
                color: #1e293b;
                display: flex;
                align-items: center;
                gap: 12rpx;
            }

            .upload-qrcode {
                width: 240rpx;
                height: 240rpx;
                border: 2rpx dashed #cbd5e1;
                border-radius: 16rpx;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 26rpx;
                color: #64748b;
                background: #f8fafc;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;

                &:active {
                    background: #f1f5f9;
                    border-color: #94a3b8;
                }

                .upload-content {
                    width: 100%;
                    height: 100%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    position: relative;
                    transition: all 0.3s ease;

                    &.is-loading {
                        opacity: 0.7;
                    }

                    .upload-placeholder {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        gap: 12rpx;
                        color: #94a3b8;
                    }

                    image {
                        width: 100%;
                        height: 100%;
                        border-radius: 16rpx;
                        object-fit: cover;
                    }
                }

                .loading-overlay {
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background: rgba(255, 255, 255, 0.9);
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;
                    gap: 16rpx;
                    border-radius: 16rpx;
                    z-index: 1;

                    .loading-spinner {
                        width: 60rpx;
                        height: 60rpx;
                        border: 4rpx solid #f3f3f3;
                        border-top: 4rpx solid #3b82f6;
                        border-radius: 50%;
                        animation: spin 1s linear infinite;
                    }

                    .loading-text {
                        font-size: 24rpx;
                        color: #3b82f6;
                        font-weight: 500;
                    }
                }
            }
        }
    }

    .popup-footer {
        padding: 40rpx;
        border-top: 2rpx solid #f1f5f9;
        display: flex;
        justify-content: space-between;
        gap: 24rpx;

        button {
            flex: 1;
            height: 88rpx;
            line-height: 88rpx;
            border-radius: 44rpx;
            font-size: 30rpx;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);

            &.btn-cancel {
                background: #f1f5f9;
                color: #64748b;
            }

            &.btn-confirm {
                background: linear-gradient(135deg, #3b82f6, #2563eb);
                color: #fff;
                box-shadow: 0 4rpx 12rpx rgba(59, 130, 246, 0.2);
            }
        }
    }
}

@keyframes spin {
    0% {
        transform: rotate(0deg);
    }

    100% {
        transform: rotate(360deg);
    }
}
</style>