<template>
	<view :style="warpCss">
		<view :style="maskLayer"></view>
		<view class="flex flex-wrap justify-center" :style="{ padding: diyComponent.padding * 2 + 'rpx', }">
			<view v-if="list.length > 0" class="grid-layout w-full"
				:style="{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '20rpx' }">
				<view v-for="(item, index) in list" :key="index" class="card-item border rounded overflow-hidden"
					:style="{ background: diyComponent.background, margin: '0 0 0 0' }"
					@click="redirect({ url: '/addon/ai_humans/pages/model/creation?id=' + item.id })">
					<view class="flex items-center p-3">
						<view class="flex-shrink-0" :style="{ background: 'transparent' }">
							<u-image v-if="diyComponent.iconshow == '1'" :show-loading="true" :src="img(item.logo)"
								:width="diyComponent.iconsize" :height="diyComponent.iconsize"
								:radius="diyComponent.radiussize" mode="aspectFill"></u-image>
						</view>
						<view v-if="diyComponent.titleshow == '1' || diyComponent.descshow == '1'"
							class="ml-2 overflow-hidden flex-1">
							<view v-if="diyComponent.titleshow == '1'" class="font-bold text-slate-800 tk-sltext"
								:style="{ color: diyComponent.titlecolor, fontSize: diyComponent.titlesize + 'px', }">
								{{ item.name }}
							</view>
							<view v-if="diyComponent.descshow == '1'" class="text-xs text-slate-400 tk-sltext mt-1"
								:style="{ color: diyComponent.desccolor, fontSize: diyComponent.descsize + 'px', }">{{
									item.desc
								}}
							</view>
						</view>
					</view>
				</view>
			</view>
			<view v-else class="card-item border rounded overflow-hidden">
				<view class="flex items-center p-3">
					<view class="flex-shrink-0" :style="{ background: 'transparent' }">
						<view class="text-center text-slate-400 tk-sltext"
							:style="{ fontSize: diyComponent.titlesize + 'px', }">
							暂无数据
						</view>
					</view>
				</view>
			</view>
		</view>

	</view>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, nextTick, getCurrentInstance } from 'vue';
import useDiyStore from '@/app/stores/diy';
import { img, redirect } from '@/utils/common';
import { modelList } from '@/addon/ai_humans/api/chat'

interface ModelItem {
	id: number | string;
	name: string;
	logo: string;
	desc: string;
	[key: string]: any;
}

let list = ref<ModelItem[]>([]);
let loading = ref<boolean>(false);

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
const height = ref(0)

const refresh = () => {
	nextTick(() => {
		const query = uni.createSelectorQuery().in(instance);
		query.select('.diy-rich-text').boundingClientRect((data: any) => {
			height.value = data.height;
		}).exec();
	})
}
const getModelListFn = () => {
	let data: object = {
		page: 1,
		limit: diyComponent.value.modelnum ? diyComponent.value.modelnum : 4,
	};
	modelList(data).then((res: any) => {
		let newArr = (res.data.data as ModelItem[]);
		list.value = newArr
	}).catch(() => {
	})
}
getModelListFn()
</script>

<style lang="scss" scoped>
@import '@/addon/ai_humans/utils/styles/common.scss';

:deep(.u-image) {
	background: transparent !important;
}

:deep(.u-image__loading) {
	background-color: transparent !important;
}

:deep(.u-image__error) {
	background-color: transparent !important;
}
</style>