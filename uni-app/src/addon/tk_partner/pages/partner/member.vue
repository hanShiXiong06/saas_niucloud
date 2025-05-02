<template>
	<mescroll-body ref="mescrollRef" @init="mescrollInit" @down="downCallback" @up="getPartnerMemberListFn">
		<view class="px-4 py-3 bg-gray-50 min-h-screen">
			<view v-for="(item, index) in listData" :key="index"
				class="bg-white rounded-xl shadow mb-4 overflow-hidden transition-all duration-300 hover:shadow-lg transform hover:-translate-y-1">
				<!-- 会员信息头部 -->
				<view
					class="flex justify-between items-center px-4 py-3 border-b border-gray-100 bg-gradient-to-r from-gray-50 to-white">
					<view class="flex items-center space-x-2">
						<image class="w-[90rpx] h-[90rpx] rounded-full border-2 border-white shadow-md"
							:src="img(item.member_info && item.member_info.headimg ? item.member_info.headimg : 'static/resource/images/default_headimg.png')"
							mode="aspectFill">
						</image>
						<view class="flex flex-col">
							<text class="font-bold text-base text-gray-800">{{ item.member_info.nickname || "--"
							}}</text>
							<text class="text-xs text-gray-500 mt-1">进店时间: {{ item.create_time
							}}</text>
						</view>
					</view>

				</view>

				<!-- 数据统计区域 -->
				<view class="p-4">
					<view class="rounded-lg overflow-hidden shadow-sm bg-gradient-to-br from-white to-gray-50">
						<!-- 统计信息网格 -->
						<view class="grid grid-cols-2 divide-x divide-gray-100">
							<!-- 订单数量 -->
							<view class="p-3">
								<view class="flex flex-col items-center">
									<view class="flex items-center text-xs text-gray-600 mb-1">
										<text class="i-uil:shopping-bag mr-1.5 text-themeColor"></text>
										订单数量
									</view>
									<view class="text-lg font-bold text-themeColor">{{ item.order_num }}</view>
								</view>
							</view>

							<!-- 佣金收益 -->
							<view class="p-3">
								<view class="flex flex-col items-center">
									<view class="flex items-center text-xs text-gray-600 mb-1">
										<text class="i-uil:money-bill-stack mr-1.5 text-red-500"></text>
										结算收益
									</view>
									<view class="text-lg font-bold text-red-500">¥{{ item.commission }}</view>
								</view>
							</view>
						</view>
					</view>
				</view>
			</view>
		</view>
		<mescroll-empty v-if="!listData?.length" :option="{ tip: '暂无会员数据' }"></mescroll-empty>
	</mescroll-body>
	<tabbar addon="tk_partner_partner" />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import {
	getPartnerMemberList
} from '@/addon/tk_partner/api/member'
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
import useMescroll from '@/components/mescroll/hooks/useMescroll.js'
import { onPageScroll, onReachBottom } from '@dcloudio/uni-app'
import { img, redirect } from '@/utils/common';

const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
const listData = ref();
const loading = ref<boolean>(false);
import { checkPartnerOpenEvent } from '@/addon/tk_partner/utils/ts/common';
onShow(()=>{
	checkPartnerOpenEvent()
})
const getPartnerMemberListFn = (mescroll: any) => {
	const data = ref<{ page?: number, page_size?: number }>({});

	loading.value = false;
	data.value.page = mescroll.num;
	data.value.page_size = mescroll.size;

	getPartnerMemberList(data.value).then((res: any) => {
		const newArr = res.data.data;
		mescroll.endSuccess(newArr.length);

		if (mescroll.num == 1) {
			listData.value = []; //如果是第一页需手动制空列表
		}
		listData.value = listData.value.concat(newArr);
		loading.value = true;
	}).catch((e) => {
		loading.value = true;
		mescroll.endErr(); // 请求失败, 结束加载
	})
}

// 格式化日期
const formatDate = (timestamp: string | number) => {
	if (!timestamp) return '--';
	const date = new Date(Number(timestamp) * 1000);
	return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

// 查看会员详情
const viewMemberDetail = (item: any) => {
	uni.navigateTo({
		url: `/addon/tk_partner/pages/partner/member-detail?id=${item.member_id}`
	});
}

// 联系会员
const contactMember = (item: any) => {
	// 处理联系会员的逻辑
	uni.showToast({
		title: '联系功能开发中',
		icon: 'none'
	});
}
</script>

<style lang="scss" scoped>
@import '@/addon/tk_partner/utils/styles/common.scss';

:deep(.u-image) {
	border-radius: theme('borderRadius.md');
}

.line-clamp-2 {
	display: -webkit-box;
	-webkit-line-clamp: 2;
	-webkit-box-orient: vertical;
	overflow: hidden;
}

/* 增加过渡动画效果 */
.transform {
	transition: transform 0.3s ease, box-shadow 0.3s ease;
}

button {
	transition: all 0.2s ease;
}

button:active {
	transform: scale(0.97);
	opacity: 0.9;
}
</style>