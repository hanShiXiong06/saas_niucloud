
import request from '@/utils/request'

/***************************************************** CPA开码接口 ****************************************************/
export function getSidList(params: any) {
    return request.get(`tk_cpa/sid`, params)
}
export function getSidInfo(id: any) {
    return request.get(`tk_cpa/sid/${id}`)
}
export function asyncStatus(id: any) {
    return request.get(`tk_cpa/sid/asyncstatus/${id}`)
}
export function getStatusList() {
    return request.get(`tk_cpa/sid/getstatuslist`)
}

export function getSidInfoBySid(sid: any) {
    return request.get(`tk_cpa/sid/getsidinfo/${sid}`)
}