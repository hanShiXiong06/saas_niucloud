<template>
    <div class="setting-form">
        <el-form :model="formData" label-width="150px">
            <el-form-item label="商户号">
                <el-input v-model="formData.merchantNo" :readonly="true"></el-input>
            </el-form-item>
            <el-form-item label="结算卡联行号" class="tn-el-form-item--inline">
                <el-input v-model="formData.bankCode" :readonly="true">
                    <template #prepend>
                        变更前
                    </template>
                </el-input>
                <el-input v-model="formData.updateBankCode">
                    <template #prepend>
                        变更后
                    </template>
                </el-input>
                <!-- <div class="tn-form-item__tips">联行号查询</div> -->
            </el-form-item>
            <el-form-item label="开户名" class="tn-el-form-item--inline">
                <el-input v-model="formData.accountName" :readonly="true">
                    <template #prepend>
                        变更前
                    </template>
                </el-input>
                <el-input v-model="formData.updateAccountName">
                    <template #prepend>
                        变更后
                    </template>
                </el-input>
            </el-form-item>
            <el-form-item label="开户账号" class="tn-el-form-item--inline">
                <el-input v-model="formData.accountNo" :readonly="true">
                    <template #prepend>
                        变更前
                    </template>
                </el-input>
                <el-input v-model="formData.updateAccountNo">
                    <template #prepend>
                        变更后
                    </template>
                </el-input>
            </el-form-item>
            <el-form-item label="结算账户指定书(变更结算开户名必传)" prop="authorizationForSettlement">
				<upload-image v-model="formData.authorizationForSettlement" :limit="1" />
			</el-form-item>
            <el-form-item label="持卡人身份证正面照" prop="frontOfIdCard">
				<upload-image v-model="formData.frontOfIdCard" :limit="1" />
			</el-form-item>
            <el-form-item label="持卡人身份证反面照" prop="backOfIdCard">
				<upload-image v-model="formData.backOfIdCard" :limit="1" />
			</el-form-item>
            <el-form-item label="持卡人身份证反面照" prop="handheldOfIdCard">
				<upload-image v-model="formData.handheldOfIdCard" :limit="1" />
			</el-form-item>
            <el-form-item label="持卡人手持银行卡照" prop="handheldOfBankCard">
				<upload-image v-model="formData.handheldOfBankCard" :limit="1" />
			</el-form-item>
            <el-form-item label="结算卡类型(变更前)" class="tn-el-form-item--inline">
                <el-select v-model="formData.settleBankType"  placeholder="请选择结算卡类型">
                    <el-option v-for="(item, key) in baseInfoData.settleBankTypeData" :label="item" :value="key"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="结算卡类型(变更后)" class="tn-el-form-item--inline">
                <el-select v-model="formData.updateSettleBankType"  placeholder="请选择结算卡类型">
                    <el-option v-for="(item, key) in baseInfoData.settleBankTypeData" :label="item" :value="key"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="结算类型">
                <el-select v-model="formData.settlementPeriod"  placeholder="请选择结算类型">
                    <el-option v-for="(item, key) in baseInfoData.settlementPeriodData" :label="item" :value="key"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="结算方式">
                <el-select v-model="formData.settlementMode"  placeholder="请选择结算方式">
                    <el-option v-for="(item, key) in baseInfoData.settlementModeData" :label="item" :value="key"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="经营类别">
                <el-select v-model="formData.merchantCategory"  placeholder="请选择经营类别">
                    <el-option v-for="(item, key) in baseInfoData.merchantCategoryData" :label="item" :value="key"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="结算模式">
                <el-select v-model="formData.settleMode"  placeholder="请选择结算模式">
                    <el-option v-for="(item, key) in baseInfoData.settleModeData" :label="item" :value="key"></el-option>
                </el-select>
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
import { getInfoApi, getBaseInfoApi, submitCardalterationApi } from '@/addon/seafox_pay/api/part'

const baseInfoData = reactive<any>({
    merchantCategoryData: {},
    settleBankTypeData: {},
    settlementModeData: {},
    settlementPeriodData: {},
    settleModeData: {},
})

const formData = reactive<any>({
    sid :localStorage.getItem('seafoxpay_sid'),
    merchantNo: '',
    bankCode: '',
    updateBankCode: '',
    accountName: '',
    updateAccountName: '',
    accountNo: '',
    updateAccountNo: '',
    settleBankType: '',
    updateSettleBankType: '',
    authorizationForSettlement: '',
    frontOfIdCard: '',
    backOfIdCard: '',
    handheldOfIdCard: '',
    handheldOfBankCard: '',
    settlementPeriod: '',
    settlementMode: '',
    merchantCategory: '',
    settleMode: '',
})

const submit = () => {
    console.log(formData)
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    submitCardalterationApi(formData).then(res => {
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
    getInfoApi({type: 'cardalteration',sid :localStorage.getItem('seafoxpay_sid')}).then(res => {
        console.log(res)
        res = res.data
        formData.merchantNo = res.merchantNo
        formData.bankCode = res.bankCode
        formData.accountName = res.accountName
        formData.accountNo = res.accountNo
        formData.settleBankType = res.settleBankType
        formData.settlementPeriod = res.settlementPeriod
        formData.settlementMode = res.settlementMode
        formData.merchantCategory = res.merchantCategory
        formData.settleMode = res.settleMode
    })
}

getInfo()

const getBaseInfo = () => {
    getBaseInfoApi().then((res:any) => {
        res = res.data
        baseInfoData.merchantCategoryData = res.merchantCategoryData
        baseInfoData.settleBankTypeData = res.settleBankTypeData
        baseInfoData.settlementModeData = res.settlementModeData
        baseInfoData.settlementPeriodData = res.settlementPeriodData
        baseInfoData.settleModeData = res.settleModeData
    })
}
getBaseInfo()

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
  