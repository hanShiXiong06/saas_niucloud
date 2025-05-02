import request from '@/utils/request'

// USER_CODE_BEGIN -- aihumans_voice_clone
/**
 * 获取声音克隆列表
 * @param params
 * @returns
 */
export function getVoiceCloneList(params: Record<string, any>) {
    return request.get(`ai_humans/voiceclone`, {params})
}

/**
 * 获取声音克隆详情
 * @param id 声音克隆id
 * @returns
 */
export function getVoiceCloneInfo(id: number) {
    return request.get(`ai_humans/voiceclone/${id}`);
}

/**
 * 添加声音克隆
 * @param params
 * @returns
 */
export function addVoiceClone(params: Record<string, any>) {
    return request.post('ai_humans/voiceclone', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑声音克隆
 * @param id
 * @param params
 * @returns
 */
export function editVoiceClone(params: Record<string, any>) {
    return request.put(`ai_humans/voiceclone/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除声音克隆
 * @param id
 * @returns
 */
export function deleteVoiceClone(id: number) {
    return request.delete(`ai_humans/voiceclone/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('ai_humans/member_all', {params})
}

// USER_CODE_END -- aihumans_voice_clone
