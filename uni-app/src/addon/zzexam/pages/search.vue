<template>
	<view :style="themeColor()" class="bg-[var(--page-bg-color)]">
		<view class="fixed left-0 top-0 right-0 z-10 bg-white">
			<view class="flex items-center px-[30rpx] h-[120rpx]">
				<view class="h-[68rpx] bg-[var(--page-bg-color)] px-[30rpx] flex items-center rounded-[34rpx] flex-1">	
					<text class="nc-iconfont nc-icon-sousuo-duanV6xx1 text-[var(--text-color-light9)] text-[26rpx] mr-[18rpx]"></text>
					<input class="text-[28rpx] flex-1" maxlength="50" type="text" v-model="inputValue" placeholder="请输入关键词" confirm-type="search" placeholderClass="text-[var(--text-color-light9)] text-[28rpx]" @confirm="search">
					<text v-if="inputValue" class="nc-iconfont nc-icon-cuohaoV6xx1 text-[24rpx] text-[var(--text-color-light9)]" @click="inputValue='';loading = false"></text>
				</view>
				<text @click.stop="search()" class="text-[26rpx] ml-[32rpx] -mb-[2rpx]">搜索</text>
			</view>
		</view>
		
		<view class="search-content">
			<!-- 历史搜索 -->
			
			<view class="history fixed left-0 top-[100rpx] right-0 z-10" v-if="historyList.length && !loading" >
				<view class="history-box">
					<view class="history-top">
						<view class="title font-500">历史搜索</view>
						<view class="icon nc-iconfont nc-icon-shanchu-yuangaizhiV6xx !text-[24rpx] text-[var(--text-color-light6)]" @click="deleteHistoryList"></view>
					</view>
					<view class="history-bottom " id="history-list" :style="{ maxHeight: !isAllHistory ? '100%' : '148rpx' }">
						<block v-for="(item, index) in historyList" :key="index">
							<view class="history-li" @click="otherSearch(item)" v-if="item">
								<view>{{ item }}</view>
							</view>
						</block>
						<view class="history-li history_more" v-if="isAllHistory" @click="isAllHistory = false">
							<view class="content-box">
								<text class="text-[30rpx] nc-iconfont nc-icon-xiaV6xx"></text>
							</view>
						</view>
					</view>
				</view>
			</view>
			
			<view v-if="loading">
				<view class="fixed left-0 top-[100rpx] right-0 z-10">
					<scroll-view scroll-x="true" class="scroll-Y box-border px-[24rpx] bg-white">
						<view class="flex whitespace-nowrap">
							<view :class="['text-sm leading-[90rpx] mr-[50rpx]', { 'class-select': resultIndex === index }]"
								@click="resultIndex = index" v-for="(item, index) in resultList"> {{item.name}}({{item.total}})</view>
						</view>
					</scroll-view>
				</view>
				
				<mescroll-body top="220rpx" ref="mescrollRef" @init="mescrollInit" :down="{ use: false }" @up="getListFn">
					<view class="list" >
						<view v-for="(item,index) in examList" :key="index" class="flex align-center p-[30rpx] bg-white rounded-[10rpx] mx-[30rpx] mb-[30rpx] mx-[30rpx]" @click="toExam(item.exam_id)" v-if="resultIndex == 0">
							<view class="relative rounded-[10rpx] overflow-hidden">
								<u--image width="255rpx" height="180rpx" :src="img(item.cover)" model="aspectFill">
									<template #error>
										<u-icon name="photo" color="#f7f7f7" size="50"></u-icon>
									</template>
								</u--image>
								
								<view class="absolute left-0 top-[-1rpx] px-[15rpx] h-[40rpx] leading-[40rpx] rounded-br-[10rpx] text-[#ffffff] bg-[var(--main1-text-color)] text-center text-[24rpx]">{{item.exam_id}} {{item.mode_arr.name}}</view>
								
							</view>
							
							<view class="flex-1 flex flex-col justify-between ml-[10px]">
								<view class="text-[30rpx] leading-[1.3] using-hidden mt-[2px]">{{item.title}}</view>
								<view class="text-[26rpx] mt-[20rpx]">
									<text class="text-[var(--light-text-color)]">{{item.subject.full_name}}</text>
								</view>
								<view class="flex text-[26rpx] mt-[25rpx] leading-[56rpx]">
									<view class="text-[var(--light-text-color)]"><text class="text-[var(--primary-color)]">{{item.exam_num}}</text>次考试</view>
									
									<view class="ml-auto text-[#fff] text-[26rpx] w-[156rpx] h-[50rpx] leading-[50rpx] rounded-[26rpx] bg-[var(--primary-color)] text-center">进入考试</view>
									
								</view>
							</view>
						</view>
						
						<view v-for="(item,index) in knowList" :key="index" class="flex align-center p-[30rpx] bg-white rounded-[10rpx] mx-[20rpx] mb-[30rpx]" @click="toKnow(item.article_id)" v-if="resultIndex == 1">
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
						
						<view v-for="(item,index) in articleList" :key="index" class="flex align-center p-[30rpx] bg-white rounded-[10rpx] mx-[20rpx] mb-[30rpx]" @click="toArticle(item.article_id)" v-if="resultIndex == 2">
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
					<view class="mx-[30rpx]">
						<mescroll-empty class="mt-0" :option="{tip : '暂无数据'}" v-if="!examList.length && (resultIndex == 0)"></mescroll-empty>
						<mescroll-empty class="mt-0" :option="{tip : '暂无数据'}" v-if="!knowList.length && (resultIndex == 1)"></mescroll-empty>
						<mescroll-empty class="mt-0" :option="{tip : '暂无数据'}" v-if="!articleList.length && (resultIndex == 2)"></mescroll-empty>
					</view>
				</mescroll-body>
			</view>
		</view>
		<u-loading-page :loading="isSearch" fontSize="16" color="#333"></u-loading-page>
	</view>
</template>
<script setup lang="ts">
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue'
import useMescroll from '@/components/mescroll/hooks/useMescroll.js'
import { onPageScroll, onReachBottom, onLoad, onShow } from '@dcloudio/uni-app'
import { ref, nextTick } from 'vue';
import { redirect, img } from '@/utils/common';
import useConfigStore from "@/stores/config";
import { getSearchList,getArticleList } from '@/addon/zzexam/api/study';
import { getCashoutAccountList, deleteCashoutAccount } from '@/app/api/member'
import { getExamList } from '@/addon/zzexam/api/exam';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';

const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom)
const inputValue = ref('') //搜索框的值
const historyList = ref([]) //历史搜索记录
const isAllHistory = ref(false)
const loading = ref(false);
const isSearch = ref(false);
const resultList = ref([]);
const resultIndex = ref(0);
const examList = ref<Array<any>>([]);
const knowList = ref<Array<any>>([]);
const articleList = ref<Array<any>>([]);

onLoad((options:any) => {
    uni.getStorageSync('zzexamSearchHistory') ? '' : uni.setStorageSync('zzexamSearchHistory', []);
});

onShow(() => {
    findHistoryList()
    nextTick(()=> {
        getHistoryHeight();
    });
})

//获取历史搜索记录
const findHistoryList =()=> {
    historyList.value = uni.getStorageSync('zzexamSearchHistory').reverse();
}

// 删除所有历史记录
const deleteHistoryList =()=> {
    uni.showModal({
        title: '提示',
        content: '确认删除全部历史记录？',
        confirmColor: useConfigStore().themeColor['--primary-color'],
        success: res => {
            if (res.confirm) {
                uni.setStorageSync('zzexamSearchHistory', []);
                findHistoryList();
            }
        }
    });
}

//搜索
const search = ()=> {
	
	if(inputValue.value == ''){
		uni.showToast({
			title:'请输入搜索关键词',
			icon: 'none'
		})
		return false;
	}
	
	resultIndex.value = 0;
	loading.value = false;
	isSearch.value = true;
	let historyList = uni.getStorageSync('zzexamSearchHistory');
	let array = [];
	if (historyList.length) {
		array = historyList.filter(v => {
			return v != inputValue.value.trim();
		});
		array.push(inputValue.value.trim());
	} else {
		array.push(inputValue.value.trim());
	}
	uni.setStorageSync('zzexamSearchHistory', array);
	
	getSearchList({keyword:inputValue.value}).then((res) => {
		loading.value = true;
		isSearch.value = false;
		resultList.value = res.data.resultList;
		examList.value = res.data.examList.data;
		knowList.value = res.data.knowList.data;
		articleList.value = res.data.articleList.data;
		
	}).catch(() => {
		isSearch.value = false;
		loading.value = true;
	})
}

const getListFn = (mescroll : any) => {
	let data : object = {
		page: mescroll.num,
		limit: mescroll.size,
		title: inputValue.value
	}
	
	if (mescroll.num > 1) {
		
		if(resultIndex.value == 0){
			getExamList(data).then((res) => {
				let newArr = (res.data.data as Array<Object>);
				examList.value = examList.value.concat(newArr);
				mescroll.endSuccess(newArr.length);
			}).catch(() => {
				mescroll.endErr();
			})
		}
		
		if(resultIndex.value == 1){
			data['type'] = 'know';
			getArticleList(data).then((res) => {
				let newArr = (res.data.data as Array<Object>);
				knowList.value = knowList.value.concat(newArr);
				mescroll.endSuccess(newArr.length);
			}).catch(() => {
				mescroll.endErr(); 
			})
		}
		
		if(resultIndex.value == 2){
			data['type'] = 'article';
			getArticleList(data).then((res) => {
				let newArr = (res.data.data as Array<Object>);
				articleList.value = articleList.value.concat(newArr);
				mescroll.endSuccess(newArr.length);
			}).catch(() => {
				mescroll.endErr();
			})
		}
	}else{
		let l = examList.value.length;
		if(l == 0){
			l = knowList.value.length ? knowList.value.length : articleList.value.length
		}
		
		mescroll.endSuccess(l);
	}
	
}
	

// 点击历史搜索
const otherSearch = (e:any)=> {
    inputValue.value = e;
    search();
}

// 获取元素高度
const getHistoryHeight =()=> {
    const query = uni.createSelectorQuery().in(this);
    query.select('#history-list').boundingClientRect((data: any) => {
        if (data && data.height > uni.upx2px(70) * 2 + uni.upx2px(35) * 2) {
            isAllHistory.value = true;
        }
    }).exec();
}

const toExam = (exam_id: number) => {
	redirect({ url: '/addon/zzexam/pages/exam/detail', param: { exam_id } })
}

const toKnow = (id: number) => {
	redirect({ url: '/addon/zzexam/pages/study/know/detail', param: { id } })
}

const toArticle = (id: number) => {
	redirect({ url: '/addon/zzexam/pages/study/article/detail', param: { id } })
}


</script>
<style>
	@import '@/addon/zzexam/styles/common.scss';
</style>
<style lang="scss" scoped>
	

	.search-content {
		box-sizing: border-box;
	}

	.history {
		width: 100%;
		box-sizing: border-box;

		.history-box {
			width: 100%;
			background: #ffffff;
			padding: 20rpx 30rpx 0rpx 30rpx;

			box-sizing: border-box;
			overflow: hidden;

			.history-top {
				width: 100%;
				display: flex;
				justify-content: space-between;
				align-items: center;

				.title {
					font-size: 28rpx;
				}

				.iconfont {
					color: var(--text-color-light9);
					font-size: 28rpx;
				}
			}

			.history-bottom {
				width: 100%;
				padding-top: 20rpx;
				position: relative;

				.history-li {
					display: inline-block;
					margin-right: 20rpx;
					margin-bottom: 15rpx;
					max-width: 100%;

					view {
						line-height: 56rpx;
						background: var(--temp-bg) !important;
						height: 56rpx;
						color: #333 !important;
						margin: 0 0rpx 4rpx 0 !important;
						padding: 0 24rpx;
						overflow: hidden;
						white-space: nowrap;
						text-overflow: ellipsis;
						border-radius: 100rpx;
						font-size: 24rpx;
					}

					&.history_more {
						margin-right: 0;
						position: absolute;
						bottom: 0;
						right: 0;
						.content-box{
							box-shadow: 2rpx 2rpx 8rpx rgba(0,0,0,.1);
						}
					}
				}
			}
		}
	}

</style>
