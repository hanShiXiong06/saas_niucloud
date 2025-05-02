<template>
	<!--PC端-->
	<div class="main-container">
		<el-card class="box-card !border-none" shadow="never">

			<div class="flex justify-between items-center">
				<span class="text-page-title">{{ pageName }}</span>
			</div>

			<el-form class="page-form mt-[20px]" :model="formData" label-width="150px" ref="formRef">

				<div style="display: flex;">
					<el-form-item label="发帖状态">
						<el-switch v-model="formData.open_fatie" />
					</el-form-item>
					<!-- <el-divider border-style="dashed" /> -->
					<el-form-item label="评论状态">
						<el-switch v-model="formData.open_ping" />
					</el-form-item>
					<el-form-item label="发帖需审核">
						<el-switch v-model="formData.open_fatie_shenhe" />
					</el-form-item>
				</div>
				

				<div style="display: flex;">
					<!-- <el-divider border-style="dashed" /> -->

					<el-form-item label="社群功能">
						<el-switch v-model="formData.open_shequn" />
					</el-form-item>
					<el-form-item label="展示点赞量">
						<el-switch v-model="formData.show_like_num" />
					</el-form-item>
					
					<el-form-item label="帖子显示评论量">
						<el-switch v-model="formData.show_ping_num" />
					</el-form-item> 
				</div>
				<el-form-item class="text-xs" label="列表展示模式">
					<el-radio-group v-model="formData.list_type">
						<el-radio :label="1">帖子形式</el-radio>
						<el-radio :label="2">瀑布流形式</el-radio>
					</el-radio-group>
				</el-form-item>
				<el-form-item label="发布强制上传图片">
					<div style="display: flex;align-items: center;">
						<el-switch v-model="formData.open_fatie_shenhe" />
						<el-tag type="primary" style="margin-left: 20px;">如果使用瀑布流列表形式, 请开启强制上传图片</el-tag>
					</div>
				</el-form-item>
				<el-form-item class="text-xs" label="菜单展示数量">
					<el-radio-group v-model="formData.menu_num">
						<el-radio :label="3">3个</el-radio>
						<el-radio :label="4">4个</el-radio>
						<el-radio :label="5">5个</el-radio>
						<el-radio :label="6">6个</el-radio>
					</el-radio-group>
				</el-form-item>

				<el-form-item label="浏览虚拟量">
					<el-input v-model="formData.views_num" class="input-width" placeholder="前端显示数量 = 虚拟数量 + 实际数量" />
				</el-form-item>
				<el-form-item label="帖子虚拟量">
					<el-input v-model="formData.tie_num" class="input-width" placeholder="前端显示数量 = 虚拟数量 + 实际数量" />
				</el-form-item>
				<el-form-item label="转发虚拟量">
					<el-input v-model="formData.zan_num" class="input-width" placeholder="前端显示数量 = 虚拟数量 + 实际数量" />
				</el-form-item>
				<el-form-item label="商家虚拟量">
					<el-input v-model="formData.author_num" class="input-width" placeholder="前端显示数量 = 虚拟数量 + 实际数量" />
				</el-form-item>
				<!-- <el-form-item label="主题色">
					<el-color-picker v-model="formData.color"></el-color-picker>
				</el-form-item> -->
			
				<el-divider border-style="dashed" />
				<el-form-item label="置顶开关">
					<el-switch v-model="formData.open_top" />
				</el-form-item>
				<el-form-item label="置顶设置">
					<div>
						<div v-for="(item,index) in top_json" style="margin-bottom:30px;">
							<div style="display: flex; margin-bottom:10px;">
								<span style="margin:0 0;"> 置顶天数 </span>
								<el-input v-model="item.daynum" style="width: 150px;margin-left:10px;" clearable type="number"
									:placeholder="t('置顶天数')" class="input-width" />
								<span style="margin:0 0;"> 置顶价格 </span>
								<el-input v-model="item.price" style="width: 150px;margin-left:10px;" clearable type="number"
									:placeholder="t('置顶价格')" class="input-width" />
								<el-button type="danger" plain @click="del(index)" style="margin:0 10px">删除</el-button>
							</div>

						</div>
						<el-button type="primary" plain @click="addfen">追加</el-button>
					</div>
				</el-form-item>
				<!--  <el-form-item :label="t('分享刷新宣传图')">
				     <upload-image v-model="formData.shuaxin_image" />
				 </el-form-item>
				 -->
				<el-divider border-style="dashed" />
				<el-form-item label="发帖免责协议">
					<editor v-model="formData.mianze" :min-height="122" />
				</el-form-item>



			</el-form>
		</el-card>

		<div class="fixed-footer-wrap">
			<div class="fixed-footer">
				<el-button type="primary" @click="save(formRef)">{{ t('save') }}</el-button>
			</div>
		</div>
	</div>
</template>

<script lang="ts" setup>
	import { reactive, ref, watch } from 'vue'
	import { t } from '@/lang'
	import { getUrl } from '@/app/api/sys'
	import { ElMessage, FormInstance } from 'element-plus'
	import { useRoute } from 'vue-router'
	import { getset, saveset } from '@/addon/blog/api/config'

	const route = useRoute()
	const pageName = route.meta.title
	const loading = ref(true)
	const top_json = ref([])

	const formData = reactive<Record<string, string | boolean | any>>({

	})

	const formRef = ref<FormInstance>()


	getset({

	}).then(res => {
		// Object.assign(formData, res.data)
		top_json.value = res.data.top_json
		formData.show_ping_num = res.data.show_ping_num == 1 ? true : false
		formData.open_top = res.data.open_top == 1 ? true : false
		formData.show_like_num = res.data.show_like_num == 1 ? true : false
		formData.open_ping = res.data.open_ping == 1 ? true : false
		formData.open_fatie_shenhe = res.data.open_fatie_shenhe == 1 ? true : false
		formData.open_fatie = res.data.open_fatie == 1 ? true : false
		formData.open_shequn = res.data.open_shequn == 1 ? true : false
		formData.mianze = res.data.mianze
		formData.tie_num = res.data.tie_num
		formData.zan_num = res.data.zan_num
		formData.author_num = res.data.author_num
		formData.views_num = res.data.views_num
		formData.shuaxin_image = res.data.shuaxin_image
		formData.list_type = res.data.list_type
		formData.menu_num = res.data.menu_num
		formData.color = res.data.color
		formData.need_image = res.data.need_image
	})

	const save = async (formEl : FormInstance | undefined) => {
		const data = {};
		data.mianze = formData.mianze;
		data.tie_num = formData.tie_num;
		data.zan_num = formData.zan_num;
		data.author_num = formData.author_num;
		data.views_num = formData.views_num;
		data.shuaxin_image = formData.shuaxin_image;
		data.open_fatie = formData.open_fatie ? 1 : 0;
		data.open_ping = formData.open_ping ? 1 : 0;
		data.open_fatie_shenhe = formData.open_fatie_shenhe ? 1 : 0;
		data.open_top = formData.open_top ? 1 : 0;
		data.show_like_num = formData.show_like_num ? 1 : 0;
		data.show_ping_num = formData.show_ping_num ? 1 : 0;
		data.open_shequn = formData.open_shequn ? 1 : 0;
		data.list_type = formData.list_type;
		data.menu_num = formData.menu_num;
		data.color = formData.color;
		data.need_image = formData.need_image;

		data.top_json = JSON.stringify(top_json.value);
		saveset(data).then(() => {
			ElMessage({
				message: '提交成功',
				type: 'success',
			})
			loading.value = false

		}).catch(() => {
			loading.value = false
		})
	}
	// addfen();
	const addfen = () => {
		top_json.value.push({
			daynum: '',
			price: ''
		})
	}
	const del = (index) => {
		top_json.value.splice(index, 1)
	}
</script>

<style lang="scss" scoped>
	.visit-btn {
		color: var(--el-color-primary);
	}
</style>