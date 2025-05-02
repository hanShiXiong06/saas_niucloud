<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh]">
		<view class="fixed left-0 top-0 right-0 z-10" v-if="typeLoading">
			<scroll-view scroll-x="true" class="scroll-Y box-border px-[24rpx] bg-white">
				<view class="flex whitespace-nowrap justify-around">
					<view :class="['text-sm leading-[90rpx]', { 'class-select': type === item.value.toString() }]"
						@click="changeTypeFn(item.value)" v-for="(item, index) in typeList"> {{item.name}}</view>
				</view>
			</scroll-view>
		</view>
		
		<mescroll-body ref="mescrollRef" top="120rpx" @init="mescrollInit" @down="downCallback" @up="getNoteListFn">
			<view class="list">
				<view v-for="(item,index) in noteList" :key="index" class="align-center relative py-[40rpx] px-[30rpx] bg-white rounded-[10rpx] mx-[30rpx] mb-[30rpx]" @tap="toLink(item.target_id,item.type)">
					<view>
						<text class="px-[15rpx] h-[44rpx] leading-[44rpx] rounded-[10rpx] text-[#ffffff] bg-[var(--main1-text-color)] text-center text-[24rpx]">{{item.type_name}}</text> {{item.target.title}}
					</view>
					<view class="text-[var(--light-text-color)] mt-[20rpx]">{{item.content}}</view>
				</view>
			</view>
			
			<view class="mx-[30rpx]">
				<mescroll-empty class="mt-0" :option="{tip : '暂无笔记'}" v-if="!noteList.length && loading"></mescroll-empty>
			</view>
			
		</mescroll-body>
		
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad, onShow } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { getNoteType,getNoteList } from '@/addon/zzexam/api/study';
	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
	import { onPageScroll, onReachBottom } from '@dcloudio/uni-app';
    const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);

	const noteList = ref<Array<any>>([]);
	let typeLoading = ref<boolean>(false);
	let type = ref('')
	let typeList = ref([]);
	const mescrollRef = ref(null);
	const loading = ref(false);
	
	onLoad(() => {
		getNoteTypeFn();
	})
	
	// 获取类型
	const getNoteTypeFn = () => {
		typeLoading.value = false;
		typeList.value = [];
		let obj = { name: '全部', value: '' };
		typeList.value.push(obj);
		
		getNoteType().then((res) => {
			Object.keys(res.data).forEach((item, index) => {
				typeList.value.push({value:item,name:res.data[item]});
			});
			typeLoading.value = true;
		}).catch(() => {
			typeLoading.value = true;
		})
	}
	

	interface mescrollStructure {
		num : number,
		size : number,
		endSuccess : Function,
		[propName : string] : any
	}
	
	const getNoteListFn = (mescroll : mescrollStructure) => {
		loading.value = false;
		let data : object = {
			page: mescroll.num,
			limit: mescroll.size,
			type: type.value
		};

		getNoteList(data).then((res) => {
			let newArr = (res.data.data as Array<Object>);
			//设置列表数据
			if (mescroll.num == 1) {
				noteList.value = []; //如果是第一页需手动制空列表
			}
			noteList.value = noteList.value.concat(newArr);
			mescroll.endSuccess(newArr.length);
			loading.value = true;
		}).catch(() => {
			loading.value = true;
			mescroll.endErr(); // 请求失败, 结束加载
		})
	}
	
	// 切换类型
	const changeTypeFn = (t: string) => {
		type.value = t;
		noteList.value = [];
		getMescroll().resetUpScroll();
	};
	
	onMounted(() => {
		setTimeout(() => {
			getMescroll().optUp.textNoMore = t("end");
		}, 500)
	});
	
	const toLink = (id:number,type:string) => {
		if(type == 'question'){
			redirect({ url: '/addon/zzexam/pages/study/question/detail', param: { id } })
		}
		
		if(type == 'know'){
			redirect({ url: '/addon/zzexam/pages/study/know/detail', param: { id } })
		}
		
		if(type == 'article'){
			redirect({ url: '/addon/zzexam/pages/study/article/detail', param: { id } })
		}
		
		if(type == 'notice'){
			redirect({ url: '/addon/zzexam/pages/study/notice/detail', param: { id } })
		}
	}
	
</script>

<style >
	@import '@/addon/zzexam/styles/common.scss';
</style>