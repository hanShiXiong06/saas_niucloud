<template>
  <!-- 内容 -->
  <div class="content-wrap" v-show="diyStore.editTab == 'content'">
    <div class="edit-attr-item-wrap">
      <el-collapse v-model="activeName" accordion>
        <el-collapse-item title="常规设置" name="1">
          <el-form label-width="80px" class="px-[10px]">
            <el-form-item label="LOGO">
              <el-radio-group v-model="diyStore.editComponent.logoshow" class="ml-4">
                <el-radio :label="'0'" size="large">隐藏</el-radio>
                <el-radio :label="'1'" size="large">显示</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="卡片背景">
              <div>
                <color-picker v-model:pureColor="diyStore.editComponent.background"
                  v-model:gradientColor="diyStore.editComponent.background" format="hex6" shape="square"
                  useType="both" />
              </div>
            </el-form-item>
            <el-form-item label="线条背景">
              <div>
                <color-picker v-model:pureColor="diyStore.editComponent.linebackground"
                  v-model:gradientColor="diyStore.editComponent.linebackground" format="hex6" shape="square"
                  useType="both" />
              </div>
            </el-form-item>
            <el-form-item label="TAG背景">
              <div>
                <color-picker v-model:pureColor="diyStore.editComponent.tagbgcolor"
                  v-model:gradientColor="diyStore.editComponent.tagbgcolor" format="hex6" shape="square"
                  useType="both" />
              </div>
            </el-form-item>
            <el-form-item label="TAG边框">
              <div>
                <color-picker v-model:pureColor="diyStore.editComponent.tagbordercolor"
                  v-model:gradientColor="diyStore.editComponent.tagbordercolor" format="hex6" shape="square"
                  useType="both" />
              </div>
            </el-form-item>
            <el-form-item label="TAG字体">
              <el-color-picker v-model="diyStore.editComponent.tagtextcolor" show-alpha
                :predefine="diyStore.predefineColors" />
            </el-form-item>
            <el-form-item label="年龄显示">
              <el-radio-group v-model="diyStore.editComponent.ageshow" class="ml-4">
                <el-radio :label="'0'" size="large">隐藏</el-radio>
                <el-radio :label="'1'" size="large">显示</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="年龄背景">
              <div>
                <color-picker v-model:pureColor="diyStore.editComponent.agebgcolor"
                  v-model:gradientColor="diyStore.editComponent.agebgcolor" format="hex6" shape="square"
                  useType="both" />
              </div>
            </el-form-item>
            <el-form-item label="年龄边框">
              <div>
                <color-picker v-model:pureColor="diyStore.editComponent.agebordercolor"
                  v-model:gradientColor="diyStore.editComponent.agebordercolor" format="hex6" shape="square"
                  useType="both" />
              </div>
            </el-form-item>
            <el-form-item label="年龄字体">
              <el-color-picker v-model="diyStore.editComponent.agetextcolor" show-alpha
                :predefine="diyStore.predefineColors" />
            </el-form-item>
          </el-form>
        </el-collapse-item>
        <el-collapse-item title="分类设置" name="2">
          <el-form label-width="80px" class="px-[10px]">
            <el-form-item label="分类显示">
              <el-radio-group v-model="diyStore.editComponent.operatorshow" class="ml-4">
                <el-radio :label="'0'" size="large">隐藏</el-radio>
                <el-radio :label="'1'" size="large">显示</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="字体颜色">
              <el-color-picker v-model="diyStore.editComponent.operatorfontcolor" show-alpha
                :predefine="diyStore.predefineColors" />
            </el-form-item>
            <el-form-item label="选中背景">
              <div>
                <color-picker v-model:pureColor="diyStore.editComponent.operatorbackground"
                  v-model:gradientColor="diyStore.editComponent.operatorbackground" format="hex6" shape="square"
                  useType="both" />
              </div>
            </el-form-item>
            <el-form-item label="选中颜色">
              <el-color-picker v-model="diyStore.editComponent.operatorselectfontcolor" show-alpha
                :predefine="diyStore.predefineColors" />
            </el-form-item>
          </el-form>
        </el-collapse-item>
        <el-collapse-item title="图标设置" name="3">
          <el-form label-width="80px" class="px-[10px]">
            <el-form-item label="图标显示">
              <el-radio-group v-model="diyStore.editComponent.iconshow" class="ml-4">
                <el-radio :label="'0'" size="large">隐藏</el-radio>
                <el-radio :label="'1'" size="large">显示</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="图标大小">
              <el-slider v-model="diyStore.editComponent.iconsize" max="200" show-input size="small"
                class="ml-[10px] horz-blank-slider" />
            </el-form-item>
            <el-form-item label="圆角大小">
              <el-slider v-model="diyStore.editComponent.radiussize" max="30" show-input size="small"
                class="ml-[10px] horz-blank-slider" />
            </el-form-item>
          </el-form>
        </el-collapse-item>

        <el-collapse-item title="字体设置" name="5">
          <el-form label-width="80px" class="px-[10px]">

            <el-form-item label="标题大小">
              <el-slider v-model="diyStore.editComponent.titlesize" max="24" show-input size="small"
                class="ml-[10px] horz-blank-slider" />
            </el-form-item>
            <el-form-item label="标题颜色">
              <el-color-picker v-model="diyStore.editComponent.titlecolor" show-alpha
                :predefine="diyStore.predefineColors" />
            </el-form-item>

            <el-form-item label="描述大小">
              <el-slider v-model="diyStore.editComponent.descsize" max="24" show-input size="small"
                class="ml-[10px] horz-blank-slider" />
            </el-form-item>
            <el-form-item label="描述颜色">
              <el-color-picker v-model="diyStore.editComponent.desccolor" show-alpha
                :predefine="diyStore.predefineColors" />
            </el-form-item>
          </el-form>
        </el-collapse-item>
        <el-collapse-item title="套餐设置" name="33">
          <el-form label-width="80px" class="px-[10px]">
            <el-form-item label="套餐显示">
              <el-radio-group v-model="diyStore.editComponent.packageshow" class="ml-4">
                <el-radio :label="'0'" size="large">隐藏</el-radio>
                <el-radio :label="'1'" size="large">显示</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item label="颜色">
              <el-color-picker v-model="diyStore.editComponent.packagecolor" show-alpha
                :predefine="diyStore.predefineColors" />
            </el-form-item>

          </el-form>
        </el-collapse-item>

        <el-collapse-item title="按钮设置" name="6">
          <el-form label-width="80px" class="px-[10px]">

            <el-form-item label="背景颜色">
              <div>
                <color-picker v-model:pureColor="diyStore.editComponent.btbackground"
                  v-model:gradientColor="diyStore.editComponent.btbackground" format="hex6" shape="square"
                  useType="both" />
              </div>
            </el-form-item>
            <el-form-item label="显示文字">
              <el-input v-model="diyStore.editComponent.bttext" placeholder="请输入文字" />
            </el-form-item>
            <el-form-item label="字体颜色">
              <el-color-picker v-model="diyStore.editComponent.btcolor" show-alpha
                :predefine="diyStore.predefineColors" />
            </el-form-item>
            <el-form-item label="字体大小">
              <el-slider v-model="diyStore.editComponent.btsize" max="24" show-input size="small"
                class="ml-[10px] horz-blank-slider" />
            </el-form-item>
            <el-form-item label="左右边距">
              <el-slider v-model="diyStore.editComponent.btpadding" max="24" show-input size="small"
                class="ml-[10px] horz-blank-slider" />
            </el-form-item>
            <el-form-item label="上下边距">
              <el-slider v-model="diyStore.editComponent.btpadding1" max="24" show-input size="small"
                class="ml-[10px] horz-blank-slider" />
            </el-form-item>
            <el-form-item label="圆角大小">
              <el-slider v-model="diyStore.editComponent.btradius" max="24" show-input size="small"
                class="ml-[10px] horz-blank-slider" />
            </el-form-item>
          </el-form>
        </el-collapse-item>
      </el-collapse>
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
const activeName = ref(1);
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