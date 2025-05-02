<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh]">
		<view class="fixed left-0 top-0 right-0 z-10">
			<scroll-view scroll-x="true" class="scroll-Y box-border px-[24rpx] bg-white">
				<view class="flex whitespace-nowrap">
					<view :class="['text-sm leading-[90rpx] mr-[40rpx]', { 'class-select': oneSubject.subject_id == 0 }]" @click="subjectChangeFn({subject_id:0},1)">全部科目</view>
					<view :class="['text-sm leading-[90rpx] mr-[40rpx]', { 'class-select': oneSubject.subject_id == item.subject_id }]" v-for="(item, index) in subjectList" @click="subjectChangeFn(item,1)" :key="index">{{ item.name }}</view>
				</view>
			</scroll-view>
		</view>
		
		<mescroll-body ref="mescrollRef" top="120rpx" @init="mescrollInit" @down="downCallback" @up="getScoresListFn">
			<view class="px-[30rpx] flex flex-wrap pb-[10rpx]" v-if="oneSubject.subject_id > 0 && oneSubject.child_list.length>0">
				<view v-for="(item, index) in oneSubject.child_list" @click="subjectChangeFn(item,2)" :class="['bg-white text-sm leading-[60rpx] mr-[20rpx] rounded-[30rpx] mb-[20rpx] text-[26rpx] px-[30rpx]', { 'text-[var(--primary-color)]': subjectId == item.subject_id }]" :key="index">{{ item.name }}</view>
			</view>
			<view class="list">
				<view v-for="(item,index) in scoresList" :key="index" class="relative p-[30rpx] bg-white rounded-[10rpx] mx-[30rpx] mb-[30rpx]">
					<view class="font-bold text-[30rpx]">{{item.exam_title}}</view>
					
					<view class="flex text-[var(--light-text-color)] text-[28rpx]">
						<view>
							<view class="mt-[30rpx]">交卷时间：{{item.create_time}}</view>
							<view class="mt-[20rpx]">考试用时：{{item.use_time}}</view>
							<view class="mt-[20rpx]">试卷总分：{{item.total_score}}</view>
							<view class="mt-[20rpx]">您的分数:<text class="font-bold text-[var(--price-text-color)]">{{item.exam_score}}</text>分<text class="text-[var(--price-text-color)]">（ {{item.is_pass == 1 ? '及格' : '不及格!'}}）</text></view>
						</view>
						<view class="ml-auto relative w-[200rpx]">
							<view class="absolute bottom-0 right-0 text-[24rpx] ">
								<view class="bg-[var(--main1-text-color)] text-white py-[12rpx] rounded-[10rpx] px-[25rpx]" @tap="toCert()" v-if="item.is_cert">查看证书</view>
								<view class="bg-[var(--main1-text-color)] text-white py-[12rpx] rounded-[10rpx] mt-[12rpx] px-[25rpx]" @tap="toDetail(item.scores_id)">查看结果</view>
								<view class="bg-[var(--main1-text-color)] text-white py-[12rpx] rounded-[10rpx] mt-[12rpx] px-[25rpx]" @tap="toExplain(item.scores_id)">查看试卷</view>
							</view>
							
						</view>
					</view>
					
				</view>
			</view>
			<view class="mx-[30rpx]" v-if="!scoresList.length && loading">
				<mescroll-empty class="mt-0" :option="{tip : '暂无成绩'}"></mescroll-empty>
			</view>
			
		</mescroll-body>
		
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad, onShow } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { getSubjectTree,getScoresList } from '@/addon/zzexam/api/exam';
	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
	import { onPageScroll, onReachBottom } from '@dcloudio/uni-app';
    const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);

	const scoresList = ref<Array<any>>([]);
	const subjectList = ref<Array<any>>([]);
	const subjectId = ref(0);
	const oneSubject = ref({subject_id:0});
	const mescrollRef = ref(null);
	const loading = ref(false);
	
	onLoad(() => {
		getSubjectTreeFn();
	})
	
	const getSubjectTreeFn = () => {
		getSubjectTree().then((res) => {
			subjectList.value = res.data;
		});
	}

	interface mescrollStructure {
		num : number,
		size : number,
		endSuccess : Function,
		[propName : string] : any
	}
	
	const getScoresListFn = (mescroll : mescrollStructure) => {
		loading.value = false;
		let data : object = {
			page: mescroll.num,
			limit: mescroll.size,
			subject_id: subjectId.value
		};

		getScoresList(data).then((res) => {
			let newArr = (res.data.data as Array<Object>);
			//设置列表数据
			if (mescroll.num == 1) {
				scoresList.value = []; //如果是第一页需手动制空列表
			}
			scoresList.value = scoresList.value.concat(newArr);
			mescroll.endSuccess(newArr.length);
			loading.value = true;
		}).catch(() => {
			loading.value = true;
			mescroll.endErr(); // 请求失败, 结束加载
		})
	}
	
	const subjectChangeFn = (subject: any,level: number) => {
		if(level == 1){
			oneSubject.value = subject
		}
		subjectId.value = subject.subject_id;
		scoresList.value = [];
		getMescroll().resetUpScroll();
	};
	
	const toDetail = (id: number) => {
		redirect({ url: '/addon/zzexam/pages/member/scores_detail', param: { id } })
	}
	
	const toExplain = (scores_id: number) => {
		redirect({ url: '/addon/zzexam/pages/exam/explain', param: { scores_id } })
	}
	
	const toCert = () => {
		redirect({ url: '/addon/zzexam/pages/member/certificate'})
	}

	onMounted(() => {
		setTimeout(() => {
			getMescroll().optUp.textNoMore = t("end");
		}, 500)
	});
	
</script>

<style >
	@import '@/addon/zzexam/styles/common.scss';
</style>