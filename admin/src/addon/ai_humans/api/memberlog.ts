import request from '@/utils/request'

// USER_CODE_BEGIN -- aihumans_member_log
/**
 * 获取会员日志列表
 * @param params
 * @returns
 */
export function getMemberLogList(params: Record<string, any>) {
    return request.get(`ai_humans/memberlog`, {params})
}

/**
 * 获取会员日志详情
 * @param id 会员日志id
 * @returns
 */
export function getMemberLogInfo(id: number) {
    return request.get(`ai_humans/memberlog/${id}`);
}

/**
 * 添加会员日志
 * @param params
 * @returns
 */
export function addMemberLog(params: Record<string, any>) {
    return request.post('ai_humans/memberlog', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑会员日志
 * @param id
 * @param params
 * @returns
 */
export function editMemberLog(params: Record<string, any>) {
    return request.put(`ai_humans/memberlog/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除会员日志
 * @param id
 * @returns
 */
export function deleteMemberLog(id: number) {
    return request.delete(`ai_humans/memberlog/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('ai_humans/member_all', {params})
}

// USER_CODE_END -- aihumans_member_log
