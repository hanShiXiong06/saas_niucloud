<template>
	<view class="template-details tn-safe-area-inset-bottom">

		<view class="">
			<!-- 图文信息 -->
			<view style="margin:30rpx 4%">
				<tieitem :item="info" :config="config" v-if="info" type="2"></tieitem>
			</view>

			<!-- 按钮-->
			<view class="flex justify-between" style="margin:10rpx 3% 60rpx;">
				<view class="flex-1 justify-content-item tn-text-center tn-margin-xs">
					<up-button type="warning" :plain="info.islike" @click="tolike" padding="40rpx 0" width="90%">
						<text class="" v-if="info.islike">已点赞</text>
						<text class="" v-else>点赞支持</text>
						<text class="tn-icon-like-lack tn-padding-left-xs tn-color-white"
							style="font-size: 18px;"></text>
					</up-button>
				</view>
				<view class="flex-1 justify-content-item tn-text-center ml-[30rpx]">
					<!-- #ifdef MP -->
					<up-button type="success" backgroundColor="#05C160" padding="40rpx 0" width="90%"
						@click="shareh5()">
						<text class="tn-color-white">分享好友</text>
						<text class="tn-icon-wechat tn-padding-left-xs tn-color-white" style="font-size: 20px;"></text>
					</up-button>
					<!-- #endif -->
					<!-- #ifdef H5 -->
					<up-button type="success" @click="shareh5()" backgroundColor="#05C160" padding="40rpx 0" width="90%"
						open-type="share">
						<text class="tn-color-white">分享好友</text>
						<text class="tn-icon-wechat tn-padding-left-xs tn-color-white" style="font-size: 20px;"></text>
					</up-button>
					<!-- #endif -->
				</view>
			</view>


		</view>

		<sharepopup :showshare="showShareBtn" :share-id="info.id" :config="{}" @hide="showShareBtn=false" />

		<!-- 评论 -->
		<view class="" style="padding-bottom: 120rpx;">

			<pinglist :tie_id="info.id" v-if="info.id" @update="getinfo"></pinglist>

		</view>

		<up-popup :show="showtop" mode="top" @close="showtop=false" closeOnClickOverlay closeable round="0">
			<view class="p-[30rpx]">
				<view>
					<text>更多功能</text>
				</view>
				<view class="morebox flexa mt-[20rpx]">
					<view class="moreitem flexmc" @click="tourl('/addon/blog/pages/home/index',2)">
						<up-icon name="home" size="22"></up-icon>
						<view>首页</view>
					</view>
					<view class="moreitem flexmc" @click="tourl('/addon/blog/pages/create/cate',2)">
						<up-icon name="order" size="22"></up-icon>
						<view>我的发布</view>
					</view>
					<view class="moreitem flexmc" @click="tourl('/app/pages/member/index',2)">
						<up-icon name="account" size="22"></up-icon>
						<view>个人中心</view>
					</view>
					<!-- #ifdef MP -->
					<button open-type="contact" class="moreitem flexmc">
						<up-icon name="chat" size="22"></up-icon>
						<view>联系客服</view>
					</button>
					<!-- #endif -->
				</view>

			</view>
		</up-popup>


		<view class="rightbox">
			<view class="flexmc" @click="shareh5()">
				<up-icon name="share" size="22"></up-icon>
				<view>分享</view>
			</view>
			<u-divider textSize="0" style="margin: 10rpx 0;"></u-divider>
			<view class="flexmc" @click="showtop=true">
				<up-icon name="grid" size="22"></up-icon>
				<view>导航</view>
			</view>
		</view>

	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { lookimg, tourl } from '@/addon/blog/utils/common';
	import { getTieDetail, postTolikelApi, getConfigApi, addviewsApi } from '@/addon/blog/api/tie'

	import pinglist from '@/addon/blog/components/pinglist/pinglist'
	import sharepopup from '@/addon/blog/components/share-popup/share-popup'

	import { useShare } from '@/hooks/useShare'
	const { setShare, onShareAppMessage, onShareTimeline } = useShare()
	// import { onShareTimeline } from '@dcloudio/uni-app'

	import tieitem from '@/addon/blog/components/tieitem/tieitem.vue'

	const config = ref([]);
	getConfigApi({}).then(res => {
		config.value = res.data;
	})

	let loading = ref<boolean>(false);


	const id = ref('')
	const info = ref('')
	const msg = ref('')
	const ping_id = ref(0)
	const showShareBtn = ref(false)
	const showtop = ref(false)

	onLoad((query : any) => {
		console.log(query);
		if (query.scene) {
			var arr = query.scene.split('%26');
			for (var i = 0; i < arr.length; i++) {
				var aa2 = arr[i].split('-');
				if (aa2[0] == 'id') query.id = aa2[1];
				if (aa2[0] == 'pid') uni.setStorageSync('pid', aa2[1]);
			}
		}
		id.value = query.id || 1;
		getinfo();
		addviews();
	})
	/* const shareTime = (options = {}) => {console.log('shareTimeshareTimeshareTime');
	// uni.showModal({title:'111'})
		onShareTimeline(() => {
			console.log('shareTime');	
			// uni.showModal({content:'shareTime'})
			let config : any = uni.getStorageSync('weappOptions')
			if (!config) config = {} 
			sharetieApi({
				id: info.value.id,
			}).then((res) => {
				console.log(res)
			})
			console.log({
				...config,
				...options
			})
			return {
				...config,
				...options
			}
		})
	} */
	const getinfo = () => {
		getTieDetail({ id: id.value }).then((res : any) => {
			info.value = res.data
			uni.setStorageSync('tie_id',info.value.id)
			var imgs = [];
			for (var i = 0; i < res.data.imgs.length; i++) {
				var aa = img(res.data.imgs[i]);
				imgs.push(aa);
			}
			info.value.imgs = imgs;



			uni.setNavigationBarTitle({
				title: info.value.details
			})
			let share = {
				title: info.value.details,
				// url: imgs.length>0?imgs
			}
			setShare({
				wechat: {
					...share
				},
				weapp: {
					...share
				}
			});
			onShareAppMessage()
			onShareTimeline()

		}).catch(() => {
		})
	}

	if (info.value) {
		let share = {
			title: info.value.details,
			// url: imgs.length>0?imgs
		}
		setShare({
			wechat: {
				...share
			},
			weapp: {
				...share
			}
		});
		onShareAppMessage()
		onShareTimeline()
	}






	// const onShareAppMessage = (() => {
	// 	return {
	// 		title: "撒打算1",
	// 		path: '/addon/blog/pages/detail/index?id=' + info.value,
	// 	};
	// });
	// const onShareTimeline = (() => {
	// 	return {
	// 		title: info.value.details,
	// 		path: '/addon/blog/pages/detail/index?id=' + info.value,
	// 		// imageUrl: 'https://example.com/share-image.jpg',
	// 	};
	// });


	const addviews = () => {
		addviewsApi({ id: id.value }).then((res : any) => {

		})
	}


	function tolike() {
		let state = !info.value.islike;
		postTolikelApi({
			id: info.value.id,
			islike: state
		})
			.then((res) => {
				console.log(res)

				uni.showToast({
					icon: 'none',
					title: state ? '点赞成功' : '取消点赞'
				})
				info.value.islike = state;
				if (state) {
					info.value.like_num = info.value.like_num + 1;
				} else {
					info.value.like_num = info.value.like_num - 1;
				}
				getinfo();
			}).catch((err) => {
				if (err.code == 401) {
					if (uni.getStorageSync('ismyblog') == 1) {
						uni.setStorageSync('loginBack', '/addon/blog/pages/detail/index?id=' + info.value.id);
					}
					tourl('/app/pages/auth/index');
				}
			})
	}
	function shareh5() {
		showShareBtn.value = true
		// uni.showToast({
		// 	title: '复制顶部链接转发',icon:'none'
		// })
	}


	function checklogin() {
		showShareBtn.value = true
		// uni.showToast({
		// 	title: '复制顶部链接转发',icon:'none'
		// })
	}
</script>

<style lang="scss" scoped>
	/* 胶囊*/
	.tn-custom-nav-bar__back {
		width: 100%;
		height: 100%;
		position: relative;
		display: flex;
		justify-content: space-evenly;
		align-items: center;
		box-sizing: border-box;
		background-color: rgba(0, 0, 0, 0.15);
		border-radius: 1000rpx;
		border: 1rpx solid rgba(255, 255, 255, 0.5);
		color: #FFFFFF;
		font-size: 18px;

		.icon {
			display: view;
			flex: 1;
			margin: auto;
			text-align: center;
		}

		&:before {
			content: " ";
			width: 1rpx;
			height: 110%;
			position: absolute;
			top: 22.5%;
			left: 0;
			right: 0;
			margin: auto;
			transform: scale(0.5);
			transform-origin: 0 0;
			pointer-events: none;
			box-sizing: border-box;
			opacity: 0.7;
			background-color: #FFFFFF;
		}
	}

	/* 文章内容 start*/
	.blogger {
		&__item {
			padding: 30rpx;
		}

		&__author {
			&__btn {
				margin-right: -12rpx;
				padding: 0 20rpx;
			}
		}

		&__desc {
			line-height: 30rpx;

			&__label {

				color: #1D2541;
				background-color: #F3F2F7;
				border-radius: 10rpx;
				font-size: 22rpx;

				padding: 5rpx 15rpx;
				margin: 5rpx 18rpx 0 0;

				&--prefix {
					font-size: 24rpx;
					color: #1D2541;
					padding-right: 10rpx;
				}
			}

			&__content {
				line-height: 50rpx;
			}
		}

		&__content {
			margin-top: 18rpx;
			padding-right: 18rpx;

			&__data {
				line-height: 46rpx;
				text-align: justify;
				overflow: hidden;
				transition: all 0.25s ease-in-out;

			}

			&__status {
				margin-top: 10rpx;
				font-size: 26rpx;
				color: #82B2FF;
			}
		}

		&__main-image {
			border-radius: 16rpx;

			&--1 {
				max-width: 80%;
				max-height: 300rpx;
			}

			&--2 {
				max-width: 260rpx;
				max-height: 260rpx;
			}

			&--3 {
				height: 212rpx;
				width: 100%;
			}
		}

		&__count-icon {
			font-size: 40rpx;
			padding-right: 5rpx;
		}

		&__ad {
			width: 100%;
			height: 500rpx;
			transform: translate3d(0px, 0px, 0px) !important;

			::v-deep .uni-swiper-slide-frame {
				transform: translate3d(0px, 0px, 0px) !important;
			}

			.uni-swiper-slide-frame {
				transform: translate3d(0px, 0px, 0px) !important;
			}

			&__item {
				position: absolute;
				width: 100%;
				height: 100%;
				transform-origin: left center;
				transform: translate3d(100%, 0px, 0px) scale(1) !important;
				transition: transform 0.25s ease-in-out;
				z-index: 1;

				&--0 {
					transform: translate3d(0%, 0px, 0px) scale(1) !important;
					z-index: 4;
				}

				&--1 {
					transform: translate3d(13%, 0px, 0px) scale(0.9) !important;
					z-index: 3;
				}

				&--2 {
					transform: translate3d(26%, 0px, 0px) scale(0.8) !important;
					z-index: 2;
				}
			}

			&__content {
				border-radius: 40rpx;
				width: 640rpx;
				height: 500rpx;
				overflow: hidden;
			}

			&__image {
				width: 100%;
				height: 100%;
			}
		}
	}

	/* 文章内容 end*/

	/* 间隔线 start*/
	.tn-strip-bottom {
		width: 100%;
		border-bottom: 20rpx solid rgba(241, 241, 241, 0.8);
	}

	/* 间隔线 end*/

	/* 头像 start */
	.logo-image {
		width: 60rpx;
		height: 60rpx;
		position: relative;
	}

	.logo-pic {
		background-size: cover;
		background-repeat: no-repeat;
		// background-attachment:fixed;
		background-position: top;
		box-shadow: 0rpx 0rpx 80rpx 0rpx rgba(0, 0, 0, 0.15);
		border-radius: 50%;
		overflow: hidden;
		// background-color: #FFFFFF;
	}


	/* 底部 start*/
	.footerfixed {
		position: fixed;
		width: 100%;
		bottom: 0;
		z-index: 999;
		background-color: rgba(255, 255, 255, 0.5);
		box-shadow: 0rpx 0rpx 30rpx 0rpx rgba(0, 0, 0, 0.07);
	}

	.tabbar {
		align-items: center;
		min-height: 130rpx;
		padding: 0;
		height: calc(130rpx + env(safe-area-inset-bottom) / 2);
		padding-bottom: calc(30rpx + env(safe-area-inset-bottom) / 2);
		padding-left: 10rpx;
		padding-right: 10rpx;
	}

	/* 毛玻璃*/
	.dd-glass {
		width: 100%;
		backdrop-filter: blur(20rpx);
		-webkit-backdrop-filter: blur(20rpx);
	}

	/* 头像*/
	.avatar-all {
		width: 60rpx;
		height: 60rpx;
		border: 4rpx solid rgba(255, 255, 255, 0.05);
		border-radius: 50%;
		overflow: hidden;
		box-shadow: 0rpx 0rpx 80rpx 0rpx rgba(0, 0, 0, 0.15);
	}

	/* 内容*/
	.topic {
		position: relative;
		height: 100%;
		z-index: 1;
		margin-bottom: 120rpx;


		/* 表单信息 start */
		&__info {
			margin: 0 50rpx;
			margin-top: 105rpx;
			padding: 30rpx 51rpx;
			border-radius: 20rpx;
			background-color: rgba(255, 255, 255, 1);
			border: 2rpx solid rgba(255, 255, 255, 0.1);
			box-shadow: 0rpx 10rpx 50rpx 0rpx rgba(0, 3, 72, 0.1);

			&__item {

				&__input {
					width: 400rpx;
					height: 60rpx;
					border: 1rpx solid #E6E6E6;
					border-radius: 39rpx;

					&__left-icon {
						width: 10%;
						font-size: 44rpx;
						margin-left: 20rpx;
						margin-right: 5rpx;
					}

					&__content {
						width: 80%;
						padding-left: 10rpx;

						&--verify-code {
							width: 56%;
						}

						input {
							font-size: 30rpx;
							// letter-spacing: 0.1em;
						}
					}

					&__right-icon {
						width: 10%;
						font-size: 34rpx;
						margin-right: 20rpx;
						color: #78909C;
					}

					&__right-verify-code {
						width: 34%;
						margin-right: 20rpx;
					}
				}

				&__button {
					width: 100%;
					height: 60rpx;
					text-align: center;
					font-size: 31rpx;
					font-weight: bold;
					line-height: 77rpx;
					// text-indent: 1em;
					border-radius: 100rpx;
					color: #FFFFFF;
					background-color: rgba(255, 255, 255, 0.2);
					// border: 2rpx solid #FFFFFF;
				}

				&__sure {
					height: 60rpx;
					width: 140rpx;
				}

			}
		}
	}
</style>
<style>
	.flex {
		display: flex;
		justify-content: flex-start;
		align-items: center;
	}

	.flexb {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.flexa {
		display: flex;
		justify-content: space-around;
		align-items: center;
	}

	.flexmc {
		display: flex;
		justify-content: center;
		align-items: center;
		flex-direction: column;
	}
</style>
<style scoped>
	/deep/.input-placeholder {
		font-size: 30rpx;
		color: #C6D1D8;
	}

	.rightbox {
		position: fixed;
		z-index: 10;
		right: 30rpx;
		bottom: 15%;
		border: 1px solid #eee;
		padding: 20rpx;
		border-radius: 30px;
		background: #fff;
		box-shadow: 0 2rpx 12rpx #eee;
		font-size: 12px;
	}

	button::after {
		border: none;
	}

	button {
		color: #333;
		background-color: #fff;
		padding-left: 0;
		padding-right: 0;
		margin: 0;
		font-size: 28rpx;
		line-height: 32rpx;
	}

	.moreitem {
		width: 23%;
		height: 150rpx;
		background: #f3f3f3;
		border-radius: 10rpx;
	}

	/* <view class="rightbox">
		<view class="flexmc">
			<up-icon name="share" size="22"></up-icon>
			<view>分享</view>
		</view>
		<view class="flexmc">
			<up-icon name="grid" size="22"></up-icon>
			<view>导航</view>
		</view>
	</view>
	<view class="flex botbox" >
		<view class="left">
			<view class="flexmc item">
				<up-icon name="home" size="22"></up-icon>
				<view>首页</view>
			</view>
			<view class="flexmc  item">
				<up-icon name="plus-circle" size="22"></up-icon>
				<view>发布</view>
			</view>
		</view>
		<view class="botbtn">打电话</view>
	</view> */
</style>