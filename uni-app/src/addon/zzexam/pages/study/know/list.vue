<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh]">
		<view class="fixed left-0 top-0 right-0 z-10">
			<scroll-view scroll-x="true" class="scroll-Y box-border px-[24rpx] bg-white">
				<view class="flex whitespace-nowrap">
					<view :class="['text-sm leading-[90rpx] mr-[40rpx]', { 'class-select': oneCategory == null }]" @click="categoryChangeFn(null,1)">全部</view>
					<view :class="['text-sm leading-[90rpx] mr-[40rpx]', { 'class-select': oneCategory != null && oneCategory.category_id == item.category_id }]" v-for="(item, index) in categoryList" @click="categoryChangeFn(item,1)" :key="index">{{ item.name }}</view>
				</view>
			</scroll-view>
		</view>
		
		<mescroll-body ref="mescrollRef" top="120rpx" @init="mescrollInit" @down="downCallback" @up="getArticleListFn">
			<view class="px-[20rpx] flex flex-wrap pb-[10rpx]" v-if="oneCategory != null && oneCategory.child_list">
				<view v-for="(item, index) in oneCategory.child_list" @click="categoryChangeFn(item,2)" :class="['bg-white text-sm leading-[60rpx] mr-[20rpx] rounded-[30rpx] mb-[20rpx] text-[26rpx] px-[30rpx]', { 'text-[var(--primary-color)]': categoryId == item.category_id }]" :key="index">{{ item.name }}</view>
			</view>
			<view class="list">
				<view v-for="(item,index) in articleList" :key="index" class="flex align-center mb-0 p-[30rpx] bg-white rounded-[10rpx] mx-[20rpx] mb-[30rpx]" @click="toLink(item.article_id)">
					<u--image width="183rpx" height="170rpx" :src="img(item.image)" model="aspectFill">
						<template #error>
							<u-icon name="photo" color="#f7f7f7" size="50"></u-icon>
						</template>
					</u--image>
					<view class="flex-1 flex flex-col justify-between ml-[10px]">
						<view class="text-[30rpx] leading-[1.3] multi-hidden mt-[2px]">{{item.title}}</view>
						<view class="text-[28rpx] using-hidden mb-[10px] mt-[10px] text-gray-500">{{item.category.full_name}}</view>
						<view class="text-[24rpx] text-gray-400 flex justify-between mb-[5px]">
							<text>{{item.create_time}}</text>
							<text class="ml-auto">浏览 {{item.total_views}}</text>
						</view>
					</view>
				</view>
			</view>
			<mescroll-empty class="mt-0" :option="{tip : '暂无知识点'}" v-if="!articleList.length && loading"></mescroll-empty>
		</mescroll-body>
		
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad, onShow } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { getCategoryTree,getArticleList } from '@/addon/zzexam/api/study';
	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
	import { onPageScroll, onReachBottom } from '@dcloudio/uni-app';
    const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);

	const articleList = ref<Array<any>>([]);
	const categoryList = ref<Array<any>>([]);
	const categoryId = ref(0);
	const oneCategory = ref(null);
	const mescrollRef = ref(null);
	const loading = ref(false);
	
	onLoad(() => {
		getCategoryTreeFn();
	})
	
	const getCategoryTreeFn = () => {
		getCategoryTree({type:'know'}).then((res) => {
			categoryList.value = res.data;
		});
	}

	interface mescrollStructure {
		num : number,
		size : number,
		endSuccess : Function,
		[propName : string] : any
	}
	
	const getArticleListFn = (mescroll : mescrollStructure) => {
		loading.value = false;
		let data : object = {
			page: mescroll.num,
			limit: mescroll.size,
			type: 'know',
			category_id: categoryId.value
		};

		getArticleList(data).then((res) => {
			let newArr = (res.data.data as Array<Object>);
			//设置列表数据
			if (mescroll.num == 1) {
				articleList.value = []; //如果是第一页需手动制空列表
			}
			articleList.value = articleList.value.concat(newArr);
			mescroll.endSuccess(newArr.length);
			loading.value = true;
		}).catch(() => {
			loading.value = true;
			mescroll.endErr(); // 请求失败, 结束加载
		})
	}
	
	const categoryChangeFn = (category: any,level: number) => {
		if(level == 1){
			oneCategory.value = category
		}
		categoryId.value = category == null ? 0 : category.category_id;
		
		articleList.value = [];
		getMescroll().resetUpScroll();
	};
	
	const toLink = (id : number) => {
		redirect({ url: '/addon/zzexam/pages/study/know/detail', param: { id } })
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