import request from '@/utils/request'

export function getset(params: Record<string, any>) {
    return request.post(`blog/getset`, params)
}
export function saveset(params: Record<string, any>) {
    return request.post(`blog/saveset`, params)
}
export function getStatInfo(params: Record<string, any>) {
	console.log(params);
    return request.post(`blog/stat`, params)
}