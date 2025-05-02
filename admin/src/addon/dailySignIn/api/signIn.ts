
import request from '@/utils/request'
/**
 * 获取签到配置
 * @returns 
 */
export function getSignInList() {
    return request.get(`dailysignin/index`)
}
/**
 * 签到配置
 */
export function create(params: Record<string, any>) { 
    return request.post(`/dailysignin/create`, params, {showSuccessMessage: true})
}