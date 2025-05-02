
import request from '@/utils/request'

export function getIndex(params = {}) {
  return request.get(`ydc_docvite/markdown/index`, {params});
}

export function getDetail(params = {}) {
  return request.get(`ydc_docvite/markdown/detail`, { params });
}

export function add(params: Record<string, any>) {
    return request.post('ydc_docvite/markdown/add', params, {showSuccessMessage: true})
}

export function del(params: Record<string, any>) {
  return request.post("ydc_docvite/markdown/del", params, {
    showSuccessMessage: true,
  });
}

export function edit(params: Record<string, any>) {
  return request.post("ydc_docvite/markdown/edit", params, {
    showSuccessMessage: true,
  });
}

export function publish(params: Record<string, any>) {
  return request.get("ydc_docvite/markdown/publish", { params });
}