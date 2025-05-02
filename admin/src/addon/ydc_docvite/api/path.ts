import request from "@/utils/request";

export function getIndex(params = {}) {
  return request.get(`ydc_docvite/path/index`, { params });
}

export function selectTree(params = {}) {
  return request.post(`ydc_docvite/path/selectTree`, params);
}

export function add(params: Record<string, any>) {
  return request.post("ydc_docvite/path/add", params, {
    showSuccessMessage: true,
  });
}

export function del(params: Record<string, any>) {
  return request.post("ydc_docvite/path/del", params, {
    showSuccessMessage: true,
  });
}

export function edit(params: Record<string, any>) {
  return request.post("ydc_docvite/path/edit", params, {
    showSuccessMessage: true,
  });
}