import request from '@/utils/request'



export function getBlogerApi(params: Record<string, any>) {
    return request.post('blog/bloger', params)
}


export function tofollowApi(params: Record<string, any>) {
    return request.post('blog/tofollow', params)
}