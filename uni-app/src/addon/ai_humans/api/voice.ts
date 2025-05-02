
import request from '@/utils/request'

/***************************************************** 声音接口 ****************************************************/

/**
 * 克隆声音
 * @param params 
 * @returns 
 */
export function cloneVoice(params) {
    return request.post('ai_humans/voiceclone', params)
}

/**
 * 获取克隆列表
 * @param params 
 * @returns 
 */
export function getCloneVoiceList(params) {
    return request.get('ai_humans/voiceclone', params)
}
export function getVoiceList(params) {
    return request.get('ai_humans/voice', params)
}
export function getText() {
    return request.get('ai_humans/gettext')
}

/**
 * 删除克隆数据
 * @param id 
 * @returns 
 */
export function deleteCloneVoice(id) {
    return request.delete(`ai_humans/voiceclone/${id}`)
}
export function deleteVoice(id) {
    return request.delete(`ai_humans/voice/${id}`)
}