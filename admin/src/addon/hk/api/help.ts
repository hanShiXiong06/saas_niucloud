import request from '@/utils/request'

// USER_CODE_BEGIN -- hk_help
/**
 * 获取帮助中心列表
 * @param params
 * @returns
 */
export function getHelpList(params: Record<string, any>) {
    return request.get(`hk/help`, {params})
}

/**
 * 获取帮助中心详情
 * @param id 帮助中心id
 * @returns
 */
export function getHelpInfo(id: number) {
    return request.get(`hk/help/${id}`);
}

/**
 * 添加帮助中心
 * @param params
 * @returns
 */
export function addHelp(params: Record<string, any>) {
    return request.post('hk/help', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑帮助中心
 * @param id
 * @param params
 * @returns
 */
export function editHelp(params: Record<string, any>) {
    return request.put(`hk/help/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除帮助中心
 * @param id
 * @returns
 */
export function deleteHelp(id: number) {
    return request.delete(`hk/help/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- hk_help
