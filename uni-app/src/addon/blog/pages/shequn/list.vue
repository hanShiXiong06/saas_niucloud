<template>
	<view class=" flex">
		<scroll-view scroll-y="" class="catebox" style="width: 180rpx;margin-right: 20rpx;">
			<view class="item" :class="where.cate_id==''?'on':''" @click="changeTab('')">全部</view>
			<view v-for="(item,index) in catelist" class="item" :class="where.cate_id==item.id?'on':''"
				@click="changeTab(item.id)">{{item.name}}</view>
		</scroll-view>
		<view class="" style="flex:1;width: 550rpx;background: #fff;padding: 20rpx;margin: 20rpx 20rpx 20rpx 240rpx;">
			<view class="flexmc" v-for="(item,index) in newsList" :key="index" @click="tourl('./detail?id='+item.id)"
				style="width:33.2%;float: left;padding: 20rpx 0;">
				<image mode="aspectFill" :src="img(item.image)" style="width: 100rpx;height: 100rpx;"></image>
				<view class="item_title line1" style="width:150rpx;text-align: center;">{{''+item.name+''}}</view>
			</view>
			<up-empty style="margin-top: 160rpx;"  v-if="!newsList.length && loading"></up-empty>
			<view style="clear: both;"></view>
		</view>


		<view style="height: 150rpx;"></view>
		<view style="position: relative;z-index: 5;">
			<up-tabbar :value="4" :fixed="true" :placeholder="false" :safeAreaInsetBottom="false">
				<up-tabbar-item text="圈子首页" icon="home" @click="tourl('/addon/blog/pages/home/index',1)"></up-tabbar-item>
				<up-tabbar-item text="发布帖子" v-if="config?.open_fatie==1" icon="plus-circle"
					@click="tourl('/addon/blog/pages/create/cate',1)"></up-tabbar-item>
				<up-tabbar-item text="我的帖子" v-if="config?.open_fatie==1" icon="order"
					@click="tourl('/addon/blog/pages/my/tie',1)"></up-tabbar-item>
				<up-tabbar-item text="微信群" v-if="config?.open_shequn==1" icon="grid"
					@click="tourl('/addon/blog/pages/shequn/list',1)"></up-tabbar-item>
				<up-tabbar-item text="个人中心" icon="account" @click="tourl('/app/pages/member/index',2)"></up-tabbar-item>
			</up-tabbar>
		</view>

	</view>
</template>

<script>
	var that;
	let app = getApp();
	import {
		getShequnlistApi,
		getShequncateApi
	} from '@/addon/blog/api/shequn'
	import {
		redirect,
		img
	} from '@/utils/common';
	import {
		lookimg,
		tourl
	} from '@/addon/blog/utils/common';
	import {
		getConfigApi
	} from '@/addon/blog/api/tie'
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
					cate_id: '',
				},
				inputword: '',

				showbacktop: false,
				catelist: [],
				current: -1,
				defaultImg: this.$baseImg + "img/wine4.jpg",
				tabs: [],
				emptyShow: !1,
				config: ''
			}
		},
		onLoad(options) {
			that = this;

			var cate_id = options.cate_id;
			if (Number(cate_id) > 0) {
				this.where.cate_id = Number(cate_id);
				// this.current = Number(cate_id);
			}
			this.getcatelist();
			this.reload(true);

			getConfigApi({}).then(res => {
				this.config = res.data;
			})
		},
		onShow() {


		},
		methods: {
			tourl: tourl,
			img,
			//关键词
			getcatelist() {
				var that = this;
				getShequncateApi().then(res => {
					that.catelist = res.data;
					that.current = Number(that.where.cate_id || 0) - 1;
					console.log(that.current);
				})
			},
			changeTab(e) {
				console.log(e);
				this.where.cate_id = e;
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
				getShequnlistApi(that.where).then(res => {
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
	page {
		background: #f5f5f5 !important;
	}
</style>
<style scoped>
	@import '@/addon/blog/static/css/base.css';

	view {
		display: block;
	}

	.catebox {
		background: #fff;
		padding: 0 20rpx;
		position: fixed;
		left: 0;
		top: 0;
	}

	.catebox .item {
		margin: 35rpx 0;
		text-align: center;
		border-left: 5rpx solid #fff;
		padding-left: 10rpx;
	}

	.catebox .item.on {
		color: #2d5fff;
		border-left: 5rpx solid #2d5fff;
	}
</style>