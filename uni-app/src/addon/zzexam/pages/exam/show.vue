<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh]">
		<block v-if="!loading">
			<view class="flex p-[30rpx] bg-white">
				<view>
					<view class="flex">
						<text>剩余：</text>
						<view class="time">{{time}}</view>
					</view>
				</view>
				<view class="ml-auto">
					<text class="font-bold">{{currentIndex+1}}</text>
					<text class="mx-[5rpx]">/</text>
					<text class="text-[var(--light-text-color)]">{{questionList.length}}</text>
				</view>
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
					
					<view class="flex flex-col justify-center items-center" @click="hand">
						<view class="zzexam icon-jiaojuan text-[40rpx]"></view>
						<text class="text-[24rpx] mt-[10rpx]">交卷</text>
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
		<u-loading-page :loading="loading || handDisabled" fontSize="16" color="#333"></u-loading-page>
		
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
	import { getExamShow, addExam } from '@/addon/zzexam/api/exam';
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
	let time = ref('');
	let timer = reactive(null);
	let transitionMode = ref('slide-right');
	let noteShow = ref<boolean>(false);
	
	onLoad((option) => {
		getExamShow(option.exam_id).then((res) => {
			loading.value = false;
			examDetail.value = res.data.exam_detail;
			questionList.value = res.data.question_list;
			timer = setInterval(()=>{
				countDown(examDetail.value.exam_endtime);
			},1000)
		}).catch(() => {
			uni.navigateBack({
			    delta: 1
			});
		});
	})
	
	onUnload(() => {
		clearInterval(timer);
	})
	
	//倒计时
	const countDown = (exam_endtime:number) => {
		if(intervalTime(exam_endtime) == '00:00:00'){
			clearInterval(timer)
			uni.showModal({
				title: '提示',
				content: '考试时间已到，请交卷。',
				showCancel: false,
				success: res => {
					confirmHand();
				}
			})
		}
		time.value = intervalTime(exam_endtime);
	}
	
	//交卷
	const hand = () => {
		let noAnswer = 0;
		questionList.value.forEach(item => {
			//去除填空题空答案
			if(item.type == 'fill'){
				item.answer.forEach((item1,index1)=>{
					if(item1 == ''){
						item.answer.splice(index1,1);
					}
				})
			}
			
			if(item.answer.length == 0){
				noAnswer++;
			}
		})
		
		uni.showModal({
			title:'提示',
			content: noAnswer > 0 ? ('您还有'+noAnswer+'道题未作答 ,确定要交卷吗？') : '确定要交卷吗？' ,
			success(e) {
				if(e.confirm){
					confirmHand();
				}
			}
		})
	}
	
	//确认交卷
	const handDisabled = ref(false);
	const confirmHand = () => {
		
		
		
		let answerList = [];
		questionList.value.forEach((item,index)=>{
			answerList.push({question_id:item.question_id,member_answer:item.answer,score:item.score,sort:item.sort})
		})
		
		handDisabled.value = true;
		
		let data = {
			exam_id:examDetail.value.exam_id,
			answer_list:answerList,
			exam_starttime:examDetail.value.exam_starttime,
		}
		addExam(data).then((res) => {
		    redirect({ url: '/addon/zzexam/pages/member/scores_detail?id='+res.data.id,mode:'redirectTo'})
		}).catch(() => {
		    handDisabled.value = false
		})
		
	}
	
	//选择答案
	const selectAnswer = (id:number,index:number) => {
		
		if(questionList.value[currentIndex.value]['type'] == 'multi'){
			questionList.value[currentIndex.value]['options'][index]['selected'] = !questionList.value[currentIndex.value]['options'][index]['selected'];
			let answer = questionList.value[currentIndex.value]['answer'];
			if(answer.length > 0){
				let flag = false;
				answer.forEach((item,index1)=>{
					if(item == id){
						answer.splice(index1,1);
						flag = true;
					}
				})
				if(!flag){
					answer.push(id);
				}
			}else{
				answer.push(id);
			}
			answer.sort();
			
			questionList.value[currentIndex.value]['answer'] = answer;
		}
		
		if(questionList.value[currentIndex.value]['type'] == 'single' || questionList.value[currentIndex.value]['type'] == 'judge'){
			questionList.value[currentIndex.value]['answer'] = [id];
			questionList.value[currentIndex.value]['options'].forEach((item,index1)=>{
				if(index == index1){
					item['selected'] = 1;
				}else{
					item['selected'] = 0;
				}
			})
		}
		
	}
	
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
		
		//去除填空题空答案
		questionList.value.forEach((item,index)=>{
			if(item.type == 'fill'){
				item.answer.forEach((item1,index1)=>{
					if(item1 == ''){
						item.answer.splice(index1,1);
					}
				})
			}
		})
		
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
