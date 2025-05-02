=<template>
	<view class="min-h-screen bg-[#f8f9fc] tech-grid relative">
		<!-- 顶部霓虹线装饰 -->
		<view
			class="absolute top-0 left-0 w-full h-[2px] bg-gradient-to-r from-transparent via-[#3c7bff] to-transparent neon-pulse">
		</view>

		<!-- 头部区域 -->
		<view class="p-4 relative">
			<view class="relative">
				<view class="text-[32rpx] font-bold mb-1 flex items-center">
					<view class="w-[3px] h-5 bg-gradient-to-b from-[#3c7bff] to-[#3c7bff]/30 rounded-full mr-2"></view>
					AI智能体
					<view
						class="ml-2 px-2 py-0.5 bg-[#3c7bff]/8 rounded-full text-[18rpx] text-[#3c7bff] backdrop-blur-sm">
						智能推荐
					</view>
				</view>
				<view class="text-[24rpx] text-gray-500 mt-3 ml-4">AI智能体可以协助你快速、准确地完成各种任务</view>
			</view>
		</view>
		<!-- 内容区域 -->
		<view class="px-3">
			<mescroll-body ref="mescrollRef" top="44rpx" @init="mescrollInit" @down="downCallback" @up="getModelListFn">
				<view class="grid grid-cols-2 gap-3" v-if="list.length > 0">
					<view v-for="(item, index) in list" :key="index"
						class="card-item-neo rounded-xl overflow-hidden transition-all duration-300 hover:shadow-md active:scale-[0.98]"
						@click="redirect({ url: '/addon/ai_humans/pages/model/creation?id=' + item.id })">

						<!-- 科技感卡片 -->
						<view
							class="border border-gray-100/50 rounded-xl shadow-sm tech-card-neo relative backdrop-blur-sm">

							<!-- 卡片内容 -->
							<view class="p-4">
								<!-- 标题和描述 -->
								<view class="">
									<view class="text-base font-bold text-gray-800 mb-1 tk-sltext flex items-center">
										<view class="w-[4px] h-[4px] rounded-full mr-2 pulse-dot"></view>
										{{ item.name }}
									</view>
									<view class="text-xs text-gray-500 line-clamp-2 h-4 mb-2 ml-3">{{ item.desc }}
									</view>
								</view>

								<!-- 底部区域 -->
								<view class="flex justify-between items-center">
									<u-image :show-loading="true" :src="img(item.logo)" width="40px" height="40px"
										class="rounded-lg shadow-sm ring-1 ring-[#3c7bff]/10"></u-image>

									<view
										class="px-3 py-1 rounded-full bg-gray-50/80 text-xs text-gray-600 flex items-center hover:bg-[#3c7bff] hover:text-white transition-colors neo-btn">
										<text>使用</text>
										<text class="ml-1 transition-transform group-hover:translate-x-1">→</text>
									</view>
								</view>
							</view>
						</view>
					</view>
				</view>

				<!-- 空状态优化 -->
				<view v-if="!list.length && loading" class="flex flex-col items-center justify-center mt-20">
					<u-image :src="img('static/resource/images/empty.png')" width="160px" height="160px"
						class="opacity-80 drop-shadow-md"></u-image>
					<view class="text-gray-500 mt-4 text-center">暂无可用智能体</view>
					<view
						class="mt-2 px-4 py-1 rounded-full border border-[#3c7bff] text-[#3c7bff] text-xs neo-btn-empty">
						即将推出更多智能体
					</view>
				</view>
			</mescroll-body>
		</view>
	</view>
	<tabbar addon="ai_humans" />
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { img, redirect } from '@/utils/common';
import { modelList } from '@/addon/ai_humans/api/chat';
// @ts-ignore - 忽略类型声明错误
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
// @ts-ignore - 忽略类型声明错误
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
// @ts-ignore - 忽略类型声明错误
import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
import { onLoad, onPageScroll, onReachBottom } from '@dcloudio/uni-app';
import useConfigStore from '@/stores/config';
const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);

interface ModelItem {
	id: number;
	name: string;
	desc: string;
	logo: string;
}

let list = ref<Array<ModelItem>>([]);
let loading = ref<boolean>(false);

const getModelListFn = (mescroll: any) => {
	loading.value = false;
	let data: object = {
		page: mescroll.num,
		limit: mescroll.size,
	};
	modelList(data).then((res: any) => {
		let newArr = res.data.data as ModelItem[];
		if (mescroll.num == 1) {
			list.value = [];
		}
		list.value = list.value.concat(newArr);
		mescroll.endSuccess(newArr.length);
		loading.value = true;
	}).catch(() => {
		loading.value = true;
		mescroll.endErr();
	});
}
</script>
<style lang="scss" scoped>
@import '@/addon/ai_humans/utils/styles/common.scss';

:deep(.mescroll-empty) {
	@apply mt-[30%];
}

/* 顶部霓虹灯效果 */
.neon-pulse {
	animation: neonPulse 2s infinite ease-in-out;
}

@keyframes neonPulse {

	0%,
	100% {
		opacity: 0.5;
	}

	50% {
		opacity: 1;
	}
}

/* 闪烁点动画 */
.pulse-dot {
	animation: pulseDot 2s infinite cubic-bezier(0.4, 0, 0.6, 1);
}

@keyframes pulseDot {

	0%,
	100% {
		opacity: 1;
		transform: scale(1);
	}

	50% {
		opacity: 0.5;
		transform: scale(1.3);
	}
}

/* 科技感卡片 */
.card-item-neo {
	opacity: 0;
	animation: neoAppear 0.3s ease forwards;
	position: relative;
	overflow: hidden;
	transform-style: preserve-3d;
	perspective: 1000px;
}

/* 出现动画 */
@keyframes neoAppear {
	from {
		opacity: 0;
		transform: translateY(10px);
	}

	to {
		opacity: 1;
		transform: translateY(0);
	}
}

/* 使用按钮效果 */
.neo-btn {
	position: relative;
	overflow: hidden;
}

.neo-btn::before {
	content: '';
	position: absolute;
	width: 100%;
	height: 100%;
	background: linear-gradient(90deg, transparent, rgba(60, 123, 255, 0.1), transparent);
	transform: translateX(-100%);
	animation: neoButtonShine 3s infinite;
}

.neo-btn-empty {
	position: relative;
	overflow: hidden;
	animation: emptyPulse 2s infinite alternate;
}

@keyframes emptyPulse {
	0% {
		box-shadow: 0 0 0px rgba(60, 123, 255, 0.3);
	}

	100% {
		box-shadow: 0 0 8px rgba(60, 123, 255, 0.5);
	}
}

@keyframes neoButtonShine {
	0% {
		transform: translateX(-100%);
	}

	20%,
	100% {
		transform: translateX(100%);
	}
}

.tech-card-neo {
	position: relative;
	transition: all 0.3s ease;
	background: linear-gradient(135deg, rgba(255, 255, 255, 0.95), rgba(240, 245, 255, 0.85));
	box-shadow: 0 2px 15px rgba(60, 123, 255, 0.05);
	backdrop-filter: blur(5px);
	border: 1px solid rgba(255, 255, 255, 0.6);
}

.tech-card-neo:hover {
	transform: translateY(-2px) translateZ(5px);
	box-shadow: 0 5px 20px rgba(60, 123, 255, 0.1);
	border-color: rgba(60, 123, 255, 0.2);
}

/* 高级边框光效 */
.tech-card-neo::before {
	content: '';
	position: absolute;
	inset: 0;
	border-radius: inherit;
	padding: 1px;
	background: linear-gradient(145deg, transparent, rgba(60, 123, 255, 0.2), transparent);
	-webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
	mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
	-webkit-mask-composite: xor;
	mask-composite: exclude;
	pointer-events: none;
	animation: borderGlow 3s infinite alternate;
}

@keyframes borderGlow {
	0% {
		opacity: 0.3;
	}

	100% {
		opacity: 0.7;
	}
}

/* 微妙的科技感网格背景 */
.tech-grid {
	background-image:
		linear-gradient(rgba(60, 123, 255, 0.03) 1px, transparent 1px),
		linear-gradient(90deg, rgba(60, 123, 255, 0.03) 1px, transparent 1px);
	background-size: 20px 20px;
	background-position: center center;
}
</style>