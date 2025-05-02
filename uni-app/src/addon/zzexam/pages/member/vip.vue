<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-screen overflow-hidden">
		<view v-if="!loading" class="pb-20rpx">
			<view v-if="detail.id">
				<view class="bg-white p-[30rpx]">
					<image :src="img(config.banner)" class="w-[690rpx] rounded-[20rpx]" mode="widthFix" />
					
					<view
						class="relative mt-[30rpx] pb-[30rpx] w-[690rpx] mx-[auto] flex items-center " @click="redirect({ url: '/addon/zzexam/pages/vip/buy' })">
						<view>
							<u-avatar :src="img(detail.headimg)" size="55" leftIcon="none" :default-url="img('static/resource/images/default_headimg.png')" />
						</view>
						<view class="ml-[30rpx]">
							<view class="text-[32rpx]">
								{{ detail.nickname }}
							</view>
							<view class="mt-[20rpx] text-[26rpx] text-[var(--text-color-light)]">
								有效期至：{{detail.overdue_time}}
							</view>
						</view>
						<view class="absolute right-0 top-[50rpx] flex text-[28rpx] text-[#2C6FFF]">
							延期<u-icon class="ml-[10rpx]" name="arrow-right" color="#2C6FFF" size="15"></u-icon>
						</view>
					</view>
					
				</view>
				
				<view class="p-[30rpx] mt-[20rpx] bg-white">
					<view class="font-bold text-[30rpx] mb-[10rpx]">权益说明</view>
					<view class="text-[30rpx] leading-[46rpx] mt-[20rpx] text-[#808080]">
						{{config.statement}}
					</view>
				</view>
			</view>
			<view v-else>
				<mescroll-empty :option="{ tip : '您暂未开通会员卡','icon': img('static/resource/images/empty.png') }"></mescroll-empty>
				<view class="common-tab-bar-placeholder"></view>
				<view class="common-tab-bar fixed left-[var(--sidebar-m)] right-[var(--sidebar-m)] bottom-[0]">
					<button class="primary-btn-bg text-[#fff] h-[80rpx] leading-[80rpx] rounded-[100rpx] text-[26rpx] font-500" @click="redirect({ url: '/addon/zzexam/pages/vip/buy'})">开通会员卡</button>
				</view>
			</view>
			
			
		</view>
	</view>

	<u-loading-page :loading="loading" fontSize="16" color="#333"></u-loading-page>
</template>

<script setup lang="ts">
	import { ref} from 'vue';
	import { onLoad } from '@dcloudio/uni-app'
	import { img, redirect,timeStampTurnTime } from '@/utils/common';
	import { getMyVip,getVipConfig } from '@/addon/zzexam/api/vip';
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue'

	let config = ref<Array<any>>([]);
	let detail = ref<Object>({});
	let loading = ref<boolean>(true);

	onLoad(() => {
		getMyVipInfo();
		getVipConfigFn();
	});

	const getMyVipInfo = () => {
		loading.value = true;
		getMyVip().then((res) => {
			detail.value = res.data;
			loading.value = false;
		}).catch(() => {
			loading.value = false;
		})
	}
	
	const getVipConfigFn = () => {
		getVipConfig().then((res) => {
			config.value = res.data;
		});
	}		

</script>
<style>
	@import '@/addon/zzexam/styles/common.scss';
</style>
