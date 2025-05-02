import request from '@/utils/request'









// USER_CODE_BEGIN -- running_product
/**
 * 获取产品列表
 * @param params
 * @returns
 */
export function getRunningProductList(params: Record<string, any>) {
    return request.get(`running/running_product`, {params})
}

/**
 * 获取产品详情
 * @param id 产品id
 * @returns
 */
export function getRunningProductInfo(id: number) {
    return request.get(`running/running_product/${id}`);
}

/**
 * 添加产品
 * @param params
 * @returns
 */
export function addRunningProduct(params: Record<string, any>) {
    return request.post('running/running_product', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑产品
 * @param id
 * @param params
 * @returns
 */
export function editRunningProduct(params: Record<string, any>) {
    return request.put(`running/running_product/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除产品
 * @param id
 * @returns
 */
export function deleteRunningProduct(id: number) {
    return request.delete(`running/running_product/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithRunningSchoolList(params: Record<string,any>){
    return request.get('running/running_school_all', {params})
}

// USER_CODE_END -- running_product
