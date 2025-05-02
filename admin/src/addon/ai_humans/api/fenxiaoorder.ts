import request from '@/utils/request'

// USER_CODE_BEGIN -- aihumans_fenxiao_order
/**
 * 获取分销订单列表
 * @param params
 * @returns
 */
export function getFenxiaoOrderList(params: Record<string, any>) {
    return request.get(`ai_humans/fenxiaoorder`, {params})
}

/**
 * 获取分销订单详情
 * @param id 分销订单id
 * @returns
 */
export function getFenxiaoOrderInfo(id: number) {
    return request.get(`ai_humans/fenxiaoorder/${id}`);
}

/**
 * 添加分销订单
 * @param params
 * @returns
 */
export function addFenxiaoOrder(params: Record<string, any>) {
    return request.post('ai_humans/fenxiaoorder', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑分销订单
 * @param id
 * @param params
 * @returns
 */
export function editFenxiaoOrder(params: Record<string, any>) {
    return request.put(`ai_humans/fenxiaoorder/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除分销订单
 * @param id
 * @returns
 */
export function deleteFenxiaoOrder(id: number) {
    return request.delete(`ai_humans/fenxiaoorder/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('ai_humans/member_all', {params})
}

// USER_CODE_END -- aihumans_fenxiao_order
