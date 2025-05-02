import request from '@/utils/request'



// USER_CODE_BEGIN -- blog_shequn
/**
 * 获取微信社群列表
 * @param params
 * @returns
 */
export function getShequnList(params: Record<string, any>) {
    return request.get(`blog/shequn`, {params})
}

/**
 * 获取微信社群详情
 * @param id 微信社群id
 * @returns
 */
export function getShequnInfo(id: number) {
    return request.get(`blog/shequn/${id}`);
}

/**
 * 添加微信社群
 * @param params
 * @returns
 */
export function addShequn(params: Record<string, any>) {
    return request.post('blog/shequn', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑微信社群
 * @param id
 * @param params
 * @returns
 */
export function editShequn(params: Record<string, any>) {
    return request.put(`blog/shequn/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除微信社群
 * @param id
 * @returns
 */
export function deleteShequn(id: number) {
    return request.delete(`blog/shequn/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithShequncateList(params: Record<string,any>){
    return request.get('blog/shequncate_all', {params})
}

// USER_CODE_END -- blog_shequn
