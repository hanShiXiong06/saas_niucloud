<template>
    <!--打款设置-->
    <div class="main-container">

        <el-card class="box-card !border-none" shadow="never">
            <div class="flex justify-between items-center">
                <span class="text-page-title">{{ pageName }}</span>
            </div>

            <div class="mt-[20px]">
                <el-alert type="warning" show-icon>
                    <template #title>
                        <span class="!text-[14px]">{{ t('operationTip') }}</span>
                    </template>
                </el-alert>
            </div>
        </el-card>

        <el-form class="page-form" :model="formData" label-width="200px" ref="formRef" :rules="formRules" v-loading="loading">
            <el-card class="box-card mt-[15px] !border-none" shadow="never">
                <h3 class="panel-title !text-sm">{{t('wechatpay')}}</h3>

                <el-form-item :label="t('mchId')" prop="wechatpay_config.mch_id">
                    <el-input v-model.trim="formData.wechatpay_config.mch_id" :placeholder="t('mchIdPlaceholder')" class="input-width" maxlength="32" show-word-limit clearable />
                    <div class="form-tip">{{ t('mchIdTips') }}</div>
                </el-form-item>
                <el-form-item :label="t('mchSecretKey')" prop="wechatpay_config.mch_secret_key">
                    <el-input v-model.trim="formData.wechatpay_config.mch_secret_key" :placeholder="t('mchSecretKeyPlaceholder')" class="input-width" maxlength="32" show-word-limit clearable />
                    <div class="form-tip">{{ t('mchSecretKeyTips') }}</div>
                </el-form-item>
                <el-form-item :label="t('mchSecretCert')" prop="wechatpay_config.mch_secret_cert">
                    <div class="input-width">
                        <upload-file v-model="formData.wechatpay_config.mch_secret_cert" api="sys/document/wechat" />
                    </div>
                    <div class="form-tip">{{ t('mchSecretCertTips') }}</div>
                </el-form-item>
                <el-form-item :label="t('mchPublicCertPath')" prop="wechatpay_config.mch_public_cert_path">
                    <div class="input-width">
                        <upload-file v-model="formData.wechatpay_config.mch_public_cert_path" api="sys/document/wechat" />
                    </div>
                    <div class="form-tip">{{ t('mchPublicCertPathTips') }}</div>
                </el-form-item>
                <el-form-item :label="t('wechatpayPublicCert')" prop="wechatpay_config.wechat_public_cert_path">
                    <div class="input-width">
                        <upload-file v-model="formData.wechatpay_config.wechat_public_cert_path" api="sys/document/wechat" />
                    </div>
                </el-form-item>

                <el-form-item :label="t('wechatpayPublicCertId')" prop="wechatpay_config.wechat_public_cert_id">
                    <div class="input-width">
                        <el-input v-model.trim="formData.wechatpay_config.wechat_public_cert_id" placeholder="" class="input-width" show-word-limit clearable />
                    </div>
                </el-form-item>
            </el-card>

            <!-- <el-card class="box-card mt-[15px] !border-none" shadow="never">
                <h3 class="panel-title !text-sm">{{t('alipay')}}</h3>

                <el-form-item :label="t('appId')" prop="alipay_config.app_id">
                    <el-input v-model.trim="formData.alipay_config.app_id" :placeholder="t('appIdPlaceholder')" class="input-width" maxlength="32" show-word-limit clearable />
                    <div class="form-tip">{{ t('appIdTips') }}</div>
                </el-form-item>
                <el-form-item :label="t('appSecretCert')" prop="alipay_config.app_secret_cert">
                    <el-input v-model.trim="formData.alipay_config.app_secret_cert" :placeholder="t('appSecretCertPlaceholder')" class="input-width" type="textarea" rows="4" clearable />
                </el-form-item>
                <el-form-item :label="t('appPublicCertPath')" prop="alipay_config.app_public_cert_path">
                    <div class="input-width">
                        <upload-file v-model="formData.alipay_config.app_public_cert_path" api="sys/document/aliyun" />
                    </div>
                </el-form-item>
                <el-form-item :label="t('alipayPublicCertPath')" prop="alipay_config.alipay_public_cert_path">
                    <div class="input-width">
                        <upload-file v-model="formData.alipay_config.alipay_public_cert_path" api="sys/document/aliyun" />
                    </div>
                </el-form-item>
                <el-form-item :label="t('alipayRootCertPath')" prop="alipay_config.alipay_root_cert_path">
                    <div class="input-width">
                        <upload-file v-model="formData.alipay_config.alipay_root_cert_path" api="sys/document/aliyun" />
                    </div>
                </el-form-item>
            </el-card> -->
        </el-form>

        <div class="fixed-footer-wrap">
            <div class="fixed-footer">
                <el-button type="primary" :loading="loading" @click="save(formRef)">{{ t('save') }}</el-button>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, computed } from 'vue'
import { t } from '@/lang'
import { getTransferInfo, setTransferInfo } from '@/app/api/sys'
import { FormInstance } from 'element-plus'
import { useRoute } from 'vue-router'

const route = useRoute()
const pageName = route.meta.title

const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    wechatpay_config: {
        mch_id: '',
        mch_secret_key: '',
        mch_secret_cert: '',
        mch_public_cert_path: '',
        wechat_public_cert_path: '',
        wechat_public_cert_id: ''
    },
    alipay_config: {
        app_secret_cert: '',
        app_public_cert_path: '',
        alipay_public_cert_path: '',
        alipay_root_cert_path: '',
        app_id: ''
    }
}
const formData: Record<string, any> = reactive({ ...initialFormData })

// 获取提款信息
const transferInfoF = async () => {
    loading.value = true
    const val = await (await getTransferInfo('transfer')).data
    if (val && val.length) {
        formData.wechatpay_config = val[0].config
        formData.alipay_config = val[1].config
    }
    loading.value = false
}
transferInfoF()

const formRef = ref<FormInstance>()
// 表单验证规则
const formRules = computed(() => {
    return {
        // 'wechatpay_config.mch_id': [
        //     { required: true, message: t('mchIdPlaceholder'), trigger: 'blur' }
        // ],
        // 'wechatpay_config.mch_secret_key': [
        //     { required: true, message: t('mchSecretKeyPlaceholder'), trigger: 'blur' }
        // ],
        // 'wechatpay_config.mch_secret_cert': [
        //     { required: true, message: t('mchSecretCertPlaceholder'), trigger: 'blur' }
        // ],
        // 'wechatpay_config.mch_public_cert_path': [
        //     { required: true, message: t('mchPublicCertPathPlaceholder'), trigger: 'blur' }
        // ],
        // 'alipay_config.app_id': [
        //     { required: true, message: t('appIdPlaceholder'), trigger: 'blur' }
        // ],
        // 'alipay_config.app_secret_cert': [
        //     { required: true, message: t('appSecretCertPlaceholder'), trigger: 'blur' }
        // ],
        // 'alipay_config.app_public_cert_path': [
        //     { required: true, message: t('appPublicCertPathPlaceholder'), trigger: 'blur' }
        // ],
        // 'alipay_config.alipay_public_cert_path': [
        //     { required: true, message: t('alipayPublicCertPathPlaceholder'), trigger: 'blur' }
        // ],
        // 'alipay_config.alipay_root_cert_path': [
        //     { required: true, message: t('alipayRootCertPathPlaceholder'), trigger: 'blur' }
        // ]
    }
})

/**
 * 确认
 * @param formEl
 */
const save = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return

    await formEl.validate(async (valid) => {
        if (valid) {
            loading.value = true

            const data = formData
            setTransferInfo(data).then(res => {
                loading.value = false
            }).catch(() => {
                loading.value = false
            })
        }
    })
}
</script>

<style lang="scss" scoped></style>
