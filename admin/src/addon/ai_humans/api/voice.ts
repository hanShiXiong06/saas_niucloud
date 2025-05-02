import request from '@/utils/request'

// USER_CODE_BEGIN -- aihumans_voice
/**
 * 获取声音合成列列表
 * @param params
 * @returns
 */
export function getVoiceList(params: Record<string, any>) {
    return request.get(`ai_humans/voice`, {params})
}

/**
 * 获取声音合成列详情
 * @param id 声音合成列id
 * @returns
 */
export function getVoiceInfo(id: number) {
    return request.get(`ai_humans/voice/${id}`);
}

/**
 * 添加声音合成列
 * @param params
 * @returns
 */
export function addVoice(params: Record<string, any>) {
    return request.post('ai_humans/voice', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑声音合成列
 * @param id
 * @param params
 * @returns
 */
export function editVoice(params: Record<string, any>) {
    return request.put(`ai_humans/voice/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除声音合成列
 * @param id
 * @returns
 */
export function deleteVoice(id: number) {
    return request.delete(`ai_humans/voice/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('ai_humans/member_all', {params})
}

// USER_CODE_END -- aihumans_voice
