<template>
	<view :style="warpCss">
		<view :style="maskLayer"></view>
		<view v-if="diyComponent.operatorshow=='1'">
			<scroll-view scroll-x="true" class="scroll-X box-border px-[24rpx] ">
				<view class="flex flex-row mb-2" style="width: max-content;"
					:style="{ color:diyComponent.operatorfontcolor }">
					<view class="x-tabs-box"
						:class="['text-sm leading-[60rpx] mr-4', {'class-select': operator === item.operator}]"
						:style="{ color:operator == item.operator ?  diyComponent.operatorselectfontcolor:diyComponent.operatorfontcolor, background: operator === item.operator ? diyComponent.operatorbackground : 'transparent' }"
						@click="selectOperator(item.operator)" v-for="(item,index) in operatorData"
						style="display: inline-block;">
						{{item.name}}
					</view>
				</view>
			</scroll-view>
		</view>

		<view v-if="list.length > 0" class="tk-card !mb-3 !p-3" v-for="(item, index) in list" key=index
			:style="{ background:diyComponent.background}"
			@click="redirect({url:'/addon/hk/pages/detail?id='+item.id})">
			<view class="flex">
				<view v-if="diyComponent.iconshow=='1'"><u-image :show-loading="true" :src="img(item.img)"
						:width="diyComponent.iconsize" :height="diyComponent.iconsize"
						:radius="diyComponent.radiussize"></u-image>
				</view>
				<view class="ml-2 mr-2 flex flex-col justify-between" style="width:100%">
					<view>
						<view class="flex justify-between">
							<view class="font-bold text-[32rpx] leading-[42rpx] tk-sltext w-[80%]"
								:style="{ color:diyComponent.titlecolor,fontSize:diyComponent.titlesize+'px', }">
								{{item.title}}
							</view>
							<view v-if="diyComponent.logoshow=='1'">
								<block v-for="(itemo,indexo) in operatorData">
									<u-icon v-if="itemo.operator==item.operator" :name="img(itemo.icon)"
										size="22"></u-icon>
								</block>
							</view>
						</view>

						<view class="flex mt-1" v-if="diyComponent.ageshow=='1'">
							<view>
								<u-tag size="mini" :bgColor="diyComponent.agebgcolor" :color="diyComponent.agetextcolor"
									:borderColor="diyComponent.agebordercolor"
									:text="item.minage+'~'+item.maxage+'岁'"></u-tag>
							</view>
						</view>
						<view v-if="diyComponent.packageshow=='1'">
							<view class="flex items-center">
								<view>
									<u-icon :color="diyComponent.packagecolor" name="bookmark-fill" size="12"></u-icon>
								</view>
								<view class="ml-1 text-[#64748B]" :style="{color:diyComponent.packagecolor}">
									通用流量{{item.generalized}}G</view>
							</view>
							<view class="flex items-center">
								<view>
									<u-icon :color="diyComponent.packagecolor" name="bookmark-fill" size="12"></u-icon>
								</view>
								<view class="ml-1 text-[#64748B]" :style="{color:diyComponent.packagecolor}">
									定向流量{{item.directional}}G</view>
							</view>
							<view class="flex items-center">
								<view>
									<u-icon :color="diyComponent.packagecolor" name="bookmark-fill" size="12"></u-icon>
								</view>
								<view class="ml-1 text-[#64748B]" :style="{color:diyComponent.packagecolor}">
									通话{{item.connected}}</view>
							</view>
						</view>

					</view>


				</view>
			</view>
			<view class="line-box mt-2 mb-2 !h-[2rpx]" :style="{background:diyComponent.linebackground}"></view>
			<view class="flex justify-between items-center">
				<view v-if="item.tag&&item.tag!=null" class="flex flex-wrap mt-1">
					<block v-for="(item1,index) in item.tag">
						<view class="mr-1 mb-1">
							<u-tag size="mini" :bgColor="diyComponent.tagbgcolor" :color="diyComponent.tagtextcolor"
								:borderColor="diyComponent.tagbordercolor" plain :text="item1"></u-tag>
						</view>
					</block>
				</view>
				<view v-else class="w-[65%] font-bold text-slate-600 flex flex-wrap"
					:style="{ color:diyComponent.desccolor,fontSize:diyComponent.descsize+'px', }">{{item.desc}}</view>
				<view class="flex justify-end" @click="redirect({url:'/addon/hk/pages/detail?id='+item.id})">
					<view class="text-center" :style="{ background:diyComponent.btbackground,color:diyComponent.btcolor,borderRadius:diyComponent.btradius+'px',
							fontSize:diyComponent.btsize+'px',
							 paddingLeft:diyComponent.btpadding+'px',
							  paddingRight:diyComponent.btpadding+'px',
							  paddingTop:diyComponent.btpadding1+'px',
							   paddingBottom:diyComponent.btpadding1+'px'
							 }">
						{{diyComponent.bttext}}
					</view>
				</view>

			</view>


			<view v-if="list.length == 0" class="text-center text-slate-400 text-sm mb-4">暂无数据</view>
		</view>

	</view>
</template>

<script setup lang="ts">
	import { ref, computed, watch, onMounted, nextTick, getCurrentInstance } from 'vue';
	import useDiyStore from '@/app/stores/diy';
	import { img, redirect } from '@/utils/common';
	import { getOperator, getProductList } from '@/addon/hk/api/hk'
	import { onLoad, onPageScroll, onReachBottom } from "@dcloudio/uni-app";
	const goDetail = (id) => {
		redirect({ url: '/addon/hk/pages/detail?id=' + id })
	}
	let list = ref<Array<Object>>([]);
	let loading = ref<boolean>(false);
	const page = ref(1)

	const props = defineProps(['component', 'index', 'pullDownRefreshCount']);

	const diyStore = useDiyStore();

	const diyComponent = computed(() => {
		if (diyStore.mode == 'decorate') {
			return diyStore.value[props.index];
		} else {
			return props.component;
		}
	})

	const warpCss = computed(() => {
		var style = '';
		style += 'position:relative;';
		if (diyComponent.value.componentStartBgColor) {
			if (diyComponent.value.componentStartBgColor && diyComponent.value.componentEndBgColor) style += `background:linear-gradient(${diyComponent.value.componentGradientAngle},${diyComponent.value.componentStartBgColor},${diyComponent.value.componentEndBgColor});`;
			else style += 'background-color:' + diyComponent.value.componentStartBgColor + ';';
		}

		if (diyComponent.value.componentBgUrl) {
			style += `background-image:url('${img(diyComponent.value.componentBgUrl)}');`;
			style += 'background-size: cover;background-repeat: no-repeat;';
		}

		if (diyComponent.value.topRounded) style += 'border-top-left-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
		if (diyComponent.value.topRounded) style += 'border-top-right-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
		if (diyComponent.value.bottomRounded) style += 'border-bottom-left-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
		if (diyComponent.value.bottomRounded) style += 'border-bottom-right-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
		return style;
	})

	// 背景图加遮罩层
	const maskLayer = computed(() => {
		var style = '';
		if (diyComponent.value.componentBgUrl) {
			style += 'position:absolute;top:0;width:100%;';
			style += `background: rgba(0,0,0,${diyComponent.value.componentBgAlpha / 10});`;
			style += `height:${height.value}px;`;

			if (diyComponent.value.topRounded) style += 'border-top-left-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
			if (diyComponent.value.topRounded) style += 'border-top-right-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
			if (diyComponent.value.bottomRounded) style += 'border-bottom-left-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
			if (diyComponent.value.bottomRounded) style += 'border-bottom-right-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
		}

		return style;
	});

	watch(
		() => props.pullDownRefreshCount,
		(newValue, oldValue) => {
			// 处理下拉刷新业务
		}
	)

	onMounted(() => {
		refresh();
		// 装修模式下刷新
		if (diyStore.mode == 'decorate') {
			watch(
				() => diyComponent.value,
				(newValue, oldValue) => {
					if (newValue && newValue.componentName == 'RichText') {
						refresh();
					}
				}
			)
		}
	});

	const instance = getCurrentInstance();
	const height = ref(0)

	const refresh = () => {
		nextTick(() => {
			const query = uni.createSelectorQuery().in(instance);
			query.select('.diy-rich-text').boundingClientRect((data : any) => {
				height.value = data.height;
			}).exec();
		})
	}
	const operatorData = ref([])
	const operator = ref('')

	const selectOperator = (e) => {
		operator.value = e
		page.value = 1
		list.value = []
		getProductListEvent()
	}
	onReachBottom(() => {
		page.value++
		getProductListEvent()
	});

	const getOperatorEvent = async () => {
		let data : object = {
			page: 1,
			limit: 50,
		};
		let obj = { name: '全部', operator: '' };
		operatorData.value.push(obj);
		getOperator().then((res) => {
			Object.values(res.data).forEach((item, index) => {
				operatorData.value.push(item);
			});

		}).catch(() => {
		})

	}
	getOperatorEvent()
	const getProductListEvent = async () => {
		let data = {
			page: page.value, // 当前页数，从1开始
			limit: diyComponent.value.num ? diyComponent.value.num : 15,
			operator: operator.value,
		};
		const res = await getProductList(data)
		let newArr = res.data.data as Array<Object>;
		if (newArr.length == 0) {
			loading.value = false;
			uni.showToast({
				title: "已经没有更多数据",
				icon: "none",
			});
			return
		}
		if (list.value == []) {
			list.value = newArr;
		} else {
			list.value = list.value.concat(newArr);
		}

	}
	getProductListEvent()
</script>

<style lang="scss" scoped>
	@import '@/addon/hk/utils/styles/common.scss';

	.class-select {
		padding: 0rpx 20rpx;
		color: #2EA7E0;
		background: #E7F3FF;
		border-color: #B4DEF7;
		border-radius: 50rpx;
	}

	.bottom {
		justify-content: space-between;
	}

	.price {
		color: #FF3D3D;
		font-size: 36rpx;
		font-weight: bold;

		&::before {
			content: '￥';
			font-size: 18rpx;
		}

		&::after {
			content: '起';
			font-size: 18rpx;
		}
	}

	.x-tabs-box {
		display: flex;
		align-items: center;
		gap: 20rpx;

		.x-tabs-box-item {
			padding: 10rpx 30rpx;
			background: white;
			color: #a3a3a3;
			border-radius: 50rpx;
		}

		.x-tabs-box-item-active {
			background: #e8f3ff;
			border: 1px solid #c2e4f8;
			color: #44b2e5;
		}
	}

	.content {
		margin: 0 30rpx;
		background: white;
		border-radius: 24rpx;
		margin-top: 30rpx;
	}

	.goods {
		display: flex;
		padding-top: 24rpx;
		padding-left: 20rpx;
		justify-content: space-between;

		.cover {
			width: 180rpx;
			height: 180rpx;
			border-radius: 20rpx;
		}

		.details {
			display: flex;
			flex-direction: column;
			justify-content: space-between;
			height: 204rpx;
			width: 416rpx;
			padding-right: 24rpx;
			padding-bottom: 24rpx;
			border-bottom: 2rpx solid #F2F2F2;
		}

		.title {
			width: 100%;
			font-weight: bold;
			font-size: 32rpx;
			color: #333333;
			line-height: 38rpx;
		}

		.bottom {
			justify-content: space-between;
		}

		.price {
			color: #FF3D3D;
			font-size: 36rpx;
			font-weight: bold;

			&::before {
				content: '￥';
				font-size: 24rpx;
			}

			&::after {
				content: '起';
				font-size: 24rpx;
			}
		}

		.buttton {

			overflow: hidden;
			display: flex;

			view {
				width: 112rpx;
				height: 60rpx;
				line-height: 60rpx;
				text-align: center;
			}

			.left {
				color: #2EA7E0;
				background: #E9F4FF;
			}

			.right {
				color: white;
				background: #2EA7E0;
				padding: 0 40rpx;
				border-radius: 40rpx;
			}

		}
	}

	.tk-card {
		background-color: rgba(255, 255, 255, 0.9);
		margin: 12rpx;
		border-radius: 12rpx;

		bbbox-shadow: 0 1px 1px 0 rgba(234, 234, 234, 0.2), 0 2px 2px 0 rgba(231, 231, 231, 0.2);
	}
</style>