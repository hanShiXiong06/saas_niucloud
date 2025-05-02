<template>
    <div class="setting-form">
        <el-form :model="formData" label-width="120px">
            <el-form-item label="商户号">
                <el-input v-model="formData.merchantNo" :readonly="true"></el-input>
            </el-form-item>
            <el-form-item label="客户类型" prop="appPayType">
                <el-radio-group v-model="formData.appPayType">
                    <el-radio label="WXPAY" size="large">微信</el-radio>
                    <el-radio label="ALIPAY" size="large">支付宝</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item  label="第三方平台信息" >
                <el-form-item v-for="item in threeDataList.list">
                    <el-form-item class="tn-el-form-item--inline">
                        <el-input :value="item.channelShortId" :readonly="true">
                            <template #prepend>
                                渠道别名
                            </template>
                        </el-input>
                        <el-input :value="item.channelMerchantNo" :readonly="true">
                            <template #prepend>
                                第三方平台渠道号
                            </template>
                        </el-input>
                        <el-input :value="item.threePartnerNo" :readonly="true">
                            <template #prepend>
                                第三方交易识别码
                            </template>
                        </el-input>
                        <el-input :value="item.statusCn" :readonly="true">
                            <template #prepend>
                                授权状态
                            </template>
                        </el-input>
                    </el-form-item>
                    <el-image v-if="formData.appPayType == 'WXPAY' && item.authorizeStatus != 'AUTHORIZED'" style="width: 300px; height: 300px" src="http://qny.wdsp666.com/images/1/2022/10/eEfUhi23Ic237E7eC7IcQ17hVQ1hqz.jpg" />
                    <el-image v-if="formData.appPayType == 'ALIPAY' && item.authorizeStatus != 'AUTHORIZED'" style="width: 300px; height: 300px" src="http://qny.wdsp666.com/images/1/2022/10/NOGX1KoIfJ8354w4bjX48k1nwvzGix.jpg" />
                </el-form-item>
            </el-form-item>
        </el-form>
        <div class="operation-btn">
            <!-- <el-button type="primary" @click="">提交</el-button> -->
        </div>
    </div>
</template>
  
<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { getInfoApi } from '@/addon/seafox_pay/api/part'

const formData = reactive<any>({
    sid : localStorage.getItem('seafoxpay_sid'),
    merchantNo: '',
    appPayType: 'WXPAY'
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
    getInfoApi({type:'appapplyquery', appPayType: formData.appPayType ,sid : localStorage.getItem('seafoxpay_sid')}).then(res => {
        console.log(res)
        res = res.data

        threeDataList.list = res.result.threePartnerNoData

        threeDataList.list.map((item: any, index:number) => {
            item.statusCn = res.authorizeStatusCn[item.authorizeStatus]
            item.qrcode = res.result.unionPayRecords ? res.result.unionPayRecords[index]['qrCode'] : ''
        })

        formData.merchantNo = res.merchantNo
        
        console.log(threeDataList)
    })
}

// getInfo()

watch(() => formData.appPayType, () => {
    getInfo()
	}, { immediate: true })

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
  