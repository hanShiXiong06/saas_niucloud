<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updateSid') : t('addSid')" width="50%"
        class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form"
            v-loading="loading">

            <el-form-item :label="t('sid')">
                <el-input v-model="formData.sid" clearable :placeholder="t('sidPlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item :label="t('memberId')">
                <el-select class="input-width" v-model="formData.member_id" clearable
                    :placeholder="t('memberIdPlaceholder')">
                    <el-option label="请选择" value=""></el-option>
                    <el-option v-for="(item, index) in memberIdList" :key="index" :label="item['nickname']"
                        :value="item['member_id']" />
                </el-select>
            </el-form-item>

            <el-form-item :label="t('cpaProjectId')">
                <el-select class="input-width" v-model="formData.cpaProjectId" clearable
                    :placeholder="t('cpaProjectIdPlaceholder')">
                    <el-option label="请选择" value=""></el-option>
                    <el-option v-for="(item, index) in cpaProjectIdList" :key="index" :label="item['title']"
                        :value="item['act_id']" />
                </el-select>
            </el-form-item>

            <el-form-item :label="t('nickName')">
                <el-input v-model="formData.nickName" clearable :placeholder="t('nickNamePlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('phone')">
                <el-input v-model="formData.phone" clearable :placeholder="t('phonePlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item :label="t('status')">
                <el-input v-model="formData.status" clearable :placeholder="t('statusPlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('auditTime')">
                <el-input v-model="formData.auditTime" clearable :placeholder="t('auditTimePlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('failReason')">
                <el-input v-model="formData.failReason" clearable :placeholder="t('failReasonPlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('h5Url')">
                <el-input v-model="formData.h5Url" clearable :placeholder="t('h5UrlPlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item :label="t('appId')">
                <el-input v-model="formData.appId" clearable :placeholder="t('appIdPlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item :label="t('pagePath')">
                <el-input v-model="formData.pagePath" clearable :placeholder="t('pagePathPlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('miniCode')">
                <upload-image v-model="formData.miniCode" />
            </el-form-item>

            <el-form-item :label="t('promotionCopywriting')">
                <el-input v-model="formData.promotionCopywriting" clearable
                    :placeholder="t('promotionCopywritingPlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item :label="t('promotionCode')">
                <upload-image v-model="formData.promotionCode" />
            </el-form-item>

            <el-form-item :label="t('promotionPoster')">
                <upload-image v-model="formData.promotionPoster" />
            </el-form-item>

            <el-form-item :label="t('promotionUrl')">
                <el-input v-model="formData.promotionUrl" clearable :placeholder="t('promotionUrlPlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('queryDataUrl')">
                <el-input v-model="formData.queryDataUrl" clearable :placeholder="t('queryDataUrlPlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('systemLink')">
                <el-input v-model="formData.systemLink" clearable :placeholder="t('systemLinkPlaceholder')"
                    class="input-width" />
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
import { addSid, editSid, getSidInfo, getWithMemberList, getWithActList } from '@/addon/tk_cpa/api/sid'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    sid: '',
    member_id: '',
    cpaProjectId: '',
    nickName: '',
    phone: '',
    status: '',
    auditTime: '',
    failReason: '',
    h5Url: '',
    appId: '',
    pagePath: '',
    miniCode: '',
    promotionCopywriting: '',
    promotionCode: '',
    promotionPoster: '',
    promotionUrl: '',
    queryDataUrl: '',
    systemLink: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
        sid: [
            { required: true, message: t('sidPlaceholder'), trigger: 'blur' },

        ]
        ,
        member_id: [
            { required: true, message: t('memberIdPlaceholder'), trigger: 'blur' },

        ]
        ,
        cpaProjectId: [
            { required: true, message: t('cpaProjectIdPlaceholder'), trigger: 'blur' },

        ]
        ,
        nickName: [
            { required: true, message: t('nickNamePlaceholder'), trigger: 'blur' },

        ]
        ,
        phone: [
            { required: true, message: t('phonePlaceholder'), trigger: 'blur' },

        ]
        ,
        status: [
            { required: true, message: t('statusPlaceholder'), trigger: 'blur' },

        ]
        ,
        auditTime: [
            { required: true, message: t('auditTimePlaceholder'), trigger: 'blur' },

        ]
        ,
        failReason: [
            { required: true, message: t('failReasonPlaceholder'), trigger: 'blur' },

        ]
        ,
        h5Url: [
            { required: true, message: t('h5UrlPlaceholder'), trigger: 'blur' },

        ]
        ,
        appId: [
            { required: true, message: t('appIdPlaceholder'), trigger: 'blur' },

        ]
        ,
        pagePath: [
            { required: true, message: t('pagePathPlaceholder'), trigger: 'blur' },

        ]
        ,
        miniCode: [
            { required: true, message: t('miniCodePlaceholder'), trigger: 'blur' },

        ]
        ,
        promotionCopywriting: [
            { required: true, message: t('promotionCopywritingPlaceholder'), trigger: 'blur' },

        ]
        ,
        promotionCode: [
            { required: true, message: t('promotionCodePlaceholder'), trigger: 'blur' },

        ]
        ,
        promotionPoster: [
            { required: true, message: t('promotionPosterPlaceholder'), trigger: 'blur' },

        ]
        ,
        promotionUrl: [
            { required: true, message: t('promotionUrlPlaceholder'), trigger: 'blur' },

        ]
        ,
        queryDataUrl: [
            { required: true, message: t('queryDataUrlPlaceholder'), trigger: 'blur' },

        ]
        ,
        systemLink: [
            { required: true, message: t('systemLinkPlaceholder'), trigger: 'blur' },

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
    let save = formData.id ? editSid : addSid

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



const memberIdList = ref([] as any[])
const setMemberIdList = async () => {
    memberIdList.value = await (await getWithMemberList({})).data
}
setMemberIdList()
const cpaProjectIdList = ref([] as any[])
const setCpaProjectIdList = async () => {
    cpaProjectIdList.value = await (await getWithActList({})).data
}
setCpaProjectIdList()
const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true
    if (row) {
        const data = await (await getSidInfo(row.id)).data
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
