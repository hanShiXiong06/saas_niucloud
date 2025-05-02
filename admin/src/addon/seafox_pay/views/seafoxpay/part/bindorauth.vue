<template>
    <div class="setting-form">
        <el-form :model="formData" label-width="120px">
            <el-form-item label="商户号">
                <el-input v-model="formData.merchantNo" :readonly="true"></el-input>
            </el-form-item>
            <el-form-item label="操作类型" prop="operateType">
                <el-radio-group v-model="formData.operateType">
                    <el-radio label="OPERATION_AUTH" size="large">代运营授权</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="场景" prop="confirmSceneType">
                <el-radio-group v-model="formData.confirmSceneType">
                    <el-radio label="OFFLINE" size="large">线下</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="商户支付宝登录账号">
                <el-input v-model="formData.alipayAccount" placeholder="商户支付宝登录账号"></el-input>
            </el-form-item>
            <el-form-item  label="第三方平台信息" >
                <el-form-item v-for="item in threeDataList.list">
                    <el-form-item class="tn-el-form-item--inline">
                        <el-input :value="item.channelShortId" :readonly="true">
                            <template #prepend>
                                渠道别名
                            </template>
                        </el-input>
                        <el-input :value="item.statusCn" :readonly="true">
                            <template #prepend>
                                授权状态
                            </template>
                        </el-input>
                        <el-input :value="item.subMerchantNo" :readonly="true">
                            <template #prepend>
                                第三方交易识别码
                            </template>
                        </el-input>
                    </el-form-item>
                    <el-image v-if="item.qrCodeUrl" style="width: 300px; height: 300px;" :src="item.qrCodeUrl" />
                </el-form-item>
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
import { getInfoApi, submitBindorauthApi } from '@/addon/seafox_pay/api/part'

const formData = reactive<any>({
    sid : localStorage.getItem('seafoxpay_sid'),
    merchantNo: '',
    operateType: 'OPERATION_AUTH',
    confirmSceneType: 'OFFLINE',
    alipayAccount: '',
})

const threeDataList = reactive<any>({
    list: []
})

const getInfo = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    getInfoApi({type:'bindorauth' ,sid : localStorage.getItem('seafoxpay_sid') }).then(res => {
        console.log(res)
        res = res.data

        formData.merchantNo = res.merchantNo

        threeDataList.list = res.paramDetails ? res.paramDetails : []

        threeDataList.list.map((item: any, index:any) => {
            item.statusCn = res.authorizeStatusCn[item.authorizeStatus]
        })

        
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
    submitBindorauthApi(formData).then(res => {
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
  