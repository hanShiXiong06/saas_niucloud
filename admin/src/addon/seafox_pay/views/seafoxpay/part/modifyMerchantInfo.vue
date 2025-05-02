<template>
    <div class="setting-form">
        <el-form :model="formData" label-width="120px">
            <el-form-item label="商户号">
                <el-input v-model="formData.merchantNo" :readonly="true"></el-input>
            </el-form-item>
            <el-form-item label="子商户签约名">
                <el-input v-model="formData.signName"></el-input>
            </el-form-item>
            <el-form-item label="展示名">
                <el-input v-model="formData.showName"></el-input>
            </el-form-item>
            <el-form-item label="子商户类型">
                <el-select v-model="formData.merchantType"  placeholder="请选择子商户类型">
                    <el-option v-for="(item, key) in baseInfoData.merchantTypeData" :label="item" :value="key"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="法人名字">
                <el-input v-model="formData.legalPerson"></el-input>
            </el-form-item>
            <el-form-item label="法人身份证号">
                <el-input v-model="formData.legalPersonID"></el-input>
            </el-form-item>
            <el-form-item label="组织机构代码">
                <el-input v-model="formData.orgNum"></el-input>
            </el-form-item>
            <el-form-item label="营业执照号">
                <el-input v-model="formData.businessLicense"></el-input>
            </el-form-item>
            <el-form-item label="地区">
                <elui-china-area-dht isall :leave="3" @change="onChange" v-model="formData.area"></elui-china-area-dht>
            </el-form-item>
            <el-form-item label="通讯地址">
                <el-input v-model="formData.address"></el-input>
            </el-form-item>
            <el-form-item label="联系人">
                <el-input v-model="formData.linkman"></el-input>
            </el-form-item>
            <el-form-item label="联系电话">
                <el-input v-model="formData.linkPhone"></el-input>
            </el-form-item>
            <el-form-item label="联系邮箱">
                <el-input v-model="formData.email"></el-input>
            </el-form-item>
            <el-form-item label="签约名">
                <el-input v-model="formData.signName"></el-input>
            </el-form-item>
            <el-form-item label="是否同步通道到修改" prop="synChannel">
                <el-radio-group v-model="formData.synChannel">
                    <el-radio :label="true" size="large">是</el-radio>
                    <el-radio :label="false" size="large">否</el-radio>
                </el-radio-group>
            </el-form-item>
            <el-form-item label="支付类型" prop="appPayType">
                <el-radio-group v-model="formData.appPayType">
                    <!-- <el-radio label="ALL" size="large">全部</el-radio> -->
                    <el-radio label="WXPAY" size="large">微信</el-radio>
                    <el-radio label="ALIPAY" size="large">支付宝</el-radio>
                </el-radio-group>
            </el-form-item>
            
        </el-form>
        <div class="operation-btn">
            <el-button type="primary" @click="submit">提交</el-button>
        </div>
    </div>
</template>
  
<script lang="ts" setup>
import { reactive, defineComponent  } from 'vue'
import { ElMessage } from 'element-plus'
import { EluiChinaAreaDht } from 'elui-china-area-dht'
import { getInfoApi, getBaseInfoApi, submitModifyMerchantInfAPi } from '@/addon/seafox_pay/api/part'

const chinaData = new EluiChinaAreaDht.ChinaArea().chinaAreaflat

const area_info = reactive<any>({
    ids_arr: [],
    value_arr: [],
})

const onChange = (e: (string | number)[]) => {
    const one = chinaData[e[0]]
    const two = chinaData[e[1]]
    const three = chinaData[e[2]]
    console.log(one, two, three)

    console.log(formData.area)

    formData.area = [one.value, two.value, three.value]

    area_info.ids_arr = [one.value, two.value, three.value]
    area_info.value_arr = [one.label, two.label, three.label]
}

const baseInfoData = reactive<any>({
    merchantTypeData: {},
})

const formData = reactive<any>({
    sid :localStorage.getItem('seafoxpay_sid'),
    merchantNo: '',
    signName: '',
    showName: '',
    merchantType: '',
    legalPerson: '',
    legalPersonID: '',
    orgNum: '',
    businessLicense: '',
    address: '',
    linkman: '',
    linkPhone: '',
    email: '',
    synChannel: true,
    appPayType: 'WXPAY',
    area: '',
})

const submit = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    formData.area = area_info.value_arr
    console.log(formData)
    submitModifyMerchantInfAPi(formData).then(res => {
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
    getInfoApi({type: 'modifyMerchantInfo' ,sid :localStorage.getItem('seafoxpay_sid')}).then(res => {
        res = res.data
        formData.merchantNo = res.merchantNo
        formData.signName = res.signName
        formData.showName = res.showName
        formData.merchantType = res.merchantType
        formData.legalPerson = res.legalPerson
        formData.legalPersonID = res.legalPersonID
        formData.orgNum = res.orgNum
        formData.businessLicense = res.businessLicense
        formData.address = res.address
        formData.linkman = res.linkman
        formData.linkPhone = res.linkPhone
        formData.email = res.email

        let provinceCode = ''
        let cityCode = ''
        let countyCode = ''
        //循环chinaData对象

        console.log(chinaData)


        Object.keys(chinaData).forEach((item:any, index:any) => {
            if (chinaData[item].label === res.province) {
                provinceCode = chinaData[item].value
            }

            if(chinaData[item].label == res.city) {
                cityCode = chinaData[item].value
            }

            if(chinaData[item].label == res.county) {
                countyCode = chinaData[item].value
            }
        })
        console.log(provinceCode, cityCode, countyCode)
        formData.area = [provinceCode, cityCode, countyCode]
    })
}

getInfo()

const getBaseInfo = () => {
    getBaseInfoApi().then((res:any) => {
        res = res.data
        baseInfoData.merchantTypeData = res.merchantTypeData
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
  