<template>
    <view :style="themeColor">
        <loading-page :loading="diy.getLoading()"></loading-page>
        <view v-show="!diy.getLoading()">
            <!-- 自定义模板渲染 -->
            <view class="diy-template-wrap bg-index" :style="diy.pageStyle()">

                <diy-group ref="diyGroupRef" :data="diy.data" />
            </view>
        </view>

        <!-- #ifdef MP-WEIXIN -->
        <!-- 小程序隐私协议 -->
        <wx-privacy-popup ref="wxPrivacyPopupRef"></wx-privacy-popup>
        <!-- #endif -->

    </view>
</template>

<script setup lang="ts">
import { ref, nextTick, onMounted, watch } from 'vue';
import { useDiy } from '@/hooks/useDiy'
import diyGroup from '@/addon/components/diy/group/index.vue'
import { getPartnerInfo, getPartnerInfoByPid } from '@/addon/tk_partner/api/partner';
interface ApiResponse<T> {
    data: T;
    [key: string]: any;
}
interface DiyData {
    title: string;
    global: {
        title: string;
        logo: string;
        [key: string]: any;
    };
    [key: string]: any;
}

interface PartnerInfo {
    name: string;
    logo: string[];
    [key: string]: any;
}

const partnerInfo = ref<PartnerInfo>()
const diy = useDiy({
    name: 'DIY_TK_PARTNER_INDEX'
}) as { data: DiyData; getLoading: () => boolean; pageStyle: () => any; onLoad: () => void; onShow: (callback: (data?: any) => void) => void; onHide: () => void; onUnload: () => void; onPageScroll: () => void }

const diyGroupRef = ref()
const wxPrivacyPopupRef = ref()
const themeColor = ref('')

// 设置页面标题
const setPageTitle = (title: string) => {
    // 设置H5页面标题
    uni.setNavigationBarTitle({
        title: title || ''
    })

    // 更新DIY数据中的标题
    if (diy?.data) {
        diy.data.title = title || ''
        if (!diy.data.global) diy.data.global = { title: '', logo: '' }
        diy.data.global.title = title || ''
    }
}

// 获取合伙人信息并更新DIY数据
const updateDiyData = async () => {
    try {
        let res: ApiResponse<PartnerInfo>;
        const pid = uni.getStorageSync("pid");

        // 根据pid是否存在调用不同的接口
        if (pid) {
            res = await getPartnerInfoByPid(pid) as ApiResponse<PartnerInfo>;
        } else {
            res = await getPartnerInfo({ type: 'partner' }) as ApiResponse<PartnerInfo>;
        }

        if (res?.data) {
            partnerInfo.value = res.data
            // 使用nextTick确保DOM更新后再设置数据
            await nextTick()
            // 设置页面标题和更新DIY数据
            setPageTitle(partnerInfo.value.name)
            // 更新logo
            if (diy?.data?.global) {
                diy.data.global.logo = partnerInfo.value.logo?.[0] || ''
            }

            // 刷新DIY组件
            if (diyGroupRef.value?.refresh) {
                diyGroupRef.value.refresh()
            }
        }
    } catch (error) {
        console.error('获取合伙人信息失败:', error)

    }
}

// 监听页面加载
diy.onLoad();

// 监听页面显示
diy.onShow(async () => {
    await updateDiyData()

    // #ifdef MP
    if (wxPrivacyPopupRef.value) {
        await nextTick()
        wxPrivacyPopupRef.value.proactive()
    }
    // #endif
});

// 监听DIY数据变化
watch(() => diy.data, (newVal) => {
    if (newVal && partnerInfo.value) {
        updateDiyData()
    }
}, { deep: true })

// 监听页面隐藏
diy.onHide();

// 监听页面卸载
diy.onUnload();

// 监听滚动事件
diy.onPageScroll()

// 组件挂载完成
onMounted(async () => {
    await updateDiyData()
})
</script>
<style lang="scss" scoped>
@import '@/styles/diy.scss';
</style>
<style lang="scss">
.diy-template-wrap {

    /* #ifdef MP */
    .child-diy-template-wrap {
        ::v-deep .diy-group {
            >.draggable-element.top-fixed-diy {
                display: block !important;
            }
        }
    }

    /* #endif */
}
</style>
