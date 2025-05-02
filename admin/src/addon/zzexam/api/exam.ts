import request from '@/utils/request'


// USER_CODE_BEGIN -- zzexam_subject

/**
 * 获取科目树结构
 * @returns
 */
export function getSubjectTree() {
    return request.get(`zzexam/subject/tree`)
}

/**
 * 拖拽编辑科目
 * @param params
 * @returns
 */
export function updateSubject(params: Record<string, any>) {
    return request.post(`zzexam/subject/update`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 获取科目列表
 * @param params
 * @returns
 */
export function getSubjectList(params: Record<string, any>) {
    return request.get(`zzexam/subject`, {params})
}

/**
 * 获取科目详情
 * @param id 科目id
 * @returns
 */
export function getSubjectInfo(id: number) {
    return request.get(`zzexam/subject/${id}`);
}

/**
 * 添加科目
 * @param params
 * @returns
 */
export function addSubject(params: Record<string, any>) {
    return request.post('zzexam/subject', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑科目
 * @param id
 * @param params
 * @returns
 */
export function editSubject(params: Record<string, any>) {
    return request.put(`zzexam/subject/${params.subject_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除科目
 * @param id
 * @returns
 */
export function deleteSubject(id: number) {
    return request.delete(`zzexam/subject/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_subject



// USER_CODE_BEGIN -- zzexam_exam
/**
 * 获取考试列表
 * @param params
 * @returns
 */
export function getExamList(params: Record<string, any>) {
    return request.get(`zzexam/exam`, {params})
}

/**
 * 获取考试选择分页列表
 * @param params
 * @returns
 */
export function getExamSelectPageList(params: Record<string, any>) {
    return request.get(`zzexam/exam/select`, {params})
}

/**
 * 获取考试详情
 * @param exam_id 考试exam_id
 * @returns
 */
export function getExamInfo(exam_id: number) {
    return request.get(`zzexam/exam/${exam_id}`);
}

/**
 * 添加考试
 * @param params
 * @returns
 */
export function addExam(params: Record<string, any>) {
    return request.post('zzexam/exam', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑考试
 * @param exam_id
 * @param params
 * @returns
 */
export function editExam(params: Record<string, any>) {
    return request.put(`zzexam/exam/${params.exam_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除考试
 * @param exam_id
 * @returns
 */
export function deleteExam(exam_id: number) {
    return request.delete(`zzexam/exam/${exam_id}`, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 获取考试模式
 * @returns
 */
export function getExamMode() {
    return request.get(`zzexam/exam/mode`);
}

// USER_CODE_END -- zzexam_exam


// USER_CODE_BEGIN -- zzexam_exam_scores
/**
 * 获取成绩列表
 * @param params
 * @returns
 */
export function getScoresList(params: Record<string, any>) {
    return request.get(`zzexam/exam/scores`, {params})
}

/**
 * 获取成绩详情
 * @param scores_id 成绩scores_id
 * @returns
 */
export function getScoresInfo(scores_id: number) {
    return request.get(`zzexam/exam/scores/${scores_id}`);
}

/**
 * 添加成绩
 * @param params
 * @returns
 */
export function addScores(params: Record<string, any>) {
    return request.post('zzexam/exam/scores', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑成绩
 * @param scores_id
 * @param params
 * @returns
 */
export function editScores(params: Record<string, any>) {
    return request.put(`zzexam/exam/scores/${params.scores_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除成绩
 * @param scores_id
 * @returns
 */
export function deleteScores(scores_id: number) {
    return request.delete(`zzexam/exam/scores/${scores_id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_exam_scores


// USER_CODE_BEGIN -- zzexam_exam_answer
/**
 * 获取考试答卷列表
 * @param params
 * @returns
 */
export function getAnswerList(params: Record<string, any>) {
    return request.get(`zzexam/exam/answer`, {params})
}

/**
 * 获取考试答卷详情
 * @param answer_id 考试答卷answer_id
 * @returns
 */
export function getAnswerInfo(answer_id: number) {
    return request.get(`zzexam/exam/answer/${answer_id}`);
}

/**
 * 添加考试答卷
 * @param params
 * @returns
 */
export function addAnswer(params: Record<string, any>) {
    return request.post('zzexam/exam/answer', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑考试答卷
 * @param answer_id
 * @param params
 * @returns
 */
export function editAnswer(params: Record<string, any>) {
    return request.put(`zzexam/exam/answer/${params.answer_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除考试答卷
 * @param answer_id
 * @returns
 */
export function deleteAnswer(answer_id: number) {
    return request.delete(`zzexam/exam/answer/${answer_id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_exam_answer


// USER_CODE_BEGIN -- zzexam_exam_sign
/**
 * 获取考试报名列表
 * @param params
 * @returns
 */
export function getSignList(params: Record<string, any>) {
    return request.get(`zzexam/exam/sign`, {params})
}

/**
 * 获取考试报名详情
 * @param sign_id 考试报名sign_id
 * @returns
 */
export function getSignInfo(sign_id: number) {
    return request.get(`zzexam/exam/sign/${sign_id}`);
}

/**
 * 添加考试报名
 * @param params
 * @returns
 */
export function addSign(params: Record<string, any>) {
    return request.post('zzexam/exam/sign', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑考试报名
 * @param sign_id
 * @param params
 * @returns
 */
export function editSign(params: Record<string, any>) {
    return request.put(`zzexam/exam/sign/${params.sign_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除考试报名
 * @param sign_id
 * @returns
 */
export function deleteSign(sign_id: number) {
    return request.delete(`zzexam/exam/sign/${sign_id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_exam_sign


// USER_CODE_BEGIN -- zzexam_exam_pwd
/**
 * 获取考试密码列表
 * @param params
 * @returns
 */
export function getPwdList(params: Record<string, any>) {
    return request.get(`zzexam/exam/pwd`, {params})
}

/**
 * 获取考试密码详情
 * @param sign_id 考试密码sign_id
 * @returns
 */
export function getPwdInfo(sign_id: number) {
    return request.get(`zzexam/exam/pwd/${sign_id}`);
}

/**
 * 添加考试密码
 * @param params
 * @returns
 */
export function addPwd(params: Record<string, any>) {
    return request.post('zzexam/exam/pwd', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑考试密码
 * @param sign_id
 * @param params
 * @returns
 */
export function editPwd(params: Record<string, any>) {
    return request.put(`zzexam/exam/pwd/${params.sign_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除考试密码
 * @param sign_id
 * @returns
 */
export function deletePwd(sign_id: number) {
    return request.delete(`zzexam/exam/pwd/${sign_id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- zzexam_exam_pwd


// USER_CODE_BEGIN -- zzexam_exam_order
/**
 * 获取考试订单列表
 * @param params
 * @returns
 */
export function getOrderList(params: Record<string, any>) {
    return request.get(`zzexam/exam/order`, {params})
}

/**
 * 获取考试订单详情
 * @param order_id 考试订单order_id
 * @returns
 */
export function getOrderInfo(order_id: number) {
    return request.get(`zzexam/exam/order/${order_id}`);
}

/**
 * 添加考试订单
 * @param params
 * @returns
 */
export function addOrder(params: Record<string, any>) {
    return request.post('zzexam/exam/order', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑考试订单
 * @param order_id
 * @param params
 * @returns
 */
export function editOrder(params: Record<string, any>) {
    return request.put(`zzexam/exam/order/${params.order_id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除考试订单
 * @param order_id
 * @returns
 */
export function deleteOrder(order_id: number) {
    return request.delete(`zzexam/exam/order/${order_id}`, { showErrorMessage: true, showSuccessMessage: true })
}


// USER_CODE_END -- zzexam_exam_order
