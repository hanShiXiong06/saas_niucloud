
import request from '@/utils/request'

/***************************************************** 视频接口 ****************************************************/

export function cloneVideo(params) {
    return request.post('ai_humans/videoclone', params)
}
export function createVideo(params) {
    return request.post('ai_humans/video', params)
}
export function getCreateVideoList(params) {
    return request.get('ai_humans/video', params)
}
export function getVideoStatus() {
    return request.get('ai_humans/video/status')
}

export function getCloneVideoList(params) {
    return request.get('ai_humans/videoclone', params)
}
export function deleteCreateVideo(id) {
    return request.delete(`ai_humans/video/${id}`)
}

/**
 * 删除克隆数据
 * @param id 
 * @returns 
 */
export function deleteCloneVideo(id) {
    return request.delete(`ai_humans/videoclone/${id}`)
}
