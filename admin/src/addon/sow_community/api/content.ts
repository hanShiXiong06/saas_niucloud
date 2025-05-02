import request from '@/utils/request'

/**
 * 获取内容分页列表
 * @param params
 * @returns
 */
export function getContentList(params: Record<string, any>) {
    return request.get(`sow_community/content`, { params })
}

/**
 * 获取内容状态
 * @returns
 */
export function getContentStatus() {
    return request.get(`sow_community/content/status`)
}

/**
 * 获取内容详情
 * @param content_id 社区分类content_id
 * @returns
 */
export function getContentInfo(content_id: number) {
    return request.get(`sow_community/content/${ content_id }`);
}

/**
 * 添加内容
 * @param params
 * @returns
 */
export function addContent(params: Record<string, any>) {
    return request.post('sow_community/content', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑内容
 * @param params
 * @returns
 */
export function editContent(params: Record<string, any>) {
    return request.put(`sow_community/content/${ params.content_id }`, params, {
        showErrorMessage: true,
        showSuccessMessage: true
    })
}

/**
 * 删除社区
 * @param params
 */
export function deleteContent(params: Record<string, any>) {
    return request.put(`sow_community/content/delete`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 强制下架
 * @param params
 */
export function offContent(params: Record<string, any>) {
    return request.put(`sow_community/content/off`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 审核内容
 * @param params
 * @returns
 */
export function auditContent(params: Record<string, any>) {
    return request.put(`sow_community/content/audit/${ params.content_id }`, params, {
        showErrorMessage: true,
        showSuccessMessage: true
    })
}
