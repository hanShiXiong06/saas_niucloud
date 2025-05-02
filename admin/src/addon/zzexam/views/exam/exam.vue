<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addExam') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="examTable.searchParam" ref="searchFormRef">
					
					<el-form-item class="w-[240px]"  :label="t('subjectId')" prop="subject_id">
					    <el-cascader v-model="examTable.searchParam.subject_id" :options="examSubjectOptions" :placeholder="t('subjectIdPlaceholder')" clearable :props="{ value: 'value', label: 'label', emitPath:false }"/>
					</el-form-item>
                    <el-form-item :label="t('title')" prop="title">
                        <el-input v-model="examTable.searchParam.title" :placeholder="t('titlePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('mode')" prop="mode">
                        <el-input v-model="examTable.searchParam.mode" :placeholder="t('modePlaceholder')" />
                    </el-form-item>

					<el-form-item class="w-[240px]" :label="t('status')" prop="status">
						<el-select v-model="examTable.searchParam.status" filterable clearable :placeholder="t('statusPlaceholder')">
						   <el-option
							   v-for="(item, index) in statusList"
							   :key="index"
							   :label="item['name']"
							   :value="item['value']"
						   />
						</el-select>
					</el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadExamList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="examTable.data" size="large" v-loading="examTable.loading">
                    <template #empty>
                        <span>{{ !examTable.loading ? t('emptyData') : '' }}</span>
                    </template>
					
					<el-table-column prop="exam_id" :label="t('ID')" min-width="70" :show-overflow-tooltip="true"/>
                    <el-table-column :label="t('cover')" min-width="130" align="left">
                        <template #default="{ row }">
                            <div class="h-[70px]">
                                <el-image class="w-[100px] h-[70px] " :src="img(row.cover)" fit="contain">
                                    <template #error>
                                        <div class="image-slot">
                                            <img class="w-[100px] h-[70px]" src="@/addon/zzexam/assets/no_img.png" />
                                        </div>
                                    </template>
                                </el-image>
                            </div>
                        </template>
                    </el-table-column>
					<el-table-column prop="subject.full_name" :label="t('subjectId')" min-width="180" :show-overflow-tooltip="true"/>
                    
					
                    <el-table-column prop="title" :label="t('title')" min-width="330" :show-overflow-tooltip="true"/>
                    
					
                    
					<el-table-column :label="t('模式')" min-width="180" align="left">
					    <template #default="{ row }">
							考试：{{ row.mode_arr.name }} <br/>
					        选题：{{ row.paper.mode_name }} 
					    </template>
					</el-table-column>
					
                    <el-table-column :label="t('考试时间')" min-width="210" align="left">
                        <template #default="{ row }">
                            开放：{{ row.start_time }} <br/>关闭：{{ row.end_time }}
                        </template>
                    </el-table-column>
					<el-table-column :label="t('数据')" min-width="120" align="left">
					    <template #default="{ row }">
							考试：{{ row.exam_num }} 次<br/>
					        考生：{{ row.exam_people }} 名<br/>
							浏览：{{ row.views }} 次<br/>
					    </template>
					</el-table-column>
					
					<el-table-column prop="status" :label="t('status')" min-width="100" align="left">
                        <template #default="{ row }">
                            <el-tag class="cursor-pointer" :type="row.status == 'normal' ? 'success' : 'danger'" >{{ row.status == 'normal' ? '开启' : '关闭' }}</el-tag>
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.exam_id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="examTable.page" v-model:page-size="examTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="examTable.total"
                        @size-change="loadExamList()" @current-change="loadExamList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getExamList, deleteExam, getSubjectTree } from '@/addon/zzexam/api/exam'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let examTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "subject_id":"",
      "title":"",
      "mode":"",
      "status":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

const statusList = reactive([
	{name:'开启',value:'normal'},
	{name:'关闭',value:'hidden'},
]);  

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

examSubjectOptionsFn()   

/**考试
 * 获取考试管理列表
 */
const loadExamList = (page: number = 1) => {
    examTable.loading = true
    examTable.page = page

    getExamList({
        page: examTable.page,
        limit: examTable.limit,
         ...examTable.searchParam
    }).then(res => {
        examTable.loading = false
        examTable.data = res.data.data
        examTable.total = res.data.total
    }).catch(() => {
        examTable.loading = false
    })
}
loadExamList()

const router = useRouter()

/**考试
 * 添加考试管理
 */
const addEvent = () => {
    router.push('/zzexam/exam_edit')
}

/**考试
 * 编辑考试管理
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/zzexam/exam_edit?id='+data.exam_id)
}

/**考试
 * 删除考试管理
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('examDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteExam(id).then(() => {
            loadExamList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadExamList()
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
