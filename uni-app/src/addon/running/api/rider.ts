// USER_CODE_START -- rider
import request from "@/utils/request";

/**
 * 获取骑手信息
 */
export function getRiderInfo() {
  return request.get("running/rider/info");
}
/*
 * 提交骑手申请
 */
export function submitRiderApply(params: Record<string, any>) {
  return request.post("running/rider/apply", params);
}

/**
 * 获取待接单列表
 * @param params
 */
export function getHallList(params: Record<string, any>) {
  return request.get("running/rider/orders/hall", params);
}

/**
 * 获取骑手相关的订单列表
 * @param params
 */
export function getOrderList(params: Record<string, any>) {
  return request.get("running/rider/orders", params);
}

/**
 * 获取订单详情
 * @param params
 */
export function getOrderDetail(params: Record<string, any>) {
  return request.get(`running/rider/orders/${params.id}`);
}

/**
 * 接单
 * @param params
 */
export function acceptOrder(params: Record<string, any>) {
  return request.put(`running/rider/orders/${params.id}/accept`);
}

/**
 * 取消接单
 * @param params
 */
export function cancelOrder(params: Record<string, any>) {
  return request.put(`running/rider/orders/${params.id}/cancel`);
}

/**
 * 开始配送
 * @param params
 */
export function startDelivery(params: Record<string, any>) {
  return request.put(`running/rider/orders/${params.id}/deliver`);
}

/**
 * 完成订单
 * @param params
 */
export function completeOrder(params: Record<string, any>) {
  return request.put(`running/rider/orders/${params.id}/complete`);
}

// USER_CODE_END -- rider
