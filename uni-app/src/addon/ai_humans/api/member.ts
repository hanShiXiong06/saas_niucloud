import request from "@/utils/request";

/***************************************************** 接口 ****************************************************/
/**
 *
 * @param params
 * @returns
 */
export function checkAccount(scene: string) {
  return request.get(`ai_humans/checkaccount/${scene}`);
}
/**
 * 获取会员日志
 * @param params
 * @returns
 */
export function getMemberLog(params: any) {
  return request.get(`ai_humans/memberlog`, params);
}
export function getAccount() {
  return request.get(`ai_humans/getaccount`);
}