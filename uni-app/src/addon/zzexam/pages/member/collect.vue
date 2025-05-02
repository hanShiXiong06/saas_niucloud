<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)] min-h-[100vh]">
		
		<mescroll-body ref="mescrollRef" top="30rpx" @init="mescrollInit" @down="downCallback" @up="getCollectListFn">
			<view class="list">
				<view v-for="(item,index) in collectList" :key="index" class="flex align-center p-[30rpx] bg-white rounded-[24rpx] mx-[30rpx] mb-[30rpx] relative" @click="toExam(item.target.exam_id)">
					
					<view class="absolute right-0 top-[-1rpx] w-[120rpx] h-[36rpx] leading-[36rpx] rounded-bl-[24rpx] rounded-tr-[24rpx] text-[#ffffff] bg-[var(--main1-text-color)] text-center text-[22rpx]" @click.stop="collectFn(item.target_id)">取消收藏</view>
					<block v-if="item.type == 'exam'">
						<view class="relative rounded-[10rpx] overflow-hidden">
							<u--image width="255rpx" height="180rpx" :src="img(item.target.cover)" model="aspectFill">
								<template #error>
									<u-icon name="photo" color="#f7f7f7" size="50"></u-icon>
								</template>
							</u--image>
							
							<view class="absolute left-0 top-[-1rpx] px-[15rpx] h-[40rpx] leading-[40rpx] rounded-br-[10rpx] text-[#ffffff] bg-[var(--main1-text-color)] text-center text-[24rpx]">{{item.target.mode_arr.name}}</view>
						</view>
						
						<view class="flex-1 flex flex-col justify-between ml-[10px]">
							<view class="text-[30rpx] leading-[1.3] using-hidden mt-[2px]">{{item.target.title}}</view>
							<view class="text-[26rpx] mt-[20rpx]">
								<text class="text-[var(--light-text-color)]">{{item.target.subject.full_name}}</text>
							</view>
							<view class="flex text-[26rpx] mt-[25rpx] leading-[56rpx]">
								<view class="text-[var(--light-text-color)]"><text class="text-[var(--primary-color)]">{{item.target.exam_num}}</text>次考试</view>
								
								<view class="ml-auto text-[#fff] text-[26rpx] w-[156rpx] h-[50rpx] leading-[50rpx] rounded-[25rpx] bg-[var(--primary-color)] text-center">进入考试</view>
								
							</view>
						</view>
					</block>
					
				</view>
			</view>
			<view class="mx-[30rpx]">
				<mescroll-empty class="mt-0" :option="{tip : '暂无收藏'}" v-if="!collectList.length && loading"></mescroll-empty>
			</view>
			
		</mescroll-body>
		
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad, onShow } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { getCollectType,getCollectList } from '@/addon/zzexam/api/study';
	import { addCollect } from '@/addon/zzexam/api/collect';
	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
	import { onPageScroll, onReachBottom } from '@dcloudio/uni-app';
    const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);

	const collectList = ref<Array<any>>([]);
	let typeLoading = ref<boolean>(false);
	let type = ref('exam')
	let typeList = ref([]);
	const mescrollRef = ref(null);
	const loading = ref(false);
	
	onLoad(() => {
		getCollectTypeFn();
	})
	
	// 获取类型
	const getCollectTypeFn = () => {
		typeLoading.value = false;
		typeList.value = [];
		let obj = { value:'', name:'全部'};
		typeList.value.push(obj);
	
		getCollectType().then((res) => {
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
	
	const getCollectListFn = (mescroll : mescrollStructure) => {
		loading.value = false;
		let data : object = {
			page: mescroll.num,
			limit: mescroll.size,
			type: type.value
		};

		getCollectList(data).then((res) => {
			let newArr = (res.data.data as Array<Object>);
			//设置列表数据
			if (mescroll.num == 1) {
				collectList.value = []; //如果是第一页需手动制空列表
			}
			collectList.value = collectList.value.concat(newArr);
			mescroll.endSuccess(newArr.length);
			loading.value = true;
		}).catch(() => {
			loading.value = true;
			mescroll.endErr(); // 请求失败, 结束加载
		})
	}
	
	const collectFn = (target_id: number) => {
		
		uni.showModal({
			title: '提示',
			content: '确定要取消收藏吗？',
			success: res => {
				if (res.confirm) {
					addCollect({type:'exam',target_id:target_id}).then(res => {
						getMescroll().resetUpScroll();
					})
				}
			}
		})
		
		
	}
	
	// 切换类型
	const changeTypeFn = (t: string) => {
		type.value = t;
		collectList.value = [];
		getMescroll().resetUpScroll();
	};
	
	const toExam = (exam_id: number) => {
		redirect({ url: '/addon/zzexam/pages/exam/detail', param: { exam_id } })
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