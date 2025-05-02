<template>
    <u-popup :show="show" @close="show = false" mode="bottom" :round="10" :closeable="true">
        <view class="text-center p-[30rpx] font-500">答题卡</view>
        <scroll-view class="h-[50vh]">
            <view class="flex text-center pl-[30rpx] pt-[10rpx] flex-wrap">
				<view class="text-[32rpx] ml-[30rpx] w-[80rpx] h-[80rpx] rounded-[10rpx] mb-[30rpx] relative bg-[var(--page-bg-color)]" :class="[Object.keys(item.answer).length > 0 ? 'bg-[var(--primary-color)] text-[#ffffff]' : '']" v-for="(item,index) in questionList" :key="index" @click="confirm(index)">
					<view class="leading-[32rpx] mt-[8rpx]">{{index+1}}</view> 
					<view class="text-[20rpx] mt-[7rpx]">{{item.type_name}}</view>
					<view v-if="currentIndex == index" class="bg-red absolute w-[14rpx] h-[14rpx] rounded-[7rpx] top-[5rpx] right-[5rpx]"></view>
				</view>
			</view>
        </scroll-view>
    </u-popup>
</template>

<script setup lang="ts">
    import { ref, computed } from 'vue'

    const show = ref(false)
	const questionList = ref<Array<any>>([]);
	const currentIndex = ref(0);
	
    
    const open = (ql:any,index:number) => {
        show.value = true
		questionList.value = ql
		currentIndex.value = index;
    }
	
	const close = () => {
		show.value = false
	}

    const emits = defineEmits(['confirm'])

    const confirm = (index: number) => {
        emits('confirm', index)
    }

    defineExpose({
        open,
		close
    })
</script>

<style>
	@import '@/addon/zzexam/styles/common.scss';
</style>
