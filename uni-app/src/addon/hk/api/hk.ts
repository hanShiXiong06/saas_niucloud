
import request from '@/utils/request'

/***************************************************** 号卡分销平台API接口 ****************************************************/
/**
 * 获取运营商列表
 * @return 
 */
export function getOperator() {
	return request.get(`hk/product/operator`)
}
/**
 * 获取产品列表
 * @param {Record<string, any>} params 
 * @return 
 */
export function getProductList(params) {
	return request.get(`hk/product/list`, params)
}
/**
 * 获取产品信息
 * @param {any} id 
 * @return 
 */
export function getProductInfo(id) {
	return request.get(`hk/product/info/${id}`)
}
/**
 * 获取产品信息
 * @param {any} id 
 * @return 
 */
export function getPhoneList(param) {
	return request.get(`hk/product/getphonelist`, param)
}
/**
 * 新增订单
 * @param {any} params 
 * @return 
 */
export function addOrder(params) {
	return request.post(`hk/order/add`, params)
}
/**
 * 获取订单列表
 * @param {any} params 
 * @return 
 */
export function getOrderLists(params) {
	return request.get(`hk/order/lists`, params)
}
/**
 * 获取订单信息
 * @param {any} id 
 * @return 
 */
export function getOrderInfo(id) {
	return request.get(`hk/order/${id}`)
}
/**
 * 查询物流轨迹
 * @param {number} id 
 * @return 
 */
export function queryExpress(id : number) {
	return request.get(`hk/order/queryexpress/${id}`);
}
/**
 * 获取订单状态
 * @return 
 */
export function getOrderStatus() {
	return request.get(`hk/order/orderstatus`)
}
/**
 * 帮助中心
 */
export function help(data : AnyObject) {
	return request.get('hk/help', data)
}
export function getConfig() {
	return request.get('hk/config/getconfig')
}