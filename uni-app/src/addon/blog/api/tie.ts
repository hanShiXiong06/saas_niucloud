import request from '@/utils/request'

export function getTongji(params: Record<string, any>) {
    return request.get('blog/tongji', params)
}
export function getTielist(params: Record<string, any>) {
    return request.get('blog/tie/lists', params)
}

export function getTielistZan(params: Record<string, any>) {
    return request.get('blog/tie/lists_zan', params)
}

export function getTielistMy(params: Record<string, any>) {
    return request.get('blog/tie/lists_my', params)
}

export function getTieposter(params: Record<string, any>) {
    return request.get(`blog/tie/getposter`, params)
}
export function addviewsApi(params: Record<string, any>) {
    return request.get(`blog/tie/addviews`, params)
}

export function getTieDetail(params: Record<string, any>) {
    return request.get(`blog/tie/detail`, params)
}

export function getBanner() {
    return request.get('blog/banner')
}

export function getCategory(params: Record<string, any>) {
    return request.get('blog/catelist',params)
}

export function getLabel() {
    return request.get('blog/labellist')
}
	/**
	 * 帖子点赞
	 */
	export const postTolikelApi = (data) => {
	  return request.post('blog/tie/tolike',{
	    ...data
	  })
	}
	
	export const postTieApi = (data) => {
	  return request.post('blog/tie/post',{
	    ...data
	  })
	}
	
	export function delTieApi(params: Record<string, any>) {
	    return request.post(`blog/tie/del/`+params.id)
	}
	
	export function getConfigApi(params: Record<string, any>) {
	    return request.post('blog/config', params)
	}
	export function upheadimgApi(params: Record<string, any>) {
	    return request.post('blog/upheadimg', params)
	}
	
	