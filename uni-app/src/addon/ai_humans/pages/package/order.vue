<template>
	<view class="bg-[var(--page-bg-color)] min-h-screen p-3" :style="themeColor()">
		<view class="fixed left-0 top-0 right-0 z-10" v-if="statusLoading">
			<scroll-view scroll-x="true" class="scroll-Y box-border px-[24rpx] bg-[var(--page-bg-color)]">
				<view class="flex whitespace-nowrap justify-around">
					<view
						:class="['text-sm leading-[90rpx] text-[var(--primary-color)]', { 'class-select': orderState === item.status.toString() }]"
						@click="orderStateFn(item.status)" v-for="(item, index) in orderStateList">{{ item.name }}
					</view>
				</view>
			</scroll-view>
		</view>

		<mescroll-body ref="mescrollRef" top="88rpx" @init="mescrollInit" @down="downCallback" @up="getOrderListFn">
			<view v-if="list.length > 0" class="bg-white/98 rounded-lg p-3 mb-2" v-for="(item, index) in list"
				key=index>
				<view class="flex justify-between">
					<view class="flex ">
						<view class="font-bold text-[28rpx]">{{ item.name }}</view>

					</view>

					<view class="">
						<view
							class="bg-[var(--primary-color-light)] text-[var(--primary-color)] text-xs px-2 py-1 rounded-full "
							:style="configValue ? { background: configValue.buttoncolor } : {}">
							{{ item.order_status_arr.name }}
						</view>
					</view>

				</view>
				<view class="flex items-center justify-between mt-3">

					<view class="text-[#f43034] text-[28rpx]">￥{{ item.order_money }}</view>
					<view class="flex" style="justify-content: flex-end;">
						<block v-if="item.order_status_arr"
							v-for="(item1, index1) in item.order_status_arr.member_action">
							<view
								class="bg-[var(--primary-color-light2)] text-[var(--primary-color)] text-xs px-2 py-1 ml-2 rounded-full "
								:style="configValue ? { background: configValue.buttoncolor } : {}"
								@click="clickbut(item1.class, item)">{{ item1.name }}</view>
						</block>
					</view>

				</view>



			</view>
			<mescroll-empty :option="{ 'icon': img('static/resource/images/empty.png') }"
				v-if="!list.length && loading"></mescroll-empty>
		</mescroll-body>
		<tabbar addon="ai_humans" />
		<pay ref="payRef" @close="payLoading = false"></pay>
	</view>

</template>

<script setup lang="ts">
import { ref } from 'vue';
import { img, redirect } from '@/utils/common';
import { getOrderList, getOrderStatus, deleteOrder } from '@/addon/ai_humans/api/order';
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
import { onLoad, onPageScroll, onReachBottom } from '@dcloudio/uni-app';

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

}
//支付
const gopay = (item) => {
	payLoading.value = true;
	payRef.value?.open('AiHumansPackagePay', item.id, '/addon/ai_humans/pages/package/order?status=' + orderState.value);
}
//删除
const del = async (item) => {
	await deleteOrder(item.id)
	getMescroll().resetUpScroll();
}

//退款
const refund = async (item) => {
	let params: object = {
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
	let data: object = {
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
@import '@/addon/ai_humans/utils/styles/common.scss';

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