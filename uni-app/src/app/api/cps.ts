
import request from '@/utils/request'
import { useLogin } from "@/hooks/useLogin";
import { getToken } from '@/utils/common'
/***************************************************** CPS联盟 ****************************************************/
export function getCpsInfo(params: Record<string, any>) {
	return request.get(`tk_cps/cpsinfo`, params)
}
/**
 * 新增拦截
 * @return
 */
export function authLogin() {
	if (!getToken()) {
		useLogin().setLoginBack({ url: '/addon/tk_cps/pages/diy' })
	}
	return true //自动进行登录
}