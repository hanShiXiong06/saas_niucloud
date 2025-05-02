import request from '@/utils/request'

// USER_CODE_BEGIN -- blog_tie_cate
/**
 * 获取分类列表
 * @param params
 * @returns
 */
export function getCateList(params: Record<string, any>) {
    return request.get(`blog/cate`, {params})
}

/**
 * 获取分类详情
 * @param id 分类id
 * @returns
 */
export function getCateInfo(id: number) {
    return request.get(`blog/cate/${id}`);
}

/**
 * 添加分类
 * @param params
 * @returns
 */
export function addCate(params: Record<string, any>) {
    return request.post('blog/cate', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑分类
 * @param id
 * @param params
 * @returns
 */
export function editCate(params: Record<string, any>) {
    return request.put(`blog/cate/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除分类
 * @param id
 * @returns
 */
export function deleteCate(id: number) {
    return request.delete(`blog/cate/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- blog_tie_cate
