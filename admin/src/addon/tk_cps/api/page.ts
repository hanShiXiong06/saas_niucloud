import request from '@/utils/request'
//获取页面域名
export function getWapDomain() {
    return request.get(`tk_cps/getwapdomain`)
}

