import request from '@/utils/request'


export function getNewslistApi(params: Record<string, any>) {
    return request.post('blog/news/getlist', params)
}

export function getNewsdetailApi(params: Record<string, any>) {
    return request.post('blog/news/detail', params)
}