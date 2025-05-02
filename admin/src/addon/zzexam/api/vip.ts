import request from '@/utils/request'

// USER_CODE_BEGIN -- zzexam_vip
/**
 * 获取VIP套餐列表
 * @param params
 * @returns
 */
export function getVipList(params: Record<string, any>) {
    return request.get(`zzexam/vip`, {params})
}

/**
 * 获取VIP套餐详情
 * @param vip_id VIP套餐vip_id
 * @returns
 */
export function getVipInfo(vip_id: number) {
    return request.get(`zzexam/vip/${vip_id}`);
}

/**
 * 添加VIP套餐
 * @param params
 * @returns
 */
export function addVip(params: Record<string, any>) {
    return request.post('zzexam/vip', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑VIP套餐
 * @param vip_id
 * @param params
 * @returns
 */
export function editVip(params: Record<string, any>) {
    return request.put(`zzexam/vip/${params.vip_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除VIP套餐
 * @param vip_id
 * @returns
 */
export function deleteVip(vip_id: number) {
    return request.delete(`zzexam/vip/${vip_id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_vip


// USER_CODE_BEGIN -- zzexam_vip_log
/**
 * 获取VIP会员日志列表
 * @param params
 * @returns
 */
export function getLogList(params: Record<string, any>) {
    return request.get(`zzexam/vip/log`, {params})
}

/**
 * 获取VIP会员日志详情
 * @param id VIP会员日志id
 * @returns
 */
export function getLogInfo(id: number) {
    return request.get(`zzexam/vip/log/${id}`);
}

/**
 * 添加VIP会员日志
 * @param params
 * @returns
 */
export function addLog(params: Record<string, any>) {
    return request.post('zzexam/vip/log', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑VIP会员日志
 * @param id
 * @param params
 * @returns
 */
export function editLog(params: Record<string, any>) {
    return request.put(`zzexam/vip/log/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除VIP会员日志
 * @param id
 * @returns
 */
export function deleteLog(id: number) {
    return request.delete(`zzexam/vip/log/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_vip_log


// USER_CODE_BEGIN -- zzexam_vip_member
/**
 * 获取VIP会员列表
 * @param params
 * @returns
 */
export function getMemberList(params: Record<string, any>) {
    return request.get(`zzexam/vip/member`, {params})
}

/**
 * 获取VIP会员详情
 * @param id VIP会员id
 * @returns
 */
export function getMemberInfo(id: number) {
    return request.get(`zzexam/vip/member/${id}`);
}

/**
 * 添加VIP会员
 * @param params
 * @returns
 */
export function addMember(params: Record<string, any>) {
    return request.post('zzexam/vip/member', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑VIP会员
 * @param id
 * @param params
 * @returns
 */
export function editMember(params: Record<string, any>) {
    return request.put(`zzexam/vip/member/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除VIP会员
 * @param id
 * @returns
 */
export function deleteMember(id: number) {
    return request.delete(`zzexam/vip/member/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_vip_member


// USER_CODE_BEGIN -- zzexam_vip_order
/**
 * 获取VIP订单列表
 * @param params
 * @returns
 */
export function getOrderList(params: Record<string, any>) {
    return request.get(`zzexam/vip/order`, {params})
}

/**
 * 获取VIP订单详情
 * @param order_id VIP订单order_id
 * @returns
 */
export function getOrderInfo(order_id: number) {
    return request.get(`zzexam/vip/order/${order_id}`);
}

/**
 * 添加VIP订单
 * @param params
 * @returns
 */
export function addOrder(params: Record<string, any>) {
    return request.post('zzexam/vip/order', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑VIP订单
 * @param order_id
 * @param params
 * @returns
 */
export function editOrder(params: Record<string, any>) {
    return request.put(`zzexam/vip/order/${params.order_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除VIP订单
 * @param order_id
 * @returns
 */
export function deleteOrder(order_id: number) {
    return request.delete(`zzexam/vip/order/${order_id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_vip_order

/**
 * 获取VIP配置
 * @returns
 */
export function getVipConfig() {
    return request.get('zzexam/vip/config')
}

/**
 * 编辑VIP配置
 * @returns
 */
export function setVipConfig(param: any) {
    return request.post('zzexam/vip/config', param, {showSuccessMessage: true})
}
