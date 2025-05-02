<template>
    <div class="setting-form">
        <el-form label-width="120px">
            <el-form-item label="客户类型" prop="activityId">
                <el-radio-group v-model="activityId">
                    <el-radio label="SCHOOLCANTEEN_002" size="large">教育行业学校主体食堂活动(微信) </el-radio>
                    <el-radio label="CAMPUSDINING_001" size="large">教育行业非学校主体商户餐饮活动(微信)</el-radio>
                    <el-radio label="ALISCHOOL_1" size="large">支付宝未来校园活动(支付宝)</el-radio>
                    <el-radio label="MEDICAL_0" size="large">医疗卫生活动(支付宝)</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item  label="第三方平台信息" >
                <el-form-item v-for="item in threeDataList.list">
                    <el-form-item class="tn-el-form-item--inline">
                        <el-input :value="item.subMerchantNo" :readonly="true">
                            <template #prepend>
                                二级商户号
                            </template>
                        </el-input>
                        <el-input :value="item.activityApplyStatus" :readonly="true">
                            <template #prepend>
                                状态
                            </template>
                        </el-input>
                        <el-input :value="item.activeTime" :readonly="true">
                            <template #prepend>
                                审核通过时间
                            </template>
                        </el-input>
                        <el-input :value="item.channelRetMsg" :readonly="true">
                            <template #prepend>
                                渠道返回信息
                            </template>
                        </el-input>
                        <el-input :value="item" :readonly="true">
                            <template #prepend>
                                时间是否有效
                            </template>
                        </el-input>
                    </el-form-item>
                </el-form-item>
            </el-form-item>
        </el-form>
    </div>
</template>
  
<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { getInfoApi } from '@/addon/seafox_pay/api/part'

const activityId = ref<any>('SCHOOLCANTEEN_001')

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
    getInfoApi({type:'activityApplyQuery', activityId: activityId.value ,sid:localStorage.getItem('seafoxpay_sid') }).then(res => {
        console.log(res)
        res = res.data
        threeDataList.list = res
    })
}

// getInfo()

watch(() => activityId.value, () => {
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
  