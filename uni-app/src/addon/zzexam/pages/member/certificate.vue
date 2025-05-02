<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh]">
		<view class="fixed left-0 top-0 right-0 z-10">
			<scroll-view scroll-x="true" class="scroll-Y box-border px-[30rpx] bg-white">
				<view class="flex whitespace-nowrap">
					<view :class="['text-sm leading-[90rpx] mr-[40rpx]', { 'class-select': oneSubject.subject_id == 0 }]" @click="subjectChangeFn({subject_id:0},1)">全部科目</view>
					<view :class="['text-sm leading-[90rpx] mr-[40rpx]', { 'class-select': oneSubject.subject_id == item.subject_id }]" v-for="(item, index) in subjectList" @click="subjectChangeFn(item,1)" :key="index">{{ item.name }}</view>
				</view>
			</scroll-view>
		</view>
		
		<mescroll-body ref="mescrollRef" top="120rpx" @init="mescrollInit" @down="downCallback" @up="getCertificateListFn">
			<view class="px-[30rpx] flex flex-wrap pb-[10rpx]" v-if="oneSubject.subject_id > 0 && oneSubject.child_list.length>0">
				<view v-for="(item, index) in oneSubject.child_list" @click="subjectChangeFn(item,2)" :class="['bg-white text-sm leading-[60rpx] mr-[20rpx] rounded-[30rpx] mb-[20rpx] text-[26rpx] px-[30rpx]', { 'text-[var(--primary-color)]': subjectId == item.subject_id }]" :key="index">{{ item.name }}</view>
			</view>
			<view class="list">
				<view v-for="(item,index) in certificateList" :key="index" class="align-center p-[30rpx] bg-white rounded-[10rpx] mx-[30rpx] mb-[30rpx]">
					<view class="font-bold">{{item.poster.name}}</view>
					
					<view class="flex text-[var(--light-text-color)]">
						<view>
							<view class="mt-[15rpx] text-[28rpx]">获得时间：{{item.create_time}}</view>
						</view>
						<view class="ml-auto relative w-[200rpx]">
							<view class="absolute bottom-0 right-0 text-[24rpx]">
								<view class="bg-[var(--main1-text-color)] py-[12rpx] text-white rounded-[10rpx] px-[25rpx]" @tap="toScores(item.scores_id)">查看成绩</view>
								<view class="bg-[var(--main1-text-color)] py-[12rpx] text-white rounded-[10rpx] mt-[15rpx] px-[25rpx]" @tap="openShareFn(item.template_id)">保存证书</view>
							</view>
							
						</view>
					</view>
				</view>
			</view>
			<view class="mx-[30rpx]">
				<mescroll-empty class="mt-0" :option="{tip : '您暂未获得证书'}" v-if="!certificateList.length && loading"></mescroll-empty>
			</view>
			
		</mescroll-body>
		
		<share-poster ref="sharePosterRef" posterType="zzexam_certificate" :posterParam="posterParam" :copyUrl="copyUrl" :posterId="posterId"/>
		
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, onMounted, computed } from 'vue'
	import { onLoad, onShow } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { getSubjectTree,getCertificateList } from '@/addon/zzexam/api/exam';
	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
	import { onPageScroll, onReachBottom } from '@dcloudio/uni-app';
	import useMemberStore from '@/stores/member'
	
	
    const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);

	const certificateList = ref<Array<any>>([]);
	const subjectList = ref<Array<any>>([]);
	const subjectId = ref(0);
	const oneSubject = ref({subject_id:0});
	const mescrollRef = ref(null);
	const loading = ref(false);
	const posterId = ref(0);
	const posterParam = ref({member_id:0});
	
	// 会员信息
	const memberStore = useMemberStore()
	const userInfo = computed(() => memberStore.info)
	
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
	
	const getCertificateListFn = (mescroll : mescrollStructure) => {
		loading.value = false;
		let data : object = {
			page: mescroll.num,
			limit: mescroll.size,
			subject_id: subjectId.value
		};

		getCertificateList(data).then((res) => {
			let newArr = (res.data.data as Array<Object>);
			//设置列表数据
			if (mescroll.num == 1) {
				certificateList.value = []; //如果是第一页需手动制空列表
			}
			certificateList.value = certificateList.value.concat(newArr);
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
		certificateList.value = [];
		getMescroll().resetUpScroll();
	};

	onMounted(() => {
		setTimeout(() => {
			getMescroll().optUp.textNoMore = t("end");
		}, 500)
	});
	
	const toScores = (id: number) => {
		redirect({ url: '/addon/zzexam/pages/member/scores_detail', param: { id } })
	}
	
	const sharePosterRef: any = ref(null);
	const openShareFn = (id: any)=>{
		posterId.value = id
		posterParam.value.member_id = userInfo.value.member_id
		setTimeout(() => {
			sharePosterRef.value.openShare()
		}, 500)
	}
	
	const copyUrl = ref('/addon/zzexam/pages/index');
	
</script>

<style >
	@import '@/addon/zzexam/styles/common.scss';
</style>