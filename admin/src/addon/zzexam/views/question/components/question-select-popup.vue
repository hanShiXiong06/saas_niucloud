<template>
    <div>
        <div @click="show">
            <slot>
                <el-button type="primary">{{ t('选择题目') }}</el-button>
				<!--div class="inline-block ml-[10px] text-[14px]" v-show="questionIds.length">
					<span>{{ t('已选') }}</span>
					<span class="text-primary mx-[2px]">{{ questionIds.length }}</span>
				</div-->
            </slot>
        </div>
        <el-dialog v-model="showDialog" :title="t('选择题目')" width="80%" :close-on-press-escape="false" :destroy-on-close="true" :close-on-click-modal="false">

            <el-form :inline="true" :model="questionTable.searchParam" ref="searchFormRef" class="mb-[20px]">
                <el-form-item prop="select_type" class="w-[100px]">
                    <el-select v-model="questionTable.searchParam.select_type" @change="handleSelectTypeChange">
                        <el-option :label="t('全部')" value="all" />
                        <el-option :label="t('已选')" value="selected" />
                    </el-select>
                </el-form-item>
				
				<el-form-item class="w-[240px]"  :label="t('分类')" prop="category_id">
				    <el-cascader v-model="questionTable.searchParam.category_id" :options="questionCategoryOptions" :placeholder="t('请选择分类')" clearable :props="{ value: 'value', label: 'label', emitPath:false }"/>
				</el-form-item>
				
				<el-form-item class="w-[240px]"  :label="t('题型')" prop="type">
					<el-select v-model="questionTable.searchParam.type" filterable clearable :placeholder="t('请选择题型')">
					   <el-option
						   v-for="(item, index) in typeList"
						   :key="index"
						   :label="item['name']"
						   :value="item['type']"
					   />
					</el-select>
				</el-form-item>
				<el-form-item class="w-[240px]" :label="t('题目')" prop="title">
				    <el-input v-model="questionTable.searchParam.title" :placeholder="t('请输入题目')" />
				</el-form-item>
				<el-form-item class="w-[240px]" :label="t('难度')" prop="difficulty">
				    <el-select v-model="questionTable.searchParam.difficulty" filterable clearable :placeholder="t('请选择难度')">
				       <el-option
				    	   v-for="(item, index) in difficultyList"
				    	   :key="index"
				    	   :label="item['name']"
				    	   :value="item['value']"
				       />
				    </el-select>
				</el-form-item>
               
                <el-form-item class="form-item-wrap">
                    <el-button type="primary" @click="loadQuestionList()">{{ t('search') }}</el-button>
                    <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                </el-form-item>
            </el-form>

            <el-table :data="questionTable.data" size="large" v-loading="questionTable.loading" ref="questionListTableRef" max-height="400" @select="handleSelectChange" @select-all="handleSelectAllChange">
                <template #empty>
                    <span>{{ !questionTable.loading ? t('emptyData') : '' }}</span>
                </template>
                <el-table-column type="selection" width="55" />
				<el-table-column prop="type" :label="t('题型')" min-width="80" :show-overflow-tooltip="true">
				    <template #default="{ row }">
				        <el-tag type="success" v-if="row.type == 'single'">{{ row.type_name }}</el-tag>
				        <el-tag type="danger" v-else-if="row.type == 'judge'">{{ row.type_name }}</el-tag>
						<el-tag type="warning" v-else-if="row.type == 'multi'">{{ row.type_name }}</el-tag>
						<el-tag v-else>{{ row.type_name }}</el-tag>
				    </template>
				</el-table-column>
                <el-table-column prop="title" :label="t('题目')" min-width="400" :show-overflow-tooltip="true">
                    <template #default="{ row }">
						<div v-html="row.title" class="pr-[30px]"></div>
                    </template>
                </el-table-column>
                <el-table-column prop="difficulty_name" :label="t('难度')" min-width="80" :show-overflow-tooltip="true"/>
                <el-table-column prop="category.full_name" :label="t('分类')" min-width="150" :show-overflow-tooltip="true"/>
            </el-table>
            <div class="mt-[16px] flex">
                <div class="flex items-center flex-1">
                    <div class="layui-table-bottom-left-container mr-[10px]" v-show="selectQuestionNum">
                        <span>{{ t('已选择') }}</span>
                        <span class="text-primary mx-[2px]">{{ selectQuestionNum }}</span>
                    </div>
                    <el-button type="primary" link @click="clear" v-show="selectQuestionNum">{{ t('取消') }}</el-button>
                </div>
                <el-pagination v-model:current-page="questionTable.page" v-model:page-size="questionTable.limit"
                    layout="total, sizes, prev, pager, next, jumper" :total="questionTable.total"
                    @size-change="loadQuestionList()" @current-change="loadQuestionList" />
            </div>

            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="showDialog = false">{{ t('cancel') }}</el-button>
                    <el-button type="primary" @click="save">{{ t('confirm') }}</el-button>
                </span>
            </template>
        </el-dialog>
    </div>
</template>

<script lang="ts" setup>
import { t } from '@/lang'
import { ref, reactive, computed, nextTick } from 'vue'
import { cloneDeep } from 'lodash-es'
import { ElMessage } from 'element-plus'
import { getQuestionList, deleteQuestion, getQuestionTypeList,getQuestionDifficultyList,getQuestionSelectList } from '@/addon/zzexam/api/question'
import { getCategoryTree } from '@/addon/zzexam/api/study'

const prop = defineProps({
    modelValue: {
        type: String,
        default: ''
    },
    max: {
        type: Number,
        default: 0
    },
    min: {
        type: Number,
        default: 0
    }
})

const emit = defineEmits(['update:modelValue','questionSelect'])

const questionIds: any = computed({
    get () {
        return prop.modelValue
    },
    set (value) {
        emit('update:modelValue', value)
    }
})

const showDialog = ref(false)

// 已选选项列表
const selectQuestion: any = reactive({})

// 已选选项列表id
const selectQuestionId: any = reactive([])

// 已选选项数量
const selectQuestionNum: any = computed(() => {
    return Object.keys(selectQuestion).length
})

const questionTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
		"select_type":"all",
		"category_id":[],
		"type":"",
		"title":"",
		"difficulty":"",
        "question_ids": '',
        "verify_ids": '',
    }
})

const searchFormRef = ref()

// 查询全部/已选选项
const handleSelectTypeChange = (value: any) => {
    loadQuestionList()
}

const questionListTableRef = ref()

// 监听表格复选框
const handleSelectChange = (selection: any, row: any) => {
    // 是否选中
    let isSelected = false
    for (let i = 0; i < selection.length; i++) {
        if (selection[i].question_id == row.question_id) {
            isSelected = true
            break
        }
    }
    if (isSelected) {
        selectQuestionId.push(row.question_id)
        selectQuestion['question_' + row.question_id] = row
    } else {
        selectQuestionId.splice(selectQuestionId.indexOf(row.question_id),1)
        // 未选中，删除当前选项
        delete selectQuestion['question_' + row.question_id]
    }

    // 当所选数量超出限制数量【prop.max】时，添加一个就会删除开头的第一个或多个，最终保证所选的数量小于等于prop.max
    if(prop.max && prop.max > 0 && Object.keys(selectQuestion).length > 0 && Object.keys(selectQuestion).length > prop.max){
        let len = Object.keys(selectQuestion).length;
        len = len - prop.max;

        let questionIdCopy = cloneDeep(selectQuestionId);
        questionIdCopy.forEach((item,index,arr) => {
            if(index < len){
                let indent = selectQuestionId.indexOf(item)
                delete selectQuestion['question_'+selectQuestionId[indent]]
                selectQuestionId.splice(indent,1) 
            }
        });
        setItemSelected();
    }
}

// 监听表格全选
const handleSelectAllChange = (selection: any) => {
    if (selection.length) {
        selection.forEach((item: any) => {
            selectQuestion['question_' + item.question_id] = item
            if(selectQuestionId.indexOf(item.question_id) == -1){
                selectQuestionId.push(item.question_id)
            }
        })
    } else {
        // 未选中，删除当前页面的数据
        questionTable.data.forEach((item: any) => {
            selectQuestionId.splice(selectQuestionId.indexOf(item.question_id),1)
            delete selectQuestion['question_' + item.question_id]
        })
    }
}

/**
 * 获取选项列表
 */
const loadQuestionList = (page: number = 1, callback: any = null) => {
	
    questionTable.loading = true
    questionTable.page = page

    const searchData = cloneDeep(questionTable.searchParam);
	
	if (searchData.select_type == 'selected') {
		const question_ids = <any>[]
		for (let k in selectQuestion) {
			question_ids.push(parseInt(k.replace('question_', '')))
		}
		searchData.question_ids = question_ids
	} else {
		searchData.question_ids = ''
	}

    if (searchData.select_type == 'selected') {
        const question_ids = <any>[]
        for (let k in selectQuestion) {
            question_ids.push(parseInt(k.replace('question_', '')))
        }
        searchData.question_ids = question_ids
    } else {
        searchData.question_ids = '';
    }

    getQuestionSelectList({
        page: questionTable.page,
        limit: questionTable.limit,
        ...searchData
    }).then(res => {
        questionTable.loading = false
        questionTable.data = res.data.data
        questionTable.total = res.data.total

        if (callback) callback(res.data.verify_ids)

        setItemSelected();

    }).catch(() => {
        questionTable.loading = false
    })

}

// 表格设置选中状态
const setItemSelected = () => {
    nextTick(() => {
        if (!questionListTableRef.value) return;
        for (let i = 0; i < questionTable.data.length; i++) {
            questionListTableRef.value.toggleRowSelection(questionTable.data[i], false);
            if (selectQuestion['question_' + questionTable.data[i].question_id]) {
                questionListTableRef.value.toggleRowSelection(questionTable.data[i], true);
            }
        }
    });
}

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()

    loadQuestionList()
}

const show = () => {
    for (let k in selectQuestion) {
        delete selectQuestion[k];
    }
    // 检测选项id集合是否存在，移除不存在的选项id，纠正数据准确性
    questionTable.searchParam.verify_ids = questionIds.value;
    loadQuestionList(1, (verify_ids: any) => {
        // 第一次打开弹出框时，纠正数据，并且赋值已选选项
        if (questionIds.value) {
            questionIds.value.splice(0, questionIds.value.length, ...verify_ids)
            questionIds.value.forEach((item: any) => {
                if (!selectQuestion['question_' + item]) {
                    selectQuestion['question_' + item] = {};
                }
            })

            // 赋值已选择的选项
            for (let i = 0; i < questionTable.data.length; i++) {
                if (questionIds.value.indexOf(questionTable.data[i].question_id) != -1) {
                    selectQuestion['question_' + questionTable.data[i].question_id] = questionTable.data[i];
                }
            }
        }
    })
    showDialog.value = true
}

// 清空已选选项
const clear = () => {
    for (let k in selectQuestion) {
        delete selectQuestion[k];
    }
    setItemSelected();
}

const save = () => {
    if (prop.min && selectQuestionNum.value < prop.min) {
        ElMessage({
            type: 'warning',
            message: `${t('所选题目数量不能小于')}${prop.min}`,
        });
        return;
    }

    if (prop.max && prop.max > 0 && selectQuestionNum.value && selectQuestionNum.value > prop.max) {
        ElMessage({
            type: 'warning',
            message: `${t('所选题目数量不能超过')}${prop.max}`,
        });
        return;
    }

    let ids: any = [];
    for (let k in selectQuestion) {
        ids.push(parseInt(k.replace('question_', '')));
    }
    questionIds.value.splice(0, questionIds.value.length, ...ids)
    emit('questionSelect',selectQuestion)
    initSearchParam();
    showDialog.value = false
}

// 重置表单搜索
const initSearchParam = ()=>{
	questionTable.searchParam.select_type = 'all';
    questionTable.searchParam.category_id = [];
    questionTable.searchParam.type = '';
    questionTable.searchParam.title = '';
	questionTable.searchParam.difficulty = '';
    questionTable.searchParam.question_ids = '';
    questionTable.searchParam.verify_ids = '';
}

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

defineExpose({
    showDialog,
    selectQuestion,
    selectQuestionNum
})
</script>

<style lang="scss" scoped>

</style>
