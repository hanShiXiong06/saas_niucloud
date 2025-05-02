import request from '@/utils/request'
export function asyncAct() {
    return request.get(`tk_cpa/act/async`, {showErrorMessage: true, showSuccessMessage: true})
}
export function getActType() {
    return request.get(`tk_cpa/act/type`)
}
// USER_CODE_BEGIN -- cpa_act
/**
 * 获取CPA活动列列表
 * @param params
 * @returns
 */
export function getActList(params: Record<string, any>) {
    return request.get(`tk_cpa/act`, {params})
}

/**
 * 获取CPA活动列详情
 * @param id CPA活动列id
 * @returns
 */
export function getActInfo(id: number) {
    return request.get(`tk_cpa/act/${id}`);
}

/**
 * 添加CPA活动列
 * @param params
 * @returns
 */
export function addAct(params: Record<string, any>) {
    return request.post('tk_cpa/act', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑CPA活动列
 * @param id
 * @param params
 * @returns
 */
export function editAct(params: Record<string, any>) {
    return request.put(`tk_cpa/act/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除CPA活动列
 * @param id
 * @returns
 */
export function deleteAct(id: number) {
    return request.delete(`tk_cpa/act/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('tk_cpa/member_all', {params})
}export function getWithDiyFormList(params: Record<string,any>){
    return request.get('tk_cpa/diy_form_all', {params})
}

// USER_CODE_END -- cpa_act
