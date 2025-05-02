import request from '@/utils/request'

// USER_CODE_BEGIN -- aihumans_package
/**
 * 获取套餐列列表
 * @param params
 * @returns
 */
export function getPackageList(params: Record<string, any>) {
    return request.get(`ai_humans/package`, {params})
}

/**
 * 获取套餐列详情
 * @param id 套餐列id
 * @returns
 */
export function getPackageInfo(id: number) {
    return request.get(`ai_humans/package/${id}`);
}

/**
 * 添加套餐列
 * @param params
 * @returns
 */
export function addPackage(params: Record<string, any>) {
    return request.post('ai_humans/package', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑套餐列
 * @param id
 * @param params
 * @returns
 */
export function editPackage(params: Record<string, any>) {
    return request.put(`ai_humans/package/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除套餐列
 * @param id
 * @returns
 */
export function deletePackage(id: number) {
    return request.delete(`ai_humans/package/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- aihumans_package
