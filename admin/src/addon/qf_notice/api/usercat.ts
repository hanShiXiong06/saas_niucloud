import request from '@/utils/request'

// USER_CODE_BEGIN -- qfnotice_user_cat
/**
 * 获取用户分类列表
 * @param params
 * @returns
 */
export function getUserCatList(params: Record<string, any>) {
    return request.get(`qf_notice/usercat`, {params})
}

/**
 * 获取用户分类详情
 * @param id 用户分类id
 * @returns
 */
export function getUserCatInfo(id: number) {
    return request.get(`qf_notice/usercat/${id}`);
}

/**
 * 添加用户分类
 * @param params
 * @returns
 */
export function addUserCat(params: Record<string, any>) {
    return request.post('qf_notice/usercat', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑用户分类
 * @param id
 * @param params
 * @returns
 */
export function editUserCat(params: Record<string, any>) {
    return request.put(`qf_notice/usercat/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除用户分类
 * @param id
 * @returns
 */
export function deleteUserCat(id: number) {
    return request.delete(`qf_notice/usercat/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- qfnotice_user_cat
