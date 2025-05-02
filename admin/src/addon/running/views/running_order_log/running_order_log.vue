<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addRunningOrderLog') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="runningOrderLogTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('orderId')" prop="order_id">
                        <el-input v-model="runningOrderLogTable.searchParam.order_id" :placeholder="t('orderIdPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('status')" prop="status">
                        <el-select class="w-[280px]" v-model="runningOrderLogTable.searchParam.status" clearable :placeholder="t('statusPlaceholder')">
                            <el-option label="全部" value=""></el-option>
                            <el-option
                                v-for="(item, index) in statusList"
                                :key="index"
                                :label="item.name"
                                :value="item.value"
                            />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('remark')" prop="remark">
                        <el-input v-model="runningOrderLogTable.searchParam.remark" :placeholder="t('remarkPlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('operatorId')" prop="operator_id">
                        <el-select class="w-[280px]" v-model="runningOrderLogTable.searchParam.operator_id" clearable :placeholder="t('operatorIdPlaceholder')">
                           <el-option
                                       v-for="(item, index) in operatorIdList"
                                       :key="index"
                                       :label="item['username']"
                                       :value="item['member_id']"
                                   />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="runningOrderLogTable.searchParam.create_time" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadRunningOrderLogList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="runningOrderLogTable.data" size="large" v-loading="runningOrderLogTable.loading">
                    <template #empty>
                        <span>{{ !runningOrderLogTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="order_id" :label="t('orderId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('status')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <div v-for="(item, index) in statusList">
                                <div v-if="item.value == row.status">{{ item.name }}</div>
                            </div>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="remark" :label="t('remark')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="operator_id_name" :label="t('operatorId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="runningOrderLogTable.page" v-model:page-size="runningOrderLogTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="runningOrderLogTable.total"
                        @size-change="loadRunningOrderLogList()" @current-change="loadRunningOrderLogList" />
                </div>
            </div>

            <edit ref="editRunningOrderLogDialog" @complete="loadRunningOrderLogList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getRunningOrderLogList, deleteRunningOrderLog, getWithMemberList } from '@/addon/running/api/running_order_log'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/running/views/running_order_log/components/running-order-log-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let runningOrderLogTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "order_id":"",
      "status":"",
      "remark":"",
      "operator_id":"",
      "create_time":[]
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    const statusList = ref([] as any[])
    const statusDictList = async () => {
    statusList.value = await (await useDictionary('school_order_status')).data.dictionary
    }
    statusDictList();

/**
 * 获取订单日志列表
 */
const loadRunningOrderLogList = (page: number = 1) => {
    runningOrderLogTable.loading = true
    runningOrderLogTable.page = page

    getRunningOrderLogList({
        page: runningOrderLogTable.page,
        limit: runningOrderLogTable.limit,
         ...runningOrderLogTable.searchParam
    }).then(res => {
        runningOrderLogTable.loading = false
        runningOrderLogTable.data = res.data.data
        runningOrderLogTable.total = res.data.total
    }).catch(() => {
        runningOrderLogTable.loading = false
    })
}
loadRunningOrderLogList()

const editRunningOrderLogDialog: Record<string, any> | null = ref(null)

/**
 * 添加订单日志
 */
const addEvent = () => {
    editRunningOrderLogDialog.value.setFormData()
    editRunningOrderLogDialog.value.showDialog = true
}

/**
 * 编辑订单日志
 * @param data
 */
const editEvent = (data: any) => {
    editRunningOrderLogDialog.value.setFormData(data)
    editRunningOrderLogDialog.value.showDialog = true
}

/**
 * 删除订单日志
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('runningOrderLogDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteRunningOrderLog(id).then(() => {
            loadRunningOrderLogList()
        }).catch(() => {
        })
    })
}

    
    const operatorIdList = ref([])
    const setOperatorIdList = async () => {
    operatorIdList.value = await (await getWithMemberList({})).data
    }
    setOperatorIdList()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadRunningOrderLogList()
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
