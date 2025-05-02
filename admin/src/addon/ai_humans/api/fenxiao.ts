import request from '@/utils/request'

// USER_CODE_BEGIN -- aihumans_fenxiao
/**
 * 获取分销会员列表
 * @param params
 * @returns
 */
export function getFenxiaoList(params: Record<string, any>) {
    return request.get(`ai_humans/fenxiao`, {params})
}
export function getFenxiaoStatus() {
    return request.get(`ai_humans/getfenxiaostatus`)
}
/**
 * 获取分销会员详情
 * @param member_id 分销会员member_id
 * @returns
 */
export function getFenxiaoInfo(member_id: number) {
    return request.get(`ai_humans/fenxiao/${member_id}`);
}

/**
 * 添加分销会员
 * @param params
 * @returns
 */
export function addFenxiao(params: Record<string, any>) {
    return request.post('ai_humans/fenxiao', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑分销会员
 * @param member_id
 * @param params
 * @returns
 */
export function editFenxiao(params: Record<string, any>) {
    return request.put(`ai_humans/fenxiao/${params.member_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除分销会员
 * @param member_id
 * @returns
 */
export function deleteFenxiao(member_id: number) {
    return request.delete(`ai_humans/fenxiao/${member_id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('ai_humans/member_all', {params})
}

// USER_CODE_END -- aihumans_fenxiao
