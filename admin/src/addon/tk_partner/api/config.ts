
import request from '@/utils/request'
export function getShareCode() {
    return request.get('tk_partner/getsharecode')
}
/**
 * 配置信息
 * @returns
 */
export function getConfig() {
    return request.get('tk_partner/getconfig')
}

/**
 *配置修改
 * @param params
 */
export function setConfig(params: Record<string, any>) {
    return request.post(`tk_partner/setconfig`, params, { showSuccessMessage: true })
}
/**
 * 获取佣金配置
 * @returns 
 */
export function getPartnerCommissionConfig() {
    return request.get('tk_partner/getpartnercommissionconfig')
}
/**
 * 设置佣金配置
 * @param params 
 * @returns 
 */
export function setPartnerCommissionConfig(params: Record<string, any>) {
    return request.post(`tk_partner/setpartnercommissionconfig`, params, { showSuccessMessage: true })
}

export function getWeappConfig() {
    return request.get('tk_partner/getweappconfig')
}

/**
 *配置修改
 * @param params
 */
export function setWeappConfig(params: Record<string, any>) {
    return request.post(`tk_partner/setweappconfig`, params, { showSuccessMessage: true })
}
export function weappVersion(params: Record<string, any>) {
    return request.post(`tk_partner/upload/version`, params, { showSuccessMessage: true })
}