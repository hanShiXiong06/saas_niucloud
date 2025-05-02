
import request from '@/utils/request'

/***************************************************** 推广活动接口 ****************************************************/
export function getActList(params: any) {
    return request.get(`tk_cpa/act`, params)
}
export function getActInfo(id: any) {
    return request.get(`tk_cpa/act/${id}`)
}
export const addPromotionCode = (data) => {
    return request.post(`tk_cpa/sid/add`, data);
};