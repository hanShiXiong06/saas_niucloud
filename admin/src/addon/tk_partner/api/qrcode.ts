import request from '@/utils/request'



// USER_CODE_BEGIN -- tkpartner_qrcode
/**
 * 获取空码列列表
 * @param params
 * @returns
 */
export function getQrcodeList(params: Record<string, any>) {
    return request.get(`tk_partner/qrcode`, {params})
}

/**
 * 获取空码列详情
 * @param id 空码列id
 * @returns
 */
export function getQrcodeInfo(id: number) {
    return request.get(`tk_partner/qrcode/${id}`);
}

/**
 * 添加空码列
 * @param params
 * @returns
 */
export function addQrcode(params: Record<string, any>) {
    return request.post('tk_partner/qrcode', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑空码列
 * @param id
 * @param params
 * @returns
 */
export function editQrcode(params: Record<string, any>) {
    return request.put(`tk_partner/qrcode/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除空码列
 * @param id
 * @returns
 */
export function deleteQrcode(id: number) {
    return request.delete(`tk_partner/qrcode/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithLevelList(params: Record<string,any>){
    return request.get('tk_partner/level_all', {params})
}export function getWithMemberList(params: Record<string,any>){
    return request.get('tk_partner/member_all', {params})
}

// USER_CODE_END -- tkpartner_qrcode
export function delselect(params: Record<string, any>) {
    return request.post(`tk_partner/delqrcodeselect`, params, { showErrorMessage: true, showSuccessMessage: true })
}
export function downloadQrcode(params: Record<string, any>) {
    return request.post(`tk_partner/download/qrcode`, params)
}