import request from "@/utils/request";

// USER_CODE_BEGIN -- hsx_phone_query_category
/**
 * 获取分类列表
 * @param params
 * @returns
 */
export function getHsxPhoneQueryCategoryList(params: Record<string, any>) {
  return request.get(`hsx_phone_query/hsx_phone_query_category`, { params });
}

/**
 * 获取分类详情
 * @param site_id 分类site_id
 * @returns
 */
export function getHsxPhoneQueryCategoryInfo(id: number) {
  return request.get(`hsx_phone_query/hsx_phone_query_category/${id}`);
}

/**
 * 添加分类
 * @param params
 * @returns
 */
export function addHsxPhoneQueryCategory(params: Record<string, any>) {
  return request.post("hsx_phone_query/hsx_phone_query_category", params, {
    showErrorMessage: true,
    showSuccessMessage: true,
  });
}

/**
 * 编辑分类
 * @param site_id
 * @param params
 * @returns
 */
export function editHsxPhoneQueryCategory(params: Record<string, any>) {
  return request.put(
    `hsx_phone_query/hsx_phone_query_category/${params.id}`,
    params,
    { showErrorMessage: true, showSuccessMessage: true }
  );
}

/**
 * 删除分类
 * @param site_id
 * @returns
 */
export function deleteHsxPhoneQueryCategory(id: number) {
  return request.delete(`hsx_phone_query/hsx_phone_query_category/${id}`, {
    showErrorMessage: true,
    showSuccessMessage: true,
  });
}

/**
 * 修改排序
 * @param id
 * @param sort
 */
export function modifySort(id: number, sort: number) {
  return request.post(
    `hsx_phone_query/hsx_phone_query_category/modify_sort/${id}`,
    { sort }
  );
}

/**
 * 修改显示状态
 * @param id
 * @param is_show
 */
export function modifyShow(id: number, is_show: number) {
  return request.post(
    `hsx_phone_query/hsx_phone_query_category/modify_show/${id}`,
    { is_show }
  );
}

// USER_CODE_END -- hsx_phone_query_category
