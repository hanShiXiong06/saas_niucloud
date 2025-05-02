import request from '@/utils/request'

// USER_CODE_BEGIN -- running_rider
/**
 * 获取跑腿员列表
 * @param params
 * @returns
 */
export function getRunningRiderList(params: Record<string, any>) {
  return request.get(`running/running_rider`, { params })
}

/**
 * 获取跑腿员详情
 * @param id 跑腿员id
 * @returns
 */
export function getRunningRiderInfo(id: number) {
  return request.get(`running/running_rider/${id}`)
}

/**
 * 添加跑腿员
 * @param params
 * @returns
 */
export function addRunningRider(params: Record<string, any>) {
  return request.post('running/running_rider', params, {
    showErrorMessage: true,
    showSuccessMessage: true
  })
}

/**
 * 编辑跑腿员
 * @param id
 * @param params
 * @returns
 */
export function editRunningRider(params: Record<string, any>) {
  return request.put(`running/running_rider/${params.id}`, params, {
    showErrorMessage: true,
    showSuccessMessage: true
  })
}

/**
 * 删除跑腿员
 * @param id
 * @returns
 */
export function deleteRunningRider(id: number) {
  return request.delete(`running/running_rider/${id}`, {
    showErrorMessage: true,
    showSuccessMessage: true
  })
}

export function getWithRunningSchoolList(params: Record<string, any>) {
  return request.get('running/running_school_all', { params })
}
export function getWithMemberList(params: Record<string, any>) {
  return request.get('running/member_all', { params })
}

// USER_CODE_END -- running_rider
