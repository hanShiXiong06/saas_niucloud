
import request from '@/utils/request'

/***************************************************** 智能对话 ****************************************************/
export function sendMsg(params) {
	return request.post(`ai_humans/sendmsg`, params)
}
export function modelList(params) {
	return request.get(`ai_humans/chatmodel`, params)
}
export function getHistoryMsgList(params) {
	return request.get(`ai_humans/chat/gethistorymsg`, params)
}
export function modelInfo(id) {
	return request.get(`ai_humans/chatmodel/${id}`)
}