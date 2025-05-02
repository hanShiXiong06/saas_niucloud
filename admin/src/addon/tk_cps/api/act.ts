import request from '@/utils/request'
/**
 * 获取已经启用的驱动
 * @returns 
 */
export function getDrivers() {
    return request.get(`tk_cps/driver/list`);
}
/**
 * 同步cps活动
 */
export function asyncAct() {
    return request.get(`tk_cps/asyncact`, { showErrorMessage: true, showSuccessMessage: true });
}
/**
 * 获取CPS推广信息
 * @param id CPS活动链接id
 * @returns
 */
export function getShareInfo(id: number) {
    return request.get(`tk_cps/shareinfo/${id}`);
}
/**
 * 同步推广信息
 */
export function getAllItem() {
    return request.get(`tk_cps/getallitem`, { showErrorMessage: true, showSuccessMessage: true });
}
/**
 * 保存cps素材
 * @param id CPS活动链接id
 * @returns
 */
export function saveImg(id: number) {
    return request.get(`tk_cps/saveimg/${id}`, { showErrorMessage: true, showSuccessMessage: true });
}
// USER_CODE_BEGIN -- cps_act
/**
 * 获取CPS活动链接列表
 * @param params
 * @returns
 */
export function getActList(params: Record<string, any>) {
    return request.get(`tk_cps/act`, { params })
}

/**
 * 获取CPS活动链接详情
 * @param id CPS活动链接id
 * @returns
 */
export function getActInfo(id: number) {
    return request.get(`tk_cps/act/${id}`);
}

/**
 * 添加CPS活动链接
 * @param params
 * @returns
 */
export function addAct(params: Record<string, any>) {
    return request.post('tk_cps/act', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑CPS活动链接
 * @param id
 * @param params
 * @returns
 */
export function editAct(params: Record<string, any>) {
    return request.put(`tk_cps/act/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除CPS活动链接
 * @param id
 * @returns
 */
export function deleteAct(id: number) {
    return request.delete(`tk_cps/act/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- cps_act
