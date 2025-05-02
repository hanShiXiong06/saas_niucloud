<template>
    <div class="setting-form">
        <el-form :model="formData" label-width="120px">
            <el-form-item label="商户号">
                <el-input v-model="formData.merchantNo" :readonly="true"></el-input>
            </el-form-item>
            <el-form-item label="产品类型" prop="productType">
                <el-radio-group v-model="formData.productType">
                    <el-radio label="APPPAY" size="large">扫码</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="收取方式" prop="value">
                <el-radio-group v-model="formData.value">
                    <el-radio label="FEEACCOUNT" size="large">从平台商手续费账户收取</el-radio>
                    <el-radio label="OWN_CASHACCOUNT" size="large">子商户资金账户</el-radio>
                </el-radio-group>
            </el-form-item>
        </el-form>
        <div class="operation-btn">
            <el-button type="primary" @click="submit">提交</el-button>
        </div>
    </div>
</template>
  
<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { getInfoApi, submitModifyProductConfigApi } from '@/addon/seafox_pay/api/part'

const formData = reactive<any>({
    sid :localStorage.getItem('seafoxpay_sid'),
    merchantNo: '',
    productType: 'APPPAY',
    value: 'FEEACCOUNT',
})

const getInfo = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    getInfoApi({type:'modifyProductConfig' ,sid :localStorage.getItem('seafoxpay_sid')}).then(res => {
        console.log(res)
        res = res.data
        formData.merchantNo = res.merchantNo
        formData.value = res.value
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
    submitModifyProductConfigApi(formData).then(res => {
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
  