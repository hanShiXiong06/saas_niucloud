<template>
	<view style="margin: 50rpx 0 30rpx;text-align: center;color: #999;">选择分类进行发布</view>
	<view class="page-b" style="margin: 20rpx 0;">
		<up-grid :border="false" col="5">
			<up-grid-item v-for="(item,index) in catelist" :key="index" @click="xuancate(item)">
				<up-avatar size="38" :src="img(item.image)" :customStyle="{paddingTop:20+'rpx'}"></up-avatar>
				<text class="grid-text" style="margin-top: 10rpx;font-size:14px">{{item.name}}</text>
			</up-grid-item>
		</up-grid>
	</view>

	<!-- <up-action-sheet :actions="catelist2" :title="'请选择类目'" :wrapMaxHeight="'300px'" :show="showcate2" @close="showcate2=false"></up-action-sheet> -->

	<u-action-sheet :actions="catelist2" :title="'请选择类目'" :show="showcate2" :closeOnClickOverlay="true"
		:safeAreaInsetBottom="true" @close="showcate2 = false" @select="xuancate2"></u-action-sheet>


	<up-tabbar :value="1" :fixed="true" :placeholder="false" :safeAreaInsetBottom="false">
		<up-tabbar-item text="圈子首页" icon="home" @click="tourl('/addon/blog/pages/home/index',1)"></up-tabbar-item>
		<up-tabbar-item text="发布帖子" v-show="config?.open_fatie==1" icon="plus-circle"
			@click="tourl('/addon/blog/pages/create/cate',1)"></up-tabbar-item>
		<up-tabbar-item text="我的帖子" v-show="config?.open_fatie==1" icon="order"
			@click="tourl('/addon/blog/pages/my/tie',1)"></up-tabbar-item>
		<up-tabbar-item text="微信群" v-show="config?.open_shequn==1" icon="grid"
			@click="tourl('/addon/blog/pages/shequn/list',1)"></up-tabbar-item>
		<up-tabbar-item text="个人中心" icon="account" @click="tourl('/app/pages/member/index',2)"></up-tabbar-item>
	</up-tabbar>

</template>
<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	import { onLoad } from '@dcloudio/uni-app'
	import { t } from '@/locale'
	import { redirect, img } from '@/utils/common';
	import { lookimg, tourl } from '@/addon/blog/utils/common';
	import { getCategory, getConfigApi } from '@/addon/blog/api/tie'


	let catelist = ref<Array<Object>>([]);



	onLoad((option) => {
		getCategory().then((res : any) => {
			// const initData = { title: '全部', id: '' };
			// catelist.value.push(initData);
			catelist.value = catelist.value.concat(res.data);

		});

	})

	const config = ref([]);
	getConfigApi({}).then(res => {
		config.value = res.data;
	})


	const cateitem = ref([]);
	const catelist2 = ref([]);
	const showcate2 = ref(false);
	const xuancate = (e) => {
		// catelist2.value = e.child;
		cateitem.value = e;

		catelist2.value = [];
		const initData = { name: '不限', id: '' };
		catelist2.value.push(initData);
		catelist2.value = catelist2.value.concat(e.child);

		showcate2.value = true;
	}

	const xuancate2 = (e) => {
		tourl('/addon/blog/pages/create/index?cate_id=' + cateitem.value.id + '&cate_name=' + cateitem.value.name + '&cate_id2=' + e.id + '&cate_name2=' + e.name)
	}
</script>


<style lang="scss" scoped>
	:deep(.u-action-sheet) {
		.u-line {
			margin: 0 30rpx !important;
			width: auto !important;
			border-color: #ddd !important;
		}

		.u-action-sheet__cancel {
			padding: 0;

		}

		.u-action-sheet__item-wrap__item__name {
			font-size: 30rpx !important;
		}

		.u-action-sheet {
			margin-bottom: 20rpx;
		}
	}
</style>