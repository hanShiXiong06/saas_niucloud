<template>
    <el-dialog v-model="showDialog" title="活动详情" width="50%" class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form"
            v-loading="loading">
            <el-form-item :label="t('actId')">
                <el-input v-model="formData.act_id" clearable :placeholder="t('actIdPlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item :label="t('actName')">
                <el-input v-model="formData.act_name" clearable :placeholder="t('actNamePlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('type')">
                <el-input v-model="formData.type" clearable :placeholder="t('typePlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item :label="t('desc')">
                <el-input v-model="formData.desc" clearable :placeholder="t('descPlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item :label="t('img')">
                <upload-image v-model="formData.img" />
            </el-form-item>

            <el-form-item :label="t('icon')">
                <upload-image v-model="formData.icon" />
            </el-form-item>

            <el-form-item :label="t('poster')">
                <upload-image v-model="formData.poster" />
            </el-form-item>

            <el-form-item :label="t('commissionRate')">
                <el-input v-model="formData.commission_rate" clearable :placeholder="t('commissionRatePlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('introduce')">
                <editor v-model="formData.introduce" />
            </el-form-item>
            <el-form-item :label="t('attributionExplain')">
                <editor v-model="formData.attribution_explain" />
            </el-form-item>
            <el-form-item :label="t('settlementTime')">
                <el-input v-model="formData.settlement_time" clearable :placeholder="t('settlementTimePlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item label="开始时间" class="input-width">
                <el-input class="flex-1 !flex" v-model="formData.start_date">
                </el-input>
            </el-form-item>
            <el-form-item label="结束时间" class="input-width">
                <el-input class="flex-1 !flex" v-model="formData.end_date">
                </el-input>
            </el-form-item>
            <el-form-item :label="t('createTime')">
                <el-input v-model="formData.create_time" clearable :placeholder="t('createTimePlaceholder')"
                    class="input-width" />
            </el-form-item>

        </el-form>
    </el-dialog>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, watch } from 'vue'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'

import { addAct, editAct, getActInfo, } from '@/addon/tk_cps/api/act'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    act_id: '',
    act_name: '',
    type: '',
    desc: '',
    img: '',
    icon: '',
    poster: '',
    commission_rate: '',
    introduce: '',
    attribution_explain: '',
    settlement_time: '',
    start_date: '',
    end_date: '',
    create_time: '',
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
        desc: [
            { required: true, message: t('descPlaceholder'), trigger: 'blur' },

        ]
        ,
        img: [
            { required: true, message: t('imgPlaceholder'), trigger: 'blur' },

        ]
        ,
        icon: [
            { required: true, message: t('iconPlaceholder'), trigger: 'blur' },

        ]
        ,
        poster: [
            { required: true, message: t('posterPlaceholder'), trigger: 'blur' },

        ]
        ,
        commission_rate: [
            { required: true, message: t('commissionRatePlaceholder'), trigger: 'blur' },

        ]
        ,
        introduce: [
            { required: true, message: t('introducePlaceholder'), trigger: 'blur' },

        ]
        ,
        attribution_explain: [
            { required: true, message: t('attributionExplainPlaceholder'), trigger: 'blur' },

        ]
        ,
        settlement_time: [
            { required: true, message: t('settlementTimePlaceholder'), trigger: 'blur' },

        ]
        ,
        start_date: [
            { required: true, message: t('startDatePlaceholder'), trigger: 'blur' },

        ]
        ,
        end_date: [
            { required: true, message: t('endDatePlaceholder'), trigger: 'blur' },

        ]
        ,
        create_time: [
            { required: true, message: t('createTimePlaceholder'), trigger: 'blur' },

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
    let save = formData.id ? editAct : addAct

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
        const data = await (await getActInfo(row.id)).data
        if (data) Object.keys(formData).forEach((key: string) => {
            if (data[key] != undefined) formData[key] = data[key]
        })
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
