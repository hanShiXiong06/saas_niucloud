<template>
	<view class="flex flex-wrap">
		<view v-for="(item, index) in videoList"
			:class="['mb-[18rpx] relative', (index + 1) % 3 === 0 ? '' : 'mr-[18rpx]']">
			<u--video class="rounded-[10rpx] overflow-hidden" width="204rpx" height="204rpx" :src="img(item || '')"
				model="aspectFill">
				<template #error>
					<u-icon name="plus" color="#999" size="50"></u-icon>
				</template>
			</u--video>
			<text
				class="nc-iconfont nc-icon-guanbiV6xx absolute top-0 right-[5rpx] text-[#fff] bg-[#888] rounded-bl-[16rpx]"
				@click.stop="deleteVideo(index)"></text>
		</view>
		<view class="w-[204rpx] h-[204rpx]" v-show="videoList.length < maxCount">
			<u-upload @afterRead="afterRead" :maxCount="maxCount" :multiple="prop.multiple" :loading="loading">
				<view
					class="flex items-center justify-center w-[204rpx] h-[204rpx] border-[2rpx] border-dashed border-[#ebebec] text-center text-[#888]">
					<view v-if="!loading">
						<view class="nc-iconfont nc-icon-xiangjiV6xx text-[50rpx]"></view>
						<view class="text-[24rpx] mt-[10rpx]">{{ videoList.length }}/{{ maxCount }}</view>
					</view>
					<view v-else class="flex flex-col items-center">
						<u-loading mode="circle" color="#2979ff"></u-loading>
						<view class="text-[24rpx] mt-[10rpx]" v-if="uploadProgress < 100">上传中 {{ uploadProgress }}%</view>
						<view class="text-[24rpx] mt-[10rpx]" v-else>处理中...</view>
					</view>
				</view>
			</u-upload>
		</view>
		
		<!-- 视频压缩选项 -->
		<view class="w-full flex items-center mt-[16rpx]" v-if="showCompressOption">
			<u-checkbox v-model="enableCompress" @change="onCompressChange">启用压缩</u-checkbox>
			<u-slider v-if="enableCompress" :value="qualityValue" @changing="onQualityChange" @change="onQualityConfirm" 
				class="flex-1 mx-[20rpx]" min="30" max="100" step="10"></u-slider>
			<text v-if="enableCompress" class="text-[24rpx] text-[#666] w-[80rpx]">{{qualityValue}}%</text>
		</view>

		<!-- #ifdef MP-WEIXIN -->
		<!-- 小程序隐私协议 -->
		<wx-privacy-popup ref="wxPrivacyPopupRef"></wx-privacy-popup>
		<!-- #endif -->
	</view>
</template>
<script lang="ts" setup>
import { computed, ref, watch, onBeforeUnmount } from 'vue';
import { img } from '@/utils/common';
import { uploadVideo } from '@/app/api/system'

const prop = defineProps({
	modelValue: {
		type: [String, Array],
		default: () => []
	},
	maxCount: {
		type: Number,
		default: 9
	},
	multiple: {
		type: Boolean,
		default: false
	},
	compress: {
		type: Boolean,
		default: true
	},
	quality: {
		type: Number,
		default: 0.8
	},
	showCompressOption: {
		type: Boolean,
		default: false
	}
})

const emit = defineEmits(['update:modelValue'])
const loading = ref(false)
const enableCompress = ref(prop.compress)
const qualityValue = ref(Math.round(prop.quality * 100))
const uploadProgress = ref(0)
const videoUploadTask = ref<UniApp.UploadTask | null>(null)

// 监听压缩设置变化
watch(enableCompress, (val) => {
	console.log('压缩状态变更:', val)
})

const onCompressChange = (val: boolean) => {
	enableCompress.value = val
}

const onQualityChange = (val: number) => {
	qualityValue.value = val
}

const onQualityConfirm = (val: number) => {
	qualityValue.value = val
	console.log('设置压缩质量:', val / 100)
}

const videoList = computed<string[]>({
	get() {
		if (typeof prop.modelValue === 'string') {
			return prop.modelValue ? [prop.modelValue] : []
		}
		return prop.modelValue as string[] || []
	},
	set(value) {
		emit('update:modelValue', value)
	}
})

const maxCount = computed(() => prop.maxCount)

// 定义接口用于视频压缩
interface VideoInfo {
	tempFilePath: string;
	size?: number;
	duration?: number;
	width?: number;
	height?: number;
}

// 视频压缩
const compressVideo = (file: VideoInfo): Promise<string> => {
	return new Promise((resolve, reject) => {
		if (!enableCompress.value) {
			resolve(file.tempFilePath)
			return
		}
		
		// #ifdef APP-PLUS || MP-WEIXIN
		// 根据用户设置的质量值计算压缩质量
		const quality = qualityValue.value >= 90 ? 'high' : qualityValue.value >= 60 ? 'medium' : 'low'
		
		uni.showLoading({ title: '视频压缩中', mask: true })
		
		uni.compressVideo({
			src: file.tempFilePath,
			quality,
			success: (res) => {
				uni.hideLoading()
				console.log('视频压缩成功, 原大小:', file.size, '压缩后:', res.size)
				resolve(res.tempFilePath)
			},
			fail: (err) => {
				uni.hideLoading()
				console.error('视频压缩失败:', err)
				uni.showModal({
					title: '压缩失败',
					content: '视频压缩失败，是否直接上传原视频？',
					success: (res) => {
						if (res.confirm) {
							resolve(file.tempFilePath) // 压缩失败时使用原文件
						} else {
							reject(new Error('用户取消上传'))
						}
					}
				})
			}
		})
		// #endif
		
		// #ifndef APP-PLUS || MP-WEIXIN
		resolve(file.tempFilePath) // 不支持压缩的平台直接使用原文件
		// #endif
	})
}

const afterRead = (event: any) => {
	if (prop.multiple) {
		const files = event.file as any[]
		uploadMultiple(files)
	} else {
		upload(event)
	}
}

// 批量上传处理
const uploadMultiple = async (files: any[]) => {
	if (videoList.value.length >= maxCount.value) {
		uni.showToast({ title: `最多允许上传${maxCount.value}个视频`, icon: 'none' })
		return
	}
	
	try {
		loading.value = true
		
		// 使用Promise.all处理多个文件并行上传
		const uploadPromises = files.map(file => {
			if (videoList.value.length < maxCount.value) {
				return upload({ file })
			}
			return Promise.resolve()
		})
		
		await Promise.all(uploadPromises)
	} catch (error) {
		console.error('批量上传失败:', error)
	} finally {
		loading.value = false
	}
}

const upload = async (event: any) => {
	if (videoList.value.length >= maxCount.value) {
		uni.showToast({ title: `最多允许上传${maxCount.value}个视频`, icon: 'none' })
		return false
	}

	try {
		loading.value = true
		uploadProgress.value = 0
		
		// 获取视频路径
		let videoPath = event.file.url
		let videoInfo: VideoInfo = { tempFilePath: videoPath }
		
		// 如果支持压缩且开启了压缩选项
		if (enableCompress.value) {
			// #ifdef APP-PLUS || MP-WEIXIN
			try {
				// 获取视频信息
				videoInfo = await new Promise<VideoInfo>((resolve, reject) => {
					uni.getVideoInfo({
						src: videoPath,
						success: (res) => {
							resolve({ 
								tempFilePath: videoPath,
								size: res.size,
								duration: res.duration,
								width: res.width,
								height: res.height
							})
						},
						fail: (err) => {
							console.error('获取视频信息失败:', err)
							resolve({ tempFilePath: videoPath })
						}
					})
				})
				
				// 视频过大时才压缩(大于10MB)
				if (videoInfo.size && videoInfo.size > 10 * 1024 * 1024) {
					videoPath = await compressVideo(videoInfo)
				} else {
					console.log('视频较小，跳过压缩')
				}
			} catch (error) {
				console.error('压缩过程出错:', error)
				// 如果用户取消了，则停止上传
				if (error instanceof Error && error.message === '用户取消上传') {
					loading.value = false
					return false
				}
			}
			// #endif
		}
		
		// 使用uploadVideo API，因为它封装了上传功能
		const res = await new Promise<any>((resolve, reject) => {
			const task = uploadVideo({
				filePath: videoPath,
				name: 'file',
				onProgressUpdate: (progressRes: any) => {
					uploadProgress.value = progressRes.progress || 0
				}
			}) as any
			
			// 保存上传任务引用
			videoUploadTask.value = task
			
			// 尝试检测是否有promise的结构
			if (task && typeof task.then === 'function') {
				task.then(resolve).catch(reject)
			} else if (task && typeof task.onProgressUpdate === 'function') {
				// 如果是原生上传任务对象
				task.onProgressUpdate((res: any) => {
					uploadProgress.value = res.progress || 0
				})
			}
		})
		
		if (videoList.value.length < maxCount.value && res?.data?.url) {
			const newList = [...videoList.value]
			newList.push(res.data.url)
			videoList.value = newList
			uni.showToast({ title: '上传成功', icon: 'success' })
		}
	} catch (error) {
		uni.showToast({ title: '上传失败，请重试', icon: 'none' })
		console.error('上传视频失败:', error)
	} finally {
		loading.value = false
		videoUploadTask.value = null
		uploadProgress.value = 0
	}
}

const deleteVideo = (index: number) => {
	const newList = [...videoList.value]
	newList.splice(index, 1)
	videoList.value = newList
}

const cancelUpload = () => {
	if (videoUploadTask.value) {
		videoUploadTask.value.abort()
		videoUploadTask.value = null
		loading.value = false
		uploadProgress.value = 0
		uni.showToast({ title: '已取消上传', icon: 'none' })
	}
}

// 组件卸载时取消上传任务
onBeforeUnmount(() => {
	if (videoUploadTask.value) {
		videoUploadTask.value.abort()
	}
})
</script>