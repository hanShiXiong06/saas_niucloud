import request from '@/utils/request'

// USER_CODE_BEGIN -- hlwoauth_domain
/**
 * 获取域名授权列表
 * @param params
 * @returns
 */
export function getDomainList(params: Record<string, any>) {
    return request.get(`hlwoauth/domain`, {params})
}

/**
 * 获取域名授权详情
 * @param id 域名授权id
 * @returns
 */
export function getDomainInfo(id: number) {
    return request.get(`hlwoauth/domain/${id}`);
}

/**
 * 添加域名授权
 * @param params
 * @returns
 */
export function addDomain(params: Record<string, any>) {
    return request.post('hlwoauth/domain', params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 编辑域名授权
 * @param id
 * @param params
 * @returns
 */
export function editDomain(params: Record<string, any>) {
    return request.put(`hlwoauth/domain/${params.id}`, params, { showErrorMessage: true, showSuccessMessage: true })
}

/**
 * 删除域名授权
 * @param id
 * @returns
 */
export function deleteDomain(id: number) {
    return request.delete(`hlwoauth/domain/${id}`, { showErrorMessage: true, showSuccessMessage: true })
}



// USER_CODE_END -- hlwoauth_domain
