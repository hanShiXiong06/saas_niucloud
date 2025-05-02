<template>
    <view class="bg-gray-50 min-h-screen" :style="themeColor()">
        合成声音
    </view>
</template>

<script setup lang="ts">
import {
    ref,
    reactive
} from 'vue'
import {
    onLoad
} from '@dcloudio/uni-app'
import { img, copy } from '@/utils/common'

</script>

<style lang="scss" scoped></style>