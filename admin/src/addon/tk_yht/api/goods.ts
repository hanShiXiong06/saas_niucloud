import request from '@/utils/request'


/**
 * 获取商品类型
 * @returns
 */
export function getGoodsType() {
    return request.get(`shop/goods/type`);
}

/**
 * 获取商品分类树结构
 * @returns
 */
export function getCategoryTree() {
    return request.get(`shop/goods/tree`)
}
