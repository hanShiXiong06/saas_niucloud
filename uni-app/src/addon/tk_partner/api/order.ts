
import request from '@/utils/request'

/***************************************************** hello world ****************************************************/
export function addOrder(data: any) {
    return request.post(`tk_partner/partner/order/create`, data)
}
export function getOrderList(data: any) {
    return request.get(`tk_partner/partner/commission/order/lists`, data)
}
