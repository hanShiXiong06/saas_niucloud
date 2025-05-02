import request from '@/utils/request'
export function getStorageList(params: Record<string, any>) {
    return request.get(`manage_oss/storage`, { params })
}



// USER_CODE_BEGIN -- manage_oss
/**
 * 获取存储管理列表
 * @param params
 * @returns
 */
export function getManageOssList(params: Record<string, any>) {
    return request.get(`manage_oss/manageoss`, { params })
}

/**
 * 获取存储管理详情
 * @param id 存储管理id
 * @returns
 */
export function getManageOssInfo(id: number) {
    return request.get(`manage_oss/manageoss/${id}`);
}

/**
 * 添加存储管理
 * @param params
 * @returns
 */
export function addManageOss(params: Record<string, any>) {
    return request.post('manage_oss/manageoss', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑存储管理
 * @param id
 * @param params
 * @returns
 */
export function editManageOss(params: Record<string, any>) {
    return request.put(`manage_oss/manageoss/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除存储管理
 * @param id
 * @returns
 */
export function deleteManageOss(id: number) {
    return request.delete(`manage_oss/manageoss/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithSiteList(params: Record<string, any>) {
    return request.get('manage_oss/site_all', { params })
}

// USER_CODE_END -- manage_oss