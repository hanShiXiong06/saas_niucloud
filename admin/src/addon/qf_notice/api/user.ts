import request from '@/utils/request'
export function delselect(params: Record<string, any>) {
    return request.post(`qf_notice/deluserselect`, params, { showErrorMessage: true, showSuccessMessage: true })
}
export function clearUser() {
    return request.post(`qf_notice/clearuser`, { showErrorMessage: true, showSuccessMessage: true })
}
// USER_CODE_BEGIN -- qfnotice_user
/**
 * 获取用户列列表
 * @param params
 * @returns
 */
export function getUserList(params: Record<string, any>) {
    return request.get(`qf_notice/user`, { params })
}

/**
 * 获取用户列详情
 * @param id 用户列id
 * @returns
 */
export function getUserInfo(id: number) {
    return request.get(`qf_notice/user/${id}`);
}

/**
 * 添加用户列
 * @param params
 * @returns
 */
export function addUser(params: Record<string, any>) {
    return request.post('qf_notice/user', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑用户列
 * @param id
 * @param params
 * @returns
 */
export function editUser(params: Record<string, any>) {
    return request.put(`qf_notice/user/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除用户列
 * @param id
 * @returns
 */
export function deleteUser(id: number) {
    return request.delete(`qf_notice/user/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithUserCatList(params: Record<string, any>) {
    return request.get('qf_notice/user_cat_all', { params })
}

// USER_CODE_END -- qfnotice_user
