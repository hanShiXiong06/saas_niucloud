<template>
	<view :style="warpCss">
		<view :style="maskLayer"></view>
		<template v-if="diyStore.mode == 'decorate'">
			<view class="">
				<view class="rounded-lg shadow-md overflow-hidden flex items-center">
					<view class="p-3 rounded-md ">
						<u-image :src="img('static/resource/images/diy/figure.png')"
							:width="diyComponent.imagewidth + 'rpx'" :height="diyComponent.imageheight + 'rpx'"
							radius="8"></u-image>
					</view>
					<view class="flex-1 p-3 pl-0">
						<view class="font-bold"
							:style="{ fontSize: diyComponent.titlesize + 'px', color: diyComponent.titlecolor }">如何使用克隆
						</view>
						<view class="text-[24rpx] mb-2 mt-1 line-clamp-2" :style="{ color: diyComponent.desccolor }">
							视频克隆步骤
						</view>
						<view class="flex items-center justify-between text-xs text-gray-500">
							<view class="flex items-center" v-if="diyComponent.viewshow == 1">
								<u-icon name="eye" size="12" class="mr-1" :color="diyComponent.timecolor"></u-icon>
								<text class="text-xs" :style="{ color: diyComponent.timecolor }">10000</text>
							</view>
							<view class="text-xs" :style="{ color: diyComponent.timecolor }">2025-3-20 19:00:00
							</view>
						</view>
					</view>
				</view>
			</view>
		</template>
		<scroll-view v-else scroll-y @scrolltolower="loadMore" @refresherrefresh="refresh" refresher-enabled
			:refresher-triggered="isRefreshing" class="">
			<view class="">
				<view v-for="(item, index) in listData" :key="index"
					@click.stop="redirect({ url: `/addon/ai_humans/pages/help/detail?id=${item.id}` })"
					class="rounded-lg shadow-md overflow-hidden flex items-center">
					<view class="p-3 rounded-md ">
						<u-image :src="img(item.image)" :width="diyComponent.imagewidth + 'rpx'"
							:height="diyComponent.imageheight + 'rpx'" radius="8"></u-image>
					</view>
					<view class="flex-1 p-3 pl-0">
						<view class="font-bold"
							:style="{ fontSize: diyComponent.titlesize + 'px', color: diyComponent.titlecolor }">{{
								item.title }}</view>
						<view class="text-[24rpx] mb-2 mt-1 line-clamp-2" :style="{ color: diyComponent.desccolor }">{{
							item.desc
						}}</view>
						<view class="flex items-center justify-between text-xs text-gray-500">
							<view class="flex items-center" v-if="diyComponent.viewshow == 1">
								<u-icon name="eye" size="12" class="mr-1" :color="diyComponent.timecolor"></u-icon>
								<text class="text-xs" :style="{ color: diyComponent.timecolor }">{{ item.view_num
								}}</text>
							</view>
							<view class="text-xs" :style="{ color: diyComponent.timecolor }">{{ item.create_time }}
							</view>
						</view>
					</view>
				</view>
			</view>
		</scroll-view>
	</view>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, nextTick, getCurrentInstance } from 'vue';
// @ts-ignore - 忽略模块类型声明错误
import useDiyStore from '@/app/stores/diy';
// @ts-ignore - 忽略模块类型声明错误
import { img, redirect, getToken } from '@/utils/common';
// @ts-ignore - 忽略模块类型声明错误
import { getHelpList } from '@/addon/ai_humans/api/help';
import { onPageScroll, onReachBottom } from '@dcloudio/uni-app';

// 定义接口类型
interface HelpItem {
	id: number;
	title: string;
	desc: string;
	image: string;
	view_num: number;
	create_time: string;
	[key: string]: any;
}

interface ApiResponse {
	code: number;
	data: {
		data: HelpItem[];
		[key: string]: any;
	};
	msg: string;
}

// 分页数据
const page = ref(1);
const pageSize = ref(10);
const listData = ref<HelpItem[]>([]);
const loading = ref<boolean>(false);
const hasMore = ref<boolean>(true);
const isRefreshing = ref<boolean>(false);

// 获取列表数据
const getHelpListFn = () => {
	if (loading.value) return;

	loading.value = true;
	const data = {
		page: page.value,
		page_size: pageSize.value
	};

	getHelpList(data).then((res: any) => {
		const newArr = res.data.data;

		if (page.value === 1) {
			listData.value = newArr;
		} else {
			listData.value = listData.value.concat(newArr);
		}

		hasMore.value = newArr.length >= pageSize.value;
		loading.value = false;
		isRefreshing.value = false;
	}).catch((e) => {
		console.log('error', e);
		loading.value = false;
		isRefreshing.value = false;
	});
};

// 加载更多
const loadMore = () => {
	if (!hasMore.value || loading.value) return;
	page.value++;
	getHelpListFn();
};

// 刷新数据
const refresh = () => {
	isRefreshing.value = true;
	page.value = 1;
	hasMore.value = true;
	getHelpListFn();

	// 如果使用diyStore，同时刷新高度
	nextTick(() => {
		const query = uni.createSelectorQuery().in(instance);
		query.select('.scroll-view').boundingClientRect((data: any) => {
			if (data) {
				height.value = data.height;
			}
		}).exec();
	});
};

// @ts-ignore - 忽略模块类型声明错误
import { useLogin } from "@/hooks/useLogin";
const goLogin = () => {
	const login = useLogin();
	// 第三方平台自动登录
	// #ifdef MP
	login.getAuthCode();
	// #endif
	// #ifdef H5
	useLogin().setLoginBack({ url: '/addon/ai_humans/pages/index/index' })
	// #endif
}
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
		if (newValue !== oldValue) {
			refresh();
		}
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
const height = ref(0);
</script>

<style lang="scss" scoped>
@import '@/addon/ai_humans/utils/styles/common.scss';

:deep(.u-image) {
	border-radius: theme('borderRadius.md');
}

.line-clamp-2 {
	display: -webkit-box;
	-webkit-line-clamp: 2;
	-webkit-box-orient: vertical;
	overflow: hidden;
}

.h-full {
	height: 100vh;
}
</style>