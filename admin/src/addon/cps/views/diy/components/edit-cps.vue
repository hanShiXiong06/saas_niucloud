<template>
	<!-- 内容 -->
	<div class="content-wrap" v-show="diyStore.editTab == 'content'"> 
		<div class="edit-attr-item-wrap">
			<h3 class="mb-[10px]">组件设置</h3>
			<el-form label-width="80px" class="px-[10px]"> 
				<el-form-item label="选择组件">
					<el-radio-group v-model="diyStore.editComponent.style">
						<el-radio :label="'style-1'">美团好店</el-radio>
						<el-radio :label="'style-2'">美团秒杀</el-radio>
						<el-radio :label="'style-3'">景区门票</el-radio>
						<el-radio :label="'style-4'">折扣影票</el-radio>
 					</el-radio-group>
				</el-form-item>
			</el-form>
		</div> 
	</div> 
</template>

<script lang="ts" setup>
    import {t} from '@/lang'
    import useDiyStore from '@/stores/modules/diy'
    import {ref, reactive} from 'vue'

    const diyStore = useDiyStore()
    diyStore.editComponent.ignore = []; // 忽略公共属性

    const showDialog = ref(false)

    const showStyle = () => {
        showDialog.value = true
    }

    const selectStyle = ref(diyStore.editComponent.style)

 
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