<template>
	<view :style="warpCss">
		<view :style="maskLayer"></view>
		<view class="diy-graphic-nav relative">
			<scroll-view :class="['graphic-nav', 'graphic-nav-' + diyComponent.showStyle]" class="p-[6rpx]">
				<!-- #ifdef MP -->
				<view class="uni-scroll-view-content">
					<!-- #endif -->

					<view class="flex flex-wrap">
						<view class="graphic-nav-item"
							:class="{ 'flex-shrink-0': diyComponent.showStyle == 'singleSlide' }"
							v-for="(item, index) in diyComponent.list" :key="item.id"
							:style="{ width: `calc(${100 / diyComponent.rowCount}% - 12rpx)`, margin: '6rpx' }">

							<view @click="diyStore.toRedirect(item.type == 'system' ? item.link : item.act)"
								class="flex flex-col items-center box-border pt-2 pb-0 bg-white rounded-[12rpx] h-full relative w-full"
								:style="{ background: item.cardColor }">
								<view class="flex flex-col items-center w-full px-2 mb-10">
									<view class="graphic-img relative flex items-center justify-center w-10 h-10"
										v-if="diyComponent.mode != 'text'"
										:style="{ width: diyComponent.imageSize * 2 + 'rpx', height: diyComponent.imageSize * 2 + 'rpx' }">
										<image v-if="item.imageUrl" :src="img(item.imageUrl)" mode="aspectFill"
											:style="{ maxWidth: diyComponent.imageSize * 2 + 'rpx', maxHeight: diyComponent.imageSize * 2 + 'rpx', borderRadius: diyComponent.aroundRadius * 2 + 'rpx' }" />
										<image v-else :src="img('static/resource/images/diy/figure.png')"
											mode="aspectFill"
											:style="{ maxWidth: diyComponent.imageSize * 2 + 'rpx', maxHeight: diyComponent.imageSize * 2 + 'rpx', borderRadius: diyComponent.aroundRadius * 2 + 'rpx' }" />
										<text
											:class="['tag absolute -top-[10rpx] -right-[24rpx] text-white rounded-[24rpx] rounded-bl-none transform scale-80 py-1 px-2 text-xs']"
											v-if="item.label.control"
											:style="{ color: item.label.textColor, background: item.label.bgColor }">
											{{ item.label.text }}
										</text>
									</view>
									<text class="graphic-text w-full text-center truncate leading-normal"
										:class="{ 'pt-[16rpx]': diyComponent.mode != 'text' }"
										:style="{ fontSize: diyComponent.font.size * 2 + 'rpx', fontWeight: diyComponent.font.weight, color: diyComponent.font.color }">
										{{ item.title }}
									</text>
									<text class="graphic-text w-full text-center truncate leading-normal"
										:style="{ fontSize: diyComponent.desc.size * 2 + 'rpx', color: diyComponent.desc.color }">
										{{ item.desctext }}
									</text>
								</view>

								<view class="absolute bottom-0 left-0 w-full">
									<view class="text-center  text-xs rounded-b-[12rpx]"
										:style="{ background: item.bbgColor }">
										<view class="flex items-center justify-between p-1 pl-2 pr-2">
											<view class="flex items-center">
												<view v-if="item.logo != '' && item.logo.split(',').length > 0"
													v-for="(logo, index) in item.logo.split(',')" :key="index"
													class="logo-item"
													:style="{ marginLeft: index > 0 ? '-8rpx' : '0' }">
													<image
														class="w-5 h-5 rounded-full border-2 border-white border-opacity-70"
														:src="img(logo)" mode="aspectFill"></image>
												</view>
											</view>
											<view @click.stop="showShareEvent(item)"
												class="text-xs py-1 px-1 rounded-[12rpx] text-center flex items-center justify-center"
												:style="{ color: item.bt.textColor, background: item.bt.bgColor, minWidth: '60rpx' }">
												推广
											</view>
										</view>
									</view>
								</view>
							</view>
						</view>
					</view>

					<!-- #ifdef MP -->
				</view>
				<!-- #endif -->

			</scroll-view>
		</view>
		<u-popup :show="shareShow" @close="shareShow = false" mode="center" closeable :round="16" safe-area-inset-bottom
			close-icon-pos="top-right" :close-on-click-overlay="true" border-radius="16px"
			:custom-style="{ borderTopLeftRadius: '16px', borderTopRightRadius: '16px'}">
			<view class="popup-content" v-if="configData">
				<view class="mx-4 bg-white rounded-xl my-4 shadow-sm">
					<view class="px-4 py-3 border-b border-gray-50 flex items-center">
						<view class="title-decorator"></view>
						<text class="text-gray-800 font-bold">推广信息</text>
					</view>

					<view class="p-3.5 flex items-center justify-between border-b border-gray-50">
						<view class="flex items-center">
							<view class="w-9 h-9 rounded-lg bg-indigo-50 flex items-center justify-center mr-3">
								<u-icon name="ie" size="26" color="#4285F4"></u-icon>
							</view>
							<text class="text-gray-700">网页链接</text>
						</view>
						<view class="flex items-center">
							<text class="text-gray-500 text-xs mr-2 bg-gray-50 px-2 py-1 rounded ">{{
								truncateUrl(queryParamsString(configData.domain + selectItem.link.url,
									configData.member_id))
							}}</text>
							<view
								class="w-12 h-6 rounded bg-gray-100 hover:bg-gray-200 active:bg-gray-300 transition-colors flex items-center justify-center cursor-pointer"
								@click="copy(queryParamsString(configData.domain + selectItem.link.url,
									configData.member_id), '')">
								<text class="iconfont icon-copy text-gray-500 text-sm px-2">复制</text>
							</view>
						</view>
					</view>
					<view class="p-3.5 flex items-center justify-between border-b border-gray-50" v-if="shortLink!=''">
						<view class="flex items-center">
							<view class="w-9 h-9 rounded-lg bg-indigo-50 flex items-center justify-center mr-3">
								<u-icon name="weixin-fill" size="26" color="#4285F4"></u-icon>
							</view>
							<text class="text-gray-700">小程序链接</text>
						</view>
						<view class="flex items-center">
							<text class="text-gray-500 text-xs mr-2 bg-gray-50 px-2 py-1 rounded ">{{
								truncateUrl(shortLink)
							}}</text>
							<view
								class="w-12 h-6 rounded bg-gray-100 hover:bg-gray-200 active:bg-gray-300 transition-colors flex items-center justify-center cursor-pointer"
								@click="copy(shortLink, '')">
								<text class="iconfont icon-copy text-gray-500 text-sm px-2">复制</text>
							</view>
						</view>
					</view>
					<view class="p-3.5 flex items-center justify-between border-b border-gray-50">
						<view class="flex items-center">
							<view class="w-9 h-9 rounded-lg bg-indigo-50 flex items-center justify-center mr-3">
								<u-icon name="weixin-fill" size="26" color="#4285F4"></u-icon>
							</view>
							<text class="text-gray-700">APPID</text>
						</view>
						<view class="flex items-center">
							<text class="text-gray-500 text-xs mr-2 bg-gray-50 px-2 py-1 rounded ">{{
								truncateUrl(configData.weapp_appid)
							}}</text>
							<view
								class="w-12 h-6 rounded bg-gray-100 hover:bg-gray-200 active:bg-gray-300 transition-colors flex items-center justify-center cursor-pointer"
								@click="copy(configData.weapp_appid, '')">
								<text class="iconfont icon-copy text-gray-500 text-sm px-2">复制</text>
							</view>
						</view>
					</view>
					<view class="p-3.5 flex items-center justify-between border-b border-gray-50">
						<view class="flex items-center">
							<view class="w-9 h-9 rounded-lg bg-indigo-50 flex items-center justify-center mr-3">
								<u-icon name="tags" size="26" color="#4285F4"></u-icon>
							</view>
							<text class="text-gray-700">页面路径</text>
						</view>
						<view class="flex items-center">
							<text class="text-gray-500 text-xs mr-2 bg-gray-50 px-2 py-1 rounded ">{{
								truncateUrl(queryParamsString(selectItem.link.url, configData.member_id))
							}}</text>
							<view
								class="w-12 h-6 rounded bg-gray-100 hover:bg-gray-200 active:bg-gray-300 transition-colors flex items-center justify-center cursor-pointer"
								@click="copy(queryParamsString(selectItem.link.url, configData.member_id), '')">
								<text class="iconfont icon-copy text-gray-500 text-sm px-2">复制</text>
							</view>
						</view>
					</view>
				</view>
			</view>
		</u-popup>
	</view>
</template>

<script lang="ts" setup>
// 图文导航
import { ref, computed, watch, onMounted, nextTick, getCurrentInstance } from 'vue';
import { img, copy } from '@/utils/common';
import useDiyStore from '@/app/stores/diy';
import { truncateMiddle, queryParamsString } from '@/addon/tk_partner/utils/ts/common';
import { getConfig,getShortLink } from '@/addon/tk_partner/api/config';
const configData = ref()
getConfig().then((res: any) => {
	configData.value = res.data
})
const shareShow = ref(false)

const truncateUrl = (url: string) => {
	if (!url) return '';
	return truncateMiddle(url, 12, 4);
}

// 显示提示
const showToast = (title: string) => {
	uni.showToast({
		title: title,
		icon: 'none'
	});
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
const shouldShowIndicator = computed(() => {
	const totalItems = diyComponent.value.list.length // 总项数
	const itemsPerPage = diyComponent.value.pageCount * diyComponent.value.rowCount // 每页可显示的项数
	return totalItems > itemsPerPage // 如果总项数大于每页显示的项数，显示指示器
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

const horizontalSingleSlideItemStyle = (index: any) => {
	let style = { width: "" };
	style.width = `${100 / diyComponent.value.rowCount}%`;
	return style;
}

watch(
	() => props.pullDownRefreshCount,
	(newValue, oldValue) => {
		// 处理下拉刷新业务
	}
)
const selectItem = ref<any>({})
const shortLink = ref<any>('')
const showShareEvent = (item: any) => {
	getShortLink({path:item.link.url+'?mid='+configData.value.member_id,title:item.title}).then((res:any)=>{
		shortLink.value = res.data.link
			selectItem.value = item
	        shareShow.value = true
	})

}
const swiperIndex = ref(0);

const swiperChange = (e: { detail: { current: number } }) => {
	swiperIndex.value = e.detail.current;
};

const swiperCondition = (index: number, numItem: number) => {
	let count = diyComponent.value.pageCount * diyComponent.value.rowCount;
	let result = true;

	result = index >= ((numItem - 1) * count) && index < (numItem * count);

	return result;
}

const storageKey = 'graphic_nav_horizontal_page_slide_swiperheight_' + props.index + '_' + diyComponent.value.list.length;
const swiperHeight = ref(uni.getStorageSync(storageKey) || '');

const handleData = () => {
	if (diyComponent.value.layout == 'horizontal' && diyComponent.value.showStyle == 'pageSlide') {
		var height = 0;
		const query = uni.createSelectorQuery().in(instance);
		query.select('.graphic-nav-item').boundingClientRect((data: any) => {
			let len = 1;
			if (diyComponent.value.pageCount == 2) {
				len = (diyComponent.value.list.length / diyComponent.value.rowCount) > 1 ? 2 : 1;
			}
			height = data.height * len;
			swiperHeight.value = height + 'px';
			uni.setStorageSync(storageKey, swiperHeight.value);
		}).exec();
	}
};

onMounted(() => {
	refresh();
	// 装修模式下刷新
	if (diyStore.mode == 'decorate') {
		watch(
			() => diyComponent.value,
			(newValue, oldValue) => {
				if (newValue && newValue.componentName == 'GraphicNav') {
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
		handleData()
		const query = uni.createSelectorQuery().in(instance);
		query.select('.diy-graphic-nav').boundingClientRect((data: any) => {
			height.value = data.height;
		}).exec();
	})
}
// 获取滑动行数
const getSlideRowNum = () => {
	let num = 1;
	if (diyComponent.value.pageCount == 2) {
		num = diyComponent.value.list.length > diyComponent.value.rowCount ? 2 : 1;
	}
	return num;
}
const isShowslideTemp = (index: number, numItem: number) => {
	let result = true;
	let indent = index + 1;
	if (diyComponent.value.pageCount == 2) {
		let num = Math.ceil(diyComponent.value.list.length / diyComponent.value.rowCount)
		for (let i = 1; i <= num; i++) {
			if (numItem == 1 && (i % 2) != 0) {
				if (indent > ((i - 1) * diyComponent.value.rowCount) && indent <= (i * diyComponent.value.rowCount)) {
					return true;
				}
			}
			if (numItem == 2 && (i % 2) == 0) {
				if (indent > ((i - 1) * diyComponent.value.rowCount) && indent <= (i * diyComponent.value.rowCount)) {
					return true;
				}
			}
		}
	}

	return false;
}
</script>

<style>
/* 固定显示 */
.graphic-nav-fixed>>>.uni-scroll-view-content {
	display: flex;
	flex-wrap: wrap;
	width: 100%;
}

/* 单行滑动 */
.graphic-nav-singleSlide>>>.uni-scroll-view-content {
	display: flex;
	flex-wrap: nowrap;
	width: auto;
}

/* 多行滑动 */
.multiple-lines.graphic-nav-singleSlide>>>.uni-scroll-view-content {
	display: block;
	width: 100%;
}

.graphic-nav-item {
	box-sizing: border-box;
}

.flex-wrap {
	display: flex;
	flex-wrap: wrap;
	width: 100%;
}

/* 单行滑动时不换行 */
.graphic-nav-singleSlide .flex-wrap {
	flex-wrap: nowrap;
	width: auto;
}

/* logo样式 */
.logo-item {
	position: relative;
	transition: all 0.3s;
}

.logo-item:hover {
	z-index: 10;
}

.logo-item:nth-child(1) {
	z-index: 1;
}

.logo-item:nth-child(2) {
	z-index: 2;
}

.logo-item:nth-child(3) {
	z-index: 3;
}

.logo-item:nth-child(4) {
	z-index: 4;
}

.logo-item:nth-child(5) {
	z-index: 5;
}
</style>
<style lang="scss" scoped>
.graphic-nav-indicator-dot {
	width: 95%;
	margin: auto;

	.dots-wrap {
		white-space: nowrap;
		display: flex;
		align-items: center;
		justify-content: center;

		&.left {
			justify-content: flex-start;
			padding-left: 30rpx;
		}

		&.right {
			justify-content: flex-end;
			padding-right: 30rpx;
		}

		.dot {
			display: inline-block;
			width: 12rpx;
			height: 12rpx;
			cursor: pointer;
			transition-property: background-color;
			transition-timing-function: ease;
			background: rgba(0, 0, 0, 0.3);
			border-radius: 50%;
			margin-right: 16rpx;

			&:last-child {
				margin-right: 0;
			}


			// 指示器样式二
			&.style-2 {
				width: 18rpx;
				height: 6rpx;
				border-radius: 4rpx;
			}

			&dot-active.style-2 {
				width: 36rpx;
			}

			// 指示器样式三
			&.style-3 {
				width: 10rpx;
				height: 10rpx !important;
				border-radius: 12rpx;
				margin-right: 14rpx;

				&:last-of-type {
					margin-right: 0;
				}
			}

			&.dot-active.style-3 {
				width: 32rpx;
			}
		}
	}
}

.title-decorator {
	width: 4px;
	height: 18px;
	background: linear-gradient(to bottom, var(--primary-color), var(--primary-color));
	margin-right: 6px;
	border-radius: 2px;
	display: inline-block;
	position: relative;
	flex-shrink: 0;
}
</style>
