import request from '@/utils/request'

// USER_CODE_BEGIN -- aihumans_card
/**
 * 获取卡密管理列表
 * @param params
 * @returns
 */
export function getCardList(params: Record<string, any>) {
    return request.get(`ai_humans/card`, {params})
}

/**
 * 获取卡密管理详情
 * @param id 卡密管理id
 * @returns
 */
export function getCardInfo(id: number) {
    return request.get(`ai_humans/card/${id}`);
}

/**
 * 添加卡密管理
 * @param params
 * @returns
 */
export function addCard(params: Record<string, any>) {
    return request.post('ai_humans/card', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑卡密管理
 * @param id
 * @param params
 * @returns
 */
export function editCard(params: Record<string, any>) {
    return request.put(`ai_humans/card/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除卡密管理
 * @param id
 * @returns
 */
export function deleteCard(id: number) {
    return request.delete(`ai_humans/card/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- aihumans_card
