<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updateProduct') : t('addProduct')" width="50%"
        class="diy-dialog-wrap" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form"
            v-loading="loading">

            <el-form-item :label="t('productId')">
                <el-input v-model="formData.product_id" clearable disabled :placeholder="t('productIdPlaceholder')"
                    class="input-width" />
            </el-form-item>
            <el-form-item :label="t('operator')">
                <el-input v-model="formData.operator_name" disabled clearable :placeholder="t('operatorPlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('mode')">
                <el-input v-model="formData.mode_name" disabled clearable :placeholder="t('modePlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('activationCash')">
                <el-input v-model="formData.activation_cash" disabled clearable
                    :placeholder="t('activationCashPlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item :label="t('followupCash')">
                <el-input v-model="formData.followup_cash" disabled clearable
                    :placeholder="t('followupCashPlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item :label="t('apiStatus')">
                <el-tag v-if="formData.api_status == 1">正常</el-tag>
                <el-tag type="error" v-else>三方下架</el-tag>
            </el-form-item>
            <el-form-item :label="t('title')">
                <el-input v-model="formData.title" clearable :placeholder="t('titlePlaceholder')" class="input-width" />
            </el-form-item>

            <el-form-item label="描述">
                <el-input v-model="formData.desc" clearable placeholder="请输入描述" class="input-width" />
            </el-form-item>
            <el-form-item label="标签">
                <el-tag class="mr-1" v-for="tag in formData.tag" :key="tag" closable :disable-transitions="false"
                    @close="handleClose(tag)">
                    {{ tag }}
                </el-tag>

                <el-input v-if="inputVisible" ref="InputRef" v-model="inputValue" style="width: 80px;" size="small"
                    @keyup.enter="handleInputConfirm" @blur="handleInputConfirm" />
                <el-button v-else class="button-new-tag" size="small" @click="showInput">
                    + 新增标签
                </el-button>
            </el-form-item>
            <el-form-item :label="t('img')">
                <upload-image v-model="formData.img" />
            </el-form-item>
            <el-form-item :label="t('poster')">
                <upload-image v-model="formData.poster" />
            </el-form-item>

            <el-form-item :label="t('marketing')">
                <el-input v-model="formData.marketing" clearable :placeholder="t('marketingPlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('beizhu')">
                <el-input v-model="formData.beizhu" clearable :placeholder="t('beizhuPlaceholder')"
                    class="input-width" />
            </el-form-item>

            <el-form-item :label="t('tgContent')">
                <editor v-model="formData.tg_content" />
            </el-form-item>
            <el-form-item :label="t('sort')" type="number">
                <el-input v-model="formData.sort" clearable :placeholder="t('sortPlaceholder')" class="input-width" />
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
import { ref, reactive, computed, watch, nextTick } from 'vue'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import type { FormInstance, InputInstance, ElInput } from 'element-plus'
import { addProduct, editProduct, getProductInfo } from '@/addon/hk/api/product'
const handleClose = (tag: string) => {
    formData.tag.splice(formData.tag.indexOf(tag), 1)
}
const inputValue = ref('')
const inputVisible = ref(false)
const InputRef = ref<InputInstance>()
const showInput = () => {
    inputVisible.value = true
    nextTick(() => {
        InputRef.value!.input!.focus()
    })
}

const handleInputConfirm = () => {
    if (inputValue.value) {
        formData.tag.push(inputValue.value)
    }
    inputVisible.value = false
    inputValue.value = ''
}
let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    product_id: '',
    title: '',
    operator: '',
    operator_name: '',
    is_idcard: '',
    gztcheckidcard: '',
    minage: '',
    maxage: '',
    person_card_num: '',
    person_card_checkcycle: '',
    img: '',
    content: '',
    poster: '',
    marketing: '',
    beizhu: '',
    tg_content: '',
    mode: '',
    mode_name: '',
    photo: '',
    allow_area: '',
    prohibit_area: '',
    detailsimg: '',
    activation_cash: '',
    followup_cash: '',
    connected: '',
    generalized: '',
    directional: '',
    heyueqixian: '',
    introduce: '',
    status: '',
    api_status: '',
    sort: '',
    desc: '',
    tag: [],
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
        product_id: [
            { required: true, message: t('productIdPlaceholder'), trigger: 'blur' },

        ]
        ,
        title: [
            { required: true, message: t('titlePlaceholder'), trigger: 'blur' },

        ]
        ,
        operator: [
            { required: true, message: t('operatorPlaceholder'), trigger: 'blur' },

        ]
        ,
        is_idcard: [
            { required: true, message: t('isIdcardPlaceholder'), trigger: 'blur' },

        ]
        ,
        gztcheckidcard: [
            { required: true, message: t('gztcheckidcardPlaceholder'), trigger: 'blur' },

        ]
        ,
        minage: [
            { required: true, message: t('minagePlaceholder'), trigger: 'blur' },

        ]
        ,
        maxage: [
            { required: true, message: t('maxagePlaceholder'), trigger: 'blur' },

        ]
        ,
        person_card_num: [
            { required: true, message: t('personCardNumPlaceholder'), trigger: 'blur' },

        ]
        ,
        person_card_checkcycle: [
            { required: true, message: t('personCardCheckcyclePlaceholder'), trigger: 'blur' },

        ]
        ,
        img: [
            { required: true, message: t('imgPlaceholder'), trigger: 'blur' },

        ]
        ,
        content: [
            { required: true, message: t('contentPlaceholder'), trigger: 'blur' },

        ]
        ,
        poster: [
            { required: true, message: t('posterPlaceholder'), trigger: 'blur' },

        ]
        ,
        marketing: [
            { required: true, message: t('marketingPlaceholder'), trigger: 'blur' },

        ]
        ,
        beizhu: [
            { required: true, message: t('beizhuPlaceholder'), trigger: 'blur' },

        ]
        ,
        tg_content: [
            { required: true, message: t('tgContentPlaceholder'), trigger: 'blur' },

        ]
        ,
        mode: [
            { required: true, message: t('modePlaceholder'), trigger: 'blur' },

        ]
        ,
        photo: [
            { required: true, message: t('photoPlaceholder'), trigger: 'blur' },

        ]
        ,
        allow_area: [
            { required: true, message: t('allowAreaPlaceholder'), trigger: 'blur' },

        ]
        ,
        prohibit_area: [
            { required: true, message: t('prohibitAreaPlaceholder'), trigger: 'blur' },

        ]
        ,
        detailsimg: [
            { required: true, message: t('detailsimgPlaceholder'), trigger: 'blur' },

        ]
        ,
        activation_cash: [
            { required: true, message: t('activationCashPlaceholder'), trigger: 'blur' },

        ]
        ,
        followup_cash: [
            { required: true, message: t('followupCashPlaceholder'), trigger: 'blur' },

        ]
        ,
        connected: [
            { required: true, message: t('connectedPlaceholder'), trigger: 'blur' },

        ]
        ,
        generalized: [
            { required: true, message: t('generalizedPlaceholder'), trigger: 'blur' },

        ]
        ,
        directional: [
            { required: true, message: t('directionalPlaceholder'), trigger: 'blur' },

        ]
        ,
        heyueqixian: [
            { required: true, message: t('heyueqixianPlaceholder'), trigger: 'blur' },

        ]
        ,
        introduce: [
            { required: true, message: t('introducePlaceholder'), trigger: 'blur' },

        ]
        ,
        status: [
            { required: true, message: t('statusPlaceholder'), trigger: 'blur' },

        ]
        ,
        api_status: [
            { required: true, message: t('apiStatusPlaceholder'), trigger: 'blur' },

        ]
        ,
        sort: [
            { required: true, message: t('sortPlaceholder'), trigger: 'blur' },

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
    let save = formData.id ? editProduct : addProduct

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
        const data = await (await getProductInfo(row.id)).data
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
