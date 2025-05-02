
import request from '@/utils/request'
/**
 * 添加插件
 */
export function addPlugin() {
    return request.get('tk_cps/addplugin', { showErrorMessage: true, showSuccessMessage: true })
}
/**
 * 加载代码
 * @returns
 */
export function addFile() {
    return request.get('tk_cps/addfile', { showErrorMessage: true, showSuccessMessage: true })
}
/**
 * 恢复代码加载
 * @returns
 */
export function delFile() {
    return request.get('tk_cps/delfile', { showErrorMessage: true, showSuccessMessage: true })
}


/**
 * 下载代码
 * @returns
 */
export function downCode() {
    return request.get('tk_cps/downcode')
}

/**
 * 配置信息
 * @returns
 */
export function getConfig() {
    return request.get('tk_cps/getconfig')
}

export function getBwcConfig() {
    return request.get('tk_cps/getbwcconfig')
}
export function codeUpload() {
    return request.post('tk_cps/upload', { showSuccessMessage: true })
}

/**
 *配置修改
 * @param params
 */
export function setConfig(params: Record<string, any>) {
    return request.post(`tk_cps/setconfig`, params, { showSuccessMessage: true })
}
export function setBwcConfig(params: Record<string, any>) {
    return request.post(`tk_cps/setbwcconfig`, params, { showSuccessMessage: true })
}