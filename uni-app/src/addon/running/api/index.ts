import request from "@/utils/request";

// 接口返回数据类型
interface ApiResponse<T> {
  code: number;
  message: string;
  data: T;
}

// 学校类型
export interface School {
  id: number;
  name: string;
  [key: string]: any;
}

// 服务类型
export interface Service {
  id: number;
  name: string;
  price: number;
  image: string;
  type: number; // 1: 快递代取 2: 跑腿服务
  [key: string]: any;
}

// 服务分类类型
export interface ServiceCategory {
  id: number;
  name: string;
  desc: string;
  service_list: Service[];
}

// 快递站点类型
export interface ExpressStation {
  id: number;
  name: string;
  address: string;
  site_id: number;
  school_id: number;
  status: number;
  create_time: string;
  update_time: string;
}

// 楼栋类型
export interface Building {
  id: number;
  name: string;
  site_id: number;
  school_id: number;
  status: number;
  create_time: string;
  update_time: string;
}

// 快递信息类型
export interface ExpressInfo {
  express_site: ExpressStation[];
  building: Building[];
}

// 订单类型
export interface Order {
  id: number;
  order_no: string;
  order_status: number;
  order_status_text: string;
}

// API方法
export const getSchoolList = () => {
  return request.get("/running/schools") as Promise<ApiResponse<School[]>>;
};

export const getProductList = (params: any) => {
  return request.get("/running/products", params) as Promise<
    ApiResponse<ServiceCategory[]>
  >;
};

/**
 * 获取学校相关的快递站点和配送楼栋信息
 */
export function getSchoolExpressInfo(
  params: any
): Promise<ApiResponse<ExpressInfo>> {
  return request.get("/running/express", params) as Promise<
    ApiResponse<ExpressInfo>
  >;
}

// 获取帮助中心列表
export function getHelpList(params: any): Promise<ApiResponse<Help[]>> {
  return request.get("/running/helps", params) as Promise<ApiResponse<Help[]>>;
}

// __________________________
/**
 * 创建订单
 */
export function createOrder(params: any): Promise<ApiResponse<Order>> {
  return request.post("/running/orders", params) as Promise<ApiResponse<Order>>;
}

/**
 * 获取订单列表
 */
// export function getOrderList(params: {
//   school_id: number;
//   status: number;
// }): Promise<ApiResponse<Order[]>> {
//   return request.get("/running/orders", params) as Promise<
//     ApiResponse<Order[]>
//   >;
// }

/**
 * 获取订单详情
 */
// export function getOrderDetail(params: {
//   id: number;
// }): Promise<ApiResponse<Order>> {
//   return request.get(`/running/orders/${params.id}`) as Promise<
//     ApiResponse<Order>
//   >;
// }

/*
 * 取消订单
 * put /running/orders/:id/cancel
 */
// export function cancelOrder(params: {
//   id: number;
// }): Promise<ApiResponse<Order>> {
//   return request.put(`/running/orders/${params.id}/cancel`) as Promise<
//     ApiResponse<Order>
//   >;
// }

/*
 * 删除订单
 * delete /running/orders/:id
 */
// export function deleteOrder(params: {
//   id: number;
// }): Promise<ApiResponse<Order>> {
//   return request.delete(`/running/orders/${params.id}`) as Promise<
//     ApiResponse<Order>
//   >;
// }
