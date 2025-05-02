import request from '@/utils/request'

// USER_CODE_BEGIN -- tkpartner_level
/**
 * 获取店主级别列列表
 * @param params
 * @returns
 */
export function getLevelList(params: Record<string, any>) {
    return request.get(`tk_partner/level`, {params})
}

/**
 * 获取店主级别列详情
 * @param id 店主级别列id
 * @returns
 */
export function getLevelInfo(id: number) {
    return request.get(`tk_partner/level/${id}`);
}

/**
 * 添加店主级别列
 * @param params
 * @returns
 */
export function addLevel(params: Record<string, any>) {
    return request.post('tk_partner/level', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑店主级别列
 * @param id
 * @param params
 * @returns
 */
export function editLevel(params: Record<string, any>) {
    return request.put(`tk_partner/level/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除店主级别列
 * @param id
 * @returns
 */
export function deleteLevel(id: number) {
    return request.delete(`tk_partner/level/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- tkpartner_level
