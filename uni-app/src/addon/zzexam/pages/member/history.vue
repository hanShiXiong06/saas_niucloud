<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh]">
		<view class="fixed left-0 top-0 right-0 z-10" v-if="typeLoading">
			<scroll-view scroll-x="true" class="scroll-Y box-border px-[30rpx] bg-white">
				<view class="flex whitespace-nowrap justify-around">
					<view :class="['text-sm leading-[90rpx]', { 'class-select': type == item.value }]"
						@click="changeTypeFn(item.value)" v-for="(item, index) in typeList">{{item.name}}</view>
				</view>
			</scroll-view>
		</view>
		
		<mescroll-body ref="mescrollRef" top="120rpx" @init="mescrollInit" @down="downCallback" @up="getHistoryListFn">
			<view class="list">
				<view v-for="(item,index) in historyList" :key="index" class="align-center p-[30rpx] relative bg-white rounded-[24rpx] mx-[30rpx] mb-[30rpx]">
					<view class="absolute right-0 top-[-1rpx] w-[80rpx] h-[36rpx] leading-[36rpx] rounded-bl-[24rpx] rounded-tr-[24rpx] text-[#ffffff] bg-[var(--main1-text-color)] text-center text-[22rpx]" @click="delHistoryFn(item.history_id)">删除</view>
					
					<view class="flex" v-if="item.type == 'article'" @click="toArticle(item.target_id)">
						<u--image width="183rpx" height="170rpx" :src="img(item.target.image)" model="aspectFill">
							<template #error>
								<u-icon name="photo" color="#f7f7f7" size="50"></u-icon>
							</template>
						</u--image>
						<view class="flex-1 flex flex-col justify-between ml-[10px]">
							<view class="text-[30rpx] leading-[1.3] multi-hidden mt-[2px]">{{item.target.title}}</view>
							<view class="text-[28rpx] using-hidden mb-[10px] mt-[10px] text-gray-500">{{item.target.category.full_name}}</view>
							<view class="text-[24rpx] text-gray-400 flex justify-between mb-[5px]">
								<text>{{item.target.create_time}}</text>
								<text class="ml-auto">浏览 {{item.target.total_views}}</text>
							</view>
						</view>
					</view>
					<view class="flex" v-if="item.type == 'notice'" @click="toNotice(item.target_id)">
						<u--image width="183rpx" height="170rpx" :src="img(item.target.image)" model="aspectFill">
							<template #error>
								<u-icon name="photo" color="#f7f7f7" size="50"></u-icon>
							</template>
						</u--image>
						<view class="flex-1 flex flex-col justify-between ml-[10px]">
							<view class="text-[30rpx] leading-[1.3] multi-hidden mt-[2px]">{{item.target.title}}</view>
							<view class="text-[28rpx] using-hidden mb-[10px] mt-[10px] text-gray-500">{{item.target.category.full_name}}</view>
							<view class="text-[24rpx] text-gray-400 flex justify-between mb-[5px]">
								<text>{{item.target.create_time}}</text>
								<text class="ml-auto">浏览 {{item.target.total_views}}</text>
							</view>
						</view>
					</view>
					<view class="flex" v-if="item.type == 'know'" @click="toKnow(item.target_id)">
						<u--image width="183rpx" height="170rpx" :src="img(item.target.image)" model="aspectFill">
							<template #error>
								<u-icon name="photo" color="#f7f7f7" size="50"></u-icon>
							</template>
						</u--image>
						<view class="flex-1 flex flex-col justify-between ml-[10px]">
							<view class="text-[30rpx] leading-[1.3] multi-hidden mt-[2px]">{{item.target.title}}</view>
							<view class="text-[28rpx] using-hidden mb-[10px] mt-[10px] text-gray-500">{{item.target.category.full_name}}</view>
							<view class="text-[24rpx] text-gray-400 flex justify-between mb-[5px]">
								<text>{{item.target.create_time}}</text>
								<text class="ml-auto">浏览 {{item.target.total_views}}</text>
							</view>
						</view>
					</view>
					<view class="flex" v-if="item.type == 'exam'" @click="toExam(item.target_id)">
						<view class="relative rounded-[10rpx] overflow-hidden">
							<u--image width="255rpx" height="180rpx" :src="img(item.target.cover)" model="aspectFill">
								<template #error>
									<u-icon name="photo" color="#f7f7f7" size="50"></u-icon>
								</template>
							</u--image>
							
							<view class="absolute left-0 top-[-1rpx] px-[15rpx] h-[40rpx] leading-[40rpx] rounded-br-[10rpx] text-[#ffffff] bg-[var(--main1-text-color)] text-center text-[24rpx]">{{item.target.mode_arr.name}}</view>
							
						</view>
						
						<view class="flex-1 flex flex-col justify-between ml-[10px]">
							<view class="text-[30rpx] leading-[1.3] using-hidden mt-[2px]">{{item.target.title}}</view>
							<view class="text-[26rpx] mt-[20rpx]">
								<text class="text-[var(--light-text-color)]">{{item.target.subject.full_name}}</text>
							</view>
							<view class="flex text-[26rpx] mt-[25rpx] leading-[56rpx]">
								<view class="text-[var(--light-text-color)]"><text class="text-[var(--primary-color)]">{{item.target.exam_num}}</text>次考试</view>
								
								<view class="ml-auto text-[#fff] text-[28rpx] w-[150rpx] h-[52rpx] leading-[52rpx] rounded-[26rpx] bg-[var(--primary-color)] text-center">进入考试</view>
								
							</view>
						</view>
					</view>
				</view>
			</view>
			<view class="mx-[30rpx]">
				<mescroll-empty class="mt-0" :option="{tip : '暂无记录'}" v-if="!historyList.length && loading"></mescroll-empty>
			</view>
			
		</mescroll-body>
		
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad, onShow } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { getHistoryType,getHistoryList,delHistory } from '@/addon/zzexam/api/study';
	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
	import { onPageScroll, onReachBottom } from '@dcloudio/uni-app';
    const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);

	const historyList = ref<Array<any>>([]);
	let typeLoading = ref<boolean>(false);
	let type = ref('exam')
	let typeList = ref([]);
	const mescrollRef = ref(null);
	const loading = ref(false);
	
	onLoad(() => {
		getHistoryTypeFn();
	})
	
	// 获取类型
	const getHistoryTypeFn = () => {
		typeLoading.value = false;
		typeList.value = [];
		let obj = {};
	
		getHistoryType().then((res) => {
			Object.keys(res.data).forEach((item, index) => {
				typeList.value.push({value:item,name:res.data[item]});
			});
			typeLoading.value = true;
		}).catch(() => {
			typeLoading.value = true;
		})
	}
	

	interface mescrollStructure {
		num : number,
		size : number,
		endSuccess : Function,
		[propName : string] : any
	}
	
	const getHistoryListFn = (mescroll : mescrollStructure) => {
		loading.value = false;
		let data : object = {
			page: mescroll.num,
			limit: mescroll.size,
			type: type.value
		};

		getHistoryList(data).then((res) => {
			let newArr = (res.data.data as Array<Object>);
			//设置列表数据
			if (mescroll.num == 1) {
				historyList.value = []; //如果是第一页需手动制空列表
			}
			historyList.value = historyList.value.concat(newArr);
			mescroll.endSuccess(newArr.length);
			loading.value = true;
		}).catch(() => {
			loading.value = true;
			mescroll.endErr(); // 请求失败, 结束加载
		})
	}
	
	// 删除
	const delHistoryFn = (history_id:number) => {
		uni.showModal({
			title: '提示',
			content: '确定要删除该条记录吗？',
			success: res => {
				if (res.confirm) {
					delHistory(history_id).then(() => {
					    getMescroll().resetUpScroll();
					}).catch()
				}
			}
		})
	}
	
	// 切换类型
	const changeTypeFn = (t: string) => {
		type.value = t;
		getMescroll().resetUpScroll();
	};
	
	const toExam = (exam_id: number) => {
		redirect({ url: '/addon/zzexam/pages/exam/detail', param: { exam_id } })
	}
	
	const toKnow = (id: number) => {
		redirect({ url: '/addon/zzexam/pages/study/know/detail', param: { id } })
	}
	
	const toNotice = (id: number) => {
		redirect({ url: '/addon/zzexam/pages/study/notice/detail', param: { id } })
	}
	
	const toArticle = (id: number) => {
		redirect({ url: '/addon/zzexam/pages/study/article/detail', param: { id } })
	}
	
	onMounted(() => {
		setTimeout(() => {
			getMescroll().optUp.textNoMore = t("end");
		}, 500)
	});
	
</script>

<style >
	@import '@/addon/zzexam/styles/common.scss';
</style>