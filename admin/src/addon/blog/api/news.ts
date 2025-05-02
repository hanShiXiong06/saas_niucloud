import request from '@/utils/request'

// USER_CODE_BEGIN -- blog_news
/**
 * 获取公告资讯列表
 * @param params
 * @returns
 */
export function getNewsList(params: Record<string, any>) {
    return request.get(`blog/news`, {params})
}

/**
 * 获取公告资讯详情
 * @param id 公告资讯id
 * @returns
 */
export function getNewsInfo(id: number) {
    return request.get(`blog/news/${id}`);
}

/**
 * 添加公告资讯
 * @param params
 * @returns
 */
export function addNews(params: Record<string, any>) {
    return request.post('blog/news', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑公告资讯
 * @param id
 * @param params
 * @returns
 */
export function editNews(params: Record<string, any>) {
    return request.put(`blog/news/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除公告资讯
 * @param id
 * @returns
 */
export function deleteNews(id: number) {
    return request.delete(`blog/news/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- blog_news
