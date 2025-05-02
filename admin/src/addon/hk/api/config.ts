import request from '@/utils/request'


/***************************************************** card 配置接口 ****************************************************/

/**
 * 获取接口配置
 * @param params
 * @returns
 */
export function getConfig() {
    return request.get(`hk/config/getconfig`)
}

/**
 * 设置配置
 * @param params
 * @returns
 */
export function setConfig(params: Record<string, any>) {
    return request.post(`hk/config/setconfig`, params, { showErrorMessage: true, showSuccessMessage: true })
}


