import request from '@/utils/request'

	export function SubmitTopOrder(params: Record<string, any>) {
	    return request.post('blog/top_order/submit', params)
	}