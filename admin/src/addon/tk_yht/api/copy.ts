
import request from '@/addon/tk_yht/utils/request'

/**
 * 商品采集
 * @returns
 */
export function copyGoods(params) {
    return request.post('tk_yht/copygoods', params)
}
