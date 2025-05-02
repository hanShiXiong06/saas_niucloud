<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh]">
		<view class="list pt-[30rpx]">
			<view v-for="(item,index) in menuList" :key="index" class="flex align-center p-[30rpx] bg-white rounded-[24rpx] mx-[30rpx] mb-[30rpx]" @click="toLink(item.url)">
				<view class="relative rounded-[10rpx] overflow-hidden">
					<u--image width="105rpx" height="105rpx" :src="img(item.image)" />
				</view>
				
				<view class="ml-[10px]">
					<view class="text-[30rpx] font-bold mt-[10rpx]">{{item.name}}</view>
					<view class="text-[26rpx] mt-[30rpx]">
						<text class="text-[var(--light-text-color)]">{{item.des}}</text>
					</view>
				</view>
				<view class="ml-auto pt-[35rpx]">
					<u-icon name="arrow-right" labelPos="left" color="var(--light-text-color)" size="18"></u-icon>
				</view>
			</view>
		</view>
		
		<!-- 笔记弹窗 -->
		<u-popup :show="categoryShow" @close="categoryShow = false" mode="center" :round="10" :closeable="true">
			
			<view class="w-[690rpx]">
				<view class="w-[570rpx] m-[60rpx]">
					<u-divider text="选择题库" textColor="#000000"></u-divider>
				</view>
				
				<view class="m-[30rpx] flex flex-wrap justify-between">
					<view v-for="(item, index) in categoryList" @click="categoryChangeFn(item.category_id)" :class="['border-solid py-[15rpx] px-[30rpx] rounded-[10rpx] mb-[30rpx] border-color-[#eee]', { 'text-[var(--primary-color)] border-color-[var(--primary-color)]': categoryId == item.category_id }]" :key="index">
						{{item.name}}
					</view>
				</view>
				
				<view class="mb-[60rpx]">
					<button class="primary-btn-bg text-[#fff] h-[60rpx] leading-[60rpx] w-[300rpx] mt-[30rpx] rounded-[30rpx] text-[26rpx] font-500" @click="toPractice">确定</button>
				</view>
			</view>
			
			
		</u-popup>
	</view>
	<tabbar addon="zzexam"/>
</template>

<script setup lang="ts">
	import { reactive, ref, onMounted, computed } from 'vue'
	import { onLoad, onShow } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { getCategoryTree } from '@/addon/zzexam/api/study';
	import { redirect, img } from '@/utils/common';
	import useMemberStore from '@/stores/member'
	import { useLogin } from '@/hooks/useLogin'
	
	const categoryList = ref<Array<any>>([]);
	// 会员信息
	const memberStore = useMemberStore()
	const userInfo = computed(() => memberStore.info)
	const categoryId = ref(0);
	const categoryShow = ref(false);
	const menuList = ref<Array<any>>([
		{name:'练习刷题',des:'选择题库模拟考试刷题',image:'addon/zzexam/study/practice.png',url:'practice'},
		{name:'知识点',des:'掌握知识点，助您轻松考过',image:'addon/zzexam/study/know.png',url:'/addon/zzexam/pages/study/know/list'},
		{name:'学习动态',des:'助您实时掌握学习动态',image:'addon/zzexam/study/article.png',url:'/addon/zzexam/pages/study/article/list'},
		{name:'错题练习',des:'加深理解，纠正误区',image:'addon/zzexam/study/errors.png',url:'/addon/zzexam/pages/member/errors'},
		{name:'笔记夹',des:'查看学习笔记，熟练掌握知识',image:'addon/zzexam/study/note.png',url:'/addon/zzexam/pages/member/note'},
		{name:'通知公告',des:'快速为您传达考试信息',image:'addon/zzexam/study/notice.png',url:'/addon/zzexam/pages/study/notice/list'},
	]);
	
	onLoad(() => {
		getCategoryTreeFn();
	})
	
	const getCategoryTreeFn = () => {
		getCategoryTree({type:'question'}).then((res) => {
			categoryList.value = res.data;
		});
	}
	
	const categoryChangeFn = (category_id: number) => {
		categoryId.value = category_id;
	}
	
	//去练习
	const toPractice = () => {
		if(categoryId.value == ''){
			uni.showToast({
				title:'请选项题库',
				icon:'none'
			});
		}else{
			categoryShow.value = false;
			redirect({ url: '/addon/zzexam/pages/study/practice', param: { type:'question','category_id':categoryId.value } });
		}
	}
	
	const toLink = (url: string) => {
		
		if(url == 'practice'){
			// 检测是否登录
			if (!userInfo.value) {
			    useLogin().setLoginBack({
			        url: '/addon/zzexam/pages/study/index',
			    })
			}else{
				categoryShow.value = true;
			}
		}else{
			redirect({ url })
		}
		
	}
	
</script>

<style >
	@import '@/addon/zzexam/styles/common.scss';
</style>