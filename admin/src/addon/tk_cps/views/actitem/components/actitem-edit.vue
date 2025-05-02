<template>
    <el-dialog v-model="showDialog" title="推广详情" width="65%" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form"
            v-loading="loading">

            <el-form-item :label="t('actName')">
                <div>{{ formData.act_name }}</div>
            </el-form-item>

            <el-form-item v-if="formData && formData.type" :label="t('type')">
                <el-tag v-if="formData.type == 0">
                    聚推客
                </el-tag>
                <el-tag v-if="formData.type == 1">
                    蚂蚁星球
                </el-tag>
            </el-form-item>

            <el-form-item v-if="formData.h5 != ''" :label="t('h5')">
                <div class="multi-hidden">{{ formData.h5 }}</div>
                <el-icon class="ml-2" @click="copyEvent(formData.h5)">
                    <DocumentCopy />
                </el-icon>
            </el-form-item>
            <el-form-item label="页面链接">
                <div>{{ pagepath }}</div>
                <el-icon class="ml-2" @click="copyEvent(pagepath)">
                    <DocumentCopy />
                </el-icon>
            </el-form-item>
            <el-form-item label="小程序信息" v-if="formData && formData.weapp && JSON.parse(formData.weapp).appid != ''">
                <div class="flex mt-2">
                    <div v-if="formData && formData.weapp && JSON.parse(formData.weapp).appid != ''"
                        class="mr-2 p-4 rounded-md statistic-card bg-gradient-to-r from-indigo-50 from-10% via-sky-50 via-10% to-emerald-50 to-10%">
                        <div class="font-bold">微信小程序信息</div>
                        <div class="mt-2" v-if="JSON.parse(formData.weapp).original_id">
                            <div class="font-bold">原始id:</div>
                            <div>{{ JSON.parse(formData.weapp).original_id }}
                                <el-icon class="ml-2" @click="copyEvent(JSON.parse(formData.weapp).original_id)">
                                    <DocumentCopy />
                                </el-icon>
                            </div>
                        </div>
                        <div class="mt-2">
                            <div class="font-bold">appid:</div>
                            <div>{{ JSON.parse(formData.weapp).appid }}
                                <el-icon class="ml-2" @click="copyEvent(JSON.parse(formData.weapp).appid)">
                                    <DocumentCopy />
                                </el-icon>
                            </div>
                        </div>
                        <div class="mt-2">
                            <div class="font-bold">页面路径:</div>
                            <div class="whitespace-normal w-[360px] break-words">{{ JSON.parse(formData.weapp).pagepath }}
                                <el-icon class="ml-2" @click="copyEvent(JSON.parse(formData.weapp).pagepath)">
                                    <DocumentCopy />
                                </el-icon>
                            </div>
                        </div>
                    </div>
                    <div v-if="formData && formData.aliapp && JSON.parse(formData.aliapp).appid != ''"
                        class="p-4 rounded-md statistic-card bg-gradient-to-r from-indigo-50 from-10% via-sky-50 via-10% to-emerald-50 to-10%">
                        <div class="font-bold">支付宝小程序</div>
                        <div class="mt-2">
                            <div class="font-bold">appid:</div>
                            <div>{{ JSON.parse(formData.aliapp).appid }}
                                <el-icon class="ml-2" @click="copyEvent(JSON.parse(formData.aliapp).appid)">
                                    <DocumentCopy />
                                </el-icon>
                            </div>
                        </div>
                        <div class="mt-2">
                            <div class="font-bold">页面路径:</div>
                            <div class="whitespace-normal w-[360px] break-words">{{ JSON.parse(formData.aliapp).pagepath }}
                                <el-icon class="ml-2" @click="copyEvent(JSON.parse(formData.aliapp).pagepath)">
                                    <DocumentCopy />
                                </el-icon>
                            </div>
                        </div>
                    </div>
                </div>
            </el-form-item>
        </el-form>
    </el-dialog>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, watch } from 'vue'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import { useClipboard } from '@vueuse/core'
import { addActItem, editActItem, getActItemInfo, } from '@/addon/tk_cps/api/actitem'

let showDialog = ref(false)
const loading = ref(false)
const pagepath = ref()
/**
 * 复制
 */
const { copy, isSupported, copied } = useClipboard()
const copyEvent = (text: string) => {
    if (!isSupported.value) {
        ElMessage({
            message: '当前浏览器不支持一键复制，请手动复制',
            type: 'warning'
        })
        return
    }
    copy(text)
    ElMessage({
        message: '复制成功',
        type: 'success'
    })
}

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    act_id: '',
    act_name: '',
    type: '',
    h5: '',
    weapp: '',
    aliapp: '',
    share_info: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
        act_id: [
            { required: true, message: t('actIdPlaceholder'), trigger: 'blur' },

        ]
        ,
        act_name: [
            { required: true, message: t('actNamePlaceholder'), trigger: 'blur' },

        ]
        ,
        type: [
            { required: true, message: t('typePlaceholder'), trigger: 'blur' },

        ]
        ,
        h5: [
            { required: true, message: t('h5Placeholder'), trigger: 'blur' },

        ]
        ,
        weapp: [
            { required: true, message: t('weappPlaceholder'), trigger: 'blur' },

        ]
        ,
        aliapp: [
            { required: true, message: t('aliappPlaceholder'), trigger: 'blur' },

        ]
        ,
        share_info: [
            { required: true, message: t('shareInfoPlaceholder'), trigger: 'blur' },

        ]
        ,
    }
})

const emit = defineEmits(['complete'])

/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    let save = formData.id ? editActItem : addActItem

    await formEl.validate(async (valid) => {
        if (valid) {
            loading.value = true

            let data = formData

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



const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true
    if (row) {
        const data = await (await getActItemInfo(row.id)).data
        if (data) Object.keys(formData).forEach((key: string) => {
            if (data[key] != undefined) formData[key] = data[key]
        })
    }
    pagepath.value = '/addon/tk_cps/pages/index?type=' + formData.type + '&act_id=' + formData.act_id + '&style=embedded'
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
