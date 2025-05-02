
import request from '@/utils/request'

/**
 * 配置信息
 * @returns
 */
export function getCommonConfig() {
    return request.get('tk_yht/getcommonconfig')
}



/**
 *配置修改
 * @param params
 */
export function setCommonConfig(params: Record<string, any>) {
    return request.post(`tk_yht/setcommonconfig`, params, {showSuccessMessage: true})
}