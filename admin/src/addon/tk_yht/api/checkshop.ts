
import request from '@/addon/tk_yht/utils/request'

/**
 * 验证shop文件
 * @returns
 */
export function checkShop() {
    return request.get('tk_yht/checkshop')
}