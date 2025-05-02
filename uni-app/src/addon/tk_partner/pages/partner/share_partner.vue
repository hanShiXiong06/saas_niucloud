<template>
	<view class="min-h-[100vh] w-full bg-[#f5f5f5]" :style="themeColor()" v-if="shareInfo && configInfo">

		<!-- 海报轮播卡片 -->
		<view class="poster-container px-0 pt-0 mb-0" v-if="shareInfo.poster && shareInfo.poster.length > 0">
			<swiper class="poster-swiper w-full" :previous-margin="'140rpx'" :next-margin="'140rpx'" :circular="true"
				:current="currentPosterIndex" @change="handlePosterChange" @transition="handleTransition"
				@animationfinish="handleAnimationFinish" :autoplay="false" :display-multiple-items="1" :interval="3000"
				:duration="300">
				<!-- 轮播内容 -->
				<swiper-item v-for="(item, index) in shareInfo.poster" :key="index"
					class="poster-swiper-item flex justify-center items-center">
					<view class="poster-card flex justify-center items-center overflow-hidden" :class="[
						currentPosterIndex === index ? 'active-poster' : 'inactive-poster',
						animating && currentPosterIndex === index ? 'poster-card-enter' : ''
					]" @tap="previewImage(item)">
						<view class="poster-image-container flex justify-center items-center">
							<image :src="img(item)" mode="widthFix" class="poster-image"></image>
						</view>
					</view>
				</swiper-item>
			</swiper>

			<!-- 自定义指示器 -->
			<view class="poster-indicator flex justify-center items-center mt-8">
				<view v-for="(_, index) in shareInfo.poster" :key="index"
					class="indicator-dot mx-1 rounded-full transition-all duration-300"
					:class="currentPosterIndex === index ? 'active-dot' : 'inactive-dot'"
					@click="currentPosterIndex = index">
				</view>
			</view>
		</view>

		<!-- 空状态提示 -->
		<view v-else class="empty-state w-full py-16 flex flex-col items-center justify-center">
			<view class="loading-animation">
				<view class="loader-circle"></view>
				<view class="loader-line-mask">
					<view class="loader-line"></view>
				</view>
				<u-icon name="photo" size="64" color="#ccc" class="mt-4"></u-icon>
			</view>
			<text class="mt-4 text-gray-400">生成中,请稍后</text>
			<view class="tip-card animate-bounce-slow mt-6 bg-white rounded-lg px-4 py-3 shadow-md">
				<text class="text-sm text-gray-600">正在生成，长时间未生成成功请刷新页面...</text>
			</view>
		</view>

		<!-- 海报二维码分享部分 -->
		<view class="mx-4 bg-white rounded-xl mb-3 mt-8 shadow-sm">
			<!-- 添加标题和说明文字 -->
			<view class="px-4 py-3 border-b border-gray-50">
				<view class="flex items-center mb-1">
					<view class="title-decorator"></view>
					<text class="text-gray-800 font-bold">推广方式</text>
				</view>
				<text class="text-xs text-gray-500 leading-4">选择合适的方式邀请好友加入{{ configInfo.alias_name }}，获取更多收益</text>
			</view>

			<view class="flex justify-around items-center py-4">
				<view class="text-center">
					<!-- #ifdef MP -->
					<button class="share-mp-btn" open-type="share">
						<view class="w-11 h-11 rounded-full bg-green-50 flex items-center justify-center mx-auto mb-2">
							<u-icon name="weixin-fill" size="22" color="#07C160"></u-icon>
						</view>
						<text class="text-xs text-gray-600 block">分享给好友</text>
						<text class="text-xs text-gray-400 mt-1 block px-2">直接分享给微信好友</text>
					</button>
					<!-- #endif -->

					<!-- #ifdef H5 -->
					<view @click="handleShareToFriend">
						<view class="w-11 h-11 rounded-full bg-green-50 flex items-center justify-center mx-auto mb-2">
							<u-icon name="weixin-fill" size="22" color="#07C160"></u-icon>
						</view>
						<text class="text-xs text-gray-600 block">分享给好友</text>
						<text class="text-xs text-gray-400 mt-1 block px-2">直接分享给微信好友</text>
					</view>
					<!-- #endif -->
				</view>

				<view class="text-center" @click="shareShow = true">
					<view class="w-11 h-11 rounded-full bg-green-50 flex items-center justify-center mx-auto mb-2">
						<u-icon name="ie" size="22" color="#3B82F6"></u-icon>
					</view>
					<text class="text-xs text-gray-600 block">邀请</text>
					<text class="text-xs text-gray-400 mt-1 block px-2">推广链接和小程序信息</text>
				</view>
			</view>
			<view class="px-4 py-2 bg-gray-50 rounded-b-xl">
				<text class="text-xs text-gray-500">推广好友成为{{ configInfo.alias_name }}后，您将获得相应的佣金奖励</text>
			</view>
		</view>
		<view class="h-32"></view>
		<view
			class="py-[var(--top-m)] px-[var(--sidebar-m)] footer w-full fixed bottom-0 left-0 right-0 box-border bg-[var(--page-bg-color)] safe-area-inset-bottom z-10 shadow-lg">
			<view class="transform transition-all duration-300 hover:scale-[1.02] active:scale-[0.98]">
				<button hover-class="btn-hover"
					class="h-[88rpx] leading-[88rpx] rounded-[28rpx] text-[32rpx] text-[var(--primary-color-light)] w-full shadow-md transition-all duration-300 flex items-center justify-center"
					:style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color2))' }"
					@click="handleSavePoster">
					<u-icon name="download" class="mr-2" size="30" color="#ffffff"></u-icon>
					<text>保存邀请海报</text>
				</button>
			</view>
			<u-safe-bottom></u-safe-bottom>
		</view>
		<u-popup :show="shareShow" @close="closeSharePopup" mode="bottom" closeable :round="16" safe-area-inset-bottom
			close-icon-pos="top-right" :close-on-click-overlay="true" border-radius="16px"
			:custom-style="{ borderTopLeftRadius: '16px', borderTopRightRadius: '16px' }">
			<view class="popup-content">
				<view class="mx-4 bg-white rounded-xl my-4 shadow-sm">
					<view class="px-4 py-3 border-b border-gray-50 flex items-center">
						<view class="title-decorator"></view>
						<text class="text-gray-800 font-bold">邀请{{ configInfo.alias_name }}</text>
					</view>

					<view class="p-3.5 flex items-center justify-between border-b border-gray-50">
						<view class="flex items-center">
							<view class="w-9 h-9 rounded-lg bg-indigo-50 flex items-center justify-center mr-3">
								<u-icon name="ie" size="26" color="#4285F4"></u-icon>
							</view>
							<text class="text-gray-700">邀请链接</text>
						</view>
						<view class="flex items-center">
							<text class="text-gray-500 text-xs mr-2 bg-gray-50 px-2 py-1 rounded ">{{
								truncateUrl(partnerInfo.share_partner_url)
							}}</text>
							<view
								class="w-12 h-6 rounded bg-gray-100 hover:bg-gray-200 active:bg-gray-300 transition-colors flex items-center justify-center cursor-pointer"
								@click="copy(partnerInfo.share_partner_url, '')">
								<text class="iconfont icon-copy text-gray-500 text-sm px-2">复制</text>
							</view>
						</view>
					</view>
                    <view class="p-3.5 flex items-center justify-between border-b border-gray-50" v-if="shortLink!=''">
						<view class="flex items-center">
							<view class="w-9 h-9 rounded-lg bg-indigo-50 flex items-center justify-center mr-3">
								<u-icon name="weixin-fill" size="26" color="#4285F4"></u-icon>
							</view>
							<text class="text-gray-700">小程序短链</text>
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
								truncateUrl(shareInfo.appid)
							}}</text>
							<view
								class="w-12 h-6 rounded bg-gray-100 hover:bg-gray-200 active:bg-gray-300 transition-colors flex items-center justify-center cursor-pointer"
								@click="copy(shareInfo.appid, '')">
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
								truncateUrl('/addon/tk_partner/pages/partner/apply?mid=' + partnerInfo.member_id)
							}}</text>
							<view
								class="w-12 h-6 rounded bg-gray-100 hover:bg-gray-200 active:bg-gray-300 transition-colors flex items-center justify-center cursor-pointer"
								@click="copy('/addon/tk_partner/pages/partner/apply?mid=' + partnerInfo.member_id, '')">
								<text class="iconfont icon-copy text-gray-500 text-sm px-2">复制</text>
							</view>
						</view>
					</view>
				</view>
			</view>
		</u-popup>
	</view>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import { img, redirect, copy } from '@/utils/common';
import useMemberStore from '@/stores/member'
import useConfigStore from '@/stores/config'
import { onLoad,onShow } from '@dcloudio/uni-app';
import { getSharePartnerInfo, getConfig } from '@/addon/tk_partner/api/config';
import { getPartnerInfo } from '@/addon/tk_partner/api/partner';
import { truncateMiddle } from '@/addon/tk_partner/utils/ts/common';
import { checkPartnerOpenEvent } from '@/addon/tk_partner/utils/ts/common';
import { getShortLink } from '@/addon/tk_partner/api/config';
onShow(()=>{
	checkPartnerOpenEvent()
})
const configInfo = ref<any>(null)
getConfig().then((res: any) => {
	configInfo.value = res.data
})
// 声明数据
const shareInfo = ref<any>({})
const partnerInfo = ref<any>({})
const configStore = useConfigStore()
const qrcodeType = ref<'miniprogram' | 'official'>('miniprogram')
const loading = ref<boolean>(false)
const currentPosterIndex = ref<number>(0)
const animating = ref<boolean>(false)
const shareShow = ref<boolean>(false)
// 获取主题色
const themeStyle = computed(() => {
	return configStore.getThemeColor()
})
const shortLink = ref<any>('')
// 获取合伙人信息
getPartnerInfo({ type: 'partner' }).then((res: any) => {
	partnerInfo.value = res.data
	getShortLink({path:'/addon/tk_partner/pages/partner/apply?mid='+partnerInfo.value.member_id,title:'推广海报'}).then((res:any)=>{
		shortLink.value = res.data.link
	})
})

// 处理切换二维码类型
const handleChangeQrType = (type: 'miniprogram' | 'official') => {
	if (qrcodeType.value === type || loading.value) return

	loading.value = true
	qrcodeType.value = type

	// 获取对应类型的分享信息
	getSharePartnerInfo({ type }).then((res: any) => {
		console.log('切换二维码类型后获取的数据:', res.data)
		shareInfo.value = {
			...shareInfo.value,
			qrcode: res.data.qrcode
		}
	}).finally(() => {
		loading.value = false
	})
}

// 处理链接展示
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

// 处理分享给好友
const handleShareToFriend = () => {
	// 在H5环境下只需显示提示信息
	showToast('请长按图片或使用浏览器分享功能')
}

// 处理嵌入公众号
const handleJoinOfficialAccount = () => {
	showToast('公众号功能配置中')
}

// 处理店铺专属码
const handleShopQrcode = () => {
	uni.navigateTo({
		url: '/addon/tk_partner/pages/partner/qrcode'
	})
}

// 保存海报
const handleSavePoster = () => {
	if (shareInfo.value && shareInfo.value.poster && shareInfo.value.poster.length > 0) {
		// 获取当前选中的海报
		const currentPoster = shareInfo.value.poster[currentPosterIndex.value];
		// #ifdef MP
		uni.downloadFile({
			url: img(currentPoster),
			success: (res) => {
				if (res.errMsg == "downloadFile:ok") {
					uni.saveImageToPhotosAlbum({
						filePath: res.tempFilePath,
						success: () => {
							uni.showToast({
								title: '保存成功',
								icon: 'none'
							});
						},
						fail: (err) => {
							if (err.errno == 104) {
								let msg = '用户未授权隐私权限，将图像保存到相册失败';
								uni.showToast({ title: msg, icon: 'none' })
							} else if (err.errMsg == "saveImageToPhotosAlbum:fail auth deny" ||
								err.errMsg == "saveImageToPhotosAlbum:fail:auth denied") {
							} else if (err.errMsg == "saveImageToPhotosAlbum:fail cancel") {
								let msg = '用户取消将图片保存到相册';
								uni.showToast({ title: msg, icon: 'none' })
							} else {
								uni.showToast({ title: err.errMsg, icon: 'none' })
							}
						}
					});
				}
			},
			fail: (err) => {
				uni.showToast({
					title: err.errMsg,
					icon: 'none'
				});
			}
		});
		// #endif

		// #ifdef H5
		showToast('请长按图片保存')
		// #endif
	} else {
		showToast('暂无可保存的海报')
	}
}

// 处理海报切换
const handlePosterChange = (e: any) => {
	currentPosterIndex.value = e.detail.current
}

// 处理过渡动画
const handleTransition = (e: any) => {
	animating.value = true
}

// 处理动画完成
const handleAnimationFinish = () => {
	animating.value = false
}

// 预览图片
const previewImage = (item: string) => {
	uni.previewImage({
		urls: [img(item)],
		current: item
	})
}

// 页面加载
onLoad(() => {
	// 获取分享信息
	getSharePartnerInfo({ type: qrcodeType.value }).then((res: any) => {
		console.log('初始加载获取的数据:', res.data)
		shareInfo.value = res.data

		// 初始化假数据（如果后端没有返回数据）
		if (!shareInfo.value.poster || shareInfo.value.poster.length === 0) {
			console.log('后端未返回海报数据，使用默认数据')
			shareInfo.value.poster = [
				'/static/images/default_poster.png'
			]
		}
	}).catch(err => {
		console.error('获取分享信息失败:', err)
	})

	// 获取配置信息
	try {
		const configData = uni.getStorageSync('partner_config')
		if (configData) {
			configInfo.value = JSON.parse(configData)
		}
	} catch (e) {
		console.log('获取配置信息失败', e)
	}
});

// 关闭分享弹窗
const closeSharePopup = () => {
	shareShow.value = false
}
</script>

<style lang="scss" scoped>
@import '@/addon/tk_partner/utils/styles/common.scss';

.poster-container {
	position: relative;
	width: 100%;
	overflow: hidden;
	padding: 0;
}

.poster-swiper {
	margin-top: 40rpx;
	height: 820rpx;
	width: 100%;
}

.poster-swiper-item {
	display: flex;
	justify-content: center;
	align-items: center;
	width: 100%;
	height: 100%;
	box-sizing: border-box;
}

.poster-card {
	width: 100%;
	height: 100%;
	transition: all 0.4s ease;
	box-shadow: 0 10px 20px rgba(0, 0, 0, 0.12);
	border-radius: 16rpx;
	overflow: hidden;
	position: relative;
	margin: 0 auto;
	transform-origin: center center;
	background: #fff;
	padding: 0;

	&::after {
		content: '';
		position: absolute;
		top: 0;
		left: 0;
		right: 0;
		bottom: 0;
		background: linear-gradient(to bottom, rgba(0, 0, 0, 0) 80%, rgba(0, 0, 0, 0.1));
		z-index: 1;
		pointer-events: none;
	}

	&:active {
		transform: scale(0.98) !important;
	}
}

.poster-image-container {
	width: 100%;
	height: 100%;
	display: flex;
	justify-content: center;
	align-items: center;
	padding: 0;
	margin: 0;
	overflow: hidden;
}

.poster-image {
	width: 100%;
	max-height: 100%;
	display: block;
	margin: 0;
	padding: 0;
}

.poster-overlay {
	position: absolute;
	bottom: 20rpx;
	right: 20rpx;
	z-index: 10;
}

.poster-tag {
	background-color: rgba(0, 0, 0, 0.5);
	backdrop-filter: blur(5px);
	color: #fff;
	font-size: 24rpx;
	border: 1px solid rgba(255, 255, 255, 0.2);
}

.active-poster {
	transform: scale(1);
	opacity: 1;
	z-index: 10;
	box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
}

.inactive-poster {
	transform: scale(0.85);
	opacity: 0.65;
	filter: blur(0.5px);
	z-index: 1;
}

.poster-indicator {
	margin-top: 24rpx;
}

.indicator-dot {
	width: 12rpx;
	height: 12rpx;
	margin: 0 5rpx;
	background: rgba(200, 200, 200, 0.5);
	transition: all 0.3s ease;
}

.active-dot {
	width: 28rpx;
	background: var(--primary-color, #f59e0b);
}

.inactive-dot {
	background: #E0E0E0;
}

// 渐变背景
.bg-gradient-to-r {
	background-image: linear-gradient(to right, var(--primary-color, #f59e0b), var(--primary-help-color, #ef4444));
}

// 新增金币动画
@keyframes float {
	0% {
		transform: translateY(0px);
	}

	50% {
		transform: translateY(-10px);
	}

	100% {
		transform: translateY(0px);
	}
}

.floating-coin {
	animation: float 3s ease-in-out infinite;
}

// 3D转换效果
@keyframes card-rotate {
	0% {
		transform: perspective(1000px) rotateY(-1deg) scale(0.98);
	}

	50% {
		transform: perspective(1000px) rotateY(0deg) scale(1);
	}

	100% {
		transform: perspective(1000px) rotateY(1deg) scale(0.98);
	}
}

.poster-card-enter {
	animation: card-rotate 0.8s cubic-bezier(0.34, 1.56, 0.64, 1);
}

// 新增加载动画
@keyframes rotate {
	0% {
		transform: rotate(0deg);
	}

	100% {
		transform: rotate(360deg);
	}
}

@keyframes bounce-slow {

	0%,
	100% {
		transform: translateY(0);
	}

	50% {
		transform: translateY(-8px);
	}
}

.animate-bounce-slow {
	animation: bounce-slow 2s ease-in-out infinite;
}

.loading-animation {
	position: relative;
	width: 80px;
	height: 80px;
	margin-bottom: 10px;
}

.loader-circle {
	position: absolute;
	width: 100%;
	height: 100%;
	border: 4px solid rgba(var(--primary-color-rgb, 245, 158, 11), 0.1);
	border-radius: 50%;
}

.loader-line-mask {
	position: absolute;
	width: 50%;
	height: 100%;
	top: 0;
	right: 0;
	overflow: hidden;
	transform-origin: 0 50%;
	animation: rotate 1.5s ease-in-out infinite;
}

.loader-line {
	position: absolute;
	width: 100%;
	height: 100%;
	border: 4px solid var(--primary-color, #f59e0b);
	border-radius: 50%;
	left: 100%;
}

.tip-card {
	position: relative;
	max-width: 300rpx;
	z-index: 2;
	backdrop-filter: blur(5px);
	border: 1px solid rgba(var(--primary-color-rgb, 245, 158, 11), 0.1);
}

// 弹窗样式优化
.popup-content {
	padding: 10rpx 0;
	max-height: 85vh;
	overflow-y: auto;
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

.btn-hover {
	opacity: 0.9;
	transform: translateY(2rpx);
	box-shadow: 0 4rpx 8rpx rgba(0, 0, 0, 0.1);
}

:deep(.u-popup) {
	border-top-left-radius: 16px !important;
	border-top-right-radius: 16px !important;
	overflow: hidden;
}

:deep(.u-popup__content) {
	border-top-left-radius: 16px !important;
	border-top-right-radius: 16px !important;
}

:deep(.u-popup__content__close) {
	z-index: 999;
	top: 15px !important;
	right: 15px !important;
}
</style>