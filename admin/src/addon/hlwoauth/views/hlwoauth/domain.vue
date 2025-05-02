<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{ pageName }}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addDomain') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="domainTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="domainTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('scope')" prop="scope">
                        <el-select class="w-[280px]" v-model="domainTable.searchParam.scope" clearable :placeholder="t('scopePlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option v-for="(item, index) in scopeList" :key="index" :label="item.name" :value="item.value" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="domainTable.searchParam.status" clearable
                            :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option v-for="(item, index) in statusList" :key="index" :label="item.name"
                                :value="item.value" />
                        </el-select>
                    </el-form-item>

                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="domainTable.searchParam.create_time" type="datetimerange"
                            format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadDomainList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="domainTable.data" size="large" v-loading="domainTable.loading">
                    <template #empty>
                        <span>{{ !domainTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <!-- <el-table-column prop="id" :label="t('id')" min-width="50" :show-overflow-tooltip="true" /> -->

                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true" />
                    <el-table-column prop="scope" :label="t('scope')" min-width="120" :show-overflow-tooltip="true" >
                        <template #default="{ row }">
                            <div v-for="(item, index) in scopeList">
                                <el-tag v-if="item.value == 'snsapi_base' && row.scope == item.value" type="info">{{ item.name }}</el-tag>
                                <el-tag v-if="item.value == 'snsapi_userinfo' && row.scope == item.value">{{ item.name }}</el-tag>
                            </div>
                        </template>
                    </el-table-column>

                    <el-table-column prop="domain" :label="t('domain')" min-width="300" :show-overflow-tooltip="true" />

                    <el-table-column prop="auth_url" :label="t('authUrl')" min-width="390" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-input readonly :value="row.auth_url" class="!w-[390px]">
                                <template #append>
                                    <el-button @click="copyEvent(row.auth_url)" class="bg-primary copy">{{ t('copy')
                                        }}</el-button>
                                </template>
                            </el-input>
                        </template>
                    </el-table-column>

                    <el-table-column prop="number" :label="t('number')" align="center" min-width="80" :show-overflow-tooltip="true" />

                    <el-table-column :label="t('status')" min-width="100" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <el-tag v-if="item.value == '1' && row.status == item.value" type="primary">{{ item.name }}</el-tag>
                                <el-tag v-if="item.value == '0' && row.status == item.value" type="danger">{{ item.name }}</el-tag>
                            </div>
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('createTime')" min-width="180" align="center"
                        :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            {{ row.create_time || '' }}
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                            <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="domainTable.page" v-model:page-size="domainTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="domainTable.total"
                        @size-change="loadDomainList()" @current-change="loadDomainList" />
                </div>
            </div>

            <edit ref="editDomainDialog" @complete="loadDomainList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getDomainList, deleteDomain } from '@/addon/hlwoauth/api/hlwoauth'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance, ElMessage } from 'element-plus'
import Edit from '@/addon/hlwoauth/views/hlwoauth/components/domain-edit.vue'
import { useRoute } from 'vue-router'

import { useClipboard } from '@vueuse/core'
const route = useRoute()
const pageName = route.meta.title
// 复制
const { copy, isSupported } = useClipboard()
const copyEvent = (text: string) => {
    if (!isSupported.value) {
        ElMessage({
            message: t('notSupportCopy'),
            type: 'warning'
        })
    }
    copyToClipboard(text)
}

const domainTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        name: '',
        number: '',
        scope: '',
        status: '',
        create_time: []
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
const statusList = ref([
    {
        value: '1',
        name: '启用'
    },
    {
        value: '0',
        name: '禁用'
    }
])

const scopeList = ref([
    {
        value:'snsapi_base',
        name: '静默授权'
    },
    {
        value:'snsapi_userinfo',
        name: '弹出授权'
    }
])

/**
 * 获取域名授权列表
 */
const loadDomainList = (page: number = 1) => {
    domainTable.loading = true
    domainTable.page = page

    getDomainList({
        page: domainTable.page,
        limit: domainTable.limit,
        ...domainTable.searchParam
    }).then(res => {
        domainTable.loading = false
        domainTable.data = res.data.data
        domainTable.total = res.data.total
    }).catch(() => {
        domainTable.loading = false
    })
}
loadDomainList()

const editDomainDialog: Record<string, any> | null = ref(null)

/**
 * 添加域名授权
 */
const addEvent = () => {
    editDomainDialog.value.setFormData()
    editDomainDialog.value.showDialog = true
}

/**
 * 编辑域名授权
 * @param data
 */
const editEvent = (data: any) => {
    editDomainDialog.value.setFormData(data)
    editDomainDialog.value.showDialog = true
}

/**
 * 删除域名授权
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('domainDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning'
        }
    ).then(() => {
        deleteDomain(id).then(() => {
            loadDomainList()
        }).catch(() => {
        })
    })
}

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadDomainList()
}

const copyToClipboard=(text:string)=> {
  var textarea = document.createElement('textarea');
  textarea.style.position = 'fixed';
  textarea.style.opacity = '0';
  textarea.value = text;
  document.body.appendChild(textarea);
  textarea.select();
  document.execCommand('copy');
  document.body.removeChild(textarea);
  ElMessage({
    message: '复制成功',
    type: 'success'
})
}
</script>

<style lang="scss" scoped>
/* 多行超出隐藏 */
.multi-hidden {
    word-break: break-all;
    text-overflow: ellipsis;
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}
</style>
