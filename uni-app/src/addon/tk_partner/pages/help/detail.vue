<template>
	<view class="min-h-screen bg-gray-50" v-if="detailData">
		<view class="max-w-3xl mx-auto p-4">
			<!-- 头部信息卡片 -->
			<view class="bg-white rounded-lg shadow-sm p-2 mb-2">
				<view class="flex items-center space-x-4 ">
					<u-image :src="img(detailData.image)" width="120rpx" height="120rpx" class="rounded-lg"></u-image>
					<view class="flex-1">
						<view class="text-[32rpx] font-bold text-gray-800 mb-2">{{ detailData.title }}</view>
						<view class="text-[24rpx] text-gray-500 mb-2">{{ detailData.desc }}</view>
						<view class="flex items-center space-x-4 text-xs text-gray-400">
							<view class="flex items-center">
								<u-icon name="calendar" size="14"></u-icon>
								<text class="ml-1">{{ detailData.create_time }}</text>
							</view>
							<view class="flex items-center">
								<u-icon name="eye" size="14"></u-icon>
								<text class="ml-1">{{ detailData.view_num }}</text>
							</view>
						</view>
					</view>
				</view>
			</view>

			<!-- 内容区域 -->
			<view class="bg-white rounded-lg shadow-sm p-2">
				<u-parse :content="detailData.content"
					:tagStyle="{ img: 'vertical-align: top;', p: 'overflow: hidden;word-break:break-word;' }"></u-parse>
			</view>
		</view>
	</view>
	<tabbar addon="tk_partner_partner" />
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { img, redirect } from '@/utils/common';
import { getHelpInfo } from '@/addon/tk_partner/api/help';
import { onLoad } from '@dcloudio/uni-app';

interface HelpDetail {
	title: string;
	desc: string;
	image: string;
	content: string;
	create_time: string;
	view_num: number;
}

const detailData = ref<HelpDetail>();

onLoad((option: { id?: string }) => {
	if (option?.id) {
		const id = option.id;
		getHelpInfo(id).then((res: { data: HelpDetail }) => {
			detailData.value = res.data;
		});
	} else {
		uni.showToast({
			title: '参数错误',
			icon: 'none'
		});
	}
});
</script>

<style lang="scss" scoped>
@import '@/addon/tk_partner/utils/styles/common.scss';
</style>