<template>
  <!-- 内容 -->
  <div class="content-wrap" v-show="diyStore.editTab == 'content'">
    <div class="edit-attr-item-wrap">
      <h3 class="mb-[10px] text-gray-800">温馨提示：</h3>
      <h3 class="mb-[10px] text-gray-800">此组件仅在微信小程序显示,装修预览仅做占位参考</h3>
    </div>
  </div>

  <!-- 样式 -->
  <div class="style-wrap" v-show="diyStore.editTab == 'style'">
    <!-- 组件样式 -->

    <slot name="style"> </slot>
  </div>
</template>

<script lang="ts" setup>
import { t } from "@/lang";
import useDiyStore from "@/stores/modules/diy";
import { ColorPicker } from "vue3-colorpicker";
import "vue3-colorpicker/style.css";
import { reactive, ref, watch } from "vue";
const pureColor = ref<ColorInputWithoutInstance>("red");
const gradientColor = ref(
  "linear-gradient(0deg, rgba(0, 0, 0, 1) 0%, rgba(0, 0, 0, 1) 100%)"
);

const diyStore = useDiyStore();
diyStore.editComponent.ignore = []; // 忽略公共属性

defineExpose({});
</script>

<style lang="scss">
.horz-blank-slider {
  .el-slider__input {
    width: 100px;
  }
}
</style>
<style lang="scss" scoped></style>