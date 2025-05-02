<template>
	<view>
		<view class="article_details" style="padding: 25rpx;">
			<!-- <view class="article_info">
				<view class="article_title">{{''+detail.name+''}}</view>
				<view class="info">
					<text class="article_date">{{detail.adddate}}</text>
					<text class="article_author" v-if="detail.author">{{'作者:'+detail.author}}</text>
				</view>
			</view> -->
			<view class="detail_content">
				<u-parse :content="detail.content" ref="article" :tag-style="tagStyle"></u-parse>
			</view>
					<up-empty style="margin-top: 160rpx;"  v-if="!detail.content"></up-empty>
			<!-- <view class="details_btn">
				<view class="atten_btn">
					<text class="iconfont icon-icon-user"></text>
					<text>{{detail.like_num==null?0:detail.like_num}}</text>
				</view>
				<view class="collect_btn">
					<text class="iconfont icon-follow"></text>
					<text>{{detail.look_num==null?0:detail.look_num}}</text>
				</view>
			</view> -->
		</view>

	</view>
</template>

<script>
	// import parser from '@/addon/blog/components/jyf-parser/jyf-parser';
	var that;
	let app = getApp();
	import {
		getShequndetailApi
	} from '@/addon/blog/api/shequn'
	import {
		redirect,
		img
	} from '@/utils/common';
	import {
		lookimg,
		tourl
	} from '@/addon/blog/utils/common';

	export default {
		components: {
			// 'jyf-parser': parser
		},
		data() {
			return {
				tagStyle: {
					img: 'width:100%;'
				},

				detail: {},
				id: ''
			}
		},
		onLoad(options) {
			this.id = options.id
			that = this;
		},
		onShow() {
			that.getdetail();

		},
		methods: {

			getdetail(ispage) {
				var that = this;
				getShequndetailApi({
					id: that.id
				}, false).then(res => {
					var detail = res.data;
					if (detail.content) {
						detail.content = detail.content.replace(/\<img/g,
							'<img style="width:100%;height:auto;display:block;"');
					}
					that.detail = detail;

				})
			},

		},
	}
</script>
