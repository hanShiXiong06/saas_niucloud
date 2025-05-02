<template>
	<view :style="warpCss">
		<view :style="maskLayer"></view>
		<view class="rider-technician relative">
			<!-- 已是骑手 - 显示进入接单大厅 (有图) -->
			<view v-if="(isRider && diyComponent.imageUrl) || diyStore.mode == 'decorate'"
				class="leading-0 overflow-hidden" :style="{ height: imgHeight }">
				<view @click="handleClick" class="flex items-center justify-between px-4 w-full h-full box-border"
					:style="{ backgroundColor: diyComponent.bgColor }">
					<view class="flex-1">
						<view class="font-bold text-lg" :style="{ color: diyComponent.textColor }">{{ isRider ? '进入接单大厅'
							:
							diyComponent.title }}</view>
						<view class="mt-2 text-sm opacity-75" :style="{ color: diyComponent.textColor }">{{ isRider ?
							'点击开始接单' : '点击申请成为骑手' }}</view>
					</view>
					<image :src="img(diyComponent.imageUrl)" mode="aspectFit" class="w-20 h-20"
						:show-menu-by-longpress="true" />
				</view>

			</view>

			<!-- 已是骑手 - 无图模式 -->
			<view v-else-if="isRider" @click="handleClick" class="rider-btn flex items-center justify-center p-4"
				:style="{ backgroundColor: diyComponent.bgColor || '#3B82F6' }">
				<view class="font-bold text-lg" :style="{ color: diyComponent.textColor || '#FFFFFF' }">进入接单大厅</view>
			</view>

			<!-- 非骑手 - 显示申请入口 -->
			<view v-else @click="handleClick" class="rider-apply flex items-center justify-between p-4"
				:style="{ backgroundColor: diyComponent.bgColor || '#f0f5ff' }">
				<view>
					<view class="font-bold text-lg" :style="{ color: diyComponent.textColor || '#3B82F6' }">{{
						diyComponent.title }}</view>
					<view class="mt-2 text-sm opacity-75" :style="{ color: diyComponent.textColor || '#3B82F6' }">
						点击申请成为骑手
					</view>
				</view>
				<u-icon name="arrow-right" color="#3B82F6" size="24"></u-icon>
			</view>
		</view>
	</view>
</template>

<script lang="ts" setup>
import { ref, computed, watch, onMounted, nextTick, getCurrentInstance } from 'vue';
import { img, redirect } from '@/utils/common';
import { getRiderInfo } from '@/addon/running/api/rider';
import useDiyStore from '@/app/stores/diy';

const props = defineProps(['component', 'index']);
const diyStore = useDiyStore();

// 计算组件数据
const diyComponent = computed(() => {
	if (diyStore.mode == 'decorate') {
		return diyStore.value[props.index];
	} else {
		return props.component;
	}
});

// 计算样式
const warpCss = computed(() => {
	let style = '';
	style += 'position:relative;';

	// 背景颜色
	if (diyComponent.value.componentStartBgColor) {
		if (diyComponent.value.componentStartBgColor && diyComponent.value.componentEndBgColor) {
			style += `background:linear-gradient(${diyComponent.value.componentGradientAngle},${diyComponent.value.componentStartBgColor},${diyComponent.value.componentEndBgColor});`;
		} else {
			style += 'background-color:' + diyComponent.value.componentStartBgColor + ';';
		}
	}

	// 背景图片
	if (diyComponent.value.componentBgUrl) {
		style += `background-image:url('${img(diyComponent.value.componentBgUrl)}');`;
		style += 'background-size: cover;background-repeat: no-repeat;';
	}

	// 圆角设置
	if (diyComponent.value.topRounded) style += 'border-top-left-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
	if (diyComponent.value.topRounded) style += 'border-top-right-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
	if (diyComponent.value.bottomRounded) style += 'border-bottom-left-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
	if (diyComponent.value.bottomRounded) style += 'border-bottom-right-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';

	return style;
});

// 背景图遮罩层
const maskLayer = computed(() => {
	let style = '';
	if (diyComponent.value.componentBgUrl) {
		style += 'position:absolute;top:0;width:100%;';
		style += `background: rgba(0,0,0,${diyComponent.value.componentBgAlpha / 10});`;
		style += `height:${height.value}px;`;

		// 圆角设置
		if (diyComponent.value.topRounded) style += 'border-top-left-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
		if (diyComponent.value.topRounded) style += 'border-top-right-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
		if (diyComponent.value.bottomRounded) style += 'border-bottom-left-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
		if (diyComponent.value.bottomRounded) style += 'border-bottom-right-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
	}
	return style;
});

// 组件挂载时
onMounted(() => {
	refresh();
	// 装修模式下刷新
	if (diyStore.mode == 'decorate') {
		watch(
			() => diyComponent.value,
			(newValue) => {
				if (newValue && newValue.componentName == 'RiderTechnician') {
					refresh();
				}
			}
		);
	}
});

// 获取组件实例和高度
const instance = getCurrentInstance();
const height = ref(0);

// 刷新组件高度
const refresh = () => {
	nextTick(() => {
		const query = uni.createSelectorQuery().in(instance);
		query.select('.rider-technician').boundingClientRect((data: any) => {
			height.value = data?.height || 0;
		}).exec();
	});
};

// 图片高度
const imgHeight = computed(() => {
	return (diyComponent.value.imageHeight * 2) + 'rpx';
});

// 判断是否是骑手
const isRider = ref(false);
const isLoading = ref(true);
const riderInfo = ref<any>({});

const checkRiderStatus = () => {
	if (diyStore.mode == 'decorate') {
		isRider.value = true;
		isLoading.value = false;
		return;
	}

	getRiderInfo().then((res: any) => {
		if (res.code === 1 && res.data) {
			// isRider.value = res.data.is_rider || fal?e;
			isRider.value = res.data.info.status == 1 ? true : false;
			riderInfo.value = res.data.info;
		} else {
			isRider.value = false;
		}
		isLoading.value = false;
	}).catch(() => {
		isRider.value = false;
		isLoading.value = false;
	});
};

// 检查骑手状态
checkRiderStatus();

// 点击骑手入口
const handleClick = () => {
	if (diyStore.mode == 'decorate') return;

	// 根据状态跳转不同页面
	if (riderInfo.value.status == 1) {
		// 已是骑手，跳转到接单大厅
		redirect({ url: '/addon/running/pages/rider/hall' });
	} else if (riderInfo.value.status == 0) {
		// 不是骑手，跳转到申请页面
		redirect({ url: '/addon/running/pages/rider/apple' });
	} else {
		// 不是骑手，跳转到申请页面
		redirect({ url: '/addon/running/pages/rider/apply' });
	}
};
</script>

<style lang="scss" scoped>
.rider-btn {
	min-height: 88rpx;
	border-radius: 12rpx;
}

.rider-apply {
	min-height: 88rpx;
	border-radius: 12rpx;
}
</style>