
import request from '@/utils/request'

/***************************************************** hello world ****************************************************/
export function getLevelList() {
    return request.get(`tk_partner/level`)
}

