import request from '@/utils/request'

// USER_CODE_BEGIN -- zzexam_collect
/**
 * 获取收藏列表
 * @param params
 * @returns
 */
export function getCollectList(params: Record<string, any>) {
    return request.get(`zzexam/collect`, params)
}


/**
 * 添加|取消收藏
 * @param params
 * @returns
 */
export function addCollect(params: Record<string, any>) {
    return request.post('zzexam/collect', params)
}

// USER_CODE_END -- zzexam_collect
