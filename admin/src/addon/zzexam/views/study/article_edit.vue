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
            <el-form :model="formData" label-width="110px" ref="formRef" :rules="formRules" class="page-form">
				
				<el-form-item :label="t('type')" prop="type" v-if="formData.article_id">
				    <template v-for="(item,key) in typeList" :key="item.type">
				        <div class="article-type-wrap" :class="[formData.type == item.type ? 'selected' : 'disabled']">
				            <div class="article-type-name">{{ item }}</div>
				            <template v-if="formData.type == key">
				                <div class="triangle"></div>
				                <div class="selected">✓</div>
				            </template>
				        </div>
				    </template>
				</el-form-item>
				<el-form-item :label="t('type')" prop="type" v-else>
				    <div class="article-type-wrap" :class="{ 'selected': formData.type == item.type }" v-for="(item,key) in typeList" :key="item.type" @click="changeType(key)">
				        <div class="article-type-name">{{ item }}</div>
				        <template v-if="formData.type == key">
				            <div class="triangle"></div>
				            <div class="selected">✓</div>
				        </template>
				    </div>
				</el-form-item>
				
                <el-form-item :label="t('categoryId')" prop="category_id">
					<el-cascader v-model="formData.category_id" :options="categoryOptions" :props="categoryProps" clearable filterable popper-class="choice" :placeholder="t('categoryIdPlaceholder')" />
					<div class="ml-[10px]">
						<span class="cursor-pointer text-primary mr-[10px]" @click="refreshCategoryFn(true)">{{ t('refresh') }}</span>
						<span class="cursor-pointer text-primary" @click="toCategoryEvent">{{ t('addCategory') }}</span>
					</div>
				</el-form-item>
                
                <el-form-item :label="t('title')" prop="title">
                    <el-input v-model="formData.title" clearable :placeholder="t('titlePlaceholder')" class="input-width" />
                </el-form-item>
                
                <el-form-item :label="t('image')" prop="image">
					<div>
						<upload-image v-model="formData.image" />
						<p class="text-[12px] text-[#a9a9a9]">建议图片尺寸：210*195像素；图片格式：jpg、png、jpeg。</p>
					</div>
                </el-form-item>
				
                <el-form-item :label="t('author')" prop="author" >
                    <el-input v-model="formData.author" clearable :placeholder="t('authorPlaceholder')" class="input-width" />
                </el-form-item>
                <el-form-item :label="t('intro')" prop="intro">
                    <el-input v-model="formData.intro" type="textarea" rows="4" clearable :placeholder="t('introPlaceholder')" class="input-width"/>
                </el-form-item>
                
                <el-form-item :label="t('content')" prop="content">
                    <editor v-model="formData.content" />
                </el-form-item>
                
                <el-form-item :label="t('virtualviews')" prop="virtualviews">
                    <el-input-number v-model="formData.virtualviews" clearable :placeholder="t('virtualviewsPlaceholder')"  class="input-width"  :min = "0" />
                </el-form-item>
                
                <el-form-item :label="t('sort')" prop="sort">
                    <el-input-number v-model="formData.sort" clearable :placeholder="t('sortPlaceholder')"  class="input-width"  :min = "0" />
                </el-form-item>
                
                <el-form-item :label="t('status')" prop="status">
                	<el-radio-group v-model="formData.status">
                	    <el-radio :label="'normal'">显示</el-radio>
                	    <el-radio :label="'hidden'">隐藏</el-radio>
                	  </el-radio-group>
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
import type { FormInstance } from 'element-plus'
import { getArticleInfo,addArticle,editArticle, getCategoryList,getArticleTypeList,getCategoryTree } from '@/addon/zzexam/api/study';
import { useRoute,useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()
const id:number = parseInt(route.query.id);
const loading = ref(false)
const pageName = route.meta.title


/**
 * 表单数据
 */
const initialFormData = {
    article_id: 0,
	type:'know',
    category_id: '',
    title: '',
    author: '',
    image: '',
    intro: '',
    content: '',
    virtualviews: 0,
    sort: 0,
    status: 'normal',
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const setFormData = async (id:number = 0) => {
    Object.assign(formData, initialFormData)
    const data = await (await getArticleInfo(id)).data
    Object.keys(formData).forEach((key: string) => {
        if (data[key] != undefined) formData[key] = data[key]
    })
	refreshCategoryFn();
}


const formRef = ref<FormInstance>()
// 选中数据
const selectData = ref<any[]>([])

// 字典数据
// 分类
const categoryOptions = reactive([])
const categoryProps = { multiple: false,emitPath:false }
const refreshCategoryFn = (bool = false) => {
	getCategoryTree({type:formData.type}).then((res) => {
		const data = res.data
		if (data) {
			const categoryTree: any = []
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
				categoryTree.push({
					value: item.category_id,
					label: item.name,
					children
				})
			})
			categoryOptions.splice(0, categoryOptions.length, ...categoryTree)
			if (bool) {
				ElMessage({
					message: t('refreshSuccess'),
					type: 'success'
				})
			}
		}
	})
}

if(id) {
	setFormData(id)
}else{
	refreshCategoryFn();
}

// 类型
const typeList = ref([])
const getArticleTypeListFn = async () => {
	typeList.value = await (await getArticleTypeList()).data
}
getArticleTypeListFn()

// 表单验证规则
const formRules = computed(() => {
    return {
		type: [
			{ required: true, message: t('typePlaceholder'), trigger: 'blur' },
		],
		category_id: [
			{ required: true, message: t('categoryIdPlaceholder'), trigger: 'blur' },
		],
		title: [
			{ required: true, message: t('titlePlaceholder'), trigger: 'blur' },
		],
		url: [
			{ required: true, message: t('urlPlaceholder'), trigger: 'blur' },
		],
		image: [
			{ required: true, message: t('imagePlaceholder'), trigger: 'blur' },
		],
		content: [
			{ required: true, message: t('contentPlaceholder'), trigger: 'blur' },
		],
		virtualviews: [
			{ required: true, message: t('virtualviewsPlaceholder'), trigger: 'blur' },
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

           const save = id ? editArticle : addArticle
           save(data).then(res => {
               loading.value = false
               history.back()
           }).catch(err => {
               loading.value = false
           })

       }
    })
}

// 切换类型
const changeType = (value: any) => {
	formData.type = value
	refreshCategoryFn()
}

// 跳转到分类，添加分类
const toCategoryEvent = () => {
	const url = router.resolve({
		path: '/zzexam/category'
	})
	window.open(url.href)
}

const back = () => {
    history.back()
}
</script>

<style lang="scss" scoped>
	.article-type-wrap {
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
			.article-type-name {
			  color: #999;
			}
		}
		
		&:nth-child(2n) {
			margin: 0 12px;
		}
	}
</style>
