<template>
	<view class="bg-[#f0f0f0] min-h-[100vh] relative">
		<mescroll-body ref="mescrollRef" @init="mescrollInit" @down="downCallback" @up="getOrderListsFn">
			<view class="mb-2 z-1000" v-if="orderStatusData">
				<scroll-view scroll-x="true" class="scroll-Y box-border px-[24rpx] bg-white">
					<view class="flex whitespace-nowrap justify-around">
						<view :class="['text-sm leading-[90rpx]',{'class-select': status == item.status}]"
							@click="orderStateFn(item)" v-for="(item,index) in orderStatusData">{{item.name}}</view>
					</view>
				</scroll-view>
			</view>
			<view class="tk-card !mb-3 !p-3" v-for="(item,index) in list">
				<view class="flex justify-between mb-2">
					<view class="text-xs">订单号:{{item.order_id}}</view>
					<view>
						<u-tag :text="item.status_name" plain size="mini" v-if="item.status!=5"></u-tag>
						<u-tag :text="item.status_name" plain size="mini" v-else type="error"></u-tag>
					</view>
				</view>
				<view class="flex">
					<image style="width: 180rpx; height: 140rpx; background-color: #eeeeee;border-radius: 8px;"
						:src="img(item.image)" mode="aspectFill"></image>
					<view class="flex flex-col ml-2 w-[100%] " style="">
						<view class="font-bold tk-sltext text-xs">{{item.name}}</view>
						<view class="mt-1">
							<u-tag size="mini" :text="item.operator_name"></u-tag>
						</view>
						<view class="text-xs mt-1 font-bold text-red-400" v-if="item.msg">提示:{{item.msg}}</view>
					</view>
				</view>
				<view class="line-box mt-2 mb-2"></view>
				<view class="flex items-center justify-between">
					<view class="text-xs text-slate-400">{{item.create_time}}</view>
					<view>
						<u-tag @click="redirect({url:'/addon/hk/pages/orderdetail?id='+item.id})" size="mini"
							text="查看详情" plain></u-tag>
					</view>
				</view>

			</view>

			<mescroll-empty :option="{'icon': img('static/resource/images/empty.png')}"
				v-if="!list.length && loading"></mescroll-empty>
		</mescroll-body>
	</view>
	<tabbar addon="hk" />
	<!-- #ifdef MP-WEIXIN -->
	<!-- 小程序隐私协议 -->
	<wx-privacy-popup ref="wxPrivacyPopup"></wx-privacy-popup>
	<!-- #endif -->
</template>

<script setup lang="ts">
	import { ref } from 'vue'
	import MescrollUni from '@/components/mescroll/mescroll-uni/mescroll-uni.vue';
	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
	import { onLoad, onPageScroll, onReachBottom } from '@dcloudio/uni-app';
	import useDiyStore from '@/app/stores/diy'
	const { mescrollInit, downCallback, getMescroll } = useMescroll()
	import { img, redirect } from '@/utils/common'
	import { useShare } from '@/hooks/useShare'
	import { getOrderLists, getOrderStatus } from '@/addon/hk/api/hk'
	const { setShare, onShareAppMessage, onShareTimeline } = useShare()
	let list = ref<Array<Object>>([]);
	let loading = ref<boolean>(false);
	const upCallback = (mescroll) => {
		getOrderListsFn(mescroll).then(res => {
		}).catch(() => {
			mescroll.endErr()
		})
	}
	setShare();
	onShareAppMessage()
	onShareTimeline()
	const status = ref('')
	const orderStatusData = ref([])
	getOrderStatus().then((res) => {
		orderStatusData.value.push({
			status: '',
			name: '全部'
		})
		Object.values(res.data).forEach((item, index) => {
			orderStatusData.value.push(item);
		});
	})
	const orderStateFn = (item) => {
		status.value = item.status
		list.value = [];
		getMescroll().resetUpScroll();
	}
	const listData = ref([])
	const getOrderListsFn = (mescroll) => {
		loading.value = false;
		let data : object = {
			page: mescroll.num,
			limit: mescroll.size,
			status: status.value,
		};
		getOrderLists(data).then((res) => {
			let newArr = (res.data.data as Array<Object>);
			//设置列表数据
			if (mescroll.num == 1) {
				list.value = []; //如果是第一页需手动制空列表
			}

			if (newArr == []) {
				uni.$u.toast('已经全部加载了')
				mescroll.endSuccess(newArr.length);
				loading.value = true;
			}
			list.value = list.value.concat(newArr);
			mescroll.endSuccess(newArr.length);
			loading.value = true;
		}).catch(() => {
			loading.value = true;
			mescroll.endErr(); // 请求失败, 结束加载
		})
	}

	onLoad(() => {

	})
</script>


<style lang="scss" scoped>
	@import '@/addon/hk/utils/styles/common.scss';

	.line-box {
		background-color: #EEEEEE;
		height: 2rpx;
		width: 100%;
	}

	.class-select {
		position: relative;
		font-weight: bold;

		&::after {
			content: "";
			position: absolute;
			bottom: 0;
			height: 6rpx;
			background-color: #FE6D3A;
			width: 90%;
			left: 50%;
			transform: translateX(-50%);
		}
	}
</style>