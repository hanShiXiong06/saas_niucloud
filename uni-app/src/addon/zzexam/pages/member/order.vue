<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh]">
		<view class="fixed left-0 top-0 right-0 z-10">
			<scroll-view scroll-x="true" class="scroll-Y box-border px-[30rpx] bg-white">
				<view class="flex whitespace-nowrap justify-around">
					<view :class="['text-sm leading-[90rpx]', { 'class-select': type === item.value.toString() }]"
						@click="changeTypeFn(item.value)" v-for="(item, index) in typeList"> {{item.name}}</view>
				</view>
			</scroll-view>
		</view>
		
		<mescroll-body ref="mescrollRef" top="120rpx" @init="mescrollInit" @down="downCallback" @up="getOrderListFn">
			<view class="list" v-if="orderList.length">
				<template v-for="(item, index) in orderList" :key="index">
					<view class="mb-[30rpx] mx-[30rpx] rounded-[24rpx] p-[30rpx] bg-white" v-if="type == 'exam'" @click="toExam(item.exam_id)">
						<view>
							<view class="flex justify-between items-center">
								<view class="text-[#303133] text-[26rpx] font-400 leading-[36rpx]">
									<text>{{ t('orderNo') }}:</text>
									<text class="ml-[10rpx]">{{ item.order_no }}</text>
									<text class="text-[#303133] text-[26rpx] font-400 nc-iconfont nc-icon-fuzhiV6xx1 ml-[11rpx]" @click.stop="copy(item.order_no)"></text>
								</view>
								<view class="text-[#303133] text-[26rpx] leading-[34rpx] text-primary">已完成</view>
							</view>
							
							<view class="flex box-border mt-[40rpx]">
								<u--image width="212rpx" height="150rpx" :radius="'var(--goods-rounded-big)'" :src="img(item.exam_cover)" mode="aspectFill" />
								<view class="ml-[20rpx] flex flex-1 flex-col box-border">
									<view class="flex justify-between items-baseline">
										<view class="text-[28rpx] leading-[40rpx] using-hidden">{{ item.exam_title }}</view>
									</view>
									
									<view class="leading-[42rpx] mt-[20rpx]">
										<text class="text-[22rpx] price-font">￥</text>
										<text class="text-[36rpx] font-500 price-font">{{parseFloat(item.exam_money).toFixed(2).split('.')[0] }}</text>
										<text class="text-[22rpx] font-500 price-font">.{{parseFloat(item.exam_money).toFixed(2).split('.')[1] }}</text>
									</view>
									<view class="flex justify-between items-baseline text-[#303133] mt-[14rpx]">
										<view class="text-[24rpx] font-400 leading-[34rpx] text-[var(--text-color-light6)]" >创建时间：{{item.create_time}}</view>
									</view>
								</view>
							</view>
						</view>
						<view class="mt-[40rpx] flex z-10">
							<view
								class="inline-block leading-[60rpx]"
								@click="toLink(item)">
								<text>合计：<text class=" text-[var(--price-text-color)] price-font">￥{{ item.order_money }}</text></text>
							</view>
						</view>
					</view>
					
					<view class="mb-[30rpx] mx-[30rpx] rounded-[24rpx] p-[30rpx] bg-white" v-if="type == 'vip'">
						<view>
							<view class="flex justify-between items-center">
								<view class="text-[#303133] text-[26rpx] font-400 leading-[36rpx]">
									<text>{{ t('orderNo') }}:</text>
									<text class="ml-[10rpx]">{{ item.order_no }}</text>
									<text class="text-[#303133] text-[26rpx] font-400 nc-iconfont nc-icon-fuzhiV6xx1 ml-[11rpx]" @click.stop="copy(item.order_no)"></text>
								</view>
								<view class="text-[#303133] text-[26rpx] leading-[34rpx] text-primary">已完成</view>
							</view>
							
							<view class="flex box-border mt-[40rpx]">
								<view class="w-[212rpx] font-600 text-[34rpx] h-[150rpx] bg-[var(--primary-color)] rounded-[10rpx] text-center text-white leading-[150rpx]">
									{{ item.days }}天
								</view>
								<view class="ml-[20rpx] flex flex-1 flex-col box-border">
									<view class="flex justify-between items-baseline">
										<view class="text-[28rpx] leading-[40rpx] font-400 truncate text-[#303133]">{{ item.vip_name }}</view>
									</view>
									
									<view class="leading-[42rpx] mt-[20rpx]">
										<text class="text-[22rpx] price-font">￥</text>
										<text class="text-[36rpx] font-500 price-font">{{parseFloat(item.vip_money).toFixed(2).split('.')[0] }}</text>
										<text class="text-[22rpx] font-500 price-font">.{{parseFloat(item.vip_money).toFixed(2).split('.')[1] }}</text>
									</view>
									<view class="flex justify-between items-baseline text-[#303133] mt-[14rpx]">
										<view class="text-[24rpx] font-400 leading-[34rpx] text-[var(--text-color-light6)]" >创建时间：{{item.create_time}}</view>
									</view>
								</view>
							</view>
						</view>
						<view class="mt-[40rpx] flex z-10">
							<view
								class="inline-block leading-[60rpx]"
								@click="toLink(item)">
								<text>合计：<text class=" text-[var(--price-text-color)] price-font">￥{{ item.order_money }}</text></text>
							</view>
							
							
						</view>
					</view>
				</template>
			</view>
			<view class="mx-[30rpx]">
				<mescroll-empty class="mt-0" :option="{tip : '暂无订单'}" v-if="!orderList.length && loading"></mescroll-empty>
			</view>
		</mescroll-body>
		
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad, onShow } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { getExamOrderList } from '@/addon/zzexam/api/exam';
	import { getVipOrderList } from '@/addon/zzexam/api/vip';
	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
	import { onPageScroll, onReachBottom } from '@dcloudio/uni-app';
    const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);

	const orderList = ref<Array<any>>([]);
	let typeLoading = ref<boolean>(false);
	let type = ref('exam')
	let typeList = ref([
		{name:'购买考试',value:'exam'},
		{name:'开通VIP',value:'vip'}
	]);
	const mescrollRef = ref(null);
	const loading = ref(false);
	
	interface mescrollStructure {
		num : number,
		size : number,
		endSuccess : Function,
		[propName : string] : any
	}
	
	const getOrderListFn = (mescroll : mescrollStructure) => {
		loading.value = false;
		let data : object = {
			page: mescroll.num,
			limit: mescroll.size,
			type: type.value
		};
		
		if(type.value == 'exam'){
			getExamOrderList(data).then((res) => {
				let newArr = (res.data.data as Array<Object>);
				//设置列表数据
				if (mescroll.num == 1) {
					orderList.value = []; //如果是第一页需手动制空列表
				}
				orderList.value = orderList.value.concat(newArr);
				mescroll.endSuccess(newArr.length);
				loading.value = true;
			}).catch(() => {
				loading.value = true;
				mescroll.endErr(); // 请求失败, 结束加载
			})
		}else{
			getVipOrderList(data).then((res) => {
				let newArr = (res.data.data as Array<Object>);
				//设置列表数据
				if (mescroll.num == 1) {
					orderList.value = []; //如果是第一页需手动制空列表
				}
				orderList.value = orderList.value.concat(newArr);
				mescroll.endSuccess(newArr.length);
				loading.value = true;
			}).catch(() => {
				loading.value = true;
				mescroll.endErr(); // 请求失败, 结束加载
			})
		}

		
	}
	
	// 切换类型
	const changeTypeFn = (t: string) => {
		type.value = t;
		orderList.value = [];
		getMescroll().resetUpScroll();
	};
	
	onMounted(() => {
		setTimeout(() => {
			getMescroll().optUp.textNoMore = t("end");
		}, 500)
	});
	
	const toExam = (exam_id: number) => {
		redirect({ url: '/addon/zzexam/pages/exam/detail', param: { exam_id } })
	}
	
</script>

<style >
	@import '@/addon/zzexam/styles/common.scss';
</style>