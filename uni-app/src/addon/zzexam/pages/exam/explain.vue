<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh]">
		<block v-if="!loading">
			<view class="flex p-[30rpx] bg-white">
				<view>
					<text class="font-bold">{{currentIndex+1}}</text>
					<text class="mx-[5rpx]">/</text>
					<text class="text-[var(--light-text-color)]">{{questionList.length}}</text>
				</view>
				<view class="bg-[var(--primary-color)] ml-auto px-[40rpx] text-center text-white rounded-[12rpx] h-[62rpx] leading-[62rpx]" @tap="toExam()">再考一次</view>
			</view>
			
			<up-transition :show="transitionShow" :mode="transitionMode">
				<view class="m-[30rpx] rounded-[20rpx] bg-white overflow-hidden">
					<view class="question p-[45rpx] relative" v-if="questionList[currentIndex]['type'] == 'fill'">
						<view class="bg-[var(--primary-color)] flex px-[20rpx] top-0 left-0 absolute text-[24rpx] leading-[50rpx] text-white text-center rounded-br-[20rpx]">{{questionList[currentIndex]['type_name']}} ({{questionList[currentIndex]['score']}}分)</view>
						<view class="mt-[45rpx] text-[32rpx] leading-[45rpx] title">
							<rich-text :nodes="questionList[currentIndex]['title']"></rich-text>
						</view>
						<view class="option-list mt-[45rpx]">
							<view class="mb-[30rpx]" v-for="(item,key) in questionList[currentIndex]['fill_num']" :key="item">
								<u-input v-model="questionList[currentIndex]['answer'][key]" clearable placeholder="请输入您的答案"></u-input>
							</view>
						</view>
					</view>
					<view class="question p-[45rpx] relative" v-else>
						<view class="bg-[var(--primary-color)] flex px-[20rpx] top-0 left-0 absolute text-[24rpx] leading-[50rpx] text-white text-center rounded-br-[20rpx]">{{questionList[currentIndex]['type_name']}} ({{questionList[currentIndex]['score']}}分)</view>
						<view class="mt-[45rpx] text-[32rpx] leading-[45rpx] title">
							<rich-text :nodes="questionList[currentIndex]['title']"></rich-text>
						</view>
						
						<view class="option-list mt-[35rpx]">
							<view class="item px-[30rpx] py-[15rpx] text-[30rpx] leading-[45rpx] flex mt-[30rpx] relative" v-for="(item,index) in questionList[currentIndex]['options']" :key="index" @tap="selectAnswer(item.id,index)" :class="[item.selected ? 'selected' : '']">
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
						<u-divider class="m-0" text="我的答案" textColor="#000000"></u-divider>
						<view class="text-[var(--price-text-color)]">
							<text v-if="Object.keys(questionList[currentIndex].answer).length == 0">未作答</text>
							<text v-for="(item,index) in questionList[currentIndex].answer" :key="index">{{index < Object.keys(questionList[currentIndex].answer).length-1 ? item +'，' : item}} </text>
						</view>
						<u-divider class="m-0" text="正确答案" textColor="#000000"></u-divider>
						<view class="text-[var(--price-text-color)]">
							<text v-for="(item,index) in questionList[currentIndex].c_answer" :key="index">{{index < Object.keys(questionList[currentIndex].c_answer).length-1 ? item +'，' : item}} </text>
						</view>
						<u-divider class="m-0" text="答案解析" textColor="#000000"></u-divider>
						<view class="text-[#808080] leading-[45rpx] text-[30rpx]">
							<rich-text :nodes="questionList[currentIndex].explain"></rich-text>
						</view>
					</view>
					
					<view v-if="questionList[currentIndex].note.note_id != ''">
						<view class="mx-[45rpx]">
							<u-divider class="m-0" text="学习笔记" textColor="#000000"></u-divider>
						</view>
						<view class="mx-[45rpx] mb-[45rpx] bg-[var(--page-bg-color)] rounded-[20rpx] p-[40rpx]">
							<view @click="noteShow = true">
								<view class="text-gray-400 flex">
									<view>{{questionList[currentIndex].note.create_time}}</view>
									<view class="ml-auto"><text class="zzexam icon-biji"></text></view>
								</view>
								<view class="mt-[10rpx]">
									{{questionList[currentIndex].note.content}}
								</view>
							</view>
						</view>
					</view>
				</view>
			</up-transition>
			
			<view class="tab-bar-placeholder"></view>
			<view class="border-[0] border-t-[2rpx] border-solid border-[#f5f5f5] w-[100%] px-[60rpx] bg-[#fff] box-border fixed left-0 bottom-0 tab-bar z-1 items-center pt-[16rpx]">
				<view class="flex justify-between">
					<view class="flex flex-col justify-center items-center" :class="[currentIndex == 0 ? 'text-[var(--light-text-color)]' : '']" @click="changeQuesion('up')">
						<view class="zzexam icon-shangyiti text-[40rpx]"></view>
						<text class="text-[24rpx] mt-[10rpx]">上一题</text>
					</view>
					
					<view class="flex flex-col justify-center items-center" @click="openAnswerSheetFn">
						<view class="zzexam icon-datiqia text-[40rpx]"></view>
						<text class="text-[24rpx] mt-[10rpx]">答题卡</text>
					</view>
					
					<view class="flex flex-col justify-center items-center" :class="[currentIndex == questionList.length - 1 ? 'text-[var(--light-text-color)]' : '']" @click="changeQuesion('down')">
						<text class="zzexam icon-xiayiti text-[40rpx]"></text>
						<text class="text-[24rpx] mt-[10rpx]">下一题</text>
					</view>
				</view>
				
			</view>
			
			<view class="note-add text-center bg-[var(--primary-color)]" v-if="questionList[currentIndex].note.note_id == ''" @click="noteShow = true">
				<view class="mt-[20rpx] leading-[32rpx]">
					<text class="zzexam icon-biji text-[#ffffff] text-[42rpx]"></text>
				</view>
				<view class="text-[24rpx] mt-[5rpx] text-[#ffffff]">笔记</view>
			</view>
			
			
			
		</block>
		<u-loading-page :loading="loading" fontSize="16" color="#333"></u-loading-page>
		
		<!-- 答题卡弹窗 -->
		<answer-sheet-popup ref="answerSheetRef" @confirm="confirmAnswerSheet" />
		
		<!-- 添加笔记弹窗 -->
		<u-popup :show="noteShow" @close="noteShow = false" mode="bottom" :round="10" :closeable="true">
			
			<scroll-view scroll-y="true" class="bg-[var(--page-bg-color)]" >
				<view class="w-[500rpx] ml-[125rpx] mt-[60rpx]">
					<u-divider text="记笔记" textColor="#000000"></u-divider>
				</view>
				<view class="py-[10rpx] px-[30rpx] mt-[20rpx] mb-[30rpx] relative">
					<textarea class="bg-white rounded-[10rpx] p-[20rpx] w-[650rpx]" v-model="questionList[currentIndex].note.content" placeholder="请在此输入笔记内容" maxlength="500" />
					<view class="text-right text-[24rpx] text-[#888] absolute right-[40rpx] bottom-[40rpx]">
						 {{ questionList[currentIndex].note.content.length }}/500
					</view>
				</view>
				<view class="common-tab-bar-placeholder"></view>
				<view class="common-tab-bar fixed left-[var(--sidebar-m)] right-[var(--sidebar-m)] bottom-[0]">
					<button :loading="loading" class="primary-btn-bg text-[#fff] h-[80rpx] leading-[80rpx] rounded-[100rpx] text-[26rpx] font-500" @click="saveNote">保存</button>
				</view>
			</scroll-view>
			
		</u-popup>
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, computed, nextTick } from 'vue'
	import { onLoad, onUnload } from '@dcloudio/uni-app'
	import { redirect, img, timeStampTurnTime} from '@/utils/common';
	import { getExamExplain } from '@/addon/zzexam/api/exam';
	import { addNote,editNote } from '@/addon/zzexam/api/study'
	import { useLogin } from '@/hooks/useLogin'
	import useMemberStore from '@/stores/member'
	import { intervalTime } from '@/addon/zzexam/utils/common'
	import answerSheetPopup from './components/answer-sheet-popup.vue'
	

	// 会员信息
	const memberStore = useMemberStore()
	const userInfo = computed(() => memberStore.info)
	
	let examDetail = ref<Array<any>>([]);
	let questionList = ref<Array<any>>([]);
	let currentIndex = ref(0);
	let loading = ref<boolean>(true);
	let transitionShow = ref(true);
	let transitionMode = ref('slide-right');
	let noteShow = ref<boolean>(false);
	
	onLoad((option) => {
		getExamExplain(option.scores_id).then((res) => {
			loading.value = false;
			questionList.value = res.data.question_list;
			examDetail.value = res.data.exam_info;
		}).catch(() => {
			uni.navigateBack({
			    delta: 1
			});
		});
	})
	
	// 答题卡弹窗
	const answerSheetRef = ref();
	const confirmAnswerSheet = (data : any) => {
		let oldIndex = currentIndex.value;
		currentIndex.value = data;
		answerSheetRef.value.close();
		
		if(oldIndex == data){
			return false;
		}
		
		transitionShow.value = false;
		transitionMode.value = oldIndex > data ? 'fade-right' : 'fade-left';
		setTimeout(()=>{
			transitionMode.value = oldIndex > data ? 'fade-left' : 'fade-right';
			transitionShow.value = true;
		},500)
		
	}
	
	//打开答题卡弹窗
	const openAnswerSheetFn = () => {
		answerSheetRef.value.open(questionList.value,currentIndex.value);
	}
	
	//题目切换
	const changeQuesion = (type: string) => {
		
		if(type == 'up'){
			if(currentIndex.value > 0){
				currentIndex.value -- ;
				transitionShow.value = false;
				transitionMode.value = 'fade-right';
				setTimeout(()=>{
					transitionMode.value = 'fade-left';
					transitionShow.value = true;
				},500)
			}else{
				uni.showToast({title:'当前为第一题',icon:'none'});
			}
			
		}
		
		if(type == 'down'){
			if(currentIndex.value < questionList.value.length - 1){
				currentIndex.value ++ ;
				transitionShow.value = false;
				transitionMode.value = 'fade-left';
				setTimeout(()=>{
					transitionMode.value = 'fade-right';
					transitionShow.value = true;
				},500)
			}else{
				uni.showToast({title:'当前为最后一题',icon:'none'});
			}
		}
	}
	
	//保存笔记
	const saveNote = () => {
		const save = questionList.value[currentIndex.value].note.note_id ? editNote : addNote
		save(questionList.value[currentIndex.value].note).then((res) => {
			noteShow.value = false;
			if(questionList.value[currentIndex.value].note.note_id == ''){
				questionList.value[currentIndex.value].note = res.data;
			}
		})
	}
	
	const toExam = () => {
		redirect({ url: '/addon/zzexam/pages/exam/show', param: { exam_id: examDetail.value.exam_id } })
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
