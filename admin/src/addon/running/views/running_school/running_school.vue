<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addRunningSchool') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="runningSchoolTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="runningSchoolTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="runningSchoolTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option
                                v-for="(item, index) in statusList"
                                :key="index"
                                :label="item.name"
                                :value="item.value"
                            />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="runningSchoolTable.searchParam.create_time" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('updateTime')" prop="update_time">
                        <el-date-picker v-model="runningSchoolTable.searchParam.update_time" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadRunningSchoolList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="runningSchoolTable.data" size="large" v-loading="runningSchoolTable.loading">
                    <template #empty>
                        <span>{{ !runningSchoolTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="address" :label="t('address')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <div v-if="item.value == row.status">{{ item.name }}</div>
                            </div>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="create_time" :label="t('createTime')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="update_time" :label="t('updateTime')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="runningSchoolTable.page" v-model:page-size="runningSchoolTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="runningSchoolTable.total"
                        @size-change="loadRunningSchoolList()" @current-change="loadRunningSchoolList" />
                </div>
            </div>

            <edit ref="editRunningSchoolDialog" @complete="loadRunningSchoolList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getRunningSchoolList, deleteRunningSchool } from '@/addon/running/api/running_school'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/running/views/running_school/components/running-school-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let runningSchoolTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "name":"",
      "address":"",
      "status":"",
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
 * 获取学校信息列表
 */
const loadRunningSchoolList = (page: number = 1) => {
    runningSchoolTable.loading = true
    runningSchoolTable.page = page

    getRunningSchoolList({
        page: runningSchoolTable.page,
        limit: runningSchoolTable.limit,
         ...runningSchoolTable.searchParam
    }).then(res => {
        runningSchoolTable.loading = false
        runningSchoolTable.data = res.data.data
        runningSchoolTable.total = res.data.total
    }).catch(() => {
        runningSchoolTable.loading = false
    })
}
loadRunningSchoolList()

const editRunningSchoolDialog: Record<string, any> | null = ref(null)

/**
 * 添加学校信息
 */
const addEvent = () => {
    editRunningSchoolDialog.value.setFormData()
    editRunningSchoolDialog.value.showDialog = true
}

/**
 * 编辑学校信息
 * @param data
 */
const editEvent = (data: any) => {
    editRunningSchoolDialog.value.setFormData(data)
    editRunningSchoolDialog.value.showDialog = true
}

/**
 * 删除学校信息
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('runningSchoolDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteRunningSchool(id).then(() => {
            loadRunningSchoolList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadRunningSchoolList()
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
