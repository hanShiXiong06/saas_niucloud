<template>
  <view v-if="visible" class="global-popup-container" ref="popupContainerRef">
    <view class="global-popup-mask" @click="maskClick"></view>
    <view class="global-popup-content" :class="[`global-popup-${position}`]">
      <view class="global-popup-header" v-if="showHeader">
        <text class="global-popup-title">{{ title }}</text>
        <view class="global-popup-close" @click="close">
          <text class="iconfont icon-close"></text>
        </view>
      </view>
      <view class="global-popup-body">
        <slot></slot>
      </view>
    </view>
  </view>
</template>

<script lang="ts" setup>
import { ref, defineProps, defineEmits, onMounted, nextTick } from 'vue';

const props = defineProps({
  position: {
    type: String,
    default: 'bottom' // bottom, center, top
  },
  title: {
    type: String,
    default: ''
  },
  showHeader: {
    type: Boolean,
    default: true
  },
  closeable: {
    type: Boolean,
    default: true
  },
  maskClosable: {
    type: Boolean,
    default: true
  }
});

const emit = defineEmits(['close']);
const visible = ref(false);
const popupContainerRef = ref(null);
let popupContainer = null;

onMounted(() => {
  // 查找全局弹窗容器
  setTimeout(() => {
    uni.createSelectorQuery()
      .select('#globalPopupContainer')
      .boundingClientRect(data => {
        if (data) {
          console.log('全局弹窗容器已找到');
          popupContainer = data;
        } else {
          console.error('未找到全局弹窗容器');
        }
      })
      .exec();
  }, 500);
});

const show = () => {
  visible.value = true;
  // 确保组件可见后将其移动到全局容器
  nextTick(() => {
    console.log('弹窗已显示');
  });
};

const close = () => {
  visible.value = false;
  emit('close');
};

const maskClick = () => {
  if (props.maskClosable) {
    close();
  }
};

defineExpose({
  show,
  close,
  visible
});
</script>

<style scoped>
.global-popup-container {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  z-index: 9999999999;
  display: flex;
  align-items: center;
  justify-content: center;
}

.global-popup-mask {
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 9999999998;
}

.global-popup-content {
  position: relative;
  background-color: #fff;
  border-radius: 16rpx;
  z-index: 9999999999;
  overflow: hidden;
  max-height: 80vh;
}

.global-popup-bottom {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  border-radius: 16rpx 16rpx 0 0;
}

.global-popup-top {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  border-radius: 0 0 16rpx 16rpx;
}

.global-popup-center {
  width: 80%;
  max-width: 600rpx;
}

.global-popup-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx;
  border-bottom: 1px solid #eee;
}

.global-popup-title {
  font-size: 32rpx;
  font-weight: 500;
  color: #333;
}

.global-popup-close {
  font-size: 36rpx;
  color: #999;
  cursor: pointer;
}

.global-popup-body {
  padding: 24rpx;
}
</style> 