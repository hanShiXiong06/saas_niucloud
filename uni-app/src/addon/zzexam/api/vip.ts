import request from '@/utils/request'

/**
 * 获取VIP配置
 * @returns
 */
export function getVipConfig() {
    return request.get('zzexam/vip/config')
}

/**
 * 获取VIP套餐列表
 */
export function getVipList() {
    return request.get(`zzexam/vip`)
}

/**
 * 创建VIP订单
 */
export function orderCreate(params: Record<string, any>) {
    return request.post('zzexam/vip/order/create', params)
}

/**
 * 获取我的会员卡
 */
export function getMyVip(params : Record<string, any>) {
	return request.get(`zzexam/member/vip`, params)
}

/**
 * 获取VIP订单列表
 */
export function getVipOrderList(params: Record<string, any>) {
    return request.get(`zzexam/vip_order`, params)
}
