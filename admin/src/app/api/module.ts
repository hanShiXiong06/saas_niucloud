import request from '@/utils/request'

/**
 * 获取授权信息
 */
export function getAuthInfo() {
    return request.get('niucloud/authinfo', { showErrorMessage: false })
}

/**
 * 设置 授权配置
 */
export function setAuthInfo(params: Record<string, any>) {
    return request.post('niucloud/authinfo', params, { showSuccessMessage: true })
}

/**
 * 获取 授权配置
 */
export function getAdminAuthInfo() {
    return request.get('niucloud/admin/authinfo')
}

/**
 * 获取授权插件列表
 * @returns
 */
export function getModule() {
    return request.get('niucloud/module')
}

/**
 * 获取插件版本
 * @returns
 */
export function getModuleVersion() {
    return request.get(`niucloud/module`)
}

/**
 * 下载版本
 * @param params
 * @returns
 */
export function downloadVersion(params: Record<string, any>) {
    return request.post(`addon/download/${ params.addon }`, params, { showSuccessMessage: true })
}

/**
 * 获取框架最新版本
 * @returns
 */
export function getFrameworkNewVersion() {
    return request.get(`niucloud/framework/newversion`)
}

/**
 * 获取框架更新记录
 * @returns
 */
export function getFrameworkVersionList() {
    return request.get(`niucloud/framework/version/list`)
}

/**
 * 获取应用/插件的版本更新记录
 * @param params
 */
export function getAppVersionList(params: Record<string, any>) {
    return request.get(`niucloud/app_version/list`, { params })
}
