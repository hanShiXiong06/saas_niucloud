
import request from '@/addon/tk_yht/utils/request'

/**
 * 设置 物流查询配置
 * @param params
 * @returns
 */
export function setDeliverySearch(params: Record<string, any>) {
    return request.post('tk_yht/delivery/setconfig', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 获取 物流查询配置
 * @returns
 */
export function getDeliverySearch() {
    return request.get('tk_yht/delivery/getconfig')
}