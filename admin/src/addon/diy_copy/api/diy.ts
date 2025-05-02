import request from '@/utils/request'


export function outTxt(id: number) {
    return request.get(`diy_copy/out/${id}`)
}

export function importTxt(params: Record<string, any>) {
    return request.post('diy_copy/importtxt', params, { showErrorMessage: true, showSuccessMessage: true })
}
