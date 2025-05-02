import request from '@/utils/request'

// USER_CODE_BEGIN -- aihumans_help
/**
 * 获取帮助中心列表
 * @param params
 * @returns
 */
export function getAihumansHelpList(params: Record<string, any>) {
    return request.get(`ai_humans/aihumanshelp`, {params})
}

/**
 * 获取帮助中心详情
 * @param id 帮助中心id
 * @returns
 */
export function getAihumansHelpInfo(id: number) {
    return request.get(`ai_humans/aihumanshelp/${id}`);
}

/**
 * 添加帮助中心
 * @param params
 * @returns
 */
export function addAihumansHelp(params: Record<string, any>) {
    return request.post('ai_humans/aihumanshelp', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑帮助中心
 * @param id
 * @param params
 * @returns
 */
export function editAihumansHelp(params: Record<string, any>) {
    return request.put(`ai_humans/aihumanshelp/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除帮助中心
 * @param id
 * @returns
 */
export function deleteAihumansHelp(id: number) {
    return request.delete(`ai_humans/aihumanshelp/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- aihumans_help
