import request from "@/utils/request";

// USER_CODE_BEGIN -- spdr_list
/**
 * 获取商品导入列列表
 * @param params
 * @returns
 */
export function getSpdrListList(params: Record<string, any>) {
  return request.get(`goods_export/spdrlist`, { params });
}

/**
 * 获取商品导入列详情
 * @param id 商品导入列id
 * @returns
 */
export function getSpdrListInfo(id: number) {
  return request.get(`goods_export/spdrlist/${id}`);
}

/**
 * 添加商品导入列
 * @param params
 * @returns
 */
export function addSpdrList(params: Record<string, any>) {
  return request.post("goods_export/spdrlist", params, {
    showErrorMessage: true,
    showSuccessMessage: true,
  });
}

/**
 * 编辑商品导入列
 * @param id
 * @param params
 * @returns
 */
export function editSpdrList(params: Record<string, any>) {
  return request.put(`goods_export/spdrlist/${params.id}`, params, {
    showErrorMessage: true,
    showSuccessMessage: true,
  });
}

/**
 * 删除商品导入列
 * @param id
 * @returns
 */
export function deleteSpdrList(id: number) {
  return request.delete(`goods_export/spdrlist/${id}`, {
    showErrorMessage: true,
    showSuccessMessage: true,
  });
}

// USER_CODE_END -- spdr_list
