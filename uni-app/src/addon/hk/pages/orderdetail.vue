<template>
	<view v-if="orderInfo" class="bg-[#f8f8f8] min-h-screen overflow-hidden">
		<view class="tk-card">
			<view class="flex">
				<image style="width: 180rpx; height: 140rpx; background-color: #eeeeee;border-radius: 8px;"
					:src="orderInfo.image" mode="aspectFill"></image>
				<view class="flex flex-col ml-2 w-[100%]" style="">
					<view class="flex items-center">
						<view class="font-bold tk-sltext">{{orderInfo.name}}</view>
						<view class="ml-1">
							<u-tag :text="orderInfo.operator_name" plain size="mini"></u-tag>
						</view>
					</view>
					<view class="mr-2 font-bold text-slate-400">快递:{{orderInfo.logistics_name}}</view>
					<view v-if="orderInfo.logisticsno" class="flex items-center">

						<view class="font-bold" @click="copy(orderInfo.logisticsno)">{{orderInfo.logisticsno}}</view>
						<view class="ml-2">
							<u-icon @click="copy(orderInfo.logisticsno)" name="file-text"></u-icon>
						</view>
					</view>
				</view>

			</view>
		</view>
		<view class="tk-card">
			<view class="flex items-center justify-between mt-1 mb-1">
				<view class="text-slate-400">创建时间</view>
				<view>{{orderInfo.create_time}}</view>
			</view>
			<view class="flex items-center justify-between mt-1 mb-1">
				<view class="text-slate-400">商品名称</view>
				<view>{{orderInfo.name}}</view>
			</view>
			<view v-if="orderInfo.plan_phone" class="flex items-center justify-between mt-1 mb-1">
				<view class="text-slate-400">生产号码</view>
				<view>{{orderInfo.plan_phone}}</view>
			</view>
			<view class="flex items-center justify-between mt-1 mb-1">
				<view class="text-slate-400">当前状态</view>
				<view>
					<u-tag v-if="orderInfo.status==5" type="error" :text="orderInfo.status_name"></u-tag>
					<u-tag v-else :text="orderInfo.status_name"></u-tag>
				</view>
			</view>
			<view v-if="orderInfo.msg" class="flex items-center justify-between mt-1 mb-1">
				<view class="text-slate-400">备注说明</view>
				<view class="text-red">
					{{orderInfo.msg}}
				</view>
			</view>
		</view>
		<view class="tk-card" v-if="orderInfo.logisticsno">
			<!-- 	<view class="flex items-center justify-between mt-1 mb-1">
				<view class="text-slate-400">物流动态</view>
				<view>
					<u-tag text="查询物流" size="mini"></u-tag>
				</view>
			</view> -->
			<view class="flex items-center justify-between mt-1 mb-1">
				<view class="text-slate-400">快递名称</view>
				<view>
					<u-tag :text="orderInfo.logistics_name" plain size="mini"></u-tag>
				</view>
			</view>
			<view class="flex items-center justify-between mt-1 mb-1">
				<view class="text-slate-400">快递单号</view>
				<view class="flex">
					<view class="font-bold" @click="copy(orderInfo.logisticsno)">{{orderInfo.logisticsno}}</view>
					<view class="ml-2">
						<u-icon @click="copy(orderInfo.logisticsno)" name="file-text"></u-icon>
					</view>
				</view>
			</view>
		</view>
		<view class="tk-card">
			<view class="p-2" v-if="orderInfo.logisticsno!=''&&express.length>0">
				<u-steps dot="true" direction="column">
					<block v-for="(item,index) in express" key=index>
						<u-steps-item :title="item.desc" :desc="item.time">
						</u-steps-item>
					</block>
				</u-steps>
			</view>
			<view v-else class="text-xs text-slate-400">暂无运单动态</view>
		</view>
	</view>
	<tabbar addon="hk" />
	<!-- #ifdef MP-WEIXIN -->
	<!-- 小程序隐私协议 -->
	<wx-privacy-popup ref="wxPrivacyPopup"></wx-privacy-popup>
	<!-- #endif -->
</template>

<script setup lang="ts">
	import { ref } from 'vue'
	import { onLoad } from '@dcloudio/uni-app';
	import useDiyStore from '@/app/stores/diy'
	import { img, redirect, copy } from '@/utils/common'
	import { getOrderInfo,queryExpress } from '@/addon/hk/api/hk'
	import { useShare } from '@/hooks/useShare'
	const { setShare, onShareAppMessage, onShareTimeline } = useShare()
	setShare();
	onShareAppMessage()
	onShareTimeline()
	const orderInfo = ref()
    const express=ref()
	const queryExpressEvent = async (id) => {
	    queryExpress(id).then((res) => {
	        express.value = res.data
	    })
	}

	const getOrderInfoEvent = async (id) => {
		const res = await getOrderInfo(id)
		orderInfo.value = res.data
	}
	onLoad((options) => {
		if (options.id) {
			getOrderInfoEvent(options.id)
			queryExpressEvent(options.id)
		} else {
			uni.navigateBack()
		}
	})
</script>


<style lang="scss" scoped>
	@import '@/addon/hk/utils/styles/common.scss';

	.line-box {
		background-color: #EEEEEE;
		height: 2rpx;
		width: 100%;
	}

	.card {
		background: linear-gradient(-180deg, #faead1 0%, #faead1 100%);
		margin: 24rpx;
		border-radius: 12rpx;

		bbbox-shadow: 0 1px 1px 0 rgba(234, 234, 234, 0.2), 0 2px 2px 0 rgba(231, 231, 231, 0.2);
	}

	.card1 {
		background: linear-gradient(-180deg, #fafafa 0%, #ffffff 100%);

		border-radius: 12rpx;

		bbbox-shadow: 0 1px 1px 0 rgba(234, 234, 234, 0.2), 0 2px 2px 0 rgba(231, 231, 231, 0.2);
	}
</style>