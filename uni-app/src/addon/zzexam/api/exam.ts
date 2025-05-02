import request from '@/utils/request'

/**
 * 获取考试列表供组件调用
 */
export function getExamComponents(params: Record<string, any>) {
    return request.get(`zzexam/exam/components`, params)
}

/**
 * 获取科目树结构
 * @returns
 */
export function getSubjectTree() {
    return request.get(`zzexam/subject/tree`)
}

/**
 * 科目详情
 */
export function getSubjectDetail(exam_id: number) {
    return request.get(`zzexam/subject/${exam_id}`)
}

/**
 * 获取考试列表
 * @param params
 * @returns
 */
export function getExamList(params: Record<string, any>) {
    return request.get(`zzexam/exam`, params)
}

/**
 * 考试详情
 */
export function getExamDetail(exam_id: number) {
    return request.get(`zzexam/exam/${exam_id}`)
}

/**
 * 考试中-题目详情
 */
export function getExamShow(exam_id: number) {
    return request.get(`zzexam/exam/show/${exam_id}`)
}

/**
 * 交卷
 */
export function addExam(params : Record<string, any>) {
    return request.post('zzexam/exam', params)
}

/**
 * 考试报名
 * @param params
 * @returns
 */
export function addSign(params: Record<string, any>) {
    return request.post('zzexam/sign', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 考试密码验证
 * @param params
 * @returns
 */
export function addPwd(params: Record<string, any>) {
    return request.post('zzexam/pwd', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 创建考试订单
 */
export function orderCreate(params: Record<string, any>) {
    return request.post('zzexam/exam/order/create', params)
}

/**
 * 获取会员考试成绩列表
 * @param params
 * @returns
 */
export function getScoresList(params: Record<string, any>) {
    return request.get(`zzexam/scores`, params)
}

/**
 * 考试成绩详情
 */ 
export function getScoresDetail(id: number) {
    return request.get(`zzexam/scores/${id}`)
}

/**
 * 考试解析
 */ 
export function getExamExplain(scores_id: number) {
    return request.get(`zzexam/exam/explain/${scores_id}`)
}

/**
 * 获取会员证书列表
 * @param params
 * @returns
 */
export function getCertificateList(params: Record<string, any>) {
    return request.get(`zzexam/certificate`, params)
}

/**
 * 获取考试订单列表
 */
export function getExamOrderList(params: Record<string, any>) {
    return request.get(`zzexam/exam_order`, params)
}

/**
 * 获取练习题目列表
 */
export function getPracticeQueston(params: Record<string, any>) {
    return request.get(`zzexam/practice`, params)
}


