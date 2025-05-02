<template>
	<view class="bg-[#f8f8f8] min-h-screen overflow-hidden">
		<mescroll-body ref="mescrollRef" top="44rpx" @init="mescrollInit" @down="downCallback" @up="getHistoryListFn">
			<view v-if="list.length > 0" class="tk-card" v-for="(item, index) in list" key=index>
				<view class="flex">
					<view v-if="item.role == 'user'" class="flex">
						<u-icon class="mr-2" name="question-circle" color="#2c2453" size="16"></u-icon>
						<view class="tk-sltext font-bold">
							{{ item.content }}
						</view>
					</view>
					<view class="w-[100%]" v-if="item.role == 'system'">
						<u-read-more :showHeight="120">
							<ua-markdown :source="item.content" />
						</u-read-more>
						<view class="flex justify-end items-end mb-2">
							<u-icon name="file-text" color="#5f5f5f" size="18" @click="copy()"></u-icon>
							<view class="ml-1 text-xs" @click="copy(item.content)">复制</view>
						</view>
					</view>
				</view>

			</view>
			<mescroll-empty :option="{ 'icon': img('static/resource/images/empty.png') }"
				v-if="!list.length && loading"></mescroll-empty>
		</mescroll-body>
	</view>
	<tabbar addon="ai_humans" />

</template>

<script setup lang="ts">
import { ref } from 'vue';
import { copy, img, redirect } from '@/utils/common';
import { getHistoryMsgList } from '@/addon/ai_humans/api/chat';
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
import { onLoad, onPageScroll, onReachBottom } from '@dcloudio/uni-app';
import uaMarkdown from './ua-markdown/ua-markdown'
const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
let list = ref<Array<Object>>([]);
let loading = ref<boolean>(false);

const getHistoryListFn = (mescroll) => {
	loading.value = false;
	let data: object = {
		page: mescroll.num,
		limit: mescroll.size,
		type: 'model'
	};
	getHistoryMsgList(data).then((res) => {
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