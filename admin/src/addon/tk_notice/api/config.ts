
import request from '@/utils/request'

export function getConfig() {
    return request.get('tk_notice/config/getconfig')
}

/**
 *配置修改
 * @param params
 */
export function setConfig(params: Record<string, any>) {
    return request.post(`tk_notice/config/setconfig`, params, { showSuccessMessage: true })
}
