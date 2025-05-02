<template>
	<view class="bg-[#f8f8f8] min-h-screen overflow-hidden">
		<view class="fixed left-0 top-0 right-0 z-10" v-if="statusLoading">
			<scroll-view scroll-x="true" class="scroll-Y box-border px-[24rpx] bg-white">
				<view class="flex whitespace-nowrap justify-around">
					<view :class="['text-sm leading-[90rpx]',{'class-select': orderState === item.status.toString()}]"
						@click="orderStateFn(item.status)" v-for="(item,index) in orderStateList">{{item.name}}</view>
				</view>
			</scroll-view>
		</view>

		<mescroll-body ref="mescrollRef" top="64rpx" @init="mescrollInit" @down="downCallback" @up="getOrderListFn">
			<view v-if="list.length > 0" class="tk-card" v-for="(item, index) in list" key=index>
				<view class="flex justify-between">
					<view class="flex ">
						<u-image :show-loading="true" :src="img(item.icon)" width="80px" height="80px"></u-image>
						<view class="ml-2 flex flex-col items-start justify-between">
							<view class="font-bold text-xs">{{item.name}}</view>
							<view class="text-xs text-slate-400 text-[#ff0004]">{{item.desc}}</view>
							<view class="flex">
								<view v-if="item.type=='vip'" class="flex">
									<view class="">{{item.num}}</view>
									<block v-for="(item1,index1) in unitData" :key="index1">
										<view class="" v-if="item.unit==item1.unit">
											{{item1.name}}
										</view>
									</block>
								</view>
								<view v-if="item.type=='package'" class="flex">
									<view class="">{{item.chat_num}}次</view>
								</view>
							</view>
							<view class="text-[#f43034]">{{item.order_money}}</view>
						</view>

					</view>
					<view class="">
						<view class="tk-tag text-xs"
							:style="configValue ? { background: configValue.buttoncolor } : {}">
							{{item.order_status_arr.name}}
						</view>
					</view>

				</view>

				<view class="flex" style="justify-content: flex-end;">
					<block v-if="item.order_status_arr" v-for="(item1, index1) in item.order_status_arr.member_action">
						<view class="tk-tag ml-2 text-xs text-slate-100"
							:style="configValue ? { background: configValue.buttoncolor } : {}"
							@click="clickbut(item1.class,item)">{{ item1.name }}</view>
					</block>
				</view>

			</view>
			<mescroll-empty :option="{'icon': img('static/resource/images/empty.png')}"
				v-if="!list.length && loading"></mescroll-empty>
		</mescroll-body>
	</view>
	<tabbar addon="ai_chat" />
	<pay ref="payRef" @close="payLoading = false"></pay>
</template>

<script setup lang="ts">
	import { ref } from 'vue';
	import { img, redirect } from '@/utils/common';
	import { getOrderList, getOrderStatus, closeOrder, deleteOrder } from '@/addon/ai_chat/api/order';
	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
	import { onLoad, onPageScroll, onReachBottom } from '@dcloudio/uni-app';
	import { getUnit, getType, getPackageList } from '@/addon/ai_chat/api/package'
	import { getConfig } from '@/addon/ai_chat/api/chat'
	const configValue = ref()
	const getConfigData = async () => {
		const res = await getConfig()
		configValue.value = res.data
	}
	getConfigData()
	const unitData = ref()
	const getUnitEvent = async () => {
		const res = await getUnit()
		unitData.value = res.data
	}
	getUnitEvent()
	const payRef = ref(null)
	const payLoading = ref(false)
	const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
	let list = ref<Array<Object>>([]);
	let loading = ref<boolean>(false);
	let statusLoading = ref<boolean>(false);
	let orderState = ref('')
	let orderStateList = ref([]);
	const listData = ref([])
	onLoad((option) => {
		orderState.value = option.status || "";
		getOrderStatusFn()
	});
	const clickbut = (action, item) => {
		// eval(action)(item);
		if (action == 'gopay') {
			gopay(item)
		}
		if (action == 'del') {
			del(item)
		}
		if (action == 'refund') {
			refund(item)
		}
		if (action == 'close') {
			close(item)
		}


	}
	//支付
	const gopay = (item) => {
		payLoading.value = true;
		payRef.value?.open(item.payInfo.trade_type, item.payInfo.trade_id, '/addon/ai_chat/pages/order/orderlist?status=' + orderState.value);
	}
	//删除
	const del = async (item) => {
		await deleteOrder(item.id)
		getMescroll().resetUpScroll();
	}
	const close = async (item) => {
		await closeOrder(item.id)
		getMescroll().resetUpScroll();
	}
	//退款
	const refund = async (item) => {
		let params : object = {
			id: item.id,
			close_reason: '用户主动退款'
		};
		await applyRefund(params)
		getMescroll().resetUpScroll();
	}
	//评价
	const evaluate = (item) => {
		console.log('evaluate')
	}
	//再来一单
	const again = (item) => {
		console.log('again')
	}
	const getOrderListFn = (mescroll) => {
		loading.value = false;
		let data : object = {
			page: mescroll.num,
			limit: mescroll.size,
			order_status: orderState.value
		};
		getOrderList(data).then((res) => {
			let newArr = (res.data.data as Array<Object>);
			//设置列表数据
			if (mescroll.num == 1) {
				list.value = []; //如果是第一页需手动制空列表
			}
			list.value = list.value.concat(newArr);
			mescroll.endSuccess(newArr.length);
			loading.value = true;
		}).catch(() => {
			loading.value = true;
			mescroll.endErr(); // 请求失败, 结束加载
		})
	}
	const getOrderStatusFn = () => {
		statusLoading.value = false;
		orderStateList.value = [];
		let obj = { name: '全部', status: '' };
		orderStateList.value.push(obj);
		getOrderStatus().then((res) => {
			Object.values(res.data).forEach((item, index) => {
				orderStateList.value.push(item);
			});

			statusLoading.value = true;
		}).catch(() => {
			statusLoading.value = true;
		})
	}
	const orderStateFn = (status) => {
		orderState.value = status.toString();
		list.value = [];
		getMescroll().resetUpScroll();
	};
</script>
<style lang="scss" scoped>
	@import '@/addon/ai_chat/utils/styles/common.scss';

	.class-select {
		position: relative;
		font-weight: bold;

		&::after {
			content: "";
			position: absolute;
			bottom: 0;
			height: 6rpx;
			background-color: var(--primary-color);
			width: 90%;
			left: 50%;
			transform: translateX(-50%);
		}
	}
</style>