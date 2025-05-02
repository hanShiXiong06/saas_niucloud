<template>
    <div class="setting-form">
        <el-form :model="formData" label-width="120px">
            <el-form-item label="商户号">
                <el-input v-model="formData.merchantNo" :readonly="true"></el-input>
            </el-form-item>
            <el-form-item label="活动标识" prop="appPayType">
                <el-radio-group v-model="formData.appPayType">
                    <el-radio label="WXPAY" size="large">微信</el-radio>
                    <el-radio label="ALIPAY" size="large">支付宝</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="活动标识" prop="activityId">
                <el-radio-group v-model="formData.activityId" v-if="formData.appPayType == 'WXPAY'">
                    <el-radio label="SCHOOLCANTEEN_002" size="large">教育行业学校主体食堂活动</el-radio>
                    <el-radio label="CAMPUSDINING_001" size="large">教育行业非学校主体商户餐饮活动</el-radio>
                </el-radio-group>
                <el-radio-group v-model="formData.activityId" v-if="formData.appPayType == 'ALIPAY'">
                    <el-radio label="ALISCHOOL_1" size="large">支付宝未来校园活动</el-radio>
                    <el-radio label="MEDICAL_0" size="large">医疗卫生活动</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="支付宝行业code" prop="industryCode">
                <el-radio-group v-model="formData.industryCode">
                    <el-radio label="B0007" size="large">校园团餐</el-radio>
                    <el-radio label="B0134" size="large">高校和中职校园公立</el-radio>
                    <el-radio label="B0135" size="large">高校和中职校园私立</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="备注/补充信息">
                <el-input v-model="formData.remark"></el-input>
            </el-form-item>
        </el-form>
        <div class="operation-btn">
            <el-button type="primary" @click="submit">提交</el-button>
            <el-button type="primary" @click="second_submit">二次修改</el-button>
        </div>
    </div>
</template>
  
<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { getInfoApi, submitActivityApply, submitActivityApplyUpdateApi } from '@/addon/seafox_pay/api/part'

const formData = reactive<any>({
    sid :localStorage.getItem('seafoxpay_sid'),
    merchantNo: '',
    appPayType: '',
    activityId: '',
    industryCode: '',
    remark: '',
})

const getInfo = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    getInfoApi({type:'activityApply', appPayType: formData.appPayType ,sid:localStorage.getItem('seafoxpay_sid')}).then(res => {
        console.log(res)
        res = res.data
        formData.merchantNo = res.merchantNo
    })
}

const submit = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    submitActivityApply(formData).then(res => {
        console.log(res)
        ElMessage({
            message: '设置成功',
            type: 'success',
        })
    })
}

const second_submit = () => {
    submitActivityApplyUpdateApi(formData).then(res => {
        console.log(res)
        ElMessage({
            message: '设置成功',
            type: 'success',
        })
    })
}

getInfo()

</script>
  
<style lang="scss" scoped>
.setting-form {
    background-color: #FFFFFF;
    padding: 20px;
    box-sizing: border-box;

    .operation-btn {
        margin-bottom: 16px;
    }
}
</style>
  