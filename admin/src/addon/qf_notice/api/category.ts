import request from '@/utils/request'

// USER_CODE_BEGIN -- qfnotice_category
/**
 * 获取应用分类列表
 * @param params
 * @returns
 */
export function getCategoryList(params: Record<string, any>) {
    return request.get(`qf_notice/category`, {params})
}

/**
 * 获取应用分类详情
 * @param id 应用分类id
 * @returns
 */
export function getCategoryInfo(id: number) {
    return request.get(`qf_notice/category/${id}`);
}

/**
 * 添加应用分类
 * @param params
 * @returns
 */
export function addCategory(params: Record<string, any>) {
    return request.post('qf_notice/category', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑应用分类
 * @param id
 * @param params
 * @returns
 */
export function editCategory(params: Record<string, any>) {
    return request.put(`qf_notice/category/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除应用分类
 * @param id
 * @returns
 */
export function deleteCategory(id: number) {
    return request.delete(`qf_notice/category/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- qfnotice_category
