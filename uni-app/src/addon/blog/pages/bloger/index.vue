<template>

	<view custom-navbar navbar-title="主页" wrapper-begin-navbar="false" wrapper-bg-color="#F7F6F1">
		<view style="padding-bottom: 160rpx;" v-if="bloggerData">

			<!-- 用户信息 S -->
			<view class="user-container">
				<!-- 旋转头像 -->
				<view class="cube__container">
					<view class="cube__container__body">
						<view class="cube__container__body__item cube__container__body__item--front"
							:style="'background-image:url('+img(bloggerData?.headimg)+');'"></view>
						<view class="cube__container__body__item cube__container__body__item--back"
							:style="'background-image:url('+img(bloggerData?.headimg)+');'"></view>
						<view class="cube__container__body__item cube__container__body__item--right"
							:style="'background-image:url('+img(bloggerData?.headimg)+');'"></view>
						<view class="cube__container__body__item cube__container__body__item--left"
							:style="'background-image:url('+img(bloggerData?.headimg)+');'"></view>
						<view class="cube__container__body__item cube__container__body__item--top"
							:style="'background-image:url('+img(bloggerData?.headimg)+');'"></view>
						<view class="cube__container__body__item cube__container__body__item--bottom"
							:style="'background-image:url('+img(bloggerData?.headimg)+');'"></view>
					</view>
				</view>
				<!-- 用户名 -->
				<view class="cube__username">{{bloggerData?.nickname}}</view>
			</view>
			<!-- 用户信息 E -->

			<!-- 评论详情 S -->
			<view class="user-comment">
				<!-- 消息按钮 -->
				<!-- <view class="user-news">
					<view class="user-news-btn" @tap.stop="navPage(`/blog-page/news/index?uid=${bloggerData.uid}`)">
						消息动态
					</view>
				</view> -->
				<!-- 用户动态 -->
				<view class="user-status">
					<view class="status-like">
						<view class="like-num " style="color: #fa8d14;">{{ bloggerData?.zan_num }}</view>
						<view class="like-icon">
							<text class="tn-icon-like"></text> 点赞数
						</view>
					</view>
					<!-- <view class="status-like">
						<view class="like-num tn-color-orangered">{{ bloggerData?.fensi_num }}</view>
						<view class="like-icon">
							<text class="tn-icon-vip"></text> 粉丝
						</view>
					</view>
					<view class="status-like">
						<view class="like-num tn-color-indigo">{{ bloggerData?.follow_num }}</view>
						<view class="like-icon">
							<text class="tn-icon-star"></text> 关注
						</view>
					</view> -->
					<view class="status-like">
						<view class="like-num " style="color: #1677ff;">{{ bloggerData?.views_num }}</view>
						<view class="like-icon">
							<text class="tn-icon-vip"></text> 浏览数
						</view>
					</view>
					<view class="status-like">
						<view class="like-num " style="color: #ff00ff;">{{ bloggerData?.tie_num }}</view>
						<view class="like-icon">
							<text class="tn-icon-star"></text> 帖子数
						</view>
					</view>
				</view>
			</view>


			<mescroll-body ref="mescrollRef" @init="mescrollInit" top="0" @down="downCallback" @up="getListFn">



				<view style="flex-direction: column;margin:30rpx 3%">

					<view v-for="(item,index) in tielist" :key="index" class="blogger__item home-shadow "
						style="border-radius: 15rpx;box-shadow: 0rpx 0rpx 50rpx 0rpx rgba(0, 0, 0, 0.09);padding:35rpx 3%">
						<tieitem :item="item" :config="config"></tieitem>
					</view>
				</view>

				<view class='tn-tabbar-height'></view>
				<mescroll-empty v-if="!tielist.length && loading"></mescroll-empty>
			</mescroll-body>


			<!-- 底部按钮 S -->
			<!-- <view class="floot-btn">
				<button v-if="!is_me" @click="saveFollow({isfollow:bloggerData?.isfollow,uid:bloggerData?.member_id})"
					class='shadow-blur lg text-bold tn-bg-yellow tn-color-brown'>
					<text
						class="tn-icon-add tn-padding-right-xs tn-color-black"></text>{{bloggerData?.isfollow==1?'取消关注':'关注'}}
				</button>
			</view> -->
		</view>

	</view>

</template>

<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { lookimg, tourl } from '@/addon/blog/utils/common';
	import { getCategory, getBanner, getTielist, getTongji, delTieApi, getConfigApi } from '@/addon/blog/api/tie'
	import tieitem from '@/addon/blog/components/tieitem/tieitem.vue'
	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue'
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue'
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js'
	import { onPageScroll, onReachBottom } from '@dcloudio/uni-app'
	import { useShare } from '@/hooks/useShare'

	import { getBlogerApi, tofollowApi } from '@/addon/blog/api/bloger'

	const payRef = ref()

	const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
	const { setShare, onShareAppMessage, onShareTimeline } = useShare()
	setShare()
	onShareAppMessage()
	onShareTimeline()

	let mescrollRef = ref(null);
	let loading = ref<boolean>(false);

	// 定义 id 变量
	const id = ref('');
	const config = ref([]);
	getConfigApi({}).then(res => {
		config.value = res.data;
	})
	// 定义 bloggerData 数组
	const bloggerData = ref([]);


	onLoad((option) => {
		console.log(option.id);
		id.value = option.id;
		getBloger();
		setTimeout(() => {
			getMescroll().optUp.textNoMore = t("end");
		}, 500)
	})

	const getBloger = () => {
		getBlogerApi({
			member_id: id.value
		}).then((res : any) => {

			bloggerData.value = res.data;
			console.log(bloggerData.value);
		})
	}





	interface mescrollStructure {
		num : number,
		size : number,
		endSuccess : Function,
		[propName : string] : any
	}


	const latitude = ref(uni.getStorageSync('mylat'));
	const longitude = ref(uni.getStorageSync('mylng'));


	const tielist = ref([]);
	const getListFn = (mescroll : mescrollStructure) => {
		loading.value = false;
		let data : object = {
			// cate_id: currCategoryId.value,
			// title: tieTitle.value,
			page: mescroll.num,
			limit: mescroll.size,
			is_ta: 1,
			ta_member_id: id.value,
			lat: latitude.value,
			lng: longitude.value
		};

		getTielist(data).then((res : any) => {
			let newArr = (res.data.data as Array<Object>);
			//设置列表数据
			if (mescroll.num == 1) {
				tielist.value = []; //如果是第一页需手动制空列表
			}
			tielist.value = tielist.value.concat(newArr);
			console.log(tielist.value)
			mescroll.endSuccess(newArr.length);
			loading.value = true;
		}).catch(() => {
			loading.value = true;
			mescroll.endErr(); // 请求失败, 结束加载
		})
	}

	// const loadCategory = (id : string) => {
	// 	currCategoryId.value = id;
	// 	getMescroll().resetUpScroll();
	// }

	const searchFn = () => {
		getMescroll().resetUpScroll();
	}
	// onMounted(() => {
	// 	setTimeout(() => {
	// 		getMescroll().optUp.textNoMore = t("end");
	// 	}, 500)
	// });


	const tofollow = () => {
		tofollowApi({
			touid: bloggerData.value.id,
			isfollow: Number(!bloggerData.value.isfollow)
		})
			.then((res) => {
				console.log(res);
				uni.showToast({
					icon: 'none',
					title: bloggerData.value.isfollow ? '取消关注' : '关注成功'
				})
				getMescroll().resetUpScroll();
			}).catch(err => {
				console.log(err);
			})
	}
</script>


<style lang="scss" scoped>
	// 底部按钮
	.floot-btn {
		position: fixed;
		bottom: 0;
		padding: 40rpx;
		width: 100%;
		z-index: 100;
	}

	.cube__username {
		font-size: 16px;
	}

	// 消息动态
	.user-comment {
		padding: 10rpx;
		background-color: white;
		border-radius: 30rpx 30rpx 0 0;
	}


	// 动态列表
	.user-status {
		display: flex;
		flex-wrap: wrap;
		align-self: center;
		margin: 20rpx 0 0;

		.status-like {
			flex: 1;
			text-align: center;
		}
	}

	.like-num {
		font-size: 20px;
		margin-bottom: 0rpx;
	}

	.like-icon {
		color: #AAAAAA;

		text {
			font-size: 18px;
			margin-right: 10rpx;
		}
	}



	/* 立体头像 start*/
	$cube-size: 120rpx;
	$cube-split: 60rpx;

	.cube {
		background: #fff;
		background-repeat: no-repeat;
		background-size: cover;
		height: 550rpx;
		display: flex;
		justify-content: center;
		padding-top: 40rpx;
		overflow: hidden;
		position: relative;
		flex-direction: column;
		align-items: center;
		font-weight: 300;

		&__username {
			color: black;
			font-weight: bold;
		}

		&__container {
			margin-top: 180rpx;
			margin-bottom: 10%;
			position: relative;
			width: $cube-size;
			height: $cube-size;
			-webkit-perspective: 500px;
			perspective: 500px; //透视太大会超过屏幕就不好了吖

			&:before {
				content: '';
				width: $cube-size;
				height: $cube-size;
				position: absolute;
				// top: calc(50% - ($cube-split - 30px));
				// left: calc(50% - $cube-split);
				background-color: #3c6496;
				filter: blur(60px);
				opacity: .8;
			}

			&__body {
				position: absolute;
				width: 100%;
				height: 100%;
				transform-style: preserve-3d;
				transform: translateZ(-75px);
				animation: cubeFrame 35s cubic-bezier(0.36, -0.03, 0.46, 0.95) infinite alternate;
				will-change: transform;

				&__item {
					position: absolute;
					display: block;
					display: flex;
					align-items: center;
					justify-content: center;
					width: $cube-size;
					height: $cube-size;
					font-size: 30px;
					background-repeat: no-repeat;
					background-size: cover;

					&--front {
						transform: rotateY(0deg) translateZ($cube-split);
						background-color: #BEEBFF;
					}

					&--back {
						transform: rotateX(180deg) translateZ($cube-split);
						background-color: #BEEBFF;
					}

					&--right {
						transform: rotateY(90deg) translateZ($cube-split);
						background-color: #BEEBFF;
					}

					&--left {
						transform: rotateY(-90deg) translateZ($cube-split);
						background-color: #BEEBFF;
					}

					&--top {
						transform: rotateX(90deg) translateZ($cube-split);
						background-color: #BEEBFF;
					}

					&--bottom {
						transform: rotateX(-90deg) translateZ($cube-split);
						background-color: #BEEBFF;
					}
				}
			}
		}
	}

	@keyframes cubeFrame {
		10% {
			transform: translateZ(-75px) rotateX(40deg) rotateY(60deg);
		}

		15% {
			transform: translateZ(-75px) rotateX(80deg) rotateY(20deg);
		}

		20% {
			transform: translateZ(-75px) rotateX(-180deg) rotateY(-70deg);
		}

		30% {
			transform: translateZ(-75px) rotateX(90deg) rotateY(180deg);
		}

		40% {
			transform: translateZ(-75px) rotateX(-10deg) rotateY(-140deg);
		}

		45% {
			transform: translateZ(-75px) rotateX(-100deg) rotateY(20deg);
		}

		55% {
			transform: translateZ(-75px) rotateX(-10deg) rotateY(-35deg);
		}

		60% {
			transform: translateZ(-75px) rotateX(180deg) rotateY(360deg);
		}

		70% {
			transform: translateZ(-75px) rotateX(-180deg) rotateY(-360deg);
		}

		80% {
			transform: translateZ(-75px) rotateX(45deg) rotateY(-70deg);
		}

		90% {
			transform: translateZ(-75px) rotateX(-45deg) rotateY(70deg);
		}

		100% {
			transform: translateZ(-75px) rotateX(-360deg) rotateY(360deg);
		}
	}

	/* 立体头像 end*/
	// 背景
	.user-container {
		background: #fff;
		height: 550rpx;
		display: flex;
		justify-content: center;
		overflow: hidden;
		position: relative;
		flex-direction: column;
		align-items: center;
		color: #fff;
		font-weight: 300;
		background-repeat: no-repeat;
		background-size: cover;
		background-image: url(http://qny.wdsp666.com/%E7%A6%8F%E8%A2%8B%E8%83%8C%E6%99%AF%E5%9B%BE/bg_image_1.jpg);
	}
</style>