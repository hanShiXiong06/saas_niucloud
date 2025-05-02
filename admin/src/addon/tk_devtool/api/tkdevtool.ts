import request from '@/addon/tk_devtool/utils/tkdevtoolrequest'


/***************************************************** DEVTOOL接口 ****************************************************/
export function addonUpload(params: Record<string, any>) {
    return request.post(`tk_devtool/addonupload`, params)
}
export function build(key) {
    return request.get(`tk_devtool/build/${key}`)
}


/**
 * 获取git配置
 * @param params
 * @returns
 */
export function getGitConfig(params: Record<string, any>) {
    return request.get(`tk_devtool/getconfig`, { params })
}
/**
 * 设置git配置
 * @param params
 * @returns
 */
export function setGitConfig(params: Record<string, any>) {
    return request.post(`tk_devtool/setconfig`, params, { showSuccessMessage: true })
}
/**
 * 初始仓库
 * @param params
 * @returns
 */
export function doSetGit(params: Record<string, any>) {
    return request.post(`tk_devtool/setgit`, params, { showSuccessMessage: true })
}
/**
 * 强制拉取
 * @param params
 * @returns
 */
export function doGitforce(params: Record<string, any>) {
    return request.post(`tk_devtool/gitforce`, params, { showSuccessMessage: true })
}
/**
 * 拉取更新
 * @param params
 * @returns
 */
export function doGitupdate(params: Record<string, any>) {
    return request.post(`tk_devtool/gitupdate`, params, { showSuccessMessage: true })
}
/**
 * 更新数据库
 * @param params
 * @returns
 */
export function doUpdatesql(params: Record<string, any>) {
    return request.post(`tk_devtool/updatesql`, params, { showSuccessMessage: true })
}
/**
 * 执行命令接口
 * @param params
 * @returns
 */
export function doExecute(params: Record<string, any>) {
    return request.post(`tk_devtool/execute`, params, { showSuccessMessage: true })
}
export function asyncBuild() {
    return request.get(`tk_devtool/asyncbuild`, { showErrorMessage: true, showSuccessMessage: true })
}
export function checkBuild() {
    return request.get(`tk_devtool/checkbuild`)
}
/**
 * 初始文件
 * @param params
 * @returns
 */
export function moveFile(params: Record<string, any>) {
    return request.post(`tk_devtool/moveFile`, params, { showSuccessMessage: true })
}

/**
 * 合并uni-app-cli依赖
 * @param params
 * @returns
 */
export function depend(params: Record<string, any>) {
    return request.post(`tk_devtool/depend`, params, { showSuccessMessage: true })
}
/**
 * 合并uni-app-cli依赖
 * @param params
 * @returns
 */
export function doasyncadmin(params: Record<string, any>) {
    return request.post(`tk_devtool/asyncadmin`, params, { showSuccessMessage: true })
}
/**
 * 数据库表
 */
export function getTables() {
    return request.get(`tk_devtool/gettables`)
}
/**
 * 更新/新增数据库表
 */
export function updateTable(params: Record<string, any>) {
    return request.post(`tk_devtool/updatetable`, params, { showSuccessMessage: true })
}
/**
 * 删除数据表
 */
export function deleteTable(params: Record<string, any>) {
    return request.post(`tk_devtool/deletetable`, params, { showSuccessMessage: true })
}
/**
 * 获取数据表详情
 */
export function getTableInfo(params: Record<string, any>) {
    return request.post(`tk_devtool/gettableinfo`, params)
}
/**
 * 备份数据库
 */
export function backupDatabase() {
    return request.get(`tk_devtool/backupdatabase`, { showSuccessMessage: true })
}
/**
 * 导出表
 */
export function exportTable(params: Record<string, any>) {
    return request.post(`tk_devtool/exporttable`, params, { showSuccessMessage: true })
}
/**
 * 导出文本
 */
export function exportTableText(params: Record<string, any>) {
    return request.post(`tk_devtool/exporttabletext`, params)
}