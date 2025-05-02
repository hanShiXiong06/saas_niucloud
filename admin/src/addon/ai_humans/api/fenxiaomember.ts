import request from '@/utils/request'

// USER_CODE_BEGIN -- aihumans_fenxiao_member
/**
 * 获取分销会员列列表
 * @param params
 * @returns
 */
export function getFenxiaoMemberList(params: Record<string, any>) {
    return request.get(`ai_humans/fenxiaomember`, {params})
}

/**
 * 获取分销会员列详情
 * @param member_id 分销会员列member_id
 * @returns
 */
export function getFenxiaoMemberInfo(member_id: number) {
    return request.get(`ai_humans/fenxiaomember/${member_id}`);
}

/**
 * 添加分销会员列
 * @param params
 * @returns
 */
export function addFenxiaoMember(params: Record<string, any>) {
    return request.post('ai_humans/fenxiaomember', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑分销会员列
 * @param member_id
 * @param params
 * @returns
 */
export function editFenxiaoMember(params: Record<string, any>) {
    return request.put(`ai_humans/fenxiaomember/${params.member_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除分销会员列
 * @param member_id
 * @returns
 */
export function deleteFenxiaoMember(member_id: number) {
    return request.delete(`ai_humans/fenxiaomember/${member_id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('ai_humans/member_all', {params})
}

// USER_CODE_END -- aihumans_fenxiao_member
