<template>
    <div class="main-container">
        <div class="detail-head">
            <div class="left" @click="back()">
                <span class="iconfont iconxiangzuojiantou !text-xs"></span>
                <span class="ml-[1px]">{{t('returnToPreviousPage')}}</span>
            </div>
            <span class="adorn">|</span>
            <span class="right">{{ pageName }}</span>
        </div>
        <el-card class="box-card !border-none" shadow="never">
            <el-form :model="formData" label-width="90px" ref="formRef" :rules="formRules" class="page-form">
                <el-form-item :label="t('tid')" >
    <el-input v-model="formData.tid" clearable :placeholder="t('tidPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('details')" >
    <el-input v-model="formData.details" clearable :placeholder="t('detailsPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('addtime')" >
    <el-input v-model="formData.addtime" clearable :placeholder="t('addtimePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('reply')" >
    <el-input v-model="formData.reply" clearable :placeholder="t('replyPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('hfTime')" >
    <el-input v-model="formData.hf_time" clearable :placeholder="t('hfTimePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('memberId')" >
    <el-input v-model="formData.member_id" clearable :placeholder="t('memberIdPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('memberName')" >
    <el-input v-model="formData.member_name" clearable :placeholder="t('memberNamePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('bid')" >
    <el-input v-model="formData.bid" clearable :placeholder="t('bidPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('hfId')" >
    <el-input v-model="formData.hf_id" clearable :placeholder="t('hfIdPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('status')" >
    <el-input v-model="formData.status" clearable :placeholder="t('statusPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('touid')" >
    <el-input v-model="formData.touid" clearable :placeholder="t('touidPlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('adddate')" >
    <el-input v-model="formData.adddate" clearable :placeholder="t('adddatePlaceholder')" class="input-width" />
</el-form-item>

                <el-form-item :label="t('siteId')" >
    <el-input v-model="formData.site_id" clearable :placeholder="t('siteIdPlaceholder')" class="input-width" />
</el-form-item>

            </el-form>
        </el-card>
         <div class="fixed-footer-wrap">
            <div class="fixed-footer">
                <el-button type="primary" @click="onSave(formRef)">{{ t('save') }}</el-button>
                <el-button @click="back()">{{ t('cancel') }}</el-button>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import type { FormInstance } from 'element-plus'
import { getCommentsInfo,addComments,editComments } from '@/addon/blog/api/comments';
import { useRoute } from 'vue-router'

const route = useRoute()
const id:number = parseInt(route.query.id);
const loading = ref(false)
const pageName = route.meta.title



/**
 * 表单数据
 */
const initialFormData = {
    id: 0,
    tid: 0,
    details: '',
    addtime: '',
    reply: '',
    hf_time: '',
    member_id: 0,
    member_name: '',
    bid: 0,
    hf_id: 0,
    status: 0,
    touid: 0,
    adddate: '',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const setFormData = async (id:number = 0) => {
    Object.assign(formData, initialFormData)
    const data = await (await getCommentsInfo(id)).data
    Object.keys(formData).forEach((key: string) => {
        if (data[key] != undefined) formData[key] = data[key]
    })
}
if(id) setFormData(id);

const formRef = ref<FormInstance>()
// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

    
// 表单验证规则
const formRules = computed(() => {
    return {
    tid: [
        { required: true, message: t('tidPlaceholder'), trigger: 'blur' },
        
    ]
,
    details: [
        { required: true, message: t('detailsPlaceholder'), trigger: 'blur' },
        
    ]
,
    addtime: [
        { required: true, message: t('addtimePlaceholder'), trigger: 'blur' },
        
    ]
,
    reply: [
        { required: true, message: t('replyPlaceholder'), trigger: 'blur' },
        
    ]
,
    hf_time: [
        { required: true, message: t('hfTimePlaceholder'), trigger: 'blur' },
        
    ]
,
    member_id: [
        { required: true, message: t('memberIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    member_name: [
        { required: true, message: t('memberNamePlaceholder'), trigger: 'blur' },
        
    ]
,
    bid: [
        { required: true, message: t('bidPlaceholder'), trigger: 'blur' },
        
    ]
,
    hf_id: [
        { required: true, message: t('hfIdPlaceholder'), trigger: 'blur' },
        
    ]
,
    status: [
        { required: true, message: t('statusPlaceholder'), trigger: 'blur' },
        
    ]
,
    touid: [
        { required: true, message: t('touidPlaceholder'), trigger: 'blur' },
        
    ]
,
    adddate: [
        { required: true, message: t('adddatePlaceholder'), trigger: 'blur' },
        
    ]
,
    }
})

const onSave = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    await formEl.validate(async (valid) => {
       if (valid) {
           loading.value = true
           let data = formData

           const save = id ? editComments : addComments
           save(data).then(res => {
               loading.value = false
               history.back()
           }).catch(err => {
               loading.value = false
           })

       }
    })
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
const back = () => {
    history.back()
}
</script>

<style lang="scss" scoped></style>
