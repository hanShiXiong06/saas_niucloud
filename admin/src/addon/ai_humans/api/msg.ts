import request from '@/utils/request'

// USER_CODE_BEGIN -- aihumans_msg
/**
 * 获取对话记录列表
 * @param params
 * @returns
 */
export function getMsgList(params: Record<string, any>) {
    return request.get(`ai_humans/msg`, {params})
}

/**
 * 获取对话记录详情
 * @param id 对话记录id
 * @returns
 */
export function getMsgInfo(id: number) {
    return request.get(`ai_humans/msg/${id}`);
}

/**
 * 添加对话记录
 * @param params
 * @returns
 */
export function addMsg(params: Record<string, any>) {
    return request.post('ai_humans/msg', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑对话记录
 * @param id
 * @param params
 * @returns
 */
export function editMsg(params: Record<string, any>) {
    return request.put(`ai_humans/msg/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除对话记录
 * @param id
 * @returns
 */
export function deleteMsg(id: number) {
    return request.delete(`ai_humans/msg/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('ai_humans/member_all', {params})
}

// USER_CODE_END -- aihumans_msg
