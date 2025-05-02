import request from '@/utils/request';

export const getConfigApi = (data: any) => request.post("seafox_pay/part/getCashRegisterConfig",data)  

export const setConfigApi = (data: any) => request.post("seafox_pay/part/setCashRegisterConfig", data)
