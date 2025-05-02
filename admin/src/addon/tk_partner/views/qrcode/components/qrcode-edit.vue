<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updateQrcode') : t('addQrcode')" width="50%"
        class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form"
            v-loading="loading">

            <el-form-item :label="t('levelId')">
                <el-select class="input-width" v-model="formData.level_id" clearable
                    :placeholder="t('levelIdPlaceholder')">
                    <el-option label="请选择" value=""></el-option>
                    <el-option v-for="(item, index) in levelIdList" :key="index" :label="item['name']"
                        :value="item['id']" />
                </el-select>
            </el-form-item>

            <el-form-item :label="t('memberId')">
                <el-select class="input-width" v-model="formData.member_id" clearable
                    :placeholder="t('memberIdPlaceholder')">
                    <el-option label="请选择" value=""></el-option>
                    <el-option v-for="(item, index) in memberIdList" :key="index" :label="item['nickname']"
                        :value="item['member_id']" />
                </el-select>
            </el-form-item>

            <el-form-item :label="t('weappQrcode')">
                <upload-image v-model="formData.weapp_qrcode" />
            </el-form-item>

            <el-form-item :label="t('h5Qrcode')">
                <upload-image v-model="formData.h5_qrcode" />
            </el-form-item>

            <el-form-item :label="t('isBind')">
                <el-select v-model="formData.is_bind" clearable :placeholder="t('isBindPlaceholder')">
                    <el-option label="已绑定" :value="1" />
                    <el-option label="未绑定" :value="0" />
                </el-select>
            </el-form-item>

            <el-form-item :label="t('isExport')">
                <el-select v-model="formData.is_export" clearable :placeholder="t('isExportPlaceholder')">
                    <el-option label="已导出" :value="1" />
                    <el-option label="未导出" :value="0" />
                </el-select>
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
import { addQrcode, editQrcode, getQrcodeInfo, getWithLevelList, getWithMemberList } from '@/addon/tk_partner/api/qrcode'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    level_id: '',
    member_id: '',
    code: '',
    weapp_qrcode: '',
    h5_qrcode: '',
    expire_time: '',
    is_bind: '',
    is_export: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
        level_id: [
            { required: true, message: t('levelIdPlaceholder'), trigger: 'blur' },

        ]
        ,
        member_id: [
            { required: true, message: t('memberIdPlaceholder'), trigger: 'blur' },

        ]
        ,
        code: [
            { required: true, message: t('codePlaceholder'), trigger: 'blur' },

        ]
        ,
        weapp_qrcode: [
            { required: true, message: t('weappQrcodePlaceholder'), trigger: 'blur' },

        ]
        ,
        h5_qrcode: [
            { required: true, message: t('h5QrcodePlaceholder'), trigger: 'blur' },

        ]
        ,
        expire_time: [
            { required: true, message: t('expireTimePlaceholder'), trigger: 'blur' },

        ]
        ,
        is_bind: [
            { required: true, message: t('isBindPlaceholder'), trigger: 'blur' },

        ]
        ,
        is_export: [
            { required: true, message: t('isExportPlaceholder'), trigger: 'blur' },

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
    let save = formData.id ? editQrcode : addQrcode

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



const levelIdList = ref([] as any[])
const setLevelIdList = async () => {
    levelIdList.value = await (await getWithLevelList({})).data
}
setLevelIdList()
const memberIdList = ref([] as any[])
const setMemberIdList = async () => {
    memberIdList.value = await (await getWithMemberList({})).data
}
setMemberIdList()
const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true
    if (row) {
        const data = await (await getQrcodeInfo(row.id)).data
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
