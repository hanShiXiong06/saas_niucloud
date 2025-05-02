<template>
	<view class="body">

		<view class="article_list">
			<view class="list" style="margin-top: 0rpx;">
				<view class="list_item" v-for="(item,index) in newsList" :key="index"
					@click="tourl('./detail?id='+item.id)" style="background: #fff;border-bottom: 1px solid #eee;">
					<!-- <image class="data-v-6c321a2c" mode="aspectFill" :src="item.image"></image> -->
					<view class="item_text">
						<view class="item_title">{{''+item.name+''}}</view>
						<view class="desction" style="margin-top: 25rpx;">{{''+item.adddate+''}}</view>
					</view>
					<view class="iconfont icon-youjiantou"></view>
				</view>
			</view>
			<up-empty style="margin-top: 160rpx;"  v-if="!newsList.length && loading"></up-empty>
		</view>
	</view>
</template>

<script>
	var that;
	let app = getApp();
	import {
		getNewslistApi
	} from '@/addon/blog/api/news'
	import {
		redirect,
		img
	} from '@/utils/common';
	import {
		lookimg,
		tourl
	} from '@/addon/blog/utils/common';
	export default {
		components: {},
		data() {
			return {
				newsList: [],

				loading: false,
				loadend: false,
				where: {
					page: 1,
					rows: 10,
					keyword: '',
					catid: '',
				},
				inputword: '',

				showbacktop: false,
				catelist: [],
				current: -1,
				defaultImg: this.$baseImg + "img/wine4.jpg",
				tabs: [],
				emptyShow: !1,
			}
		},
		onLoad(options) {
			that = this;

			var cate_id = options.cate_id;
			if (Number(cate_id) > 0) {
				this.where.cate_id = Number(cate_id);
				// this.current = Number(cate_id);
			}
			// this.getcatelist();
			this.reload(true);
		},
		onShow() {


		},
		methods: {
tourl:tourl,
			//关键词
			getcatelist() {
				var that = this;
				this.$api.http.get('news/catelist', {}, false).then(res => {
					that.catelist = res.data;
					that.current = Number(that.where.cate_id || 0) - 1;
					console.log(that.current);
				})
			},
			changeTab(e) {
				console.log(e);
				this.where.cate_id = this.catelist[e].id;
				this.reload(true)
			},
			// 输入搜索
			inputKey: function(e) {
				this.inputword = e.detail.value;
			},
			inputconfirm() {
				this.$set(this.where, 'keyword', this.inputword);
				this.reload(true)
			},
			clearinput() {
				this.inputword = '';
				this.$set(this.where, 'keyword', this.inputword);
				this.reload(true)
			},
			// 知识文章
			getlist(isPage) {
				var that = this;
				if (that.loadend) return;
				if (that.loading) return;

				that.loading = true;
				that.loadTitle = '';
				getNewslistApi(that.where).then(res => {
					//console.log(res.data);
					if (isPage === true) that.$set(that, 'newsList', []);
					let list = res.data.data;
					let lists = that.SplitArray(list, that.newsList);
					let loadend = list.length < that.where.rows;
					that.newsList = lists;
					// that.total = res.list.total;
					that.loadend = loadend;
					that.loading = false;

					that.$set(that.where, 'page', that.where.page + 1);
				})
			},
			SplitArray(list, sp) {
				if (typeof list != 'object') return [];
				if (sp === undefined) sp = [];
				for (var i = 0; i < list.length; i++) {
					sp.push(list[i]);
				}
				return sp;
			},
			reload(isPage) {
				if (isPage === true) {
					this.loadend = false;
					this.$set(this.where, 'page', 1);
				}
				this.getlist(isPage);
			},

			// 返回顶部
			backtop() {
				uni.pageScrollTo({
					scrollTop: 0,
					duration: 100,
				});
			},
			onPageScroll(e) { //根据距离顶部距离是否显示回到顶部按钮
				if (e.scrollTop > 50) { //当距离大于10时显示回到顶部按钮
					this.showbacktop = true
				} else {
					this.showbacktop = false
				}
			},
			changenav(id) {
				this.$set(this.where, 'catid', id);
				this.reload(true);
			},
			tonewsDetail(item) {
				console.log(item);
				uni.navigateTo({
					url: '/pages/news/newsDetail/newsDetail?id=' + item.targetId
				})
			}
		},

		onPullDownRefresh() {
			this.reload(true)
			setTimeout(() => {
				uni.stopPullDownRefresh()
				//this.tui.toast("刷新成功");
			}, 200);
		},
		onReachBottom() {
			this.reload()
		},
	}
</script>

<style>
	page{
		background: #f5f5f5 !important;
	}
	.article_list .v-tabs__container-item {
		font-size: 1rem !important;
		padding: 0;
	}

	.article_list .list {
		border-top: 0 solid #f4f4f4;
	}

	.article_list .list_item {
		padding: 24rpx;
		position: relative;
	}

	.article_list .list_item .item_title{
		font-size: 16px;
	}
	.article_list .list_item image {
		vertical-align: middle;
	}

	.article_list .list_item image {
		height: 100rpx;
		width: 100rpx;
	}

	.article_list .list_item .item_text {
		display: inline-block;
		line-height: 1.5;
		margin-left: 24rpx;
		vertical-align: middle;
		width: 75%;
	}

	.article_list .list_item .item_text .item_title {
		display: inline-block;
		font-size: 28rpx;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
		width: 100%;
	}

	.article_list .list_item .item_text .desction {
		-webkit-line-clamp: 3;
		-webkit-box-orient: vertical;
		color: #666;
		display: inline-block;
		display: -webkit-box;
		font-size: 24rpx;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.article_list .list_item .icon-youjiantou {
		color: #b7b7b7;
		font-size: 28rpx;
		position: absolute;
		right: 24rpx;
		top: 50%;
		transform: translateY(-50%);
	}
</style>