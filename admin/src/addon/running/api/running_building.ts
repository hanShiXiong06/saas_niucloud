import request from '@/utils/request'

// USER_CODE_BEGIN -- running_building
/**
 * 获取收货楼栋列表
 * @param params
 * @returns
 */
export function getRunningBuildingList(params: Record<string, any>) {
  return request.get(`running/running_building`, { params })
}

/**
 * 获取收货楼栋详情
 * @param id 收货楼栋id
 * @returns
 */
export function getRunningBuildingInfo(id: number) {
  return request.get(`running/running_building/${id}`)
}

/**
 * 添加收货楼栋
 * @param params
 * @returns
 */
export function addRunningBuilding(params: Record<string, any>) {
  return request.post('running/running_building', params, {
    showErrorMessage: true,
    showSuccessMessage: true
  })
}

/**
 * 编辑收货楼栋
 * @param id
 * @param params
 * @returns
 */
export function editRunningBuilding(params: Record<string, any>) {
  return request.put(`running/running_building/${params.id}`, params, {
    showErrorMessage: true,
    showSuccessMessage: true
  })
}

/**
 * 删除收货楼栋
 * @param id
 * @returns
 */
export function deleteRunningBuilding(id: number) {
  return request.delete(`running/running_building/${id}`, {
    showErrorMessage: true,
    showSuccessMessage: true
  })
}

export function getWithRunningSchoolList(params: Record<string, any>) {
  return request.get('running/running_school_all', { params })
}

// USER_CODE_END -- running_building
