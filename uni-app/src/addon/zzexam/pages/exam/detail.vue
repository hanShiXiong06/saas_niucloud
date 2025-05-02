<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh]">
		<block v-if="!loading">
			<view class="photo flex relative">
				<image :src="img(examDetail.cover)" class="w-[750rpx] h-[530rpx]" />
			</view>
			
			<view class="info p-[30rpx] bg-white text-[30rpx]">
				<view class="font-bold mb-[10rpx]">{{examDetail.title}}</view>
				
				<view class="leading-[60rpx]">已考试{{examDetail.exam_num}}次 <text class="mx-[10rpx]">|</text> {{examDetail.exam_people}}名考生 <text class="mx-[10rpx]">|</text> 浏览{{examDetail.views}}次</view>
				
				<view class="leading-[60rpx] flex justify-between">
					<view>共{{examDetail.paper.question_num}}题</view>
					<view>总分{{examDetail.paper.total_score}} </view>
					<view>限时{{examDetail.answertime}}分钟</view>
					<view>{{examDetail.paper.pass_score}}分及格</view>
				</view>
				<view class="leading-[50rpx]">考试科目：{{examDetail.subject.full_name}}</view>
				<view class="leading-[50rpx]">考试模式：{{examDetail.mode_arr.name}}（{{examDetail.mode_arr.desc}}考试）</view>
				<view class="leading-[50rpx]" v-if="examDetail.mode == 2">报名时间：{{examDetail.sign_end_time}}之前</view>
				<view class="leading-[50rpx]">开放时间：{{examDetail.start_time}}</view>
				<view class="leading-[50rpx]">关闭时间：{{examDetail.end_time}}</view>
				<view class="leading-[50rpx]">可考次数：{{examDetail.num_limit == 0 ? '不限考试次数' : examDetail.num_limit }}</view>
				
			</view>
			
			<view class="p-[30rpx] mt-[10rpx] bg-white text-[30rpx]">
				<view class="font-bold mb-[20rpx]">详细介绍</view>
				<u-parse :content="examDetail.desc" :tagStyle="style"></u-parse>
			</view>
			
			<view class="tab-bar-placeholder"></view>
			<view class="border-[0] border-t-[2rpx] border-solid border-[#f5f5f5] w-[100%] flex justify-between pl-[30rpx] pr-[30rpx] bg-[#fff] box-border fixed left-0 bottom-0 tab-bar items-center pt-[16rpx]">
				<view class="flex items-center">
					<view class="flex flex-col justify-center items-center mr-[38rpx]" @click="redirect({ url: '/addon/zzexam/pages/index', mode: 'reLaunch' })">
						<view class="nc-iconfont nc-icon-shouyeV6xx11 text-[36rpx]"></view>
						<text class="text-[20rpx] mt-[10rpx]">首页</text>
					</view>
					
					<view class="flex flex-col justify-center items-center mr-[38rpx]" @click="collectFn">
						<text class="nc-iconfont text-[36rpx]" :class="{'text-[var(--primary-color)] nc-icon-xihuanV6mm': isCollect, 'text-[#303133] nc-icon-guanzhuV6xx' : !isCollect}"></text>
						<text class="text-[20rpx] mt-[10rpx]">收藏</text>
					</view>
					
					<view class="flex flex-col justify-center items-center mr-[38rpx]" @click="openShareFn">
						<view class="nc-iconfont nc-icon-fenxiangV6xx text-[36rpx]"></view>
						<text class="text-[20rpx] mt-[10rpx]">分享</text>
					</view>
				</view>

				<view class="flex flex-1" v-if="examDetail.mode == 2 && examDetail.is_sign && examDetail.is_exam == 0">
					<button  class="flex-1 !h-[70rpx] font-500 text-[26rpx] !text-[#fff] primary-btn-bg !m-0 leading-[70rpx] rounded-full remove-border" @click="addSignRef.open()">考试报名</button>
				</view>
				<view class="flex flex-1" v-else-if="examDetail.mode == 3 && examDetail.is_exam == 0 ">
					<button  class="flex-1 !h-[70rpx] font-500 text-[26rpx] !text-[#fff] primary-btn-bg !m-0 leading-[70rpx] rounded-full remove-border" @click="create">￥{{examDetail.price}} 购买</button>
				</view>
				<view class="flex flex-1" v-else-if="examDetail.mode == 4 && examDetail.is_exam == 0">
					<button  class="flex-1 !h-[70rpx] font-500 text-[26rpx] !text-[#fff] primary-btn-bg !m-0 leading-[70rpx] rounded-full remove-border" @click="addPwdRef.open()">密码验证</button>
				</view>
				<view class="flex flex-1" v-else-if="examDetail.mode == 5 && examDetail.is_exam == 0">
					<button  class="flex-1 !h-[70rpx] font-500 text-[26rpx] !text-[#fff] primary-btn-bg !m-0 leading-[70rpx] rounded-full remove-border" @click="redirect({ url: '/addon/zzexam/pages/vip/buy'})">开通VIP会员</button>
				</view>
				<view class="flex flex-1" v-else-if="examDetail.exam_status.value == 'not_active' || examDetail.exam_status.value == 'end'">
					<button class="w-[100%] !h-[70rpx] font-500 text-[26rpx] !text-[#fff] !bg-[#ccc] !m-0 leading-[70rpx] rounded-full remove-border">{{ examDetail.exam_status.name }}</button>
				</view>
				<view class="flex flex-1" v-else>
					<button class="flex-1 !h-[70rpx] font-500 text-[26rpx] !text-[#fff] primary-btn-bg !m-0 leading-[70rpx] rounded-full remove-border" @click="startExam">开始答题</button>
				</view>
			</view>
		</block>
		<u-loading-page :loading="loading" fontSize="16" color="#333"></u-loading-page>

		<share-poster ref="sharePosterRef" posterType="zzexam_exam" :posterParam="posterParam" :copyUrlParam="copyUrlParam" />

		<!-- 报名弹窗 -->
		<add-sign-popup ref="addSignRef" @confirm="confirmAddSign" />

		<!-- 密码验证弹窗 -->
		<add-pwd-popup ref="addPwdRef" @confirm="confirmAddPwd" />

		<pay ref="payRef" @close="payClose"></pay>
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, computed, nextTick } from 'vue'
	import { onLoad } from '@dcloudio/uni-app'
	import { redirect, img} from '@/utils/common';
	import { getExamDetail,addSign, addPwd, orderCreate } from '@/addon/zzexam/api/exam';
	import { addCollect } from '@/addon/zzexam/api/collect';
	import { useShare } from '@/hooks/useShare'
	import { useLogin } from '@/hooks/useLogin'
	import useMemberStore from '@/stores/member'
	import addSignPopup from './components/add-sign-popup.vue'
	import addPwdPopup from './components/add-pwd-popup.vue'

	const { setShare } = useShare()
	const payRef = ref(null)

	// 会员信息
	const memberStore = useMemberStore()
	const userInfo = computed(() => memberStore.info)
	let orderId = ref<number>(0);
	let tradeType =  ref<string>('');
	let examDetail = ref<Array<any>>([]);
	let loading = ref<boolean>(true);
	let style = {
		h2: 'margin-bottom: 20rpx;',
		p: 'margin-bottom: 10rpx;line-height: 1.6;text-align: justify;',
		img: 'margin: 20rpx 0;',
	};
	onLoad((option) => {
		loading.value = true;
		getExamDetail(option.exam_id).then((res) => {
			examDetail.value = res.data;
			isCollect.value = examDetail.value.is_collect;
			loading.value = false;
			let share = {
				title: examDetail.value.title,
				desc: examDetail.value.title,
				url: examDetail.value.cover
			}
			setShare({
				wechat: {
					...share
				},
				weapp: {
					...share
				}
			});
			
			copyUrlFn();
			
			nextTick(() => {
				setTimeout(() => {
					if(sharePosterRef.value) {
						posterParam.exam_id = examDetail.value.exam_id;
						if (userInfo.value && userInfo.value.member_id) posterParam.member_id = userInfo.value.member_id;
						sharePosterRef.value.loadPoster();
					}
				}, 400)
			})
		})
	})

	//开始答题
	const startExam = () => {
		// 检测是否登录
		if (!userInfo.value) {
		    useLogin().setLoginBack({
		        url: '/addon/zzexam/pages/exam/detail',
		        param: {
			        exam_id: examDetail.value.exam_id,
		        }
		    })
		    return false
		}
		redirect({ url: '/addon/zzexam/pages/exam/show', param: { exam_id: examDetail.value.exam_id } })
	}

	//创建订单
	let createLoading = ref(false);
	const create = () => {
		// 检测是否登录
		if (!userInfo.value) {
		    useLogin().setLoginBack({
		        url: '/addon/zzexam/pages/exam/detail',
		        param: {
			        exam_id: examDetail.value.exam_id,
		        }
		    })
		    return false
		}
		createLoading.value = true
		let data = {exam_id:examDetail.value.exam_id};
		
		if(orderId.value != 0 && tradeType.value != ''){
			payRef.value?.open(tradeType.value, orderId.value,`/addon/zzexam/pages/exam/detail?exam_id=${examDetail.value.exam_id}`);
		}else{
			orderCreate(data).then((res) => {
				orderId.value = res.data.trade_id;
				tradeType.value = res.data.trade_type;
				payRef.value?.open(res.data.trade_type, res.data.trade_id,`/addon/zzexam/pages/exam/detail?exam_id=${examDetail.value.exam_id}`);
			}).catch(() => {
				createLoading.value = false
			})
		}
	}

	/**
	 * 支付弹窗关闭
	 */
	const payClose = () => {
	    createLoading.value = false
	}

	// 报名
	const addSignRef = ref();
	// 确认报名
	const confirmAddSign = (data : any) => {
		// 检测是否登录
		if (!userInfo.value) {
		    useLogin().setLoginBack({
		        url: '/addon/zzexam/pages/exam/detail',
		        param: {
			        exam_id: examDetail.value.exam_id,
		        }
		    })
		    return false
		}
		addSign({realname:data.realname,mobile:data.mobile,exam_id:examDetail.value.exam_id}).then(res => {
			examDetail.value.is_exam = 1;
			addSignRef.value.close();
		})
	}

	// 密码验证
	const addPwdRef = ref();
	// 确认密码验证
	const confirmAddPwd = (data : any) => {
		// 检测是否登录
		if (!userInfo.value) {
		    useLogin().setLoginBack({
		        url: '/addon/zzexam/pages/exam/detail',
		        param: {
			        exam_id: examDetail.value.exam_id,
		        }
		    })
		    return false
		}
		addPwd({password:data.password,exam_id:examDetail.value.exam_id}).then(res => {
			examDetail.value.is_exam = 1;
			addPwdRef.value.close();
		})
	}
	
	// 收藏
	const isCollect: any = ref(0);
	const collectFn = () => {
		// 检测是否登录
		if (!userInfo.value) {
		    useLogin().setLoginBack({
		        url: '/addon/zzexam/pages/exam/detail',
		        param: {
			        exam_id: examDetail.value.exam_id,
		        }
		    })
		    return false
		}
		
		addCollect({type:'exam',target_id:examDetail.value.exam_id}).then(res => {
			isCollect.value = !isCollect.value;
			if (isCollect.value) {
				uni.showToast({
					title: '收藏成功',
					icon: 'none'
				});
			} else {
				uni.showToast({
					title: '取消收藏',
					icon: 'none'
				});
			}
		})
	}
	
	// 分享海报
	const sharePosterRef: any = ref(null);
	const copyUrlParam = ref('');
	let posterParam: any = {};

	// 分享海报链接
	const copyUrlFn = ()=>{
		copyUrlParam.value = '?exam_id='+examDetail.value.exam_id;
		if (userInfo.value && userInfo.value.member_id) copyUrlParam.value += '&mid=' + userInfo.value.member_id;
	}

	const openShareFn = ()=>{
		sharePosterRef.value.openShare()
	}
</script>
<style>
	@import '@/addon/zzexam/styles/common.scss';
	.primary-btn-bg {
	  background-color: #2C6FFF;
	}
</style>