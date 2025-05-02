import request from '@/utils/request'

/**
 * 获取社区宝贝库分页列表
 * @param params
 * @returns
 */
export function getTreasureList(params: Record<string, any>) {
    return request.get(`sow_community/treasure`, { params })
}

/**
 * 获取社区宝贝库类型列表
 * @returns
 */
export function getTreasureType() {
    return request.get(`sow_community/treasure/type`)
}

/**
 * 修改宝贝是否参与种草
 * @param params
 * @returns
 */
export function treasureJoin(params: Record<string, any>) {
    return request.put(`sow_community/treasure/join`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 获取社区宝贝库选择宝贝列表
 * @param params
 * @returns
 */
export function getTreasureSelect(params: Record<string, any>) {
    return request.get(`sow_community/treasure/select`, { params })
}

/**
 *社区宝贝库已选宝贝列表
 * @param params
 * @returns
 */
export function getTreasureSelected(params: Record<string, any>) {
    return request.get(`sow_community/treasure/selected`, { params })
}
