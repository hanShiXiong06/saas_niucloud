import request from '@/utils/request'

// USER_CODE_BEGIN -- aihumans_video_clone
/**
 * 获取视频克隆列列表
 * @param params
 * @returns
 */
export function getVideoCloneList(params: Record<string, any>) {
    return request.get(`ai_humans/videoclone`, {params})
}

/**
 * 获取视频克隆列详情
 * @param id 视频克隆列id
 * @returns
 */
export function getVideoCloneInfo(id: number) {
    return request.get(`ai_humans/videoclone/${id}`);
}

/**
 * 添加视频克隆列
 * @param params
 * @returns
 */
export function addVideoClone(params: Record<string, any>) {
    return request.post('ai_humans/videoclone', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑视频克隆列
 * @param id
 * @param params
 * @returns
 */
export function editVideoClone(params: Record<string, any>) {
    return request.put(`ai_humans/videoclone/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除视频克隆列
 * @param id
 * @returns
 */
export function deleteVideoClone(id: number) {
    return request.delete(`ai_humans/videoclone/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('ai_humans/member_all', {params})
}

// USER_CODE_END -- aihumans_video_clone
