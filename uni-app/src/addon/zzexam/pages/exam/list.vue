<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh]">
		<mescroll-body ref="mescrollRef" top="30rpx" @init="mescrollInit" @down="downCallback" @up="getExamListFn">
			<view class="list">
				<view v-for="(item,index) in examList" :key="index" class="flex align-center p-[30rpx] bg-white rounded-[24rpx] mx-[30rpx] mb-[30rpx] relative" @click="toExam(item.exam_id)">
					<view class="rounded-[10rpx] overflow-hidden">
						<u--image width="255rpx" height="180rpx" :src="img(item.cover)" model="aspectFill">
							<template #error>
								<u-icon name="photo" color="#f7f7f7" size="50"></u-icon>
							</template>
						</u--image>
						
						<view class="absolute left-0 top-[0rpx] px-[20rpx] h-[40rpx] leading-[40rpx] rounded-br-[24rpx] text-[#ffffff] bg-[var(--main1-text-color)] text-center text-[24rpx] rounded-tl-[24rpx]">{{item.mode_arr.name}}</view>
						
					</view>
					
					<view class="flex-1 flex flex-col justify-between ml-[10px]">
						<view class="text-[30rpx] leading-[1.3] using-hidden mt-[2px]">{{item.title}}</view>
						<view class="text-[26rpx] mt-[20rpx]">
							<text class="text-[var(--light-text-color)]">{{item.subject.full_name}}</text>
						</view>
						<view class="flex text-[26rpx] mt-[25rpx] leading-[56rpx]">
							<view class="text-[var(--light-text-color)]"><text class="text-[var(--primary-color)]">{{item.exam_num}}</text>次考试</view>
							
							<view class="ml-auto text-[#fff] text-[26rpx] w-[156rpx] h-[50rpx] leading-[50rpx] rounded-[25rpx] bg-[var(--primary-color)] text-center">进入考试</view>
							
						</view>
					</view>
				</view>
			</view>
			
			<view class="mx-[30rpx]" v-if="!examList.length && loading">
				<mescroll-empty class="mt-0" :option="{tip : '暂无考试'}"></mescroll-empty>
			</view>
		</mescroll-body>
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad, onShow } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { getSubjectDetail,getExamList } from '@/addon/zzexam/api/exam';
	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
	import { onPageScroll, onReachBottom } from '@dcloudio/uni-app';
    const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);

	const examList = ref<Array<any>>([]);
	const subjectList = ref<Array<any>>([]);
	const subjectId = ref(0);
	const subjectDetail = ref(0);
	const mescrollRef = ref(null);
	const loading = ref(false);
	
	onLoad((option) => {
		if(option.subject_id){
			subjectId.value = option.subject_id;
		}
		getSubjectDetailFn();
	})
	
	const getSubjectDetailFn = () => {
		getSubjectDetail(subjectId.value).then((res) => {
			subjectDetail.value = res.data;
			uni.setNavigationBarTitle({
				title: subjectDetail.value.name
			})
		});
	}

	interface mescrollStructure {
		num : number,
		size : number,
		endSuccess : Function,
		[propName : string] : any
	}
	
	const getExamListFn = (mescroll : mescrollStructure) => {
		loading.value = false;
		let data : object = {
			page: mescroll.num,
			limit: mescroll.size,
			subject_id: subjectId.value
		};

		getExamList(data).then((res) => {
			let newArr = (res.data.data as Array<Object>);
			//设置列表数据
			if (mescroll.num == 1) {
				examList.value = []; //如果是第一页需手动制空列表
			}
			examList.value = examList.value.concat(newArr);
			mescroll.endSuccess(newArr.length);
			loading.value = true;
		}).catch(() => {
			loading.value = true;
			mescroll.endErr(); // 请求失败, 结束加载
		})
	}

	onMounted(() => {
		setTimeout(() => {
			getMescroll().optUp.textNoMore = t("end");
		}, 500)
	});
	
	const toExam = (exam_id: number) => {
		redirect({ url: '/addon/zzexam/pages/exam/detail', param: { exam_id } })
	}
</script>

<style >
	@import '@/addon/zzexam/styles/common.scss';
</style>