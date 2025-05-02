<template>

	<view>
		<view style="position: relative;">
			<image v-if="item.top_status==1" :src="img('addon/blog/static/img/top.png')"
				style="width: 90rpx;height:90rpx;position:absolute;right:-27rpx;top:-15rpx;" mode="widthFix"></image>
			<view class="blogger__author" style="margin-bottom:20rpx">
				<view class="">
					<view class="flex" @click="tobloger(item.member_id)"
						style="width: 400rpx;">
						<view class="">
							<u-avatar shape="circle" :src="img(item.headimg)" size="50"></u-avatar>
						</view>
						<view class=" ml-[20rpx]">
							<view class="font-bold " style="font-size: 14px;">
								{{ item.nickname }}
							</view>
							<view class="tn-padding-right tn-padding-left-sm  tn-color-gray" style="font-size:12px">
								<!-- {{ $u.timeFrom(new Date(item.adddate).getTime(),false) }} -->
								{{item.adddate}}
							</view>
							<view style="width: 400rpx;">
								<text v-for="(label_item,label_index) in item.labelname" :key="label_index"
									class="blogger__desc__label ">
									<text class="tn-text-df"
										:style="['color:'+color[label_index],'border:1px solid '+color[label_index]]">{{ label_item }}</text>
								</text>
							</view>
						</view>
					</view>
					<text class="callbtn" v-if="item.mobile" @click="tocall(item.mobile)">电话联系</text>
				</view>
				<!-- <view class="blogger__author__btn justify-content-item tn-flex-col-center tn-flex-row-center">
 						<text class="tn-icon-more-vertical tn-color-gray tn-text-bold tn-text-xxl"></text>
 					</view> -->
			</view> 
			<view @click="todetail(item.id)" class="mt-[20rpx] mb-[20rpx]" :class="showquan?'':'line4'">
				<text style="color: #1677ff;" class="mr-[20rpx]">#{{item.cate_name}}<text
						v-if="item.cate_name2">-{{item.cate_name2}}</text> #</text>
				<text class="bloggerf" style="line-height:40rpx">{{ item.details }}</text>
			</view>
			
			<block v-if="item.details.length>100">
				<view v-if="!showquan" @click="showquan=true" class="u-flex" style="color: #888;">
					全文 <up-icon name="arrow-down" color="#888"></up-icon>
				</view>
				<view v-else @click="showquan=false" class="u-flex" style="color: #888;">
					收起 <up-icon name="arrow-up" color="#888"></up-icon>
				</view>
			</block>
			<view style="margin-top: 25rpx;"></view> 
			<up-album :urls="(item.imgs)" v-if="item.imgs.length" :max-count="9" :rowCount="3" :multipleSize="105"
				:singleSize="105" autoWrap></up-album>

			<view v-if="item.address" @tap.stop="toditu(item)"
				style="line-height: 20px;display:flex;font-siez:12px;margin-top:10rpx">
				<u-icon name="map" color="#999"></u-icon>
				<view class="ml-[5rpx] ml-[10rpx] text-gray" style="color:#999;font-size: 12px;">{{item.address}}
					<text v-if="item.distance>0">{{item.distance}}km</text>
				</view>
			</view>
			<view class="flex justify-between mt-[20rpx]" @click="todetail(item.id)">
				<view class="justify-content-item  tn-text-center" style="flex:1">
					<view class="flex" style="flex:1;">
						<up-icon name="eye" color="#aaa" class="blogger__count-icon"></up-icon> 
						<text class="mr-[20rpx] text-gray" style="color:#999">{{ item.views||0 }}</text>
						<up-icon name="chat" v-if="config.show_ping_num==1" color="#aaa" class="blogger__count-icon"></up-icon>
						<text class="mr-[20rpx] text-gray" v-if="config.show_ping_num==1" style="color:#999">{{ item.ping_num||0 }}</text>
						<up-icon name="heart" color="#aaa" v-if="config.show_like_num==1" class="blogger__count-icon"></up-icon>
						<!-- <up-icon name="heart-fill" class="blogger__count-icon tn-icon-fire tn-text-lg"></up-icon> -->
						<text class="text-gray" v-if="config.show_like_num==1" style="color:#999">{{ item.likenum||0 }}</text>
					</view>
				</view>
			<!-- 	<view class="flex" style="flex:1;justify-content: flex-end;align-items: center;">
					<view style="margin-left: -10rpx;margin-right: 6rpx;transform: scale(0.85);">
						<up-avatar-group :urls="item.look_headimg" size="35" gap="0.4"></up-avatar-group>
					</view>
					<text class="" style="color:#999">{{ item.look_headimg_num||0 }}人</text>
				</view> -->
			</view>

		</view>
		<!-- <commentpopup></commentpopup> -->
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { lookimg, tourl, toditu } from '@/addon/blog/utils/common';
	import commentpopup from '@/addon/blog/components/comment-popup/comment-popup.vue'
	const props = defineProps({
		item: {
			type: [String, Object],
			required: true
		},
		config: {
			type: [String, Object],
			required: true
		},
		type: {
			type: String,
			required: false
		}
	});


	// 响应式数据  
	const showquan = ref(false);
	// const urls2 = ref([]);
	// if (props.item && props.item.imgs) {
	// 	for (var i = 0; i < props.item.imgs.length; i++) {
	// 		urls2.value.push(img(props.item.imgs[i]))
	// 	}
	// }
	// console.log('urls2.value', urls2.value);

	var color = ref(["#ff0000", "#099e7e", "#6a85ff", "#008000", "#ffa500", "#c71585", "#800080",
		"#a52a2a", "#9acd32", "#ff4500", "#ff0000", "#099e7e", "#6a85ff", "#008000", "#ffa500", "#c71585", "#800080",
		"#a52a2a", "#9acd32", "#ff4500", "#ff0000", "#099e7e", "#6a85ff", "#008000", "#ffa500", "#c71585", "#800080",
		"#a52a2a", "#9acd32", "#ff4500"
	]);

	const todetail = (id) => {
		console.log(props.type);
		if (props.type == 2) return;
		tourl('/addon/blog/pages/detail/index?id=' + id)
	}

	const tocall = (mobile) => {
		uni.makePhoneCall({
			phoneNumber: String(mobile)
		})
	}
	
	const tobloger = (member_id)=>{
		if(Number(member_id)>0){
			tourl('/addon/blog/pages/bloger/index?id='+member_id)
		}
	
	}
</script>

<style scoped>
	/deep/.input-placeholder {
		font-size: 30rpx;
		color: #C6D1D8;
	}

	/deep/.u-read-more__toggle {
		justify-content: flex-start;
	}

	/deep/.u-read-more__toggle__text {
		padding-top: 20rpx;
	}

	/* .label0{
		font-size: 12px;border: 1px solid #;
	} */
	.tn-text-df {
		font-size: 10px;
		padding: 1rpx 6rpx;
		margin-right: 10rpx;
		display: inline;
	}

	.callbtn {
		border: 1px solid #1677ff;
		color: #fff;
		background-color: #1677ff;
		padding: 8rpx 15rpx;
		border-radius: 8rpx;
		font-size: 12px;
		position: absolute;
		right: 20rpx;
		top: 20rpx
	}
</style>
<style lang="scss" scoped>
	.album {
		@include flex;
		align-items: flex-start;

		&__avatar {
			background-color: #eee;
			padding: 5px;
			border-radius: 3px;
		}

		&__content {
			margin-left: 10px;
			flex: 1;
		}
	}
	.line4{
		display: -webkit-box;
		-webkit-box-orient: vertical;
		-webkit-line-clamp: 5;
		overflow: hidden;
	}
</style>