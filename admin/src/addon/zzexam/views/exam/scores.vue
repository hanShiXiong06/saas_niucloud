<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
               
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="scoresTable.searchParam" ref="searchFormRef">
                    <el-form-item class="w-[240px]"  :label="t('subjectId')" prop="subject_id">
                        <el-cascader v-model="scoresTable.searchParam.subject_id" :options="examSubjectOptions" :placeholder="t('subjectIdPlaceholder')" clearable :props="{ value: 'value', label: 'label', emitPath:false }"/>
                    </el-form-item>
                    <el-form-item :label="t('examTitle')" prop="exam_title">
                        <el-input v-model="scoresTable.searchParam.exam_title" :placeholder="t('examTitlePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="scoresTable.searchParam.create_time" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadScoresList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="scoresTable.data" size="large" v-loading="scoresTable.loading">
                    <template #empty>
                        <span>{{ !scoresTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    
					<el-table-column :label="t('考试信息')" min-width="300" :show-overflow-tooltip="true">
					    <template #default="{ row }">
							<div>{{ row.exam_title || '' }}</div>
							<div>{{ row.subject.full_name || '' }}</div>
						</template>
					</el-table-column>	
					
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
                    
					<el-table-column :label="t('examScore')" min-width="120" :show-overflow-tooltip="true">
					    <template #default="{ row }">
							<div>{{ row.exam_score || '' }}</div>
							<div>{{ row.is_pass == 1 ? '及格' : '不及格' }}</div>
						</template>
					</el-table-column>	
                    
                    
                    <el-table-column prop="error_num" :label="t('errorNum')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="correct_num" :label="t('correctNum')" min-width="120" :show-overflow-tooltip="true"/>
					
					<el-table-column prop="use_time" :label="t('用时')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="create_time" :label="t('createTime')" min-width="220" :show-overflow-tooltip="true"/>

                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="deleteEvent(row.scores_id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="scoresTable.page" v-model:page-size="scoresTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="scoresTable.total"
                        @size-change="loadScoresList()" @current-change="loadScoresList" />
                </div>
            </div>

            <edit ref="editScoresDialog" @complete="loadScoresList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getScoresList, deleteScores, getSubjectTree } from '@/addon/zzexam/api/exam'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/zzexam/views/exam/components/scores-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let scoresTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "subject_id":"",
      "exam_title":"",
      "realname":"",
      "mobile":"",
      "create_time":[]
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 考试科目
const examSubjectOptions: any = reactive([])
const examSubjectOptionsFn = () => {
    getSubjectTree().then((res) => {
        const data = res.data
        if (data) {
            const subjectTree: any = []
            data.forEach((item: any) => {
                const children: any = []
                if (item.child_list) {
                    item.child_list.forEach((childItem: any) => {
                        children.push({
                            value: childItem.subject_id,
                            label: childItem.name
                        })
                    })
                }
                subjectTree.push({
                    value: item.subject_id,
                    label: item.name,
                    children
                })
            })
            examSubjectOptions.splice(0, examSubjectOptions.length, ...subjectTree)
        }
    })
    
}
examSubjectOptionsFn();

/**
 * 获取成绩列表
 */
const loadScoresList = (page: number = 1) => {
    scoresTable.loading = true
    scoresTable.page = page

    getScoresList({
        page: scoresTable.page,
        limit: scoresTable.limit,
         ...scoresTable.searchParam
    }).then(res => {
        scoresTable.loading = false
        scoresTable.data = res.data.data
        scoresTable.total = res.data.total
    }).catch(() => {
        scoresTable.loading = false
    })
}
loadScoresList()

const editScoresDialog: Record<string, any> | null = ref(null)

/**
 * 添加成绩
 */
const addEvent = () => {
    editScoresDialog.value.setFormData()
    editScoresDialog.value.showDialog = true
}

/**
 * 编辑成绩
 * @param data
 */
const editEvent = (data: any) => {
    editScoresDialog.value.setFormData(data)
    editScoresDialog.value.showDialog = true
}

/**
 * 删除成绩
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('scoresDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteScores(id).then(() => {
            loadScoresList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadScoresList()
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
