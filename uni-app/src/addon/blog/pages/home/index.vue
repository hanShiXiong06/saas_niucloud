<template>

	<view class="">

		<!-- <view style="height: 90rpx;"></view> -->
		<view style="background: #fff;top: 0;width: 94%;padding:15rpx 3%;z-index:22;position: relative;z-index:3">
			<up-search placeholder="请搜索感兴趣的话题关键词" v-model="keyword" :showAction="false" @search="tosearch"></up-search>
		</view>



		<!-- 发现 -->
		<view style="margrin-top:20rpx">

			<view class="bg-[#fff]">
				<view style="margin: 0 0;">
					<up-swiper :list="banner" keyName="image" radius="0" height="180" circular imgMode="aspectFill"
						@click="clickbanner"></up-swiper>
				</view>
				<swiper :indicator-dots="true" :autoplay="false" :interval="3000" :duration="1000"
					style="margin: 20rpx 20rpx 0;height: 190rpx;" :style="'height: '+menuheight+'rpx;'"
					v-if="nineCatelist.length>0">
					<swiper-item v-for="(item,index) in nineCatelist" :key="index">
						<view class="swiper-item">
							<up-grid :border="false" :col="config.menu_num||5">
								<up-grid-item v-for="(baseListItem,baseListIndex) in item" :key="baseListIndex"
									@click="tourl('/addon/blog/pages/home/cate?pid='+baseListItem.id)">
									<up-avatar size="38" :src="img(baseListItem.image)"
										:customStyle="{paddingTop:20+'rpx'}"></up-avatar>
									<text class="grid-text"
										style="margin-top: 10rpx;font-size:14px">{{baseListItem.name}}</text>
								</up-grid-item>
							</up-grid>
						</view>
					</swiper-item>
				</swiper>
				<view class="flex" style="padding: 0 25rpx 20rpx;">
					<image :src="img('addon/blog/static/img/tongji.png')" style="width:35rpx;height:35rpx"
						mode="widthFix"></image>
					<view class="flex" style="">
						<view style="margin-left: 25rpx;font-size: 12px;">帖子量：{{tongji.tie_num||0}}</view>
						<view style="margin-left: 25rpx;font-size: 12px;">浏览量：{{tongji.views_num||0}}</view>
						<view style="margin-left: 25rpx;font-size: 12px;">点赞量：{{tongji.zan_num||0}}</view>
						<view style="margin-left: 25rpx;font-size: 12px;">商家数：{{tongji.author_num||0}}</view>
					</view>
				</view>


				<view class="flex" v-if="newslist.length>0" style="background: #ffd966;padding: 10rpx 25rpx;"
					:style="'background: '+config.color+';'">
					<image :src="img('/addon/blog/static/img/news.png')" mode="widthFix"  @click="tourl('/addon/blog/pages/news/list')"
						style="width:125rpx;height:25rpx"></image>
					<view style="width: 580rpx;">
						<u-notice-bar :text="newslist" icon=""  speed="350" @click="clicknews"
							:bgColor="config.color" color="#5f5f5f" direction="column"></u-notice-bar>
					</view>
				</view>

			</view>
			<!-- <view style="height:20rpx;background-color: #f5f5f5;"></view> -->
			<up-sticky :offsetTop="0">
				<view class="flexa sortbox" style="justify-content: space-around;padding:20rpx 0;font-size: 16px;top:0">
					<view class="item " :class="sort==1?'on':''" @click="changesort(1)">最新发布</view>
					<view class="item" :class="sort==2?'on':''" @click="changesort(2)">最新回复</view>
					<view class="item" :class="sort==3?'on':''" @click="changesort(3)">距离最近</view>
				</view>
			</up-sticky>
			<!-- #ifdef MP-WEIXIN -->
			<view v-if="config.list_type==2" style="margin: -30rpx 20rpx 30rpx;">
			<!-- #endif -->
			<!-- #ifndef MP-WEIXIN -->
			<view v-if="config.list_type==2" style="margin-top: 0rpx;">
			<!-- #endif -->
				<customWaterfallsFow ref="waterfallsFlowRef" @imageClick="imageClick" @wapperClick="imageClick"
					imageKey="image" :value="tielist" :column="2" :columnSpace="1.5" :seat="2" style="margin: 0 3%;">
					<!-- #ifdef MP-WEIXIN -->
					<view class="item" v-for="(item,index) in tielist" :key="index" slot="slot{{index}}">
						<view style="padding: 15rpx;">
							<view class="title line2">{{item.details}}</view>
							<view class="flexb" style="padding:10rpx;width:250rpx">
								<view class="flex">
									<!-- <image :src="img(item.member.headimg)"
										style="width: 40rpx;height:40rpx;border-radius: 50%;background: #eee;"
										mode="aspectFill"></image> -->
									<view class="line1" style="width: 170rpx;">{{item.member.nickname}}</view>
								</view>
								<view class="flex" @tap.stop="tolike(item,index)">
									<u-icon name="heart-fill" v-if="item.is_like" size="18" color="#e33c2f"></u-icon>
									<u-icon name="heart" v-else size="18" color="#888"></u-icon>
									<text style="margin-left: 5rpx;">{{item.like_num||0}}</text>
								</view>
							</view>
						</view>
					</view>
					<!-- #endif -->
					<!-- #ifndef MP-WEIXIN -->
					<template v-slot:default="item">
						<view class="item" style="padding: 0 15rpx;font-size: 14px;">

							<view class="title line2">{{item.details}}</view>
							<view class="flexb" style="padding:10rpx;width:280rpx">
								<view class="flex" v-if="item.member"
									@click="tourl('/addon/shortvideo/pages/ta?member_id='+item.member_id)">
									<!-- <image :src="img(item.member.headimg)"
										style="width: 40rpx;height:40rpx;border-radius: 50%;margin-right:5rpx;;display: block;"
									></image> -->
									<view class="line1" style="width: 170rpx;">{{item.member.nickname}}</view>
								</view>
								<view class="flex" @tap.stop="tolike(item,0)">
									<u-icon name="heart-fill" v-if="item.islike" size="18" color="#e33c2f"></u-icon>
									<u-icon name="heart" v-else size="18" color="#888"></u-icon>
									<text style="margin-left: 5rpx;">{{item.like_num||0}}</text>
								</view>
							</view>
						</view>
					</template>
					<!-- #endif -->
				</customWaterfallsFow>
			</view>

			<view v-else style="padding:25rpx 3%;">
				<view v-for="(item,index) in tielist" :key="index">
					<!-- <image :src="img(config.shuaxin_image)" v-if="config.shuaxin_image&&index%5==0"
						@click="tourl('/addon/blog/pages/my/tie')" style="width: 100%;height:170rpx" mode="widthFix">
					</image> -->
					<view class="mb-[20rpx] bg-[#fff] p-[20rpx] rounded-[20rpx] ">
						<tieitem :item="item" :config="config"></tieitem>

					</view>
				</view>
			</view>



			<view class='tn-tabbar-height'></view>
		</view>

		<up-back-top :scroll-top="scrollTop" bottom="260"></up-back-top>

		<view class="rightbox">
			<view class="item flexmc" @click="tourl('/addon/blog/pages/create/cate',1)" v-if="config?.open_fatie==1">
				<up-icon name="camera" color="#fff" size="22"></up-icon>
			</view>
			<!-- #ifdef MP-WEIXIN -->
			<button class="item flexmc" open-type="contact">
				<up-icon name="kefu-ermai" color="#fff" size="22"></up-icon>
			</button>
			<!-- #endif -->
		</view>


	</view>
	<view style="height: 150rpx;"></view>
	<view style="position: relative;z-index: 5;">
		<up-tabbar :value="0" :fixed="true" :placeholder="false" :safeAreaInsetBottom="false">
			<up-tabbar-item text="圈子首页" icon="home"></up-tabbar-item>
			<up-tabbar-item text="发布帖子" v-show="config?.open_fatie==1" icon="plus-circle"
				@click="tourl('/addon/blog/pages/create/cate',1)"></up-tabbar-item>
			<up-tabbar-item text="我的帖子" v-show="config?.open_fatie==1" icon="order"
				@click="tourl('/addon/blog/pages/my/tie',1)"></up-tabbar-item>
			<up-tabbar-item text="微信群" v-show="config?.open_shequn==1" icon="grid"
				@click="tourl('/addon/blog/pages/shequn/list',1)"></up-tabbar-item>
			<up-tabbar-item text="个人中心" icon="account" @click="tourl('/app/pages/member/index',2)"></up-tabbar-item>
		</up-tabbar>
	</view>

	<!-- #ifdef MP-WEIXIN -->
	<!-- 小程序隐私协议 -->
	<wx-privacy-popup ref="wxPrivacyPopupRef"></wx-privacy-popup>
	<!-- #endif -->


</template>
<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad, onShow } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { lookimg, tourl } from '@/addon/blog/utils/common';
	import { getCategory, getBanner, getTielist, getTongji, getConfigApi,postTolikelApi} from '@/addon/blog/api/tie'
	import { getNewslistApi} from '@/addon/blog/api/news'

	
	import tieitem from '@/addon/blog/components/tieitem/tieitem.vue'
	import customWaterfallsFow from '@/addon/blog/components/custom-waterfalls-flow/components/custom-waterfalls-flow/custom-waterfalls-flow'

	import { onPageScroll, onReachBottom } from '@dcloudio/uni-app'
	import { useShare } from '@/hooks/useShare'
	const { setShare, onShareAppMessage, onShareTimeline } = useShare()
	setShare()
	onShareAppMessage()
	onShareTimeline()

	// 创建响应式数据 scrollTop  
	const scrollTop = ref(0);

	// onPageScroll 方法来更新 scrollTop 的值  
	onPageScroll((e) => {
		scrollTop.value = e.scrollTop;
	});


	let catelist = ref<Array<Object>>([]);
	let tielist = ref<Array<any>>([]);
	let currCategoryId = ref<number | string>('');
	let tieTitle = ref<string>('');
	let mescrollRef = ref(null);
	let loading = ref<boolean>(false);
	const data = reactive({
		loading: false,
		loadend: false,
		where: {
			page: 1,
			rows: 10,
			keyword: '',
			sort: '',
		},
	});

	const newslist = ref([]);
	const newslist2 = ref([]);
	// newslist.value = ['有任何优化和建议可随时联系客服哈!!', '所有人都可免费自行发布!']
	getNewslistApi().then((res : any) => {
		newslist2.value = res.data.data
		var news =[];
		for (var i = 0; i < res.data.data.length; i++) {
			news.push(res.data.data[i].name)
		}
		console.log(news)
		newslist.value = news
	
	});
	const clicknews = (e)=>{
		console.log(e)
		var news_id = newslist2.value[e].id
		tourl('/addon/blog/pages/news/detail?id='+news_id)
	}
	const imageClick = (e)=>{
		console.log(e)
		
			tourl('/addon/blog/pages/detail/index?id='+e.id)
	}
function tolike(item) {
	var info = '',index = 0;
	for (var i = 0; i < tielist.value.length; i++) {
		if(tielist.value[i].id==item.id){
			index = i;info = tielist.value[i];break;
		}
	}
	
		let state = !info.islike;
		postTolikelApi({
			id: info.id,
			islike: state
		})
			.then((res) => {
				console.log(res)

				uni.showToast({
					icon: 'none',
					title: state ? '点赞成功' : '取消点赞'
				})
				info.islike = state;
				if (state) {
					info.like_num = info.like_num + 1;
				} else {
					info.like_num = info.like_num - 1;
				}
				tielist.value[index] = info
				getinfo();
			}).catch((err) => {
				if (err.code == 401) {
					if (uni.getStorageSync('ismyblog') == 1) {
						uni.setStorageSync('loginBack', '/addon/blog/pages/home/index');
					}
					tourl('/app/pages/auth/index');
				}
			})
	}
	
	
	
	const latitude = ref(uni.getStorageSync('mylat'));
	const longitude = ref(uni.getStorageSync('mylng'));

	

	let sort = ref(1);
	const changesort = async (e) => {
		if (e == 3) {
			try {
				const res = await uni.getLocation({
					type: 'gcj02',
					isHighAccuracy: true,
				});
				console.log(res, 'getLocation');
				latitude.value = res.latitude;
				longitude.value = res.longitude;
				uni.setStorageSync('mylat', latitude.value);
				uni.setStorageSync('mylng', longitude.value);
				sort.value = e
				reload(true);
			} catch (err) {
				// #ifdef H5
				uni.showModal({
					title: '提示', content: JSON.stringify(err)
				}); return;
				// #endif
				// #ifdef MP
				getMapLocation();; return;
				// #endif
			}
		} else {
			sort.value = e
			reload(true);
		}

	}
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
						// await mapSelect();
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


	const menuheight = ref('195');
	let tongji = ref<Array<Object>>([]);
	let banner = ref<Array<Object>>([]);
	let nineCatelist = ref<Array<Object>>([]);
	const config = ref([]);
	getConfigApi({}).then(res => {
		config.value = res.data;
		uni.setNavigationBarTitle({
			title: config.value.site_name
		})



		getCategory().then((res : any) => {
			const initData = { title: '全部', id: '' };
			catelist.value.push(initData);
			catelist.value = catelist.value.concat(res.data);

			nineCatelist.value = arrayToNineGrid(res.data);


		});
	})



	onLoad((option) => {



		getBanner().then((res : any) => {
			for (var i = 0; i < res.data.length; i += 1) {
				res.data[i].image = img(res.data[i].image);
			}
			console.log(res.data);
			banner.value = res.data
		})



	})

	onShow(() => {
		reload(true);
		getTongji().then((res : any) => {
			tongji.value = res.data

		})
	});
	onReachBottom(() => {
		reload();
	});
	const arrayToNineGrid = (arr) => {
		var result = []

		var fennum = config.value.menu_num * 2;
		for (var i = 0; i < arr.length; i += fennum) {
			result.push(arr.slice(i, i + fennum));
		}


		if (arr.length > config.value.menu_num) {
			menuheight.value = 335;
		}




		return result;
	}
	function reload(isPage : boolean) {
		if (isPage) {
			data.loadend = false;
			data.where.page = 1;
		}
		getlist(isPage);
	}

	function getlist(isPage : boolean) {
		if (data.loadend) return;
		if (data.loading) return;

		data.loading = true;

		var datawhere = {
			cate_id: currCategoryId.value,
			title: tieTitle.value,
			page: data.where.page,
			limit: data.where.rows,
			sort: sort.value,
			lat: latitude.value,
			lng: longitude.value
		};
		getTielist(datawhere).then((res : any) => {
			if (isPage) tielist.value = [];
			const list = res.data.data;
			const lists = SplitArray(list, tielist.value);
			console.log('lists', list);
			const loadend = list.length < data.where.rows;

			data.total = res.total;
			data.loadend = loadend;
			data.loading = false;
			data.where.page++;
		})

	}
	function SplitArray(list, sp) {
		if (typeof list != 'object') return [];
		if (sp === undefined) sp = [];
		for (var i = 0; i < list.length; i++) {
			sp.push(list[i]);
		}
		return sp;
	}

	/* 	interface mescrollStructure {
			num : number,
			size : number,
			endSuccess : Function,
			[propName : string] : any
		}
		const getListFn = (mescroll : mescrollStructure) => {
			loading.value = false;
			let data : object = {
				cate_id: currCategoryId.value,
				title: tieTitle.value,
				page: mescroll.num,
				limit: mescroll.size,
				sort: sort.value,
				lat: latitude.value,
				lng: longitude.value
			};
	
			
		} */

	const loadCategory = (id : string) => {
		currCategoryId.value = id;
		reload(true);
	}

	const searchFn = () => {
		reload(true);
	}

	// const tourl = (url : string) => {
	// 	uni.navigateTo({ url: url })
	// }

	// const searchFn = () => {
	// switchTab({
	// 	url:url
	// })

	let keyword = ref('');
	const tosearch = () => {
		tourl('/addon/blog/pages/home/cate?keyword=' + keyword.value)
	};
	const clickbanner = (e) => {
		console.log(e);
		if (!banner.value[e].url) return;
		tourl(banner.value[e].url)
	}; 1
</script>

<style lang="scss">
	page {
		background: #f8f8f8;
	}

	.sortbox {
		background: #fff;
	}

	.sortbox .item.on {
		font-weight: bold;
		color: #1c6ef6;
	}
</style>
<style scoped>
	@import '@/addon/blog/static/css/base.css';

	view {
		display: block;
	}
</style>

<style>
	.rightbox {
		position: fixed;
		z-index: 911;
		bottom: 220rpx;
		right: 38rpx;
	}

	.rightbox .item {
		background: #009dda;
		width: 75rpx;
		height: 75rpx;
		font-size: 12px;
		border-radius: 50%;
		color: #fff;
		line-height: 75rpx;
		text-align: center;
		padding: 0;
		margin: 0;
		margin-bottom: 30rpx;
	}

	/deep/.uni-swiper-dot {
		display: inline-block;
		width: 8rpx;
		height: 8rpx;
		cursor: pointer;
		transition-property: background-color;
		transition-timing-function: ease;
		background: rgba(0, 0, 0, 0.6);
		border-radius: 50%;
	}
</style>