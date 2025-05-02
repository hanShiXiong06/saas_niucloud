import request from '@/utils/request'


// USER_CODE_BEGIN -- zzexam_category

/**
 * 获取分类树结构
 * @returns
 */
export function getCategoryTree(params: Record<string, any>) {
    return request.get(`zzexam/category/tree`,{params})
}

/**
 * 拖拽编辑分类
 * @param params
 * @returns
 */
export function updateCategory(params: Record<string, any>) {
    return request.post(`zzexam/category/update`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 获取分类类型
 * @returns
 */
export function getCategoryType() {
    return request.get(`zzexam/category/type`);
}

/**
 * 获取分类列表
 * @param params
 * @returns
 */
export function getCategoryList(params: Record<string, any>) {
    return request.get(`zzexam/category`, {params})
}

/**
 * 获取分类详情
 * @param id 分类id
 * @returns
 */
export function getCategoryInfo(id: number) {
    return request.get(`zzexam/category/${id}`);
}

/**
 * 添加分类
 * @param params
 * @returns
 */
export function addCategory(params: Record<string, any>) {
    return request.post('zzexam/category', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑分类
 * @param id
 * @param params
 * @returns
 */
export function editCategory(params: Record<string, any>) {
    return request.put(`zzexam/category/${params.category_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除分类
 * @param id
 * @returns
 */
export function deleteCategory(id: number) {
    return request.delete(`zzexam/category/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_category



// USER_CODE_BEGIN -- zzexam_note
/**
 * 获取会员笔记列表
 * @param params
 * @returns
 */
export function getNoteList(params: Record<string, any>) {
    return request.get(`zzexam/note`, {params})
}

/**
 * 获取会员笔记详情
 * @param id 会员笔记id
 * @returns
 */
export function getNoteInfo(id: number) {
    return request.get(`zzexam/note/${id}`);
}

/**
 * 添加会员笔记
 * @param params
 * @returns
 */
export function addNote(params: Record<string, any>) {
    return request.post('zzexam/note', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑会员笔记
 * @param id
 * @param params
 * @returns
 */
export function editNote(params: Record<string, any>) {
    return request.put(`zzexam/note/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除会员笔记
 * @param id
 * @returns
 */
export function deleteNote(id: number) {
    return request.delete(`zzexam/note/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_note


// USER_CODE_BEGIN -- zzexam_errors
/**
 * 获取会员错题列表
 * @param params
 * @returns
 */
export function getErrorsList(params: Record<string, any>) {
    return request.get(`zzexam/errors`, {params})
}

/**
 * 获取会员错题详情
 * @param id 会员错题id
 * @returns
 */
export function getErrorsInfo(id: number) {
    return request.get(`zzexam/errors/${id}`);
}

/**
 * 添加会员错题
 * @param params
 * @returns
 */
export function addErrors(params: Record<string, any>) {
    return request.post('zzexam/errors', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑会员错题
 * @param id
 * @param params
 * @returns
 */
export function editErrors(params: Record<string, any>) {
    return request.put(`zzexam/errors/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除会员错题
 * @param id
 * @returns
 */
export function deleteErrors(id: number) {
    return request.delete(`zzexam/errors/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_errors


// USER_CODE_BEGIN -- zzexam_article
/**
 * 获取内容列表
 * @param params
 * @returns
 */
export function getArticleList(params: Record<string, any>) {
    return request.get(`zzexam/article`, {params})
}

/**
 * 获取内容类型
 * @returns
 */
export function getArticleTypeList() {
	return request.get(`zzexam/article_type`)
}

/**
 * 获取内容详情
 * @param article_id 内容article_id
 * @returns
 */
export function getArticleInfo(article_id: number) {
    return request.get(`zzexam/article/${article_id}`);
}

/**
 * 添加内容
 * @param params
 * @returns
 */
export function addArticle(params: Record<string, any>) {
    return request.post('zzexam/article', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑内容
 * @param article_id
 * @param params
 * @returns
 */
export function editArticle(params: Record<string, any>) {
    return request.put(`zzexam/article/${params.article_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除内容
 * @param article_id
 * @returns
 */
export function deleteArticle(article_id: number) {
    return request.delete(`zzexam/article/${article_id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_article


// USER_CODE_BEGIN -- zzexam_history
/**
 * 获取会员足迹列表
 * @param params
 * @returns
 */
export function getHistoryList(params: Record<string, any>) {
    return request.get(`zzexam/history`, {params})
}

/**
 * 获取会员足迹详情
 * @param history_id 会员足迹history_id
 * @returns
 */
export function getHistoryInfo(history_id: number) {
    return request.get(`zzexam/history/${history_id}`);
}

/**
 * 添加会员足迹
 * @param params
 * @returns
 */
export function addHistory(params: Record<string, any>) {
    return request.post('zzexam/history', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑会员足迹
 * @param history_id
 * @param params
 * @returns
 */
export function editHistory(params: Record<string, any>) {
    return request.put(`zzexam/history/${params.history_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除会员足迹
 * @param history_id
 * @returns
 */
export function deleteHistory(history_id: number) {
    return request.delete(`zzexam/history/${history_id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_history
