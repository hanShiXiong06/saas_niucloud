
import request from '@/utils/request'

/***************************************************** 声音接口 ****************************************************/

/**
 * 克隆声音
 * @param params 
 * @returns 
 */
export function createPackageOrder(params) {
    return request.post('ai_humans/createpackageorder', params)
}
export function getOrderList(params) {
    return request.get(`ai_humans/order`, params)
}
export function getOrderStatus() {
    return request.get(`ai_humans/order/status`)
}
/**
 * 删除订单
 */
export function deleteOrder(id: number) {
    return request.delete(`ai_humans/order/${id}`, { showSuccessMessage: true, showErrorMessage: true })
}
