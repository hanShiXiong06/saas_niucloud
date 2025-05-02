import request from '@/utils/request'

// USER_CODE_BEGIN -- zzexam_paper
/**
 * 获取试卷列表
 * @param params
 * @returns
 */
export function getPaperList(params: Record<string, any>) {
    return request.get(`zzexam/paper`, {params})
}

/**
 * 获取试卷选择列表
 * @param params
 * @returns
 */
export function getPaperSelectList(params: Record<string, any>) {
    return request.get(`zzexam/paper/select`, {params})
}

/**
 * 获取试卷详情
 * @param paper_id 试卷paper_id
 * @returns
 */
export function getPaperInfo(paper_id: number) {
    return request.get(`zzexam/paper/${paper_id}`);
}

/**
 * 添加试卷
 * @param params
 * @returns
 */
export function addPaper(params: Record<string, any>) {
    return request.post('zzexam/paper', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑试卷
 * @param paper_id
 * @param params
 * @returns
 */
export function editPaper(params: Record<string, any>) {
    return request.put(`zzexam/paper/${params.paper_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除试卷
 * @param paper_id
 * @returns
 */
export function deletePaper(paper_id: number) {
    return request.delete(`zzexam/paper/${paper_id}`, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 确认试卷
 */
export function confirmPaper(paper_id: number) {
    return request.put(`zzexam/paper_confirm/${paper_id}`, { showErrorMessage: true, showSuccessMessage: true })
}


// USER_CODE_END -- zzexam_paper


// USER_CODE_BEGIN -- zzexam_paper_question
/**
 * 获取试卷题目列表
 * @param params
 * @returns
 */
export function getPaperQuestionList(params: Record<string, any>) {
    return request.get(`zzexam/paper_question`, {params})
}

/**
 * 获取试卷题目详情
 * @param id 试卷题目id
 * @returns
 */
export function getPaperQuestionInfo(paper_id: number) {
    return request.get(`zzexam/paper_question/${paper_id}`);
}

/**
 * 添加试卷题目
 * @param params
 * @returns
 */
export function addPaperQuestion(params: Record<string, any>) {
    return request.post('zzexam/paper_question', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑试卷题目
 * @param id
 * @param params
 * @returns
 */
export function editPaperQuestion(params: Record<string, any>) {
    return request.put(`zzexam/paper_question/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除试卷题目
 * @param id
 * @returns
 */
export function deletePaperQuestion(id: number) {
    return request.delete(`zzexam/paper_question/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_paper_question
