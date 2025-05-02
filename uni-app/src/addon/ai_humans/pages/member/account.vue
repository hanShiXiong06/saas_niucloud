<template>
	<view class="bg-[var(--page-bg-color)] min-h-screen p-4" :style="themeColor()" v-if="account">


		<!-- 充值卡片 -->
		<view class="bg-white rounded-[16rpx] p-6 shadow-sm mb-3">
			<view class="flex justify-between items-center mb-6">
				<view class="text-[32rpx] font-bold text-gray-800">
					剩余{{ config.name }}
				</view>
				<view
					class="flex items-center text-[26rpx] text-[var(--primary-color)] opacity-80 hover:opacity-100 transition-opacity"
					@click="redirect({ url: '/addon/ai_humans/pages/member/log' })">
					消耗明细 <uni-icons type="forward" size="16" color="var(--primary-color)" class="ml-1"></uni-icons>
				</view>
			</view>

			<view class="flex items-center bg-[#f8f9ff] p-5 rounded-[12rpx] hover:bg-[#f0f2ff] transition-colors">
				<view class="flex items-center">
					<view class="text-[28rpx] text-gray-600">我的{{ config.name }}:</view>
					<view class="flex items-center mx-3">
						<u-icon name="level" size="20" color="var(--primary-color)"></u-icon>
					</view>
					<view class="text-[44rpx] font-bold text-[var(--primary-color)]">6000.00</view>
				</view>
			</view>

			<view class="text-[26rpx] text-gray-500 mt-4 pl-2">
				{{ `尊享8+数字权益，超多算力免费送` }}
			</view>

			<view
				class="mt-6 flex items-center justify-center bg-[var(--primary-color)] text-white text-[30rpx] rounded-[12rpx] h-[88rpx] shadow-sm hover:bg-opacity-90 transition-colors"
				@click="redirect({ url: '/addon/ai_humans/pages/package/package' })">
				<uni-icons type="plus" size="20" color="#ffffff"></uni-icons>
				<text class="ml-2">充值中心</text>
			</view>
		</view>
		<!-- 账户余额和流量信息卡片 -->
		<view class="bg-white rounded-[16rpx] p-6 mb-4 shadow-sm" v-if="memberInfo">
			<view class="flex items-center justify-between mb-6">
				<view class="flex items-center">
					<u-icon name="calendar" size="24" color="var(--primary-color)" class="mr-2"></u-icon>
					<view class="text-[32rpx] font-bold text-gray-800">套餐余量</view>
				</view>
				<view class="text-[26rpx] text-gray-500">
					<text v-if="memberInfo.expire_time != 0">有效期至：{{ memberInfo.expire_time }}</text>
					<text v-else>永久有效</text>
				</view>
			</view>

			<!-- 账户信息网格布局 -->
			<view class="grid grid-cols-2 gap-4">
				<!-- 克隆声音相关信息 -->
				<view v-if="memberInfo.clone_voice_num > 0"
					class="flex items-center bg-gradient-to-br from-[#f8f9ff] to-[#f0f2ff] p-4 rounded-[12rpx] hover:shadow-md transition-all duration-300">
					<view class="flex-1">
						<view class="flex items-center mb-2">
							<u-icon name="volume" size="20" color="var(--primary-color)" class="mr-2"></u-icon>
							<view class="text-[26rpx] text-gray-600">克隆声音</view>
						</view>
						<view class="text-[36rpx] font-medium text-[var(--primary-color)]">{{ memberInfo.clone_voice_num
						}}
							<text class="text-[24rpx] text-gray-500 ml-1">次</text>
						</view>
					</view>
				</view>

				<view v-if="memberInfo.clone_voice_pro_num > 0"
					class="flex items-center bg-gradient-to-br from-[#f8f9ff] to-[#f0f2ff] p-4 rounded-[12rpx] hover:shadow-md transition-all duration-300">
					<view class="flex-1">
						<view class="flex items-center mb-2">
							<u-icon name="volume" size="20" color="var(--primary-color)" class="mr-2"></u-icon>
							<view class="text-[26rpx] text-gray-600">克隆声音Pro</view>
						</view>
						<view class="text-[36rpx] font-medium text-[var(--primary-color)]">{{
							memberInfo.clone_voice_pro_num }}
							<text class="text-[24rpx] text-gray-500 ml-1">次</text>
						</view>
					</view>
				</view>

				<!-- 合成声音相关信息 -->
				<view v-if="memberInfo.create_voice_num > 0"
					class="flex items-center bg-gradient-to-br from-[#f8f9ff] to-[#f0f2ff] p-4 rounded-[12rpx] hover:shadow-md transition-all duration-300">
					<view class="flex-1">
						<view class="flex items-center mb-2">
							<u-icon name="mic" size="20" color="var(--primary-color)" class="mr-2"></u-icon>
							<view class="text-[26rpx] text-gray-600">合成声音</view>
						</view>
						<view class="text-[36rpx] font-medium text-[var(--primary-color)]">{{
							memberInfo.create_voice_num }}
							<text class="text-[24rpx] text-gray-500 ml-1">分钟</text>
						</view>
					</view>
				</view>

				<view v-if="memberInfo.create_voice_pro_num > 0"
					class="flex items-center bg-gradient-to-br from-[#f8f9ff] to-[#f0f2ff] p-4 rounded-[12rpx] hover:shadow-md transition-all duration-300">
					<view class="flex-1">
						<view class="flex items-center mb-2">
							<u-icon name="mic" size="20" color="var(--primary-color)" class="mr-2"></u-icon>
							<view class="text-[26rpx] text-gray-600">合成声音Pro</view>
						</view>
						<view class="text-[36rpx] font-medium text-[var(--primary-color)]">{{
							memberInfo.create_voice_pro_num }}
							<text class="text-[24rpx] text-gray-500 ml-1">分钟</text>
						</view>
					</view>
				</view>

				<!-- 克隆视频相关信息 -->
				<view v-if="memberInfo.clone_video_num > 0"
					class="flex items-center bg-gradient-to-br from-[#f8f9ff] to-[#f0f2ff] p-4 rounded-[12rpx] hover:shadow-md transition-all duration-300">
					<view class="flex-1">
						<view class="flex items-center mb-2">
							<u-icon name="camera" size="20" color="var(--primary-color)" class="mr-2"></u-icon>
							<view class="text-[26rpx] text-gray-600">克隆视频</view>
						</view>
						<view class="text-[36rpx] font-medium text-[var(--primary-color)]">{{ memberInfo.clone_video_num
						}}
							<text class="text-[24rpx] text-gray-500 ml-1">次</text>
						</view>
					</view>
				</view>

				<view v-if="memberInfo.clone_video_pro_num > 0"
					class="flex items-center bg-gradient-to-br from-[#f8f9ff] to-[#f0f2ff] p-4 rounded-[12rpx] hover:shadow-md transition-all duration-300">
					<view class="flex-1">
						<view class="flex items-center mb-2">
							<u-icon name="camera" size="20" color="var(--primary-color)" class="mr-2"></u-icon>
							<view class="text-[26rpx] text-gray-600">克隆视频Pro</view>
						</view>
						<view class="text-[36rpx] font-medium text-[var(--primary-color)]">{{
							memberInfo.clone_video_pro_num }}
							<text class="text-[24rpx] text-gray-500 ml-1">次</text>
						</view>
					</view>
				</view>

				<!-- 合成视频相关信息 -->
				<view v-if="memberInfo.create_video_num > 0"
					class="flex items-center bg-gradient-to-br from-[#f8f9ff] to-[#f0f2ff] p-4 rounded-[12rpx] hover:shadow-md transition-all duration-300">
					<view class="flex-1">
						<view class="flex items-center mb-2">
							<u-icon name="camera-fill" size="20" color="var(--primary-color)" class="mr-2"></u-icon>
							<view class="text-[26rpx] text-gray-600">合成视频</view>
						</view>
						<view class="text-[36rpx] font-medium text-[var(--primary-color)]">{{
							memberInfo.create_video_num }}
							<text class="text-[24rpx] text-gray-500 ml-1">分种</text>
						</view>
					</view>
				</view>

				<view v-if="memberInfo.create_video_pro_num > 0"
					class="flex items-center bg-gradient-to-br from-[#f8f9ff] to-[#f0f2ff] p-4 rounded-[12rpx] hover:shadow-md transition-all duration-300">
					<view class="flex-1">
						<view class="flex items-center mb-2">
							<u-icon name="camera-fill" size="20" color="var(--primary-color)" class="mr-2"></u-icon>
							<view class="text-[26rpx] text-gray-600">合成视频Pro</view>
						</view>
						<view class="text-[36rpx] font-medium text-[var(--primary-color)]">{{
							memberInfo.create_video_pro_num }}
							<text class="text-[24rpx] text-gray-500 ml-1">分钟</text>
						</view>
					</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script setup lang="ts">
import { ref, computed } from "vue";
import { getAccount } from '@/addon/ai_humans/api/member'
import { getConfig } from '@/addon/ai_humans/api/config'
import { img, copy, redirect } from "@/utils/common";
import useConfigStore from '@/stores/config';

// 引入主题颜色函数
const themeColor = () => {
	const configStore = useConfigStore();
	return configStore.getThemeColor();
};

const account = ref()
const memberInfo = ref()
getAccount().then((res: any) => {
	memberInfo.value = res.data.member_info
	account.value = res.data
})
const config = ref<any>({});
getConfig().then((res: any) => {
	config.value = res.data;
})

</script>

<style lang="scss">
@import "@/addon/ai_humans/utils/styles/common.scss";
</style>
