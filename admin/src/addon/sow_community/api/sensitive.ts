import request from '@/utils/request'

/**
 * 获取敏感词设置
 * @returns
 */
export function getSensitive() {
    return request.get('sow_community/sensitive')
}

/**
 * 编辑取敏感词设置
 * @returns
 */
export function setSensitive(param: any) {
    return request.post('sow_community/sensitive', param, { showSuccessMessage: true })
}