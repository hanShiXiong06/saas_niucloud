import request from '@/utils/request'

// USER_CODE_BEGIN -- blog_label
/**
 * 获取标签列表
 * @param params
 * @returns
 */
export function getLabelList(params: Record<string, any>) {
    return request.get(`blog/label`, {params})
}

/**
 * 获取标签详情
 * @param id 标签id
 * @returns
 */
export function getLabelInfo(id: number) {
    return request.get(`blog/label/${id}`);
}

/**
 * 添加标签
 * @param params
 * @returns
 */
export function addLabel(params: Record<string, any>) {
    return request.post('blog/label', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑标签
 * @param id
 * @param params
 * @returns
 */
export function editLabel(params: Record<string, any>) {
    return request.put(`blog/label/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除标签
 * @param id
 * @returns
 */
export function deleteLabel(id: number) {
    return request.delete(`blog/label/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- blog_label
