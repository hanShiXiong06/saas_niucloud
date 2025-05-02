
import request from '@/utils/request'

/***************************************************** hello world ****************************************************/
export function checkPartnerOpen() {
    return request.get(`tk_partner/partner/check`)
}
export function getPartnerInfo(data: any) {
    return request.get(`tk_partner/partner/info`, data)
}
export function getPartnerInfoByPid(pid: string) {
    return request.get(`tk_partner/partner/info/pid/${pid}`)
}
export function editPartner(data: any) {
    return request.post(`tk_partner/partner/edit`, data)
}
export function getStat() {
    return request.get(`tk_partner/partner/stat`)
}
export function getQrcodeInfo(code: string) {
    return request.get(`tk_partner/qrcode/info/${code}`)
}