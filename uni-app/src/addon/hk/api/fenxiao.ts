
import request from '@/utils/request'

/***************************************************** 分销相关接口 ****************************************************/
export function checkFenxiao(params : Record<string, any>) {
	return request.post(`hk/checkfenxiao`, params)
}
export function getFenxiaoInfo() {
	return request.get(`hk/fenxiao/getfenxiaofnfo`)
}