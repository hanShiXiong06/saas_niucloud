import request from '@/utils/request'

// USER_CODE_BEGIN -- aihumans_member
/**
 * 获取会员列列表
 * @param params
 * @returns
 */
export function getAihumansMemberList(params: Record<string, any>) {
    return request.get(`ai_humans/aihumansmember`, {params})
}

/**
 * 获取会员列详情
 * @param id 会员列id
 * @returns
 */
export function getAihumansMemberInfo(id: number) {
    return request.get(`ai_humans/aihumansmember/${id}`);
}

/**
 * 添加会员列
 * @param params
 * @returns
 */
export function addAihumansMember(params: Record<string, any>) {
    return request.post('ai_humans/aihumansmember', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑会员列
 * @param id
 * @param params
 * @returns
 */
export function editAihumansMember(params: Record<string, any>) {
    return request.put(`ai_humans/aihumansmember/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除会员列
 * @param id
 * @returns
 */
export function deleteAihumansMember(id: number) {
    return request.delete(`ai_humans/aihumansmember/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('ai_humans/member_all', {params})
}

// USER_CODE_END -- aihumans_member
