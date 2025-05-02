import request from '@/utils/request'

// USER_CODE_BEGIN -- blog_banner
/**
 * 获取轮播图管理列表
 * @param params
 * @returns
 */
export function getBannerList(params: Record<string, any>) {
    return request.get(`blog/banner`, {params})
}

/**
 * 获取轮播图管理详情
 * @param id 轮播图管理id
 * @returns
 */
export function getBannerInfo(id: number) {
    return request.get(`blog/banner/${id}`);
}

/**
 * 添加轮播图管理
 * @param params
 * @returns
 */
export function addBanner(params: Record<string, any>) {
    return request.post('blog/banner', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑轮播图管理
 * @param id
 * @param params
 * @returns
 */
export function editBanner(params: Record<string, any>) {
    return request.put(`blog/banner/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除轮播图管理
 * @param id
 * @returns
 */
export function deleteBanner(id: number) {
    return request.delete(`blog/banner/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- blog_banner
