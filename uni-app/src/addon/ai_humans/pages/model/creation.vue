<template>
	<view class="bg-[var(--page-bg-color)] min-h-screen p-3" :style="themeColor()" v-if="modelData">

		<view class="flex items-center">
			<view
				class="w-2 h-[36rpx] bg-gradient-to-b from-[var(--primary-color)] to-[var(--primary-help-color)] rounded mr-[16rpx]"
				:style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color))' }">
			</view>
			<view class="text-[32rpx] font-bold text-[var(--primary-color)]">{{ modelData.name }}</view>
		</view>
		<view class="text-xs text-[var(--primary-color-light)] mt-2">{{ modelData.desc }}</view>
		<view class="rounded-lg mt-4">

			<view class="flex items-center mt-2">
				<u-textarea maxlength="-1" clearable border="none" v-model="inputValue" height="120"
					:placeholder="modelData.desc" @keydown.enter="handleEnter"
					@keydown.shift.enter="handleShiftEnter" />
			</view>
			<view class="flex mt-2 items-center justify-between">
				<view class="flex items-center">
					<view
						class="text-[var(--primary-color-light)] bg-[var(--primary-color-dark)] text-xs p-1 rounded-lg mr-2"
						@click="insertInput(modelData.demo)">不知道写啥？点击插入
					</view>
					<view class="text-[var(--primary-color)] text-[24rpx] h-[44rpx] leading-[44rpx]">本次创作将消耗{{
						config.model_chat }}{{ config.name }}</view>
				</view>
			</view>
		</view>
		<view v-if="content" class="rounded-lg mt-4"
			style="border-image: linear-gradient(45deg, var(--primary-color), var(--primary-help-color)) 1; box-shadow: 0 0 4px var(--primary-color-light);">
			<view class="markdown-content rounded-lg bg-[var(--primary-color-light)] p-4 backdrop-blur-sm">
				<ua-markdown :source="content" />
			</view>

			<view
				class="fixed bottom-24 right-4 z-50 flex items-center space-x-1 rounded-full bg-white/80 px-3 py-2 shadow-lg backdrop-blur-sm hover:bg-white/90"
				@click="copy(content)">
				<u-icon name="file-text" color="#5f5f5f" size="18"></u-icon>
				<view class="cursor-pointer text-sm text-gray-600">复制</view>
			</view>
		</view>
		<view class="mt-[480rpx] text-center text-slate-400">&nbsp</view>
		<view class="w-full footer bg-[var(--page-bg-color)]">
			<view
				class="flex justify-center items-center py-[var(--top-m)] px-[var(--sidebar-m)] footer w-full fixed bottom-0 left-0 right-0 box-border bg-[var(--page-bg-color)]">
				<view class="px-4">
					<button @click="refresh()" hover-class="none"
						class="h-[88rpx] leading-[88rpx] rounded-[24rpx] text-[26rpx] font-500 text-[var(--primary-color-light)] w-[280rpx]"
						:style="{ background: 'linear-gradient(to right, var(--primary-color-light2), var(--primary-color-light2))' }">重置内容</button>
				</view>
				<view v-if="sendloading == false" class="flex items-center justify-center px-4">
					<button hover-class="none"
						class="h-[88rpx] leading-[88rpx] rounded-[24rpx] text-[26rpx] font-500 text-[var(--primary-color-light2)] w-[280rpx]"
						:style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-color))' }"
						@click="sendMessageStream()">立即生成</button>
				</view>
				<view v-if="sendloading == true" class="flex items-center justify-center px-4">
					<button hover-class="none" :loading="sendloading"
						class="h-[88rpx] leading-[88rpx] rounded-[24rpx] text-[26rpx] font-500 text-[var(--primary-color-light2)] w-[280rpx]"
						:style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-color))' }">生成中</button>
				</view>
			</view>
		</view>
	</view>

	<!-- #ifdef MP-WEIXIN -->
	<!-- 小程序隐私协议 -->
	<wx-privacy-popup ref="wxPrivacyPopup"></wx-privacy-popup>
	<!-- #endif -->
</template>

<script setup lang="ts">
import { ref } from 'vue';
import uaMarkdown from './ua-markdown/ua-markdown'
import { copy, getSiteId, getToken, img, redirect } from '@/utils/common';
import { modelInfo, sendMsg } from '@/addon/ai_humans/api/chat'
import { onLoad, onPageScroll, onReachBottom } from '@dcloudio/uni-app'
import { guid } from '@/addon/ai_humans/utils/ts/common'
import { useShare } from '@/hooks/useShare'
const { setShare, onShareAppMessage, onShareTimeline } = useShare()
onShareAppMessage()
onShareTimeline()
import { getConfig } from '@/addon/ai_humans/api/config';
const config = ref<any>({});
getConfig().then((res) => {
	config.value = res.data;
})
const refresh = () => {
	inputValue.value = ''
	content.value = ''
	sendloading.value = false
}
const sendloading = ref(false)
const content = ref('')

// 处理Enter按键事件
const handleEnter = (e: KeyboardEvent) => {
	if (!e.shiftKey) {
		e.preventDefault()
		sendMessageStream()
	}
}

// 处理Shift+Enter按键事件
const handleShiftEnter = (e: KeyboardEvent) => {
	// Shift+Enter默认就是换行，不需要特殊处理
}

const sendMessageStream = () => {
	getMsgID()
	if (inputValue.value == '') {
		uni.$u.toast('请填写问题内容')
		return
	}
	content.value = ''
	let baseUrl = import.meta.env.VITE_APP_BASE_URL || `${location.origin}/api/`
	sendloading.value = true;
	const postData = {
		msg_id: msg_id.value,
		content: inputValue.value,
		model_id: modelData.value.id,
		type: 'model'
	};
	// #ifdef H5
	const xhr = new XMLHttpRequest();
	xhr.open('POST', baseUrl + '/ai_humans/sendmsgstream', true);
	xhr.timeout = 1500000;
	xhr.responseType = 'text';
	let lastProcessedIndex = 0; // 记录上次处理的位置
	xhr.onreadystatechange = function () {
		if (xhr.readyState === 3) {
			const newText = xhr.responseText.substring(lastProcessedIndex);
			let updatedText = newText.replace(content.value, "");
			content.value += updatedText;
			lastProcessedIndex = xhr.responseText.length;
		} else if (xhr.readyState === 4) {
			inputValue.value = '';
			sendloading.value = false
		}
	};
	xhr.setRequestHeader("Content-Type", "application/json");
	xhr.setRequestHeader(import.meta.env.VITE_REQUEST_HEADER_SITEID_KEY, getSiteId(import.meta.env.VITE_SITE_ID || uni.getStorageSync('wap_site_id')));
	xhr.setRequestHeader(import.meta.env.VITE_REQUEST_HEADER_TOKEN_KEY, getToken());
	xhr.send(JSON.stringify(postData)); // 将要发送的数据转换为 JSON 字符串并发送
	// #endif
	// #ifdef MP-WEIXIN
	const siteIdHeader = {};
	siteIdHeader[import.meta.env.VITE_REQUEST_HEADER_SITEID_KEY] = getSiteId(import.meta.env.VITE_SITE_ID || uni.getStorageSync('wap_site_id'));
	siteIdHeader[import.meta.env.VITE_REQUEST_HEADER_TOKEN_KEY] = getToken();
	const requestTask = uni.request({
		url: baseUrl + '/ai_humans/sendmsgstream',
		timeout: 15000,
		responseType: 'text',
		method: 'POST',
		enableChunked: true,  //配置这里
		data: postData,
		header: {
			'Content-Type': 'application/json',
			...siteIdHeader
		},
		success: response => {
			inputValue.value = '';
			sendloading.value = false
		},
		fail: error => { }
	})

	requestTask.onChunkReceived(function (res) {
		const uint8Array = new Uint8Array(res.data);
		let text = String.fromCharCode.apply(null, uint8Array);
		text = decodeURIComponent(escape(text));
		let updatedText = text.replace(content.value, "");
		content.value += updatedText;

	})
	// #endif
}
const sendMessage = async () => {
	getMsgID()
	if (inputValue.value == '') {
		uni.$u.toast('请填写内容')
	}
	if (inputValue.value.trim()) {
		sendloading.value = true;
		const res = await sendMsg({ msg_id: msg_id.value, content: inputValue.value, model_id: modelData.value, type: 'model' });
		if (res.code == 1) {
			inputValue.value = '';
			content.value = res.data.msg
			sendloading.value = false
		}
	}
};
const msg_id = ref()
let siteId = ref()
const getSiteIdEvent = () => {
	siteId.value = getSiteId()
}
getSiteIdEvent()
const modelData = ref()
const getModelInfo = async (e) => {
	const res = await modelInfo(e)
	modelData.value = res.data
	uni.setNavigationBarTitle({
		title: res.data.name
	})
}
const inputValue = ref()
const insertInput = (e) => {
	inputValue.value = e
}

const getMsgID = () => {
	msg_id.value = guid(10)
}
onLoad((options) => {

	if (options.id) {
		getModelInfo(options.id)
	} else {
		uni.$u.toast('创作模型参数错误')
		redirect({ url: '/addon/ai_humans/pages/model/model' })
	}
})
</script>
<style lang="scss" scoped>
@import '@/addon/ai_humans/utils/styles/common.scss';

.insert {
	background: linear-gradient(-90deg, #ffffcb 0%, #fdffe4 100%);
	padding: 8rpx 12rpx;
	border-radius: 8rpx;
	color: #42224d;
}

.b-tabbar {
	position: fixed;
	bottom: 12rpx;
	left: 0;
	z-index: 999999999999999999 !important;
	right: 0;
	margin: 0rpx 24rpx;
	border-radius: 12rpx;
	padding: 12rpx;
	background: linear-gradient(-90deg, #eef5f5 0%, #f8f6ff 100%);
	bbox-shadow: inset 2px 2px 4px rgba(0, 0, 0, 0.8), 2px 2px 4px rgba(224, 249, 252, 0.8);
}

.b-tabbar-back {
	background: linear-gradient(-90deg, #f4fdff 0%, #edf1ff 100%);
	border-radius: 8rpx;
}

.tk-bbut1 {
	background: linear-gradient(-90deg, rgba(186, 185, 186, 0.6) 0%, rgba(131, 127, 136, 0.4) 100%);
	text-align: center;
	width: 240rpx;
	border-radius: 12rpx;
	color: #ffffff;
	font-size: 24rpx;
	padding: 8rpx;
	margin-top: 8rpx;
	margin-bottom: 8rpx;
	margin-left: 12rpx;
}

.small-but {
	background: linear-gradient(-90deg, #e0cbff 0%, #dcdfff 100%);
	padding: 8rpx 20rpx;
	border-radius: 8rpx;
}

.small-but-border {
	background: linear-gradient(-90deg, #f4f4ff 0%, #f0fffb 100%);
	padding: 0rpx 16rpx;
	border-radius: 8rpx;
}

.small-but-anwser {
	background: linear-gradient(-90deg, #f3ebff 0%, #eff3ff 100%);
	padding: 0rpx 16rpx;
	border-radius: 8rpx;
	font-size: 14rpx;
}
</style>