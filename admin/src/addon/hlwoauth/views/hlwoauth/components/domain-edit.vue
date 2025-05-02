<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updateDomain') : t('addDomain')" width="600px"
        class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form"
            v-loading="loading">
            <el-form-item :label="t('name')" prop="name">
                <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item :label="t('scope')" prop="scope">
                <el-radio-group v-model="formData.scope" :placeholder="t('scopePlaceholder')">
                    <el-radio v-for="(item, index) in scopeList" :key="index" :label="item.value">
                        {{ item.name }}
                    </el-radio>
                </el-radio-group>
                <div class="help-text text-gray-400 text-sm mt-[5px]">
                    <p>静默授权：不弹出授权页面，直接跳转，只能获取用户openid。</p>
                    <p>弹出授权：弹出授权页面，可通过openid拿到昵称、性别、所在地。并且， 即使在未关注的情况下，只要用户授权，也能获取其信息。</p>
                </div>
            </el-form-item>

            <el-form-item :label="t('domain')" prop="domain">
                <el-input v-model="formData.domain" type="textarea" clearable :placeholder="t('domainPlaceholder')" class="input-width" />
                <div class="help-text text-gray-400 text-sm mt-[5px]">填写授权成功后回调的地址，例如：https://www.example.com/oauth/callback</div>
            </el-form-item>

            <el-form-item :label="t('status')" prop="status">
                <el-radio-group v-model="formData.status" :placeholder="t('statusPlaceholder')">
                    <el-radio v-for="(item, index) in statusList" :key="index" :label="item.value">
                        {{ item.name }}
                    </el-radio>
                </el-radio-group>
            </el-form-item>

        </el-form>

        <template #footer>
            <span class="dialog-footer">
                <el-button @click="showDialog = false">{{ t('cancel') }}</el-button>
                <el-button type="primary" :loading="loading" @click="confirm(formRef)">{{
                    t('confirm')
                }}</el-button>
            </span>
        </template>
    </el-dialog>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, watch } from 'vue'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import { addDomain, editDomain, getDomainInfo } from '@/addon/hlwoauth/api/hlwoauth'

const showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    name: '',
    domain: '',
    scope: 'snsapi_base',
    auth_url: '',
    number: '0',
    status: '1'
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
        name: [
            { required: true, message: t('namePlaceholder'), trigger: 'blur' }

        ],
        domain: [
            { required: true, message: t('domainPlaceholder'), trigger: 'blur' }

        ]
    }
})

const emit = defineEmits(['complete'])

/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    const save = formData.id ? editDomain : addDomain

    await formEl.validate(async (valid) => {
        if (valid) {
            loading.value = true

            const data = formData

            save(data).then(res => {
                loading.value = false
                showDialog.value = false
                emit('complete')
            }).catch(err => {
                loading.value = false
            })
        }
    })
}

// 获取字典数据
const statusList = ref([
    {
        value: '1',
        name: '启用'
    },
    {
        value: '0',
        name: '禁用'
    }
])
watch(() => statusList.value, () => { formData.status = statusList.value[0].value })

const scopeList = ref([
    {
        value:'snsapi_base',
        name: '静默授权'
    },
    {
        value:'snsapi_userinfo',
        name: '弹出授权'
    }
])
watch(() => scopeList.value, () => { formData.scope = scopeList.value[0].value })

const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true
    if (row) {
        const data = await (await getDomainInfo(row.id)).data
        if (data) {
            Object.keys(formData).forEach((key: string) => {
                if (data[key] != undefined) formData[key] = data[key]
            })
        }
    }
    loading.value = false
}

// 验证手机号格式
const mobileVerify = (rule: any, value: any, callback: any) => {
    if (value && !/^1[3-9]\d{9}$/.test(value)) {
        callback(new Error(t('generateMobile')))
    } else {
        callback()
    }
}

// 验证身份证号
const idCardVerify = (rule: any, value: any, callback: any) => {
    if (value && !/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/.test(value)) {
        callback(new Error(t('generateIdCard')))
    } else {
        callback()
    }
}

// 验证邮箱号
const emailVerify = (rule: any, value: any, callback: any) => {
    if (value && !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test(value)) {
        callback(new Error(t('generateEmail')))
    } else {
        callback()
    }
}

// 验证请输入整数
const numberVerify = (rule: any, value: any, callback: any) => {
    if (!Number.isInteger(value)) {
        callback(new Error(t('generateNumber')))
    } else {
        callback()
    }
}

defineExpose({
    showDialog,
    setFormData
})
</script>

<style lang="scss" scoped></style>
<style lang="scss">
.diy-dialog-wrap .el-form-item__label {
    height: auto !important;
}
</style>
