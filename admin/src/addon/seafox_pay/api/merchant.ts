
import request from '@/utils/request'

/***************************************************** setting ****************************************************/

export function getMerchantList(params : Record<string, any>) {
    return request.get(`seafox_pay/merchant/lists`,{ params })
}

export function deleteMerchant(params: Record<string, any>) {
    return request.post(`seafox_pay/merchant/delete`,params)
}

export function getMerchantDetail(params: Record<string, any>) {
    return request.get(`seafox_pay/merchant/detail`,{ params })
}

export function addMerchant(params: Record<string, any>) {
    return request.post(`seafox_pay/merchant/add`,params)
}
export function editMerchant(params: Record<string, any>) {
    return request.post(`seafox_pay/merchant/edit/${params.id}`,params)
}