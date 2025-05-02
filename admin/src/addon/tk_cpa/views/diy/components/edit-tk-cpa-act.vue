<template>
	<!-- 内容 -->
	<div class="content-wrap" v-show="diyStore.editTab == 'content'">
		<div class="edit-attr-item-wrap">
			<h3 class="mb-[10px]">基础设置</h3>
			<el-form label-width="80px" class="px-[10px]">
				<el-form-item label="组件背景">
					<div>
						<color-picker v-model:pureColor="diyStore.editComponent.bgcolor"
							v-model:gradientColor="diyStore.editComponent.bgcolor" format="hex6" shape="square"
							useType="both" />
					</div>
				</el-form-item>
				<el-form-item label="图片大小">
					<el-slider v-model="diyStore.editComponent.imagewidth" :min="0" :max="150" show-input size="small"
						class="ml-[10px] horz-blank-slider" />
				</el-form-item>
			
				<el-form-item label="标题大小">
					<el-slider v-model="diyStore.editComponent.titlesize" max="40" show-input size="small"
						class="ml-[10px] horz-blank-slider" />
				</el-form-item>
				<el-form-item label="标题颜色">
					<div>
						<el-color-picker v-model="diyStore.editComponent.titlecolor" show-alpha
							:predefine="diyStore.predefineColors" />
					</div>
				</el-form-item>
				<el-form-item label="标题颜色">
					<div>
						<el-color-picker v-model="diyStore.editComponent.desccolor" show-alpha
							:predefine="diyStore.predefineColors" />
					</div>
				</el-form-item>
				
			</el-form>
			<h3 class="mb-[10px]">佣金设置</h3>
			<el-form label-width="80px" class="px-[10px]">
				
				<el-form-item label="字体颜色">
					<div>
						<el-color-picker v-model="diyStore.editComponent.commissioncolor" show-alpha
							:predefine="diyStore.predefineColors" />
					</div>
				</el-form-item>
				<el-form-item label="字体大小">
					<el-slider v-model="diyStore.editComponent.commissionsize" max="40" show-input size="small"
						class="ml-[10px] horz-blank-slider" />
				</el-form-item>
				<el-form-item label="佣金背景">
					<div>
						<color-picker v-model:pureColor="diyStore.editComponent.cbcolor"
							v-model:gradientColor="diyStore.editComponent.cbcolor" format="hex6" shape="square"
							useType="both" />
					</div>
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