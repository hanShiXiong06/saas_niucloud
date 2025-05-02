<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh] pt-[30rpx]">
		<block v-if="!loading">
			
			<view class="mx-[30rpx] rounded-[20rpx] bg-white overflow-hidden">
				<view class="question p-[45rpx] relative" v-if="questionDetail['type'] == 'fill'">
					<view class="bg-[var(--primary-color)] flex px-[20rpx] top-0 left-0 absolute text-[24rpx] leading-[50rpx] text-white text-center rounded-br-[20rpx]">{{questionDetail['type_name']}}</view>
					<view class="mt-[45rpx] text-[32rpx] leading-[45rpx] title">
						<rich-text :nodes="questionDetail['title']"></rich-text>
					</view>
					<view class="option-list mt-[45rpx]">
						<view class="mb-[30rpx]" v-for="(item,key) in questionDetail['fill_num']" :key="item">
							<u-input v-model="questionDetail['answer'][key]" clearable placeholder="请输入您的答案"></u-input>
						</view>
					</view>
				</view>
			    <view class="question p-[45rpx] relative" v-else>
			    	<view class="bg-[var(--primary-color)] flex px-[20rpx] top-0 left-0 absolute text-[24rpx] leading-[50rpx] text-white text-center rounded-br-[20rpx]">{{questionDetail['type_name']}}</view>
			    	<view class="mt-[45rpx] text-[32rpx] leading-[45rpx] title">
			    		<rich-text :nodes="questionDetail['title']"></rich-text>
			    	</view>
			    	
			    	<view class="option-list mt-[35rpx]">
			    		<view class="item px-[30rpx] py-[15rpx] text-[30rpx] leading-[45rpx] flex mt-[30rpx] relative" v-for="(item,index) in questionDetail['options_json']" :key="index" >
			    			<view class="mr-[20rpx] flex">{{item.id}}.</view>
							<view class="w-[490rpx]">
								<view v-if="item.title !=''">{{item.title}}</view>
								<view v-if="item.image !=''">
									<image :src="img(item.image)" mode="widthFix" class="max-w-[100%]" />
								</view>
								<view v-if="item.video !=''">
									<video :src="img(item.video)" class="max-w-[100%]"></video>
								</view>
							</view>
			    		</view>
			    	</view>
			    </view>
				
				<view class="mx-[45rpx] mb-[45rpx]">
					<u-divider class="m-0" text="正确答案" textColor="#000000"></u-divider>
					<view class="text-[#808080]">
						<text v-for="(item,index) in questionDetail.answer" :key="index">{{index<questionDetail.answer.length-1 ? item +'，' : item}} </text>
					</view>
					<u-divider class="m-0" text="答案解析" textColor="#000000"></u-divider>
					<view class="text-[#808080]">
						<rich-text :nodes="questionDetail.explain"></rich-text>
					</view>
				</view>
				
				<view v-if="questionDetail.note.note_id">
					<view class="mx-[45rpx]">
						<u-divider class="m-0" text="学习笔记" textColor="#000000"></u-divider>
					</view>
					<view class="mx-[45rpx] mb-[45rpx] bg-[var(--page-bg-color)] text-[#808080] rounded-[20rpx] p-[40rpx]">
						<view @click="noteShow = true">
							<view class="flex">
								<view>{{questionDetail.note.create_time}}</view>
								<view class="ml-auto"><text class="zzexam icon-biji"></text></view>
							</view>
							<view class="mt-[10rpx]">
								{{questionDetail.note.content}}
							</view>
						</view>
					</view>
				</view>
			</view>
			
			<view class="note-add text-center bg-[var(--primary-color)]" v-if="!questionDetail.note.note_id" @click="noteShow = true">
				<view class="mt-[20rpx] leading-[32rpx]">
					<text class="zzexam icon-biji text-[#ffffff] text-[42rpx]"></text>
				</view>
				<view class="text-[24rpx] mt-[5rpx] text-[#ffffff]">笔记</view>
			</view>
			
		</block>
		<u-loading-page :loading="loading" fontSize="16" color="#333"></u-loading-page>
		
		<!-- 添加笔记弹窗 -->
		<u-popup :show="noteShow" @close="noteShow = false" mode="bottom" :round="10" :closeable="true">
			
			<scroll-view scroll-y="true" class="bg-[var(--page-bg-color)]" >
				<view class="w-[500rpx] ml-[125rpx] mt-[60rpx]">
					<u-divider text="记笔记" textColor="#000000"></u-divider>
				</view>
				<view class="py-[10rpx] px-[30rpx] mt-[20rpx] mb-[30rpx] relative">
					<textarea class="bg-white rounded-[10rpx] p-[20rpx] w-[650rpx]" v-model="questionDetail.note.content" placeholder="请在此输入笔记内容" maxlength="500" />
					<view class="text-right text-[24rpx] text-[#888] absolute right-[40rpx] bottom-[40rpx]">
						 {{ questionDetail.note.content.length }}/500
					</view>
				</view>
				<view class="common-tab-bar-placeholder"></view>
				<view class="common-tab-bar fixed left-[var(--sidebar-m)] right-[var(--sidebar-m)] bottom-[0]">
					<button :loading="noteLoading" class="primary-btn-bg text-[#fff] h-[80rpx] leading-[80rpx] rounded-[100rpx] text-[26rpx] font-500" @click="saveNote">保存</button>
				</view>
			</scroll-view>
			
		</u-popup>
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, computed, nextTick } from 'vue'
	import { onLoad, onUnload } from '@dcloudio/uni-app'
	import { redirect, img, timeStampTurnTime} from '@/utils/common';
	import { getQuestonDetail, addNote, editNote } from '@/addon/zzexam/api/study';
	import { useLogin } from '@/hooks/useLogin'
	import useMemberStore from '@/stores/member'

	// 会员信息
	const memberStore = useMemberStore()
	const userInfo = computed(() => memberStore.info)
	
	let loading = ref<boolean>(true);
	let noteShow = ref<boolean>(false);
	let questionId = ref(0);
	let questionDetail = ref<Array<any>>([]);
	
	onLoad((option) => {
		questionId.value = option.id;
		getQuestonDetailFn();
	})
	
	//获取题目
	const getQuestonDetailFn = () => {
		loading.value = true;
		getQuestonDetail(questionId.value).then((res) => {
			loading.value = false;
			questionDetail.value = res.data;
		}).catch(() => {
			loading.value = false;
		});
	}
	
	//保存笔记
	const noteLoading = ref(false);
	const saveNote = () => {
		noteLoading.value = true;
		const save = questionDetail.value.note.note_id ? editNote : addNote
		save(questionDetail.value.note).then((res) => {
			noteShow.value = false;
			noteLoading.value = false;
			if(!questionDetail.value.note.note_id){
				questionDetail.value.note = res.data;
			}
		})
	}
	
</script>
<style>
	@import '@/addon/zzexam/styles/common.scss';
</style>
<style lang="scss" scoped>
	.option-list .item{
		border: solid 2rpx var(--page-bg-color);
	}
	
	.option-list .item.selected{
		border-color: var(--primary-color);
	}
	
	.title img{max-width: 100%;margin-top: 10rpx;}
</style>
