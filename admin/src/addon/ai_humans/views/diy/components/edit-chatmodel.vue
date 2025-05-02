<template>
	<!-- 内容 -->
	<div class="content-wrap" v-show="diyStore.editTab == 'content'">
		<div class="edit-attr-item-wrap">
			<h3 class="mb-[10px]">基础设置</h3>
			<el-form label-width="80px" class="px-[10px]">
				<el-form-item label="显示数量">
					<el-slider v-model="diyStore.editComponent.modelnum" max="20" show-input size="small"
						class="ml-[10px] horz-blank-slider" />
				</el-form-item>
			
				<el-form-item label="背景颜色">
					<div>
						<color-picker v-model:pureColor="diyStore.editComponent.background"
							v-model:gradientColor="diyStore.editComponent.background" format="hex6" shape="square"
							useType="both" />
					</div>
				</el-form-item>
			</el-form>
			<h3 class="mb-[10px]">图标设置</h3>
			<el-form label-width="80px" class="px-[10px]">
				<el-form-item label="图标显示">
					<el-radio-group v-model="diyStore.editComponent.iconshow" class="ml-4">
						<el-radio :label="'0'" size="large">隐藏</el-radio>
						<el-radio :label="'1'" size="large">显示</el-radio>
					</el-radio-group>
				</el-form-item>
				<el-form-item label="图标大小">
					<el-slider v-model="diyStore.editComponent.iconsize" max="50" show-input size="small"
						class="ml-[10px] horz-blank-slider" />
				</el-form-item>
				<el-form-item label="圆角大小">
					<el-slider v-model="diyStore.editComponent.radiussize" max="30" show-input size="small"
						class="ml-[10px] horz-blank-slider" />
				</el-form-item>

			</el-form>
			<h3 class="mb-[10px]">字体设置</h3>
			<el-form label-width="80px" class="px-[10px]">
				<el-form-item label="标题显示">
					<el-radio-group v-model="diyStore.editComponent.titleshow" class="ml-4">
						<el-radio :label="'0'" size="large">隐藏</el-radio>
						<el-radio :label="'1'" size="large">显示</el-radio>
					</el-radio-group>
				</el-form-item>
				<el-form-item label="标题大小">
					<el-slider v-model="diyStore.editComponent.titlesize" max="24" show-input size="small"
						class="ml-[10px] horz-blank-slider" />
				</el-form-item>
				<el-form-item label="标题颜色">
					<el-color-picker v-model="diyStore.editComponent.titlecolor" show-alpha
						:predefine="diyStore.predefineColors" />
				</el-form-item>
				<el-form-item label="描述显示">
					<el-radio-group v-model="diyStore.editComponent.descshow" class="ml-4">
						<el-radio :label="'0'" size="large">隐藏</el-radio>
						<el-radio :label="'1'" size="large">显示</el-radio>
					</el-radio-group>
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
		</div>
	</div>

	<!-- 样式 -->
	<div class="style-wrap" v-show="diyStore.editTab == 'style'">
		<!-- 组件样式 -->

		<slot name="style">

		</slot>
	</div>
</template>

<script lang="ts" setup>
import { t } from '@/lang'
import useDiyStore from '@/stores/modules/diy'
import { ColorPicker } from "vue3-colorpicker";
import "vue3-colorpicker/style.css";
import { reactive, ref, watch } from 'vue'
const pureColor = ref<ColorInputWithoutInstance>("red");
const gradientColor = ref("linear-gradient(0deg, rgba(0, 0, 0, 1) 0%, rgba(0, 0, 0, 1) 100%)");

const diyStore = useDiyStore()
diyStore.editComponent.ignore = []; // 忽略公共属性

defineExpose({})

</script>

<style lang="scss">
.horz-blank-slider {
	.el-slider__input {
		width: 100px;
	}
}
</style>
<style lang="scss" scoped></style>