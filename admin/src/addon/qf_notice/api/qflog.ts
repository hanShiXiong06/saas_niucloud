import request from '@/utils/request'

export function delselect(params: Record<string, any>) {
    return request.post(`qf_notice/delqflogselect`, params, { showErrorMessage: true, showSuccessMessage: true })
}
// USER_CODE_BEGIN -- qfnotice_log
/**
 * 获取发送日志列表
 * @param params
 * @returns
 */
export function getQflogList(params: Record<string, any>) {
    return request.get(`qf_notice/qflog`, { params })
}

/**
 * 获取发送日志详情
 * @param id 发送日志id
 * @returns
 */
export function getQflogInfo(id: number) {
    return request.get(`qf_notice/qflog/${id}`);
}

/**
 * 添加发送日志
 * @param params
 * @returns
 */
export function addQflog(params: Record<string, any>) {
    return request.post('qf_notice/qflog', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑发送日志
 * @param id
 * @param params
 * @returns
 */
export function editQflog(params: Record<string, any>) {
    return request.put(`qf_notice/qflog/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除发送日志
 * @param id
 * @returns
 */
export function deleteQflog(id: number) {
    return request.delete(`qf_notice/qflog/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- qfnotice_log
