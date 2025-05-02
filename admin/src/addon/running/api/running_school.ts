import request from '@/utils/request'

// USER_CODE_BEGIN -- running_school
/**
 * 获取学校信息列表
 * @param params
 * @returns
 */
export function getRunningSchoolList(params: Record<string, any>) {
    return request.get(`running/running_school`, {params})
}

/**
 * 获取学校信息详情
 * @param id 学校信息id
 * @returns
 */
export function getRunningSchoolInfo(id: number) {
    return request.get(`running/running_school/${id}`);
}

/**
 * 添加学校信息
 * @param params
 * @returns
 */
export function addRunningSchool(params: Record<string, any>) {
    return request.post('running/running_school', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑学校信息
 * @param id
 * @param params
 * @returns
 */
export function editRunningSchool(params: Record<string, any>) {
    return request.put(`running/running_school/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除学校信息
 * @param id
 * @returns
 */
export function deleteRunningSchool(id: number) {
    return request.delete(`running/running_school/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- running_school
