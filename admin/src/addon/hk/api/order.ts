import request from '@/utils/request'
export function queryExpress(id: number) {
    return request.get(`hk/order/queryexpress/${id}`);
}
export function queryOrder(id: number) {
    return request.get(`hk/order/queryorder/${id}`, { showErrorMessage: true, showSuccessMessage: true });
}
export function queryCommission(id: number) {
    return request.get(`hk/order/querycommission/${id}`, { showErrorMessage: true, showSuccessMessage: true });
}

// USER_CODE_BEGIN -- hk_order
/**
 * 获取号卡订单列表
 * @param params
 * @returns
 */
export function getOrderList(params: Record<string, any>) {
    return request.get(`hk/order`, { params })
}

/**
 * 获取号卡订单详情
 * @param id 号卡订单id
 * @returns
 */
export function getOrderInfo(id: number) {
    return request.get(`hk/order/${id}`);
}

/**
 * 添加号卡订单
 * @param params
 * @returns
 */
export function addOrder(params: Record<string, any>) {
    return request.post('hk/order', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑号卡订单
 * @param id
 * @param params
 * @returns
 */
export function editOrder(params: Record<string, any>) {
    return request.put(`hk/order/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除号卡订单
 * @param id
 * @returns
 */
export function deleteOrder(id: number) {
    return request.delete(`hk/order/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string, any>) {
    return request.get('hk/member_all', { params })
}

// USER_CODE_END -- hk_order
