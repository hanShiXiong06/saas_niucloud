<!-- eslint-disable vue/multi-word-component-names -->
<template>
	<div class="main-container">
		<div class="flex ml-[18px] justify-between items-center mt-[20px]">
			<div class="detail-head !m-0">
				<div class="left" @click="router.push('/shop/order/delivery')">
					<span class="iconfont iconxiangzuojiantou !text-xs"></span>
					<span class="ml-[1px]">{{ t('returnToPreviousPage') }}</span>
				</div>
				<span class="adorn">|</span>
				<span class="right">{{ pageName }}</span>
			</div>
		</div>
		<el-form :model="formData" label-width="150px" ref="formRef" :rules="formRules" class="page-form"
			v-loading="loading">

			<el-card class="box-card !border-none" shadow="never">
				<el-card class="!border-none" shadow="never" style="width: 640px;">
					<el-alert type="warning" title="说明:支持1000多家以上快递物流公司查询，单号自动识别，接口稳定，高效。" :closable="false"
						show-icon />
				</el-card>
				<el-form-item label="是否启用" prop="interface_type" class="">
					<div>
						<el-radio-group v-model="formData.interface_type">
							<el-radio :label="1" size="large">关闭</el-radio>
							<el-radio :label="1001" size="large">启用</el-radio>
						</el-radio-group>
						<p class="text-[12px] text-[#b2b2b2]" v-if="formData.interface_type == 1001">
							启用将会切换niucloud-shop商城系统的物流查询为一号通接口
						</p>

					</div>
				</el-form-item>
			</el-card>
		</el-form>

		<div class="fixed-footer-wrap">
			<div class="fixed-footer">
				<el-button type="primary" :loading="loading" @click="save(formRef)">{{ t('save') }}</el-button>
			</div>
		</div>
	</div>
</template>

<script lang="ts" setup>
import { reactive, ref } from 'vue'
import { t } from '@/lang'
import { FormInstance, FormRules } from 'element-plus'
import { useRoute, useRouter } from 'vue-router'
import { setDeliverySearch, getDeliverySearch } from '@/addon/tk_yht/api/delivery'
import { getCommonConfig } from '@/addon/tk_yht/api/config'
import { checkShop } from '@/addon/tk_yht/api/checkshop'
import { ElMessage } from 'element-plus'
const route = useRoute()
const router = useRouter()
const pageName = route.meta.title

const loading = ref(true)
const getyhtConfig = async () => {
	const commondata = await getCommonConfig()
	if (commondata.data.access_key == 'AppId') {
		ElMessage({
			message: '请先完成通用配置，才能开启物流查询',
			type: 'info'
		})
		router.push('/commonconfig')
	} else {
		formData.yht_access_key = commondata.data.access_key
		formData.yht_secret_key = commondata.data.secret_key
	}
}
interface formDataType {
	interface_type: number
	kdniao_id: string
	kdniao_app_key: string
	kdniao_is_pay: number
	kd100_app_key: string
	kd100_customer: string
	yht_access_key: string
	yht_secret_key: string
}
const formData = reactive<formDataType | any>({
	interface_type: 1,
	kdniao_id: '',
	kdniao_app_key: '',
	kdniao_is_pay: 1,
	kd100_app_key: '',
	kd100_customer: '',
	yht_access_key: '',
	yht_secret_key: ''
})
const docheckshop = async () => {
	await checkShop()
	setFormData()
}
docheckshop()
const setFormData = async (id: number = 0) => {
	const data = await (await getDeliverySearch()).data
	Object.keys(formData).forEach((key: string) => {
		if (data[key] != undefined) formData[key] = data[key]
	})
	getyhtConfig()
	loading.value = false
}

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = reactive<FormRules>({
})

/**
 * 保存
 */
const save = async (formEl: FormInstance | undefined) => {
	if (loading.value || !formEl) return

	await formEl.validate(async (valid) => {
		if (valid) {
			loading.value = true
			setDeliverySearch(formData).then(() => {
				loading.value = false
			}).catch(() => {
				loading.value = false
			})
		}
	})
}

</script>

<style lang="scss" scoped>
.input-item {
	margin-bottom: 10px !important
}

.warm-prompt {
	margin-bottom: 10px !important
}

.button-size {
	font-size: 12px !important;
}

.el-radio.el-radio--large {
	height: auto !important
}
</style>
