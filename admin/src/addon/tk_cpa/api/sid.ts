import request from '@/utils/request'
export function getSidStatus() {
    return request.get(`tk_cpa/sid/status`);
}
// USER_CODE_BEGIN -- cpa_sid
/**
 * 获取CPA开码列列表
 * @param params
 * @returns
 */
export function getSidList(params: Record<string, any>) {
    return request.get(`tk_cpa/sid`, { params })
}

/**
 * 获取CPA开码列详情
 * @param id CPA开码列id
 * @returns
 */
export function getSidInfo(id: number) {
    return request.get(`tk_cpa/sid/${id}`);
}

/**
 * 添加CPA开码列
 * @param params
 * @returns
 */
export function addSid(params: Record<string, any>) {
    return request.post('tk_cpa/sid', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑CPA开码列
 * @param id
 * @param params
 * @returns
 */
export function editSid(params: Record<string, any>) {
    return request.put(`tk_cpa/sid/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除CPA开码列
 * @param id
 * @returns
 */
export function deleteSid(id: number) {
    return request.delete(`tk_cpa/sid/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string, any>) {
    return request.get('tk_cpa/member_all', { params })
} export function getWithActList(params: Record<string, any>) {
    return request.get('tk_cpa/act_all', { params })
}

// USER_CODE_END -- cpa_sid
