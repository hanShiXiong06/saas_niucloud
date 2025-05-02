<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addPaper') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="paperTable.searchParam" ref="searchFormRef">
                    <el-form-item class="w-[240px]"  :label="t('categoryId')" prop="category_id">
                        <el-cascader v-model="paperTable.searchParam.category_id" :options="paperCategoryOptions" :placeholder="t('categoryIdPlaceholder')" clearable :props="{ value: 'value', label: 'label', emitPath:false }"/>
                    </el-form-item>
                    <el-form-item :label="t('title')" prop="title">
                        <el-input v-model="paperTable.searchParam.title" :placeholder="t('titlePlaceholder')" clearable />
                    </el-form-item>
                    <el-form-item class="w-[240px]" :label="t('status')" prop="status">
                    	<el-select v-model="paperTable.searchParam.status" filterable clearable :placeholder="t('statusPlaceholder')">
                    	   <el-option
                    		   v-for="(item, index) in statusList"
                    		   :key="index"
                    		   :label="item['name']"
                    		   :value="item['value']"
                    	   />
                    	</el-select>
                    	
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
						<el-date-picker v-model="paperTable.searchParam.create_time" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
							:start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
					</el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadPaperList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="paperTable.data" size="large" v-loading="paperTable.loading">
                    <template #empty>
                        <span>{{ !paperTable.loading ? t('emptyData') : '' }}</span>
                    </template>
					<el-table-column prop="category.full_name" :label="t('categoryId')" min-width="150" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="title" :label="t('title')" min-width="220" :show-overflow-tooltip="true"/>
                    
					<el-table-column prop="mode" :label="t('mode')" min-width="120" :show-overflow-tooltip="true">
					    <template #default="{ row }">
					        <el-tag class="cursor-pointer" :type="row.mode == 1 ? 'success' : ''">{{ row.mode == 1 ? '题库抽题' : '手动选题' }}</el-tag>
					    </template>
					</el-table-column>
                    
                    <el-table-column prop="question_num" :label="t('questionNum')" min-width="100" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="total_score" :label="t('totalScore')" min-width="100" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="pass_score" :label="t('passScore')" min-width="100" :show-overflow-tooltip="true"/>
                    
					<el-table-column prop="status" :label="t('status')" min-width="100" align="left">
					    <template #default="{ row }">
					        <el-tag class="cursor-pointer" type="info" v-if="row.status == 1" >未完善</el-tag>
							<el-tag class="cursor-pointer" v-if="row.status == 2" >已完善</el-tag>
							<el-tag class="cursor-pointer" type="error" v-if="row.status == 3" >已确认</el-tag>
					    </template>
					</el-table-column>
					
                    <el-table-column :label="t('createTime')" min-width="160" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            {{ row.create_time || '' }}
                        </template>
                    </el-table-column>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="170">
                       <template #default="{ row }">
						   <el-button type="primary" link v-if="row.status == 3" @click="detailEvent(row)">查看</el-button>
                           <el-button type="primary" link v-if="row.status != 3" @click="editEvent(row)">{{ t('edit') }}</el-button>
						   <el-button type="primary" link v-if="row.mode == 2" @click="questionEvent(row)">{{row.status == 3 ? '试题' : '选题'}}</el-button>
						   <el-button type="primary" link v-if="row.status != 3" @click="confirmEvent(row.paper_id)">确认</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.paper_id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="paperTable.page" v-model:page-size="paperTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="paperTable.total"
                        @size-change="loadPaperList()" @current-change="loadPaperList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getPaperList, deletePaper, confirmPaper } from '@/addon/zzexam/api/paper'
import { getCategoryTree } from '@/addon/zzexam/api/study'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

const statusList = reactive([
	{value:1,name:'未完善'},
	{value:2,name:'已完善'},
	{value:3,name:'已确认'},
]);  

let paperTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "category_id":"",
      "title":"",
      "status":"",
      "create_time":[]
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 试卷分类
const paperCategoryOptions: any = reactive([])
const paperCategoryOptionsFn = () => {
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
        }
    })
    
}

paperCategoryOptionsFn()

/**
 * 获取试卷列表
 */
const loadPaperList = (page: number = 1) => {
    paperTable.loading = true
    paperTable.page = page

    getPaperList({
        page: paperTable.page,
        limit: paperTable.limit,
         ...paperTable.searchParam
    }).then(res => {
        paperTable.loading = false
        paperTable.data = res.data.data
        paperTable.total = res.data.total
    }).catch(() => {
        paperTable.loading = false
    })
}
loadPaperList()

const router = useRouter()

/**
 * 添加试卷
 */
const addEvent = () => {
    router.push('/zzexam/paper_edit')
}

/**
 * 编辑试卷
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/zzexam/paper_edit?id='+data.paper_id)
}

/**
 * 试卷详情
 * @param data
 */
const detailEvent = (data: any) => {
    router.push('/zzexam/paper_detail?id='+data.paper_id)
}

/**
 * 试卷题目管理
 * @param data
 */
const questionEvent = (data: any) => {
    router.push('/zzexam/paper/question?paper_id='+data.paper_id)
}



/**
 * 删除试卷
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('paperDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deletePaper(id).then(() => {
            loadPaperList()
        }).catch(() => {})
    })
}

/**
 * 确认试卷
 */
const confirmEvent = (id: number) => {
    ElMessageBox.confirm(t('paperConfirmTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        confirmPaper(id).then(() => {
            loadPaperList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadPaperList()
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
