import request from '@/utils/request'

// USER_CODE_BEGIN -- tkpartner_commission_order
/**
 * 获取订单结算列表
 * @param params
 * @returns
 */
export function getCommissionOrderList(params: Record<string, any>) {
    return request.get(`tk_partner/commissionorder`, {params})
}

/**
 * 获取订单结算详情
 * @param id 订单结算id
 * @returns
 */
export function getCommissionOrderInfo(id: number) {
    return request.get(`tk_partner/commissionorder/${id}`);
}

/**
 * 添加订单结算
 * @param params
 * @returns
 */
export function addCommissionOrder(params: Record<string, any>) {
    return request.post('tk_partner/commissionorder', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑订单结算
 * @param id
 * @param params
 * @returns
 */
export function editCommissionOrder(params: Record<string, any>) {
    return request.put(`tk_partner/commissionorder/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除订单结算
 * @param id
 * @returns
 */
export function deleteCommissionOrder(id: number) {
    return request.delete(`tk_partner/commissionorder/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('tk_partner/member_all', {params})
}

// USER_CODE_END -- tkpartner_commission_order
