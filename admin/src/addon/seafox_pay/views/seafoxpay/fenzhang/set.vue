<template>
	<!--PC端-->
	<div class="main-container">
		<el-card class="box-card !border-none" shadow="never">

			<div class="flex justify-between items-center">
				<span class="text-page-title">{{ pageName }}</span>
				<el-button type="primary" @click="handleChange">
					分账记录
				</el-button>
			</div>

			<el-form class="page-form mt-[20px]" :model="formData" label-width="150px" ref="formRef">


				<el-form-item label="分账状态">
					<!-- <el-radio-group v-model="formData.open">
						<el-radio label="1">开启</el-radio>
						<el-radio label="0">关闭</el-radio>
					</el-radio-group> -->
					<el-switch v-model="formData.open" />
				</el-form-item>

				<el-form-item label="分账设置">
					<div>
						<div v-for="(item,index) in fenlist" style="margin-bottom:30px;">
							<div style="display: flex; margin-bottom:10px;">
								<span style="margin:0 0;">【{{index+1}}】 分账商户号 </span>
								<el-input v-model="item.mch_id" style="width: 250px;margin-left:10px;" clearable
									:placeholder="t('填写分账商户号')" class="input-width" />
								<!-- <el-select class="input-width" style="width: 150px" v-model="item.mer_id" clearable :placeholder="t('分账方')">
									<el-option label="请选择" value=""></el-option>
									<el-option v-for="(item2, index2) in merList" :key="index2" :label="item2.name"
										:value="item2.value" />
								</el-select> -->
								<el-button type="danger" plain @click="del(index)" style="margin:0 10px">删除</el-button>
							</div>
							<div style="margin-left:40px;">
								<div style="display: flex; margin-bottom:20px;">
									<div style="display: flex; ">
										<div style="margin-right: 15px;">
											分账方式 :
										</div>
										<el-radio-group v-model="item.type">
											<el-radio :value="1">按比例</el-radio>
											<el-radio :value="2">按固定金额</el-radio>
										</el-radio-group>
									</div>

								</div>
								<div v-if="item.type==1" style="display: flex;margin-bottom:20px;">
									<span style="margin-right:10px;">分账比例</span>
									<el-select class="input-width" style="width: 100px" v-model="item.rate_key"
										clearable :placeholder="t('分账方式')">
										<el-option label="增加" value="1" />
										<el-option label="扣除" value="0" />
									</el-select>
									<el-input v-model="item.price" style="width: 100px" clearable :placeholder="t('金额')"
										class="input-width" />
									<span style="margin:0 10px">元 + </span>

									<el-input v-model="item.rate" style="width: 100px" clearable :placeholder="t('比例')"
										class="input-width" /> <span style="margin:0 10px"> %</span>
									<!-- <span style="margin:0 15px;">分账金额</span>
									<el-select class="input-width" v-model="item.rate_key" style="width: 100px" clearable :placeholder="t('分账方式')">
										<el-option label="增加" value="1" />
										<el-option label="扣除" value="0" />
									</el-select> -->
									<span style="margin:0 10px;"></span>
								</div>
								<div v-if="item.type==2" style="display: flex;margin-bottom:20px;">
									<span style="margin-right:10px;">分账金额:</span>

									<el-input v-model="item.price" style="width: 100px" clearable :placeholder="t('金额')"
										class="input-width" />
									<span style="margin:0 10px">元 </span>
									<span style="margin:0 10px;"></span>
								</div>
							</div>
							<el-divider border-style="dashed" />
						</div>
						<el-button type="primary" plain @click="addfen">追加</el-button>
					</div>
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
	import { getset, saveset, selectmerlist } from '@/addon/seafox_pay/api/fenzhang'

	const route = useRoute()
	const pageName = route.meta.title
	const loading = ref(true)

	const formData = reactive<Record<string, string | boolean | any>>({
		fenlist: [],
		open: 0
	})

	const formRef = ref<FormInstance>()

	const fenlist = ref([]);
	const merList = ref([]);
	const merchant_id = ref('');
	merchant_id.value = localStorage.getItem('seafoxpay_sid')


	getset({
		merchant_id: merchant_id.value
	}).then(res => {
		// Object.assign(formData, res.data)
		formData.open = res.data.open == 1 ? true : false
		fenlist.value = res.data.fenlist

	})
	// selectmerlist({ 
	// }).then(res => {
	// 	Object.assign(merList, res.data)
	// 	// formData.open = res.data.open

	// })



	/**
	 * 保存
	 */
	const save = async (formEl : FormInstance | undefined) => {
		const data = {};
		data.open = formData.open ? 1 : 0;
		data.merchant_id = merchant_id.value
		data.fenlist = fenlist.value
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
		fenlist.value.push({
			type: 1,
			mer_id: '',
			rate: '',
			price: '',
			price_key: '1',
		})
	}
	const del = (index) => {
		fenlist.value.splice(index, 1)
	}
</script>

<style lang="scss" scoped>
	.visit-btn {
		color: var(--el-color-primary);
	}
</style>