import request from '@/utils/request'

export const getInfoApi = (params: {type:string, appPayType?:string, activityId?:string}):Promise<any> => request.post('seafox_pay/part/info', params)

export const getBaseInfoApi = () => request.post('seafox_pay/part/getBaseInfo')

export const getFeilvApi = (params: any) => request.post('seafox_pay/part/getFeilv' ,params)

//进件
export const partsApi = (params: any, imgData: any):Promise<any> => request.post('seafox_pay/part/parts', {...params, imgData})

//资质上传
export const imageUrlQueryApi = (params: any):Promise<any> => request.post('seafox_pay/part/imageUrlQuery', params)

//产品开通
export const productQueryApi = (params: any):Promise<any> => request.post('seafox_pay/part/productQuery', params)

//app报备
export const appapplyqueryAllApi = (params: {merchantNo: string, appPayType: string}):Promise<any> => request.post('seafox_pay/part/appapplyqueryAll', params)

//微信进件
export const wxPublicApplyQueryApi = (params: any):Promise<any> => request.post('seafox_pay/part/wxPublicApplyQuery', params)

//设置费率
export const setFeilvApi = (params: any):Promise<any> => request.post('seafox_pay/part/setFeilv', params)

//二级商户修改
export const submitAliSubMerchantUpdateApi = (params: any) => request.post('seafox_pay/part/aliSubMerchantUpdate', params)

//代运营授权绑定
export const submitBindorauthApi = (params: any) => request.post('seafox_pay/part/bindorauth', params)

//结算卡信息变更
export const submitCardalterationApi = (params: any) => request.post('seafox_pay/part/cardalteration', params)

//修改商户信息
export const submitModifyMerchantInfAPi = (params: any) => request.post('seafox_pay/part/modifyMerchantInfo', params)

//活动报名资质
export const submitActivityApplyUrl = (params: any ,sid : string) => request.post('seafox_pay/part/activityApplyUrl', { img :params ,sid  })

//活动报名
export const submitActivityApply = (params: any) => request.post('seafox_pay/part/activityApply', params)

//报名活动二次修改
export const submitActivityApplyUpdateApi = (params: any) => request.post('seafox_pay/part/second_activityApply', params)

//产品手续费收取方式
export const submitModifyProductConfigApi = (params: any) => request.post('seafox_pay/part/modifyProductConfig', params)

//自动扫描营业执照
export const scanBusinessLicenseApi = (params: {img: string}) => request.post('seafox_pay/part/scanBusinessLicenseByMiniProgram', params)

//自动扫描身份证
export const scanIdCardApi = (params: {img: string}) => request.post('seafox_pay/part/scanIdCardByMiniProgram', params)

export const getProductQrcodeApi = () => request.post('seafox_pay/part/getProductQrcode')