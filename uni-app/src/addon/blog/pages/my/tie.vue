<template>

	<view class="page-b">
		<mescroll-body ref="mescrollRef" @init="mescrollInit" top="0" @down="downCallback" @up="getListFn">




			<view class="tn-flex tn-flex-direction-column tn-margin-top-sm tn-margin-bottom" style="padding:25rpx 3%;">
				<view v-for="(item,index) in tielist" :key="index"
					class="mb-[20rpx] bg-[#fff] p-[20rpx] rounded-[20rpx] ">


					<tieitem :item="item" :config="config"></tieitem>
					<view><text style="background: #ff6666;color: #fff;padding: 0 15rpx;" v-if="item.top_endtime">置顶至:
							{{item.top_endtime}}</text></view>
					<view class="u-flex" style="margin-top:20rpx;justify-content: space-between;">

						<view class="flex" v-if="item.sta"> <text
								:style="'color:'+item.sta.color">【{{item.sta.text}}】</text></view>
						<view class="u-flex">
							<view style="margin-right: 15rpx;" @click="top(item)">
								<picker :range="config.top_json" :range-key="'text'" @change="xuantop">
									<up-button size="small" type="primary" plain style="width:140rpx">置顶</up-button>
								</picker>
							</view>
							<view><up-button @click="edit(item)" size="small" type="primary" plain
									style="margin-right: 15rpx;width:140rpx">编辑</up-button></view>
							<view><up-button @click="del(item)" size="small" type="error" plain
									style="width:140rpx">删除</up-button></view>
						</view>
					</view>
				</view>

			</view>

			<view class='tn-tabbar-height'></view>
			<mescroll-empty v-if="!tielist.length && loading"></mescroll-empty>
		</mescroll-body>


	</view>

	<up-tabbar :value="3" :fixed="true" :placeholder="false" :safeAreaInsetBottom="false">
		<up-tabbar-item text="圈子首页" icon="home" @click="tourl('/addon/blog/pages/home/index',1)"></up-tabbar-item>
		<up-tabbar-item text="发布帖子" v-if="config?.open_fatie==1" icon="plus-circle"
			@click="tourl('/addon/blog/pages/create/cate',1)"></up-tabbar-item>
		<up-tabbar-item text="我的帖子" v-if="config?.open_fatie==1" icon="order"
			@click="tourl('/addon/blog/pages/my/tie',1)"></up-tabbar-item>
		<up-tabbar-item text="微信群" v-if="config?.open_shequn==1" icon="grid"
			@click="tourl('/addon/blog/pages/shequn/list',1)"></up-tabbar-item>
		<up-tabbar-item text="个人中心" icon="account" @click="tourl('/app/pages/member/index',2)"></up-tabbar-item>
	</up-tabbar>


	<pay ref="payRef" />


</template>
<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { lookimg, tourl } from '@/addon/blog/utils/common';
	import { getCategory, getBanner, getTielist, getTongji, delTieApi, getConfigApi } from '@/addon/blog/api/tie'
	import tieitem from '@/addon/blog/components/tieitem/tieitem.vue'
	import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue'
	import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue'
	import useMescroll from '@/components/mescroll/hooks/useMescroll.js'
	import { onPageScroll, onReachBottom } from '@dcloudio/uni-app'
	import { useShare } from '@/hooks/useShare'

	import { SubmitTopOrder } from '@/addon/blog/api/order'
	const payRef = ref()

	const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
	const { setShare, onShareAppMessage, onShareTimeline } = useShare()
	setShare()
	onShareAppMessage()
	onShareTimeline()


	let statuslist = ref<Array<Object>>([]);
	statuslist.value = [
		{ 'name': '全部', 'status': '' },
		{ 'name': '待审核', 'status': '1' },
		{ 'name': '审核通过', 'status': '2' },
		{ 'name': '已拒绝', 'status': '-1' },
	]
	let tielist = ref<Array<any>>([]);
	let currCategoryId = ref<number | string>('');
	let tieTitle = ref<string>('');
	let mescrollRef = ref(null);
	let loading = ref<boolean>(false);


	let tongji = ref<Array<Object>>([]);
	let banner = ref<Array<Object>>([]);
	let nineCatelist = ref<Array<Object>>([]);

	onLoad((option) => {

	})
	const arrayToNineGrid = (arr) => {
		var result = []
		for (var i = 0; i < arr.length; i += 10) {
			result.push(arr.slice(i, i + 10));
		}
		return result;
	}

	interface mescrollStructure {
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
			is_my: 1,
		};

		getTielist(data).then((res : any) => {
			let newArr = (res.data.data as Array<Object>);
			//设置列表数据
			if (mescroll.num == 1) {
				tielist.value = []; //如果是第一页需手动制空列表
			}
			tielist.value = tielist.value.concat(newArr);
			console.log(tielist.value)
			mescroll.endSuccess(newArr.length);
			loading.value = true;
		}).catch(() => {
			loading.value = true;
			mescroll.endErr(); // 请求失败, 结束加载
		})
	}

	const loadCategory = (id : string) => {
		currCategoryId.value = id;
		getMescroll().resetUpScroll();
	}

	const searchFn = () => {
		getMescroll().resetUpScroll();
	}




	// const tourl = (url : string) => {
	// 	uni.navigateTo({ url: url })
	// }

	// const searchFn = () => {
	// switchTab({
	// 	url:url
	// })
	onMounted(() => {
		setTimeout(() => {
			getMescroll().optUp.textNoMore = t("end");
		}, 500)
	});

	let keyword = ref('');
	const tosearch = () => {
		tourl('/addon/blog/pages/home/cate?keyword=' + keyword.value)
	};
	const clickbanner = (e) => {
		console.log(e);
		if (!banner.value[e].url) return;
		tourl(e)
	};
	const edit = (item) => {
		console.log(item);
		uni.navigateTo({
			url: '/addon/blog/pages/create/index?id=' + item.id + '&cate_id=' + item.cate_id + '&cate_name=' + item.cate_name + '&cate_id2=' + item.cate_id2 + '&cate_name2=' + item.cate_name2 + '&info='+JSON.stringify(item)
		})
	};

	const del = (item) => {
		uni.showModal({
			title: '提示', content: '确定删除吗?',
			success: (res) => {
				if (res.confirm) {
					delTieApi({
						id: item.id
					}).then((res : any) => {
						uni.showToast({
							title: '删除成功'
						})
						setTimeout(function () {
							getMescroll().resetUpScroll();
						}, 1000);
					})
				}
			}
		})
	}


	const config = ref([]);
	getConfigApi({}).then(res => {
		config.value = res.data;
	})
	const topinfo = ref([]);
	const xuantop = (e) => {
		topinfo.value = config.value.top_json[e.detail.value];
		top_pay();
	};
	var tie_id = ''
	const top = (e) => {
		console.log(e)
		tie_id = e.id;
	};
	const top_pay = () => {
		SubmitTopOrder({
			tie_id: tie_id,
			daynum: topinfo.value.daynum,
		}).then((res : any) => {
			payRef.value?.open(res.data.trade_type, res.data.trade_id, '/addon/blog/pages/my/tie')
		}).catch(() => {
		})
	}
</script>
<style lang="scss" scoped>
	page {
		background: #f8f8f8;
	}
</style>