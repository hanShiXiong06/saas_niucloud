import request from '@/utils/request'

// USER_CODE_BEGIN -- running_express_site
/**
 * 获取快递站点列表
 * @param params
 * @returns
 */
export function getRunningExpressSiteList(params: Record<string, any>) {
    return request.get(`running/running_express_site`, {params})
}

/**
 * 获取快递站点详情
 * @param id 快递站点id
 * @returns
 */
export function getRunningExpressSiteInfo(id: number) {
    return request.get(`running/running_express_site/${id}`);
}

/**
 * 添加快递站点
 * @param params
 * @returns
 */
export function addRunningExpressSite(params: Record<string, any>) {
    return request.post('running/running_express_site', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑快递站点
 * @param id
 * @param params
 * @returns
 */
export function editRunningExpressSite(params: Record<string, any>) {
    return request.put(`running/running_express_site/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除快递站点
 * @param id
 * @returns
 */
export function deleteRunningExpressSite(id: number) {
    return request.delete(`running/running_express_site/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithRunningSchoolList(params: Record<string,any>){
    return request.get('running/running_school_all', {params})
}

// USER_CODE_END -- running_express_site
