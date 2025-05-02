<template>
    <el-tabs type="border-card" v-model="activeName" @tab-click='handleClick'>
        <!-- 商户进件 -->
        <el-tab-pane label="商户进件" name="post">
            <div style="font-size: 20px;">商户进件</div>
            <el-form :model="formData" label-width="120px">
                <el-form-item label="商户号" v-if="formData.merchantNo">
                    <el-input v-model="formData.merchantNo" :readonly="true"></el-input>
                </el-form-item>
                <el-form-item label="子商户签约名">
                    <el-input v-model="formData.signName"></el-input>
                </el-form-item>
                <el-form-item label="展示名">
                    <el-input v-model="formData.showName"></el-input>
                </el-form-item>
                <el-form-item label="子商户类型">
                    <el-select v-model="formData.merchantType" placeholder="请选择子商户类型">
                        <el-option v-for="(item, key) in baseInfoData.merchantTypeData" :label="item"
                            :value="key"></el-option>
                    </el-select>
                </el-form-item>


                <!-- 图片的上传前置 -->

                <!-- 企业或事业单位或个体户 -->
                <div v-if="formData.merchantType == 'ENTERPRISE' || formData.merchantType == 'INSTITUTION' || formData.merchantType == 'INDIVIDUALBISS'">
                    <el-form-item label="营业执照" prop="BUSINESS_LICENSE">
                        <upload-image v-model="imgData.BUSINESS_LICENSE" :limit="1" @change="handleChange('business_license')" />
                    </el-form-item>
                    <el-form-item label="开户许可证" prop="PERMIT_FOR_BANK_ACCOUNT">
                        <upload-image v-model="imgData.PERMIT_FOR_BANK_ACCOUNT" :limit="1" />
                    </el-form-item>
                    <el-form-item label="法人身份证正面" prop="FRONT_OF_ID_CARD">
                        <upload-image v-model="imgData.FRONT_OF_ID_CARD" :limit="1" @change="handleChange('id_card')" />
                    </el-form-item>
                    <el-form-item label="法人身份证反面" prop="BACK_OF_ID_CARD">
                        <upload-image v-model="imgData.BACK_OF_ID_CARD" :limit="1" />
                    </el-form-item>
                    <el-form-item label="商户门头照" prop="SIGN_BOARD">
                        <upload-image v-model="imgData.SIGN_BOARD" :limit="1" />
                    </el-form-item>
                    <el-form-item label="商户室内照" prop="INTERIOR_PHOTO">
                        <upload-image v-model="imgData.INTERIOR_PHOTO" :limit="1" />
                    </el-form-item>
                </div>

                <!-- 个体户 -->
                <div v-if="formData.merchantType == 'PERSON'">
                    <el-form-item label="法人身份证正面" prop="FRONT_OF_ID_CARD">
                        <upload-image v-model="imgData.FRONT_OF_ID_CARD" :limit="1" @change="handleChange('id_card')" />
                    </el-form-item>
                    <el-form-item label="法人身份证反面" prop="BACK_OF_ID_CARD">
                        <upload-image v-model="imgData.BACK_OF_ID_CARD" :limit="1" />
                    </el-form-item>
                    <el-form-item label="商户门头照" prop="SIGN_BOARD">
                        <upload-image v-model="imgData.SIGN_BOARD" :limit="1" />
                    </el-form-item>
                    <el-form-item label="商户室内照" prop="INTERIOR_PHOTO">
                        <upload-image v-model="imgData.INTERIOR_PHOTO" :limit="1" />
                    </el-form-item>
                </div>




                <el-form-item label="行业类型编码">
                    <!-- <el-input v-model="formData.industryTypeCode"></el-input> -->
                    <el-select v-model="formData.industryTypeCode" placeholder="请选择行业编码">
                        <el-option v-for="(item, key) in baseInfoData.industryTypeCodeData" :label="item"
                            :value="key"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item v-if="formData.industryTypeCode == '0'">
                    <template #label>
                        <a href="https://myshangpu.yuque.com/org-wiki-myshangpu-sfbw9n/ehkk9f/dbg5ul#6edd" target="_blank">行业编码（编码查询表）</a>
                    </template>
                    <el-input v-model="formData.other_code"></el-input>
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
                <el-form-item label="结算卡银联号">
                    <el-input v-model="formData.bankCode"></el-input>
                    <div class="tn-form-item__tips"><a href="https://www.cwjyz.com.cn/bank/index.html#" target="_blank">联行号查询</a></div>
                </el-form-item>
                <el-form-item label="开户名">
                    <el-input v-model="formData.accountName"></el-input>
                </el-form-item>
                <el-form-item label="开户账号">
                    <el-input v-model="formData.accountNo"></el-input>
                </el-form-item>
                <el-form-item label="结算卡类型(变更前)" class="tn-el-form-item--inline">
                    <el-select v-model="formData.settleBankType" placeholder="请选择结算卡类型">
                        <el-option v-for="(item, key) in baseInfoData.settleBankTypeData" :label="item"
                            :value="key"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="结算类型">
                    <el-select v-model="formData.settlementPeriod" placeholder="请选择结算类型">
                        <el-option v-for="(item, key) in baseInfoData.settlementPeriodData" :label="item"
                            :value="key"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="结算方式">
                    <el-select v-model="formData.settlementMode" placeholder="请选择结算方式">
                        <el-option v-for="(item, key) in baseInfoData.settlementModeData" :label="item"
                            :value="key"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="经营类别">
                    <el-select v-model="formData.merchantCategory" placeholder="请选择经营类别">
                        <el-option v-for="(item, key) in baseInfoData.merchantCategoryData" :label="item"
                            :value="key"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="结算模式">
                    <el-select v-model="formData.settleMode" placeholder="请选择结算模式">
                        <el-option v-for="(item, key) in baseInfoData.settleModeData" :label="item"
                            :value="key"></el-option>
                    </el-select>
                </el-form-item>

            </el-form>
            <div class="operation-btn">
                <el-button type="primary" @click="submitParts">提交</el-button>
            </div>
        </el-tab-pane>

        <!-- 资质上传 -->
        <el-tab-pane label="资质上传" name="imageUrlQuery">
            <el-form label-position="left" label-width="120px">
                <el-form-item label="法人身份证正面" prop="FRONT_OF_ID_CARD">
                    <upload-image v-model="imgData.FRONT_OF_ID_CARD" :limit="1" />
                </el-form-item>
                <el-form-item label="法人身份证反面" prop="BACK_OF_ID_CARD">
                    <upload-image v-model="imgData.BACK_OF_ID_CARD" :limit="1" />
                </el-form-item>
                <el-form-item label="营业执照" prop="BUSINESS_LICENSE">
                    <upload-image v-model="imgData.BUSINESS_LICENSE" :limit="1" />
                </el-form-item>
                <el-form-item label="开户许可证" prop="PERMIT_FOR_BANK_ACCOUNT">
                    <upload-image v-model="imgData.PERMIT_FOR_BANK_ACCOUNT" :limit="1" />
                </el-form-item>
                <el-form-item label="商户门头照" prop="SIGN_BOARD">
                    <upload-image v-model="imgData.SIGN_BOARD" :limit="1" />
                </el-form-item>
                <el-form-item label="商户室内照" prop="INTERIOR_PHOTO">
                    <upload-image v-model="imgData.INTERIOR_PHOTO" :limit="1" />
                </el-form-item>
                <el-form-item label="结算账户指定书" prop="AUTHORIZATION_FOR_SETTLEMENT">
                    <upload-image v-model="imgData.AUTHORIZATION_FOR_SETTLEMENT" :limit="1" />
                </el-form-item>
                <el-form-item label="手持身份证照" prop="HANDHELD_OF_ID_CARD">
                    <upload-image v-model="imgData.HANDHELD_OF_ID_CARD" :limit="1" />
                </el-form-item>
                <el-form-item label="手持银行卡照正面" prop="HANDHELD_OF_BANK_CARD">
                    <upload-image v-model="imgData.HANDHELD_OF_BANK_CARD" :limit="1" />
                </el-form-item>
                <el-form-item label="结算卡" prop="BANK_CARD">
                    <upload-image v-model="imgData.BANK_CARD" :limit="1" />
                </el-form-item>
                <el-form-item label="结算人身份证正面" prop="SETTLE_FRONT_OF_ID_CARD">
                    <upload-image v-model="imgData.SETTLE_FRONT_OF_ID_CARD" :limit="1" />
                </el-form-item>
                <el-form-item label="结算人身份证反面" prop="SETTLE_BACK_OF_ID_CARD">
                    <upload-image v-model="imgData.SETTLE_BACK_OF_ID_CARD" :limit="1" />
                </el-form-item>
            </el-form>
            <div class="operation-btn">
                <el-button type="primary" @click="submitImgUrlQuery">提交</el-button>
            </div>
        </el-tab-pane>

        <!-- 产品开通 -->
        <el-tab-pane label="产品开通" name="productQuery">
            <el-form label-position="left">
                <el-form-item label="支付类型" prop="payType">
                    <el-radio-group v-model="productData.payType">
                        <el-radio label="APPLET" size="large">小程序</el-radio>
                        <el-radio label="SWIPE" size="large">被扫产品</el-radio>
                        <el-radio label="ACCOUNT_PAY" size="large">虚拟支付</el-radio>
                        <el-radio label="PUBLIC" size="large">公众号</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="客户类型" prop="appPayType">
                    <el-radio-group v-model="productData.appPayType">
                        <el-radio label="WXPAY" size="large">微信</el-radio>
                        <el-radio label="ALIPAY" size="large">支付宝</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="费率类型" prop="feePurpose">
                    <el-radio-group v-model="productData.feePurpose">
                        <el-radio label="DEFAULT" size="large">默认</el-radio>
                        <el-radio label="SCHOOLCANTEEN_001" size="large">高校食堂行业活动(微)</el-radio>
                        <el-radio label="EDUCATION_001" size="large">高校食堂行业活动(微)</el-radio>
                        <el-radio label="ALISCHOOL_1" size="large">支付宝未来校园活动(支)</el-radio>
                        <el-radio label="MEDICAL_0" size="large">医疗卫生活动(支)</el-radio>
                        <el-radio label="PUBLIC_WELFARE" size="large">公益类费率</el-radio>
                        <el-radio label="ACADEMY" size="large">私立院校</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="费率">
                    <el-input v-model="productData.value">
                        <template #append>
                            %
                        </template>
                    </el-input>
                </el-form-item>
                <el-form-item label="费率模式" prop="appFeeMode">
                    <el-radio-group v-model="productData.appFeeMode">
                        <el-radio label="DEFAULT" size="large">不分段</el-radio>
                        <el-radio label="RANGE" size="large" v-if="productData.feePurpose != 'DEFAULT'">分段</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="区间值" class="tn-el-form-item--inline" v-if="productData.appFeeMode == 'RANGE'">
                    <el-input v-model="productData.feeRanges[0]['start']">
                        <template #append>
                            元至
                        </template>
                    </el-input>
                    <el-input v-model="productData.feeRanges[0]['end']">
                        <template #append>
                            元，费率
                        </template>
                    </el-input>
                    <el-input v-model="productData.feeRanges[0]['fee']">
                        <template #append>
                            %
                        </template>
                    </el-input>
                </el-form-item>
                <el-form-item label="区间值" class="tn-el-form-item--inline" v-if="productData.appFeeMode == 'RANGE'">
                    <el-input v-model="productData.feeRanges[0]['minFee']">
                        <template #prepend>
                            最低费率
                        </template>
                    </el-input>
                    <el-input v-model="productData.feeRanges[0]['maxFee']">
                        <template #prepend>
                            最高费率
                        </template>
                    </el-input>
                </el-form-item>
                <el-form-item label="计算类型" prop="feeRanges" v-if="productData.appFeeMode == 'RANGE'">
                    <el-radio-group v-model="productData.feeRanges[0]['calcType']">
                        <el-radio label="RATIO" size="large">比率收费</el-radio>
                        <el-radio label="SINGLE" size="large">单笔收费</el-radio>
                    </el-radio-group>
                </el-form-item>


                <el-form-item label="区间值" class="tn-el-form-item--inline" v-if="productData.appFeeMode == 'RANGE'">
                    <el-input v-model="productData.feeRanges[1]['start']">
                        <template #append>
                            元至
                        </template>
                    </el-input>
                    <el-input v-model="productData.feeRanges[1]['end']">
                        <template #append>
                            元，费率
                        </template>
                    </el-input>
                    <el-input v-model="productData.feeRanges[1]['fee']">
                        <template #append>
                            %
                        </template>
                    </el-input>
                </el-form-item>
                <el-form-item label="区间值" class="tn-el-form-item--inline" v-if="productData.appFeeMode == 'RANGE'">
                    <el-input v-model="productData.feeRanges[1]['minFee']">
                        <template #prepend>
                            最低费率
                        </template>
                    </el-input>
                    <el-input v-model="productData.feeRanges[1]['maxFee']">
                        <template #prepend>
                            最高费率
                        </template>
                    </el-input>
                </el-form-item>
                <el-form-item label="计算类型" prop="feeRanges" v-if="productData.appFeeMode == 'RANGE'">
                    <el-radio-group v-model="productData.feeRanges[1]['calcType']">
                        <el-radio label="RATIO" size="large">比率收费</el-radio>
                        <el-radio label="SINGLE" size="large">单笔收费</el-radio>
                    </el-radio-group>
                </el-form-item>

                <div class="operation-btn">
                    <el-button type="primary" @click="submitProductQuery">提交</el-button>
                </div>
            </el-form>


            <el-form label-position="left" style="margin-top: 50px;">
                <el-form-item label="微信费率">
                    <el-input v-model="productData2.weixin_feilv">
                        <template #append>
                            %
                        </template>
                    </el-input>
                    <div class="tn-form-item__tips">海狐聚合支付系统查询费率:{{ productData2.system_weixin_feilv }}%</div>
                </el-form-item>
                <el-form-item label="支付宝费率">
                    <el-input v-model="productData2.alipay_feilv">
                        <template #append>
                            %
                        </template>
                    </el-input>
                    <div class="tn-form-item__tips">海狐聚合支付系统查询费率:{{ productData2.system_alipay_feilv }}%</div>
                </el-form-item>
                <el-form-item label="特别说明">
                    <view style="display:flex;flex-direction: column;align-items: baseline;">
                        <span>PS：上面是提交给海狐聚合支付的费率，下面是系统计算的费率，
                                    如果两者保持一致，则由代理承担支付手续费（大多数情况下采用该模式，因为商家的支付手续费包含在了商户的佣金里）
                        </span>
                        <span>如果下面设置0，则由商家承担支付手续费</span>
                        <span style="color: red;">此处提交按钮与上面的设置费率提交按钮是独立的，需单独设置。</span>
                    </view>
                </el-form-item>
                <div class="operation-btn">
                    <el-button type="primary" @click="setFeilv">提交</el-button>
                </div>
            </el-form>

        </el-tab-pane>

        <!-- app报备 -->
        <el-tab-pane label="app报备" name="appapplyqueryAll">
            <el-form label-position="left">
                <el-form-item label="商户号">
                    <el-input v-model="formData.merchantNo" :readonly="true"></el-input>
                </el-form-item>
                <el-form-item label="第三方平台信息">
                    <el-form-item v-for="(item,index) in threeDataList.list">
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
                        <el-image v-if="item.authorizeStatus != 'AUTHORIZED' && item.appPayType == 'WXPAY'" style="width: 300px; height: 300px;" :src="app_product_wechat_qrcode" />
                        <el-image v-if="item.authorizeStatus != 'AUTHORIZED' && item.appPayType == 'ALIPAY'" style="width: 300px; height: 300px;" :src="app_product_alipay_qrcode" />
                    </el-form-item>
                </el-form-item>
            </el-form>
            <div class="operation-btn">
                <el-button type="primary" @click="nextstap">下一步</el-button>
            </div>
        </el-tab-pane>

        <!-- 微信进件 -->
        <el-tab-pane label="微信进件" name="wxPublicApplyQuery">
            <el-form label-position="left">
                <el-form-item label="类型" prop="wechat_type">
                    <el-radio-group v-model="wxPublicApplyQueryData.wechat_type">
                        <el-radio label="receipt" size="large">小程序</el-radio>
                        <!-- <el-radio label="subscribe" size="large">公众号</el-radio> -->
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="小程序AppId" v-if="wxPublicApplyQueryData.wechat_type == 'receipt'" style="display: none;">
                    <el-input v-model="wxPublicApplyQueryData.receiptAppIds"></el-input>
                </el-form-item>
                <el-form-item label="公众号AppId" v-if="wxPublicApplyQueryData.wechat_type == 'subscribe'">
                    <el-input v-model="wxPublicApplyQueryData.subscribeAppIds"></el-input>
                </el-form-item>
                <el-form-item label="appIds">
                    <el-input v-model="wxPublicApplyQueryData.appIds"></el-input>
                </el-form-item>
                <el-form-item label="支付授权目录列表">
                    <el-input v-model="wxPublicApplyQueryData.authPayDirs"></el-input>
                </el-form-item>
            </el-form>
            <div class="operation-btn">
                <el-button type="primary" @click="submitWxPublicApplyQuery">提交</el-button>
            </div>
        </el-tab-pane>
    </el-tabs>
</template>
  
<script lang="ts" setup>
import { reactive, defineComponent, ref, watch } from 'vue'
import { ElMessage, ElMessageBox, FormInstance } from 'element-plus'
import { EluiChinaAreaDht } from 'elui-china-area-dht'

import { 
    getInfoApi, 
    getBaseInfoApi, 
    getFeilvApi, 
    setFeilvApi, 
    partsApi, 
    imageUrlQueryApi, 
    productQueryApi, 
    appapplyqueryAllApi, 
    wxPublicApplyQueryApi,
    scanBusinessLicenseApi,
    scanIdCardApi,
    getProductQrcodeApi,
} from '@/addon/seafox_pay/api/part'

const activeName = ref<string>('post')

const handleClick = (target: any, action: any) => {
    console.log(target)
}

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

    // formData.area = [one.label, two.label, three.label]
    formData.area = [one.value, two.value, three.value]

    area_info.ids_arr = [one.value, two.value, three.value]
    area_info.value_arr = [one.label, two.label, three.label]

    console.log(formData.area)
}

const baseInfoData = reactive<any>({
    merchantTypeData: {},
    merchantCategoryData: {},
    settleBankTypeData: {},
    settlementModeData: {},
    settlementPeriodData: {},
    settleModeData: {},
    industryTypeCodeData: {}
})

//进件表单
const formData = reactive<any>({
    sid:localStorage.getItem('seafoxpay_sid'),
    merchantNo: '',
    signName: '',
    showName: '',
    merchantType: '',
    industryTypeCode: '',
    legalPerson: '',
    legalPersonID: '',
    orgNum: '',
    businessLicense: '',
    address: '',
    area: '',
    linkman: '',
    linkPhone: '',
    email: '',
    bankCode: '',
    accountName: '',
    accountNo: '',
    settleBankType: '',
    settlementPeriod: 'T1',
    settlementMode: 'AUTO',
    merchantCategory: '',
    settleMode: 'MERCHANT',
    other_code: '',
})

const imgData = reactive<any>({
    sid:localStorage.getItem('seafoxpay_sid'),
    FRONT_OF_ID_CARD: '',
    BACK_OF_ID_CARD: '',
    BUSINESS_LICENSE: '',
    PERMIT_FOR_BANK_ACCOUNT: '',
    SIGN_BOARD: '',
    INTERIOR_PHOTO: '',
    AUTHORIZATION_FOR_SETTLEMENT: '',
    HANDHELD_OF_ID_CARD: '',
    HANDHELD_OF_BANK_CARD: '',
    BANK_CARD: '',
    SETTLE_FRONT_OF_ID_CARD: '',
    SETTLE_BACK_OF_ID_CARD: '',
})

const productData = reactive<any>({
    sid:localStorage.getItem('seafoxpay_sid'),
    payType: 'APPLET',
    appPayType: 'WXPAY',
    feePurpose: 'DEFAULT',
    value: 0,
    appFeeMode: 'DEFAULT',
    feeRanges: [
        {
            start: 0,
            end: 5000,
            fee: 0,
            minFee: 0,
            maxFee: 0,
            calcType: 'RATIO',
        },
        {
            start: 5000.01,
            end: 10000,
            fee: 0,
            minFee: 0,
            maxFee: 0,
            calcType: 'RATIO',
        }
    ],
})

const productData2 = reactive<any>({
    sid:localStorage.getItem('seafoxpay_sid'),
    weixin_feilv: '',
    alipay_feilv: '',
    system_weixin_feilv: 'none',
    system_alipay_feilv: 'none',
})

const submitParts = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    formData.area = area_info.value_arr

    if(formData.industryTypeCode == '0' && !formData.other_code) {
        ElMessage({
            message: '请填写行业编码',
            type: 'error',
        })
        return
    }

    //copy formData
    const formDataCopy = formData

    if(formData.industryTypeCode == '0') {
        formDataCopy.industryTypeCode = formData.other_code
    }

    partsApi(formDataCopy, imgData).then(res => {
        console.log(res)

        ElMessage({
            message: '设置成功',
            type: 'success',
        })

        activeName.value = 'imageUrlQuery'
    })
}

const submitImgUrlQuery = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    imageUrlQueryApi({imgs: imgData ,sid :localStorage.getItem('seafoxpay_sid')}).then(res => {
        console.log(res)

        ElMessage({
            message: '设置成功',
            type: 'success',
        })

        activeName.value = 'productQuery'
    })
}

const submitProductQuery = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    productQueryApi(productData).then(res => {
        console.log(res)

        ElMessage({
            message: '设置成功',
            type: 'success',
        })

        activeName.value = 'appapplyqueryAll'
    })
}

const nextstap = () => {
    activeName.value = 'wxPublicApplyQuery'
}

const submitWxPublicApplyQuery = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    wxPublicApplyQueryApi(wxPublicApplyQueryData).then(res => {
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
    getInfoApi({ type: 'parts' ,sid :localStorage.getItem('seafoxpay_sid')  }).then(res => {
        res = res.data
        formData.merchantNo = res.merchantNo
        formData.signName = res.signName
        formData.showName = res.showName
        formData.merchantType = res.merchantType

        formData.industryTypeCode = res.industryTypeCode
        if(res.industryTypeCode != '888' && res.industryTypeCode != '212' && res.industryTypeCode != '135') {
            formData.other_code = res.industryTypeCode
            formData.industryTypeCode = '0'
        }


        formData.legalPerson = res.legalPerson
        formData.legalPersonID = res.legalPersonID
        formData.orgNum = res.orgNum
        formData.businessLicense = res.businessLicense
        formData.address = res.address
        formData.linkman = res.linkman
        formData.linkPhone = res.linkPhone
        formData.email = res.email
        formData.bankCode = res.bankCode
        formData.accountName = res.accountName
        formData.accountNo = res.accountNo
        formData.settleBankType = res.settleBankType
        formData.settlementPeriod = res.settlementPeriod || 'T1'
        formData.settlementMode = res.settlementMode || 'AUTO'
        formData.merchantCategory = res.merchantCategory
        formData.settleMode = res.settleMode || 'MERCHANT'

        const address_code = res.address_code
        console.log(res,address_code,'address_code');
        
        const province = address_code.province
        console.log(address_code.province,' address_code.province');
        
        const city = address_code.city
        const district = address_code.district

        //根据province文本 找到对应的code
        const provinceCode = Object.keys(chinaData).find((item: any) => {
            return chinaData[item].label === province
        })

        //根据city文本 找到对应的code
        const cityCode = Object.keys(chinaData).find((item: any) => {
            return chinaData[item].label === city
        })

        //根据district文本 找到对应的code
        const districtCode = Object.keys(chinaData).find((item: any) => {
            return chinaData[item].label === district
        })

        formData.area = [provinceCode, cityCode, districtCode]
    })
}

getInfo()

const getBaseInfo = () => {
    getBaseInfoApi().then((res: any) => {
        res = res.data
        baseInfoData.merchantTypeData = res.merchantTypeData
        baseInfoData.merchantCategoryData = res.merchantCategoryData
        baseInfoData.settleBankTypeData = res.settleBankTypeData
        baseInfoData.settlementModeData = res.settlementModeData
        baseInfoData.settlementPeriodData = res.settlementPeriodData
        baseInfoData.settleModeData = res.settleModeData
        baseInfoData.industryTypeCodeData = res.industryTypeCodeData
    })
}
getBaseInfo()

const appapplyqueryAllData = reactive<any>({
    sid:localStorage.getItem('seafoxpay_sid'),
    merchantNo: '',
})

const threeDataList = reactive<any>({
    list: []
})

const appData = reactive<any>({
    sid:localStorage.getItem('seafoxpay_sid'),
    authorizeStatus: '',
    channelMerchantNo: '',
    channelShortId: '',
    threePartnerNo: '',
    statusCn: '',
    qrcode: '',
    appPayType: '',
})

const wxPublicApplyQueryData = reactive<any>({
    sid:localStorage.getItem('seafoxpay_sid'),
    wechat_type: 'receipt',
    receiptAppIds: '',
    subscribeAppIds: '',
    appIds: '',
    authPayDirs: '',
})
const qrCodeAuth = ref<any>([])

//设置费率
const setFeilv = () => {
    if(!localStorage.getItem('seafoxpay_sid')){
        ElMessage({
            message: '请先点击商户进件',
            type: 'error',
        })
        return
    }
    setFeilvApi(productData2).then((res: any) => {
    })
}
const app_product_wechat_qrcode = ref<any>('')
const app_product_alipay_qrcode = ref<any>('')
const getProductQrcode = () => {
    getProductQrcodeApi({}).then((res: any) => {
        console.log(res)
        res = res.data
        app_product_wechat_qrcode.value = res.app_product_wechat_qrcode
        app_product_alipay_qrcode.value = res.app_product_alipay_qrcode
    })
}

watch(() => activeName.value, () => {
    if (activeName.value == 'imageUrlQuery') {
        if(!localStorage.getItem('seafoxpay_sid')){
            ElMessage({
                message: '请先点击商户进件',
                type: 'error',
            })
            return
        }
        getInfoApi({ type: 'imageUrlQuery',sid :localStorage.getItem('seafoxpay_sid') }).then((res) => {
            console.log(res)
            res = res.data
            imgData.FRONT_OF_ID_CARD = res.FRONT_OF_ID_CARD ? res.FRONT_OF_ID_CARD : ''
            imgData.BACK_OF_ID_CARD = res.BACK_OF_ID_CARD ? res.BACK_OF_ID_CARD : ''
            imgData.BUSINESS_LICENSE = res.BUSINESS_LICENSE ? res.BUSINESS_LICENSE : ''
            imgData.PERMIT_FOR_BANK_ACCOUNT = res.PERMIT_FOR_BANK_ACCOUNT ? res.PERMIT_FOR_BANK_ACCOUNT : ''
            imgData.SIGN_BOARD = res.SIGN_BOARD ? res.SIGN_BOARD : ''
            imgData.INTERIOR_PHOTO = res.INTERIOR_PHOTO ? res.INTERIOR_PHOTO : ''
            imgData.AUTHORIZATION_FOR_SETTLEMENT = res.AUTHORIZATION_FOR_SETTLEMENT ? res.AUTHORIZATION_FOR_SETTLEMENT : ''
            imgData.HANDHELD_OF_ID_CARD = res.HANDHELD_OF_ID_CARD ? res.HANDHELD_OF_ID_CARD : ''
            imgData.HANDHELD_OF_BANK_CARD = res.HANDHELD_OF_BANK_CARD ? res.HANDHELD_OF_BANK_CARD : ''
            imgData.BANK_CARD = res.BANK_CARD ? res.BANK_CARD : ''
            imgData.SETTLE_FRONT_OF_ID_CARD = res.SETTLE_FRONT_OF_ID_CARD ? res.SETTLE_FRONT_OF_ID_CARD : ''
            imgData.SETTLE_BACK_OF_ID_CARD = res.SETTLE_BACK_OF_ID_CARD ? res.SETTLE_BACK_OF_ID_CARD : ''
        })
    } else if (activeName.value == 'productQuery') {
        if(!localStorage.getItem('seafoxpay_sid')){
            ElMessage({
                message: '请先点击商户进件',
                type: 'error',
            })
            return
        }
        getInfoApi({ type: 'productQuery',sid :localStorage.getItem('seafoxpay_sid') }).then((res) => {
            console.log(res)

            // if(res.data) {
            //     productData.feePurpose = res.data.feePurpose
            //     productData.appPayType = res.data.appPayType
            //     productData.appFeeMode = res.data.appFeeMode
            //     productData.payType = res.data.payType
            //     productData.feeRanges.minFee = res.data.minFee
            //     productData.value = res.data.value
            // }
        })

        getFeilvApi({ sid :localStorage.getItem('seafoxpay_sid') }).then((res: any) => {
            res = res.data
            productData2.system_weixin_feilv = res.system_weixin_feilv
            productData2.system_alipay_feilv = res.system_alipay_feilv
            productData2.weixin_feilv = res.weixin_feilv
            productData2.alipay_feilv = res.alipay_feilv
        })

    } else if (activeName.value == 'appapplyqueryAll') {
        getProductQrcode()
        if(!localStorage.getItem('seafoxpay_sid')){
            ElMessage({
                message: '请先点击商户进件',
                type: 'error',
            })
            return
        }
        getInfoApi({ type: 'appapplyqueryAll',sid :localStorage.getItem('seafoxpay_sid') }).then((res) => {
            console.log(res)
            res = res.data
            threeDataList.list = [];
            res.map((item: any) => {
                item.threePartnerNoData[0].appPayType = item.appPayType
                threeDataList.list.push(item.threePartnerNoData[0])
                qrCodeAuth.value = item.unionPayRecords
            })
            console.log(threeDataList,'threeDataList');
            
            // threeDataList.list = res
        })
    }else if (activeName.value == 'wxPublicApplyQuery') {
        if(!localStorage.getItem('seafoxpay_sid')){
            ElMessage({
                message: '请先点击商户进件',
                type: 'error',
            })
            return
        }
        getInfoApi({ type: 'wxPublicApplyQuery',sid :localStorage.getItem('seafoxpay_sid') }).then((res) => {
            console.log(res,'res')
            res = res.data
            console.log(res,'res')
            wxPublicApplyQueryData.wechat_type = res.wechat_type || 'receipt'
            wxPublicApplyQueryData.receiptAppIds = res.receiptAppIds
            wxPublicApplyQueryData.subscribeAppIds = res.subscribeAppIds
            wxPublicApplyQueryData.appIds = res.appIds
            wxPublicApplyQueryData.authPayDirs = res.authPayDirs
        })
    }
}, { immediate: true })

watch (() => productData.feePurpose, (val) => {
    if(val != 'DEFAULT') {
        productData.appFeeMode = 'RANGE'
    }else {
        productData.appFeeMode = 'DEFAULT'
    }
})

const handleChange = (val: any) => {
    // if(val == 'business_license') {
    //     if(!imgData.BUSINESS_LICENSE)
    //         return;
    //     scanBusinessLicenseApi({img: imgData.BUSINESS_LICENSE ,sid :localStorage.getItem('seafoxpay_sid')}).then((res: any) => {
    //         console.log(res)
    //         res = res.data
    //         formData.legalPerson = res.legalPerson
    //         formData.orgNum = res.creditCode
    //         formData.businessLicense = res.creditCode
    //         formData.address = res.businessAddress
    //         formData.linkman = res.legalPerson
    //         const province = res.province
    //         const city = res.city
    //         const district = res.district

    //         //根据province文本 找到对应的code
    //         const provinceCode = Object.keys(chinaData).find((item: any) => {
    //             return chinaData[item].label === province
    //         })

    //         //根据city文本 找到对应的code
    //         const cityCode = Object.keys(chinaData).find((item: any) => {
    //             return chinaData[item].label === city
    //         })

    //         //根据district文本 找到对应的code
    //         const districtCode = Object.keys(chinaData).find((item: any) => {
    //             return chinaData[item].label === district
    //         })

    //         formData.area = [provinceCode, cityCode, districtCode]
    //     })
    // }else if(val == 'id_card') {
    //     if(!imgData.FRONT_OF_ID_CARD)
    //         return;
    //     scanIdCardApi({img: imgData.FRONT_OF_ID_CARD ,sid :localStorage.getItem('seafoxpay_sid')}).then((res: any) => {
    //         console.log(res)
    //         res = res.data
    //         formData.legalPersonID = res.idNumber
    //         formData.legalPerson = res.legalPerson
    //     })
    // }
}

</script>
  
<style lang="scss" scoped>
.setting-form {
    background-color: #FFFFFF;
    padding: 20px;
    box-sizing: border-box;

    .operation-btn {
        margin-bottom: 16px;
    }
}</style>
  