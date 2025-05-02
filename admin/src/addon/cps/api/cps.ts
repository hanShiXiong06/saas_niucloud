import request from '@/utils/request'
 

/***************************************************** 设置 ****************************************************/

/**
 * 获取cps设置
 * @returns
 */
export function getConfig() {
    return request.get('cps/config')
}

 

/**
 * 更新cps设置
 * @param params
 * @returns
 */
export function setConfig(params: Record<string, any>) {
    return request.put(`cps/config`, params, {showSuccessMessage: true})
}
 
  
 
 
/**
 * 获取聚推客订单列表
 * @param params
 * @returns
 */
export function getJtkList(params: Record<string, any>) {
    return request.get(`cps/jtk/order`, {params})
}
 
/**
 * 获取聚推客订单类型
 * @returns
 */
export function getJtkType() {
    return request.get(`cps/jtk/type`)
}
 
 
/**
 * 获取蚂蚁星球充值订单列表
 * @param params
 * @returns
 */
export function getRechargeList(params: Record<string, any>) {
    return request.get(`cps/myxq/order`, {params})
}

 
 
 
 
/**
 * 获取cps设置
 * @returns
 */
export function getSetting() {
    return request.get('cps/setting')
}

 

/**
 * 更新cps设置
 * @param params
 * @returns
 */
export function setSetting(params: Record<string, any>) {
    return request.put(`cps/setting`, params, {showSuccessMessage: true})
}