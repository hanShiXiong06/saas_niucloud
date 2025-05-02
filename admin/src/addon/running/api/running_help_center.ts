import request from '@/utils/request'

// USER_CODE_BEGIN -- running_help_center
/**
 * 获取帮助中心列表
 * @param params
 * @returns
 */
export function getRunningHelpCenterList(params: Record<string, any>) {
    return request.get(`running/running_help_center`, {params})
}

/**
 * 获取帮助中心详情
 * @param id 帮助中心id
 * @returns
 */
export function getRunningHelpCenterInfo(id: number) {
    return request.get(`running/running_help_center/${id}`);
}

/**
 * 添加帮助中心
 * @param params
 * @returns
 */
export function addRunningHelpCenter(params: Record<string, any>) {
    return request.post('running/running_help_center', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑帮助中心
 * @param id
 * @param params
 * @returns
 */
export function editRunningHelpCenter(params: Record<string, any>) {
    return request.put(`running/running_help_center/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除帮助中心
 * @param id
 * @returns
 */
export function deleteRunningHelpCenter(id: number) {
    return request.delete(`running/running_help_center/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- running_help_center
