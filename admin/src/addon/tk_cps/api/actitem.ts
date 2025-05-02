import request from '@/utils/request'
export function delselect(params: Record<string, any>) {
    return request.post(`tk_cps/delactitemselect`, params, { showErrorMessage: true, showSuccessMessage: true })
}
// USER_CODE_BEGIN -- cps_act_item
/**
 * 获取活动详情列表
 * @param params
 * @returns
 */
export function getActItemList(params: Record<string, any>) {
    return request.get(`tk_cps/actitem`, {params})
}

/**
 * 获取活动详情详情
 * @param id 活动详情id
 * @returns
 */
export function getActItemInfo(id: number) {
    return request.get(`tk_cps/actitem/${id}`);
}

/**
 * 添加活动详情
 * @param params
 * @returns
 */
export function addActItem(params: Record<string, any>) {
    return request.post('tk_cps/actitem', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑活动详情
 * @param id
 * @param params
 * @returns
 */
export function editActItem(params: Record<string, any>) {
    return request.put(`tk_cps/actitem/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除活动详情
 * @param id
 * @returns
 */
export function deleteActItem(id: number) {
    return request.delete(`tk_cps/actitem/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- cps_act_item
