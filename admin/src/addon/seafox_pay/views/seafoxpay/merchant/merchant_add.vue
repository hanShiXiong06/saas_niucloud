<template>
    <div class="main-container">

        <el-card class="card !border-none" shadow="never">
            <el-page-header :content="pageName" :icon="ArrowLeft" @back="$router.back()" />
        </el-card>

        <el-card class="box-card mt-[15px] !border-none" shadow="never" v-loading="loading">
            <el-form :model="formData" label-width="90px" ref="formRef" :rules="formRules" class="page-form">

                <el-form-item label="商家名称">
                    <el-input v-model.trim="formData.name" class="input-width" />
                </el-form-item>
 <el-form-item label="商家号">
                    <el-input v-model.trim="formData.mch_id" class="input-width" />
                </el-form-item>
                <el-form-item label="LOGO" prop="logo">
                    <upload-image v-model="formData.logo" />
                </el-form-item>
  
            </el-form>
        </el-card>

        <div class="fixed-footer-wrap">
            <div class="fixed-footer">
                <el-button type="primary" @click="onSave(formRef)">{{ t('save') }}</el-button>
                <el-button @click="back()">{{ t('cancel') }}</el-button>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref, reactive, computed } from 'vue'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import { ArrowLeft } from '@element-plus/icons-vue'
import { addMerchant,editMerchant  } from '@/addon/seafox_pay/api/merchant'
import { useRoute, useRouter } from 'vue-router'
import useTabbarStore from '@/stores/modules/tabbar'

const route = useRoute()
const router = useRouter()
const loading = ref(false)
const tabbarStore = useTabbarStore()
let pageName = route.meta.title

/**
 * 表单数据
 */
const initialFormData = { 
    name: '',
    mch_id: '',
    logo: '',
    id: '',
}



const formData: Record<string, any> = reactive({ ...initialFormData })
const formRef = ref<FormInstance>()

const merchant_id: number = Number(route.query.merchant_id)||0;
if(merchant_id>0){
	const seafoxpay_row = JSON.parse(localStorage.getItem('seafoxpay_row'))
	console.log(seafoxpay_row);
	formData.id =seafoxpay_row.id;
	formData.name =seafoxpay_row.name;
	formData.logo =seafoxpay_row.logo;
	formData.mch_id =seafoxpay_row.mch_id;
	pageName = '编辑商户';
}

// 表单验证规则
const formRules = computed(() => {
    return {
        name: [
            { required: true, message: '请输入商家名称', trigger: 'blur' }
        ]
    }
})

const onSave = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    await formEl.validate(async (valid) => {
        if (valid) {
            loading.value = true
			if(Number(formData.id)>0){
				editMerchant(formData).then(res => {
				    loading.value = false
				    back()
				}).catch(() => {
				    loading.value = false
				})
			}else{
				addMerchant(formData).then(res => {
				    loading.value = false
				    back()
				}).catch(() => {
				    loading.value = false
				})
			}
            
        }
    })
}

const back = () => {
    tabbarStore.removeTab(route.path)
    router.push({ path: '/seafoxpay/merchant/merchant' })
}
</script>

<style lang="scss" scoped></style>
