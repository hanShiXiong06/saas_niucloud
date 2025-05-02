import request from '@/utils/request'
export function asyncOrder() {
    return request.get(`tk_cps/actorder/asyncorder`, { showSuccessMessage: true })
}
// USER_CODE_BEGIN -- cps_act_order
/**
 * 获取CPS活动订单列表
 * @param params
 * @returns
 */
export function getActorderList(params: Record<string, any>) {
    return request.get(`tk_cps/actorder`, { params })
}

/**
 * 获取CPS活动订单详情
 * @param id CPS活动订单id
 * @returns
 */
export function getActorderInfo(id: number) {
    return request.get(`tk_cps/actorder/${id}`);
}

/**
 * 添加CPS活动订单
 * @param params
 * @returns
 */
export function addActorder(params: Record<string, any>) {
    return request.post('tk_cps/actorder', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑CPS活动订单
 * @param id
 * @param params
 * @returns
 */
export function editActorder(params: Record<string, any>) {
    return request.put(`tk_cps/actorder/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除CPS活动订单
 * @param id
 * @returns
 */
export function deleteActorder(id: number) {
    return request.delete(`tk_cps/actorder/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- cps_act_order
