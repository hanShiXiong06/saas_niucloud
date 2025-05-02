import request from "@/utils/request";

/***************************************************** 接口 ****************************************************/
/**
 *
 * @param params
 * @returns
 */
export function getHelpList(params) {
  return request.get(`tk_partner/help/lists`, params);
}
export function getHelpInfo(id) {
  return request.get(`tk_partner/help/${id}`);
}

