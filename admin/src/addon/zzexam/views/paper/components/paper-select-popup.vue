<template>
    <div>
        <el-dialog v-model="showDialog" :title="prop.title" width="1000px" :close-on-press-escape="false" :destroy-on-close="true" :close-on-click-modal="false">
            <el-form :inline="true" :model="paperTable.searchParam" ref="searchFormRef" @submit.native.prevent>
                <el-form-item class="w-[240px]"  :label="t('试卷分类')" prop="category_id">
                    <el-cascader v-model="paperTable.searchParam.category_id" :options="paperCategoryOptions" :placeholder="t('请选项试卷分类')" clearable :props="{ value: 'value', label: 'label', emitPath:false }"/>
                </el-form-item>
                <el-form-item :label="t('试卷名称')" prop="title">
                    <el-input v-model="paperTable.searchParam.title" :placeholder="t('请输入试卷名称')" clearable />
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="getPaperListFn()">{{ t('search') }}</el-button>
                    <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                </el-form-item>
            </el-form>

            <el-table :data="paperTable.data" size="large" v-loading="paperTable.loading" max-height="400" @selection-change="handleSelectionChange">
                <template #empty>
                    <span>{{ !paperTable.loading ? t('emptyData') : '' }}</span>
                </template>
                <el-table-column v-if="prop.max>1" type="selection" width="55" />
                
				<el-table-column prop="category.full_name" :label="t('试卷分类')" min-width="150" :show-overflow-tooltip="true"/>
				
				<el-table-column prop="title" :label="t('试卷名称')" min-width="220" :show-overflow-tooltip="true"/>
				
				<el-table-column prop="mode" :label="t('mode')" min-width="120" :show-overflow-tooltip="true">
				    <template #default="{ row }">
				        <el-tag class="cursor-pointer" :type="row.mode == 1 ? 'success' : ''">{{ row.mode == 1 ? '题库抽题' : '手动选题' }}</el-tag>
				    </template>
				</el-table-column>
				
                <el-table-column v-if="prop.max==1" :label="t('operation')" fixed="right" align="right">
                    <template #default="{row}">
                        <el-button type="primary" @click="rowSave(row)">选择</el-button>
                    </template>
                </el-table-column>
            </el-table>
            <div class="mt-[16px] flex justify-end">
                <el-pagination v-model:current-page="paperTable.page" v-model:page-size="paperTable.limit"
                    layout="total, sizes, prev, pager, next, jumper" :total="paperTable.total"
                    @size-change="getPaperListFn()" @current-change="getPaperListFn" />
            </div>

            <template #footer>
                <span class="dialog-footer" v-if="prop.max>1">
                    <el-button @click="showDialog = false">{{ t('cancel') }}</el-button>
                    <el-button type="primary" @click="save">{{ t('confirm') }}</el-button>
                </span>
            </template>
        </el-dialog>
    </div>
</template>

<script lang="ts" setup>
import { t } from '@/lang'
import { ref, reactive } from 'vue'
import { img } from '@/utils/common'
import { cloneDeep } from 'lodash-es'
import { ElMessage, FormInstance } from 'element-plus'
import { getPaperSelectList } from '@/addon/zzexam/api/paper'
import { getCategoryTree } from '@/addon/zzexam/api/study'

const prop = defineProps({
    title:{
        type:String,
        default:''
    },
    max: {
        type: Number,
        default: 1
    },
})

const showDialog = ref(false)
const emit = defineEmits(['load'])
const paperTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
        category_id:"",
		title:""
    }
})

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
 * 获取会员列表
 */
const getPaperListFn = (page: number = 1) => {
    paperTable.loading = true
    paperTable.page = page
    const searchData = cloneDeep(paperTable.searchParam)
    getPaperSelectList({
        page: paperTable.page,
        limit: paperTable.limit,
        ...searchData
    }).then(res => {
        paperTable.loading = false;
        paperTable.data = res.data.data;
        paperTable.total = res.data.total;
    }).catch(() => {
        paperTable.loading = false
    })
}

let searchFormRef = ref<FormInstance>()
// 重置搜索条件
const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    paperTable.searchParam.search = "";
    getPaperListFn()
}

let selectPaperData = ref<Array<any>>([]);
// 选择会员列表
const handleSelectionChange = (data:Array<any>)=>{
    selectPaperData.value=data;
}

const show = (data: any) => {
    getPaperListFn()
    showDialog.value = true
}

const save = () => {
    if(selectPaperData.value.length > prop.max){
        ElMessage.error(`最多选择${prop.max}个会员`);
        return
    }
    emit('load',selectPaperData.value);
    showDialog.value = false;
}
const rowSave = (row:any)=>{
    emit('load',row);
    showDialog.value = false;
}
defineExpose({
    showDialog,
    show
})
</script>

<style lang="scss" scoped>
</style>
