<template>
    <div class="setting-form">
        <el-form :model="formData" label-width="150px">
            <el-form-item label="门头照_活动报名" prop="SIGN_BOARD_ACTIVITY">
				<upload-image v-model="formData.SIGN_BOARD_ACTIVITY" :limit="1" />

                <el-radio-group v-model="formData.SIGN_BOARD_ACTIVITY_methods">
                    <el-radio :label="1" size="large">首次上传</el-radio>
                    <el-radio :label="2" size="large">更新</el-radio>
                </el-radio-group>

			</el-form-item>
            <el-form-item label="室内照_活动报名" prop="INTERIOR_PHOTO_ACTIVITY">
				<upload-image v-model="formData.INTERIOR_PHOTO_ACTIVITY" :limit="1" />

                <el-radio-group v-model="formData.INTERIOR_PHOTO_ACTIVITY_methods">
                    <el-radio :label="1" size="large">首次上传</el-radio>
                    <el-radio :label="2" size="large">更新</el-radio>
                </el-radio-group>
			</el-form-item>
            <el-form-item label="商户与企业团餐合作协议(支付宝)" prop="MERCHANT_ENTERPRISE_MEALS_COOPERATION">
				<upload-image v-model="formData.MERCHANT_ENTERPRISE_MEALS_COOPERATION" :limit="1" />

                <el-radio-group v-model="formData.MERCHANT_ENTERPRISE_MEALS_COOPERATION_methods">
                    <el-radio :label="1" size="large">首次上传</el-radio>
                    <el-radio :label="2" size="large">更新</el-radio>
                </el-radio-group>
			</el-form-item>
            <el-form-item label="民办非企业单位登记证书图片" prop="PRIVATE_NONENTERPRISE_UNITS">
				<upload-image v-model="formData.PRIVATE_NONENTERPRISE_UNITS" :limit="1" />

                <el-radio-group v-model="formData.PRIVATE_NONENTERPRISE_UNITS_methods">
                    <el-radio :label="1" size="large">首次上传</el-radio>
                    <el-radio :label="2" size="large">更新</el-radio>
                </el-radio-group>
			</el-form-item>
            <el-form-item label="证明文件图片" prop="CERTIFICATE_FILE">
				<upload-image v-model="formData.CERTIFICATE_FILE" :limit="1" />

                <el-radio-group v-model="formData.CERTIFICATE_FILE_methods">
                    <el-radio :label="1" size="large">首次上传</el-radio>
                    <el-radio :label="2" size="large">更新</el-radio>
                </el-radio-group>
			</el-form-item>
            <el-form-item label="优惠费率承诺函照" prop="ACTIVITY_RATE_COMMITMENT">
				<upload-image v-model="formData.ACTIVITY_RATE_COMMITMENT" :limit="1" />

                <el-radio-group v-model="formData.ACTIVITY_RATE_COMMITMENT_methods">
                    <el-radio :label="1" size="large">首次上传</el-radio>
                    <el-radio :label="2" size="large">更新</el-radio>
                </el-radio-group>
			</el-form-item>
            <el-form-item label="办学资质图片" prop="RUN_SCHOOL_LICENSE_PIC">
				<upload-image v-model="formData.RUN_SCHOOL_LICENSE_PIC" :limit="1" />

                <el-radio-group v-model="formData.RUN_SCHOOL_LICENSE_PIC_methods">
                    <el-radio :label="1" size="large">首次上传</el-radio>
                    <el-radio :label="2" size="large">更新</el-radio>
                </el-radio-group>
			</el-form-item>
            <el-form-item label="法人登记证书" prop="INSTITUTIONAL_ORGANIZATION_PIC">
				<upload-image v-model="formData.INSTITUTIONAL_ORGANIZATION_PIC" :limit="1" />

                <el-radio-group v-model="formData.INSTITUTIONAL_ORGANIZATION_PIC_methods">
                    <el-radio :label="1" size="large">首次上传</el-radio>
                    <el-radio :label="2" size="large">更新</el-radio>
                </el-radio-group>
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
import { getInfoApi, getBaseInfoApi, submitActivityApplyUrl } from '@/addon/seafox_pay/api/part'

const formData = reactive<any>({
    SIGN_BOARD_ACTIVITY: '',
    INTERIOR_PHOTO_ACTIVITY: '',
    MERCHANT_ENTERPRISE_MEALS_COOPERATION: '',
    PRIVATE_NONENTERPRISE_UNITS: '',
    CERTIFICATE_FILE: '',
    ACTIVITY_RATE_COMMITMENT: '',
    RUN_SCHOOL_LICENSE_PIC: '',
    INSTITUTIONAL_ORGANIZATION_PIC: '',

    SIGN_BOARD_ACTIVITY_methods: 1,
    INTERIOR_PHOTO_ACTIVITY_methods: 1,
    MERCHANT_ENTERPRISE_MEALS_COOPERATION_methods: 1,
    PRIVATE_NONENTERPRISE_UNITS_methods: 1,
    CERTIFICATE_FILE_methods: 1,
    ACTIVITY_RATE_COMMITMENT_methods: 1,
    RUN_SCHOOL_LICENSE_PIC_methods: 1,
    INSTITUTIONAL_ORGANIZATION_PIC_methods: 1,

})

const submit = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    console.log(formData)
    submitActivityApplyUrl(formData ,localStorage.getItem('seafoxpay_sid')).then(res => {
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
    getInfoApi({type: 'activityApplyUrl' ,sid:localStorage.getItem('seafoxpay_sid')}).then(res => {
        res = res.data
        formData.SIGN_BOARD_ACTIVITY = res.SIGN_BOARD_ACTIVITY ? res.SIGN_BOARD_ACTIVITY : ''
        formData.INTERIOR_PHOTO_ACTIVITY = res.INTERIOR_PHOTO_ACTIVITY ? res.INTERIOR_PHOTO_ACTIVITY : ''
        formData.MERCHANT_ENTERPRISE_MEALS_COOPERATION = res.MERCHANT_ENTERPRISE_MEALS_COOPERATION ? res.MERCHANT_ENTERPRISE_MEALS_COOPERATION : ''
        formData.PRIVATE_NONENTERPRISE_UNITS = res.PRIVATE_NONENTERPRISE_UNITS ? res.PRIVATE_NONENTERPRISE_UNITS : ''
        formData.CERTIFICATE_FILE = res.CERTIFICATE_FILE ? res.CERTIFICATE_FILE : ''    
        formData.ACTIVITY_RATE_COMMITMENT = res.ACTIVITY_RATE_COMMITMENT ? res.ACTIVITY_RATE_COMMITMENT : ''
        formData.RUN_SCHOOL_LICENSE_PIC = res.RUN_SCHOOL_LICENSE_PIC ? res.RUN_SCHOOL_LICENSE_PIC : ''
        formData.INSTITUTIONAL_ORGANIZATION_PIC = res.INSTITUTIONAL_ORGANIZATION_PIC ? res.INSTITUTIONAL_ORGANIZATION_PIC : ''
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
  