<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addRunningExpressSite') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="runningExpressSiteTable.searchParam" ref="searchFormRef">
                    
                    <el-form-item :label="t('schoolId')" prop="school_id">
                        <el-select class="w-[280px]" v-model="runningExpressSiteTable.searchParam.school_id" clearable :placeholder="t('schoolIdPlaceholder')">
                           <el-option
                                       v-for="(item, index) in schoolIdList"
                                       :key="index"
                                       :label="item['name']"
                                       :value="item['id']"
                                   />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="runningExpressSiteTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('address')" prop="address">
                        <el-input v-model="runningExpressSiteTable.searchParam.address" :placeholder="t('addressPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="runningExpressSiteTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option
                                v-for="(item, index) in statusList"
                                :key="index"
                                :label="item.name"
                                :value="item.value"
                            />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadRunningExpressSiteList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="runningExpressSiteTable.data" size="large" v-loading="runningExpressSiteTable.loading">
                    <template #empty>
                        <span>{{ !runningExpressSiteTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="school_id_name" :label="t('schoolId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="address" :label="t('address')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <div v-if="item.value == row.status">{{ item.name }}</div>
                            </div>
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
                    <el-pagination v-model:current-page="runningExpressSiteTable.page" v-model:page-size="runningExpressSiteTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="runningExpressSiteTable.total"
                        @size-change="loadRunningExpressSiteList()" @current-change="loadRunningExpressSiteList" />
                </div>
            </div>

            <edit ref="editRunningExpressSiteDialog" @complete="loadRunningExpressSiteList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getRunningExpressSiteList, deleteRunningExpressSite, getWithRunningSchoolList } from '@/addon/running/api/running_express_site'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/running/views/running_express_site/components/running-express-site-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let runningExpressSiteTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "school_id":"",
      "name":"",
      "address":"",
      "status":""
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
 * 获取快递站点列表
 */
const loadRunningExpressSiteList = (page: number = 1) => {
    runningExpressSiteTable.loading = true
    runningExpressSiteTable.page = page

    getRunningExpressSiteList({
        page: runningExpressSiteTable.page,
        limit: runningExpressSiteTable.limit,
         ...runningExpressSiteTable.searchParam
    }).then(res => {
        runningExpressSiteTable.loading = false
        runningExpressSiteTable.data = res.data.data
        runningExpressSiteTable.total = res.data.total
    }).catch(() => {
        runningExpressSiteTable.loading = false
    })
}
loadRunningExpressSiteList()

const editRunningExpressSiteDialog: Record<string, any> | null = ref(null)

/**
 * 添加快递站点
 */
const addEvent = () => {
    editRunningExpressSiteDialog.value.setFormData()
    editRunningExpressSiteDialog.value.showDialog = true
}

/**
 * 编辑快递站点
 * @param data
 */
const editEvent = (data: any) => {
    editRunningExpressSiteDialog.value.setFormData(data)
    editRunningExpressSiteDialog.value.showDialog = true
}

/**
 * 删除快递站点
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('runningExpressSiteDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteRunningExpressSite(id).then(() => {
            loadRunningExpressSiteList()
        }).catch(() => {
        })
    })
}

    
    const schoolIdList = ref([])
    const setSchoolIdList = async () => {
    schoolIdList.value = await (await getWithRunningSchoolList({})).data
    }
    setSchoolIdList()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadRunningExpressSiteList()
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
