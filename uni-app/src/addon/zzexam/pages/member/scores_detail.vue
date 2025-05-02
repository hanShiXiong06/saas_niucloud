<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] pt-[40rpx] min-h-[100vh]">
		<block v-if="!loading">
			<view class="bg-white mx-[30rpx] rounded-[20rpx] pb-[40rpx]">
				<view class="text-[32rpx] font-bold text-center p-[40rpx]">本次成绩</view>
				<view class="text-center font-bold p-[20rpx] text-[56rpx] text-[var(--price-text-color)]">
					{{scoresDetail.exam_score}}<text class="text-[30rpx] font-normal ml-[5rpx]">分</text>
				</view>
				<view class="text-[var(--price-text-color)] text-[30rpx] p-[30rpx] text-center">
					总分{{scoresDetail.total_score}},考试{{scoresDetail.is_pass == 1 ? '及格' : '不及格!'}}
					<text v-if="scoresDetail.is_cert">,获得证书</text>
				</view>
				<view class="flex p-[30rpx] justify-between text-[30rpx]">
					<view>用时:{{scoresDetail.use_time}}</view>
					<view>交卷:{{scoresDetail.create_time}}</view>
				</view>
				
				<view class="w-[300rpx] m-auto pt-[20rpx]">
					<view class="bg-[var(--primary-color)] text-[28rpx] text-center text-white rounded-[12rpx] h-[68rpx] leading-[68rpx]" @tap="toCert()" v-if="scoresDetail.is_cert">查看证书</view>
					<view class="bg-[var(--primary-color)] text-[28rpx] mt-[20rpx] text-center text-white rounded-[12rpx] h-[68rpx] leading-[68rpx]" @tap="toExplain(scoresDetail.scores_id)">查看试卷</view>
				</view>
				
			</view>
		</block>
		<u-loading-page :loading="loading" fontSize="16" color="#333"></u-loading-page>
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, computed } from 'vue'
	import { onLoad } from '@dcloudio/uni-app'
	import { redirect, img } from '@/utils/common';
	import { t } from '@/locale'
	import { getScoresDetail } from '@/addon/zzexam/api/exam';

	let scoresDetail = ref<Array<any>>([]);
	let loading = ref<boolean>(true);
	onLoad((option) => {
		loading.value = true;
		getScoresDetail(option.id).then((res) => {
			scoresDetail.value = res.data;
			loading.value = false;
		});
	})
	
	const toExplain = (scores_id: number) => {
		redirect({ url: '/addon/zzexam/pages/exam/explain', param: { scores_id } })
	}
	
	const toCert = () => {
		redirect({ url: '/addon/zzexam/pages/member/certificate'})
	}
	
	
</script>
<style>
	@import '@/addon/zzexam/styles/common.scss';
</style>