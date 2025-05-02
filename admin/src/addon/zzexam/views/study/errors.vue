<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
            </div>
            
            <div class="mt-[10px]">
                <el-table :data="errorsTable.data" size="large" v-loading="errorsTable.loading">
                    <template #empty>
                        <span>{{ !errorsTable.loading ? t('emptyData') : '' }}</span>
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
                    
                    <el-table-column prop="exam.title" :label="t('examId')" min-width="300" :show-overflow-tooltip="true"/>
                    <el-table-column prop="question.title" :label="t('questionId')" min-width="300" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="create_time" :label="t('createTime')" min-width="220" :show-overflow-tooltip="true"/>
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="errorsTable.page" v-model:page-size="errorsTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="errorsTable.total"
                        @size-change="loadErrorsList()" @current-change="loadErrorsList" />
                </div>
            </div>

            <edit ref="editErrorsDialog" @complete="loadErrorsList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getErrorsList, deleteErrors } from '@/addon/zzexam/api/study'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/zzexam/views/study/components/errors-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let errorsTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "member_id":"",
      "exam_id":"",
      "question_id":"",
      "scores_id":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取会员错题列表
 */
const loadErrorsList = (page: number = 1) => {
    errorsTable.loading = true
    errorsTable.page = page

    getErrorsList({
        page: errorsTable.page,
        limit: errorsTable.limit,
         ...errorsTable.searchParam
    }).then(res => {
        errorsTable.loading = false
        errorsTable.data = res.data.data
        errorsTable.total = res.data.total
    }).catch(() => {
        errorsTable.loading = false
    })
}
loadErrorsList()

const editErrorsDialog: Record<string, any> | null = ref(null)

/**
 * 添加会员错题
 */
const addEvent = () => {
    editErrorsDialog.value.setFormData()
    editErrorsDialog.value.showDialog = true
}

/**
 * 编辑会员错题
 * @param data
 */
const editEvent = (data: any) => {
    editErrorsDialog.value.setFormData(data)
    editErrorsDialog.value.showDialog = true
}

/**
 * 删除会员错题
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('errorsDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteErrors(id).then(() => {
            loadErrorsList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadErrorsList()
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
