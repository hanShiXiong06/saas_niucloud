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
            <el-form :model="formData" label-width="180px" ref="formRef" :rules="formRules" class="page-form">
				
				<el-form-item :label="t('subjectId')" prop="subject_id">
				    <el-cascader v-model="formData.subject_id" :options="subjectOptions" :props="subjectProps" clearable filterable popper-class="choice" :placeholder="t('subjectIdPlaceholder')" />
				    <div class="ml-[10px]">
				        <span class="cursor-pointer text-primary mr-[10px]" @click="refreshsubjectFn(true)">{{ t('refresh') }}</span>
				        <span class="cursor-pointer text-primary" @click="toSubjectEvent">{{ t('addSubject') }}</span>
				    </div>
				</el-form-item>
                
                <el-form-item :label="t('title')" prop="title">
                    <el-input v-model="formData.title" clearable :placeholder="t('titlePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('cover')" prop="cover">
					<div>
						<upload-image v-model="formData.cover" />
						<p class="text-[12px] text-[#a9a9a9]">建议图片尺寸：750*530像素；图片格式：jpg、png、jpeg。</p>
					</div>
                </el-form-item>
				
				<el-form-item :label="t('paperId')" prop="paper_id">
				    <div v-if="!formData.paper_id" class="input-width h-[32px] mr-[15px] px-[10px] box-border border-[1px] border-solid border-[var(--el-border-color)]">
				       <span class="text-[var(--el-text-color-secondary)]">{{t('paperIdPlaceholder')}}</span> 
				    </div>
				    <div v-if="formData.paper_id" class="parent-name input-width h-[32px] flex justify-between items-center mr-[15px] px-[10px] box-border border-[1px] border-solid border-[var(--el-border-color)]">
				       <span class="text-[var(--el-text-color-regular)]">{{ formData.paper_title }}</span> 
				    </div>
				    <el-button type="primary" @click="selectPaperFn">{{ t('toSelect') }}</el-button>
					
					<div class="ml-[10px]">
					    <span class="cursor-pointer text-primary" @click="toPaperEvent">{{ t('添加试卷') }}</span>
					</div>
				</el-form-item>
				
				<el-form-item :label="t('templateId')">
				    <div v-if="!formData.template_id" class="input-width h-[32px] mr-[15px] px-[10px] box-border border-[1px] border-solid border-[var(--el-border-color)]">
				       <span class="text-[var(--el-text-color-secondary)]">{{t('templateIdPlaceholder')}}</span> 
				    </div>
				    <div v-if="formData.template_id" class="parent-name input-width h-[32px] flex justify-between items-center mr-[15px] px-[10px] box-border border-[1px] border-solid border-[var(--el-border-color)]">
				       <span class="text-[var(--el-text-color-regular)]">{{ formData.template_name }}</span>
					   <el-icon class="cursor-pointer" color="#333" @click="formData.template_id = '';formData.template_name = ''"><Close /></el-icon>
					   
				    </div>
				    <el-button type="primary" @click="selectTemplateFn">{{ t('toSelect') }}</el-button>
					
					<div class="ml-[10px]">
					    <span class="cursor-pointer text-primary" @click="toTemplateEvent">{{ t('添加证书模板') }}</span>
					</div>
				</el-form-item>
				
				<el-form-item :label="t('startTime')" prop="start_time">
					<el-date-picker v-model="formData.start_time" type="datetime" :placeholder="t('startTimePlaceholder')" style="width: 300px;" />
				</el-form-item>
				
				<el-form-item :label="t('endTime')" prop="end_time">
					<el-date-picker v-model="formData.end_time" type="datetime" :placeholder="t('endTimePlaceholder')" style="width: 300px;" />
				</el-form-item>
                
				<el-form-item :label="t('mode')" prop="mode" v-if="formData.exam_id">
				    <template v-for="(item) in modeList" :key="item.value">
				        <div class="mode-wrap" :class="[formData.mode == item.value ? 'selected' : 'disabled']">
				            <div class="mode-name">{{ item.name }}</div>
							<div class="mode-desc">({{ item.desc }})</div>
				            <template v-if="formData.mode == item.value">
				                <div class="triangle"></div>
				                <div class="selected">✓</div>
				            </template>
				        </div>
				    </template>
				</el-form-item>
				<el-form-item v-else :label="t('mode')" prop="mode">
					<div class="mode-wrap" :class="{ 'selected': formData.mode == item.value }" v-for="(item) in modeList" :key="item.value" @click="changeMode(item)">
					    <div class="mode-name">{{ item.name }}</div>
					    <div class="mode-desc">({{ item.desc }})</div>
					    <template v-if="formData.mode == item.value">
					        <div class="triangle"></div>
					        <div class="selected">✓</div>
					    </template>
					</div>
				</el-form-item>
				
				<el-form-item :label="t('signEndTime')" prop="sign_end_time" v-if="formData.mode == 2" >
					<el-date-picker v-model="formData.sign_end_time" type="datetime" :placeholder="t('signEndTimePlaceholder')" style="width: 300px;" />
				</el-form-item>
				
				<el-form-item :label="t('price')" prop="price" v-if="formData.mode == 3" >
				    <el-input v-model.trim="formData.price" clearable placeholder="请输入收取费用" class="input-width" maxlength="8">
				        <template #append>{{ t('元') }}</template>
				    </el-input>
				</el-form-item>
				
				<el-form-item :label="t('password')" prop="password" v-if="formData.mode == 4" >
				    <el-input v-model="formData.password" clearable :placeholder="t('passwordPlaceholder')" class="input-width" />
				</el-form-item>
                
                <el-form-item :label="t('answertime')" prop="answertime">
					<el-input v-model.trim="formData.answertime" clearable :placeholder="t('answertimePlaceholder')" class="input-width" maxlength="8">
					    <template #append>{{ t('分钟') }}</template>
					</el-input>
                </el-form-item>
                
                <el-form-item :label="t('numLimit')" prop="num_limit">
					<div>
						<el-input-number v-model="formData.num_limit" clearable :placeholder="t('numLimitPlaceholder')" class="input-width" :min="0" />
						<p class="text-[12px] text-[#a9a9a9]">0为不限制考试次数。</p>
					</div>
					
				</el-form-item>
               
				<el-form-item :label="t('desc')" prop="desc">
				    <editor v-model="formData.desc" :height="300" class="editor-width" :placeholder="t('descPlaceholder')" />
				</el-form-item>
				
				<el-form-item :label="t('resultOpen')" prop="result_open">
					<el-switch v-model="formData.result_open" active-text="允许" inactive-text="不允许" class="input-width" :active-value="1" :inactive-value="2" />
				</el-form-item>
                
                <el-form-item :label="t('status')" prop="status">
                    <el-switch v-model="formData.status" active-text="开启" inactive-text="关闭" class="input-width" active-value="normal" inactive-value="hidden" />
                </el-form-item>

            </el-form>
        </el-card>
         <div class="fixed-footer-wrap">
            <div class="fixed-footer">
                <el-button type="primary" @click="onSave(formRef)">{{ t('save') }}</el-button>
                <el-button @click="back()">{{ t('cancel') }}</el-button>
            </div>
        </div>
		
		<paper-select-popup :title="t('选择试卷')" ref="paperSelectPopupRef" @load="selectPaperCallbackFn" />
		
		<template-select-popup :title="t('选择证书模板')" ref="templateSelectPopupRef" @load="selectTemplateCallbackFn" />
    </div>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import type { FormInstance } from 'element-plus'
import { getExamInfo,addExam,editExam,getSubjectTree,getExamMode } from '@/addon/zzexam/api/exam';
import { useRoute,useRouter } from 'vue-router'
import paperSelectPopup from '@/addon/zzexam/views/paper/components/paper-select-popup.vue'
import templateSelectPopup from '@/addon/zzexam/views/certificate/components/template-select-popup.vue'

const route = useRoute()
const router = useRouter()
const id:number = parseInt(route.query.id);
const loading = ref(false)
const pageName = route.meta.title



/**
 * 表单数据
 */
const initialFormData = {
    exam_id: 0,
    subject_id: '',
    title: '',
    cover: '',
    paper_id: '',
	paper_title:'',
    mode: 1,
    template_id: '',
	template_name:'',
    start_time: '',
    end_time: '',
    answertime: '',
    sign_end_time: '',
    price: '',
    password: '',
    num_limit: 0,
    result_open: 1,
    desc: '',
    status: 'normal',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const setFormData = async (id:number = 0) => {
    Object.assign(formData, initialFormData)
    const data = await (await getExamInfo(id)).data
    Object.keys(formData).forEach((key: string) => {
        if (data[key] != undefined) formData[key] = data[key]
    })
}
if(id) setFormData(id);

const formRef = ref<FormInstance>()
// 选中数据
const selectData = ref<any[]>([])

// 考试模式
const modeList = ref([])
const getExamModeListFn = async () => {
	modeList.value = await (await getExamMode()).data
}
getExamModeListFn()

// 科目
const subjectOptions = reactive([])
const subjectProps = { multiple: false,emitPath:false }
const refreshsubjectFn = (bool = false) => {
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
			subjectOptions.splice(0, subjectOptions.length, ...subjectTree)
			if (bool) {
				ElMessage({
					message: t('refreshSuccess'),
					type: 'success'
				})
			}
		}
	})
}

refreshsubjectFn()    
    
// 表单验证规则
const formRules = computed(() => {
    return {
		subject_id: [
			{ required: true, message: t('subjectIdPlaceholder'), trigger: 'blur' },
		],
		title: [
			{ required: true, message: t('titlePlaceholder'), trigger: 'blur' },
		],
		cover: [
			{ required: true, message: t('coverPlaceholder'), trigger: 'blur' },
		],
		paper_id: [
			{ required: true, message: t('paperIdPlaceholder'), trigger: 'blur' },
		],
		mode: [
			{ required: true, message: t('modePlaceholder'), trigger: 'blur' },
		],
		start_time: [
			{ required: true, message: t('startTimePlaceholder'), trigger: 'blur' },
		],
		end_time: [
			{ required: true, message: t('endTimePlaceholder'), trigger: 'blur' },
		],
		answertime: [
			{ required: true, message: t('answertimePlaceholder'), trigger: 'blur' },
		],
		sign_end_time: [
			{ required: true, message: t('signEndTimePlaceholder'), trigger: 'blur' },
		],
		price: [
			{ required: true, message: t('pricePlaceholder'), trigger: 'blur' },
		],
		password: [
			{ required: true, message: t('passwordPlaceholder'), trigger: 'blur' },
		],
		num_limit: [
			{ required: true, message: t('numLimitPlaceholder'), trigger: 'blur' },
		],
		result_open: [
			{ required: true, message: t('resultOpenPlaceholder'), trigger: 'blur' },
		],
		exam_people: [
			{ required: true, message: t('examPeoplePlaceholder'), trigger: 'blur' },
		],
		exam_num: [
			{ required: true, message: t('examNumPlaceholder'), trigger: 'blur' },
		],
		desc: [
			{ required: true, message: t('descPlaceholder'), trigger: 'blur' },
		],
		sort: [
			{ required: true, message: t('sortPlaceholder'), trigger: 'blur' },
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
           loading.value = true
           let data = formData

           const save = id ? editExam : addExam
           save(data).then(res => {
               loading.value = false
               history.back()
           }).catch(err => {
               loading.value = false
           })
       }
    })
}

// 选择试卷弹框
const paperSelectPopupRef = ref<any>()

// 选择试卷
const selectPaperFn = () => {
    paperSelectPopupRef.value?.show();
}

// 试卷选择回调
const selectPaperCallbackFn = (row: any) => {
    formData.paper_id = row.paper_id
    formData.paper_title = row.title
    formRef.value?.validateField('paper_id')
}

// 选择证书模板弹框
const templateSelectPopupRef = ref<any>()

// 选择证书模板
const selectTemplateFn = () => {
    templateSelectPopupRef.value?.show();
}

// 证书模板回调
const selectTemplateCallbackFn = (row: any) => {
    formData.template_id = row.id
    formData.template_name = row.name
    formRef.value?.validateField('template_id')
}

// 更改选题模式
const changeMode = (item: any) => {
	formData.mode = item.value
}


// 跳转到科目管理，添加科目
const toSubjectEvent = () => {
	const url = router.resolve({
		path: '/zzexam/subject'
	})
	window.open(url.href)
}

// 跳转到试卷管理，添加试卷
const toPaperEvent = () => {
	const url = router.resolve({
		path: '/zzexam/paper'
	})
	window.open(url.href)
}

// 跳转到证书模板管理，添加证书模板
const toTemplateEvent = () => {
	const url = router.resolve({
		path: '/zzexam/certificate/template'
	})
	window.open(url.href)
}



const back = () => {
    history.back()
}
</script>

<style lang="scss" scoped>
	.mode-wrap {
	  width: 160px;
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
