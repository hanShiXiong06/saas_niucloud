
import request from '@/utils/request'
export function getAiChatConfig() {
    return request.get('ai_humans/getaichatconfig')
}


/**
 *配置修改
 * @param params
 */
export function setAiChatConfig(params: Record<string, any>) {
    return request.post(`ai_humans/setaichatconfig`, params, { showSuccessMessage: true })
}
/**
 * 配置信息
 * @returns
 */
export function getConfig() {
    return request.get('ai_humans/getconfig')
}


/**
 *配置修改
 * @param params
 */
export function setConfig(params: Record<string, any>) {
    return request.post(`ai_humans/setconfig`, params, { showSuccessMessage: true })
}

/**
 * 配置信息
 * @returns
 */
export function getVoiceConfig() {
    return request.get('ai_humans/getvoiceconfig')
}


/**
 *配置修改
 * @param params
 */
export function setVoiceConfig(params: Record<string, any>) {
    return request.post(`ai_humans/setvoiceconfig`, params, { showSuccessMessage: true })
}


export function getAiConfig() {
    return request.get('ai_humans/getaiconfig')
}
export function getTextCensorConfig() {
    return request.get('ai_humans/gettextcensorconfig')
}

export function getFenxiaoConfig() {
    return request.get('ai_humans/getfenxiaoconfig')
}
export function setFenxiaoConfig(params: Record<string, any>) {
    return request.post(`ai_humans/setfenxiaoconfig`, params, { showSuccessMessage: true })
}
/**
 *配置修改
 * @param params
 */
export function setAiConfig(params: Record<string, any>) {
    return request.post(`ai_humans/setaiconfig`, params, { showSuccessMessage: true })
}
export function setTextCensorConfig(params: Record<string, any>) {
    return request.post(`ai_humans/settextcensorconfig`, params, { showSuccessMessage: true })
}
