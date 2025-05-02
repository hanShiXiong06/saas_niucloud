import request from '@/utils/request'

// USER_CODE_BEGIN -- running_order_product
/**
 * 获取订单商品列表
 * @param params
 * @returns
 */
export function getRunningOrderProductList(params: Record<string, any>) {
    return request.get(`running/running_order_product`, {params})
}

/**
 * 获取订单商品详情
 * @param id 订单商品id
 * @returns
 */
export function getRunningOrderProductInfo(id: number) {
    return request.get(`running/running_order_product/${id}`);
}

/**
 * 添加订单商品
 * @param params
 * @returns
 */
export function addRunningOrderProduct(params: Record<string, any>) {
    return request.post('running/running_order_product', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑订单商品
 * @param id
 * @param params
 * @returns
 */
export function editRunningOrderProduct(params: Record<string, any>) {
    return request.put(`running/running_order_product/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除订单商品
 * @param id
 * @returns
 */
export function deleteRunningOrderProduct(id: number) {
    return request.delete(`running/running_order_product/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- running_order_product
