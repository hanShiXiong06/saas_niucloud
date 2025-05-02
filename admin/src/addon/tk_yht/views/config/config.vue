<template>
    <div class="main-container">
        <div class="flex ml-[18px] justify-between items-center mt-[20px]">
            <span class="text-[20px]">{{ pageName }}</span>
        </div>
        <el-form :model="formData" label-width="140px" ref="formRef" :rules="formRules" class="page-form"
            v-loading="loading">
            <el-card class="box-card !border-none" shadow="never">
                <el-card class="!border-none" shadow="never" style="width: 640px;">
                    <el-alert type="warning" title="首次配置默认使用通用设置信息，也可自定义配置，用于框架短信驱动发送" :closable="false" show-icon />
                </el-card>
                <el-form-item label="短信启用">
                    <el-radio-group v-model="formData.is_use">
                        <el-radio :label="1">启用</el-radio>
                        <el-radio :label="0">停用</el-radio>
                    </el-radio-group>
                </el-form-item>

                <el-form-item label="access_key" prop="access_key">
                    <el-input v-model="formData.access_key" placeholder="access_key一号通后台应用管理获得APPID" class="input-width"
                        clearable />
                </el-form-item>

                <el-form-item label="secret_key" prop="secret_key">
                    <el-input v-model="formData.secret_key" placeholder="secret_key一号通后台应用管理获得AppSecret" class="input-width"
                        clearable />
                </el-form-item>
                <el-form-item label="常用导航">
                    <el-button>
                        <a href="https://api.crmeb.com/" target="_blank">打开一号通后台</a>
                    </el-button>
                    <el-button @click="toLink('/setting/notice/template')">
                        设置模板
                        <span class="ml-2 relative flex h-3 w-3 mb">
                            <span
                                class="animate-ping absolute inline-flex h-full w-full rounded-full bg-sky-400 opacity-75"></span>
                            <span class="relative inline-flex rounded-full h-3 w-3 bg-sky-400"></span>
                        </span>
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
import { getCommonConfig } from '@/addon/tk_yht/api/config'
import { getSmsInfo, editSms } from '@/addon/tk_yht/api/sms'
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
    sms_type: '',
    access_key: '',
    secret_key: '',
    is_use: ''
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const getData = async () => {
    loading.value = true
    const data = await (await getSmsInfo('yht')).data
    Object.keys(formData).forEach((key: string) => {
        if (data[key] != undefined) formData[key] = data[key]
        if (data.params[key] != undefined) formData[key] = data.params[key].value
    })
    if (formData.access_key == '' || formData.secret_key == '') {
        const commondata = await getCommonConfig()
        formData.access_key = commondata.data.access_key
        formData.secret_key = commondata.data.secret_key
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
            editSms(data).then(res => {
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
