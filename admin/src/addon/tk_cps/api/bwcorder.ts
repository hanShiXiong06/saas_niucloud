import request from '@/utils/request'
/**
 * 获取订单状态
 * @returns 
 */
export function getOrderStatus() {
    return request.get('tk_cps/bwc/getorderstatus')
}
// USER_CODE_BEGIN -- cpsbwc_order
/**
 * 获取霸王餐订单列表
 * @param params
 * @returns
 */
export function getBwcOrderList(params: Record<string, any>) {
    return request.get(`tk_cps/bwcorder`, { params })
}

/**
 * 获取霸王餐订单详情
 * @param id 霸王餐订单id
 * @returns
 */
export function getBwcOrderInfo(id: number) {
    return request.get(`tk_cps/bwcorder/${id}`);
}

/**
 * 添加霸王餐订单
 * @param params
 * @returns
 */
export function addBwcOrder(params: Record<string, any>) {
    return request.post('tk_cps/bwcorder', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑霸王餐订单
 * @param id
 * @param params
 * @returns
 */
export function editBwcOrder(params: Record<string, any>) {
    return request.put(`tk_cps/bwcorder/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除霸王餐订单
 * @param id
 * @returns
 */
export function deleteBwcOrder(id: number) {
    return request.delete(`tk_cps/bwcorder/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- cpsbwc_order
