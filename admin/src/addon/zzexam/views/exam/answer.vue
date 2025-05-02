<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addAnswer') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="answerTable.searchParam" ref="searchFormRef">
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadAnswerList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="answerTable.data" size="large" v-loading="answerTable.loading">
                    <template #empty>
                        <span>{{ !answerTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="scores_id" :label="t('scoresId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="question_id" :label="t('questionId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="answer" :label="t('answer')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="score" :label="t('score')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="result" :label="t('result')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.answer_id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="answerTable.page" v-model:page-size="answerTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="answerTable.total"
                        @size-change="loadAnswerList()" @current-change="loadAnswerList" />
                </div>
            </div>

            <edit ref="editAnswerDialog" @complete="loadAnswerList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getAnswerList, deleteAnswer } from '@/addon/zzexam/api/exam'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/zzexam/views/exam/components/answer-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let answerTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取考试答卷列表
 */
const loadAnswerList = (page: number = 1) => {
    answerTable.loading = true
    answerTable.page = page

    getAnswerList({
        page: answerTable.page,
        limit: answerTable.limit,
         ...answerTable.searchParam
    }).then(res => {
        answerTable.loading = false
        answerTable.data = res.data.data
        answerTable.total = res.data.total
    }).catch(() => {
        answerTable.loading = false
    })
}
loadAnswerList()

const editAnswerDialog: Record<string, any> | null = ref(null)

/**
 * 添加考试答卷
 */
const addEvent = () => {
    editAnswerDialog.value.setFormData()
    editAnswerDialog.value.showDialog = true
}

/**
 * 编辑考试答卷
 * @param data
 */
const editEvent = (data: any) => {
    editAnswerDialog.value.setFormData(data)
    editAnswerDialog.value.showDialog = true
}

/**
 * 删除考试答卷
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('answerDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteAnswer(id).then(() => {
            loadAnswerList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadAnswerList()
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
