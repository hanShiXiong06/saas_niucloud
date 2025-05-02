import request from '@/utils/request'

/***************************************************** 平台接口 ****************************************************/

/**
 * 配置列表
 * @returns
 */
export function getPlatformList() {
    return request.get('ai_humans/platform/list')
}

/**
 * 配置详情
 * @param sms_type
 * @returns
 */
export function getPlatformInfo(type: string) {
    return request.get(`ai_humans/platform/config/${type}`,)
}

/**
 * 配置修改
 * @param params
 */
export function editPlatform(params: Record<string, any>) {
    return request.put(`ai_humans/platform/config/${params.type}`, params, { showSuccessMessage: true })
}
