import request from "@/utils/request";

// 获取用户订单列表
export const getOrderList = (params: any) => {
  return request.get("running/orders", params);
};

// 获取订单详情
export const getOrderInfo = (params: any) => {
  return request.get(`running/orders/${params.id}`);
};

// 取消订单
export const cancelOrder = (params: any) => {
  return request.put(`running/orders/${params.id}/cancel`, { params });
};

// 删除订单
export const deleteOrder = (params: any) => {
  return request.delete(`running/orders/${params.id}`);
};

// 创建订单
export function createOrder(params: any) {
  return request.post("/running/orders", params);
}

// 确认收货
export const confirmOrder = (params: any) => {
  return request.put(`running/orders/${params.id}/confirm`);
};

// 获取订单统计信息
export function getOrderStatistics() {
  return request.get("running/order/statistics");
}
