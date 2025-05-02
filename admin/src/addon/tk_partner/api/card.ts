import request from '@/utils/request'

// USER_CODE_BEGIN -- tkpartner_card
/**
 * 获取店主列列表
 * @param params
 * @returns
 */
export function getCardList(params: Record<string, any>) {
    return request.get(`tk_partner/card`, {params})
}

/**
 * 获取店主列详情
 * @param id 店主列id
 * @returns
 */
export function getCardInfo(id: number) {
    return request.get(`tk_partner/card/${id}`);
}

/**
 * 添加店主列
 * @param params
 * @returns
 */
export function addCard(params: Record<string, any>) {
    return request.post('tk_partner/card', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑店主列
 * @param id
 * @param params
 * @returns
 */
export function editCard(params: Record<string, any>) {
    return request.put(`tk_partner/card/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除店主列
 * @param id
 * @returns
 */
export function deleteCard(id: number) {
    return request.delete(`tk_partner/card/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithLevelList(params: Record<string,any>){
    return request.get('tk_partner/level_all', {params})
}

// USER_CODE_END -- tkpartner_card
export function delselect(params: Record<string, any>) {
    return request.post(`tk_partner/delcardselect`, params, { showErrorMessage: true, showSuccessMessage: true })
}