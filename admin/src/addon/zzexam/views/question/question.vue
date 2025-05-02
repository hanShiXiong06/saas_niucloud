<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
				<div>
				    <el-button type="primary" @click="addEvent">
				       {{ t('addQuestion') }}
				    </el-button>
					<el-button type="danger" @click="importEvent">
						{{ t('导入题目') }}
					</el-button>
				</div>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="questionTable.searchParam" ref="searchFormRef">
                    <el-form-item class="w-[240px]"  :label="t('categoryId')" prop="category_id">
                        <el-cascader v-model="questionTable.searchParam.category_id" :options="questionCategoryOptions" :placeholder="t('categoryIdPlaceholder')" clearable :props="{ value: 'value', label: 'label', emitPath:false }"/>
                    </el-form-item>
					
                    <el-form-item class="w-[240px]"  :label="t('type')" prop="type">
						<el-select v-model="questionTable.searchParam.type" filterable clearable :placeholder="t('typePlaceholder')">
						   <el-option
							   v-for="(item, index) in typeList"
							   :key="index"
							   :label="item['name']"
							   :value="item['type']"
						   />
						</el-select>
                    </el-form-item>
                    <el-form-item class="w-[240px]" :label="t('title')" prop="title">
                        <el-input v-model="questionTable.searchParam.title" :placeholder="t('titlePlaceholder')" />
                    </el-form-item>
                    <el-form-item class="w-[240px]" :label="t('difficulty')" prop="difficulty">
                        <el-select v-model="questionTable.searchParam.difficulty" filterable clearable :placeholder="t('difficultyPlaceholder')">
                           <el-option
                        	   v-for="(item, index) in difficultyList"
                        	   :key="index"
                        	   :label="item['name']"
                        	   :value="item['value']"
                           />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item class="w-[240px]" :label="t('status')" prop="status">
						<el-select v-model="questionTable.searchParam.status" filterable clearable :placeholder="t('statusPlaceholder')">
						   <el-option
							   v-for="(item, index) in statusList"
							   :key="index"
							   :label="item['name']"
							   :value="item['value']"
						   />
						</el-select>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadQuestionList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="questionTable.data" size="large" v-loading="questionTable.loading">
                    <template #empty>
                        <span>{{ !questionTable.loading ? t('emptyData') : '' }}</span>
                    </template>
					
					<el-table-column prop="type" :label="t('type')" min-width="100" :show-overflow-tooltip="true">
					    <template #default="{ row }">
					        <el-tag type="success" v-if="row.type == 'single'">{{ row.type_name }}</el-tag>
					        <el-tag type="danger" v-else-if="row.type == 'judge'">{{ row.type_name }}</el-tag>
							<el-tag type="warning" v-else-if="row.type == 'multi'">{{ row.type_name }}</el-tag>
							<el-tag v-else>{{ row.type_name }}</el-tag>
					    </template>
					</el-table-column>
					
					<el-table-column prop="title" :label="t('title')" min-width="400" :show-overflow-tooltip="true">
					    <template #default="{ row }">
							<div v-html="row.title" class="pr-[30px] max-h-[180px]" style="overflow-wrap: break-word;
  word-break: break-all;white-space: pre-wrap;overflow: hidden"></div>
					    </template>
					</el-table-column>
                    
                    <el-table-column prop="difficulty_name" :label="t('difficulty')" min-width="100" :show-overflow-tooltip="true"/>
					
					<el-table-column prop="category.full_name" :label="t('categoryId')" min-width="150" :show-overflow-tooltip="true"/>
					
                    <el-table-column prop="status" :label="t('status')" min-width="100" align="left">
                        <template #default="{ row }">
                            <el-tag class="cursor-pointer" :type="row.status == 'normal' ? 'success' : 'danger'">{{ row.status == 'normal' ? '显示' : '隐藏' }}</el-tag>
                        </template>
                    </el-table-column>
					
					<el-table-column :label="t('createTime')" min-width="160" :show-overflow-tooltip="true">
					    <template #default="{ row }">
					        {{ row.create_time || '' }}
					    </template>
					</el-table-column>
					
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.question_id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="questionTable.page" v-model:page-size="questionTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="questionTable.total"
                        @size-change="loadQuestionList()" @current-change="loadQuestionList" />
                </div>
            </div>

            <question-import ref="importQuestionDialog" @complete="loadQuestionList()" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getQuestionList, deleteQuestion, getQuestionTypeList,getQuestionDifficultyList } from '@/addon/zzexam/api/question'
import { getCategoryTree } from '@/addon/zzexam/api/study'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
import questionImport from '@/addon/zzexam/views/question/components/question-import.vue'
const route = useRoute()
const pageName = route.meta.title;

let questionTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "category_id":[],
      "type":"",
      "title":"",
      "difficulty":"",
      "status":""
    }
})

const searchFormRef = ref<FormInstance>()

const statusList = reactive([
	{name:'显示',value:'normal'},
	{name:'隐藏',value:'hidden'},
]);  

// 题目分类
const questionCategoryOptions: any = reactive([])
const questionCategoryOptionsFn = () => {
    getCategoryTree({type:'question'}).then((res) => {
        const data = res.data
        if (data) {
            const questionCategoryTree: any = []
            data.forEach((item: any) => {
                const children: any = []
                if (item.child_list) {
                    item.child_list.forEach((childItem: any) => {
                        children.push({
                            value: childItem.category_id,
                            label: childItem.name
                        })
                    })
                }
                questionCategoryTree.push({
                    value: item.category_id,
                    label: item.name,
                    children
                })
            })
            questionCategoryOptions.splice(0, questionCategoryOptions.length, ...questionCategoryTree)
        }
    })
    
}

questionCategoryOptionsFn()

// 题目题型
const typeList = ref([])
const getQuestionTypeListFn = async () => {
	typeList.value = await (await getQuestionTypeList()).data
}
getQuestionTypeListFn()

// 题目难度
const difficultyList = ref([])
const getQuestionDifficultyListFn = async () => {
	difficultyList.value = await (await getQuestionDifficultyList()).data
}
getQuestionDifficultyListFn()

/**
 * 获取题目列表
 */
const loadQuestionList = (page: number = 1) => {
    questionTable.loading = true
    questionTable.page = page

    getQuestionList({
        page: questionTable.page,
        limit: questionTable.limit,
         ...questionTable.searchParam
    }).then(res => {
        questionTable.loading = false
        questionTable.data = res.data.data
        questionTable.total = res.data.total
    }).catch(() => {
        questionTable.loading = false
    })
}
loadQuestionList()

const router = useRouter()

/**
 * 添加题目
 */
const addEvent = () => {
    router.push('/zzexam/question_edit')
}

/**
 * 编辑题目
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/zzexam/question_edit?id='+data.question_id)
}

/**
 * 删除题目
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('questionDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteQuestion(id).then(() => {
            loadQuestionList()
        }).catch(() => {
        })
    })
}

/**
 * 批量导入
 * @param data
 */
const importQuestionDialog: Record<string, any> | null = ref(null)
const importEvent = (data: any) => {
    importQuestionDialog.value.open();
}
    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadQuestionList()
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
