<template>
	<view :style="warpCss" v-if="diyStore.mode == 'decorate'">
		<image :src="img('addon/tk_cps/plugin/hotel.png')" mode="aspectFill" :style="{
			width: '100%',
			height: '180px',
			borderRadius: '4px',
			padding: '4px'
		}"></image>
	</view>
	<!-- #ifdef MP-WEIXIN -->
	<view :style="warpCss" v-if="loading">
		<hotel :data="options"></hotel>
	</view>
	<!-- #endif -->
</template>

<script setup lang="ts">
import { ref, reactive, computed, watch } from 'vue';
import { img } from '@/utils/common';
import { getPlatformConfig } from '@/addon/tk_cps/api/cps';
import useDiyStore from '@/app/stores/diy';
import useSystemStore from "@/addon/tk_cps/stores/system";
import { getActList, getActInfo, getNewActList } from "@/addon/tk_cps/api/bwc";
import { timeChange, authLogin, getLocationData, authLoginWx } from "@/addon/tk_cps/utils/ts/common";
import { getAddressByLatlng } from "@/app/api/system";
import { useLocation } from '@/addon/tk_cps/hooks/useLocation'
const locationVal = useLocation(true);
locationVal.onLoad();
locationVal.init();
locationVal.refresh();
const systemStore = useSystemStore();
const loading = ref(false);
const options = ref({
	pub_id: 223924,//你的联盟ID
	sid: 123456,
	locationCity: '昆明市,汉庭'
})
const address = ref();
watch(() => systemStore.diyAddressInfo, async (nval, oval) => {
	if (nval.latitude && nval.longitude) {
		loading.value = true;
		let data = {
			latlng: ''
		};
		data.latlng = nval.latitude + ',' + nval.longitude
		getAddressByLatlng(data).then(async (res: any) => {
			if (res.data && Object.keys(res.data).length) {
				uni.setStorageSync('addressByLatlng', res.data);
				options.value.locationCity = res.data.city + ',汉庭';
			} else {
				uni.$u.toast('地址切换失败')
			}
		})
	}
}, { deep: true })

const props = defineProps(['component', 'index']);
const platformConfig = ref()
getPlatformConfig(0).then(res => {
	platformConfig.value = res.data;
	options.value.pub_id = platformConfig.value.pub_id
	options.value.sid = platformConfig.value.sid
	options.value.locationCity = uni.getStorageSync('addressByLatlng').city + ',汉庭'
	loading.value = true
})

const diyStore = useDiyStore();

const diyComponent = computed(() => {
	if (diyStore.mode == 'decorate') {
		return diyStore.value[props.index];
	} else {
		return props.component;
	}
})

const warpCss = computed(() => {
	var style = '';
	style += 'background:' + diyComponent.value.componentBgColor + ';';
	style += 'border-top-left-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
	style += 'border-top-right-radius:' + diyComponent.value.topRounded * 2 + 'rpx;';
	style += 'border-bottom-left-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
	style += 'border-bottom-right-radius:' + diyComponent.value.bottomRounded * 2 + 'rpx;';
	return style;
})
</script>

<style lang="scss" scoped>
.tag {
	background: #dddddd;
	padding: 6rpx 12rpx;
	text-align: center;
	border-radius: 8rpx;
	font-weight: bold;
}

.bt {
	padding: 4rpx 12rpx;
	border-radius: 12rpx;
	// border: #effeed solid 2rpx;
}
</style>