<template>
    <!--代码生成-->
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-page-title">{{ pageName }}</span>
            </div>

            <el-tabs v-model="activeName" class="mt-[20px]">
                <el-tab-pane :label="t('codeGeneration')" name="codeGeneration">
                    <el-steps :active="5" direction="vertical">
                        <el-step>
                            <template #title>
                                <p class="text-[14px] font-[700]">
                                    {{ t("step1") }}
                                </p>
                            </template>
                            <template #description>
                                <span class="text-[#999]">{{ t("describe1") }}</span>
                                <div class="mt-[20px] mb-[40px] h-[32px]">
                                    <el-button type="primary" class="w-[100px]" @click="addEvent">{{ t('btn1') }}</el-button>
                                </div>
                            </template>
                        </el-step>

                        <el-step>
                            <template #title>
                                <p class="text-[14px] font-[700]">
                                    {{ t("step2") }}
                                </p>
                            </template>
                            <template #description>
                                <span class="text-[#999]">{{ t("describe2") }}</span>
                                <div class="mt-[20px] mb-[40px] h-[32px]"></div>
                            </template>
                        </el-step>

                        <el-step>
                            <template #title>
                                <p class="text-[14px] font-[700]">
                                    {{ t("step3") }}
                                </p>
                            </template>
                            <template #description>
                                <span class="text-[#999]">{{ t("describe3") }}</span>
                                <div class="mt-[20px] mb-[40px] h-[32px]"></div>
                            </template>
                        </el-step>

                        <el-step>
                            <template #title>
                                <p class="text-[14px] font-[700]">
                                    {{ t("step4") }}
                                </p>
                            </template>
                            <template #description>
                                <span class="text-[#999]">{{ t("describe4") }}</span>
                                <div class="mt-[20px] mb-[40px] h-[32px]"></div>
                            </template>
                        </el-step>

                        <el-step>
                            <template #title>
                                <p class="text-[14px] font-[700]">
                                    {{ t("step5") }}
                                </p>
                            </template>
                            <template #description>
                                <span class="text-[#999]">{{ t("describe5") }}</span>
                                <div class="mt-[20px] mb-[40px] h-[32px]"></div>
                            </template>
                        </el-step>
                    </el-steps>
                </el-tab-pane>
                <el-tab-pane :label="t('codeList')" name="codeList">
                    <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                        <el-form :inline="true" :model="codeTableData.searchParam" ref="searchFormRef">
                             <el-form-item :label="t('addonName')" prop="addon_name">
                                <el-select v-model="codeTableData.searchParam.addon_name" placeholder="全部" filterable remote clearable :remote-method="getAddonDevelopFn">
                                    <el-option label="全部" value="" />
                                    <el-option label="系统" value="2" />
                                    <el-option :label="item.title" :value="item.key" v-for="item in addonList" :key="item.key" />
                                </el-select>
                            </el-form-item>

                            <el-form-item :label="t('tableName')" prop="table_name">
                                <el-input v-model.trim="codeTableData.searchParam.table_name" :placeholder="t('tableNamePlaceholder')" />
                            </el-form-item>
                            <el-form-item>
                                <el-button type="primary" @click="loadGenerateTableList()">{{ t('search') }}</el-button>
                                <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                            </el-form-item>
                        </el-form>
                    </el-card>
                    <div>
                        <el-table :data="codeTableData.data" size="large" v-loading="codeTableData.loading">

                            <template #empty>
                                <span>{{ !codeTableData.loading ? t('emptyData') : '' }}</span>
                            </template>

                            <el-table-column prop="table_name" :show-overflow-tooltip="true" :label="t('tableName')" min-width="120" />
                            <el-table-column prop="title" :show-overflow-tooltip="true" :label="t('addonName')" min-width="120" />
                            <el-table-column prop="table_content" :show-overflow-tooltip="true" :label="t('tableContent')" min-width="120" />

                            <el-table-column prop="edit_type" :label="t('editType')" min-width="150" align="center">
                                <template #default="{ row }">
                                    {{ row.edit_type == 1 ? t('popup') : t('page') }}
                                </template>
                            </el-table-column>

                            <el-table-column :label="t('createTime')" min-width="180" align="center">
                                <template #default="{ row }">
                                    {{ row.create_time || '' }}
                                </template>
                            </el-table-column>

                            <el-table-column :label="t('operation')" fixed="right" align="right" width="330">
                                <template #default="{ row }">
                                    <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                                    <el-button type="primary" link @click="generatePreviewFn(row.id)">{{ t('preview') }}</el-button>
                                    <el-button type="primary" link @click="generatorCheckFileFn(row.id)">{{ t('saveAndSync') }}</el-button>
                                    <el-button type="primary" link @click="generateCreateFn(row.id, 2)">{{ t('download') }}</el-button>
                                    <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                                </template>
                            </el-table-column>

                        </el-table>
                        <div class="mt-[16px] flex justify-end">
                            <el-pagination v-model:current-page="codeTableData.page" v-model:page-size="codeTableData.limit"
                                layout="total, sizes, prev, pager, next, jumper" :total="codeTableData.total"
                                @size-change="loadGenerateTableList()" @current-change="loadGenerateTableList" />
                        </div>
                    </div>
                </el-tab-pane>
            </el-tabs>

            <add-table ref="addCodeDialog" />

            <el-dialog v-model="dialogVisible" class="dialog-visible" width="70%" title="代码预览">
                <div class="flex h-[50vh]" v-loading="codeLoading">
                    <el-scrollbar class="h-[100%] w-[270px]">
                        <el-tree v-if="treeData.length && treeKey != ''" :data="treeData" :props="{ label: 'name', value: 'key' }"
                            node-key="key" :current-node-key="treeKey" :expand-on-click-node="false" highlight-current
                            default-expand-all ref="treeRef" @node-click="nodeClick">
                            <template #default="{ node, data }">
                                <div class="flex items-center">
                                    <el-icon v-if="data.children">
                                        <Folder v-if="!node.expanded" />
                                        <FolderOpened v-else />
                                    </el-icon>
                                    <el-icon v-else>
                                        <Document />
                                    </el-icon>
                                    <span class="pl-[5px]">{{ data.name }}</span>
                                </div>

                            </template>
                        </el-tree>
                    </el-scrollbar>
                    <div class="ml-[20px]" style="width: calc(100% - 285px);">
                        <el-scrollbar class="h-[100%] w-[100%]">
                            <highlightjs autodetect class="h-[100%]" :code="code" />
                        </el-scrollbar>
                    </div>
                </div>
            </el-dialog>
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, onMounted } from 'vue'
import { t } from '@/lang'
import { getGenerateTableList, deleteGenerateTable, generateCreate, generatePreview, generatorCheckFile, getAddonDevelop } from '@/app/api/tools'
import { img,setTablePageStorage,getTablePageStorage } from '@/utils/common'
import { ElMessageBox, ElMessage } from 'element-plus'
import AddTable from '@/app/views/tools/code/components/add-table.vue'
import type { FormInstance } from 'element-plus'
import { useRouter, useRoute } from 'vue-router'

const route = useRoute()
const pageName = route.meta.title

const router = useRouter()
const activeName = ref('codeGeneration')
const codeTableData = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        table_name: '',
        table_content: '',
        addon_name: ''
    }
})

const searchFormRef = ref<FormInstance>()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return

    formEl.resetFields()
    loadGenerateTableList()
}
onMounted(() => {
    if (window.codeActiveName) {
        activeName.value = window.codeActiveName + ''
        window.codeActiveName = null
    }
    loadGenerateTableList(getTablePageStorage(codeTableData.searchParam).page)
})
/**
 * 获取代码生成列表
 */
const loadGenerateTableList = (page: number = 1) => {
    codeTableData.loading = true
    codeTableData.page = page

    getGenerateTableList({
        page: codeTableData.page,
        limit: codeTableData.limit,
        ...codeTableData.searchParam
    }).then(res => {
        codeTableData.loading = false
        codeTableData.data = res.data.data
        codeTableData.total = res.data.total
        setTablePageStorage(codeTableData.page, codeTableData.limit, codeTableData.searchParam);
    }).catch(() => {
        codeTableData.loading = false
    })
}

const addonList = ref<Array<any>>([])
// 获取插件远程搜索
const getAddonDevelopFn = (search: string) => {
    getAddonDevelop({ search }).then(res => {
        addonList.value = res.data
    })
}

const addCodeDialog: Record<string, any> | null = ref(null)

/**
 * 添加代码生成
 */
const addEvent = () => {
    addCodeDialog.value.setFormData()
    addCodeDialog.value.showDialog = true
}

/**
 * 删除代码生成
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('codeDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning'
        }
    ).then(() => {
        deleteGenerateTable(id).then(() => {
            loadGenerateTableList()
        }).catch(() => {
        })
    })
}

/**
 * 编辑
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/tools/code/edit?id=' + data.id)
}

/**
 * 同步校验
 */
const generatorCheckFileFn = ((id: any) => {
    generatorCheckFile({ id }).then((res: any) => {
        codeTableData.loading = false
        ElMessageBox.confirm(
                res.msg != '2' ? t('saveAndSyncText') : t('saveAndSyncText1'),
                t('warning'),
                {
                    confirmButtonText: t('confirm'),
                    cancelButtonText: t('cancel')
                }
        ).then(() => {
            generateCreateFn(id, 3)
        }).catch(() => {
        })
    }).catch(() => {
        codeTableData.loading = false
    })
})

/**
 * 同步or下载
 */
const generateCreateFn = (id: any, generate_type: any) => {
    codeTableData.loading = true
    generateCreate({ id, generate_type }).then(res => {
        ElMessage({
            type: 'success',
            message: '操作成功'
        })
        if (generate_type != 3) {
            codeTableData.loading = false
            window.open(img(res.data.file), '_blank')
        } else {
            loadGenerateTableList()
        }
    }).catch(() => {
        codeTableData.loading = false
    })
}

/*
*代码预览
*/
const previewList = ref<Array<any>>([])
const dialogVisible = ref<boolean>(false)
const treeData = ref([])
const codeLoading = ref(false)
const code = ref('')
const treeKey = ref('')
const generatePreviewFn = (id: number) => {
    dialogVisible.value = true
    codeLoading.value = true
    code.value = ''
    treeData.value = []
    treeKey.value = ''
    generatePreview(id).then(res => {
        previewList.value = res.data
        treeData.value = listToTree(res.data.map((el:any) => el.file_dir + el.name))
        code.value = previewList.value[0].content
        codeLoading.value = false
    }).catch(() => {
        codeLoading.value = false
    })
}

const nodeClick = (node: { path: any }) => {
    previewList.value.forEach(el => {
        if (node.path === el.file_dir + el.name) code.value = el.content
    })
}
const listToTree = (arr:any) => {
    const ret: any[] = []
    if (Array.isArray(arr)) {
        for (let i = 0; i < arr.length; ++i) {
            const path = arr[i].split('/')
            let _ret = ret
            for (let j = 0; j < path.length; ++j) {
                const name = path[j]
                let obj = null
                for (var k = 0; k < _ret.length; ++k) {
                    const _obj = _ret[k]
                    if (_obj.name === name) {
                        obj = _obj
                        break
                    }
                }
                if (!obj) {
                    obj = { name: name, path: name.indexOf('.') < 0 ? '' : arr[i], key: 'k' + i + j + k }
                    if (name.indexOf('.') < 0) obj.children = []
                    if (obj.path === arr[0]) treeKey.value = obj.key
                    _ret.push(obj)
                }
                if (obj.children) _ret = obj.children
            }
        }
    }
    return ret
}
</script>

<style lang="scss" scoped></style>
