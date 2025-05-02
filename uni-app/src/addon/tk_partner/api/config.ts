import request from '@/utils/request'

/***************************************************** hello world ****************************************************/
export function getConfig() {
    return request.get(`tk_partner/config`)
}
export function getShareInfo(data?: any) {
    return request.get(`tk_partner/partner/share/info`, data)
}
export function getSharePartnerInfo(data?: any) {
    return request.get(`tk_partner/partner/sharepartner/info`, data)
}
export function getShortLink(data?: any) {
    return request.get(`tk_partner/getshortlink`, data)
}
