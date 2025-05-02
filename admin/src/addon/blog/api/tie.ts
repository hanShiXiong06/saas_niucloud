import request from '@/utils/request'


// USER_CODE_BEGIN -- blog_tie
/**
 * 获取帖子列表
 * @param params
 * @returns
 */
export function getTieList(params: Record<string, any>) {
    return request.get(`blog/tie`, {params})
}

/**
 * 获取帖子详情
 * @param id 帖子id
 * @returns
 */
export function getTieInfo(id: number) {
    return request.get(`blog/tie/${id}`);
}

/**
 * 添加帖子
 * @param params
 * @returns
 */
export function addTie(params: Record<string, any>) {
    return request.post('blog/tie', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑帖子
 * @param id
 * @param params
 * @returns
 */
export function editTie(params: Record<string, any>) {
    return request.put(`blog/tie/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除帖子
 * @param id
 * @returns
 */
export function deleteTie(id: number) {
    return request.delete(`blog/tie/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithCateList(params: Record<string,any>){
    return request.get('blog/cate_all', {params})
}export function getWithMemberList(params: Record<string,any>){
    return request.get('blog/member_all', {params})
}export function getWithLabelList(params: Record<string,any>){
    return request.get('blog/label_all', {params})
}

export function shenhe_tie(params: Record<string,any>){
    return request.post('blog/shenhe_tie', params)
}

// USER_CODE_END -- blog_tie



