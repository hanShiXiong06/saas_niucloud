import request from '@/utils/request'

// USER_CODE_BEGIN -- running_order_log
/**
 * 获取订单日志列表
 * @param params
 * @returns
 */
export function getRunningOrderLogList(params: Record<string, any>) {
    return request.get(`running/running_order_log`, {params})
}

/**
 * 获取订单日志详情
 * @param id 订单日志id
 * @returns
 */
export function getRunningOrderLogInfo(id: number) {
    return request.get(`running/running_order_log/${id}`);
}

/**
 * 添加订单日志
 * @param params
 * @returns
 */
export function addRunningOrderLog(params: Record<string, any>) {
    return request.post('running/running_order_log', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑订单日志
 * @param id
 * @param params
 * @returns
 */
export function editRunningOrderLog(params: Record<string, any>) {
    return request.put(`running/running_order_log/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除订单日志
 * @param id
 * @returns
 */
export function deleteRunningOrderLog(id: number) {
    return request.delete(`running/running_order_log/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('running/member_all', {params})
}

// USER_CODE_END -- running_order_log
