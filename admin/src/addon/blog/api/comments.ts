import request from '@/utils/request'

// USER_CODE_BEGIN -- blog_comments
/**
 * 获取评价列表
 * @param params
 * @returns
 */
export function getCommentsList(params: Record<string, any>) {
    return request.get(`blog/comments`, {params})
}

/**
 * 获取评价详情
 * @param id 评价id
 * @returns
 */
export function getCommentsInfo(id: number) {
    return request.get(`blog/comments/${id}`);
}

/**
 * 添加评价
 * @param params
 * @returns
 */
export function addComments(params: Record<string, any>) {
    return request.post('blog/comments', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑评价
 * @param id
 * @param params
 * @returns
 */
export function editComments(params: Record<string, any>) {
    return request.put(`blog/comments/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除评价
 * @param id
 * @returns
 */
export function deleteComments(id: number) {
    return request.delete(`blog/comments/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function batchdel(params: Record<string, any>) {
    return request.post(`blog/comments/batchdel`, params, { showErrorMessage: true, showSuccessMessage: true })
}

// USER_CODE_END -- blog_comments
