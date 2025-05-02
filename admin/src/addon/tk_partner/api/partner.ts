import request from '@/utils/request'
export function getPartnerDict() {
    return request.get(`tk_partner/partner/dict`)
}
// USER_CODE_BEGIN -- tkpartner_partner
/**
 * 获取店主列列表
 * @param params
 * @returns
 */
export function getPartnerList(params: Record<string, any>) {
    return request.get(`tk_partner/partner`, {params})
}

/**
 * 获取店主列详情
 * @param id 店主列id
 * @returns
 */
export function getPartnerInfo(id: number) {
    return request.get(`tk_partner/partner/${id}`);
}

/**
 * 添加店主列
 * @param params
 * @returns
 */
export function addPartner(params: Record<string, any>) {
    return request.post('tk_partner/partner', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑店主列
 * @param id
 * @param params
 * @returns
 */
export function editPartner(params: Record<string, any>) {
    return request.put(`tk_partner/partner/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除店主列
 * @param id
 * @returns
 */
export function deletePartner(id: number) {
    return request.delete(`tk_partner/partner/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('tk_partner/member_all', {params})
}export function getWithLevelList(params: Record<string,any>){
    return request.get('tk_partner/level_all', {params})
}

// USER_CODE_END -- tkpartner_partner
