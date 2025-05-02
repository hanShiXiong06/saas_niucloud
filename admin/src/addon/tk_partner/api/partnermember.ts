import request from '@/utils/request'

// USER_CODE_BEGIN -- tkpartner_member
/**
 * 获取会员列列表
 * @param params
 * @returns
 */
export function getPartnerMemberList(params: Record<string, any>) {
    return request.get(`tk_partner/partnermember`, {params})
}

/**
 * 获取会员列详情
 * @param id 会员列id
 * @returns
 */
export function getPartnerMemberInfo(id: number) {
    return request.get(`tk_partner/partnermember/${id}`);
}

/**
 * 添加会员列
 * @param params
 * @returns
 */
export function addPartnerMember(params: Record<string, any>) {
    return request.post('tk_partner/partnermember', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑会员列
 * @param id
 * @param params
 * @returns
 */
export function editPartnerMember(params: Record<string, any>) {
    return request.put(`tk_partner/partnermember/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除会员列
 * @param id
 * @returns
 */
export function deletePartnerMember(id: number) {
    return request.delete(`tk_partner/partnermember/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('tk_partner/member_all', {params})
}

// USER_CODE_END -- tkpartner_member
