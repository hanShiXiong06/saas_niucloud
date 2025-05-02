import request from '@/utils/request'

// USER_CODE_BEGIN -- tkpartner_help
/**
 * 获取帮助中心列表
 * @param params
 * @returns
 */
export function getHelpList(params: Record<string, any>) {
    return request.get(`tk_partner/help`, {params})
}

/**
 * 获取帮助中心详情
 * @param id 帮助中心id
 * @returns
 */
export function getHelpInfo(id: number) {
    return request.get(`tk_partner/help/${id}`);
}

/**
 * 添加帮助中心
 * @param params
 * @returns
 */
export function addHelp(params: Record<string, any>) {
    return request.post('tk_partner/help', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑帮助中心
 * @param id
 * @param params
 * @returns
 */
export function editHelp(params: Record<string, any>) {
    return request.put(`tk_partner/help/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除帮助中心
 * @param id
 * @returns
 */
export function deleteHelp(id: number) {
    return request.delete(`tk_partner/help/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithHelpCatList(params: Record<string,any>){
    return request.get('tk_partner/help_cat_all', {params})
}

// USER_CODE_END -- tkpartner_help
