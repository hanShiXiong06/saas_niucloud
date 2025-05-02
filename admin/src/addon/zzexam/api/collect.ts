import request from '@/utils/request'

// USER_CODE_BEGIN -- zzexam_collect
/**
 * 获取会员收藏列表
 * @param params
 * @returns
 */
export function getCollectList(params: Record<string, any>) {
    return request.get(`zzexam/collect`, {params})
}

/**
 * 获取会员收藏详情
 * @param id 会员收藏id
 * @returns
 */
export function getCollectInfo(id: number) {
    return request.get(`zzexam/collect/${id}`);
}

/**
 * 添加会员收藏
 * @param params
 * @returns
 */
export function addCollect(params: Record<string, any>) {
    return request.post('zzexam/collect', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑会员收藏
 * @param id
 * @param params
 * @returns
 */
export function editCollect(params: Record<string, any>) {
    return request.put(`zzexam/collect/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除会员收藏
 * @param id
 * @returns
 */
export function deleteCollect(id: number) {
    return request.delete(`zzexam/collect/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_collect
