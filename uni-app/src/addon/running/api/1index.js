import request from '@/utils/request'

/**
 * 获取学校列表
 */
export const getSchoolList = () => {
  return request.get('/running/schools')
}

export const getProductList = (params) => {
  return request.get('/running/products', params)
}

export const getHelpList = () => {
  return request.get('/running/helps')
}

export const getExpress = (params) => {
  return request.get('/running/express', params)
}
