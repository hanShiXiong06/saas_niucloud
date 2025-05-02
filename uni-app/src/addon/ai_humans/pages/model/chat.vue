<template>
	<view style="position: fixed;top: 0;width: 100%;" class="full-screen min-h-[100vh] h-[100%] overflow-hidden mt-0"
		:style="themeColor()" v-if="configValue">

		<view :style="{ height: `${statusBarHeight}px`, position: 'fixed', top: 0, left: 0, right: 0, zIndex: 1000, }">
		</view>
		<view
			:style="{ height: `${barHeight}px`, 'line-height': `${barHeight}px`, position: 'fixed', top: `${statusBarHeight}px`, left: 0, right: 0, zIndex: 1000, }">
			<!-- #ifndef H5 -->
			<view v-if="configValue" class="flex items-center"
				@click="redirect({ url: '/addon/ai_humans/pages/chat/diy' })">
				<view class="ml-4">
					<u-image :show-loading="true" :src="img(configValue.logo)" width="36px" height="36px"></u-image>
				</view>
				<text class="ml-2 text-slate-400">{{ configValue.name }}</text>
			</view>
			<!-- #endif -->
		</view>

		<view :style="{ marginTop: `${barHeight + statusBarHeight}px` }"
			class="overflow-y-scroll overflow-x-hidden p-2">
			<!-- #ifdef H5 -->
			<view v-if="configValue" class="flex items-center"
				@click="redirect({ url: '/addon/ai_humans/pages/chat/diy' })">
				<u-image :show-loading="true" :src="img(configValue.logo)" width="36px" height="36px"></u-image>
				<text class="ml-2 text-slate-400">{{ configValue.name }}</text>
			</view>
			<!-- #endif -->

			<mescroll-uni :top="`${barHeight + statusBarHeight}px`" @init="mescrollInit" @down="downCallback"
				@up="getHistoryListFn">

				<view v-if="list.length > 0" v-for="(item, index) in list" class="p-2">

					<view v-if="item.role == 'user'" class="flex flex-col items-end mr-2 ml-[20%] mt-2">
						<text class="text-xs mb-1">会话ID:{{ msg_id }}</text>
						<view class="dialogbg">
							<text class="w-[320px] text-xs">{{ item.content }}</text>
						</view>
						<view class="flex justify-end items-end mt-1 items-center" @click="copy(item.content)">

							<u-icon name="file-text" color="#5d5d5d" size="18"></u-icon>
							<view class="ml-1 text-xs">复制</view>
						</view>

					</view>

					<view v-if="item.role == 'system'" class="flex flex-col items-start m-1 z-0">
						<view :class="ispc == false ? 'w-[100%]' : 'w-[65%]'">
							<view class="dialogbg1" :style="configValue ? { background: configValue.answercolor } : {}">
								<view class="">
									<ua-markdown :source="item.content"></ua-markdown>
								</view>
								<view class="flex justify-end items-end mb-2">

									<u-icon name="file-text" color="#5f5f5f" size="18"
										@click="copy(item.content)"></u-icon>
									<view class="ml-1 text-xs" @click="copy(item.content)">复制</view>
								</view>
							</view>
						</view>

					</view>
				</view>
				<view v-if="content" :class="ispc == false ? 'w-[100%]' : 'w-[85%]'" class="mt-2 p-2 mr-[22rpx]">
					<view class="dialogbg1 w-[100%]]"
						:style="configValue ? { background: configValue.answercolor } : {}">
						<view class="">
							<ua-markdown :source="content"></ua-markdown>
						</view>

					</view>
				</view>
				<view v-if="list.length == 0" class="p-4">
					<view class="welcome-container">
						<view class="text-2xl font-medium mb-2">Hi~ 我是{{ configValue.name || '智能助手' }}</view>
						<view class="text-base text-gray-600 mb-6">
							你身边的智能助手，可以为你答疑解惑、尽情创作，
							<view>快来点击以下任一功能体验吧 ~</view>
						</view>

						<view class="tips-container mb-4">
							<view class="text-sm text-gray-500 mb-3">你可以这样问</view>

							<view class="demo-questions">
								<view v-for="(item, index) in configValue.demo" :key="index" class="demo-question-item"
									@click="handleDemoClick(item)">
									{{ item }}
								</view>
							</view>
						</view>

						<view class="text-sm text-gray-400 text-center">
							写一份川菜菜谱 <text class="text-green-500">去提问</text>
						</view>
					</view>
				</view>
				<view v-if="list.length > 0" class="mt-[480rpx] text-center text-slate-400">&nbsp</view>
			</mescroll-uni>


		</view>

	</view>


	<view class="b-tabbar safe-area-inset-bottom">
		<view class="b-tabbar-back flex flex-col p-2 rounded-xl"
			:style="configValue ? { background: configValue.background } : {}">
			<view class="input-container relative">
				<u-textarea maxlength="800" clearable border="none" v-model="inputValue" height="28" autoHeight
					class="custom-textarea" placeholder="有问题，尽管问" @keydown.enter="handleEnter"
					@keydown.shift.enter="handleShiftEnter" />
			</view>
			<view class="flex justify-between mt-1 items-center">
				<view class="flex items-center space-x-2">
					<view class="tool-btn" @click="redirect({ url: '/addon/ai_humans/pages/model/history' })">
						<u-icon name="chat" color="#909090" size="24"></u-icon>
					</view>
					<view class="tool-btn" @click="redirect({ url: '/addon/ai_humans/pages/model/model' })">
						<u-icon name="list-dot" color="#909090" size="22"></u-icon>
					</view>
				</view>
				<view class="flex items-center">
					<view class="text-[28rpx] text-gray-400 mr-3" @click="delMessage()">新对话</view>
					<view @click="sendMessageStream()">
						<view class="send-btn flex items-center justify-center text-white px-4 py-1 rounded-full"
							:style="configValue && configValue.buttoncolor ? { background: configValue.buttoncolor } : {}">
							发送
						</view>
					</view>
				</view>
			</view>
		</view>
		<u-safe-bottom></u-safe-bottom>
	</view>
	<u-popup :show="showModelDialog" :round="6" :bgColor="configValue ? configValue.background : ''" mode="center"
		@close="close" @open="open">
		<view class="w-[320px]">
			<view v-for="(item, index) in modelistData" class="model flex items-center" @click="selectModelEvent(item)">
				<u-image :show-loading="true" :src="img(item.logo)" width="42px" height="42px"></u-image>
				<view class="ml-2">
					<view class="font-bold text-slate-600">{{ item.name }}</view>
					<view class="text-xs text-slate-400">{{ item.desc }}</view>
				</view>
			</view>
			<view class="flex justify-end items-center mr-3 mb-2" @click="changeModel()">
				<text class="mr-4 text-slate-400 text-xs">选择合适模型对话更方便</text>
				<text class="tk-tag" :style="configValue ? { background: configValue.buttoncolor } : {}">换一批</text>
			</view>
		</view>
	</u-popup>
	<!-- #ifdef MP-WEIXIN -->
	<!-- 小程序隐私协议 -->
	<wx-privacy-popup ref="wxPrivacyPopup"></wx-privacy-popup>
	<!-- #endif -->
</template>

<script setup lang="ts">
import { reactive, ref, onMounted, computed, nextTick } from 'vue'
import { onLoad, onShow } from '@dcloudio/uni-app'
import { t } from '@/locale'
import { useShare } from '@/hooks/useShare'
import { sendMsg, modelList, getHistoryMsgList } from '@/addon/ai_humans/api/chat'
import { confirm, } from '@/addon/ai_humans/utils/ts/alert'
import uaMarkdown from './ua-markdown/ua-markdown'
import { copy, img, getToken, redirect, timeStampTurnTime, handleOnloadParams, getSiteId, themeColorToHex } from '@/utils/common'

import { guid } from '@/addon/ai_humans/utils/ts/common'
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
import MescrollUni from '@/components/mescroll/mescroll-uni/mescroll-uni.vue';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
import { onPageScroll, onReachBottom } from '@dcloudio/uni-app';
import { getAiChatConfig } from '@/addon/ai_humans/api/config'
import { useLogin } from '@/hooks/useLogin'
import useMemberStore from '@/stores/member'
const memberStore = useMemberStore()
const userInfo = computed(() => memberStore.info)

const { mescrollInit, downCallback, getMescroll } = useMescroll()
const upCallback = (mescroll) => {
	getHistoryListFn(mescroll).then(res => {
	}).catch(() => {
		mescroll.endErr()
	})
}
const { setShare, onShareAppMessage, onShareTimeline } = useShare()
onShareAppMessage()
onShareTimeline()

const configValue = ref()
const getConfigData = async () => {
	const res = await getAiChatConfig()
	configValue.value = res.data
}
getConfigData()
const msg_id = ref()
const getMsgID = () => {
	msg_id.value = uni.getStorageSync('msg_id')
	if (!msg_id.value) {
		msg_id.value = guid(10)
		uni.setStorageSync('msg_id', msg_id.value)
	}
}
getMsgID()

const changeModel = () => {
	if (modelPage.total <= modelPage.page * modelPage.limit) {
		modelPage.page = 1
	} else {
		modelPage.page = modelPage.page + 1
	}
	getModelList()
}
const showModelDialog = ref(false)
const showModel = () => {
	showModelDialog.value = true
}
const selectModel = ref()
const model_id = ref('')
const addcontent = ref('')
const selectModelEvent = (e) => {
	console.log(e)
	selectModel.value = e
	model_id.value = e.id
	addcontent.value = e.content
	inputValue.value = e.demo
	showModelDialog.value = false
}
const open = () => {
	modelPage.limit = 4
	getModelList()
}
const close = () => {
	showModelDialog.value = false
}
let modelPage = reactive({
	page: 1,
	limit: 4,
	total: 0,
})
const modelistData = ref()
const getModelList = async () => {
	const res = await modelList({
		page: modelPage.page,
		limit: modelPage.limit
	})
	modelistData.value = res.data.data
	modelPage.total = res.data.total
	console.log(modelPage.total)
}
getModelList()
const ispc = ref()
const systemInfo = uni.getSystemInfoSync();
if (systemInfo.platform.toLowerCase().includes('windows') || systemInfo.platform.toLowerCase().includes('mac')) {
	ispc.value = true
	console.log('nopc')
} else {
	console.log('yespc')
	ispc.value = false
}
const inputValue = ref('');
const messages = ref([{ msg_id: '', role: 'system', content: 'Welcome!' }]);
const sendloading = ref(false);
const handleEnter = (event) => {
	if (!event.shiftKey) {
		sendMessageStream()
	}
}
const handleShiftEnter = (event) => {
	if (event.shiftKey) {
		sendMessage()
	}
}
const delMessage = () => {
	selectModel.value = null
	uni.setStorageSync('msg_id', '')
	list.value = []
	msg_id.value = ''
	uni.$u.toast('新建会话成功')
}
const ailoading = ref()
const aiMsg = async () => {
	if (inputValue.value == '') {
		uni.$u.toast('请填写问题内容')
	}
	ailoading.value = true
	const res = await sendMsg({ content: inputValue.value + '，根据上文内容，优化这个提问问题' });
	if (res.code == 1) {
		inputValue.value = res.data.msg;
		ailoading.value = false
	}
}
const content = ref('')
const sendMessageStream = () => {
	getMsgID()
	if (inputValue.value == '') {
		uni.$u.toast('请填写问题内容')
		return
	}
	let baseUrl = import.meta.env.VITE_APP_BASE_URL || `${location.origin}/api/`
	sendloading.value = true;
	list.value.push({ msg_id: msg_id.value, role: 'user', content: inputValue.value });
	const postData = {
		msg_id: msg_id.value,
		role: 'user',
		content: inputValue.value,
		model_id: model_id.value
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
			list.value.push({ msg_id: '', role: 'system', content: content.value });
			content.value = ''
			inputValue.value = ''
			sendloading.value = false;

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
			list.value.push({ msg_id: '', role: 'system', content: content.value });
			content.value = ''
			inputValue.value = ''
			sendloading.value = false;
		},
		fail: error => { }
	})

	requestTask.onChunkReceived(function (res) {
		const uint8Array = new Uint8Array(res.data);
		let text = String.fromCharCode.apply(null, uint8Array);
		text = decodeURIComponent(escape(text));
		let updatedText = text.replace(content.value, "");
		content.value += updatedText;
	});
	// #endif
}
const sendMessage = async () => {
	getMsgID()
	if (inputValue.value == '') {
		uni.$u.toast('请填写问题内容')
	}
	if (inputValue.value.trim()) {
		sendloading.value = true;
		list.value.push({ msg_id: msg_id.value, role: 'user', content: inputValue.value });
		const res = await sendMsg({ msg_id: msg_id.value, content: inputValue.value, model_id: model_id.value });
		if (res.code == 1) {
			inputValue.value = '';
			list.value.push({ msg_id: '', role: 'system', content: res.data.msg });
			sendloading.value = false
		}
	}
};

const statusBarHeight = ref(0)
const barHeight = ref(0)
let list = ref<Array<Object>>([]);
let loading = ref<boolean>(false);

const getHistoryListFn = (mescroll) => {
	loading.value = false;
	let data: object = {
		page: mescroll.num,
		limit: mescroll.size,
		msg_id: msg_id.value
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
onLoad((options) => {
	// #ifdef MP-WEIXIN
	// 处理小程序场景值参数
	options = handleOnloadParams(options);
	// #endif


	// 判断是否已登录
	let data = {
		type: ''
	};
	if (!getToken()) {
		const login = useLogin()
		// 第三方平台自动登录
		// #ifdef MP
		login.getAuthCode()
		// #endif
		// #ifdef H5
		useLogin().setLoginBack({ url: '/addon/ai_humans/pages/model/chat' })
		// #endif
	}
	setTimeout(() => {
		if (!userInfo.value) {
			let pid = uni.getStorageSync('pid');
			if (pid && pid > 0) {
				useLogin().setLoginBack({ url: '/addon/ai_humans/pages/model/chat?mid=' + pid })
				return false
			} else {
				useLogin().setLoginBack({ url: '/addon/ai_humans/pages/model/chat' })
				return false
			}
		}
	}, 500)
	if (options.msg_id) {
		msg_id.value = options.msg_id
	}
	getMsgID()
	// 状态栏高度
	statusBarHeight.value = uni.getSystemInfoSync().statusBarHeight;
	// 胶囊数据
	const { top, height } = wx.getMenuButtonBoundingClientRect();
	// 自定义导航栏高度 = 胶囊高度 + 胶囊的padding*2, 如果获取不到设置为38
	barHeight.value = height ? height + (top - statusBarHeight.value) * 2 : 38;
});

const handleDemoClick = (content: string) => {
	inputValue.value = content;
	sendMessageStream();
}
</script>

<style lang="scss" scoped>
@import '@/addon/ai_humans/utils/styles/common.scss';

::deep .custom-textarea textarea {
	height: 12px;
	overflow-y: hidden;
}

.full-screen {
	// background-color: #0d0d28;
	min-height: 100vh;
	height: 100%;
	// margin-bottom: 100rpx;
	overflow: hidden;
	overflow-y: scroll;
}

.tk-tag {
	padding: 4rpx 8rpx;
	background: linear-gradient(-90deg, #ceb4e8 30%, #c5c7f9 100%);
	color: #ffffff;
	border-radius: 8rpx;
	font-size: 22rpx;
}

.b-tabbar {
	position: fixed;
	bottom: 12rpx;
	left: 0;
	z-index: 999;
	right: 0;
	margin: 0 24rpx;
	border-radius: 16rpx;
	padding: 8rpx;
}

.b-tabbar-back {
	background: rgba(250, 250, 252, 0.95);
	border-radius: 16rpx;
	backdrop-filter: blur(10px);
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.input-container {
	background: rgba(248, 248, 250, 0.8);
	border-radius: 12rpx;
	margin: 2rpx 0;
}

.custom-textarea {
	background: transparent;
	border-radius: 12rpx;
	padding: 12rpx 16rpx;
	transition: all 0.2s ease;
	font-size: 28rpx;

	&:focus {
		background: transparent;
		box-shadow: none;
	}
}

.tool-btn {
	@apply p-1.5 mx-1 rounded-full transition-colors duration-150;

	&:active {
		background-color: rgba(0, 0, 0, 0.05);
	}
}

.send-btn {
	font-size: 28rpx;
	background: linear-gradient(to right, #44c97d, #42c799);
	box-shadow: 0 2px 4px rgba(66, 199, 153, 0.2);
}

/* 自定义样式 */
.u-textarea {
	background: linear-gradient(-90deg, #ffffff 0%, #ffffff 100%);
	/* 背景颜色 */
	color: #595959;
	/* 文字颜色 */
}

.dialogbg {
	background: linear-gradient(-90deg, var(--primary-color) 0%, var(--primary-color) 100%);
	padding: 4rpx 16rpx;
	border-radius: 12rpx;
	color: #ffff;
}

.dialogbg1 {
	background: linear-gradient(-90deg, #f4f8f8 0%, #f5fafa 100%);
	padding: 26rpx;
	border-radius: 12rpx;
	color: #595959;
	display: block;
	overflow-x: auto;
}

.model {
	background: linear-gradient(-90deg, #fdfdfd 0%, #fcfcfc 100%);
	margin: 24rpx;
	border-radius: 12rpx;
	padding: 24rpx;
}

.demo-item {
	border: 1px solid rgba(0, 0, 0, 0.05);

	&:hover {
		transform: translateY(-2px);
		border-color: rgba(0, 0, 0, 0.1);
	}
}

.welcome-container {
	padding: 24rpx 0;
}

.demo-questions {
	display: flex;
	flex-direction: column;
	gap: 16rpx;
}

.demo-question-item {
	background-color: #f5f5f7;
	padding: 20rpx 24rpx;
	border-radius: 12rpx;
	color: #333;
	font-size: 28rpx;
	transition: all 0.2s;

	&:hover,
	&:active {
		background-color: #f0f0f2;
		transform: translateY(-2rpx);
	}
}

.tips-container {
	border-bottom: 1px solid #f0f0f0;
	padding-bottom: 24rpx;
}
</style>