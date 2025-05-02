<template>
    <el-card shadow="always" style="margin-top: 20px;">
        <h3 style="padding:0 0 20px 0;">微信支付配置</h3>
        <el-form-item label="微信支付商户号(Mch_Id)">
            <el-input v-model="formData.mch_id"></el-input>
        </el-form-item>
        <el-form-item label="" class="continer-item">
			<el-button type="primary" @click="submitSetting">提交</el-button>
		</el-form-item>
    </el-card>
</template>

<script lang="ts" setup>
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { getConfigApi, setConfigApi } from '@/addon/seafox_pay/api/cash_register'

let formData = reactive<any>({
    sid :localStorage.getItem('seafoxpay_sid'),
    mch_id: ''
})


const submitSetting = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    setConfigApi(formData).then((res: any) => {
        ElMessage.success('设置成功')

        mySet()
    })
}

const mySet = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    getConfigApi({ sid :localStorage.getItem('seafoxpay_sid') }).then((res: any) => {
        console.log(res)

        if(res && res.data) {
            formData.mch_id = res.data.mch_id
        }
    })
}

mySet()

</script>

<style>
    .tip {
        margin-left: 10px;
        color: #67C23A;
    }
</style>