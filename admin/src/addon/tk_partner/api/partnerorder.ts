import request from '@/utils/request'

// USER_CODE_BEGIN -- tkpartner_order
/**
 * 获取店主开通订单列表
 * @param params
 * @returns
 */
export function getPartnerOrderList(params: Record<string, any>) {
    return request.get(`tk_partner/partnerorder`, {params})
}

/**
 * 获取店主开通订单详情
 * @param id 店主开通订单id
 * @returns
 */
export function getPartnerOrderInfo(id: number) {
    return request.get(`tk_partner/partnerorder/${id}`);
}

/**
 * 添加店主开通订单
 * @param params
 * @returns
 */
export function addPartnerOrder(params: Record<string, any>) {
    return request.post('tk_partner/partnerorder', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑店主开通订单
 * @param id
 * @param params
 * @returns
 */
export function editPartnerOrder(params: Record<string, any>) {
    return request.put(`tk_partner/partnerorder/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除店主开通订单
 * @param id
 * @returns
 */
export function deletePartnerOrder(id: number) {
    return request.delete(`tk_partner/partnerorder/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('tk_partner/member_all', {params})
}export function getWithLevelList(params: Record<string,any>){
    return request.get('tk_partner/level_all', {params})
}

// USER_CODE_END -- tkpartner_order
