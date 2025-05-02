
import request from '@/utils/request'

/**
 * 获取存储配置列表
 */
export function getStorageList() {
    return request.get(`tk_pan/storage`)
}

/**
 * 获取存储详情
 * @param type
 */
export function getStorageInfo(type: string) {
    return request.get(`tk_pan/storage/${type}`)
}

/**
 * 修改存储
 * @param params
 * @returns
 */
export function editStorage(params: Record<string, any>) {
    return request.put(`tk_pan/storage/${params.storage_type}`, params, { showSuccessMessage: true })
}
export function addDriver() {
    return request.get(`tk_pan/adddriver`,{ showErrorMessage: true, showSuccessMessage: true })
}