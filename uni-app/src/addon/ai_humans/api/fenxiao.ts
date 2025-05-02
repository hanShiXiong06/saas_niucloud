
import request from '@/utils/request'

/***************************************************** 接口 ****************************************************/
/**
 * 获取分销配置
 * @param params 
 * @returns 
 */
export function getFenxiaoConfig(params) {
    return request.get('ai_humans/getFenxiaoconfig', params)
}
/**
 * 检查分销
 * @returns 
 */
export function checkIsFenxiao() {
    return request.get('ai_humans/checkisfenxiao')
}
export function createFenxiaoOrder() {
    return request.post('ai_humans/createfenxiaoorder')
}

export function getFenxiaoInfo() {
    return request.get(`ai_humans/fenxiao/getfenxiaofnfo`)
}

/**
 * 获取分销会员
 * @param {any} params 
 * @return 
 */
export function getFenxiaoMember(params) {
    return request.get(`ai_humans/fenxiao/getfenxiaomember`, params)
}
/**
 * 获取分销订单
 * @param {any} params 
 * @return 
 */
export function getFenxiaoOrder(params) {
    return request.get(`ai_humans/fenxiao/getfenxiaoorder`, params)
}
export function getSelfFenxiaoOrder(params) {
    return request.get(`ai_humans/fenxiao/getselffenxiaoorder`, params)
}
export function getOrderData() {
    return request.get(`ai_humans/fenxiao/getorderdata`)
}