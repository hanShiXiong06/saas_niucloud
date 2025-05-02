<template>
	<view class="template-edit tn-safe-area-inset-bottom" style="padding:30rpx 3%" v-if="config?.open_fatie==1">

		<view class="">
			<view class="flex justify-between  mb-[52rpx] " v-if="!tie_id"
				@click="tourl('/addon/blog/pages/create/cate',1)">
				<view class="u-flex ">
					<up-icon name="grid-fill" color="#000" size="20"></up-icon>
					<view class="ml-[10rpx] font-bold">话题分类</view>
				</view>
				<view class="flex text-[#999]">
					<text class="tn-padding-xs">{{cate_name}} - {{cate_name2}}</text>
					<up-icon name="arrow-right"></up-icon>
				</view>
			</view>
			<!-- <picker :range="catelist" range-key="name" @change="changecate">
				<view class="flex justify-between  mb-[52rpx] ">
					<view class="u-flex ">
						<up-icon name="grid-fill" color="#000" size="20"></up-icon>
						<view class="ml-[10rpx] font-bold">话题分类</view>
					</view>
					<view class="flex text-[#999]">
						<text class="tn-padding-xs">{{cate_name}}</text>
						<up-icon name="arrow-right"></up-icon>
					</view>
				</view>
			</picker>
			<picker :range="catelist2" range-key="name" @change="changecate2">
				<view class="flex justify-between  mb-[52rpx] ">
					<view class="u-flex ">
						<up-icon name="grid-fill" color="#000" size="20"></up-icon>
						<view class="ml-[10rpx] font-bold">类目</view>
					</view>
					<view class="flex text-[#999]">
						<text class="tn-padding-xs">{{cate_name}}</text>
						<up-icon name="arrow-right"></up-icon>
					</view>
				</view>
			</picker> -->

			<view class="flex justify-between  mb-[32rpx]">
				<view class="flex ">
					<up-icon name="edit-pen-fill" color="#000" size="20"></up-icon>
					<view class="ml-[10rpx] font-bold">想说点什么</view>
				</view>
			</view>
			<view>
				<textarea maxlength="500" v-model="details" placeholder="说点什么 , 万一火了呢" placeholder-style="color:#AAAAAA"
					style="background-color: #f5f5f5;padding:20rpx 3%;width:94%;border-radius: 10rpx;"></textarea>
			</view>


			<view class="flex justify-between  mb-[32rpx] mt-[32rpx]">
				<view class="flex ">
					<up-icon name="camera-fill" color="#000" size="20"></up-icon>
					<view class="ml-[10rpx] font-bold">发点什么图咧(限3张)</view>
				</view>
				<view class="text-[#999]" @tap="clear">
					<text class="tn-padding-xs">清空上传</text>
					<text class="tn-icon-delete"></text>
				</view>
			</view>
			<view class="tn-margin-left tn-padding-top-xs">
				<up-upload :fileList="fileList1" @afterRead="afterRead" @error="uploaderror" @delete="deletePic"
					width="80" name="1" multiple :maxCount="3"></up-upload>
			</view>

			<view class="flex justify-between  mb-[32rpx] mt-[32rpx]">
				<view class="flex ">
					<up-icon name="pushpin-fill" color="#000" size="20"></up-icon>
					<view class="ml-[10rpx] font-bold">话题标签</view>
				</view>
			</view>
			<view class="tn-tag-content tn-margin tn-text-justify tn-padding-bottom">
				<view v-for="(item, index) in labellist" :key="index" @click="xuanlabel(index)"
					class="tn-tag-content__item tn-margin-right tn-round tn-text-sm tn-text-bold"
					style="border-radius: 30px;font-size: 12px;"
					:style="[`background-color:${item.check?item.bgcolor:'#eee'};color:${item.check?item.color:'#333'}`]">
					<text class="tn-tag-content__item--prefix ">#</text> {{ item.name }}
				</view>
			</view>
			<view class="u-flex" style="margin-top:55rpx;">
				<up-icon name="map-fill" color="#000" size="20"></up-icon>
				<view style="margin-left:20rpx" @click="mapSelect">
					<text v-if="address">{{address}}</text>
					<text v-else style="color:#999">请选择所在位置</text>
				</view>
			</view>
			<view class="u-flex" style="margin-top:55rpx">
				<up-icon name="phone-fill" color="#000" size="20"></up-icon>
				<input style="margin-left:20rpx" v-model="mobile" type="number" placeholder="请填写联系电话">
			</view>



			<view class="flex justify-between  mb-[32rpx] mt-[55rpx]" v-if="config?.open_top==1">
				<view class="flex ">
					<up-icon name="integral-fill" color="#000" size="20"></up-icon>
					<view class="ml-[10rpx] font-bold">置顶选择</view>
				</view>
				<picker :range="config.top_json" :range-key="'text'" @change="xuantop">
					<view class="flex text-[#999]">
						<view v-if="topinfo?.daynum">
							{{topinfo.daynum}}天 <span
								style="color: red;margin-left: 20rpx;">(￥{{topinfo.price}}元)</span>
						</view>
						<view v-else>未选择</view>
						<up-icon name="arrow-right"></up-icon>
					</view>
				</picker>
			</view>
		</view>


		<!-- <view class='tn-tabbar-height'></view> -->

		<view class=" bg-[#fff]" style="bottom:0;margin:70rpx 3% ;">
			<view class="u-flex" style="margin-bottom: 20rpx;text-align: center;">
				<u-icon name="checkmark-circle-fill" v-if="tongyi" @click="tongyi=!tongyi" color="#007aff"></u-icon>
				<u-icon name="checkmark-circle" v-else @click="tongyi=!tongyi" color="#999"></u-icon>

				<text style="color:#999" @click="tongyi=!tongyi">发布信息前请先查看</text><text style="color:#007aff"
					@click="tourl('./mianze')">免责声明</text>
			</view>
			<button type="primary" round="30" style="width: 94%;background: #007aff;color: #fff;text-align: center;"
				@tap="submit">
				发布
			</button>
		</view>

		<pay ref="payRef" />
	</view>
	<view v-else style="text-align: center;margin-top: 200rpx;">
		加载中...
	</view>

	<!-- #ifdef MP-WEIXIN -->
	<!-- 小程序隐私协议 -->
	<wx-privacy-popup ref="wxPrivacyPopupRef"></wx-privacy-popup>
	<!-- #endif -->


	<up-popup :show="showupavatar" mode="bottom" @close="showupavatar=false" closeable>
		<view style="padding:35rpx 3%">
			<view style="font-size: 18px;font-weight: bold;">获取您的昵称、头像</view>
			<view style="color: #999;margin: 20rpx 0 25rpx;font-size: 12px;">获取用户头像、昵称，主要用于向用户提供具有辨识的帖子信息页面</view>
			<view class="flex" style="padding:30rpx 0;border-bottom: 1px solid #eee;">
				<view style="width: 140rpx;">头像</view>
				<view class="flex" style="justify-content: space-between;flex:1;width:650rpx;display: flex;">
					<button class="avatar-wrapper" open-type="chooseAvatar" @chooseavatar="onChooseAvatar"
						style="background: none;padding:0;text-align: left;width:80rpx;margin:0">
						<up-avatar size="40" :src="img(avatar)"></up-avatar>
					</button>
					<up-icon name="arrow-right" color="#999"></up-icon>
				</view>
			</view>
			<view class="flex" style="padding:30rpx 0;border-bottom: 1px solid #eee;">
				<view style="width: 140rpx;">昵称</view>
				<input type="nickname" v-model="nickname" placeholder="请输入昵称" @blur="inputnickname" />
			</view>
			<view @click="upheadimg"
				style="background: #007aff;margin: 50rpx 0 35rpx;color:#fff;text-align: center;height: 75rpx;line-height: 75rpx;border-radius:10rpx">
				确定</view>
		</view>
	</up-popup>
</template>



<script setup lang="ts">
	import {
		reactive,
		ref,
		onMounted
	} from 'vue'
	import {
		onLoad
	} from '@dcloudio/uni-app'
	import {
		t
	} from '@/locale'
	import {
		redirect,
		img
	} from '@/utils/common';
	import {
		lookimg,
		tourl
	} from '@/addon/blog/utils/common';
	import {
		getLabel,
		getCategory,
		postTieApi,
		getConfigApi,upheadimgApi
	} from '@/addon/blog/api/tie'
	import {
		SubmitTopOrder
	} from '@/addon/blog/api/order'
	import {
		uploadImage
	} from '@/app/api/system'

	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue'
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue'
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js'
	import {
		onPageScroll,
		onReachBottom
	} from '@dcloudio/uni-app'
	import {
		useShare
	} from '@/hooks/useShare'


	const payRef = ref()


	const {
		mescrollInit,
		downCallback,
		getMescroll
	} = useMescroll(onPageScroll, onReachBottom);
	const {
		setShare,
		onShareAppMessage,
		onShareTimeline
	} = useShare()
	setShare()
	onShareAppMessage()
	onShareTimeline()


	const showlabel = ref(false);

	const mobile = ref('')
	const address = ref('')
	const lat = ref('')
	const lng = ref('')
	const cate_id = ref('')
	const cate_id2 = ref('')
	const details = ref('')
	const cate_name = ref('')
	const cate_name2 = ref('')
	const info = ref('')
	const labellist = ref([])
	let catelist = ref<Array<Object>>([]);
	const tongyi = ref(false);




	const tie_id = ref('');

	onLoad((query : any) => {
		cate_id.value = query.cate_id || '';
		cate_name.value = query.cate_name || '';
		cate_id2.value = query.cate_id2 || '';
		cate_name2.value = query.cate_name2 || '';


		console.log(query);
		tie_id.value = query.id;
		info.value = query.info || '';

		if (query.info && tie_id.value) {
			info.value = JSON.parse(info.value)
			console.log('info', info.value);
			details.value = info.value.details;
			address.value = info.value.address;
			mobile.value = info.value.mobile;
			lat.value = info.value.lat;
			lng.value = info.value.lng;

			for (var i = 0; i < info.value.imgs.length; i++) {
				fileList1.value.push({
					url: info.value.imgs[i]
				});
			}
		}

		getLabel().then((res : any) => {
			// const initData = { title: '全部', id: '' };
			// catelist.value.push(initData);grey
			var color = ["#ff0000", "#099e7e", "#6a85ff", "#008000", "#ffa500", "#c71585", "#800080",
				"#a52a2a", "#9acd32", "#ff4500", "#ff0000", "#099e7e", "#6a85ff", "#008000", "#ffa500", "#c71585", "#800080",
				"#a52a2a", "#9acd32", "#ff4500", "#ff0000", "#099e7e", "#6a85ff", "#008000", "#ffa500", "#c71585", "#800080",
				"#a52a2a", "#9acd32", "#ff4500"
			];
			var bgcolor = ["#ffe1de", "#e0ffff", "#edeeff", "#aae7b6", "#f5efe5", "#f7e2f7", "#ececfc",
				"#fce4de", "#f4f8ec", "#ffeadf", "#edeeff", "#aae7b6", "#f5efe5", "#f7e2f7", "#ececfc",
				"#fce4de", "#f4f8ec", "#ffeadf", "#edeeff", "#aae7b6", "#f5efe5", "#f7e2f7", "#ececfc",
				"#fce4de", "#f4f8ec", "#ffeadf"
			];
			// ['red', 'cyan', 'blue', 'green', 'orange', 'purplered', 'purple', 'brown', 'yellowgreen','orangered']
			for (var i = 0; i < res.data.length; i++) {
				labellist.value.push({
					name: res.data[i].name,
					color: color[i],
					bgcolor: bgcolor[i],
					check: info.value && info.value.labelname.indexOf(res.data[i].name) > -1 ? true : false
				})
			}
			console.log(labellist.value)
		});

		uni.$on('tongyi_mianze', function (data) {
			tongyi.value = true;
		})


	})


	// 获取城市详细位置
	const mapSelect = async () => {
		const latitude = ref(null);
		const longitude = ref(null);
		try {
			const res = await uni.getLocation({
				type: 'gcj02',
				isHighAccuracy: true,
			});
			console.log(1);
			console.log(res, 'getLocation');
			latitude.value = res.latitude;
			longitude.value = res.longitude;
			const locationRes = await uni.chooseLocation({
				latitude: res.latitude,
				longitude: res.longitude,
			});
			console.log(locationRes, 'chooseLocation');
			// this.longitude = locationRes.longitude;
			// this.latitude = locationRes.latitude;
			address.value = locationRes.address + locationRes.name;
			lng.value = locationRes.longitude;
			lat.value = locationRes.latitude;

		} catch (err) {
			console.log(err);
			// #ifdef H5
			uni.showModal({
				title: '提示', content: JSON.stringify(err)
			}); return;
			// #endif
			// #ifdef MP
			getMapLocation();; return;
			// #endif
		}
	};
	const getMapLocation = async () => {
		try {
			const res = await uni.getSetting();
			console.log(res);
			const status = res.authSetting;
			if (!status['scope.userLocation']) {
				const tip = await uni.showModal({
					title: '是否授权当前位置',
					content:
						'需要获取您的地理位置，请确认授权，否则地图功能将无法使用',
				});
				if (tip.confirm) {
					const data = await uni.openSetting();
					if (data.authSetting['scope.userLocation'] === true) {
						uni.showToast({
							title: '授权成功',
							icon: 'success',
							duration: 1000,
						});
						// 授权成功后，然后再次 chooseLocation 获取信息
						await mapSelect();
					} else {
						uni.showToast({
							title: '授权失败',
							icon: 'none',
							duration: 1000,
						});
					}
				}
			}
		} catch (error) {
			uni.showModal({
				content: '调用授权窗口失败:' + error,
			});
		}
	}


	const xuanlabel = (n) => {
		console.log('change', n);
		labellist.value[n].check = !labellist.value[n].check;
	};

	const config = ref([]);
	getConfigApi({}).then(res => {
		config.value = res.data;

		var top_json = [{
			daynum: '',
			price: '',
			text: '不置顶'
		}];
		for (var i = 0; i < config.value.top_json.length; i++) {
			top_json.push(config.value.top_json[i]);
		}
		config.value.top_json = top_json;

	})
	const topinfo = ref([]);
	const xuantop = (e) => {
		topinfo.value = config.value.top_json[e.detail.value];
	};

	getCategory().then((res : any) => {
		catelist.value = catelist.value.concat(res.data);
	});
	const changecate = (event) => {
		var cate = catelist.value[event.detail.value];
		cate_id.value = cate.id;
		cate_name.value = cate.name;
	};


	const fileList1 = ref([]);

	// 删除图片
	const clear = () => {
		fileList1.value = [];
	};
	const deletePic = (event) => {
		fileList1.value.splice(event.index, 1);
	};
	const uploaderror = (event) => {
		console.log(event);
		if (event.errno == 112) {
			uni.showModal({
				title: '权限不足',
				content: '请在用户隐私保护指引里面声明【收集你选中的照片或视频信息】'
			})
		} else {
			uni.showModal({
				title: '上传失败',
				content: event.errMsg,
				showCancel: false
			})
		}

	};

	// 新增图片
	const afterRead = async (event) => {
		uni.showLoading({
			title: '上传中'
		})
		// 当设置 mutiple 为 true 时, file 为数组格式，否则为对象格式
		let lists = [].concat(event.file);
		let fileListLen = fileList1.value.length;
		lists.map((item) => {
			fileList1.value.push({
				...item,
				status: 'uploading',
				message: '上传中',
			});
		});
		for (let i = 0; i < lists.length; i++) {
			console.log('urlurl', lists[i].url);
			const result = await uploadFilePromise(lists[i].url);
			console.log('result', result);
			let item = fileList1.value[fileListLen];
			fileList1.value.splice(fileListLen, 1, {
				...item,
				status: 'success',
				message: '',
				url: result,
			});
			fileListLen++;
		}
	};

	const uploadFilePromise = (url) => {

		return new Promise((resolve, reject) => {
			console.log(url)
			uploadImage({
				filePath: url,
				name: 'file'
			}).then(res => {
				uni.hideLoading()
				resolve(res.data.url);
			}).catch(() => { })

		});
	};

	const submit = () => {
		if (!tongyi.value) {
			return uni.showToast({
				title: '请阅读并免责声明',
				icon: 'none'
			});
		}

		var labelname = [];
		for (var i = 0; i < labellist.value.length; i++) {
			if (labellist.value[i].check) {
				labelname.push(labellist.value[i].name);
			}
		}
		if (!labelname.length) {
			return uni.showToast({
				title: '请选择标签',
				icon: 'none'
			});
		}
		var imgs = [];
		for (var i = 0; i < fileList1.value.length; i++) {
			imgs.push(fileList1.value[i].url);
		}
		// if (!imgs.length) {
		// 	return uni.showToast({
		// 		title: '请上传图片',
		// 		icon: 'none'
		// 	});
		// }
		if (!details.value) {
			return uni.showToast({
				title: '说点什么吧',
				icon: 'none'
			});
		}

		/* if (!address.value) {
			return uni.showToast({
				title: '请选择当前位置',
				icon: 'none'
			});
		} */

		postTieApi({
			details: details.value,
			id: tie_id.value,
			imgs: imgs.join(','),
			cate_id: cate_id.value,
			cate_id2: cate_id2.value,
			labelname: labelname.join(','),
			mobile: mobile.value,
			address: address.value,
			lat: lat.value,
			lng: lng.value,
		}).then(res => {
			if(res.data.data.needheadimg==1){
				console.log(11111111);
				showupavatar.value = true;
				return;
			}
			details.value = '';
			details.imgs = [];
			if (Number(topinfo.value?.daynum) > 0) {
				return top_pay(res.data.data.id);
			}
			uni.showToast({
				title: '提交成功'
			})
			setTimeout(function () {
				tourl('/addon/blog/pages/my/tie', 1)
			}, 1500)

		}).catch((err) => {
			console.log(err)
		})
	};


	const top_pay = (tie_id) => {
		SubmitTopOrder({
			tie_id: tie_id,
			daynum: topinfo.value.daynum,
		}).then((res : any) => {
			payRef.value?.open(res.data.trade_type, res.data.trade_id, '/addon/blog/pages/my/tie')
		}).catch(() => { })
	}


	// uni.setStorageSync('loginBack','/addon/blog/pages/create/index');

	const showupavatar = ref(false);
	const nickname = ref('');
	const avatar = ref('');
	const inputnickname = (e) => {
		console.log(e)
		nickname.value = e.detail.value;
	}
	const onChooseAvatar = async (e) => {
		console.log('url222', e);
		uploadImage({
			filePath: e.detail.avatarUrl,
			name: 'file'
		}).then(res => {
			uni.hideLoading()
			avatar.value = res.data.url;
		}).catch((err) => {
			console.log(err)
		})
	}
	const upheadimg = ()=>{
		if(!avatar.value){
		 return	uni.showToast({title:'请获取头像',icon:'none'});
		}
		if(!nickname.value){
		 return	uni.showToast({title:'请填写昵称',icon:'none'});
		}
		
		upheadimgApi({
			nickname: nickname.value,
			headimg: avatar.value
		}).then(res => {
			uni.hideLoading()
			showupavatar.value =false;
			submit();
		}).catch((err) => {
			console.log(err)
		})
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
			display: block;
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

	/* 底部悬浮按钮 start*/
	.tn-tabbar-height {
		min-height: 100rpx;
		height: calc(120rpx + env(safe-area-inset-bottom) / 2);
	}

	.tn-footerfixed {
		position: fixed;
		width: 100%;
		bottom: calc(30rpx + env(safe-area-inset-bottom));
		z-index: 14;
		box-shadow: 0 1rpx 6rpx rgba(0, 0, 0, 0);

	}

	/* 底部悬浮按钮 end*/

	/* 标签内容 start*/
	.tn-tag-content {
		&__item {
			display: inline-block;
			line-height: 25rpx;
			padding: 10rpx 30rpx;
			margin: 20rpx 20rpx 5rpx 0rpx;

			&--prefix {
				padding-right: 10rpx;
			}
		}
	}

	/* 标签内容 end*/
</style>
<style>
	.tn-flex-col-center {
		justify-content: space-between
	}
</style>