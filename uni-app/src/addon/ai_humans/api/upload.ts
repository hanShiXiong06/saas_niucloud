
import request from '@/utils/request'

/***************************************************** 上传音频接口独立 ****************************************************/

export function uploadVoiceApi(data: AnyObject) {
    return request.upload('ai_humans/upload/voice', data, { showErrorMessage: true })
}
