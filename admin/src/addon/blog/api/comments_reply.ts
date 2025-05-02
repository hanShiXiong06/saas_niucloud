import request from '@/utils/request'



// USER_CODE_BEGIN -- blog_comments_reply
/**
 * 获取列表
 * @param params
 * @returns
 */
export function getCommentsReplyList(params: Record<string, any>) {
    return request.get(`blog/comments_reply`, {params})
}

/**
 * 获取详情
 * @param id id
 * @returns
 */
export function getCommentsReplyInfo(id: number) {
    return request.get(`blog/comments_reply/${id}`);
}

/**
 * 添加
 * @param params
 * @returns
 */
export function addCommentsReply(params: Record<string, any>) {
    return request.post('blog/comments_reply', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑
 * @param id
 * @param params
 * @returns
 */
export function editCommentsReply(params: Record<string, any>) {
    return request.put(`blog/comments_reply/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除
 * @param id
 * @returns
 */
export function deleteCommentsReply(id: number) {
    return request.delete(`blog/comments_reply/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}




// USER_CODE_END -- blog_comments_reply
