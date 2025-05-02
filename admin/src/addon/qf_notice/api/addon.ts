import request from '@/utils/request'
export function getWithMemberLevelList(params: Record<string, any>) {
    return request.get('qf_notice/member_level_all', { params })
}
export function sendNotice(id) {
    return request.get(`qf_notice/send/notice/${id}`, { showSuccessMessage: true, showErrorMessage: true })
}
export function getAddonType() {
    return request.get(`qf_notice/addon/addontype`)
}
export function getWithCategoryList(params: Record<string, any>) {
    return request.get('qf_notice/category_all', { params })
}
// USER_CODE_BEGIN -- qfnotice_addon
/**
 * 获取群发应用列表
 * @param params
 * @returns
 */
export function getAddonList(params: Record<string, any>) {
    return request.get(`qf_notice/addon`, { params })
}

/**
 * 获取群发应用详情
 * @param id 群发应用id
 * @returns
 */
export function getAddonInfo(id: number) {
    return request.get(`qf_notice/addon/${id}`);
}

/**
 * 添加群发应用
 * @param params
 * @returns
 */
export function addAddon(params: Record<string, any>) {
    return request.post('qf_notice/addon', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑群发应用
 * @param id
 * @param params
 * @returns
 */
export function editAddon(params: Record<string, any>) {
    return request.put(`qf_notice/addon/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除群发应用
 * @param id
 * @returns
 */
export function deleteAddon(id: number) {
    return request.delete(`qf_notice/addon/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- qfnotice_addon
