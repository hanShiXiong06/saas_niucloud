import request from '@/utils/request'
export function syncProduct() {
    return request.get(`hk/syncproduct`, { showErrorMessage: true, showSuccessMessage: true })
}
export function getOperator() {
    return request.get(`hk/getoperator`)
}
export function getMode() {
    return request.get(`hk/getmode`)
}
export function upProduct(id: number) {
    return request.get(`hk/upproduct/${id}`, { showErrorMessage: true, showSuccessMessage: true });
}
export function dnProduct(id: number) {
    return request.get(`hk/dnproduct/${id}`, { showErrorMessage: true, showSuccessMessage: true });
}
// USER_CODE_BEGIN -- hk_product
/**
 * 获取号卡产品列表
 * @param params
 * @returns
 */
export function getProductList(params: Record<string, any>) {
    return request.get(`hk/product`, { params })
}

/**
 * 获取号卡产品详情
 * @param id 号卡产品id
 * @returns
 */
export function getProductInfo(id: number) {
    return request.get(`hk/product/${id}`);
}

/**
 * 添加号卡产品
 * @param params
 * @returns
 */
export function addProduct(params: Record<string, any>) {
    return request.post('hk/product', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑号卡产品
 * @param id
 * @param params
 * @returns
 */
export function editProduct(params: Record<string, any>) {
    return request.put(`hk/product/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除号卡产品
 * @param id
 * @returns
 */
export function deleteProduct(id: number) {
    return request.delete(`hk/product/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- hk_product
