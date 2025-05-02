<template>
	<view class="min-h-[100vh] w-full bg-gradient-to-b from-gray-50 to-gray-100" :style="themeColor()">
		<mescroll-body ref="mescrollRef" @init="mescrollInit" @down="downCallback" @up="getOrderListFn">
			<view class="px-3 py-2 min-h-screen">
				<mescroll-empty v-if="!listData?.length" :option="{ tip: '暂无订单数据' }"></mescroll-empty>
				<view v-for="(item, index) in listData" :key="index"
					class="bg-white rounded-lg shadow mb-3 overflow-hidden transition-all duration-300 hover:shadow-lg transform hover:-translate-y-0.5">
					<!-- 订单头部 -->
					<view
						class="flex justify-between items-center px-3 py-2 border-b border-gray-100 bg-gradient-to-r from-gray-50 to-white">
						<view class="text-xs text-gray-600 font-medium flex items-center">
							<text class="i-uil:shopping-bag mr-1 text-primary text-sm"></text>
							<text class="opacity-75">订单号：</text><text class="font-semibold text-gray-700">{{ item.order_id }}</text>
						</view>
						<view>
							<u-tag v-if="item.status == 2" :text="item.status_name" size="mini" type="primary"
								class="rounded-full px-2 py-0.5"></u-tag>
							<u-tag v-if="item.status == 1" :text="item.status_name" type="warning" size="mini"
								class="rounded-full px-2 py-0.5"></u-tag>
							<u-tag v-if="item.status == 3" :text="item.status_name" type="error" size="mini"
								class="rounded-full px-2 py-0.5"></u-tag>
						</view>
					</view>

					<!-- 优化内容布局 -->
					<view class="p-2.5">
						<!-- 商品信息 + 会员信息紧凑布局 -->
						<view class="grid grid-cols-2 gap-2 mb-2">
							<!-- 商品信息 -->
							<view class="bg-gray-50 rounded-md p-2">
								<view class="text-xs text-gray-500 mb-0.5">商品名称</view>
								<view class="text-xs font-bold line-clamp-2 text-gray-800 flex items-start">
									<text class="i-uil:box mr-1 text-primary text-sm flex-shrink-0"></text>
									<text>{{ item.name }}</text>
								</view>
							</view>
							
							<!-- 会员信息 -->
							<view class="bg-gray-50 rounded-md p-2">
								<view class="text-xs text-gray-500 mb-0.5">会员信息</view>
								<view class="flex items-center justify-between">
									<view class="flex items-center">
										<text class="i-uil:user mr-1 text-primary text-sm"></text>
										<text class="text-xs text-gray-700 truncate max-w-[80px]">{{ item.member_id_name }}</text>
									</view>
									<view v-if="item.m_commission>0" class="text-xs font-medium text-primary">
										￥{{ item.m_commission }}
									</view>
								</view>
							</view>
						</view>
						
						<!-- 价格信息区域 -->
						<view class="rounded-md overflow-hidden border border-gray-100 mb-2">
							<view class="flex bg-gradient-to-r from-gray-50 to-white">
								<view class="flex-1 py-1.5 px-2 border-r border-gray-100">
									<view class="flex items-center justify-between">
										<view class="flex items-center text-xs text-gray-600">
											<text class="i-uil:money-bill mr-1 text-xs text-primary"></text>
											订单金额
										</view>
										<view class="text-xs font-bold text-primary">¥{{ item.order_money }}</view>
									</view>
								</view>
								<view class="flex-1 py-1.5 px-2">
									<view class="flex items-center justify-between">
										<view class="flex items-center text-xs text-gray-600">
											<text class="i-uil:percentage mr-1 text-xs text-rose-500"></text>
											佣金
										</view>
										<view class="text-xs font-bold text-rose-500">¥{{ item.commission }}</view>
									</view>
								</view>
							</view>
						</view>
						
						<!-- 底部信息 -->
						<view class="flex items-center justify-between pt-1.5 text-2xs">
							<view class="text-gray-500 flex items-center">
								<text class="i-uil:clock mr-1 text-2xs"></text>
								{{ item.create_time }}
							</view>
							<view>
								<u-tag v-if="item.is_js == 1" text="已结算" type="primary" size="mini"
									class="rounded-md px-2 transform scale-90"></u-tag>
								<u-tag v-if="item.is_js == 0" text="待结算" type="warning" size="mini"
									class="rounded-md px-2 transform scale-90"></u-tag>
							</view>
						</view>
					</view>
				</view>
			</view>
		</mescroll-body>
		<tabbar addon="tk_partner_partner" />
	</view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import {
	getOrderList
} from '@/addon/tk_partner/api/order'
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
import useMescroll from '@/components/mescroll/hooks/useMescroll.js'
import { onPageScroll, onReachBottom } from '@dcloudio/uni-app'
import { img, redirect } from '@/utils/common';
import useConfigStore from '@/stores/config';
import { checkPartnerOpenEvent } from '@/addon/tk_partner/utils/ts/common';
onShow(()=>{
	checkPartnerOpenEvent()
})
const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
const listData = ref();
const loading = ref<boolean>(false);
const configStore = useConfigStore();

const themeColor = () => {
	return configStore.getThemeColor();
}

const getOrderListFn = (mescroll: any) => {
	const data = ref<{ page?: number, page_size?: number }>({});

	loading.value = false;
	data.value.page = mescroll.num;
	data.value.page_size = mescroll.size;

	getOrderList(data.value).then((res: any) => {
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

/* 主题颜色 */
.text-primary {
	color: var(--themeColor);
}

/* 更丰富的卡片动效 */
.bg-white {
	position: relative;
	&:active {
		transform: scale(0.98);
	}
}

/* 超小文本 */
.text-2xs {
	font-size: 0.65rem;
}
</style>