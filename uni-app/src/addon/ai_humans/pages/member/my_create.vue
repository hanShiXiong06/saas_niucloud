<template>
    <view class="bg-[var(--page-bg-color)] min-h-screen p-2" :style="themeColor()">

        <!-- 固定在顶部的状态栏 -->
        <view class="fixed top-2 ml-2 mr-2 left-0 right-0 z-50 bg-white/90 px-2 py-2 !pt-2 rounded-2xl">
            <scroll-view scroll-x class="scroll-Y box-border px-[24rpx]" show-scrollbar="false">
                <view class="flex whitespace-nowrap justify-around rounded-lg">
                    <view
                        :class="['py-2 px-2 rounded-lg text-[28rpx]', status === item.value ? 'active-tab' : 'inactive-tab']"
                        @click="selectStatusFn(item)" v-for="(item, index) in tabList" :key="index">
                        {{ item.name }}
                    </view>
                </view>
            </scroll-view>
        </view>
        <!-- 内容区域，添加足够的上边距避免被顶部导航遮挡 -->
        <view class="content-container mt-[44rpx]">
            <clone-video v-if="status === 'video'" />
            <clone-voice v-if="status === 'voice'" />
            <view v-if="status === 'digital'">
                <create-video />
            </view>
        </view>

        <!-- #ifdef MP-WEIXIN -->
        <!-- 小程序隐私协议 -->
        <wx-privacy-popup ref="wxPrivacyPopupRef"></wx-privacy-popup>
        <!-- #endif -->
    </view>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, onUnmounted } from "vue";
import cloneVideo from '@/addon/ai_humans/pages/video/clone_list.vue'
import cloneVoice from '@/addon/ai_humans/pages/voice/clone_list.vue'
import createVideo from '@/addon/ai_humans/pages/video/create_list_c.vue'
const status = ref('video'); // 默认选中视频选项

const tabList = ref([
    {
        name: '形象',
        value: 'video'
    },
    {
        name: '音色',
        value: 'voice'
    },
    {
        name: '数字资产',
        value: 'digital'
    },
])

// 切换状态的方法
const selectStatusFn = (item: { name: string; value: string }) => {
    status.value = item.value;
    // 这里可以添加状态切换后的其他逻辑，例如加载对应的数据等
};

// 初始化函数
onMounted(() => {
    // 默认选择第一项
    if (tabList.value.length > 0) {
        status.value = tabList.value[0].value;
    }
});

</script>

<style lang="scss">
@import "@/addon/ai_humans/utils/styles/common.scss";

/* 针对小程序环境的样式优化 */
.sticky-header {
    position: sticky;
    top: 0;
    z-index: 50;
    /* #ifdef MP-WEIXIN */
    padding-top: var(--status-bar-height, 25px);
    /* #endif */
}

.content-container {

    padding-bottom: env(safe-area-inset-bottom, 0);
}

/* 增强小程序中的滚动体验 */
::-webkit-scrollbar {
    width: 0;
    height: 0;
    color: transparent;
}

.active-tab {
    background-color: var(--primary-color);
    color: white;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.inactive-tab {
    background-color: transparent;
    color: var(--primary-color);
}
</style>
