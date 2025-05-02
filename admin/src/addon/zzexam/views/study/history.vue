<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
            </div>


            <div class="mt-[10px]">
                <el-table :data="historyTable.data" size="large" v-loading="historyTable.loading">
                    <template #empty>
                        <span>{{ !historyTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column :label="t('memberId')" min-width="170" :show-overflow-tooltip="true">
                         <template #default="{ row }">
                     		 <div class="flex items-center cursor-pointer" v-if="row.member">
                     		     <img class="w-[50px] h-[50px] mr-[10px]" v-if="row.member.headimg" :src="img(row.member.headimg)" alt="">
                     		     <img class="w-[50px] h-[50px] mr-[10px] rounded-full" v-else src="@/app/assets/images/member_head.png" alt="">
                     		     <div class="flex flex flex-col">
                     		        <div>{{ row.member.member_no || '' }}</div>
                     				<div>{{ row.member.nickname || '' }}</div>
                     		     </div>
                     			
                     		 </div>
                          </template>
                    </el-table-column>
                    
                    <el-table-column prop="type_name" :label="t('type')" min-width="120" :show-overflow-tooltip="true"/>

                    <el-table-column prop="target.title" :label="t('标题')" min-width="300" :show-overflow-tooltip="true"/>
					
					<el-table-column prop="create_time" :label="t('createTime')" min-width="220" :show-overflow-tooltip="true"/>

                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="deleteEvent(row.history_id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="historyTable.page" v-model:page-size="historyTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="historyTable.total"
                        @size-change="loadHistoryList()" @current-change="loadHistoryList" />
                </div>
            </div>

            <edit ref="editHistoryDialog" @complete="loadHistoryList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getHistoryList, deleteHistory } from '@/addon/zzexam/api/study'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/zzexam/views/study/components/history-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let historyTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "type":"",
      "create_time":[]
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取会员足迹列表
 */
const loadHistoryList = (page: number = 1) => {
    historyTable.loading = true
    historyTable.page = page

    getHistoryList({
        page: historyTable.page,
        limit: historyTable.limit,
         ...historyTable.searchParam
    }).then(res => {
        historyTable.loading = false
        historyTable.data = res.data.data
        historyTable.total = res.data.total
    }).catch(() => {
        historyTable.loading = false
    })
}
loadHistoryList()

const editHistoryDialog: Record<string, any> | null = ref(null)

/**
 * 添加会员足迹
 */
const addEvent = () => {
    editHistoryDialog.value.setFormData()
    editHistoryDialog.value.showDialog = true
}

/**
 * 编辑会员足迹
 * @param data
 */
const editEvent = (data: any) => {
    editHistoryDialog.value.setFormData(data)
    editHistoryDialog.value.showDialog = true
}

/**
 * 删除会员足迹
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('historyDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteHistory(id).then(() => {
            loadHistoryList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadHistoryList()
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
