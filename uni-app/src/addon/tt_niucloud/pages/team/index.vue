<template>
	<view class="min-h-[100vh] w-full !bg-[#F6F6F6]" v-if="!loading">
		<up-cell :title="'我的团队('+list.total+')'"></up-cell>
		<view class="px-[30rpx] pt-[20rpx] body-bottom" v-if="list.total">
			<view  v-for="(item,index) in list.data" :key="index" class="w-full h-[120rpx] flex justify-between items-center bg-[#fff] box-border p-[20rpx] rounded-[16rpx]" :class="{'mt-[20rpx]':index}">
				<view class="flex items-center">
					<u-avatar :src="img(item.headimg)" size="55" leftIcon="none"></u-avatar>
					<view class="flex flex-col ml-[20rpx]">
						<view class="text-[#000] text-[26rpx] leading-[36rpx]">{{item.nickname}}</view>
						<view class="text-[#999] text-[24rpx] leading-[34rpx] mt-[4rpx] font-400">{{item.create_time}}</view>
					</view>
				</view>
				<view class="text-right">
					<view class="text-[36rpx] leading-[50rpx]"></view>
					<view class="text-[#999] text-[24rpx] leading-[34rpx] mt-[4rpx] font-400">
						<text class="mr-[15rpx]"></text>
						<text></text>
					</view>
				</view>
			</view>
		</view>
		<u-loadmore :status="status" />
	</view>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue';
import { t } from '@/locale';
import { img } from '@/utils/common';
import { getTeamMember } from '@/addon/tt_niucloud/api/member';
import { onLoad, onReachBottom } from '@dcloudio/uni-app';

const loading = ref(true)
const list = ref([]);
const status = ref('nomore')

onLoad(() => {
    getTeamMember().then((res) => {
		loading.value = false;
		list.value = res.data
    });
})

onReachBottom(() => {
    // loading
	status.value = 'loading'
	if (list.value.current_page == list.value.last_page) {
		status.value = 'nomore'
		return false
	}
	
	let data : object = {
		page: list.value.current_page+1,
	};
	getTeamMember(data).then((res) => {
		const newArr = (res.data.data as Array<Object>);
		list.value.current_page = res.data.current_page
		list.value.data = list.value.data.concat(newArr);
		if (res.data.current_page == res.data.last_page) {
			status.value = 'nomore'
		}
	}).catch(() => {
	});
	
})

</script>

<style lang="scss">
</style>