import request from '@/utils/request'

/***************************************************** 充值订单 ****************************************************/

/**
 * 获取充值订单列表
 * @param params
 * @returns
 */
export function getMaidanOrderList(params: Record<string, any>) {
    return request.get(`seafox_pay/maidan/order`, {params})
}

/**
 * 获取充值订单统计
 * @param params
 * @returns
 */
export function getMaidanStat(params: Record<string, any>) {
    return request.get(`seafox_pay/maidan/order/stat`, {params})
}

/**
 * 获取充值订单详情
 * @param order_id
 * @returns
 */
export function getMaidanOrderInfo(order_id: number) {
    return request.get(`seafox_pay/maidan/order/${order_id}`);
}

/**
 * 获取充值订单状态列表
 * @returns
 */
export function getMaidanOrderStatusList() {
    return request.get(`seafox_pay/maidan/order/status`)
}