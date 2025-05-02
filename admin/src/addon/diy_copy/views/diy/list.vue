<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">


            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="diyPageTableData.searchParam" ref="searchFormDiyPageRef">
                    <el-form-item :label="t('title')" prop="title">
                        <el-input v-model.trim="diyPageTableData.searchParam.title" :placeholder="t('titlePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('forAddon')" prop="addon_name">
                        <el-select v-model="diyPageTableData.searchParam.addon_name" :placeholder="t('forAddonPlaceholder')" @change="handleSelectAddonChange">
                            <el-option :label="t('all')" value="" />
                            <el-option v-for="(item, key) in apps" :label="item.title" :value="key" :key="key"/>
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('typeName')" prop="type">
                        <el-select v-model="diyPageTableData.searchParam.type" :placeholder="t('pageTypePlaceholder')">
                            <el-option :label="t('all')" value="" />
                            <el-option v-for="(item, key) in pageType" :label="item.title" :value="key" :key="key"/>
                        </el-select>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadDiyPageList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormDiyPageRef)">{{ t('reset') }}</el-button>
                        <el-upload
                            class="!inline-block ml-2"
                            :show-file-list="false"
                            :auto-upload="false"
                            accept=".txt"
                            @change="handleFileChange">
                            <el-button type="primary">导入页面</el-button>
                        </el-upload>
                    </el-form-item>
                </el-form>
            </el-card>

            <el-table :data="diyPageTableData.data" size="large" v-loading="diyPageTableData.loading">
                <template #empty>
                    <span>{{ !diyPageTableData.loading ? t('emptyData') : '' }}</span>
                </template>

                <el-table-column prop="page_title" :label="t('title')" min-width="120" />
                <el-table-column prop="addon_name" :label="t('forAddon')" min-width="80" />
                <el-table-column prop="type_name" :label="t('typeName')" min-width="80" />
                <el-table-column :label="t('status')" min-width="80">
                    <template #default="{ row }">
                        <span v-if="row.type == 'DIY_PAGE'">-</span>
                        <template v-else>
                            <span v-if="row.is_default == 1" class="text-primary">{{ t('isUse') }}</span>
                            <span v-else>{{ t('unused') }}</span>
                        </template>
                    </template>
                </el-table-column>
                <el-table-column prop="update_time" :label="t('updateTime')" min-width="120" />

                <el-table-column :label="t('operation')" fixed="right" align="right" min-width="160">
                    <template #default="{ row }">
                        <el-button type="primary" link @click="toPreview(row)">{{ t('preview') }}</el-button>
                        <el-button v-if="row.is_default == 0" type="primary" link @click="setUse(row.id)">{{ t('use') }}</el-button>

                        <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                      
                        <el-button type="primary" link @click="copyEvent(row.id)">{{ t('copy') }}</el-button>
                        <el-button type="primary" link @click="exportEvent(row.id)">导出页面</el-button>
                    </template>
                </el-table-column>

            </el-table>
            <div class="mt-[16px] flex justify-end">
                <el-pagination v-model:current-page="diyPageTableData.page" v-model:page-size="diyPageTableData.limit"
                    layout="total, sizes, prev, pager, next, jumper" :total="diyPageTableData.total"
                    @size-change="loadDiyPageList()" @current-change="loadDiyPageList" />
            </div>

        </el-card>

        <!--添加页面-->
    

    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, computed } from 'vue'
import { t } from '@/lang'
import { getApps,getDiyPageList, deleteDiyPage, getDiyTemplate, editDiyPageShare, setUseDiyPage,copyDiy } from '@/app/api/diy'
import { ElMessageBox, FormInstance, ElMessage, dayOrDaysToDate } from 'element-plus'
import { useRoute, useRouter } from 'vue-router'
import {img} from "@/utils/common"
import { setTablePageStorage,getTablePageStorage } from "@/utils/common";
import {outTxt,importTxt} from "@/addon/diy_copy/api/diy"
import axios from 'axios'

const exportEvent = (id: number) => {
    outTxt(id).then(res=>{
        const blob = new Blob([res.data.download_url], { type: 'text/plain;charset=utf-8' })
        const url = window.URL.createObjectURL(blob)
        const link = document.createElement('a')
        link.style.display = 'none'
        link.href = url
        link.setAttribute('download', `page_${id}.txt`)
        document.body.appendChild(link)
        link.click()
        document.body.removeChild(link)
        window.URL.revokeObjectURL(url)
    }).catch(error => {
        console.error('Download error:', error)
    })
}

const route = useRoute()
const router = useRouter()
const pageName = route.meta.title

const pageType: any = reactive({}) // 页面类型

// 添加自定义页面
const formData = reactive({
    title: '',
    type: ''
})

// 表单验证规则
const formRules = computed(() => {
    return {
        title: [
            { required: true, message: t('titlePlaceholder'), trigger: 'blur' }
        ],
        type: [
            { required: true, message: t('pageTypePlaceholder'), trigger: 'blur' }
        ]
    }
})

const formRef = ref<FormInstance>()
const dialogVisible = ref(false)
const addEvent = async (formEl: FormInstance | undefined) => {
    if (!formEl) return

    await formEl.validate(async (valid) => {
        if (valid) {
            const query = { type: formData.type, title: formData.title }
            const url = router.resolve({
                path: '/decorate/edit',
                query
            })
            window.open(url.href)
            dialogVisible.value = false
            formData.title = ''
            formData.type = ''
        }
    })
}

// 获取自定义页面类型
const loadDiyTemplate = (addon = '')=> {
    getDiyTemplate({mode: '', addon}).then(res => {
        for (let key in pageType) {
            delete pageType[key];
        }

        for (const key in res.data) {
            pageType[key] = res.data[key]
        }
    })
}

loadDiyTemplate();

const apps: any = reactive({}) // 应用插件列表

getApps({}).then(res=>{
    if(res.data){
        for (const key in res.data) {
            apps[key] = res.data[key];
        }
    }
});

// 根据所属插件，查询页面类型
const handleSelectAddonChange = (value: any) => {
    diyPageTableData.searchParam.type = '';
    loadDiyTemplate(value)
}

const diyPageTableData: any = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        title: '',
        type: '',
        mode: '',
        addon_name: ''
    }
})

const searchFormDiyPageRef = ref<FormInstance>()

// 获取自定义页面列表
const loadDiyPageList = (page: number = 1) => {
    diyPageTableData.loading = true
    diyPageTableData.page = page

    getDiyPageList({
        page: diyPageTableData.page,
        limit: diyPageTableData.limit,
        ...diyPageTableData.searchParam
    }).then(res => {
        diyPageTableData.loading = false
        diyPageTableData.data = res.data.data
        diyPageTableData.total = res.data.total
        setTablePageStorage(diyPageTableData.page, diyPageTableData.limit, diyPageTableData.searchParam);
    }).catch(() => {
        diyPageTableData.loading = false
    })
}

loadDiyPageList(getTablePageStorage(diyPageTableData.searchParam).page);

// 编辑自定义页面
const editEvent = (data: any) => {
    const url = router.resolve({
        path: '/decorate/edit',
        query: { id: data.id }
    })
    window.open(url.href)
}

// 设为使用
const setUse = (id: any) => {
    setUseDiyPage({id}).then(() => {
        loadDiyPageList()
    })
}
const repeat = ref(false)

// 复制页面
const copyEvent = (id: any) => {
    ElMessageBox.confirm(t('diyPageCopyTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning'
        }
    ).then(() => {
        if (repeat.value) return
        repeat.value = true

        copyDiy({id: id}).then((res: any) => {
            if (res.code == 1) {
                loadDiyPageList()
            }
            repeat.value = false
        }).catch(err => {
            repeat.value = false
        })
    })
}

// 删除自定义页面
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('diyPageDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning'
        }
    ).then(() => {
        deleteDiyPage(id).then(() => {
            loadDiyPageList()
        }).catch(() => {
        })
    })
}

// 跳转去预览
const toPreview = (data: any) => {
    const url = router.resolve({
        path: '/preview/wap',
        query: {
            page: data.type_page + '?id=' + data.id
        }
    });
    window.open(url.href)
}

const tabShareType = ref('wechat')
const sharePage = ref('')
const shareFormId = ref(0)
const shareFormData = reactive({
    wechat: {
        title: '',
        desc: '',
        url: ''
    },
    weapp: {
        title: '',
        url: ''
    }
})

const shareDialogVisible = ref(false)
const shareFormRules = computed(() => {
    return {}
})

const shareFormRef = ref<FormInstance>()
const openShare = async (row: any) => {
    shareFormId.value = row.id
    sharePage.value = row.title
    const share = row.share ? JSON.parse(row.share) : {
        wechat: { title: '', desc: '', url: '' },
        weapp: { title: '', url: '' }
    }
    if (share) {
        shareFormData.wechat = share.wechat
        shareFormData.weapp = share.weapp
    }

    shareDialogVisible.value = true
}

const shareEvent = async (formEl: FormInstance | undefined) => {
    if (!formEl) return

    await formEl.validate(async (valid) => {
        if (valid) {
            editDiyPageShare({
                id: shareFormId.value,
                share: JSON.stringify(shareFormData)
            }).then(() => {
                loadDiyPageList()
                shareDialogVisible.value = false
            }).catch(() => {
            })
        }
    })
}

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadDiyPageList()
}

// 添加文件处理函数
const handleFileChange = (file: any) => {
    const reader = new FileReader()
    reader.onload = (e: any) => {
        try {
            const content = e.target.result
            // 调用导入接口
            importTxt({
                content: content
            }).then(res => {
                if (res.code === 1) {
                    ElMessage.success('导入成功')
                    loadDiyPageList() // 刷新列表
                } else {
                    ElMessage.error(res.msg || '导入失败')
                }
            }).catch(error => {
                ElMessage.error('导入失败')
                console.error('Import error:', error)
            })
        } catch (error) {
            ElMessage.error('文件解析失败')
            console.error('Parse error:', error)
        }
    }
    reader.readAsText(file.raw)
}

</script>

<style lang="scss" scoped></style>
