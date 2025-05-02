import request from '@/utils/request'

// USER_CODE_BEGIN -- aihumans_model
/**
 * 获取对话模型列表
 * @param params
 * @returns
 */
export function getChatModelList(params: Record<string, any>) {
    return request.get(`ai_humans/chatmodel`, {params})
}

/**
 * 获取对话模型详情
 * @param id 对话模型id
 * @returns
 */
export function getChatModelInfo(id: number) {
    return request.get(`ai_humans/chatmodel/${id}`);
}

/**
 * 添加对话模型
 * @param params
 * @returns
 */
export function addChatModel(params: Record<string, any>) {
    return request.post('ai_humans/chatmodel', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑对话模型
 * @param id
 * @param params
 * @returns
 */
export function editChatModel(params: Record<string, any>) {
    return request.put(`ai_humans/chatmodel/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除对话模型
 * @param id
 * @returns
 */
export function deleteChatModel(id: number) {
    return request.delete(`ai_humans/chatmodel/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- aihumans_model
