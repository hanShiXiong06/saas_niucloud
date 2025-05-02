<template>
	<view :style="warpCss" class="overflow-hidden">
		<view class="flex py-[30rpx] pl-[30rpx] pr-[20rpx]" @click="toExamList()">
			<view class="h-[32rpx] leading-[32rpx] text-[30rpx]">
				<text class="text-[var(--primary-color)] font-bold">|</text> {{diyComponent.title_text}}
			</view>
			<view class="ml-auto text-gray-400 text-[26rpx] h-[32rpx] leading-[32rpx]">
				<u-icon label="更多" name="arrow-right" labelPos="left" color="text-gray-400" size="12"></u-icon>
			</view>
		</view>
		<view class="exam-wrap">
			<view v-for="(item,index) in examList" :key="index" class="flex align-center mb-[2rpx] p-[30rpx] border-0 border-solid border-t-[2rpx] border-[var(--page-bg-color)]" @click="toExam(item.exam_id)">
				<view class="relative rounded-[10rpx] overflow-hidden">
					<u--image width="255rpx" height="180rpx" :src="img(item.cover)" model="aspectFill">
						<template #error>
							<u-icon name="photo" color="#f7f7f7" size="50"></u-icon>
						</template>
					</u--image>
					<view class="absolute left-0 top-[0rpx] w-[80rpx] h-[36rpx] leading-[36rpx] rounded-br-[10rpx] text-[#ffffff] bg-[var(--main1-text-color)] text-center text-[22rpx]">{{item.mode_arr.name}}</view>
				</view>
				
				<view class="flex-1 flex flex-col justify-between ml-[10px]">
					<view class="text-[30rpx] leading-[1.3] using-hidden mt-[2px]">{{item.title}}</view>
					<view class="text-[26rpx] mt-[20rpx]">
						<text class="text-[var(--light-text-color)]">{{item.subject.full_name}}</text>
					</view>
					<view class="flex text-[26rpx] mt-[25rpx] leading-[56rpx]">
						<view class="text-[var(--light-text-color)]"><text class="text-[var(--primary-color)]">{{item.exam_num}}</text>次考试</view>
						
						<view class="ml-auto text-[#fff] text-[26rpx] w-[156rpx] h-[50rpx] leading-[50rpx] rounded-[25rpx] bg-[var(--primary-color)] text-center">进入考试</view>
					</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script setup lang="ts">
	import { ref, computed, watch, onMounted } from 'vue';
	import { redirect, img } from '@/utils/common';
	import useDiyStore from '@/app/stores/diy';
	import { getExamComponents } from '@/addon/zzexam/api/exam';

	const props = defineProps(['component', 'index', 'pullDownRefreshCount']);
	const diyStore = useDiyStore();

	const examList = ref<Array<any>>([]);

	const diyComponent = computed(() => {
		if (diyStore.mode == 'decorate') {
			return diyStore.value[props.index];
		} else {
			return props.component;
		}
	})

	const warpCss = computed(() => {
		var style = '';
		
		if(diyComponent.value.componentStartBgColor) {
		    if (diyComponent.value.componentStartBgColor && diyComponent.value.componentEndBgColor) style += `background:linear-gradient(${diyComponent.value.componentGradientAngle},${diyComponent.value.componentStartBgColor},${diyComponent.value.componentEndBgColor});`;
		    else style += 'background-color:' + diyComponent.value.componentStartBgColor + ';';
		}
		
		if (diyComponent.value.topRounded) style += 'border-top-left-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
		if (diyComponent.value.topRounded) style += 'border-top-right-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
		if (diyComponent.value.bottomRounded) style += 'border-bottom-left-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
		if (diyComponent.value.bottomRounded) style += 'border-bottom-right-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
		return style;
	})

	watch(
		() => props.pullDownRefreshCount,
		(newValue, oldValue) => {
			// 处理下拉刷新业务
		}
	)

	const getExamListFn = () => {
		let data = {
			num: diyComponent.value.source == 'all' || diyComponent.value.source == 'subject' ? diyComponent.value.num : '',
			exam_ids: diyComponent.value.source == 'custom' ? diyComponent.value.exam_ids : '',
			subject_id: diyComponent.value.source == 'subject' ? diyComponent.value.subject_id : ''
		}
		getExamComponents(data).then((res) => {
			examList.value = res.data;
		});
	}

	onMounted(() => {
		refresh();
		// 装修模式下刷新
		if (diyStore.mode == 'decorate') {
			watch(
				() => diyComponent.value,
				(newValue, oldValue) => {
					if (newValue && newValue.componentName == 'AddonList') {
						refresh();
					}
				}
			)
		}
	});

	const refresh = () => {
		// 装修模式下设置默认图
		getExamListFn();
	}

	const toExam = (exam_id: number) => {
		if (diyStore.mode == 'decorate') return false;
		redirect({ url: '/addon/zzexam/pages/exam/detail', param: { exam_id } })
	}
	
	const toExamList = () => {
		if (diyStore.mode == 'decorate') return false;
		redirect({ url: '/addon/zzexam/pages/exam/index' })
	}
</script>

<style>
	@import '@/addon/zzexam/styles/common.scss';
</style>
