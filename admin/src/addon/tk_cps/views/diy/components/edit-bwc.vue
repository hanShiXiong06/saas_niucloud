<template>
  <!-- 内容 -->
  <div class="content-wrap" v-show="diyStore.editTab == 'content'">
    <div class="edit-attr-item-wrap">
      <h3 class="mb-[10px]">基础设置</h3>
      <el-form label-width="80px" class="px-[10px]">
        <el-form-item label="主体颜色">
          <div>
            <el-color-picker v-model="diyStore.editComponent.maincolor" show-alpha
              :predefine="diyStore.predefineColors" />
            <!-- <color-picker
              v-model:pureColor="diyStore.editComponent.maincolor"
              v-model:gradientColor="diyStore.editComponent.maincolor"
              format="hex6"
              shape="square"
              useType="both"
            /> -->
          </div>
        </el-form-item>

        <el-form-item label="进度颜色">
          <div>
            <el-color-picker v-model="diyStore.editComponent.jdcolor" show-alpha
              :predefine="diyStore.predefineColors" />
          </div>
        </el-form-item>
        <el-form-item label="要求背景">
          <div>
            <el-color-picker v-model="diyStore.editComponent.yqbgcolor" show-alpha
              :predefine="diyStore.predefineColors" />
          </div>
        </el-form-item>
        <el-form-item label="要求边框">
          <div>
            <el-color-picker v-model="diyStore.editComponent.yqbordercolor" show-alpha
              :predefine="diyStore.predefineColors" />
          </div>
        </el-form-item>
        <el-form-item label="要求字体">
          <div>
            <el-color-picker v-model="diyStore.editComponent.yqfontcolor" show-alpha
              :predefine="diyStore.predefineColors" />
          </div>
        </el-form-item>
      </el-form>
      <h3 class="mb-[10px]">标题设置</h3>
      <el-form label-width="80px" class="px-[10px]">
        <el-form-item label="是否显示">
          <el-radio-group v-model="diyStore.editComponent.showtitle">
            <el-radio :label="'0'">隐藏</el-radio>
            <el-radio :label="'1'">显示</el-radio>
          </el-radio-group>
        </el-form-item>
        <div v-if="diyStore.editComponent.showtitle == 1">
          <el-form-item label="标题颜色">
            <el-color-picker v-model="diyStore.editComponent.titlecolor" show-alpha
              :predefine="diyStore.predefineColors" />
          </el-form-item>
          <el-form-item label="标题大小">
            <el-slider v-model="diyStore.editComponent.titlesize" max="60" show-input size="small"
              class="ml-[10px] horz-blank-slider" />
          </el-form-item>
          <el-form-item label="定位颜色">
            <el-color-picker v-model="diyStore.editComponent.localcolor" show-alpha
              :predefine="diyStore.predefineColors" />
          </el-form-item>
          <el-form-item label="定位大小">
            <el-slider v-model="diyStore.editComponent.localsize" max="60" show-input size="small"
              class="ml-[10px] horz-blank-slider" />
          </el-form-item>
        </div>
      </el-form>
      <h3 class="mb-[10px]">搜索设置</h3>
      <el-form label-width="80px" class="px-[10px]">
        <el-form-item label="是否显示">
          <el-radio-group v-model="diyStore.editComponent.showsearch">
            <el-radio :label="'0'">隐藏</el-radio>
            <el-radio :label="'1'">显示</el-radio>
          </el-radio-group>
        </el-form-item>
        <div v-if="diyStore.editComponent.showsearch == 1">
          <el-form-item label="背景颜色">
            <!-- <el-color-picker
              v-model="diyStore.editComponent.searchcolor"
              show-alpha
              :predefine="diyStore.predefineColors"
            /> -->
            <div>
              <color-picker v-model:pureColor="diyStore.editComponent.searchcolor"
                v-model:gradientColor="diyStore.editComponent.searchcolor" format="hex6" shape="square"
                useType="both" />
            </div>
          </el-form-item>
          <!-- <el-form-item label="文字颜色">
            <el-color-picker
              v-model="diyStore.editComponent.searchtextcolor"
              show-alpha
              :predefine="diyStore.predefineColors"
            />
          </el-form-item> -->
        </div>
      </el-form>
      <h3 class="mb-[10px]">分类设置</h3>
      <el-form label-width="80px" class="px-[10px]">
        <el-form-item label="分类显示">
          <el-radio-group v-model="diyStore.editComponent.cateshow" class="ml-4">
            <el-radio :label="'0'" size="large">隐藏</el-radio>
            <el-radio :label="'1'" size="large">显示</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="字体颜色">
          <el-color-picker v-model="diyStore.editComponent.catefontcolor" show-alpha
            :predefine="diyStore.predefineColors" />
        </el-form-item>
        <el-form-item label="选中背景">
          <div>
            <color-picker v-model:pureColor="diyStore.editComponent.catebackground"
              v-model:gradientColor="diyStore.editComponent.catebackground" format="hex6" shape="square"
              useType="both" />
          </div>
        </el-form-item>
        <el-form-item label="选中颜色">
          <el-color-picker v-model="diyStore.editComponent.cateselectfontcolor" show-alpha
            :predefine="diyStore.predefineColors" />
        </el-form-item>
      </el-form>
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