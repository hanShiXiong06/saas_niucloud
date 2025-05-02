<template>
	<view class="min-h-[100vh] bg-[var(--page-bg-color)] overflow-hidden" v-if="partnerInfo" :style="themeColor()">
		<!-- 自定义导航栏 -->
		<view class="fixed w-full z-2 !bg-[var(--page-bg-color)]">
			<view class="" :style="headerStyle">
				<!-- #ifdef MP-WEIXIN -->
				<top-tabbar :data="param" class="top-header" />
				<!-- #endif -->
			</view>

			<!-- 顶部内容区域(可滚动) -->
			<view class="header-section">
				<view class="pt-5 pb-3 px-4 bg-[var(--primary-color)] rounded-b-[30rpx] relative overflow-hidden">

					<!-- 背景纹理 -->
					<view class="absolute inset-0 opacity-10">
						<view class="absolute inset-0"
							style="background-image: radial-gradient(circle at 1px 1px, #fff 1px, transparent 0); background-size: 20px 20px;">
						</view>
					</view>
					<!-- 提现面板 -->
					<view
						class="flex items-center justify-between mb-2 relative card-shadow rounded-xl bg-white/10 backdrop-blur-sm p-4"
						@click="applyCashOut()" v-if="memberStore && memberStore.info">
						<view class="flex-1">
							<text class="text-white/80 text-sm mb-1 block">可提现金额(元)</text>
							<view class="flex items-center">
								<text class="text-white text-2xl font-bold">
									{{ memberStore.info ? moneyFormat(memberStore.info.commission) : '0.00' }}
								</text>
								<u-icon color="#B9BAB6" name="arrow-right" class="ml-2"></u-icon>
							</view>
						</view>
						<view
							class="bg-gradient-to-r from-[var(--primary-color)] to-[var(--primary-help-color)] px-7 py-2.5 rounded-full text-[var(--primary-color-light)] font-medium shadow-md hover:shadow-lg transition-all duration-300 text-center min-w-[160rpx]">
							去提现
						</view>
					</view>
					<view class="text-[24rpx] text-white/90 mt-3 ml-1">*下方列表统计所有佣金，包含店铺利润</view>
				</view>
			</view>

			<!-- 搜索框和标签栏 -->
			<view class="search-tab-container">
				<!-- 搜索框 -->
				<view
					class="bg-[#fff] px-[var(--sidebar-m)] py-[16rpx] flex items-center shadow-sm border-t border-gray-50">
					<view class="search-input w-full">
						<text class="nc-iconfont nc-icon-sousuo-duanV6xx1 btn" @click="searchTypeFn()"></text>
						<input class="input" maxlength="50" type="text" v-model="keyword" placeholder="请输入搜索关键词"
							placeholderClass="text-[var(--text-color-light9)] text-[24rpx]" confirm-type="search"
							@confirm="searchTypeFn()">
						<text v-if="keyword" class="nc-iconfont nc-icon-cuohaoV6xx1 clear" @click="keyword = ''"></text>
					</view>
				</view>
				<!-- 标签栏 -->
				<view class="tab-style-1 pt-[4rpx] bg-[#fff] shadow-sm border-b border-gray-100"
					v-if="accountTypeList.length > 0">
					<view class="tab-left flex-1 overflow-x-auto flex-nowrap">
						<view class="tab-left-item whitespace-nowrap"
							:class="{ 'text-primary font-medium border-primary': fromType.from_type === item.from_type && fromType.account_data_gt === item.account_data_gt }"
							v-for="(item, index) in accountTypeList" :key="index" @click="fromTypeFn(item, index)">{{
								item.name }}</view>
					</view>
					<view class="tab-right" @click="handleSelect">
						<view class="tab-right-date">日期</view>
						<view class="nc-iconfont nc-icon-a-riliV6xx-36 tab-right-icon"></view>
					</view>
				</view>
			</view>
		</view>
		<!-- 列表内容 -->
		<mescroll-body ref="mescrollRef" @init="mescrollInit" :down="{ native: true }" @down="refreshData" top="520rpx"
			@up="getListFn">
			<view class="pt-2 pb-5 body-bottom" v-if="list.length">
				<view v-for="(item, index) in list" :key="item.id"
					class="sidebar-margin mb-[var(--top-m)] card-template relative p-[30rpx] rounded-[16rpx] bg-white">
					<view class="flex items-center justify-between mb-[20rpx]">
						<view class="text-[28rpx] font-500 text-[#333] leading-[40rpx]">{{ item.from_type_name }}
						</view>
						<view class="text-[36rpx] font-500 text-[#03B521] leading-[50rpx] price-font"
							:class="{ '!text-[var(--price-text-color)]': item.account_data > 0 }">{{
								item.account_data >
									0
									? '+' + item.account_data : item.account_data }}</view>
					</view>
					<view class="text-[24rpx] text-[var(--text-color-light6)] mb-[14rpx]" v-if="item.memo">{{
						item.memo
					}}</view>
					<view class="text-[24rpx] text-[var(--text-color-light6)]">{{ item.create_time }}</view>
				</view>
			</view>
			<mescroll-empty :option="{ tip: tip }" v-if="!list.length && loading"></mescroll-empty>
		</mescroll-body>
		<!-- 时间选择 -->
		<select-date ref="selectDateRef" @confirm="confirmFn" />

		<!-- 返回顶部按钮 -->
		<view class="back-top" v-if="showBackTop" @click="backToTop">
			<u-icon name="arrow-up" color="#666" size="24"></u-icon>
		</view>

		<!-- 加载中遮罩 -->
		<view class="loading-mask flex items-center justify-center" v-if="isRefreshing">
			<view class="loading-content flex flex-col items-center bg-black/70 rounded-lg px-5 py-4">
				<view class="loading-spinner mb-2"></view>
				<text class="text-white text-sm">加载中...</text>
			</view>
		</view>
		<tabbar addon="tk_partner_partner" />
	</view>
</template>

<script setup lang="ts">
import { ref, nextTick, reactive, computed, onMounted } from 'vue'
import { t } from '@/locale'
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
import { getBalanceList, getMoneyList, getCommissionList } from '@/app/api/member';
import { onLoad,onShow } from '@dcloudio/uni-app';
import selectDate from '@/components/select-date/select-date.vue';
import { img, redirect, moneyFormat } from '@/utils/common';
import useMemberStore from '@/stores/member';
import useConfigStore from '@/stores/config';
import { checkPartnerOpenEvent } from '@/addon/tk_partner/utils/ts/common';
onShow(()=>{
	checkPartnerOpenEvent()
})
/********* 自定义头部 - start ***********/
import { topTabar } from '@/utils/topTabbar'
const topTabarObj = topTabar()
let param = topTabarObj.setTopTabbarParam({ title: '店铺佣金', topStatusBar: { bgColor: '#fff', textColor: '#333' } })
/********* 自定义头部 - end ***********/

// 获取系统状态栏的高度
let menuButtonInfo: any = {};
// 如果是小程序，获取右上角胶囊的尺寸信息，避免导航栏右侧内容与胶囊重叠(支付宝小程序非本API，尚未兼容)
// #ifdef MP-WEIXIN || MP-BAIDU || MP-TOUTIAO || MP-QQ
menuButtonInfo = uni.getMenuButtonBoundingClientRect();
// #endif
const headerStyle = computed(() => {
	return {
		backgroundImage: 'url(' + img('static/resource/images/member/commission/commission_bg.png') + ') ',
		backgroundSize: 'cover',
		backgroundRepeat: 'no-repeat',
		backgroundPosition: 'bottom',
	}
})
//  16为自定头部的padding-bottom
const mescrollTop = computed(() => {
	return Object.keys(menuButtonInfo).length ? (Number(menuButtonInfo.height) * 2 + menuButtonInfo.top * 2 + 470 + 16) + 'rpx' : '470rpx'
})

const memberStore = useMemberStore();
const memberInfo = computed(() => memberStore.info)
const { mescrollInit, downCallback, getMescroll } = useMescroll();

const showBackTop = ref(false);
const isRefreshing = ref(false);

// 返回顶部
const backToTop = () => {
	uni.pageScrollTo({
		scrollTop: 0,
		duration: 300
	});
};

// 下拉刷新
const refreshData = (mescroll: any) => {
	isRefreshing.value = true;

	// 刷新数据
	Promise.all([
		getPartnerInfo({ type: 'partner' }).then((res: any) => {
			partnerInfo.value = res.data;
		}),
		getStat().then((res: any) => {
			stat.value = res.data;
		})
	]).finally(() => {
		// 刷新列表
		list.value = [];
		getMescroll().resetUpScroll();
		isRefreshing.value = false;
		mescroll.endSuccess();
	});
};

// 提现
const applyCashOut = () => {
	uni.setStorageSync('cashOutAccountType', 'commission')
	redirect({ url: '/app/pages/member/apply_cash_out' })
}
const type = ref('')
const tip = ref('')
import { getPartnerInfo, getStat } from '@/addon/tk_partner/api/partner';
const partnerInfo = ref()
getPartnerInfo({ type: 'partner' }).then((res: any) => {
	partnerInfo.value = res.data
})
const stat = ref()
getStat().then((res: any) => {
	stat.value = res.data
})
onLoad((options: any) => {
	type.value = options.type || 'commission';
	nextTick(() => {
		setTimeout(() => {
			if (type.value == 'balance') {
				tip.value = t('balanceEmptyTip')
			} else if (type.value == 'money') {
				tip.value = t('moneyEmptyTip')
			} else if (type.value == 'commission') {
				tip.value = t('commissionEmptyTip')
			}
		}, 100);
	})
});

const keyword = ref<string>('')
const create_time = ref([])
//来源类型
const fromType = ref({
	from_type: '',
	account_data_gt: ''
})
const accountTypeList = ref([
	{ name: '全部', from_type: '', account_data_gt: '' },
	{ name: '佣金', from_type: '', account_data_gt: 0 },
	{ name: '提现', from_type: 'cash_out', account_data_gt: '' },
])
const list = ref<Array<any>>([]),
	loading = ref<boolean>(false),
	mescrollRef = ref(null);

interface mescrollStructure {
	num: number,
	size: number,
	endSuccess: Function,
	[propName: string]: any
}

const getListFn = (mescroll: mescrollStructure) => {
	loading.value = false;
	let data: Object = {
		page: mescroll.num,
		page_size: mescroll.size,
		keyword: keyword.value,
		create_time: create_time.value,
		from_type: fromType.value.from_type,
		account_data_gt: fromType.value.account_data_gt
	};

	let fnList: any = (params: any) => {
	};
	if (type.value == 'balance') fnList = getBalanceList;
	else if (type.value == 'money') fnList = getMoneyList;
	else if (type.value == 'commission') fnList = getCommissionList;

	fnList(data).then((res: any) => {
		let newArr = res.data.data;
		mescroll.endSuccess(newArr.length);
		//设置列表数据
		if (mescroll.num == 1) {
			list.value = []; //如果是第一页需手动制空列表
		}
		list.value = list.value.concat(newArr);
		loading.value = true;
	}).catch(() => {
		loading.value = true;
		mescroll.endErr(); // 请求失败, 结束加载
	})
}

// 关键词搜索条件搜索
const searchTypeFn = () => {
	list.value = [];
	getMescroll().resetUpScroll();
}
// 类型搜索
const fromTypeFn = (data: any, index: number) => {
	fromType.value.from_type = data.from_type
	fromType.value.account_data_gt = data.account_data_gt
	list.value = []
	getMescroll().resetUpScroll();
}

//日期筛选
const selectDateRef = ref()
const handleSelect = () => {
	selectDateRef.value.show = true
}
// 确定时间筛选
const confirmFn = (data: any) => {
	create_time.value = data;
	list.value = []
	getMescroll().resetUpScroll();
}
</script>

<style lang="scss">
.header-section {
	width: 100%;
	z-index: 1;
}

.search-tab-container {
	width: 100%;
	position: relative;
	z-index: 1;
	background-color: #fff;
}

.body-bottom {
	padding-bottom: calc(20rpx + constant(safe-area-inset-bottom));
	padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
}

.search-input {
	position: relative;
	display: flex;
	align-items: center;
	height: 72rpx;
	background-color: #f5f5f5;
	border-radius: 36rpx;
	padding: 0 24rpx;

	.btn {
		margin-right: 10rpx;
		font-size: 28rpx;
		color: #999;
	}

	.input {
		flex: 1;
		height: 72rpx;
		font-size: 28rpx;
	}

	.clear {
		font-size: 32rpx;
		color: #999;
	}
}

.card-template {
	box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.05);
	transition: all 0.3s ease;

	&:active {
		transform: scale(0.98);
	}
}

.card-shadow {
	box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.08);
}

.tab-style-1 {
	display: flex;
	align-items: center;
	padding: 20rpx var(--sidebar-m);

	.tab-left {
		display: flex;
		padding-right: 20rpx;

		.tab-left-item {
			position: relative;
			padding: 0 24rpx;
			font-size: 28rpx;
			color: #666;
			line-height: 60rpx;

			&.text-primary {
				color: var(--primary-color);
				font-weight: 500;

				&::after {
					content: '';
					position: absolute;
					bottom: 0;
					left: 50%;
					transform: translateX(-50%);
					width: 20rpx;
					height: 4rpx;
					border-radius: 2rpx;
					background-color: var(--primary-color);
				}
			}
		}
	}

	.tab-right {
		display: flex;
		align-items: center;
		font-size: 26rpx;
		color: #666;
		padding-left: 20rpx;

		.tab-right-date {
			margin-right: 4rpx;
		}

		.tab-right-icon {
			font-size: 30rpx;
		}
	}
}

.back-top {
	position: fixed;
	right: 30rpx;
	bottom: 120rpx;
	width: 80rpx;
	height: 80rpx;
	background: rgba(255, 255, 255, 0.9);
	border-radius: 50%;
	box-shadow: 0 2rpx 10rpx rgba(0, 0, 0, 0.1);
	display: flex;
	justify-content: center;
	align-items: center;
	z-index: 99;

	text {
		font-size: 36rpx;
		color: #666;
	}
}

.loading-mask {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	z-index: 999;
	background-color: rgba(0, 0, 0, 0.1);

	.loading-spinner {
		width: 40rpx;
		height: 40rpx;
		border: 4rpx solid #fff;
		border-radius: 50%;
		border-top-color: transparent;
		animation: spin 0.8s linear infinite;
	}
}

@keyframes spin {
	0% {
		transform: rotate(0deg);
	}

	100% {
		transform: rotate(360deg);
	}
}
</style>
