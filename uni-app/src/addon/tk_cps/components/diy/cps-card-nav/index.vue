<template>
	<view :style="warpCss">
		<view :style="maskLayer"></view>
		<view class="diy-graphic-nav relative">
			<scroll-view :class="['graphic-nav', 'graphic-nav-' + diyComponent.showStyle]" class=" py-[10rpx]">
				<!-- #ifdef MP -->
				<view class="uni-scroll-view-content">
					<!-- #endif -->

					<view class="graphic-nav-item"
						:class="{ 'flex-shrink-0': diyComponent.showStyle == 'singleSlide' }"
						v-for="(item, index) in diyComponent.list" :key="item.id"
						:style="{ width: 100 / diyComponent.rowCount + '%' }">

						<view @click="diyStore.toRedirect(item.type == 'system' ? item.link : item.act)"
							class="flex flex-col items-center box-border py-2  bg-white m-1 rounded-[12rpx]" :style="{background: item.cardColor}">
							<view class="graphic-img relative flex items-center justify-center w-10 h-10"
								v-if="diyComponent.mode != 'text'"
								:style="{ width: diyComponent.imageSize * 2 + 'rpx', height: diyComponent.imageSize * 2 + 'rpx' }">
								<image v-if="item.imageUrl" :src="img(item.imageUrl)" mode="aspectFill"
									:style="{ maxWidth: diyComponent.imageSize * 2 + 'rpx', maxHeight: diyComponent.imageSize * 2 + 'rpx', borderRadius: diyComponent.aroundRadius * 2 + 'rpx' }" />
								<image v-else :src="img('static/resource/images/diy/figure.png')" mode="aspectFill"
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

							<text
									:class="[' text-white rounded-[24rpx] scale-10 py-1 px-2 text-xs mt-2']"
									:style="{ color: item.bt.textColor, background: item.bt.bgColor }">
									{{ item.bt.text }}
								</text>
						</view>
					</view>

					<!-- #ifdef MP -->
				</view>
				<!-- #endif -->

			</scroll-view>

		</view>
	</view>
</template>

<script lang="ts" setup>
// 图文导航
import { ref, computed, watch, onMounted, nextTick, getCurrentInstance } from 'vue';
import { img } from '@/utils/common';
import useDiyStore from '@/app/stores/diy';

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

const swiperIndex = ref(0);

const swiperChange = e => {
	swiperIndex.value = e.detail.current;
};

const swiperCondition = (index, numItem) => {
	let count = diyComponent.value.pageCount * diyComponent.value.rowCount;
	let result = true;

	result = index >= [(numItem - 1) * (count)] && index < [numItem * (count)];

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
const isShowslideTemp = (index, numItem) => {
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
}

/* 单行滑动 */
.graphic-nav-singleSlide>>>.uni-scroll-view-content {
	display: flex;
}

/* 多行滑动 */
.multiple-lines.graphic-nav-singleSlide>>>.uni-scroll-view-content {
	display: block;
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
</style>
