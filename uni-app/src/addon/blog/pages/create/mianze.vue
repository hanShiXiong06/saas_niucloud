<template>
	<view class="p-[20rpx]">
		<up-parse :content="config.mianze"></up-parse>
		
		
		<up-button type="primary" @click="zhixiao" style="margin:50rpx 0 20rpx">我已知晓</up-button>
	</view>

</template>



<script setup lang="ts">
	import {
		reactive,
		ref,
		onMounted
	} from 'vue'
	import {
		onLoad
	} from '@dcloudio/uni-app'
	import {
		t
	} from '@/locale'
	import {
		redirect,
		img
	} from '@/utils/common';
	import {
		onPageScroll,
		onReachBottom
	} from '@dcloudio/uni-app'
	import {
		useShare
	} from '@/hooks/useShare'
	
		import { getConfigApi } from '@/addon/blog/api/tie'

	const config = ref([]);
	getConfigApi({}).then(res => {
		config.value = res.data;

	})
	
	const zhixiao = (n) => {
		uni.navigateBack({
				delta:1,
				success: () => {
					uni.$emit('tongyi_mianze',true)
				}
			})
	};
	
</script>