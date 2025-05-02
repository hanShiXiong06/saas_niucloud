import request from '@/utils/request'

// USER_CODE_BEGIN -- blog_shequncate
/**
 * 获取微信社群列表
 * @param params
 * @returns
 */
export function getShequncateList(params: Record<string, any>) {
    return request.get(`blog/shequncate`, {params})
}

/**
 * 获取微信社群详情
 * @param id 微信社群id
 * @returns
 */
export function getShequncateInfo(id: number) {
    return request.get(`blog/shequncate/${id}`);
}

/**
 * 添加微信社群
 * @param params
 * @returns
 */
export function addShequncate(params: Record<string, any>) {
    return request.post('blog/shequncate', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑微信社群
 * @param id
 * @param params
 * @returns
 */
export function editShequncate(params: Record<string, any>) {
    return request.put(`blog/shequncate/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除微信社群
 * @param id
 * @returns
 */
export function deleteShequncate(id: number) {
    return request.delete(`blog/shequncate/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- blog_shequncate
