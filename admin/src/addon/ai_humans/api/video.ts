import request from '@/utils/request'
export function asyncVideo(id) {
    return request.post(`ai_humans/asyncvideo/${id}`,  { showErrorMessage: true, showSuccessMessage: true })
}
// USER_CODE_BEGIN -- aihumans_video
/**
 * 获取视频生成列列表
 * @param params
 * @returns
 */
export function getVideoList(params: Record<string, any>) {
    return request.get(`ai_humans/video`, {params})
}

/**
 * 获取视频生成列详情
 * @param id 视频生成列id
 * @returns
 */
export function getVideoInfo(id: number) {
    return request.get(`ai_humans/video/${id}`);
}

/**
 * 添加视频生成列
 * @param params
 * @returns
 */
export function addVideo(params: Record<string, any>) {
    return request.post('ai_humans/video', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑视频生成列
 * @param id
 * @param params
 * @returns
 */
export function editVideo(params: Record<string, any>) {
    return request.put(`ai_humans/video/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除视频生成列
 * @param id
 * @returns
 */
export function deleteVideo(id: number) {
    return request.delete(`ai_humans/video/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('ai_humans/member_all', {params})
}

// USER_CODE_END -- aihumans_video
