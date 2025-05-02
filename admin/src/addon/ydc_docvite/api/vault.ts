import request from "@/utils/request";

export function getIndex(params = {}) {
  return request.get(`ydc_docvite/vault/index`, { params });
}

export function selectTree(params = {}) {
  return request.post(
    `ydc_docvite/vault/selectTree`,
    Object.assign(
      params,
      Object.assign(
        {
          tree: 1,
        },
        params
      )
    )
  );
}

export function select(params = {}) {
  return request.get(`ydc_docvite/vault/select`, { params });
}

export function add(params: Record<string, any>) {
  return request.post("ydc_docvite/vault/add", params, {
    showSuccessMessage: true,
  });
}

export function del(params: Record<string, any>) {
  return request.post("ydc_docvite/vault/del", params, {
    showSuccessMessage: true,
  });
}

export function publish(params: Record<string, any>) {
  return request.post("ydc_docvite/vault/publish", params, {
    showSuccessMessage: false,
  });
}

export function clearPublish(params: Record<string, any>) {
  return request.post("ydc_docvite/vault/clearPublish", params, {
    showSuccessMessage: false,
  });
}

export function pullPublishStatus(params = {}) {
  return request.get("ydc_docvite/vault/pullPublishStatus", { params });
}

export function edit(params: Record<string, any>) {
  return request.post("ydc_docvite/vault/edit", params, {
    showSuccessMessage: true,
  });
}
