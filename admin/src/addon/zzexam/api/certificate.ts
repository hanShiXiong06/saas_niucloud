import request from '@/utils/request'

// USER_CODE_BEGIN -- zzexam_certificate_template
/**
 * 获取选择证书模板列表
 * @param params
 * @returns
 */
export function getTemplateSelectList(params: Record<string, any>) {
    return request.get(`zzexam/template/select`, {params})
}

// USER_CODE_END -- zzexam_certificate_template


// USER_CODE_BEGIN -- zzexam_certificate
/**
 * 获取会员证书列表
 * @param params
 * @returns
 */
export function getCertificateList(params: Record<string, any>) {
    return request.get(`zzexam/certificate`, {params})
}

/**
 * 获取会员证书详情
 * @param certificate_id 会员证书certificate_id
 * @returns
 */
export function getCertificateInfo(certificate_id: number) {
    return request.get(`zzexam/certificate/${certificate_id}`);
}

/**
 * 添加会员证书
 * @param params
 * @returns
 */
export function addCertificate(params: Record<string, any>) {
    return request.post('zzexam/certificate', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑会员证书
 * @param certificate_id
 * @param params
 * @returns
 */
export function editCertificate(params: Record<string, any>) {
    return request.put(`zzexam/certificate/${params.certificate_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除会员证书
 * @param certificate_id
 * @returns
 */
export function deleteCertificate(certificate_id: number) {
    return request.delete(`zzexam/certificate/${certificate_id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_certificate
