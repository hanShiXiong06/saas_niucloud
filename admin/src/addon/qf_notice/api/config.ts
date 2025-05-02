import request from '@/utils/request'


/***************************************************** 智能对话配置接口 ****************************************************/

/**
 * 获取接口配置
 * @param params
 * @returns
 */
export function getConfig() {
    return request.get(`qf_notice/config/getconfig`)
}
/**
 * 设置配置
 * @param params
 * @returns
 */
export function setConfig(params: Record<string, any>) {
    return request.post(`qf_notice/config/setconfig`, params, { showErrorMessage: true, showSuccessMessage: true })
}
/**
 * 导入会员
 */

export function importMember(params: Record<string, any>) {
    return request.post(`qf_notice/user/import`, params)
}