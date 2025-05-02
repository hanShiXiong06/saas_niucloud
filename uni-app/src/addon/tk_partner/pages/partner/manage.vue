<template>
	<view class="min-h-[100vh] w-full bg-[#f5f5f5] pb-[120rpx]" :style="themeColor()" v-if="partnerInfo">
		<view class="p-4 space-y-4">
			<!-- 店铺基本信息卡片 -->
			<view class="bg-white rounded-lg p-4 shadow-sm">
				<view class="text-lg font-medium mb-4 flex items-center">
					<view class="w-1 h-5 bg-primary mr-2 rounded-full"></view>
					<text>店铺基本信息</text>
				</view>
				<view class="space-y-4">
					<view>
						<view class="text-sm text-gray-500 mb-2">
							店铺名称
							<text class="text-red-500 ml-1">*</text>
						</view>
						<u-input v-model="partnerInfo.name" placeholder="请输入店铺名称" :border="true" class="rounded-md"
							:error="errors.name"></u-input>
						<view v-if="errors.name" class="text-red-500 text-sm mt-1">{{ errors.name }}</view>
					</view>
					<view>
						<view class="text-sm text-gray-500 mb-2">
							店铺描述
							<text class="text-red-500 ml-1">*</text>
						</view>
						<u-input v-model="partnerInfo.desc" placeholder="请输入店铺描述" :border="true" class="rounded-md"
							:error="errors.desc"></u-input>
						<view v-if="errors.desc" class="text-red-500 text-sm mt-1">{{ errors.desc }}</view>
					</view>
					<view>
						<view class="text-sm text-gray-500 mb-2">
							店铺LOGO
							<text class="text-red-500 ml-1">*</text>
						</view>
						<upload-img class="mt-2" v-model="partnerInfo.logo" :max-count="1" :multiple="false" :width="200"
							:height="200" />
						<view v-if="errors.logo" class="text-red-500 text-sm mt-1">{{ errors.logo }}</view>
					</view>
					<view>
						<view class="text-sm text-gray-500 mb-2">
							联系电话
							<text class="text-red-500 ml-1">*</text>
						</view>
						<u-input v-model="partnerInfo.phone" placeholder="请输入客服电话" :border="true" class="rounded-md"
							:error="errors.phone"></u-input>
						<view v-if="errors.phone" class="text-red-500 text-sm mt-1">{{ errors.phone }}</view>
					</view>
					<view>
						<view class="text-sm text-gray-500 mb-2">
							客服二维码
							<text class="text-red-500 ml-1">*</text>
						</view>
							<upload-img class="mt-2" v-model="partnerInfo.contact_qrcode" :max-count="1" :multiple="false" :width="200"
							:height="200" />
						<view v-if="errors.contact_qrcode" class="text-red-500 text-sm mt-1">{{ errors.contact_qrcode }}</view>
					</view>
				</view>
			</view>

			<!-- 分佣设置卡片 -->
			<view class="bg-white rounded-lg p-4 shadow-sm">
				<view class="space-y-4">
					<view class="flex items-center gap-2">
						<view class="w-1 h-5 bg-primary rounded-full"></view>
						<view class="flex-1">
							<view class="text-lg font-medium">分佣设置</view>
						</view>
					</view>
					<view class="pl-3 space-y-3">
						<view class="text-sm text-gray-500">
							开启分佣
							<text class="text-red-500 ml-1">*</text>
						</view>
						<view class="text-[24rpx] text-gray-500">开启分佣后,将会给进店消费店员分配设置比的佣金</view>
						<u-radio-group v-model="isOpenCommission" :border="true" class="rounded-md" @change="handleCommissionChange">
							<u-radio shape="circle" label="开启" :name="1" class="mr-4"></u-radio>
							<u-radio shape="circle" label="关闭" :name="0"></u-radio>
						</u-radio-group>
					</view>

					<view v-if="Number(partnerInfo.is_open_commission) === 1" class="pl-3 space-y-2">
						<view class="text-sm text-gray-500">
							分佣比例
							<text class="text-red-500 ml-1">*</text>
						</view>
						<u-input 
							v-model="partnerInfo.rate" 
							placeholder="请输入分佣比例" 
							:border="true" 
							class="rounded-md"
							type="number"
							min="1"
							:error="errors.rate"
						>
							<template #suffix>
								<text class="text-gray-500">%</text>
							</template>
						</u-input>
						<view v-if="errors.rate" class="text-red-500 text-sm">{{ errors.rate }}</view>
						<view class="text-[24rpx] text-gray-500">分佣比例范围：1% - 80%</view>
					</view>
				</view>
			</view>

			<!-- 轮播图设置卡片 -->
			<view class="bg-white rounded-lg p-4 shadow-sm">
				<view class="text-lg font-medium mb-4 flex items-center">
					<view class="w-1 h-5 bg-primary mr-2 rounded-full"></view>
					<text>轮播图设置</text>
				</view>
				<view class="space-y-4">
					<view class="text-sm text-gray-500">
						最多可上传3张图片，建议尺寸750x300px
					</view>
					<upload-img class="mt-2" v-model="partnerInfo.banner" :max-count="3" :multiple="true" :width="750"
						:height="300" />
				
				</view>
			</view>
		</view>

		<!-- 保存按钮，固定在底部 -->
	
		  <view 
            class="py-[var(--top-m)] px-[var(--sidebar-m)] footer w-full fixed bottom-0 left-0 right-0 box-border bg-[var(--page-bg-color)] safe-area-inset-bottom">
            
            <view class="ml-4 mr-4 mt-2">
           
               <button hover-class="none" 
                    class="h-[80rpx] leading-[80rpx] rounded-[24rpx] text-[32rpx] text-[var(--primary-color-light)] w-full"
                    :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color2))' }"
                   @click="handleSave">保存设置</button>
            </view>
            <u-safe-bottom></u-safe-bottom>
        </view>
	</view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { img, redirect, handleOnloadParams } from '@/utils/common';
import uploadImg from '@/addon/tk_partner/pages/components/upload-img'
import { onLoad,onShow } from '@dcloudio/uni-app';
import { getPartnerInfo, editPartner } from '@/addon/tk_partner/api/partner';
import { checkPartnerOpenEvent } from '@/addon/tk_partner/utils/ts/common';
import useConfigStore from '@/stores/config';
onShow(()=>{
	checkPartnerOpenEvent()
})
interface PartnerInfo {
	name: string;
	logo: string;
	desc: string;
	banner: string[];
	is_open_commission: number;
	rate: number;
	phone: string;
	contact_qrcode: string;
}

interface ApiResponse {
	data: PartnerInfo;
	[key: string]: any;
}

interface FormErrors {
	name?: string;
	logo?: string;
	desc?: string;
	banner?: string[];
	is_open_commission?: number;
	rate?: string;
	phone?: string;
	contact_qrcode?: string;
}

const partnerInfo = ref<PartnerInfo>({
	name: '',
	logo: '',
	desc: '',
	banner: [],
	is_open_commission: 0,
	rate: 0,
	phone: '',
	contact_qrcode: ''
})
const errors = ref<FormErrors>({})
const isOpenCommission = ref(0)

// 获取主题颜色方法
const configStore = useConfigStore();
const themeColor = () => {
    return configStore.getThemeColor();
};

// 处理分佣状态改变
const handleCommissionChange = (value: number) => {
	partnerInfo.value.is_open_commission = Number(value)
}

// 表单验证
const validateForm = (): boolean => {
	errors.value = {}
	let isValid = true

	if (!partnerInfo.value?.name?.trim()) {
		errors.value.name = '请输入店铺名称'
		isValid = false
	}
	if (!partnerInfo.value?.desc?.trim()) {
		errors.value.desc = '请输入店铺描述'
		isValid = false
	}

	if (!partnerInfo.value?.logo) {
		errors.value.logo = '请上传店铺LOGO'
		isValid = false
	}
	
	if (!partnerInfo.value?.phone?.trim()) {
		errors.value.phone = '请输入联系电话'
		isValid = false
	}
	
	if (!partnerInfo.value?.contact_qrcode) {
		errors.value.contact_qrcode = '请上传客服二维码'
		isValid = false
	}
	
	// 如果开启分佣，验证分佣比例
	if (Number(partnerInfo.value.is_open_commission) === 1) {
		const rate = Number(partnerInfo.value.rate)
		if (isNaN(rate) || rate <= 0) {
			errors.value.rate = '请输入有效的分佣比例'
			isValid = false
		} else if (rate > 80) {
			errors.value.rate = '分佣比例不能超过80%'
			isValid = false
		} else if (rate < 1) {
			errors.value.rate = '分佣比例不能小于1%'
			isValid = false
		}
	}

	return isValid
}

// 获取合伙人信息
const getInfo = async () => {
	try {
		const res = await getPartnerInfo({ type: 'partner' }) as ApiResponse
		if (res?.data) {
			partnerInfo.value = {
				...res.data,
				is_open_commission: Number(res.data.is_open_commission) || 0
			} as PartnerInfo
			isOpenCommission.value = Number(partnerInfo.value.is_open_commission) || 0
		}
	} catch (error) {
		uni.showToast({
			title: '获取信息失败',
			icon: 'none'
		})
	}
}

// 保存设置
const handleSave = async () => {
	if (!partnerInfo.value) return
	
	// 确保is_open_commission是数字类型
	const formData = {
		...partnerInfo.value,
		is_open_commission: Number(partnerInfo.value.is_open_commission),
		rate: Number(partnerInfo.value.rate)
	}

	// 表单验证
	if (!validateForm()) {
		uni.showToast({
			title: '请完善必填信息',
			icon: 'none'
		})
		return
	}

	try {
		editPartner(formData).then(res => {
			uni.showToast({
				title: '保存成功',
				icon: 'success'
			})
			uni.navigateBack()
		})

	} catch (error) {
		uni.showToast({
			title: '保存失败',
			icon: 'none'
		})
	}
}

onMounted(() => {
	getInfo()
})
</script>

<style lang="scss" scoped>
@import '@/addon/tk_partner/utils/styles/common.scss';
</style>