<template>
	<view class="bg-[#f0f0f0] min-h-[100vh] relative" v-if="detail">
		<view class="tk-card1">
			<view class=" rounded-[8rpx] !mb-0">
				<image class="full-width-image rounded-[8rpx]" :src="img(detail.img)" mode="widthFix">
				</image>
			</view>
			<view class="tk-card !p-2 !mt-0">
				<view class="flex">
					<view class="font-bold mr-2">{{detail.title}}</view>
					<view>
						<u-tag size="mini" color="#64C2BA" borderColor="#EAFEF8" bgColor="#EAFEF8"
							:text="detail.minage+'~'+detail.maxage+'岁'"></u-tag>
					</view>
				</view>

				<view class=" text-slate-400">{{detail.desc}}</view>
				<view class="flex flex-wrap">
					<view class="flex items-center">
						<view>
							<u-icon color="#000000" name="bookmark-fill" size="12"></u-icon>
						</view>
						<view class="ml-1 font-bold text-xs">通用流量{{detail.generalized}}G</view>
					</view>
					<view class="flex items-center mr-2 ml-2">
						<view>
							<u-icon color="#000000" name="bookmark-fill" size="12"></u-icon>
						</view>
						<view class="ml-1 font-bold text-xs">定向流量{{detail.directional}}G</view>
					</view>
					<view class="flex items-center">
						<view>
							<u-icon color="#000000" name="bookmark-fill" size="12"></u-icon>
						</view>
						<view class="ml-1 font-bold text-xs">通话{{detail.connected}}</view>
					</view>
				</view>
				<view v-if="detail.tag&&detail.tag!=null" class="flex flex-wrap mt-1">
					<block v-for="(item1,index) in detail.tag">
						<view class="mr-1 mb-1">
							<u-tag size="mini" plain :text="item1"></u-tag>
						</view>
					</block>
				</view>
			</view>
			<view class="flex">
				<view @click="query()" class="tk-card flex !p-2 items-center bg-[#ffffff] w-[50%] justify-center ">
					<view>
						<u-icon :name="img('/addon/hk/sim.png')"></u-icon>
					</view>
					<view class="ml-2">查询名下卡</view>
				</view>
				<view @click="shareEvent()" class="tk-card flex !p-2 items-center bg-[#ffffff] w-[50%] justify-center">
					<view>
						<u-icon name="share" size="20"></u-icon>
					</view>
					<view class="ml-2">分享</view>
				</view>
			</view>

			<view class="tk-card !p-0 !bg-[#ffffff]">
				<view class="flex items-center justify-center">
					<view class="text-center mt-2 mb-2 font-bold">商品详情</view>
				</view>
				<view class="rounded-[8rpx]">
					<image class="full-width-image rounded-[8rpx]" :src="img(detail.detailsimg)" mode="widthFix">
					</image>
				</view>
			</view>

			<view class="h-[240rpx]"></view>
		</view>
	</view>

	<view class="b-tabbar safe-area-inset-bottom">
		<view class="b-tabbar-back fb items-center p-2">
			<view class="flex flex-col items-center" @click="redirect({url:'/addon/hk/pages/index'})">
				<u-icon name="home" color="#000000" size="22"></u-icon>
				<view class="text-xs font-bold">首页</view>
			</view>
			<view class="flex flex-col items-center" @click="redirect({url:'/addon/hk/pages/order'})">
				<u-icon name="order" color="#000000" size="22"></u-icon>
				<view class="text-xs font-bold">订单</view>
			</view>
			<view class="flex flex-col items-center" @click="redirect({url:'/app/pages/member/contact'})">
				<u-icon name="kefu-ermai" color="#000000" size="22"></u-icon>
				<view class="text-xs font-bold">客服</view>
			</view>
			<u-button :loading="loading" loadingText="免费领取" color="#5A6BF6" shape="circle" :customStyle="{
	    lineHeight: '76rpx',
	    margin: '0rpx',
	    color: '#fff',
	    width: '278rpx',
	  }" type="primary" size="12" @click="openshow=true">免费领取</u-button>
		</view>

	</view>
	<u-popup :show="openshow" closeable @close="openshow = false" mode="bottom" :round="10">
		<view class="safe-area-inset-bottom mb-[96rpx] p-4">
			<view class="text-center font-bold mt-2 mb-2">填写信息</view>
			<view class="flex items-center">
				<view class="w-1 h-4 bg-[#007AFF] mr-2">
				</view>
				<view class="font-bold text-[32rpx]">收货信息</view>
			</view>
			<view class="text-xs text-[#DE5A33] mt-2">根据国家实名制要求，请准确提供身份证信息</view>
			<view class="form-container">
				<up-form labelStyle="{fontWeight:'bold'}" labelPosition="left" labelWidth="70" :model="formData"
					:rules="rules" ref="form1">
					<up-form-item label="姓名" prop="real_name" :border-bottom="true" ref="item1">
						<up-input color="#666666" v-model="formData.real_name" border="none" class="custom-input"
							placeholder="请填写真实姓名(已加密)" focus="true"></up-input>
					</up-form-item>
					<up-form-item label="身份证" prop="card_num" :border-bottom="true" ref="item2">
						<up-input color="#666666" v-model="formData.card_num" border="none" class="custom-input"
							placeholder="请填写身份证号(仅用于本次业务)"></up-input>
					</up-form-item>
					<up-form-item label="电话" prop="mobile" :border-bottom="true" ref="item3">
						<up-input color="#666666" v-model="formData.mobile" border="none" class="custom-input"
							placeholder="请填写收件人手机号(已加密)"></up-input>
					</up-form-item>
					<u-form-item label="所在区域" prop="area" :border-bottom="true" @click="selectArea">
						<view v-if="!formData.area" class="text-gray-placeholder text-[27rpx] mt-1">
							请选择所在区域
						</view>
						<view v-else class="text-[30rpx]">{{ formData.area }}</view>
					</u-form-item>
					<u-form-item label="详细地址" prop="address" :border-bottom="true">
						<u-input v-model.trim="formData.address" border="none" clearable maxlength="120"
							placeholder="街道乡镇小区或门牌号(不要输入省市区字样)" />
					</u-form-item>
					<view v-if="config.is_card_upload==1">
						<view class="mt-2">
							<view class="text-[26rpx]">身份证人像面</view>
							<u-form-item label="" prop="front_image" :border-bottom="true">
								<upload-img v-model="formData.front_image" :max-count="1" :multiple="true" />
							</u-form-item>
						</view>
						<view class="mt-2">
							<view class="text-[26rpx]">身份证国徽面</view>
							<u-form-item label="" prop="front_image" :border-bottom="true">
								<upload-img v-model="formData.back_image" :max-count="1" :multiple="true" />
							</u-form-item>
						</view>

					</view>

				</up-form>
			</view>
		</view>
		<view class="h-[120rpx]"></view>

		<view class="b-tabbar safe-area-inset-bottom">
			<view class="b-tabbar-back fl justify-center items-center p-2">
				<u-checkbox-group>
					<u-checkbox activeColor="var(--primary-color)" :checked="isAgree" shape="shape" size="14"
						@change="agreeChange" :customStyle="{ 'marginTop': '4rpx' }" />
				</u-checkbox-group>
				<view class="text-xs text-gray-400 flex flex-wrap">
					我已阅读并了解
					<view @click="redirect({ url: '/app/pages/auth/agreement?key=hk_service' })">
						<text class="text-primary">《用户协议》</text>
					</view>
					和
					<view @click="redirect({ url: '/app/pages/auth/agreement?key=hk_private' })">
						<text class="text-primary">《隐私条款》</text>
					</view>
				</view>
			</view>
			<view class="b-tabbar-back fb items-center p-2">
				<u-button color="#007AFF" type="primary" shape="circle" text="免费办理" @click="addOrderEvent()"></u-button>
			</view>
		</view>
	</u-popup>
	<share-poster ref="sharePosterRef" posterType="hk_poster" :posterId="poster_id" :posterParam="posterParam"
		:copyUrlParam="copyUrlParam" :copyUrl="'/addon/hk/pages/index'" />
	<area-select ref="areaRef" @complete="areaSelectComplete" :area-id="formData.district_id" />
</template>

<script setup lang="ts">
	import { ref, computed } from 'vue';
	import { getProductInfo, addOrder, getPhoneList, getConfig } from '@/addon/hk/api/hk'
	import { img, redirect } from '@/utils/common'
	import { onLoad } from '@dcloudio/uni-app'
	import uploadImg from '@/addon/hk/pages/components/upload-img'
	import { authLogin } from '@/addon/hk/utils/ts/common'
	import { useLogin } from "@/hooks/useLogin";
	import useMemberStore from "@/stores/member";
	const memberStore = useMemberStore();
	const userInfo = computed(() => memberStore.info);
	authLogin()
	const config = ref()
	const areaRef = ref()
	getConfig().then((res) => {
		config.value = res.data
	})
	const selectArea = () => {
		areaRef.value.open()
	}
	const query = () => {
		// #ifdef H5
		window.location.href = 'https://getsimnum.caict.ac.cn/m/#/';
		// #endif

		// #ifdef MP
		uni.openEmbeddedMiniProgram({
			appId: 'wxbebb3cdd9b331046',
			path: 'pages/news/index.html?img=44&src=https%3A%2F%2Fgetsimnum.caict.ac.cn%2F%23%2F%3FchannelId%3D102&title=全国移动电话卡"一证通查"',
			extraData: {},
			success(res) {
				console.log('半屏小程序打开');
			},
			fail(err) {
				console.error('打开半屏小程序失败', err);
			}
		});
		// #endif
	}
	/************* 分享海报-start **************/
	let sharePosterRef = ref(null);
	let copyUrlParam = ref("");
	let posterParam = {};
	const poster_id = ref(0);
	// 分享海报链接
	const copyUrlFn = () => {
		if (userInfo.value && userInfo.value.member_id)
			copyUrlParam.value = "?mid=" + userInfo.value.member_id;
	};
	const shareEvent = () => {
		// 检测是否登录
		if (!userInfo.value) {
			useLogin().setLoginBack({ url: "/addon/hk/pages/index" });
			return false;
		}

		if (userInfo.value && userInfo.value.member_id)
			posterParam.member_id = userInfo.value.member_id;
		copyUrlFn();
		sharePosterRef.value.openShare();
	};
	/************* 分享海报-end **************/
	const areaSelectComplete = (event) => {
		formData.value.province_id = event.province.id || 0
		formData.value.province = event.province.name
		formData.value.city_id = event.city.id || 0
		formData.value.city = event.city.name
		formData.value.district_id = event.district.id || 0
		formData.value.district = event.district.name
		formData.value.area = `${event.province.name || ''}${event.city.name || ''}${event.district.name || ''}`
	}

	const form1 = ref()
	const formData = ref({
		id: '',
		real_name: '',
		mobile: '',
		card_num: '',
		province_id: '',
		province: '',
		city_id: '',
		city: '',
		district_id: '',
		district: '',
		area: '',
		address: '',
		front_image: [],
		back_image: [],
		head_image: [],
	})
	const rules = {
		real_name: [
			{ required: true, message: '请输入姓名', trigger: 'blur' }
		],
		card_num: [
			{ required: true, message: '请输入身份证号码', trigger: 'blur' },
			{ validator: validateCardNum, trigger: 'blur' }
		],
		mobile: [
			{ required: true, message: '请输入电话号码', trigger: 'blur' },
			{ validator: validateMobile, trigger: 'blur' }
		],
		area: [
			{ required: true, message: '请选择省市区/县', trigger: 'blur' },
		],
		address: [
			{ required: true, message: '请输入详细地址', trigger: 'blur' },
		],
	}
	function validateCardNum(rule, value, callback) {
		if (!value) {
			return callback(new Error('请输入身份证号码'));
		}
		// 正则表达式修改为匹配正确的身份证格式
		if (!/^[1-9]\d{5}[1-9]\d{3}((0[1-9])|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/.test(value)) {
			callback(new Error('请输入正确的身份证号码'));
		} else {
			callback();
		}
	}

	// 自定义手机号码验证函数
	function validateMobile(rule : any, value : any, callback : any) {
		if (!value) {
			return callback(new Error('请输入电话号码'));
		}
		if (!/^1[3456789]\d{9}$/.test(value)) {
			callback(new Error('请输入正确的电话号码'));
		} else {
			callback();
		}
	}
	const isAgree = ref<boolean>(false)
	const agreeChange = () => {
		isAgree.value = !isAgree.value
	}
	const addOrderEvent = async () => {
		const valid = await form1.value.validate();
		if (valid) {
			if (!isAgree.value) {
				uni.$u.toast('请先阅读并同意协议');
				return
			}
			await addOrder(formData.value)
			openshow.value = false
			redirect({ url: '/addon/hk/pages/index' })
			uni.$u.toast('已成功提交请等待运营商审核')
		}
		else {
			uni.showToast({
				title: '请填写必填项',
				icon: 'none'
			});
		}

	}
	const openshow = ref(false)
	const phoneList = ref()
	const keywords = ref('')
	const getPhoneListEvent = async () => {
		// const res = getPhoneList({
		// 	id: formData.value.id,
		// 	keywords: keywords.value
		// })
	}

	let detail = ref('');
	onLoad((option) => {
		if (option.id) {
			getProductInfo(option.id).then(res => {
				detail.value = res.data
				formData.value.id = option.id
				getPhoneListEvent()
			})
		} else {
			uni.$u.toast('参数错误')
			uni.navigateBack()
		}
	})
</script>
<style lang="scss" scoped>
	@import '@/addon/hk/utils/styles/common.scss';

	.card {
		width: 100%;
		/* 卡片宽度铺满屏幕 */
		border-radius: 8px;
		overflow: hidden;
		/* 防止图片超出边界 */
	}

	.full-width-image {
		width: 100%;
		/* 图片宽度设置为100%，铺满屏幕 */
		height: auto;
		/* 高度自动，保持图片宽高比 */
	}

	.b-tabbar {
		position: fixed;
		bottom: 12rpx;
		left: 0;
		right: 0;
		margin: 0rpx 24rpx;
		border-radius: 12rpx;
		padding: 12rpx;
	}

	.b-tabbar-back {
		background: rgba(245, 250, 245, 0.9);
		bbbox-shadow: inset 2px 2px 4px rgba(0, 0, 0, 0.5),
			2px 2px 4px rgba(0, 0, 0, 0.5);
		border-radius: 12rpx;
	}
</style>