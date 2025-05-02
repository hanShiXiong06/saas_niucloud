
import request from '@/utils/request'

/***************************************************** setting ****************************************************/

export function getConfig() {
    return request.get(`seafox_pay/setting/getConfig`)
}

export function setConfig(params: Record<string, any>) {
    return request.post(`seafox_pay/setting/setConfig`,params)
}