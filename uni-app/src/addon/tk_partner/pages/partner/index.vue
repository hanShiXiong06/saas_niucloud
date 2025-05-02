<template>
	<view class="min-h-[100vh] w-full bg-[#f5f5f5]" :style="themeColor()" v-if="partnerInfo">
		<!-- 顶部店铺信息 -->
		<view class="pt-4 pb-16 px-4 bg-[var(--primary-color)] rounded-b-[30rpx] relative overflow-hidden">
			<!-- 背景纹理 -->
			<view class="absolute inset-0 opacity-10 pointer-events-none">
				<view class="absolute inset-0"
					style="background-image: radial-gradient(circle at 1px 1px, #fff 1px, transparent 0); background-size: 20px 20px;">
				</view>
			</view>


			<!-- 店主信息 -->
			<view class="flex items-center mb-2 relative z-10">
				<view class="relative" @click="redirect({ url: '/addon/tk_partner/pages/partner/manage' })">
					<image class="w-[120rpx] h-[120rpx] rounded-full mr-2 border-2 border-white/30 shadow-lg"
						:src="img(partnerInfo.logo && partnerInfo.logo.length > 0 ? partnerInfo.logo[0] : 'static/resource/images/default_headimg.png')"
						mode="aspectFill">
					</image>
				</view>
				<view class="flex-1">
					<view class="flex items-center justify-between">
						<view class="flex items-center"
							@click="redirect({ url: '/addon/tk_partner/pages/partner/manage' })">
							<view class="text-white text-lg font-medium">{{ partnerInfo.name || '店铺名称' }}</view>
							<view
								class="ml-2 px-2 py-0.5 bg-white/20 rounded-md text-xs text-white/90 backdrop-blur-sm">
								ID: {{ partnerInfo.member_id || '-' }}
							</view>
						</view>
						<view class="bg-amber-800/40 text-[28rpx] px-2.5 py-2 rounded-full inline-flex items-center">
							<text class="text-amber-300 font-medium text-[28rpx]">{{ partnerInfo.level_id_name || '店主'
							}}</text>
						</view>
					</view>

					<view class="mt-3 flex items-center flex-wrap gap-2 justify-between">
						<view class="flex items-center">
							<text class="text-white text-[24rpx]">邀请码：</text>
							<text class="text-white font-medium text-[28rpx] mr-1">{{ partnerInfo.share_code || '-'
							}}</text>
							<view class="ml-2 bg-white/10 rounded flex items-center justify-center"
								@click.stop="copyEvent(partnerInfo.share_code)">
								<text class="iconfont icon-copy text-white text-xs">复制</text>
							</view>
						</view>
						<view class="flex items-center bg-white/10 rounded-full px-2 py-1"
							@click="redirect({ url: '/addon/tk_partner/pages/partner/share' })">
							<view>
								<u-icon name="share-square" size="22" color="#ffffff"></u-icon>
							</view>
							<view class="text-white text-[28rpx] ml-1">分享</view>
						</view>
					</view>
				</view>
			</view>

			<!-- 数据统计 -->
			<view class="flex justify-between bg-white/10 rounded-xl p-3 backdrop-blur-sm" v-if="stat">
				<view class="flex flex-col items-center justify-center flex-1"
					@click="redirect({ url: '/addon/tk_partner/pages/partner/order' })">
					<view class="text-[26rpx] text-white/80 mb-1">店铺订单</view>
					<view class="text-[36rpx] font-medium text-white">{{ stat.count || 0 }}</view>
				</view>
				<view class="h-10 w-px bg-white/20 self-center"></view>
				<view class="flex flex-col items-center justify-center flex-1"
					@click="redirect({ url: '/addon/tk_partner/pages/partner/order' })">
					<view class="text-[26rpx] text-white/80 mb-1">店铺销售额</view>
					<view class="text-[36rpx] font-medium text-white">￥{{ stat.order_money.toFixed(2) || 0 }}</view>
				</view>
				<view class="h-10 w-px bg-white/20 self-center"></view>
				<view class="flex flex-col items-center justify-center flex-1"
					@click="redirect({ url: '/addon/tk_partner/pages/partner/commission' })">
					<view class="text-[26rpx] text-white/80 mb-1">店铺利润</view>
					<view class="text-[36rpx] font-medium text-white">￥{{ stat.commission.toFixed(2) || 0 }}</view>
				</view>
			</view>
		</view>

		<!-- 功能菜单 -->
		<view class="mx-4 bg-white rounded-xl p-4 -mt-12 shadow mb-4 relative z-10">
			<view class="grid grid-cols-4 gap-3">
				<view class="flex flex-col items-center"
					@click="redirect({ url: '/addon/tk_partner/pages/partner/diy' })">
					<view class="w-[120rpx] h-[120rpx] rounded-lg bg-[#f0f7f5] flex items-center justify-center mb-1">
						<u-icon name="grid" size="26" color="#00BFA5"></u-icon>
					</view>
					<text class="text-sm text-gray-700">推广产品</text>
				</view>
				<view class="flex flex-col items-center"
					@click="redirect({ url: '/addon/tk_partner/pages/partner/member' })">
					<view class="w-[120rpx] h-[120rpx] rounded-lg bg-[#f0f5fe] flex items-center justify-center mb-1">
						<u-icon name="account" size="26" color="#4285F4"></u-icon>
					</view>
					<text class="text-sm text-gray-700">客户管理</text>
				</view>
				<view class="flex flex-col items-center"
					@click="redirect({ url: '/addon/tk_partner/pages/partner/order' })">
					<view class="w-[120rpx] h-[120rpx] rounded-lg bg-[#fff5e6] flex items-center justify-center mb-1">
						<u-icon name="order" size="26" color="#FF9800"></u-icon>
					</view>
					<text class="text-sm text-gray-700">订单管理</text>
				</view>
				<view class="flex flex-col items-center"
					@click="redirect({ url: '/addon/tk_partner/pages/partner/commission' })">
					<view class="w-[120rpx] h-[120rpx] rounded-lg bg-[#f0f7f0] flex items-center justify-center mb-1">
						<u-icon name="rmb-circle" size="26" color="#4CAF50"></u-icon>
					</view>
					<text class="text-sm text-gray-700">资金管理</text>
				</view>
			</view>
		</view>

		<!-- 店铺菜单列表 -->
		<view class="mx-4 bg-white rounded-xl mb-4 shadow-sm">
			<view class="px-4 py-3 border-b border-gray-50">
				<text class="text-gray-800 font-medium">店铺管理</text>
			</view>


			<view class="p-3.5 flex items-center justify-between border-b border-gray-50">
				<view class="flex items-center">
					<view class="w-9 h-9 rounded-lg bg-indigo-50 flex items-center justify-center mr-3">
						<u-icon name="attach" size="26" color="#4285F4"></u-icon>
					</view>
					<text class="text-gray-700">店铺链接</text>
				</view>
				<view class="flex items-center">
					<text class="text-gray-500 text-xs mr-2 bg-gray-50 px-2 py-1 rounded ">{{
						truncateUrl(partnerInfo.share_url)
					}}</text>
					<view
						class="w-12 h-6 rounded bg-gray-100 hover:bg-gray-200 active:bg-gray-300 transition-colors flex items-center justify-center cursor-pointer"
						@click="copy(partnerInfo.share_url, '')">
						<text class="iconfont icon-copy text-gray-500 text-sm px-2">复制</text>
					</view>
				</view>
			</view>

			<view class="p-3.5 flex items-center justify-between border-b border-gray-50"
				@click="redirect({ url: '/addon/tk_partner/pages/partner/manage' })">
				<view class="flex items-center">
					<view class="w-9 h-9 rounded-lg bg-teal-50 flex items-center justify-center mr-3">
						<u-icon name="setting" size="26" color="#4CAF50"></u-icon>
					</view>
					<text class="text-gray-700">店铺设置</text>
				</view>
				<view class="flex items-center">
					<view class="text-gray-400">店铺信息配置</view>
					<u-icon name="arrow-right" size="18" color="var(--primary-help-color)"></u-icon>
				</view>
			</view>

			<view class="p-3.5 flex items-center justify-between" v-if="configData"
				@click="redirect({ url: '/addon/tk_partner/pages/partner/share_partner' })">
				<view class="flex items-center">
					<view class="w-9 h-9 rounded-lg bg-amber-50 flex items-center justify-center mr-3">
						<u-icon name="gift" size="26" color="#FF9800"></u-icon>
					</view>
					<text class="text-gray-700">开店激励计划</text>
				</view>
				<view class="flex items-center">
					<view class="bg-amber-500 text-white text-xs px-2 py-1 rounded mr-2">{{ configData.adv_name }}
					</view>
					<text class="iconfont icon-right text-gray-300"></text>
				</view>
			</view>
		</view>

		<!-- 店铺运营工具 -->
		<view class="mx-4 mb-4">
			<view class="flex justify-between items-center mb-2">
				<text class="text-gray-800 font-medium">店铺运营工具</text>
				<view class="flex items-center text-gray-500 text-xs">

					<view class="w-5 h-5 rounded bg-gray-100 flex items-center justify-center ml-1" @click="copyShopId">
						<text class="iconfont icon-copy text-gray-500 text-xs"></text>
					</view>
				</view>
			</view>

			<view class="grid grid-cols-4 gap-3 bg-white rounded-xl p-4 shadow-sm">
				<view class="flex flex-col items-center" @click="showToast('即将上线')">
					<view class="w-[110rpx] h-[110rpx] rounded-lg bg-blue-50 flex items-center justify-center mb-1">
						<u-icon name="moments" size="26" color="#4285F4"></u-icon>
					</view>
					<text class="text-sm text-gray-700">发圈素材</text>
				</view>
				<view class="flex flex-col items-center"
					@click="redirect({ url: '/addon/tk_partner/pages/help/list' })">
					<view class="w-[110rpx] h-[110rpx] rounded-lg bg-amber-50 flex items-center justify-center mb-1">
						<u-icon name="camera" size="26" color="#4285F4"></u-icon>
					</view>
					<text class="text-sm text-gray-700">运营学院</text>
				</view>
				<view class="flex flex-col items-center"
					@click="redirect({ url: '/addon/tk_partner/pages/help/list' })">
					<view class="w-[110rpx] h-[110rpx] rounded-lg bg-green-50 flex items-center justify-center mb-1">
						<u-icon name="question-circle" size="26" color="#4285F4"></u-icon>
					</view>
					<text class="text-sm text-gray-700">常见问题</text>
				</view>
				<view class="flex flex-col items-center" @click="redirect({ url: '/app/pages/member/contact' })">
					<view class="w-[110rpx] h-[110rpx] rounded-lg bg-red-50 flex items-center justify-center mb-1">
						<u-icon name="kefu-ermai" size="26" color="#4285F4"></u-icon>
					</view>
					<text class="text-sm text-gray-700">专属客服</text>
				</view>
			</view>
		</view>
	</view>

	<tabbar addon="tk_partner_partner" />
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { img, redirect, copy } from '@/utils/common';
import useMemberStore from '@/stores/member'
import useConfigStore from '@/stores/config'
import { onLoad,onShow } from '@dcloudio/uni-app';
import { getPartnerInfo, getStat } from '@/addon/tk_partner/api/partner';
import { truncateMiddle } from '@/addon/tk_partner/utils/ts/common';
import { checkPartnerOpenEvent } from '@/addon/tk_partner/utils/ts/common';
onShow(()=>{
	checkPartnerOpenEvent()
})
import { getConfig } from '@/addon/tk_partner/api/config';
const configData = ref()
getConfig().then((res: any) => {
	configData.value = res.data
})
const setEvent = () => {
	console.log('setEvent')
	redirect({ url: '/addon/tk_partner/pages/partner/manage' })
}
// 处理链接展示
const truncateUrl = (url: string) => {
	if (!url) return '';
	return truncateMiddle(url, 12, 8);
}
const showToast = (title: string) => {
	uni.showToast({
		title: title,
		icon: 'none'
	});
}
const configStore = useConfigStore();
const themeColor = () => {
	return configStore.getThemeColor();
}

const copyEvent = (value: any) => {
	copy(value, () => {
		uni.showToast({
			title: '邀请码复制成功',
			icon: 'none'
		});
	})
}
const partnerInfo = ref()
getPartnerInfo({ type: 'partner' }).then((res: any) => {
	partnerInfo.value = res.data
})
const stat = ref()
getStat().then((res: any) => {
	stat.value = res.data
})
const memberStore = useMemberStore();
const defaultAvatar = ref('/static/images/default-avatar.png');
const shopLink = ref('https://qshs.vip35.cn');


// 复制店铺链接
const copyShopLink = () => {
	uni.setClipboardData({
		data: shopLink.value,
		success: () => {
			uni.showToast({
				title: '链接已复制',
				icon: 'none'
			});
		}
	});
};

// 复制店主ID
const copyShopId = () => {
	uni.setClipboardData({
		data: partnerInfo.value.id,
		success: () => {
			uni.showToast({
				title: 'ID已复制',
				icon: 'none'
			});
		}
	});
};

// 显示分享面板
const showSharePanel = () => {
	uni.showShareMenu({
		withShareTicket: true,
		menus: ['shareAppMessage', 'shareTimeline']
	});
};

// 页面跳转
const navigateTo = (url: string) => {
	uni.navigateTo({ url });
};

onLoad((options) => {
	// 加载店铺信息
	// 可以在这里添加实际的数据获取逻辑
});
</script>

<style lang="scss" scoped>
@import '@/addon/tk_partner/utils/styles/common.scss';
</style>