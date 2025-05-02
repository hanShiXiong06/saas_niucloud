import request from '@/utils/request'


// USER_CODE_BEGIN -- zzexam_question
/**
 * 获取题目列表
 * @param params
 * @returns
 */
export function getQuestionList(params: Record<string, any>) {
    return request.get(`zzexam/question`, {params})
}

/**
 * 获取题目详情
 * @param question_id 题目question_id
 * @returns
 */
export function getQuestionInfo(question_id: number) {
    return request.get(`zzexam/question/${question_id}`);
}

/**
 * 添加题目
 * @param params
 * @returns
 */
export function addQuestion(params: Record<string, any>) {
    return request.post('zzexam/question', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑题目
 * @param question_id
 * @param params
 * @returns
 */
export function editQuestion(params: Record<string, any>) {
    return request.put(`zzexam/question/${params.question_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除题目
 * @param question_id
 * @returns
 */
export function deleteQuestion(question_id: number) {
    return request.delete(`zzexam/question/${question_id}`, { showErrorMessage: true, showSuccessMessage: true })
}


/**
 * 获取题型
 * @returns
 */
export function getQuestionTypeList() {
	return request.get(`zzexam/question_type`)
}

/**
 * 获取题型题目数量
 */
export function getQuestionTypeCount() {
	return request.get(`zzexam/question_type_count`)
}            

/**
 * 获取难度
 * @returns
 */
export function getQuestionDifficultyList() {
	return request.get(`zzexam/question_difficulty`)
}

/**
 * 导入题目
 * @return
 */
export function addBatchQuestion(params: Record<string, any>) {
    return request.put(`zzexam/question/add_batch`, params, { showErrorMessage: true, showSuccessMessage: true })
}


/**
 * 获取题目选择分页列表
 * @param params
 * @returns
 */
export function getQuestionSelectList(params: Record<string, any>) {
    return request.get(`zzexam/question/select`, { params })
}

// USER_CODE_END -- zzexam_question
