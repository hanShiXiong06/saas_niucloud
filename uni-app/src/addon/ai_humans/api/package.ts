
import request from '@/utils/request'

/***************************************************** 套餐相关 ****************************************************/
export function getPackageList(params) {
	return request.get(`ai_humans/package`, params)
}
