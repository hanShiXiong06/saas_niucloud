import request from '@/utils/request'

export function getset(params: Record<string, any>) {
    return request.post(`seafox_pay/fenzhang/getset`, params)
}
export function saveset(params: Record<string, any>) {
    return request.post(`seafox_pay/fenzhang/saveset`, params)
}
export function selectmerlist(params: Record<string, any>) {
    return request.post(`seafox_pay/fenzhang/selectmerlist`, params)
}