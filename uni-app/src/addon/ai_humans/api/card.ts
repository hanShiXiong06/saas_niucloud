import request from "@/utils/request";

/***************************************************** 接口 ****************************************************/
/**
 *
 * @param params
 * @returns
 */
export function verifyCardNum(card_num) {
  return request.post(`ai_humans/card/verifycardnum/${card_num}`);
}
