import request from '@/utils/request'
//订单列表
export function getOrderList(params: Record<string, any>) {
    return request.get(`tk_cps/getjtkorderlist`, {params})
}
//订单品牌
export function getOrderBrand() {
    return request.get(`tk_cps/getjtkorderbrand`)
}
//订单状态
export function getOrderStatus() {
    return request.get(`tk_cps/getjtkorderstatus`)
}
