
import request from '@/utils/request'

/***************************************************** 接口 ****************************************************/
/**
 * 获取配置
 * @param params 
 * @returns 
 */
export function getConfig() {
    return request.get('ai_humans/getconfig')
}
export function getFenxiaoConfig() {
    return request.get('ai_humans/getfenxiaoconfig')
}
export function getAiChatConfig() {
    return request.get('ai_humans/getaichatconfig')
}


