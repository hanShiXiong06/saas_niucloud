
import request from '@/utils/request'

/***************************************************** 店铺会员 ****************************************************/
export function getPartnerMemberList(data: any) {
    return request.get(`tk_partner/partner/member/lists`, data)
}
