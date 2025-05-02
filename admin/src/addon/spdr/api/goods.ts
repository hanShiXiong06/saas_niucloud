
import request from '@/addon/spdr/utils/request'

/***************************************************** 商品导入导出接口 ****************************************************/
/**
 * 
 * @param param 导入商品接口
 * @returns 
 */
export function importGoods(param: any) {
    return request.post(`spdr/goods/import`, param)
}
/**
 * 管理员操作
 * @param param 
 * @returns 
 */
export function importGoodsAdmin(param: any) {
    return request.post(`spdr/goods/importadmin`, param)
}
/**
 * 导出商品接口
 * @param param 
 * @returns 
 */
export function exportGoods(param: any) {
    return request.post(`spdr/goods/export`, param)
}
/**
 * 验证站点商城权限
 * @returns 
 */
export function checkShop() {
    return request.get('spdr/checkshop')
}
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
