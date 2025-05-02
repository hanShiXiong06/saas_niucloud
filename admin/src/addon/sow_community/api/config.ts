import request from '@/utils/request'

/**
 * 获取社区设置
 * @returns
 */
export function getConfig() {
    return request.get('sow_community/config')
}

/**
 * 编辑社区设置
 * @returns
 */
export function setConfig(param: any) {
    return request.post('sow_community/config', param, { showSuccessMessage: true })
}