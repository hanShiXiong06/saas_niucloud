<template>
    <div class="main-container">
        <div class="detail-head">
            <div class="left" @click="back()">
                <span class="iconfont iconxiangzuojiantou !text-xs"></span>
                <span class="ml-[1px]">{{t('returnToPreviousPage')}}</span>
            </div>
            <span class="adorn">|</span>
            <span class="right">{{ pageName }}</span>
        </div>
        <el-card class="box-card !border-none" shadow="never">
            <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form">
                <el-form-item :label="t('categoryId')" prop="category_id">
                    <el-cascader v-model="formData.category_id" :options="paperCategoryOptions" :props="paperCategoryProps" clearable filterable popper-class="choice" :placeholder="t('categoryIdPlaceholder')" disabled />
                </el-form-item>
                
                <el-form-item :label="t('title')" prop="title">
                    <el-input v-model="formData.title" clearable :placeholder="t('titlePlaceholder')" class="input-width" disabled />
                </el-form-item>
				
                <el-form-item :label="t('mode')" prop="mode">
                    <template v-for="(item) in modeList" :key="item.value">
                        <div class="mode-wrap" v-if="formData.mode == item.value" :class="[formData.mode == item.value ? 'selected' : 'disabled']">
                            <div class="mode-name">{{ item.name }}</div>
							<div class="mode-desc">({{ item.desc }})</div>
                            <template v-if="formData.mode == item.value">
                                <div class="triangle"></div>
                                <div class="selected">✓</div>
                            </template>
                        </div>
                    </template>
                </el-form-item>
				
				<el-form-item :label="t('抽题分类')" prop="question_category_ids" v-if="formData.mode == 1">
					<div class="w-[100%] flex">
						<el-cascader v-model="formData.question_category_ids" :options="questionCategoryOptions" :props="questionCategoryProps" clearable filterable popper-class="choice" :placeholder="t('全部分类')" disabled />
					</div>
					<p class="text-[12px] text-[#a9a9a9]">从{{formData.question_category_ids.length > 0 ? '选中' : '全部'}}题目分类中抽取题目</p>
				</el-form-item>
				
                <el-form-item :label="t('题目难度')" v-if="formData.mode == 1">
					<div class="w-[100%]">
						<el-checkbox-group v-model="formData.difficultys">
						    <el-checkbox :label="item.value" v-for="(item,index) in difficultyList" :key="index" disabled>
								{{ item.name }}
						    </el-checkbox>
						</el-checkbox-group>
					</div>
					
					<p class="text-[12px] text-[#a9a9a9]">从{{formData.difficultys.length > 0 ? '选中' : '全部'}}题目难度中抽取题目</p>
                </el-form-item>
                
                <el-form-item :label="t('questionRules')" prop="question_rules">
                    <div class="w-[100%]">
                        <table class="options-table w-[100%]">
                            <colgroup>
                                <col width="20%">
                                <col width="30%">
                                <col width="30%">
                    			<col width="20%">
                            </colgroup>
                            <thead class="bg-[#f7f7f7]">
                                <tr>
                                    <th>题型</th>
                                    <th>出题数量</th>
                                    <th>题型分数</th>
									<th>逐项计分<el-button type="success" class="h-[20px] ml-[5px] text-[12px]" @click="showTerm">说明</el-button></th>
                    				<th>排序</th>
                                </tr>
                            </thead>
							
                            <tbody class="options-new">
                                <template v-if="formData.question_rules.length">
                                    <tr v-for="(item,index) in formData.question_rules" :key="index">
                                        <td>{{item.name}}</td>
                                        <td>
                                            <el-input-number :min="0" v-model="item.num" disabled />
                                        </td>
                                        <td>
                    						<el-input-number type="number" :min="0" v-model="item.score" disabled />
                                        </td>
										<td>
											{{item.isterm ? '开启' : '关闭'}}
										</td>
                    					<td>
                    						<el-input-number type="number" :min="1" v-model="item.sort" disabled />
                    					</td>
                                    </tr>
                                </template>
                                
                            </tbody>
                        </table>
                    </div>
                    
                </el-form-item>
                <el-form-item :label="t('passScore')" prop="pass_score">
                    <el-input-number v-model="formData.pass_score" clearable :placeholder="t('passScorePlaceholder')" class="input-width" :min="0" disabled />
                </el-form-item>
				
                <el-form-item :label="t('questionNum')" prop="question_num">
                    <el-input-number v-model="formData.question_num" clearable :placeholder="t('questionNumPlaceholder')" class="input-width" :min="0" disabled />
                </el-form-item>
                
                <el-form-item :label="t('totalScore')" prop="total_score">
                    <el-input-number v-model="formData.total_score" clearable :placeholder="t('totalScorePlaceholder')" class="input-width" :min="0" disabled />
                </el-form-item>
                
                
            </el-form>
        </el-card>
         <div class="fixed-footer-wrap">
            <div class="fixed-footer">
                <el-button @click="back()">{{ t('返回') }}</el-button>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { FormInstance,ElMessageBox } from 'element-plus'
import { getPaperInfo,addPaper, editPaper } from '@/addon/zzexam/api/paper'
import { getQuestionTypeList, getQuestionDifficultyList } from '@/addon/zzexam/api/question'
import { getCategoryTree } from '@/addon/zzexam/api/study'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()
const id:number = parseInt(route.query.id);
const loading = ref(false)
const pageName = route.meta.title

const modeList = reactive([
	{name:'题库抽题',value:1,desc:'随机抽取'},
	{name:'手动选题 ',value:2,desc:'固定试题'},
]);

/**
 * 表单数据
 */
const initialFormData = {
    paper_id: 0,
    category_id: '',
    title: '',
    mode: 1,
	question_category_ids:[],
	difficultys:[],
    question_rules: [],
    question_num: 0,
    total_score: 0,
    pass_score: 60,
}
const formData: Record<string, any> = reactive({ ...initialFormData })

// 题型列表
const questionTypeList = ref([]);
const getQuestionTypeListFn = async () => {
	questionTypeList.value = await (await getQuestionTypeList()).data
	
	Object.keys(questionTypeList.value).forEach((key: string,index) => {
		formData.question_rules.push({
			type:key, //题型
			name:questionTypeList.value[key]['name'], //题型名称
			score:0,//分数
			isterm:0,//是否逐项计分
			num:0,// 出题数量
			sort:index+1
		})
	})
	
}

const setFormData = async (id:number = 0) => {
    Object.assign(formData, initialFormData)
    const data = await (await getPaperInfo(id)).data
    Object.keys(formData).forEach((key: string) => {
        if (data[key] != undefined) formData[key] = data[key]
    })
}
if(id){
	setFormData(id);
}else{
	getQuestionTypeListFn()
} 

const formRef = ref<FormInstance>()
// 选中数据
const selectData = ref<any[]>([])


// 题目难度
const difficultyList = ref([])
const getQuestionDifficultyListFn = async () => {
	difficultyList.value = await (await getQuestionDifficultyList()).data
}
getQuestionDifficultyListFn()

// 题目分类
const questionCategoryOptions = reactive([])
const questionCategoryProps = { multiple: true,emitPath:false }
const refreshQuestionCategoryFn = (bool = false) => {
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
			if (bool) {
				ElMessage({
					message: t('refreshSuccess'),
					type: 'success'
				})
			}
		}
	})
}

refreshQuestionCategoryFn()
 
// 试卷分类
const paperCategoryOptions = reactive([])
const paperCategoryProps = { multiple: false,emitPath:false }
const refreshPaperCategoryFn = (bool = false) => {
	getCategoryTree({type:'paper'}).then((res) => {
		const data = res.data
		if (data) {
			const paperCategoryTree: any = []
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
				paperCategoryTree.push({
					value: item.category_id,
					label: item.name,
					children
				})
			})
			paperCategoryOptions.splice(0, paperCategoryOptions.length, ...paperCategoryTree)
			if (bool) {
				ElMessage({
					message: t('refreshSuccess'),
					type: 'success'
				})
			}
		}
	})
}

refreshPaperCategoryFn() 

    
// 表单验证规则
const formRules = computed(() => {
    return {
		category_id: [
			{ required: true, message: t('categoryIdPlaceholder'), trigger: 'blur' },
		],
		title: [
			{ required: true, message: t('titlePlaceholder'), trigger: 'blur' },
		],
		mode: [
			{ required: true, message: t('modePlaceholder'), trigger: 'blur' },
		],
		question_rules: [
			{ required: true, message: t('questionRulesPlaceholder'), trigger: 'blur' },
		],
		question_num: [
			{ required: true, message: t('questionNumPlaceholder'), trigger: 'blur' },
		],
		total_score: [
			{ required: true, message: t('totalScorePlaceholder'), trigger: 'blur' },
		],
		pass_score: [
			{ required: true, message: t('passScorePlaceholder'), trigger: 'blur' },
		],
		status: [
			{ required: true, message: t('statusPlaceholder'), trigger: 'blur' },
		]
    }
})

watch(() => formData.question_rules, () => {
	calQuestioRules();
}, { deep: true })

// 计算总分和题目数量
const calQuestioRules = () => {
	let question_num = 0;
	let total_score = 0;
	formData.question_rules.forEach((item) => {
		question_num += item.num
		total_score += item.score
	})
	formData.question_num = question_num
	formData.total_score = total_score
}

// 跳转到分类，添加分类
const toCategoryEvent = () => {
	const url = router.resolve({
		path: '/zzexam/category'
	})
	window.open(url.href)
}

//显示逐项计分说明
const showTerm = () => {
	ElMessageBox.confirm('逐项计分设置只针对多选题和填空题，开启后多选题每对一个选项可获得一个选项分数，但如有选错则完全不得分，填空题每对一个填空可获得一个填空分数，就算有填错也不影响其他得分。', '逐项计分说明',
	    {
	        confirmButtonText: t('confirm'),
	        type: 'info',
	    }
	).then(() => {})
}

// 更改选题模式
const changeMode = (item: any) => {
	formData.mode = item.value
}

const back = () => {
    history.back()
}
</script>

<style lang="scss" scoped>
	.options-table {
		border: 1px solid #e6e6e6;
		
		thead tr, tbody tr {
			border-bottom: 1px solid #e6e6e6;
		}
		
		thead th, tbody td {
			padding: 5px 10px;
			border-right: 1px solid #e6e6e6;
		}
		
		thead th {
			text-align: center;
			font-weight: normal;
			font-size: 14px;
			color: #666;
			box-sizing: border-box;
		}
		
		tbody td {
			text-align: center;
		}
	}
	
	.mode-wrap {
	  width: 120px;
	  height: 60px;
	  background: #fff;
	  border-radius: 3px;
	  float: left;
	  text-align: center;
	  padding-top: 8px;
	  position: relative;
	  cursor: pointer;
	  line-height: 23px;
	  border: 1px solid #e7e7e7;
	
	  .mode-name {
	    font-size: 14px;
	    font-weight: 600;
	    color: rgba(0, 0, 0, .85);
	  }
	
	  .mode-desc {
	    font-size: 12px;
	    font-weight: 400;
	    color: #999;
	  }
	
	  .triangle {
	    position: absolute;
	    bottom: 0;
	    right: 0;
	    width: 0;
	    height: 0;
	    border-bottom: 26px solid var(--el-color-primary);
	    border-left: 26px solid transparent;
	  }
	
	  .selected {
	    position: absolute;
	    bottom: -2px;
	    right: 2px;
	    color: #fff;
	  }
	
	  &.selected {
	    border: 1px solid var(--el-color-primary);
	  }
	
	  &.disabled {
	    cursor: not-allowed;
	
	    .mode-name {
	      color: #999;
	    }
	  }
	
	  &:nth-child(2n) {
	    margin: 0 12px;
	  }
	
	}
</style>
