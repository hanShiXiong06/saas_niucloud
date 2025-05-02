import request from '@/utils/request'

export function getOrderStatus() {
    return request.get(`tk_cpa/order/status`);
}
export function getActType() {
    return request.get(`tk_cpa/order/type`);
}


// USER_CODE_BEGIN -- cpa_order
/**
 * 获取CPA订单列列表
 * @param params
 * @returns
 */
export function getOrderList(params: Record<string, any>) {
    return request.get(`tk_cpa/order`, { params })
}

/**
 * 获取CPA订单列详情
 * @param id CPA订单列id
 * @returns
 */
export function getOrderInfo(id: number) {
    return request.get(`tk_cpa/order/${id}`);
}

/**
 * 添加CPA订单列
 * @param params
 * @returns
 */
export function addOrder(params: Record<string, any>) {
    return request.post('tk_cpa/order', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑CPA订单列
 * @param id
 * @param params
 * @returns
 */
export function editOrder(params: Record<string, any>) {
    return request.put(`tk_cpa/order/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除CPA订单列
 * @param id
 * @returns
 */
export function deleteOrder(id: number) {
    return request.delete(`tk_cpa/order/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string, any>) {
    return request.get('tk_cpa/member_all', { params })
}

/**
 * 获取订单详情
 * @param id 订单ID
 * @returns
 */
export function getOrderDetail(id: number) {
    return request.get(`tk_cpa/order/detail/${id}`)
}

// USER_CODE_END -- cpa_order
