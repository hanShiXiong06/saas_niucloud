<template>
	<!-- 评论 -->
	<view>

		<!-- 评论区域 S -->
		<view v-if="blogComList.length>0">
			<view class="comment-container" v-for="(item,index) in blogComList" :key="item.id">
				<view class="com-user" v-if="item.member">
					<view class="user-img">
						<up-avatar @tap="tourl(`/addon/blog/pages/bloger/index?id=${item.member_id}`)"
							:src="img(item.member.headimg)" size="40"></up-avatar>
					</view>
					<view class="user-messge">
						<view @tap="tourl(`/addon/blog/pages/bloger/index?id=${item.member_id}`)" class="msg-name">
							{{ item.member.nickname }}
						</view>
						<view class="msg-date">{{ item.adddate }}</view>
					</view>
					<view @click.stop="commentLikel(item,index,0)" class="user-like flex mt-[10rpx]">

						<up-icon name="heart-fill" v-if="item.like_num" color="#ff4c7c"></up-icon>
						<up-icon name="heart" v-else></up-icon>
						<text class="like-num">{{ item.like_num }}</text>
					</view>
				</view>
				<view class="com-list">
					<view @tap.stop="commentBackOpen(item,0)" class="list-operation">
						<text class="list-content" user-select>{{ item.details }}</text>
						<text class="list-op-txt" v-if="config?.open_ping==1"
							@tap.stop="commentBackOpen(item,0)">回复</text>
						<text @click.stop="deleteComment(item.id)" v-if="item.is_mine==1 || tieData.isself==1"
							style="color:red" class="list-op-txt">删除</text>
					</view>
					<view style="background-color: #f8f7f8;border-radius: 15rpx;margin-top: 20rpx;">
						<view class="com-list-back" v-for="(backlevel,backlevelIndex) in item.children"
							:key="backlevel.id">
							<!-- @tap.stop="commentBackOpen(backlevel,1)" -->
							<view class="back-title">
								<text class="back-title-username">
									<text
										@tap.stop="tourl(`/addon/blog/pages/bloger/index?id=${backlevel.member_id}`)">{{ backlevel.member_name }}</text>
									<text class="tn-color-gray">{{'&nbsp;'+'回复'+'&nbsp;'}}</text>
									<text
										@tap.stop="tourl(`/addon/blog/pages/bloger/index?id=${backlevel.to_member_id}`)">@{{backlevel.to_member_name||''}}：</text>
								</text>
								<text class="back-title-content" v-if="config?.open_ping==1"
									@tap.stop="commentBackOpen(backlevel)" user-select>{{ backlevel.details }}</text>
								<text class="list-op-txt" @tap.stop="commentBackOpen(backlevel)">回复</text>
								<text @click.stop="deleteComment(backlevel.id)" style="color:red"
									v-if="backlevel.is_mine==1 || tieData.isself==1" class="list-op-txt">删除</text>
							</view>
							<view class="back-date">
								<view class="date-left">
									{{ backlevel.adddate }}
								</view>
								<view @click.stop="commentLikel(backlevel,backlevelIndex,1)"
									class="back-right flex ml-[10rpx]">
									<text class="back-right-num">{{ backlevel.like_num }}</text>
									<up-icon name="heart-fill" v-if="backlevel.islike" color="#ff4c7c"></up-icon>
									<up-icon name="heart" v-else></up-icon>
								</view>
							</view>
						</view>
					</view>
				</view>
			</view>
		</view>
		<view v-else>
			<view style="width: 100%;height: auto;display: flex;justify-content: center;align-items: center;">
				<view>
					<view style="width: 100%;display: flex;justify-content: center;align-items: center;color: #9f9f9f;">
						<image style="width: 400rpx;height: 400rpx;"
							src="https://qny.wdsp666.com/%E7%A6%8F%E8%A2%8B%E8%83%8C%E6%99%AF%E5%9B%BE/no_comment.png">
						</image>
					</view>
					<view
						style="width: 100%;display: flex;justify-content: center;align-items: center;color: rgb(140 162 212);font-size: 33rpx;">
						暂时没有人评论，快来抢个沙发吧</view>
				</view>
			</view>
		</view>



		<!-- 回复评论弹框 S -->
		<up-popup :show="openCommentModal" :round="10" mode="center" confirm-text="回 复" title="留 言"
			@close="openCommentModal = false">

			<view class="com-back-content" style="width:590rpx;padding:10rpx 2% 30rpx">
				<view style="text-align: center;font-size: 16px;margin:18rpx 0;">回 复</view>
				<textarea placeholder-style="width: 100%;"
					style="width: 90%;background-color: #f8f8f8;padding:25rpx 3%;border-radius: 15rpx;"
					v-model="backComment" cols="30" rows="10" :placeholder="placeholderText"></textarea>
				<view class="flex">
					<up-button text="取消" @click="openCommentModal = false" plain
						style="margin:25rpx 10rpx 0"></up-button>
					<up-button text="确定" @click="submitBack" type="primary" style="margin:25rpx 30rpx 0"></up-button>
				</view>
			</view>
		</up-popup>
		<view style="height:130rpx"></view>
		<view class="tabbar footerfixed" v-if="config?.open_ping==1" style="background: #fff;">
			<view class="flex" style="margin:30rpx 3% 0">
				<view class="left flex" style="margin:0 20rpx">
					<view class="flexmc item" @click="tourl('/addon/blog/pages/home/index',2)" style="margin-right: 25rpx;">
						<up-icon name="home" size="22"></up-icon>
						<view>首页</view>
					</view>
					<view class="flexmc  item"  @click="tourl('/addon/blog/pages/create/cate',2)" style="margin-right: 25rpx;">
						<up-icon name="plus-circle" size="22"></up-icon>
						<view>发布</view>
					</view>
				</view>
				<view class="justify-content-item tn-margin-top" style="margin-right: 30rpx ;flex:1">
					<up-input placeholder="输入您想说的话" border="surround" shape="circle" v-model="newComment"></up-input>
				</view>
				<view style="width:170rpx">
					<view shape="circle" type="primary" @click="sendComment"
						style="background: #3668fc;border-radius: 30px;text-align: center;line-height: 72rpx;color:#fff;">
						发 送
					</view>
				</view>
			</view>
			
			<!-- <view class="flex botbox" >
				<view class="left flex">
					<view class="flexmc item" @click="tourl('/addon/blog/pages/home/index',2)">
						<up-icon name="home" size="22"></up-icon>
						<view>首页</view>
					</view>
					<view class="flexmc  item"  @click="tourl('/addon/blog/pages/create/cate',2)">
						<up-icon name="plus-circle" size="22"></up-icon>
						<view>发布</view>
					</view>
				</view>
				<view class="botbtn">打电话</view>
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
	import {
		getBlogCommentApi,
		postBlogCommentApi,
		delBlogApi,
		postCommentlikelApi,
		complaint,
		commentDel
	} from '@/addon/blog/api/ping'

	import { getTieDetail, getConfigApi } from '@/addon/blog/api/tie'

	var id = '';
	const props = defineProps({
		tie_id: {
			type: String
		}
	});
	const config = ref([]);
	onMounted(() => {
		id = props.tie_id;
		getBlogComlist();
		getTieDetailA();



		getConfigApi({}).then(res => {
			config.value = res.data;
			// config.value.open_ping=1
		})

	})

	const getTieDetailA = () => {
		getTieDetail({ id: props.tie_id }).then((res : any) => {
			tieData.value = res.data

		})
	}
	function getBlogComlist() {
		getBlogCommentApi({
			tid: props.tie_id
		}).then((res) => {
			blogComList.value = formatData(res.list)
			console.log('评论', blogComList.value);

			emitEvent();
		})
	}

	const emit = defineEmits(['custom-event']);

	function emitEvent() {
		emit('update', 1);
	}

	// function getCommentList() {
	// 	tieData.value = []
	// 	getMarketDetailApi({
	// 		id: id,
	// 		ispage: 1
	// 	})
	// 		.then((res) => {
	// 			tieData.value.push(res.data)
	// 			tieData.value.nickname = res.data.member.nickname
	// 			tieData.value.avatar = res.data.member.headimg
	// 			memberInfo.value = res.memberInfo
	// 			getBlogComlist()
	// 			console.log(res, tieData.value);
	// 		})
	// }

	// const getPingA = () => {
	// 	getPing({ tie_id: tie_id.value }).then((res : any) => {
	// 		pinglist.value = res.data
	// 	})
	// }

	// 定义数据和方法
	const tieData = ref([]);
	const blogComList = ref([]);
	const memberInfo = ref({});
	const openCommentModal = ref(false);
	const backComment = ref('');
	const newComment = ref('');
	const likeStatus = ref(false);
	const selectedComplainTypeIndex = ref(-1);
	const complainContent = ref('');
	const placeholderText = ref('');
	const showComplainType = ref(false);

	function deleteComment(id) {
		uni.showModal({
			content: '确定删除吗?',
			title: '提示',
			success(res) {
				if (res.confirm) {
					commentDel({
						id: id
					})
						.then((res) => {
							uni.showToast({
								icon: 'none',
								title: "评论已删除"
							})
							getBlogComlist();
						})
				}
			}
		})
	}

	function complain() {
		complaint({
			tid: id,
			content: complainContent.value,
			type: complainTypeList[selectedComplainTypeIndex.value].name
		})
			.then((res) => {
				showComplainType.value = false;
				complainContent.value = '';
				selectedComplainTypeIndex.value = -1;
				uni.showToast({
					icon: 'none',
					title: "已投诉，请等待管理员审核"
				})
			})
	}

	function selectedcomplainTypeItem(index) {
		if (index === selectedComplainTypeIndex.value) {
			selectedComplainTypeIndex.value = -1;
		} else {
			selectedComplainTypeIndex.value = index;
		}
	}


	function commentLikel(item, index, type) {
		postCommentlikelApi({
			id: item.id
		})
			.then((res) => {
				uni.showToast({
					icon: 'none',
					title: item.islike ? '取消点赞' : '点赞成功'
				})
				getBlogComlist();
				getTieDetailA();
			}).catch((err) => {
				if (err.code == 401) {
					if (uni.getStorageSync('ismyblog') == 1) {
						uni.setStorageSync('loginBack', '/addon/blog/pages/detail/index?id=' + tieData.value.id);
					}
					tourl('/app/pages/auth/index');
				}
			})
	}


	function saveFollow(item) {
		let state = !tieData.value.isfollow;
		postBlogerFollowlApi({
			touid: item.uid,
			isfollow: state
		})
			.then((res) => {
				uni.showToast({
					icon: 'none',
					title: item.isfollow ? '取消关注' : '关注成功'
				})
				tieData.value.isfollow = state;
				getBlogComlist();
				getTieDetailA();
			}).catch((err) => {
				if (err.code == 401) {
					if (uni.getStorageSync('ismyblog') == 1) {
						uni.setStorageSync('loginBack', '/addon/blog/pages/detail/index?id=' + tieData.value.id);
					}
					tourl('/app/pages/auth/index');
				}
			})
	}



	function formatData(data) {
		return data.reduce((prev, next) => {
			next.children = next.children.map((i) => ({
				...i
			}))
			prev.push(next)
			console.log(prev, "==========prev")
			return prev
		}, [])
	}



	function tolike() {
		let state = !tieData.value.islike;
		postTolikelApi({
			id: tieData.value.id,
			islike: state
		})
			.then((res) => {
				uni.showToast({
					icon: 'none',
					title: state ? '点赞成功' : '取消点赞'
				})
				tieData.value.islike = state;
				if (state) {
					tieData.value.like_num = tieData.value.like_num + 1;
				} else {
					tieData.value.like_num = tieData.value.like_num - 1;
				}
				getBlogComlist();
				getTieDetailA();
			}).catch((err) => {
				if (err.code == 401) {
					if (uni.getStorageSync('ismyblog') == 1) {
						uni.setStorageSync('loginBack', '/addon/blog/pages/detail/index?id=' + tieData.value.id);
					}
					tourl('/app/pages/auth/index');
				}
			})
	}

	var hf_id = '';
	var bid = '';
	function commentBackOpen(item, type) {
		console.log(item, "===========item")
		if (type == 0) {
			placeholderText.value = '回复:' + item.member.nickname || '微信用户';
		} else {
			placeholderText.value = '回复:' + item.member_name || '微信用户';
		}

		openCommentModal.value = true
		hf_id = item.id
		bid = item.id
	}

	function topTz() {
		uni.showToast({
			icon: 'none',
			title: '敬请期待'
		})
	}

	function submitBack() {
		if (backComment.value === '') {
			uni.showToast({
				icon: 'none',
				title: '说点什么吧'
			})
			return
		}
		postBlogCommentApi({
			tid: Number(id),
			bid: bid,
			hf_id: hf_id,
			comment: backComment.value
		}).then((res) => {
			backComment.value = ''
			getBlogComlist()
			openCommentModal.value = !openCommentModal.value
		}).catch((err) => {
			console.log(err)
			if (err.code == 401) {
				if (uni.getStorageSync('ismyblog') == 1) {
					uni.setStorageSync('loginBack', '/addon/blog/pages/detail/index?id=' + tieData.value.id);
				}
				tourl('/app/pages/auth/index');
			}
		})
	}

	function changLike() {
		likeStatus.value = !likeStatus.value
	}

	function sendComment() {

		if (newComment.value === '') {
			return uni.showToast({
				icon: 'none',
				title: '请输入评论！'
			})
		}
		console.log(tieData.value.id)
		postBlogCommentApi({
			tid: tieData.value.id,
			comment: newComment.value
		})
			.then((res) => {
				if (res) {
					uni.showToast({
						icon: 'none',
						title: '发表成功'
					})
					newComment.value = ''
					getBlogComlist();
					getTieDetailA();
				}
			}).catch((err) => {
				if (err.code == 401) {
					if (uni.getStorageSync('ismyblog') == 1) {
						uni.setStorageSync('loginBack', '/addon/blog/pages/detail/index?id=' + tieData.value.id);
					}
					tourl('/app/pages/auth/index');
				}
			})
	}

	function delBlog(id) {
		//confirm
		uni.showModal({
			title: '提示',
			content: '确定删除吗？',
			success: (res) => {
				if (res.confirm) {
					delBlogApi({
						id: id
					}).then((res) => {
						uni.showToast({
							icon: 'none',
							title: '删除成功'
						})
						uni.$emit('delBlog')
						uni.navigateBack();
						//跳转到 blog-page/home/index
						// uni.navigateTo({
						// 	url: `/blog-page/home/index`
						// })
					})
				}
			}
		})
	}



	// function childFunction() {
	// 	// 函数的具体实现逻辑
	// 	console.log('子组件函数被调用');
	// }

	// // 暴露子组件的函数，以便父组件调用
	// defineExpose({
	// 	childFunction
	// });


	// const toPing = (ping_id) => {
	// 	toPing({ ping_id: ping_id.value, tie_id: id.value }).then((res : any) => {
	// 		uni.showToast({
	// 			title: '提交成功'
	// 		})
	// 		setTimeout(function () {
	// 			getPing();
	// 		}, 1000);
	// 	})
	// }
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
		bottom: 10rpx;
		z-index: 999;
		background-color: rgba(255, 255, 255, 0.5);
		box-shadow: 0rpx 0rpx 30rpx 0rpx rgba(0, 0, 0, 0.07);
	}

	.tabbar {
		align-items: center;
		min-height: 130rpx;
		padding: 0;
		// height: calc(130rpx + env(safe-area-inset-bottom) / 2);
		// padding-bottom: calc(30rpx + env(safe-area-inset-bottom) / 2);
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

	// 列表项
	.card {
		display: flex;
		flex-direction: column;
		padding: 20rpx;
		background-color: white;
		margin-top: 20rpx;

		.card-item {
			padding: 20rpx;

			.title-item {
				display: flex;
				flex-direction: row;
				margin: 5rpx 0rpx;

				.user-img {
					width: 100rpx;
					height: 100rpx;
					margin-right: 20rpx;

					image {
						width: 100%;
						height: 100%;
						border-radius: 50%;
					}
				}

				.user-messge {
					flex: 3;
					display: inline-flex;
					flex-direction: column;
					justify-content: center;

					.msg-title {
						font-size: 32rpx;
						font-weight: bold;
						margin-bottom: 5rpx;
					}

					.msg-date {
						font-size: 24rpx;
						color: #a3a1a5;
					}
				}

				.user-btn {
					background-color: #e9dcd5;
					color: #985a39;
					height: 50rpx;
					border-radius: 50rpx;
					padding: 0rpx 20rpx;
					line-height: 50rpx;
					font-weight: bold;
					text-align: center;
				}
			}

			.txt-item {
				.tips {
					background-color: #ffaa00;
					padding: 5rpx 20rpx;
					border-radius: 40rpx;
					color: white;
				}

				.tips-message {
					padding: 5rpx 20rpx;
				}
			}

			.img-item {
				width: 100%;
			}

			.operation-item {
				padding: 20rpx 0;

				.op-left {
					margin-left: auto;
					color: #AAAAAA;

					.op-icon {
						font-size: 40rpx;
						margin-right: 10rpx;
					}
				}

				.op-right {
					flex: 1;
					display: inline-flex;
					flex-direction: row;

					&-num {
						line-height: 50rpx;
						color: #AAAAAA;
						margin-left: 10rpx;
						letter-spacing: 10rpx;
					}
				}
			}
		}

	}

	// 评论列表
	.list-op-txt {
		margin-right: 20rpx;
		color: #006FFF;
		font-size: 12px;
		flex-shrink: 0;
		display: inline-block;
	}

	.comment-container {
		margin: 25rpx 40rpx 40rpx 40rpx;
		display: flex;
		flex-direction: column;

		.com-user {
			display: flex;
			flex-direction: row;

			.user-img {
				width: 70rpx;
				height: 70rpx;
				margin-right: 20rpx;

				image {
					border-radius: 50%;
					width: 100%;
					height: 100%;
				}
			}

			.user-messge {
				display: inline-block;
				justify-content: center;
				flex-direction: column;
				flex: 3;

				.msg-name {
					font-weight: bold;
				}

				.msg-date {
					font-size: 24rpx;
					color: #AAAAAA;
				}

			}

			.user-like {
				margin-left: auto;
				display: inline-flex;
				flex-direction: column;

				.like-icon {
					font-size: 32rpx;
					color: #AAAAAA;
				}

				.like-num {
					text-align: center;
					color: #AAAAAA;
				}
			}
		}

		.com-list {
			width: 87%;
			margin-left: auto;
			margin-top: 0;

			.list-operation {

				.list-content {
					margin-right: 20rpx;
				}
			}

			.com-list-back {
				// margin-top: 20rpx;

				padding: 20rpx 20rpx 0;

				.back-title {
					margin-bottom: 10rpx;

					.back-title-username {
						font-weight: bold;
						color: #555;
					}

					.back-title-content {
						margin-right: 20rpx;
					}
				}

				.back-date {
					display: flex;
					flex-direction: row;

					.date-left {
						flex: 1;
						font-size: 24rpx;
						color: #AAAAAA;
					}

					.back-right {
						margin-left: auto;

						&-num {
							color: #AAAAAA;
						}

						&-icon {
							color: #AAAAAA;
						}
					}
				}

			}
		}
	}
</style>
<style>
	.flex{
		display: flex;justify-content: flex-start;align-items: center;
	}
	.flexb{
		display: flex;justify-content: space-between;align-items: center;
	}
	.flexa{
		display: flex;justify-content: space-around;align-items: center;
	}
	
	 .flexmc{
	                display: flex;justify-content: center;align-items: center;flex-direction: column;
	            }
</style>
<style scoped>
	/deep/.input-placeholder {
		font-size: 30rpx;
		color: #C6D1D8;
	}
	.rightbox{
		z-index: 10;right: 30rpx;bottom: 20%;border: 1px solid #eee;padding: 20rpx;border-radius: 30px;background: #fff;	box-shadow: 0 2rpx 12rpx #eee;font-size: 12px;
	}
	
	.botbox{
		z-index: 10;right: 0;left: 0;width: 100%;bottom: 0;background: #fff;border-top: 1px solid #eee;
		display: flex;padding: 10rpx 3%;
	}
	.botbox .left{
		flex:1;
	}
	.botbox .left .item{
		flex:1;
	}
	.botbtn{
		
		width: 350rpx;background: #1677ff;height: 75rpx;color: #fff;border-radius: 10rpx;text-align: center;line-height: 75rpx;margin: 0 50rpx;
	}
</style>