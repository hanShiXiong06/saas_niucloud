
import request from '@/utils/request'

/**
 * 短信配置列表
 * @returns
 */
export function getSmsList() {
    return request.get('tk_yht/notice/notice/sms')
}

/**
 * 短信配置详情
 * @param sms_type
 * @returns
 */
export function getSmsInfo(sms_type: string) {
    return request.get(`tk_yht/sms/${sms_type}`,)
}

/**
 * 短信配置修改
 * @param params
 */
export function editSms(params: Record<string, any>) {
    return request.put(`tk_yht/sms/${params.sms_type}`, params, {showSuccessMessage: true})
}