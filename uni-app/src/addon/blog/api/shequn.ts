import request from '@/utils/request'


export function getShequnlistApi(params: Record<string, any>) {
    return request.post('blog/shequn/getlist', params)
}
export function getShequncateApi(params: Record<string, any>) {
    return request.post('blog/shequn/catelist', params)
}

export function getShequndetailApi(params: Record<string, any>) {
    return request.post('blog/shequn/detail', params)
}