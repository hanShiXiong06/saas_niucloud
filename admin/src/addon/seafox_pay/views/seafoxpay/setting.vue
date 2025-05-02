<template>
    <!--PC端-->
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-page-title">{{ pageName }}</span>
            </div>

            <el-form class="page-form mt-[20px]" :model="formData" label-width="150px" ref="formRef">

                <el-form-item label="商户编号">
                    <el-input v-model="formData.firstClassMerchantNo" class="input-width"></el-input>
                </el-form-item>

                <el-form-item label="公共产品的加密key">
                    <el-input v-model="formData.public_encryption" class="input-width"></el-input>
                </el-form-item>

                <el-form-item label="公共产品的签名key">
                    <el-input v-model="formData.public_autograph" class="input-width"></el-input>
                </el-form-item>

                <el-form-item label="扫码产品的加密key">
                    <el-input v-model="formData.scancode_encryption" class="input-width"></el-input>
                </el-form-item>

                <el-form-item label="扫码产品的签名key">
                    <el-input v-model="formData.scancode_autograph" class="input-width"></el-input>
                </el-form-item>

                <el-form-item label="商户私钥">
                    <el-input v-model="formData.merchant_privateKey" class="input-width"></el-input>
                </el-form-item>

                <el-form-item label="渠道名">
                    <el-input v-model="formData.merchant_cannelName" class="input-width"></el-input>
                </el-form-item>

                <el-form-item label="小程序appid">
                    <el-input v-model="formData.receiptAppIds" class="input-width"></el-input>
                </el-form-item>

                <el-form-item label="app报备微信图片">
                    <div>
                        <upload-image v-model="formData.app_product_wechat_qrcode" />
                    </div>
                </el-form-item>

                <el-form-item label="app报备支付宝图片">
                    <div>
                        <upload-image v-model="formData.app_product_alipay_qrcode" />
                    </div>
                </el-form-item>

            </el-form>
        </el-card>

        <div class="fixed-footer-wrap">
            <div class="fixed-footer">
                <el-button type="primary" :loading="loading" @click="save(formRef)">{{ t('save') }}</el-button>
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
import { getConfig ,setConfig } from '@/addon/seafox_pay/api/setting'

const route = useRoute()
const pageName = route.meta.title
const loading = ref(true)

const formData = reactive<Record<string, string | boolean | any>>({
    firstClassMerchantNo: '',
    public_encryption:'',
    public_autograph:'',
    scancode_encryption:'',
    scancode_autograph:'',
    merchant_privateKey:'',
    merchant_cannelName:'',
    receiptAppIds:'',
    app_product_wechat_qrcode:'',
    app_product_alipay_qrcode:''
})

const formRef = ref<FormInstance>()

/**
 * 获取海狐聚合支付配置
 */
 getConfig().then(res => {
    // Object.assign(formData, res.data)
    formData.firstClassMerchantNo = res.data.firstClassMerchantNo 
    formData.public_encryption = res.data.public_encryption 
    formData.public_autograph = res.data.public_autograph 
    formData.scancode_encryption = res.data.scancode_encryption 
    formData.scancode_autograph = res.data.scancode_autograph 
    formData.merchant_privateKey = res.data.merchant_privateKey
    formData.merchant_cannelName = res.data.merchant_cannelName 
    formData.receiptAppIds = res.data.receiptAppIds
    formData.app_product_wechat_qrcode = res.data.app_product_wechat_qrcode
    formData.app_product_alipay_qrcode = res.data.app_product_alipay_qrcode
    loading.value = false
})


/**
 * 保存
 */
const save = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return

    await formEl.validate(async (valid) => {
        if (valid) {
            loading.value = true
            const data = { ...formData }
            setConfig(data).then(() => {
                loading.value = false
            }).catch(() => {
                loading.value = false
            })
        }
    })
}
</script>

<style lang="scss" scoped>
    .visit-btn {
        color: var(--el-color-primary);
    }
</style>
