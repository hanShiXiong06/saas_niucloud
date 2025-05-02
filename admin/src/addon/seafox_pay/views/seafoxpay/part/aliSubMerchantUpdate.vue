<template>
    <div class="setting-form">
        <el-form :model="formData" label-width="120px">
            <el-form-item label="商户号">
                <el-input v-model="formData.merchantNo" readonly="true"></el-input>
            </el-form-item>
            <el-form-item label="商户号">
                <el-input v-model="formData.subMerchantNo"></el-input>
                <div class="tn-form-item__tips">支付宝商户编号</div>
            </el-form-item>
            <el-form-item label="目前所属mcc类别码">
                <el-input v-model="formData.current_mcc"></el-input>
                <div class="tn-form-item__tips">商户类别码mcc查询</div>
            </el-form-item>
            <el-form-item label="要修改的商户类别码mcc">
                <el-input v-model="formData.mcc"></el-input>
                <div class="tn-form-item__tips">商户类别码mcc查询</div>
            </el-form-item>
        </el-form>
        <div class="operation-btn">
            <el-button type="primary" @click="submit">提交</el-button>
        </div>
    </div>
</template>
  
<script lang="ts" setup>
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { getInfoApi, submitAliSubMerchantUpdateApi } from '@/addon/seafox_pay/api/part'

const formData = reactive<any>({
    sid :localStorage.getItem('seafoxpay_sid'),
    merchantNo: '',
    subMerchantNo: '',
    mcc: '',
    current_mcc: '',
})

const submit = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    submitAliSubMerchantUpdateApi(formData).then(res => {
        console.log(res)
        ElMessage({
            message: '设置成功',
            type: 'success',
        })
    })
}

const getInfo = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    getInfoApi({type: 'aliSubMerchantUpdate' ,sid:localStorage.getItem('seafoxpay_sid') }).then(res => {
        res = res.data
        formData.merchantNo = res.merchantNo
        formData.subMerchantNo = res.subMerchantNo
        formData.current_mcc = res.current_mcc
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
  