import request from "@/utils/request";

export function getIndex(params = {}) {
  return request.get(`ydc_docvite/config/index`, { params });
}

export function edit(params: Record<string, any>) {
  return request.post("ydc_docvite/config/edit", params, {
    showSuccessMessage: true,
  });
}
