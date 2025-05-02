import request from "@/utils/request";

/***************************************************** 接口 ****************************************************/
/**
 *
 * @param params
 * @returns
 */
export function verifyCardNum(card_num) {
  return request.post(`tk_partner/card/verifycardnum/${card_num}`);
}
