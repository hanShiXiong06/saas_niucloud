<template>
    <div class="main-container">
        <div class="flex ml-[18px] justify-between items-center mt-[20px]">
            <span class="text-[20px]">{{ pageName }}</span>
        </div>
        <el-form :model="formData" label-width="140px" ref="formRef" :rules="formRules" class="page-form"
            v-loading="loading">
            <el-card class="box-card !border-none" shadow="never">
                <el-card class="!border-none" shadow="never" style="width: 640px;">
                    <el-alert type="warning" title="1、应用于本插件接口/方法调用 2、后续适配相关驱动快速配置" :closable="false" show-icon />
                </el-card>
                <el-form-item label="access_key" prop="access_key">
                    <el-input v-model="formData.access_key" placeholder="access_key一号通后台应用管理获得APPID" class="input-width"
                        clearable />
                </el-form-item>

                <el-form-item label="secret_key" prop="secret_key">
                    <el-input v-model="formData.secret_key" placeholder="secret_key一号通后台应用管理获得AppSecret" class="input-width"
                        clearable />
                </el-form-item>
                <el-form-item label="管理后台">
                    <el-button>
                        <a href="https://api.crmeb.com/" target="_blank">打开一号通后台</a>
                    </el-button>
                </el-form-item>
            </el-card>
        </el-form>
        <div class="fixed-footer-wrap">
            <div class="fixed-footer">
                <el-button type="primary" :loading="loading" @click="confirm(formRef)">{{ t('confirm') }}</el-button>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, computed } from 'vue'
import { t } from '@/lang'
import { getCommonConfig, setCommonConfig } from '@/addon/tk_yht/api/config'
import { FormInstance, FormRules } from 'element-plus'
import { useRoute, useRouter } from 'vue-router'
const route = useRoute()
const router = useRouter()
const pageName = route.meta.title
const ruleFormRef = ref<FormInstance>()
const loading = ref(true)
const formRef = ref<FormInstance>()
/**
 * 链接跳转
 */
const toLink = (link: any) => {
    router.push(link)
}
// 表单验证规则
const formRules = computed(() => {
    return {
        access_key: [
            { required: true, message: 'access_key必须填写', trigger: 'blur' }
        ],
        secret_key: [
            { required: true, message: 'secret_key必须填写', trigger: 'blur' }
        ]
    }
})
/**
 * 表单数据
 */
const initialFormData = {
    access_key: '',
    secret_key: ''
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const getData = async () => {
    loading.value = true
    const data = await getCommonConfig()
    for (const key in formData) {
        formData[key] = data.data[key]
    }
    loading.value = false
}
getData()
/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return

    await formEl.validate(async (valid) => {
        if (valid) {
            loading.value = true
            const data = formData
            setCommonConfig(data).then(res => {
                loading.value = false
            }).catch(() => {
                loading.value = false
                // showDialog.value = false
            })
        }
    })
}
</script>

<style lang="scss" scoped></style>
