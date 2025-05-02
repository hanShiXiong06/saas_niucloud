import request from '@/utils/request'


/***************************************************** CPA配置接口 ****************************************************/

/**
 * 获取接口配置
 * @param params
 * @returns
 */
export function getConfig() {
    return request.get(`tk_cpa/config/getconfig`)
}
/**
 * 设置配置
 * @param params
 * @returns
 */
export function setConfig(params: Record<string, any>) {
    return request.post(`tk_cpa/config/setconfig`, params,{ showErrorMessage: true, showSuccessMessage: true })
}

