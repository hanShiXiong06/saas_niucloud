<template>
	<view :style="warpCss">
		<view :style="maskLayer"></view>
		<mescroll-body ref="mescrollRef" @init="mescrollInit" @down="downCallback" @up="getActListFn">
			<view class="px-4 py-3 min-h-screen">
				<mescroll-empty v-if="!listData?.length" :option="{ tip: '暂无活动数据' }"></mescroll-empty>
				<view v-for="(item, index) in listData" :key="index"
					class="bg-white rounded-xl mb-4 overflow-hidden shadow-sm hover:shadow-lg transition-all duration-300 transform hover:-translate-y-1 border border-gray-100 active:scale-[0.98]"
					:style="{ background: diyComponent.bgcolor }"
					@click="redirect({ url: '/addon/tk_cpa/pages/act/detail?id=' + item.id })">
					<view class="flex items-center p-2 pb-0">
						<view class="flex-shrink-0">
							<image :src="img(item.itemPic)" class="w-15 h-15 rounded-lg object-cover shadow-md"
								:style="{ width: diyComponent.imagewidth + 'rpx', height: diyComponent.imagewidth + 'rpx' }"
								mode="aspectFill">
							</image>
						</view>
						<view class="flex-1 ml-4 min-w-0">
							<view
								class="text-base font-medium text-gray-900 mb-2 line-clamp-1 whitespace-nowrap overflow-hidden text-ellipsis"
								:style="{ fontSize: diyComponent.titlesize + 'px', color: diyComponent.titlecolor }">
								{{ item.title }}
							</view>
							<view class="flex items-center gap-2">
								<view
									class="bg-gradient-to-r from-red-50 to-red-100 py-0.5 px-2 rounded-full inline-flex items-center"
									:style="{ background: diyComponent.cbcolor }">
									<text class="text-red-500 text-xs font-bold"
										:style="{ color: diyComponent.commissioncolor, fontSize: diyComponent.commissionsize + 'px' }">佣金</text>
									<view class="flex items-baseline">
										<text v-if="item.minMoney === item.maxMoney" class="font-bold text-sm"
											:style="{ color: diyComponent.commissioncolor, fontSize: diyComponent.commissionsize + 'px' }">{{
												item.minMoney }}</text>
										<text v-else class="font-bold text-sm"
											:style="{ color: diyComponent.commissioncolor, fontSize: diyComponent.commissionsize + 'px' }">{{
												item.minMoney }}-{{
												item.maxMoney
											}}</text>
									</view>
								</view>
							</view>
						</view>
					</view>
					<view class="px-4 py-2 bg-white/30 flex justify-between items-center border-t border-gray-100">
						<view class="flex flex-wrap gap-2">
							<block v-for="(item1, index1) in item.labelText.slice(0, 2)" :key="index1">
								<view v-if="item1" :class="[
									'px-2 py-1 rounded text-xs font-medium',
									getLabelStyle(index1)
								]">
									{{ item1 }}
								</view>
							</block>
							<view v-if="item.labelText.length > 2"
								class="px-2 py-1 rounded text-xs font-medium bg-gray-100 text-gray-500">
								...
							</view>
						</view>
						<view class="text-gray-500 text-xs flex items-center max-w-[50%]">
							<text class="whitespace-nowrap overflow-hidden text-ellipsis"
								:style="{ color: diyComponent.desccolor }">{{ item.simpleDescription
								}}</text>
						</view>
					</view>
				</view>
			</view>
		</mescroll-body>

	</view>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, nextTick, getCurrentInstance } from 'vue';
// @ts-ignore - 忽略模块类型声明错误
import useDiyStore from '@/app/stores/diy';
// @ts-ignore - 忽略模块类型声明错误
import { img, redirect, getToken } from '@/utils/common';
// @ts-ignore - 忽略模块类型声明错误
import { getActList } from '@/addon/tk_cpa/api/act';
import { onPageScroll, onReachBottom } from '@dcloudio/uni-app';
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
import useMescroll from '@/components/mescroll/hooks/useMescroll.js'
const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);


const getLabelStyle = (index: number) => {
	const styles = [
		'bg-blue-200 text-blue-800 border border-blue-400 shadow-sm',
		'bg-green-200 text-green-800 border border-green-400 shadow-sm',
		'bg-purple-200 text-purple-800 border border-purple-400 shadow-sm',
		'bg-yellow-200 text-yellow-800 border border-yellow-400 shadow-sm',
		'bg-pink-200 text-pink-800 border border-pink-400 shadow-sm',
		'bg-indigo-200 text-indigo-800 border border-indigo-400 shadow-sm',
		'bg-orange-200 text-orange-800 border border-orange-400 shadow-sm',
		'bg-teal-200 text-teal-800 border border-teal-400 shadow-sm'
	];
	return styles[index % styles.length];
}


// 刷新数据
const refresh = () => {

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
const listData = ref();
const loading = ref<boolean>(false);

const getActListFn = (mescroll: any) => {
	const data = ref<{ page?: number, page_size?: number }>({});
	loading.value = false;
	data.value.page = mescroll.num;
	data.value.page_size = mescroll.size;
	getActList(data.value).then((res: any) => {
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
@import '@/addon/tk_cpa/utils/styles/common.scss';

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