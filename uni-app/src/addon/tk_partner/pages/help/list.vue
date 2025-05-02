<template>
	<mescroll-body ref="mescrollRef" @init="mescrollInit" @down="downCallback" @up="getHelpListFn">
		<view class="px-4 py-2">
			<view v-for="(item, index) in listData" :key="index"
				@click="redirect({ url: `/addon/tk_partner/pages/help/detail?id=${item.id}` })"
				class="bg-white rounded-lg shadow-md mb-4 overflow-hidden flex">
				<view class="p-3">
					<u-image :src="img(item.image)" width="100rpx" height="100rpx" class="rounded-md"></u-image>
				</view>
				<view class="flex-1 p-3">
					<view class="text-base font-medium text-gray-900 mb-1">{{ item.title }}</view>
					<view class="text-sm text-gray-600 mb-2 line-clamp-2">{{ item.desc }}</view>
					<view class="flex items-center justify-between text-xs text-gray-500">
						<view class="flex items-center">
							<u-icon name="eye" size="12" class="mr-1"></u-icon>
							<text>{{ item.view_num }}</text>
						</view>
						<view>{{ item.create_time }}</view>
					</view>
				</view>
			</view>
		</view>

		<mescroll-empty v-if="!listData" :option="{ tip: '没有地址数据' }"></mescroll-empty>
	</mescroll-body>

	<tabbar addon="tk_partner_partner" />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import {
	getHelpList
} from '@/addon/tk_partner/api/help'
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
import useMescroll from '@/components/mescroll/hooks/useMescroll.js'
import { onPageScroll, onReachBottom } from '@dcloudio/uni-app'
import { img, redirect } from '@/utils/common';
const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
const listData = ref()
let loading = ref<boolean>(false);
const getHelpListFn = (mescroll) => {
	let data = ref({});
	loading.value = false;
	data.value.page = mescroll.num;
	data.value.page_size = mescroll.size;
	getHelpList(data.value).then((res) => {
		let newArr = res.data.data;
		mescroll.endSuccess(newArr.length);
		//设置列表数据
		if (mescroll.num == 1) {
			listData.value = []; //如果是第一页需手动制空列表
		}
		listData.value = listData.value.concat(newArr);
		loading.value = true;
	}).catch((e) => {
		console.log('erro', e)
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
</style>