<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh] pt-[30rpx]">
		
		<mescroll-body ref="mescrollRef" @init="mescrollInit" @down="downCallback" @up="getErrorsListFn">
			<view class="list">
				<view v-for="(item,index) in errorsList" :key="index" class="align-center p-[30rpx] bg-white rounded-[24rpx] mx-[30rpx] mb-[30rpx] relative" @click="toLink(item.question_id)">
					<view class="absolute right-0 top-[-1rpx] w-[90rpx] h-[36rpx] leading-[36rpx] rounded-bl-[24rpx] rounded-tr-[24rpx] text-[#ffffff] bg-[var(--main1-text-color)] text-center text-[22rpx]" @click.stop="delErrorsFn(item.id)">删除</view>
					
					<view>
						<text class="px-[15rpx] h-[44rpx] leading-[44rpx] rounded-[10rpx] text-[#ffffff] bg-[var(--main1-text-color)] text-center text-[24rpx]">{{item.question.type_name}}</text> {{item.question.title}}
					</view>
					<view class="text-[var(--light-text-color)] mt-[20rpx]">{{item.create_time}}</view>
				</view>
			</view>
			
			<view class="mx-[30rpx]">
				<mescroll-empty :option="{tip : '暂无错题'}" v-if="!errorsList.length && loading"></mescroll-empty>
			</view>
			
		</mescroll-body>
		
		<block v-if="errorsList.length">
			<view class="tab-bar-placeholder"></view>
			<view class="tab-bar fixed left-[var(--sidebar-m)] right-[var(--sidebar-m)] bottom-[0]">
				<button class="primary-btn-bg text-[#fff] h-[80rpx] leading-[80rpx] rounded-[100rpx] text-[26rpx] font-500" @click="toPractice">错题练习</button>
			</view>
		</block>
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad, onShow } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { getErrorsList,delErrors } from '@/addon/zzexam/api/study';
	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
	import { onPageScroll, onReachBottom } from '@dcloudio/uni-app';
    const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);

	const errorsList = ref<Array<any>>([]);
	const mescrollRef = ref(null);
	const loading = ref(false);

	interface mescrollStructure {
		num : number,
		size : number,
		endSuccess : Function,
		[propName : string] : any
	}
	
	const getErrorsListFn = (mescroll : mescrollStructure) => {
		loading.value = false;
		let data : object = {
			page: mescroll.num,
			limit: mescroll.size,
		};

		getErrorsList(data).then((res) => {
			let newArr = (res.data.data as Array<Object>);
			//设置列表数据
			if (mescroll.num == 1) {
				errorsList.value = []; //如果是第一页需手动制空列表
			}
			errorsList.value = errorsList.value.concat(newArr);
			mescroll.endSuccess(newArr.length);
			loading.value = true;
		}).catch(() => {
			loading.value = true;
			mescroll.endErr(); // 请求失败, 结束加载
		})
	}
	
	// 删除
	const delErrorsFn = (id:number) => {
		uni.showModal({
			title: '提示',
			content: '确定要删除该条记录吗？',
			success: res => {
				if (res.confirm) {
					delErrors(id).then(() => {
					    getMescroll().resetUpScroll();
					}).catch()
				}
			}
		})
	}

	onMounted(() => {
		setTimeout(() => {
			getMescroll().optUp.textNoMore = t("end");
		}, 500)
	});
	
	//错题练习
	const toPractice = () => {
		redirect({ url: '/addon/zzexam/pages/study/practice', param: { type:'errors' } })
	}
	
	const toLink = (id:number,type:string) => {
		redirect({ url: '/addon/zzexam/pages/study/question/detail', param: { id } })
	}
	
</script>

<style >
	@import '@/addon/zzexam/styles/common.scss';
</style>