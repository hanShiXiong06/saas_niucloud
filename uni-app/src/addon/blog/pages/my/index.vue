<template>
	<view>
		
		<view v-if="info?.member_id" @click="tourl('/app/pages/member/personal')" style="height: 200rpx;padding: 40rpx 3% 60rpx;background: #ffd966;color: #333;">
			<view style="align-items: center;display: flex;">
				<image :src="img(info?.headimg||'addon/blog/static/img/headimg.png')" style="width: 120rpx;height:120rpx;border-radius: 50%;margin-right: 30rpx;border: 1px solid #eee;background: #eee;" mode=""></image>
				<view>
					<view class="font-bold text--[16px] mb-[10rpx]">{{info?.nickname}}</view>
					<view style="font-size: 12px;">UID: {{info?.member_id}}</view>
				</view>
			</view>
			<text  class="nc-iconfont nc-icon-shezhiV6xx-1 text-[40rpx] ml-[10rpx]" style="color:#333;position: absolute;right: 30rpx;top:30rpx;"><span></span></text>
		</view>
		<view v-else @click="tourl('/app/pages/auth/login')" style="height: 200rpx;padding: 40rpx 3% 100rpx;background: #ffd966;color: #333;">
			<view style="align-items: center;display: flex;">
				<image :src="img('@/static/resource/images/default_headimg.png')" style="width: 120rpx;height:120rpx;border-radius: 50%;margin-right: 30rpx;border: 1px solid #eee;" mode=""></image>
				<view>
					<view class="font-bold text--[16px] mb-[10rpx]">登录/注册</view>
				</view>
			</view>
			<text  class="nc-iconfont nc-icon-shezhiV6xx-1 text-[40rpx] ml-[10rpx]" style="color: #333;position: absolute;right: 30rpx;top:30rpx;"><span></span></text>
		</view>
		
		
		
		<view v-if="config?.open_fatie==1" style="padding:25rpx 3%;background-color: #fff;position: relative;z-index:2;margin:-80rpx 3% 20rpx;border-radius: 15rpx;">
			<view style="font-weight: bold;font-size: 16px;margin:10rpx 0 20rpx;">功能专区</view>
			<view style="display:flex;align-items: center;font-size: 14px;">
				<view @click="tourl('/addon/blog/pages/create/cate',1)" style="display: flex;justify-content: space-between;flex-direction: column;flex:1;align-items: center;">
					<image :src="img('addon/blog/static/img/fabu.png')" style="width:70rpx;height:70rpx;margin-bottom:10rpx"></image>
					<text>发布帖子</text>
				</view>
				<view @click="tourl('/addon/blog/pages/my/tie',0)" style="display: flex;justify-content: space-between;flex-direction: column;flex:1;align-items: center;">
					<image :src="img('addon/blog/static/img/horz_m_personal.png')" style="width:60rpx;height:60rpx;margin-bottom:10rpx"></image>
					<text>我的帖子</text>
				</view>
				<view @click="tourl('/addon/blog/pages/my/zan',0)" style="display: flex;justify-content: space-between;flex-direction: column;flex:1;align-items: center;">
					<image :src="img('addon/blog/static/img/dianzan.png')" style="width:70rpx;height:70rpx;margin-bottom:10rpx"></image>
					<text>我的点赞</text>
				</view>
			</view>
		</view>
		
		
		<view style="padding:5rpx 3%;background-color: #fff;position: relative;z-index:2;margin:0 3% 20rpx;border-radius: 15rpx;">
			
			<view @click="tourl('/app/pages/member/personal')" style="display: flex;justify-content: space-between;margin:55rpx 0">
				<view style="display: flex;align-items: center">
					<image :src="img('addon/blog/static/img/vert_m_personal.png')" style="width:50rpx;height:50rpx;margin-right:10px"></image>
					<text>个人资料</text>
				</view>
				<up-icon name="arrow-right"></up-icon>
			</view>
			<button open-type="contact" style="display: flex;justify-content: space-between;margin:55rpx 0;background: none;font-size: 14px;padding:0">
				<view style="display: flex;align-items: center">
					<image :src="img('addon/blog/static/img/vert_m_service.png')" style="width:50rpx;height:50rpx;margin-right:10px"></image>
					<text>联系客服</text>
				</view>
				<up-icon name="arrow-right"></up-icon>
			</button>
			<view  @click="tourl('/app/pages/setting/index')" style="display: flex;justify-content: space-between;margin:55rpx 0">
				<view style="display: flex;align-items: center">
					<image :src="img('addon/blog/static/img/setup.png')" style="width:50rpx;height:50rpx;margin-right:10px"></image>
					<text>设置</text>
				</view>
				<up-icon name="arrow-right"></up-icon>
			</view>
			<view  @click="memberStore.logout(true)" style="display: flex;justify-content: space-between;margin:55rpx 0">
				<view style="display: flex;align-items: center">
					<image :src="img('addon/blog/static/img/logout.png')" style="width:45rpx;height:45rpx;margin-right:10px"></image>
					<text>退出登录</text>
				</view>
				<up-icon name="arrow-right"></up-icon>
			</view>
		</view>
		
		
		<up-tabbar :value="5" :fixed="true" :placeholder="false" :safeAreaInsetBottom="false">
			<up-tabbar-item text="圈子首页" icon="home" @click="tourl('/addon/blog/pages/home/index',1)"></up-tabbar-item>
			<up-tabbar-item text="发布帖子" v-show="config?.open_fatie==1" icon="plus-circle" @click="tourl('/addon/blog/pages/create/cate',1)"></up-tabbar-item>
			<up-tabbar-item text="我的帖子" v-show="config?.open_fatie==1" icon="order" @click="tourl('/addon/blog/pages/my/tie',1)"></up-tabbar-item>
			<up-tabbar-item text="微信群" v-show="config?.open_shequn==1" icon="grid"
				@click="tourl('/addon/blog/pages/shequn/list',1)"></up-tabbar-item>
				<up-tabbar-item text="个人中心" icon="account"></up-tabbar-item>
		</up-tabbar>

	</view>
</template>
<script lang="ts" setup>
	import { ref,computed } from 'vue';
	import useMemberStore from '@/stores/member'
	import { redirect, img } from '@/utils/common';
	import { lookimg, tourl } from '@/addon/blog/utils/common';
	import { getCategory, getBanner, getTielist, getTongji,getConfigApi } from '@/addon/blog/api/tie'
	const memberStore = useMemberStore()
	
	const info = computed(() => {
		return memberStore.info;
	})
	
	const config = ref([]);
				getConfigApi({}).then(res => {
					config.value = res.data;
				})
	
	// const tourl = (url)=>{
	// 	uni.navigateTo({
	// 		url
	// 	})
	// }
	
</script>
<style lang="scss" scoped>
	page{
		background: #f5f5f5;
	}
</style>