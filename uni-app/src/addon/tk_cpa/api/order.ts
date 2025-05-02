
import request from '@/utils/request'

/***************************************************** CPA开码接口 ****************************************************/
export function addOrder(params: any) {
    return request.post(`tk_cpa/order/add`, params)
}
export function getOrderBySidKey(params: any) {
    return request.get(`tk_cpa/order/bysidkey`, params)
}
export function getOrderList(params: any) {
    return request.get(`tk_cpa/order`, params)
}
export function getOrderStatus() {
    return request.get(`tk_cpa/order/getorderstatus`)
}