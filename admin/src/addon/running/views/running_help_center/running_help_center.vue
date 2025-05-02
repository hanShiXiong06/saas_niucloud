<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addRunningHelpCenter') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="runningHelpCenterTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('title')" prop="title">
                        <el-input v-model="runningHelpCenterTable.searchParam.title" :placeholder="t('titlePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('content')" prop="content">
                        <el-input v-model="runningHelpCenterTable.searchParam.content" :placeholder="t('contentPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="runningHelpCenterTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option
                                v-for="(item, index) in statusList"
                                :key="index"
                                :label="item.name"
                                :value="item.value"
                            />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('sort')" prop="sort">
                        <el-input v-model="runningHelpCenterTable.searchParam.sort" :placeholder="t('sortPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-input v-model="runningHelpCenterTable.searchParam.create_time" :placeholder="t('createTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-input v-model="runningHelpCenterTable.searchParam.update_time" :placeholder="t('updateTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadRunningHelpCenterList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="runningHelpCenterTable.data" size="large" v-loading="runningHelpCenterTable.loading">
                    <template #empty>
                        <span>{{ !runningHelpCenterTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="title" :label="t('title')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="content" :label="t('content')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <div v-if="item.value == row.status">{{ item.name }}</div>
                            </div>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="runningHelpCenterTable.page" v-model:page-size="runningHelpCenterTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="runningHelpCenterTable.total"
                        @size-change="loadRunningHelpCenterList()" @current-change="loadRunningHelpCenterList" />
                </div>
            </div>

            <edit ref="editRunningHelpCenterDialog" @complete="loadRunningHelpCenterList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getRunningHelpCenterList, deleteRunningHelpCenter } from '@/addon/running/api/running_help_center'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/running/views/running_help_center/components/running-help-center-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let runningHelpCenterTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "title":"",
      "content":"",
      "status":"",
      "sort":"",
      "create_time":"",
      "update_time":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    const statusList = ref([] as any[])
    const statusDictList = async () => {
    statusList.value = await (await useDictionary('status')).data.dictionary
    }
    statusDictList();

/**
 * 获取帮助中心列表
 */
const loadRunningHelpCenterList = (page: number = 1) => {
    runningHelpCenterTable.loading = true
    runningHelpCenterTable.page = page

    getRunningHelpCenterList({
        page: runningHelpCenterTable.page,
        limit: runningHelpCenterTable.limit,
         ...runningHelpCenterTable.searchParam
    }).then(res => {
        runningHelpCenterTable.loading = false
        runningHelpCenterTable.data = res.data.data
        runningHelpCenterTable.total = res.data.total
    }).catch(() => {
        runningHelpCenterTable.loading = false
    })
}
loadRunningHelpCenterList()

const editRunningHelpCenterDialog: Record<string, any> | null = ref(null)

/**
 * 添加帮助中心
 */
const addEvent = () => {
    editRunningHelpCenterDialog.value.setFormData()
    editRunningHelpCenterDialog.value.showDialog = true
}

/**
 * 编辑帮助中心
 * @param data
 */
const editEvent = (data: any) => {
    editRunningHelpCenterDialog.value.setFormData(data)
    editRunningHelpCenterDialog.value.showDialog = true
}

/**
 * 删除帮助中心
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('runningHelpCenterDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteRunningHelpCenter(id).then(() => {
            loadRunningHelpCenterList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadRunningHelpCenterList()
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
