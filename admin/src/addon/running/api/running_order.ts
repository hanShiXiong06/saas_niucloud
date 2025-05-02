import request from '@/utils/request'

// USER_CODE_BEGIN -- running_order
/**
 * 获取订单列表
 * @param params
 * @returns
 */
export function getRunningOrderList(params: Record<string, any>) {
  return request.get(`running/running_order`, { params })
}

/**
 * 获取订单详情
 * @param id 订单id
 * @returns
 */
export function getRunningOrderInfo(id: number) {
  return request.get(`running/running_order/${id}`)
}

/**
 * 添加订单
 * @param params
 * @returns
 */
export function addRunningOrder(params: Record<string, any>) {
  return request.post('running/running_order', params, {
    showErrorMessage: true,
    showSuccessMessage: true
  })
}

/**
 * 编辑订单
 * @param id
 * @param params
 * @returns
 */
export function editRunningOrder(params: Record<string, any>) {
  return request.put(`running/running_order/${params.id}`, params, {
    showErrorMessage: true,
    showSuccessMessage: true
  })
}

/**
 * 删除订单
 * @param id
 * @returns
 */
export function deleteRunningOrder(id: number) {
  return request.delete(`running/running_order/${id}`, {
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
export function getWithRiderList(params: Record<string, any>) {
  return request.get('running/running_rider', { params })
}

// USER_CODE_END -- running_order
