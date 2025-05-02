import request from "@/addon/goods_export/utils/request";

/***************************************************** 商品导入导出接口 ****************************************************/
/**
 *
 * @param param 导入商品接口
 * @returns
 */
export function importGoods(param: any) {
  return request.post(`goods_export/goods/import`, param);
}
/**
 * 管理员操作
 * @param param
 * @returns
 */
export function importGoodsAdmin(param: any) {
  return request.post(`goods_export/goods/importadmin`, param);
}
/**
 * 导出商品接口
 * @param param
 * @returns
 */
export function exportGoods(param: any) {
  return request.post(`goods_export/goods/export`, param);
}
/**
 * 验证站点商城权限
 * @returns
 */
export function checkShop() {
  return request.get("goods_export/checkshop");
}
/**
 * 获取商品类型
 * @returns
 */
export function getGoodsType() {
  return request.get(`phone_shop/goods/type`);
}

/**
 * 获取商品分类树结构
 * @returns
 */
export function getCategoryTree() {
  return request.get(`phone_shop/goods/tree`);
}

// 批量更新二手机价格
export function importRecycleCategory(param: any) {
  return request.post(`goods_export/goods/import/recycle_category`, param);
}
