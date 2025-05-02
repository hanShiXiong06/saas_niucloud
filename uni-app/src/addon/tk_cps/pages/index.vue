<template>
	<!-- 加载中状态 -->




	<!-- #ifdef H5 -->
	<view v-if="valueData && valueData.h5 == ''" class="mt-[200px]">
		<u-empty mode="data" text="该活动不支持此渠道~~~">
		</u-empty>
	</view>
	<!-- #endif -->
	<!-- #ifdef MP-WEIXIN -->
	<view v-if="valueData && !valueData.weapp?.appid" class="mt-[200px] flex items-center flex-col">
		<view class="">请访问链接获取优惠信息</view>
		<view class="w-[340rpx] mt-[60rpx]">
			<u-button text="复制链接" @click="copy(valueData.wap_url)"
				color="linear-gradient(to right, rgb(66, 83, 216), rgb(104, 104, 213))"></u-button>
		</view>
		<view class="mt-[60rpx]">
			<u-steps current="2" dot activeColor="rgb(66, 83, 216)">
				<u-steps-item title="复制链接" desc="点击复制链接"></u-steps-item>
				<u-steps-item title="粘贴链接" desc="在微信对话框或者浏览器粘贴链接"></u-steps-item>
				<u-steps-item title="打开链接" desc="访问复制的链接"></u-steps-item>
			</u-steps>
		</view>
	</view>
	<!-- #endif -->

	<!-- 参数不完整时的提示 -->
	<view v-else-if="!paramsRef.type || !paramsRef.act_id" class="mt-[200px]">
		<u-empty mode="data" text="参数不完整，无法加载数据">
		</u-empty>
	</view>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { getCpsInfo } from '@/addon/tk_cps/api/cps'
import { onLoad, onShow } from '@dcloudio/uni-app'
import { useShare } from '@/hooks/useShare'
import {
	copy as copyText, getToken
} from '@/utils/common'
import { useLogin } from "@/hooks/useLogin";
const { setShare, onShareAppMessage, onShareTimeline } = useShare()
const valueData = ref()
const paramsRef = ref<{ type?: string; act_id?: string }>({})
const isLoading = ref(false)
const loadError = ref(false)

// 存储参数到本地缓存
const saveParamsToStorage = (params: { type?: string, act_id?: string }) => {
	if (params.type && params.act_id) {
		uni.setStorageSync('tk_cps_params', params);
	}
}

// 从本地缓存获取参数
const getParamsFromStorage = () => {
	const params = uni.getStorageSync('tk_cps_params');
	if (params) {
		paramsRef.value = params;
		return true;
	}
	return false;
}

// 清除缓存的参数
const clearParamsStorage = () => {
	uni.removeStorageSync('tk_cps_params');
}

const copy = (text: string) => {
	copyText(text, () => {
		uni.showToast({
			title: '复制成功',
			icon: 'none'
		})
	})
}

const goto = () => {
	// #ifdef MP-WEIXIN
	if (valueData.value?.weapp?.appid) {
		uni.navigateToMiniProgram({
			appId: valueData.value.weapp.appid,
			path: valueData.value.weapp.pagepath,
			extraData: {},
			success(res) {
				console.log('小程序跳转成功');
			},
			fail(err) {
				console.error('小程序跳转失败:', err);
				uni.showToast({
					title: '小程序跳转失败',
					icon: 'none'
				});
			}
		})
	} else {
		uni.showToast({
			title: '无效的小程序信息',
			icon: 'none'
		});
	}
	// #endif
}

// 加载数据函数
const loadData = () => {
	if (!paramsRef.value.type || !paramsRef.value.act_id) {
		uni.showToast({
			title: '参数不完整',
			icon: 'none'
		});
		return;
	}

	isLoading.value = true;
	loadError.value = false;

	getCpsInfo({
		type: paramsRef.value.type,
		act_id: paramsRef.value.act_id
	}).then((res: any) => {
		isLoading.value = false;
		if (!res.data) {
			loadError.value = true;
			uni.showToast({
				title: '获取数据为空',
				icon: 'none'
			});
			return;
		}

		valueData.value = res.data;
		// 数据加载成功后，可以清除参数缓存
		clearParamsStorage();

		uni.setNavigationBarTitle({
			title: res.data.act_name || '活动详情'
		});

		// #ifdef H5
		if (valueData.value.h5 != '') {
			window.location.href = valueData.value.h5;
		} else {
			uni.showToast({
				title: '当前渠道不支持此活动',
				icon: 'none'
			});
		}
		// #endif

		// #ifdef MP-WEIXIN
		if (paramsRef.value.type == '11') {
			// 内部页面跳转
			uni.navigateTo({
				url: valueData.value.path,
				success: () => {
					console.log('内部页面跳转成功');
				},
				fail: (err) => {
					console.error('内部页面跳转失败:', err);
					uni.showToast({
						title: '页面跳转失败',
						icon: 'none'
					});
				}
			});
			uni.navigateBack();
		} else if (valueData.value?.weapp?.appid) {
			// 直接跳转到其他小程序
			goto();
		} else {
			// 无效的小程序信息
			uni.showToast({
				title: '无效的活动信息',
				icon: 'none'
			});
		}
		// #endif
	}).catch((err) => {
		isLoading.value = false;
		loadError.value = true;
		uni.showToast({
			title: '加载数据失败',
			icon: 'none'
		});
		console.error('加载数据失败:', err);
	});
}

onShow(() => {
	setShare();
	onShareAppMessage();
	onShareTimeline();
	// 检查登录状态和参数
	if (getToken()) {
		// 尝试从缓存获取参数
		if ((!paramsRef.value.type || !paramsRef.value.act_id) && getParamsFromStorage()) {
			console.log('从缓存恢复参数:', paramsRef.value);
		}

		// 如果有参数则加载数据
		if (paramsRef.value.type && paramsRef.value.act_id) {
			loadData();
		}
	} else {
		// 未登录状态，检查是否有参数并保存
		if ((!paramsRef.value.type || !paramsRef.value.act_id) && getParamsFromStorage()) {
			console.log('从缓存恢复参数:', paramsRef.value);
		}

		// #ifdef MP
		// 尝试自动登录
		const login = useLogin();
		login.getAuthCode({
			successCallback: () => {
				// 登录成功后检查参数并加载数据
				if (paramsRef.value.type && paramsRef.value.act_id) {
					loadData();
				}
			}
		});
		// #endif
	}
})

onLoad((options) => {
	// 保存URL参数到ref中
	if (options && options.type && options.act_id) {
		paramsRef.value = {
			type: options.type,
			act_id: options.act_id
		};
		// 同时保存到本地存储
		saveParamsToStorage(paramsRef.value);
	} else {
		// 尝试从缓存恢复参数
		getParamsFromStorage();
	}

	if (!getToken()) {
		const login = useLogin();
		// 第三方平台自动登录
		// #ifdef MP
		login.getAuthCode({
			successCallback: () => {
				// 登录成功后检查参数并加载数据
				if (paramsRef.value.type && paramsRef.value.act_id) {
					loadData();
				}
			}
		});
		// #endif
		// #ifdef H5
		login.setLoginBack({ url: '/addon/tk_cps/pages/index' });
		return;
		// #endif
	} else {
		// 已登录，直接加载数据
		loadData();
	}
})
</script>
<style lang="scss" scoped></style>