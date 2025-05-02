import request from '@/utils/request'

/**
 * 获取笔记类型
 * @param params
 * @returns
 */
export function getNoteType() {
    return request.get(`zzexam/note/type`)
}

/**
 * 获取足迹类型
 * @param params
 * @returns
 */
export function getHistoryType() {
    return request.get(`zzexam/history/type`)
}


/**
 * 获取会员笔记列表
 * @param params
 * @returns
 */
export function getNoteList(params: Record<string, any>) {
    return request.get(`zzexam/note`, params)
}

/**
 * 获取会员笔记详情
 */
export function getNoteDetail(id: number) {
    return request.get(`zzexam/note/${id}`)
}

/**
 * 题目详情
 */
export function getQuestonDetail(id: number) {
	return request.get(`zzexam/question/${id}`)
}

/**
 * 添加笔记
 */
export function addNote(params : Record<string, any>) {
    return request.post('zzexam/note', params, {showSuccessMessage: true})
}

/**
 * 编辑笔记
 */
export function editNote(params: Record<string, any>) {
    return request.put(`zzexam/note/${params.note_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 获取会员错题列表
 * @param params
 * @returns
 */
export function getErrorsList(params: Record<string, any>) {
    return request.get(`zzexam/errors`, params)
}

/**
 * 获取收藏类型
 * @param params
 * @returns
 */
export function getCollectType() {
    return request.get(`zzexam/collect/type`)
}

/**
 * 获取会员笔记列表
 * @param params
 * @returns
 */
export function getCollectList(params: Record<string, any>) {
    return request.get(`zzexam/collect`, params)
}



/**
 * 获取分类树结构
 * @returns
 */
export function getCategoryTree(params: Record<string, any>) {
    return request.get(`zzexam/category/tree`, params)
}

/**
 * 获取内容列表
 * @param params
 * @returns
 */
export function getArticleList(params: Record<string, any>) {
    return request.get(`zzexam/article`, params)
}

/**
 * 内容详情
 */
export function getArticleDetail(id: number) {
    return request.get(`zzexam/article/${id}`)
}

/**
 * 搜索
 */
export function getSearchList(params: Record<string, any>) {
    return request.get(`zzexam/search`, params)
}

/**
 * 获取我的学习次数
 */
export function getMyStudyCount() {
    return request.get(`zzexam/study_count`)
}


/**
 * 获取会员足迹列表
 * @param params
 * @returns
 */
export function getHistoryList(params: Record<string, any>) {
    return request.get(`zzexam/history`, params)
}

/**
 * 删除浏览记录
 */
export function delHistory(id: number) {
    return request.delete(`zzexam/history/${id}`,{showSuccessMessage: true});
}

/**
 * 删除错题
 */
export function delErrors(id: number) {
    return request.delete(`zzexam/errors/${id}`,{showSuccessMessage: true});
}


