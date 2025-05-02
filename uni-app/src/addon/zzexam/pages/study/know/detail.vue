<template>
	<view :style="themeColor()" class="bg-white">
		<block v-if="!loading">
			<view class="border-solid border-t-0 border-l-0 border-r-0 border-b-[1px] border-gray-100 p-[30rpx]">
				<view class="text-[32rpx]">
					{{articleDetail.title}}
				</view>
				<view class="flex align-center justify-between text-[26rpx] text-gray-400 mt-[30rpx]">
					<text>{{articleDetail.create_time}}</text>
					<text>{{articleDetail.category_id_name}}</text>
					<text>浏览 {{articleDetail.total_views}}</text>
				</view>
			</view>
			<view class="px-[30rpx] py-[30rpx]">
				<u-parse :content="articleDetail.content" :tagStyle="style"></u-parse>
			</view>
		</block>
		<u-loading-page :loading="loading" fontSize="16" color="#333"></u-loading-page>
		
		<view class="note-add text-center bg-[var(--primary-color)]" @click="noteShow = true">
			<view class="mt-[20rpx] leading-[32rpx]">
				<text class="zzexam icon-biji text-[#ffffff] text-[42rpx]"></text>
			</view>
			<view class="text-[24rpx] mt-[5rpx] text-[#ffffff]">笔记</view>
		</view>
		
		<!-- 笔记弹窗 -->
		<u-popup :show="noteShow" @close="noteShow = false" mode="bottom" :round="10" :closeable="true">
			
			<view class="w-[500rpx] ml-[125rpx] mt-[60rpx]">
				<u-divider text="学习笔记" textColor="#000000"></u-divider>
			</view>
			
			<view class="m-[30rpx] bg-[var(--page-bg-color)] rounded-[20rpx] p-[40rpx]">
				<view v-if="articleDetail.note" @click="toAddNote">
					<view class="text-gray-400 flex">
						<view>{{articleDetail.note.create_time}}</view>
						<view class="ml-auto"><text class="zzexam icon-biji"></text></view>
					</view>
					<view class="mt-[10rpx]">
						{{articleDetail.note.content}}
					</view>
				</view>
				<view v-else>
					<view class="text-gray-400 text-center">还没有记录笔记</view>
					<button class="primary-btn-bg text-[#fff] h-[60rpx] leading-[60rpx] w-[300rpx] mt-[30rpx] rounded-[30rpx] text-[26rpx] font-500" @click="toAddNote">记笔记</button>
				</view>
			</view>
			
		</u-popup>
		
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, computed } from 'vue'
	import { onLoad } from '@dcloudio/uni-app'
	import { redirect, img } from '@/utils/common';
	import { t } from '@/locale'
	import { getArticleDetail } from '@/addon/zzexam/api/study';
	import { useShare } from '@/hooks/useShare'
	import useMemberStore from '@/stores/member'

	const { setShare, onShareAppMessage, onShareTimeline } = useShare()
	onShareAppMessage()
	onShareTimeline()
	
	// 会员信息
	const memberStore = useMemberStore()
	const userInfo = computed(() => memberStore.info)

	let articleDetail = ref<Array<any>>([]);
	let loading = ref<boolean>(true);
	let noteShow = ref<boolean>(false);
	let style = {
		h2: 'margin-bottom: 20rpx;',
		p: 'margin-bottom: 10rpx;line-height: 1.5;',
		img: 'margin: 20rpx 0;',
	};
	onLoad((option) => {
		loading.value = true;
		getArticleDetail(option.id).then((res) => {
			articleDetail.value = res.data;
			loading.value = false;
			let share = {
				title: articleDetail.value.title,
				desc: articleDetail.value.title,
				url: articleDetail.value.image
			}
            uni.setNavigationBarTitle({
                title: articleDetail.value.title
            })
			setShare({
				wechat: {
					...share
				},
				weapp: {
					...share
				}
			});
		});
	})
	
	//记录笔记
	const toAddNote = () => {
		// 检测是否登录
		if (!userInfo.value) {
			useLogin().setLoginBack({
				url: '/addon/zzexam/pages/study/know/detail',
				param: {
					id: articleDetail.value.article_id,
				}
			})
			return false
		}
		redirect({ url: '/addon/zzexam/pages/study/note/add', param: {note_id:articleDetail.value.note == null ? 0 : articleDetail.value.note.note_id,type:articleDetail.value.type,target_id:articleDetail.value.article_id } })
	}
</script>
<style>
	@import '@/addon/zzexam/styles/common.scss';
	
	
</style>