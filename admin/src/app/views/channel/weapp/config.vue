<template>
    <!--小程序配置-->
    <div class="main-container">

        <el-card class="card !border-none" shadow="never">
            <el-page-header :content="pageName" :icon="ArrowLeft" @back="back()" />
        </el-card>

        <el-form class="page-form mt-[15px]" :model="formData" label-width="170px" ref="formRef" :rules="formRules" v-loading="loading">
            <el-card class="box-card !border-none" shadow="never">
                <h3 class="panel-title !text-sm">{{ t('weappInfo') }}</h3>

                <el-form-item :label="t('weappName')" prop="weapp_name">
                    <el-input v-model.trim="formData.weapp_name" :placeholder="t('weappNamePlaceholder')" class="input-width" clearable :readonly="formData.is_authorization"/>
                </el-form-item>

                <el-form-item :label="t('weappOriginal')" prop="weapp_original">
                    <el-input v-model.trim="formData.weapp_original" :placeholder="t('weappOriginalPlaceholder')" class="input-width" clearable :readonly="formData.is_authorization"/>
                </el-form-item>

                <el-form-item :label="t('weappQrcode')" prop="qr_code">
                    <upload-image v-model="formData.qr_code" />
                    <div class="form-tip">{{ t('weappQrcodeTips') }}</div>
                </el-form-item>
            </el-card>

            <el-card class="box-card !border-none mt-[15px]" shadow="never">
                <h3 class="panel-title !text-sm">{{ t('weappDevelopInfo') }}</h3>

                <el-form-item :label="t('weappAppid')" prop="app_id">
                    <el-input v-model.trim="formData.app_id" :placeholder="t('appidPlaceholder')" class="input-width" clearable :readonly="formData.is_authorization"/>
                    <div class="form-tip">{{ t('weappAppidTips') }}</div>
                </el-form-item>

                <el-form-item :label="t('weappAppsecret')" prop="app_secret" v-if="!formData.is_authorization">
                    <el-input v-model.trim="formData.app_secret" :placeholder="t('appSecretPlaceholder')" class="input-width" clearable />
                    <div class="form-tip">{{ t('weappAppsecretTips') }}</div>
                </el-form-item>
            </el-card>

            <el-card class="box-card !border-none mt-[15px]" shadow="never" v-if="!formData.is_authorization">
                <h3 class="panel-title !text-sm">{{ t('weappUpload') }}</h3>

                <el-form-item :label="t('uploadKey')" prop="upload_private_key">
                    <div class="input-width">
                        <upload-file v-model="formData.upload_private_key" api="sys/document/wechat" />
                    </div>
                    <div class="form-tip">{{ t('uploadKeyTips') }}</div>
                    <div class="form-tip">{{ t('uploadIpTips') }}{{ formData.upload_ip }}</div>
                </el-form-item>
            </el-card>

            <el-card class="box-card !border-none mt-[15px]" shadow="never" v-show="!formData.is_authorization">
                <h3 class="panel-title !text-sm">{{ t('theServerSetting') }}</h3>

                <el-form-item label="URL">
                    <el-input :model-value="formData.serve_url" placeholder="Please input" class="input-width" :readonly="true">
                        <template #append>
                            <div class="cursor-pointer" @click="copyEvent(formData.serve_url)">{{ t('copy') }}</div>
                        </template>
                    </el-input>
                </el-form-item>

                <el-form-item label="Token" prop="token">
                    <el-input v-model.trim="formData.token" :placeholder="t('tokenPlaceholder')" class="input-width" maxlength="32" show-word-limit clearable />
                    <div class="form-tip">{{ t('tokenTips') }}</div>
                </el-form-item>

                <el-form-item label="EncodingAESKey" prop="encoding_aes_key">
                    <el-input v-model.trim="formData.encoding_aes_key" :placeholder="t('encodingAesKeyPlaceholder')" class="input-width" maxlength="43" show-word-limit clearable />
                    <div class="form-tip">{{ t('encodingAESKeyTips') }}</div>
                </el-form-item>

                <el-form-item :label="t('encryptionType')" prop="encryption_type">
                    <el-radio-group v-model="formData.encryption_type">
                        <el-radio label="not_encrypt">{{ t('cleartextMode') }}</el-radio>
                        <el-radio label="compatible">{{ t('compatibleMode') }}</el-radio>
                        <el-radio label="safe">{{ t('safeMode') }}</el-radio>
                    </el-radio-group>
                    <div class="form-tip">{{ t('cleartextModeTips') }}</div>
                    <div class="form-tip">{{ t('compatibleModeTips') }}</div>
                    <div class="form-tip">{{ t('safeModeTips') }}</div>
                </el-form-item>
            </el-card>

            <el-card class="box-card !border-none mt-[15px]" shadow="never">
                <div class="flex items-start justify-between">
                    <h3 class="panel-title !text-sm">{{ t('functionSetting') }}</h3>
                    <el-button type="primary" link @click="modifyDomainFn" v-if="formData.is_authorization">{{ t('update') }}</el-button>
                </div>

                <div v-if="!formData.is_authorization">
                    <el-form-item :label="t('requestUrl')">
                        <el-input :model-value="formData.request_url" placeholder="Please input" class="input-width" :readonly="true">
                            <template #append>
                                <div class="cursor-pointer" @click="copyEvent(formData.request_url)">{{ t('copy') }}</div>
                            </template>
                        </el-input>
                    </el-form-item>
                    <el-form-item :label="t('socketUrl')">
                        <el-input :model-value="formData.socket_url" placeholder="Please input" class="input-width" :readonly="true">
                            <template #append>
                                <div class="cursor-pointer" @click="copyEvent(formData.socket_url)">{{ t('copy') }}</div>
                            </template>
                        </el-input>
                    </el-form-item>
                    <el-form-item :label="t('uploadUrl')">
                        <el-input :model-value="formData.upload_url" placeholder="Please input" class="input-width" :readonly="true">
                            <template #append>
                                <div class="cursor-pointer" @click="copyEvent(formData.upload_url)">{{ t('copy') }}</div>
                            </template>
                        </el-input>
                    </el-form-item>
                    <el-form-item :label="t('downloadUrl')">
                        <el-input :model-value="formData.download_url" placeholder="Please input" class="input-width" :readonly="true">
                            <template #append>
                                <div class="cursor-pointer" @click="copyEvent(formData.download_url)">{{ t('copy') }}</div>
                            </template>
                        </el-input>
                    </el-form-item>
                </div>
                <div v-else>
                    <el-form-item :label="t('requestUrl')">
                        <div v-if="formData.domain.requestdomain">{{ formData.domain.requestdomain }}</div>
                        <div v-else>-</div>
                    </el-form-item>
                    <el-form-item :label="t('socketUrl')">
                        <div v-if="formData.domain.wsrequestdomain">{{ formData.domain.wsrequestdomain }}</div>
                        <div v-else>-</div>
                    </el-form-item>
                    <el-form-item :label="t('uploadUrl')">
                        <div v-if="formData.domain.uploaddomain">{{ formData.domain.uploaddomain }}</div>
                        <div v-else>-</div>
                    </el-form-item>
                    <el-form-item :label="t('downloadUrl')">
                        <div v-if="formData.domain.downloaddomain">{{ formData.domain.downloaddomain }}</div>
                        <div v-else>-</div>
                    </el-form-item>
                    <el-form-item :label="t('udpUrl')">
                        <div v-if="formData.domain.udpdomain">{{ formData.domain.udpdomain }}</div>
                        <div v-else>-</div>
                    </el-form-item>
                    <el-form-item :label="t('tcpUrl')">
                        <div v-if="formData.domain.tcpdomain">{{ formData.domain.tcpdomain }}</div>
                        <div v-else>-</div>
                    </el-form-item>
                </div>
            </el-card>

            <el-card class="box-card !border-none mt-[15px]" shadow="never" v-if="formData.is_authorization">
                <div class="flex items-start justify-between">
                    <h3 class="panel-title !text-sm">{{ t('serviceContentStatement') }}</h3>
                </div>
                <el-form-item :label="t('privacyAgreement')">
                    <div class="flex items-center">
                        <div class="form-tip !mt-0">{{ t('privacyAgreementTips') }}</div>
                        <el-button type="primary" link @click="modifyPrivacyAgreementFn">{{ t('setting') }}</el-button>
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

    <modify-domain ref="modifyDomainRef" @complete="modifyDomainComplete"/>
    <modify-privacy-agreement :config="formData" ref="modifyPrivacyAgreementRef"/>
</template>

<script lang="ts" setup>
import { reactive, ref, watch, computed } from 'vue'
import { t } from '@/lang'
import { getWeappConfig, setWeappConfig } from '@/app/api/weapp'
import { useClipboard } from '@vueuse/core'
import { ElMessage, FormInstance } from 'element-plus'
import { ArrowLeft } from '@element-plus/icons-vue'
import { useRoute, useRouter } from 'vue-router'
import ModifyDomain from '@/app/views/channel/weapp/components/modify-domain.vue'
import ModifyPrivacyAgreement from '@/app/views/channel/weapp/components/modify-privacy-agreement.vue'

const route = useRoute()
const router = useRouter()
const pageName = route.meta.title
const back = () => {
    router.push('/channel/weapp')
}
const loading = ref(true)

const formData = reactive<Record<string, any>>({
    weapp_name: '',
    weapp_original: '',
    app_id: '',
    app_secret: '',
    qr_code: '',
    token: '',
    encoding_aes_key: '',
    encryption_type: 'not_encrypt',
    serve_url: '',
    request_url: '',
    socket_url: '',
    upload_url: '',
    download_url: '',
    upload_private_key: '',
    is_authorization: 0,
    domain: {
        requestdomain: '',
        wsrequestdomain: '',
        uploaddomain: '',
        downloaddomain: '',
        tcpdomain: '',
        udpdomain: ''
    }
})

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
        weapp_name: [
            { required: true, message: t('weappNamePlaceholder'), trigger: 'blur' }
        ],
        weapp_original: [
            { required: true, message: t('weappOriginalPlaceholder'), trigger: 'blur' }
        ],
        app_id: [
            { required: true, message: t('appidPlaceholder'), trigger: 'blur' }
        ],
        app_secret: [
            { required: !formData.is_authorization, message: t('appSecretPlaceholder'), trigger: 'blur' }
        ],
        token: [
            { required: !formData.is_authorization, message: t('tokenPlaceholder'), trigger: 'blur' }
        ],
        encoding_aes_key: [
            { required: !formData.is_authorization, message: t('encodingAesKeyPlaceholder'), trigger: 'blur' }
        ]
    }
})

/**
 * 获取微信配置
 */
getWeappConfig().then(res => {
    Object.assign(formData, res.data)
    loading.value = false
})

getWeappConfig().then(res => {
    Object.assign(res.data)
})

/**
 * 复制
 */
const { copy, isSupported, copied } = useClipboard()
const copyEvent = (text: string) => {
    if (!isSupported.value) {
        ElMessage({
            message: t('notSupportCopy'),
            type: 'warning'
        })
        return
    }
    copy(text)
}

watch(copied, () => {
    if (copied.value) {
        ElMessage({
            message: t('copySuccess'),
            type: 'success'
        })
    }
})

/**
 * 保存
 */
const save = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return

    await formEl.validate(async (valid) => {
        if (valid) {
            loading.value = true
            setWeappConfig(formData).then(() => {
                loading.value = false
            }).catch(() => {
                loading.value = false
            })
        }
    })
}

const modifyDomainRef = ref(null)
const modifyDomainFn = () => {
    modifyDomainRef.value.setFormData(formData.domain)
    modifyDomainRef.value.showDialog = true
}

const modifyDomainComplete = (data) => {
    formData.domain = data
}

const modifyPrivacyAgreementRef = ref(null)
const modifyPrivacyAgreementFn = () => {
    modifyPrivacyAgreementRef.value.setFormData()
}
</script>

<style lang="scss" scoped></style>
