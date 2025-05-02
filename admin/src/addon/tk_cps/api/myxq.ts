import request from '@/utils/request'
//充值订单列表
export function getRechargeOrderList(params: Record<string, any>) {
    return request.get(`tk_cps/myxqrechargeorder`, {params})
}
//充值订单状态
export function getRechargeOrderStatus() {
    return request.get(`tk_cps/getrechargeorderstatus`)
}
//电影票订单列表
export function getMovieOrderList(params: Record<string, any>) {
    return request.get(`tk_cps/myxqmovieorder`, {params})
}
//电影票订单状态
export function getMovieOrderStatus() {
    return request.get(`tk_cps/getmovieorderstatus`)
}
//点餐订单列表
export function getDcOrderList(params: Record<string, any>) {
    return request.get(`tk_cps/myxqdcorder`, {params})
}
//点餐订单状态
export function getDcOrderStatus() {
    return request.get(`tk_cps/getdcorderstatus`)
}
//点餐订单详情
export function getDcOrderDetail(params: Record<string, any>) {
    return request.get(`tk_cps/myxqdcorderdetail`, {params})
}
//周边优惠订单列表
export function getNearOrderList(params: Record<string, any>) {
    return request.get(`tk_cps/myxqnearorder`, {params})
}
//周边优惠订单状态
export function getNearOrderStatus() {
    return request.get(`tk_cps/getnearorderstatus`)
}
//自营订单列表
export function getShopOrderList(params: Record<string, any>) {
    return request.get(`tk_cps/myxqshoporder`, {params})
}
//自营订单状态
export function getShopOrderStatus() {
    return request.get(`tk_cps/getshoporderstatus`)
}
//其他订单列表
export function getOtherOrderList(params: Record<string, any>) {
    return request.get(`tk_cps/myxqotherorder`, {params})
}
//其他订单平台
export function getOtherOrderPf() {
    return request.get(`tk_cps/getotherorderpf`)
}
