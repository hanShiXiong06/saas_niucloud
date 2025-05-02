// USER_CODE_START -- rider
import request from '@/utils/request'

export function getRiderList(params: Record<string, any>) {
  return request.get('running/rider', { params })
}

// 获取用户是否为骑手
export function getRiderInfo() {
  return request.get('running/rider/info')
}

// 获取接单大厅
// 参数 是  学校的id
// 待接单的订单
export function getOrderList(params: Record<string, any>) {
  return request.get('running/rider/order', { params })
}

// 接单
export function acceptOrder(params: Record<string, any>) {
  return request.post('running/rider/accept', { params })
}

// 取消接单
export function cancelOrder(params: Record<string, any>) {
  return request.post('running/rider/cancel', { params })
}

// 获取订单详情
export function getOrderDetail(params: Record<string, any>) {
  return request.get('running/rider/order/detail', { params })
}

// USER_CODE_END -- rider
