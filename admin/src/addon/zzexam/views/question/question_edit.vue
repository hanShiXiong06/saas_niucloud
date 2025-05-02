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
				    <el-cascader v-model="formData.category_id" :options="questionCategoryOptions" :props="questionCategoryProps" clearable filterable popper-class="choice" :placeholder="t('categoryIdPlaceholder')" />
				    <div class="ml-[10px]">
				        <span class="cursor-pointer text-primary mr-[10px]" @click="refreshQuestionCategoryFn(true)">{{ t('refresh') }}</span>
				        <span class="cursor-pointer text-primary" @click="toCategoryEvent">{{ t('addCategory') }}</span>
				    </div>
				</el-form-item>
				
				<el-form-item :label="t('type')" prop="type" v-if="formData.question_id">
				    <template v-for="(item) in typeList" :key="item.type">
				        <div class="question-type-wrap" :class="[formData.type == item.type ? 'selected' : 'disabled']">
				            <div class="question-type-name">{{ item.name }}</div>
				            <template v-if="formData.type == item.type">
				                <div class="triangle"></div>
				                <div class="selected">✓</div>
				            </template>
				        </div>
				    </template>
				</el-form-item>
				<el-form-item :label="t('type')" prop="type" v-else>
				    <div class="question-type-wrap" :class="{ 'selected': formData.type == item.type }" v-for="(item) in typeList" :key="item.type" @click="changeQuestionType(item)">
				        <div class="question-type-name">{{ item.name }}</div>
				        <template v-if="formData.type == item.type">
				            <div class="triangle"></div>
				            <div class="selected">✓</div>
				        </template>
				    </div>
				</el-form-item>
				
				<el-form-item :label="t('difficulty')" prop="difficulty">
					<div class="question-type-wrap" :class="{ 'selected': formData.difficulty == item.value }" v-for="(item) in difficultyList" :key="item.value" @click="formData.difficulty = item.value">
					    <div class="question-type-name">{{ item.name }}</div>
					    <template v-if="formData.difficulty == item.value">
					        <div class="triangle"></div>
					        <div class="selected">✓</div>
					    </template>
					</div>
				</el-form-item>
                
                <el-form-item :label="t('title')" prop="title">
					<editor v-model="formData.title" :height="180" />
                </el-form-item>
                
				<el-form-item :label="t('optionsJson')" prop="options_json" v-if="formData.type == 'judge'||formData.type == 'judge'||formData.type == 'single'||formData.type == 'multi'">
				    <div class="w-[100%]">
				        <table class="options-table w-[100%]">
				            <colgroup>
				                <col width="10%">
				                <col width="60%">
				                <col width="10%">
								<col width="10%">
				                <col width="10%">
				            </colgroup>
				            <thead class="bg-[#f7f7f7]">
				                <tr>
				                    <th>选项</th>
				                    <th>内容</th>
				                    <th>图片</th>
									<th>视频</th>
				                    <th>操作</th>
				                </tr>
				            </thead>
				            <tbody class="options-new">
				                <template v-if="formData.options_json.length">
				                    <tr v-for="(item,index) in formData.options_json" :key="index">
				                        <td>{{item.id}}</td>
				                        <td>
				                            <el-input v-model="item.title" clearable />
				                        </td>
				                        <td>
											<div class="w-[80px] pl-[10px] m-auto">
												<upload-image v-model="item.image" width="60px" height="60px" :limit="1" />
											</div>
				                        </td>
										<td>
											<div class="w-[80px] pl-[10px] m-auto">
												<upload-video v-model="item.video" width="60px" height="60px" :limit="1" />
											</div>
										</td>
				                        <td>
				                            <span class="cursor-pointer text-[var(--el-color-primary)]" @click="delOptionsFn(index)">删除</span>
				                        </td>
				                    </tr>
				                </template>
				                
				            </tbody>
				        </table>
						<p class="text-[12px] text-[#a9a9a9]">选项内容、图片、视频至少设置一个</p>
				        <el-button class="mt-[15px]" @click="addOptionsFn">增加选项</el-button>
				    </div>
					
				</el-form-item>
				
				<el-form-item :label="t('answer')" prop="answer">
				    <el-checkbox-group v-model="formData.answer" :placeholder="t('answerPlaceholder')"  v-if="formData.type == 'multi'">
						<el-checkbox :label="item.id" v-for="(item,index) in formData.options_json" :key="index">
							{{ item.id }}
						</el-checkbox>
					</el-checkbox-group>
					<el-radio-group  v-model="formData.answer" :placeholder="t('answerPlaceholder')" v-if="formData.type == 'judge' || formData.type == 'single'">
					    <el-radio v-for="(item, key) in formData.options_json" :value="item.id" :label="item.id">
					        {{ item.id }}
					    </el-radio>
					</el-radio-group>
					
					<div class="w-[100%]" v-if="formData.type == 'fill'">
						<table class="options-table w-[100%]">
						    <colgroup>
						        <col width="80%">
						        <col width="20%">
						    </colgroup>
						    <thead class="bg-[#f7f7f7]">
						        <tr>
						            <th>答案选项</th>
						            <th>操作</th>
						        </tr>
						    </thead>
						    <tbody class="options-new">
						        <template v-if="formData.answer.length">
						            <tr v-for="(item,index) in formData.answer" :key="index">
						                <td>
						                    <el-input v-model="formData.answer[index]" clearable />
						                </td>
						                <td>
						                    <span class="cursor-pointer text-[var(--el-color-primary)]" @click="delFillAnswerFn(index)">删除</span>
						                </td>
						            </tr>
						        </template>
						        
						    </tbody>
						</table>
						<el-button class="mt-[15px]" @click="addFillAnswerFn">添加填空答案</el-button>
						
					</div>
				</el-form-item>
				
                <el-form-item :label="t('explain')" prop="explain" >
					<editor v-model="formData.explain" :height="180" />
                </el-form-item>
                
                <el-form-item :label="t('status')" prop="status">
                    <el-switch v-model="formData.status" class="input-width" active-value="normal" inactive-value="hidden" />
                </el-form-item>
                
            </el-form>
        </el-card>
         <div class="fixed-footer-wrap">
            <div class="fixed-footer">
                <el-button type="primary" @click="onSave(formRef)">{{ t('save') }}</el-button>
                <el-button @click="back()">{{ t('cancel') }}</el-button>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { cloneDeep } from 'lodash-es'
import type { FormInstance, ElMessage } from 'element-plus'
import { getQuestionInfo,addQuestion,editQuestion,getQuestionTypeList,getQuestionDifficultyList } from '@/addon/zzexam/api/question';
import { getCategoryTree } from '@/addon/zzexam/api/study'
import { useRoute,useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()
const id:number = parseInt(route.query.id);
const loading = ref(false)
const pageName = route.meta.title
const optionsIds = reactive(['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']);

/**
 * 表单数据
 */
const initialFormData = {
	question_id: 0,
	category_id: '',
	type: 'single',
	title: '',
	difficulty: 1,
	explain: '',
	options_json: [],
	answer: [],
	status: 'normal',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const setFormData = async (id:number = 0) => {
	Object.assign(formData, initialFormData)
	const data = await (await getQuestionInfo(id)).data
	Object.keys(formData).forEach((key: string) => {
		if (data[key] != undefined) {
			if(key == 'answer' && (data['type'] == 'judge' || data['type'] == 'single')){
				formData[key] = data[key][0];
			}else{
				formData[key] = data[key]
			}
		}
	})
}
if(id) setFormData(id);

const formRef = ref<FormInstance>()

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

// 分类
const questionCategoryOptions = reactive([])
const questionCategoryProps = { multiple: false,emitPath:false }
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

	
// 表单验证规则
const formRules = computed(() => {
	return {
		category_id: [
			{ required: true, message: t('categoryIdPlaceholder'), trigger: 'blur' },
		],
		type: [
			{ required: true, message: t('typePlaceholder'), trigger: 'blur' },
		],
		title: [
			{ required: true, message: t('titlePlaceholder'), trigger: 'blur' },
		],
		difficulty: [
			{ required: true, message: t('difficultyPlaceholder'), trigger: 'blur' },
		],
		options_json: [
			{ required: true, message: t('optionsJsonPlaceholder'), trigger: 'blur' },
		],
		answer: [
			{ required: true, message: t('answerPlaceholder'), trigger: 'blur' },
		],
		status: [
			{ required: true, message: t('statusPlaceholder'), trigger: 'blur' },
		]
	}
})

const onSave = async (formEl: FormInstance | undefined) => {
	if (loading.value || !formEl) return
	await formEl.validate(async (valid) => {
	   if (valid) {
		   
		   const data = cloneDeep(formData)
		   
		   if(data.type == 'judge' || data.type == 'single' || data.type == 'multi'){
			   const optionsFlag = ref(false);
			   data.options_json.forEach((item,index)=>{
					if(item.title == '' && item.image == '' && item.video == ''){
						optionsFlag.value = true;
					}
			   });
			   
			   if(optionsFlag.value){
					ElMessage({
						type: 'warning',
						message: '选项内容、图片、视频至少设置一个'
					})
					return
			   }
		   }
		   
		   if(data.type == 'fill'){
			   const answerFlag = ref(false);
			   data.answer.forEach((item,index)=>{
					if(item == ''){
						answerFlag.value = true;
					}
			   });
			   
			   data.options_json = [];
			   
			   if(answerFlag.value){
					ElMessage({
						type: 'warning',
						message: '答案选项不能为空'
					})
					return
			   }
		   }
		   
		   loading.value = true
		   
		   if(!Array.isArray(data.answer)){
			   data.answer = [data.answer];
		   }else if(data.type == 'judge' || data.type == 'single' || data.type == 'multi'){
				data.answer = data.answer.sort();
		   }

		   const save = id ? editQuestion : addQuestion
		   save(data).then(res => {
			   loading.value = false
			   history.back()
		   }).catch(err => {
			   loading.value = false
		   })

	   }
	})
}

const back = () => {
	history.back()
}

// 跳转到分类，添加分类
const toCategoryEvent = () => {
	const url = router.resolve({
		path: '/zzexam/category'
	})
	window.open(url.href)
}

// 选择题型
const changeQuestionType = (value: any) => {
	formData.type = value.type
	if(value.type == 'fill'){
		initFillAnswer();
	}else{
		initOptionsFn();
	}
}

// 初始化题目选项
const initOptionsFn = () => {
	if(formData.type == 'single' || formData.type == 'multi'){
		formData.options_json = [
			{id:'A',title:'',image:'',video:''},
			{id:'B',title:'',image:'',video:''},
			{id:'C',title:'',image:'',video:''},
			{id:'D',title:'',image:'',video:''},
		];
	}
	if(formData.type == 'judge'){
		formData.options_json = [
			{id:'A',title:'正确',image:'',video:''},
			{id:'B',title:'错误',image:'',video:''},
		];
	}
}

if(!id) initOptionsFn();

// 初始化填空题答案选项
const initFillAnswer = () => {
	formData.answer = [''];
}

// 填空题添加答案选项
const addFillAnswerFn = () => {
	formData.answer.push('');
}

// 填空题删除答案选项
const delFillAnswerFn = (index: number) => {
	
	if (formData.answer.length == 1) {
		ElMessage({
			type: 'warning',
			message: '最少保留一个答案选项'
		})
		return
	}
	
	formData.answer.splice(index,1);
	
}

// 删除题目选项
const delOptionsFn = (index: number) => {
	
	if (formData.options_json.length == 2) {
		ElMessage({
			type: 'warning',
			message: '最少两个选项'
		})
		return
	}
	
	formData.options_json.splice(index,1);
	formData.options_json.forEach((item,index)=>{
		item.id = optionsIds[index];
	})
	
	if(!Array.isArray(formData.answer)){
		formData.answer = '';
	}else{
		formData.answer = [];
	}
	
}

// 添加题目选项
const addOptionsFn = (index: number) => {
	
	if (formData.options_json.length == 10) {
		ElMessage({
			type: 'warning',
			message: '最多添加10个选项'
		})
		return
	}
	
	formData.options_json.push({id:optionsIds[formData.options_json.length],title:'',image:''},);
	
}
</script>

<style lang="scss" scoped>
	.question-type-wrap {
		width: 120px;
		height: 34px;
		background: #fff;
		border-radius: 3px;
		float: left;
		text-align: center;
		padding-top: 8px;
		position: relative;
		cursor: pointer;
		line-height: 17px;
		border: 1px solid #e7e7e7;
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
			.question-type-name {
			  color: #999;
			}
		}
		
		&:nth-child(2n) {
			margin: 0 12px;
		}
	}
	
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
</style>
