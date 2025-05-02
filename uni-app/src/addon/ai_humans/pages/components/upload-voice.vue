<template>
	<view class='text-white flex flex-col items-center justify-center p-4 m-8 rounded-lg'>
		<view class='text-white' v-if="status === 1">
			<view class="p-4 flex flex-col items-center justify-center space-y-4" style="border-width: 12rpx;"
				@tap="start">

				<view class="flex items-center flex-col space-y-4">
					<view class="relative">
						<u-icon name="mic" color="var(--primary-color-light)" size="52"></u-icon>
						<div class="absolute inset-0 rounded-full animate-pulse-ring"></div>
					</view>
					<view class="text-[var(--primary-color-light)] text-[24rpx] mt-4">点击录制自己的声音</view>
				</view>
			</view>
		</view>

		<view v-if="status === 2" class="flex flex-col items-center justify-center space-y-4 mb-4">
			<view class="text-center">
				<text class="text-2xl font-semibold text-white">{{ duration }}</text>
				<text class="text-lg text-gray-300">录音中</text>
				<view v-if="props.maxDuration > 0" class="text-sm text-[var(--primary-color)] mt-2">
					剩余时间: {{ remainingTime }}s
				</view>
			</view>
			<view class="w-18 h-18 bg-red-500 flex items-center justify-center rounded-full shadow-lg"
				style="border-width: 12rpx;" @tap="stop">
				<u-icon name="mic" color="var(--primary-color)" size="52"></u-icon>
			</view>
		</view>

		<view class="flex flex-col items-center justify-center space-y-4 p-4" v-if="status === 3">
			<view class="text-center space-y-2" v-if="duration > 0">
				<view class="text-2xl font-semibold text-[var(--primary-color)]">{{ duration }}s</view>
			</view>
			<view class="flex space-x-16 mt-4">
				<view class="flex flex-col items-center cursor-pointer" @click="reRecord">
					<view>
						<u-icon name="reload" color="var(--primary-color-light)" size="24"></u-icon>
					</view>
					<text class="text-sm text-[var(--primary-color-light)] mt-2">重录</text>
				</view>
				<view class="flex flex-col items-center cursor-pointer relative" @click="play">
					<view class="absolute inset-0 flex items-center justify-center" v-if="audioStatus">
						<div
							class="w-24 h-24 rounded-full border-4 border-t-4 border-[var(--primary-color-light)] animate-spin">
						</div>
					</view>
					<view>
						<u-icon :name="audioStatus ? 'pause' : 'play-right'" color="var(--primary-color)"
							size="24"></u-icon>
					</view>
					<text class="text-sm text-[var(--primary-color-light)] mt-2">{{ audioStatus ? '暂停' : '播放' }}</text>
				</view>
			</view>
		</view>

		<!-- #ifdef MP-WEIXIN -->
		<view class="border-2 border-dashed border-[var(--primary-color)] rounded-lg p-2 flex items-center space-x-4"
			@click="chooseMessageFile">

			<view class="flex flex-col">
				<text class="font-semibold text-[var(--primary-color)]">从微信中选择</text>
				<text class="text-sm text-[var(--primary-color-light)]">格式要求: mp3 m4a wav</text>
			</view>
		</view>
		<!-- #endif -->

		<!-- #ifdef H5 -->
		<view class="border-2 border-dashed border-[var(--primary-color)] rounded-lg p-2 flex items-center space-x-4"
			@click="chooseFile">
			<view class="flex flex-col">
				<text class="font-semibold text-[var(--primary-color)]">从文件中选择</text>
			</view>
		</view>
		<!-- #endif -->

	</view>
</template>

<script setup lang="ts">
import { ref, onMounted, defineProps, onUnmounted, computed } from 'vue';

// 添加防抖函数
const debounce = (fn: Function, delay: number = 300) => {
	let timer: any = null;
	return function (this: any, ...args: any[]) {
		if (timer) clearTimeout(timer);
		timer = setTimeout(() => {
			fn.apply(this, args);
			timer = null;
		}, delay);
	};
};

const props = withDefaults(defineProps<{
	iconSize?: string | number
	maxDuration?: number
}>(), {
	iconSize: '50',
	maxDuration: 19
});
const status = ref(1)
const emit = defineEmits(['start', 'success']);
const recorderState = ref(false);
const h5RecorderState = ref(true);
let mediaRecorder: MediaRecorder;
let mediaStream: MediaStream;
let recordedBlobs: BlobPart[] = [];
let isUserMedia = false;
let audio: HTMLAudioElement;
let startTime: number;
let startTimeEr: any;
const duration = ref(0);
const remainingTime = computed(() => props.maxDuration - duration.value);
let innerAudioContext = uni.createInnerAudioContext();
// 防止重复提交标志
const isSubmitting = ref(false);

// #ifndef H5
const recorderManager = uni.getRecorderManager();
// #endif

// #ifdef H5
const checkUserMedia = () => {
	if (location.protocol !== 'https:') {
		uni.showModal({
			content: '录音只能在HTTPS环境中使用'
		})
		return h5RecorderState.value = false;
	}
	if (!navigator.mediaDevices || !window.MediaRecorder) {
		uni.showModal({
			content: '当前浏览器不支持录音，请更换浏览器或在微信中打开。'
		})
		return h5RecorderState.value = false;
	}
	audio = document.createElement('audio')
	navigator.mediaDevices.getUserMedia({ audio: true })
		.then(stream => {
			isUserMedia = true;
			stream.getTracks().forEach((track) => {
				track.stop()
			})
		})
		.catch(error => console.error('Error:', error));
}
// #endif

// 防抖处理后的提交函数
const submitSuccess = debounce((data: any) => {
	if (isSubmitting.value) return;
	isSubmitting.value = true;

	// 统一所有平台发送的数据格式
	emit('success', data);

	// 设置延迟后允许再次提交
	setTimeout(() => {
		isSubmitting.value = false;
	}, 1000);
}, 300);

// 获取音频文件的实际时长
const getAudioDuration = (url: string): Promise<number> => {
	return new Promise((resolve) => {
		const tempAudio = new Audio();
		tempAudio.src = url;
		
		// 监听元数据加载完成事件
		tempAudio.addEventListener('loadedmetadata', () => {
			if (tempAudio.duration && tempAudio.duration !== Infinity) {
				resolve(Math.ceil(tempAudio.duration));
			} else {
				// 尝试通过播放来获取时长
				const handleCanPlay = () => {
					tempAudio.pause();
					tempAudio.currentTime = 24 * 60 * 60; // 设置一个很大的时间
					
					const handleSeeking = () => {
						tempAudio.removeEventListener('seeking', handleSeeking);
						resolve(Math.ceil(tempAudio.duration));
					};
					
					tempAudio.addEventListener('seeking', handleSeeking);
				};
				
				tempAudio.addEventListener('canplay', handleCanPlay, { once: true });
				tempAudio.load();
			}
		});
		
		// 设置超时，避免无限等待
		setTimeout(() => {
			if (!tempAudio.duration || tempAudio.duration === Infinity) {
				resolve(0); // 如果无法获取时长，返回0
			}
		}, 2000);
	});
};

const start = () => {
	duration.value = 0;
	// #ifdef H5
	if (!isUserMedia) {
		uni.showToast({
			title: '请允许使用麦克风',
			icon: 'none'
		})
		return;
	}
	emit('start')
	navigator.mediaDevices.getUserMedia({ audio: true }).then(stream => {
		status.value = 2
		recordedBlobs = []
		mediaStream = stream
		mediaRecorder = new MediaRecorder(stream, {
			audioBitsPerSecond: 128000
		})
		mediaRecorder.ondataavailable = (event) => {
			recorderState.value = true;
			recordedBlobs.push(event.data)
		}
		mediaRecorder.onstop = () => {
			clearInterval(startTimeEr);
			recorderState.value = false;
			const fileExt = 'mp3';
			const fileName = `record_${new Date().getTime()}.${fileExt}`;

			// 创建blob并转为File对象
			const blob = new Blob(recordedBlobs, { type: 'audio/mp3' });
			const file = new File([blob], fileName, { type: 'audio/mp3' });

			// 创建URL用于播放
			const blobUrl = URL.createObjectURL(file);
			innerAudioContext.src = blobUrl;

			// 读取文件内容转为base64
			const reader = new FileReader();
			reader.onload = function (e) {
				if (!e.target?.result) return;

				const base64Data = e.target.result as string;
				// 提取纯base64内容(移除data:audio/mp3;base64,前缀)
				const pureBase64 = base64Data.split(',')[1];

				// 使用防抖处理后的提交函数
				submitSuccess({
					url: blobUrl,
					base64: pureBase64,
					fileName,
					fileExt,
					duration: duration.value
				});
			};
			reader.readAsDataURL(blob);
		}
		mediaRecorder.start()
		startTime = new Date().getTime();
		startTimeEr = setInterval(() => {
			duration.value = Math.floor((new Date().getTime() - startTime) / 1000);
			if (props.maxDuration && duration.value >= props.maxDuration) {
				stop();
			}
		}, 1000)
		recorderState.value = true;
	}).catch(err => {
		let content = '';
		switch (err.name) {
			case 'NotAllowedError':
				content = '当前浏览器不支持录音，请更换浏览器或在微信中打开。';
				break;
			case 'NotReadableError':
				content = '麦克风权限被拒绝，请刷新页面后授权麦克风权限。';
				break
			default:
				content = '未知错误，请刷新页面重试：' + JSON.stringify(err);
				break
		}
		uni.showModal({
			content: content,
			success: (res: any) => {
				if (res.confirm) {
					uni.navigateBack()
				}
			}
		})
	})
	// #endif
	// #ifndef H5
	emit('start')
	startTime = new Date().getTime();
	startTimeEr = setInterval(() => {
		duration.value = Math.floor((new Date().getTime() - startTime) / 1000);
		if (props.maxDuration && duration.value >= props.maxDuration) {
			stop();
		}
	}, 1000)
	recorderState.value = true;
	let options = {
		duration: 600000,
		format: 'mp3',
	};
	if (props.maxDuration) {
		options.duration = props.maxDuration * 1000;
	}
	recorderManager.start(options);
	// #endif
}

const stop = () => {
	status.value = 3
	// #ifdef H5
	mediaRecorder.stop()
	mediaStream.getTracks().forEach((track) => {
		track.stop()
	})
	// #endif
	// #ifndef H5
	recorderManager.stop();
	// #endif
}

onMounted(() => {
	// #ifdef H5
	checkUserMedia()
	// #endif
	innerAudioContext.onCanplay(() => {
		setTimeout(() => {
			if (innerAudioContext.duration !== Infinity && innerAudioContext.duration > 0) {
				duration.value = Math.ceil(innerAudioContext.duration)
			}
		}, 300)
	})

	innerAudioContext.onPlay(() => {
		audioStatus.value = true
	})

	innerAudioContext.onStop(() => {
		audioStatus.value = false
	})

	innerAudioContext.onPause(() => {
		audioStatus.value = false
	})

	innerAudioContext.onEnded(() => {
		audioStatus.value = false
	})

	// #ifndef H5
	recorderManager.onStop((res: any) => {
		clearInterval(startTimeEr);
		recorderState.value = false;
		const tempFilePath = res.tempFilePath
		innerAudioContext.src = tempFilePath

		// 提取文件扩展名
		const fileExt = tempFilePath.substring(tempFilePath.lastIndexOf('.') + 1).toLowerCase() || 'mp3';
		const fileName = `record_${new Date().getTime()}.${fileExt}`;

		// 小程序环境需要转换为base64
		// #ifdef MP-WEIXIN
		uni.getFileSystemManager().readFile({
			filePath: tempFilePath,
			encoding: 'base64',
			success: (res) => {
				// 使用防抖处理后的提交函数
				submitSuccess({
					url: tempFilePath,
					base64: res.data, // 纯base64数据
					fileName,
					fileExt,
					duration: duration.value
				});
			},
			fail: (err) => {
				console.error('读取文件失败', err);
				uni.showToast({
					title: '读取录音文件失败',
					icon: 'none'
				});
			}
		});
		// #endif

		// #ifndef MP-WEIXIN
		// 其他平台的处理方式
		// 这里需要增加转base64的逻辑，因为后端期望接收base64数据
		// 以下是一个基本结构，实际实现可能根据平台差异而不同
		// 可能需要另外实现各平台的读取文件并转base64的逻辑
		submitSuccess({
			url: tempFilePath,
			// 由于无法直接获取base64，可能需要先上传再由后端处理
			fileName,
			fileExt,
			duration: duration.value
		});
		// #endif
	});

	recorderManager.onError((err: any) => {
		uni.showModal({
			title: '录制失败:',
			content: err.errMsg
		})
		status.value = 1
		clearInterval(startTimeEr);
		recorderState.value = false;
	});

	recorderManager.onStart(() => {
		status.value = 2
	})
	// #endif
})

defineExpose({
	start,
	stop
})

const audioStatus = ref(false)

const play = () => {
	if (audioStatus.value == false) {
		innerAudioContext.play()
		audioStatus.value = true
	} else {
		innerAudioContext.pause()
		audioStatus.value = false
	}
}

const reRecord = () => {
	if (audioStatus.value) {
		innerAudioContext.pause()
		audioStatus.value = false
	}
	status.value = 1
}

const chooseMessageFile = () => {
	// #ifdef MP-WEIXIN
	uni.chooseMessageFile({
		count: 1,
		type: 'file',
		extension: ['mp3', 'wav', 'm4a', 'webm'],
		success: async (res: any) => {
			const file = res.tempFiles[0];
			status.value = 3;
			
			// 提取文件名和扩展名
			const fileName = file.name || 'audio.mp3';
			const fileExt = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase() || 'mp3';

			// 显示加载中
			uni.showLoading({ title: '处理中...' });
			
			try {
				// 直接读取文件内容为base64
				const base64Data = await new Promise<string>((resolve, reject) => {
					uni.getFileSystemManager().readFile({
						filePath: file.path,
						encoding: 'base64',
						success: (res) => resolve(res.data as string),
						fail: (err) => reject(err)
					});
				});
				
				// 隐藏加载提示
				uni.hideLoading();
				
				// 设置播放源
				innerAudioContext.src = file.path;
				
				// 提交结果 - 直接使用duration = 0，不需要读取实际时长
				submitSuccess({
					url: file.path,
					base64: base64Data,
					fileName,
					fileExt,
					duration: file.duration || 0 // 如果有时长信息使用，否则默认为0
				});
				
			} catch (error) {
				// 处理错误
				uni.hideLoading();
				console.error('读取文件失败', error);
				uni.showToast({
					title: '读取音频文件失败',
					icon: 'none'
				});
			}
		},
		fail: (err: any) => {
			console.log('err', err);
			uni.showToast({
				title: '选择文件失败',
				icon: 'none'
			});
		}
	});
	// #endif
}

const chooseFile = () => {
	// #ifdef H5
	// 创建隐藏的文件输入框
	const fileInput = document.createElement('input');
	fileInput.type = 'file';
	fileInput.accept = 'audio/mp3,audio/wav,audio/m4a,audio/webm,.mp3,.wav,.m4a,.webm';
	fileInput.style.display = 'none';
	document.body.appendChild(fileInput);

	fileInput.onchange = async (e: any) => {
		if (e.target.files && e.target.files.length > 0) {
			const file = e.target.files[0];

			// 提取文件名和扩展名
			const fileName = file.name || 'audio.mp3';
			const fileExt = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase() || 'mp3';

			// 确保文件名包含扩展名
			let finalFileName = fileName;
			if (!finalFileName.toLowerCase().endsWith(`.${fileExt}`)) {
				finalFileName = `${finalFileName}.${fileExt}`;
			}

			// 创建URL用于播放
			const blobUrl = URL.createObjectURL(file);
			
			// 不再需要获取时长，直接设置为0或使用文件元数据中的时长信息（如果有）
			duration.value = 0;
			
			innerAudioContext.src = blobUrl;
			status.value = 3;

			// 显示加载中
			uni.showLoading({ title: '处理中...' });

			// 读取文件内容并转为base64
			try {
				const base64Data = await new Promise<string>((resolve, reject) => {
					const reader = new FileReader();
					reader.onload = (e) => {
						if (!e.target?.result) reject(new Error('读取文件失败'));
						else {
							const result = e.target.result as string;
							// 提取纯base64内容(移除data:audio/mp3;base64,前缀)
							const pureBase64 = result.split(',')[1];
							resolve(pureBase64);
						}
					};
					reader.onerror = (e) => reject(e);
					reader.readAsDataURL(file);
				});

				uni.hideLoading();

				// 使用防抖处理后的提交函数
				submitSuccess({
					url: blobUrl,
					base64: base64Data,
					fileName: finalFileName,
					fileExt,
					duration: 0 // 直接使用0，不需要读取时长
				});
			} catch (error) {
				uni.hideLoading();
				console.error('读取文件失败', error);
				uni.showToast({
					title: '读取音频文件失败',
					icon: 'none'
				});
			}
		}

		// 移除文件输入框
		document.body.removeChild(fileInput);
	};

	// 触发文件选择
	fileInput.click();
	// #endif
}

onUnmounted(() => {
	if (innerAudioContext) {
		try {
			innerAudioContext.pause();
			innerAudioContext.destroy()
		} catch (e) {
			//TODO handle the exception
		}
	}
	if (startTimeEr) {
		clearInterval(startTimeEr);
	}
})
</script>

<style lang="scss" scoped>
@keyframes pulse-ring {
	0% {
		transform: scale(0.8);
		opacity: 0.7;
	}

	100% {
		transform: scale(1.5);
		opacity: 0;
	}
}

.animate-pulse-ring {
	background: radial-gradient(circle, var(--primary-color) 0%, var(--primary-color-light) 100%);
	animation: pulse-ring 1.5s infinite;
	pointer-events: none;
}

@keyframes spin {
	0% {
		transform: rotate(0deg);
	}

	100% {
		transform: rotate(360deg);
	}
}

.text-2xl {
	font-size: 24px;
}

.text-lg {
	font-size: 18px;
}

.w-20 {
	width: 80px;
}

.h-20 {
	height: 80px;
}
</style>