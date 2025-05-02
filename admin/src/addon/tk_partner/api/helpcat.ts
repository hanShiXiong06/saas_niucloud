import request from '@/utils/request'

// USER_CODE_BEGIN -- tkpartner_help_cat
/**
 * 获取帮助分类列表
 * @param params
 * @returns
 */
export function getHelpCatList(params: Record<string, any>) {
    return request.get(`tk_partner/helpcat`, {params})
}

/**
 * 获取帮助分类详情
 * @param id 帮助分类id
 * @returns
 */
export function getHelpCatInfo(id: number) {
    return request.get(`tk_partner/helpcat/${id}`);
}

/**
 * 添加帮助分类
 * @param params
 * @returns
 */
export function addHelpCat(params: Record<string, any>) {
    return request.post('tk_partner/helpcat', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑帮助分类
 * @param id
 * @param params
 * @returns
 */
export function editHelpCat(params: Record<string, any>) {
    return request.put(`tk_partner/helpcat/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除帮助分类
 * @param id
 * @returns
 */
export function deleteHelpCat(id: number) {
    return request.delete(`tk_partner/helpcat/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- tkpartner_help_cat
