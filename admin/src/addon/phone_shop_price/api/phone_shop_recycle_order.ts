import request from '@/utils/request'


























// USER_CODE_BEGIN -- phone_shop_recycle_order
/**
 * 获取回收订单列表
 * @param params
 * @returns
 */
export function getPhoneShopRecycleOrderList(params: Record<string, any>) {
    return request.get(`phone_shop_price/phone_shop_recycle_order`, {params})
}

/**
 * 获取回收订单详情
 * @param id 回收订单id
 * @returns
 */
export function getPhoneShopRecycleOrderInfo(id: number) {
    return request.get(`phone_shop_price/phone_shop_recycle_order/${id}`);
}

/**
 * 添加回收订单
 * @param params
 * @returns
 */
export function addPhoneShopRecycleOrder(params: Record<string, any>) {
    return request.post('phone_shop_price/phone_shop_recycle_order', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑回收订单
 * @param id
 * @param params
 * @returns
 */
export function editPhoneShopRecycleOrder(params: Record<string, any>) {
    return request.put(`phone_shop_price/phone_shop_recycle_order/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除回收订单
 * @param id
 * @returns
 */
export function deletePhoneShopRecycleOrder(id: number) {
    return request.delete(`phone_shop_price/phone_shop_recycle_order/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}

export function getWithMemberList(params: Record<string,any>){
    return request.get('phone_shop_price/member_all', {params})
}

/**
 * 获取回收订单状态字典
 * @returns
 */
export function getRecycleOrderStatusDict() {
    return request.get('dict/recycle_order')
}

// USER_CODE_END -- phone_shop_recycle_order
