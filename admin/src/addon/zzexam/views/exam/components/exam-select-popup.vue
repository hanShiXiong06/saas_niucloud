<template>
    <div>
        <div @click="show">
            <slot>
                <el-button>选择考试</el-button>
                <div class="inline-block ml-[10px] text-[14px]" v-show="examIds.length">
                    <span>已选</span>
                    <span class="text-primary mx-[2px]">{{ examIds.length }}</span>
                </div>
            </slot>
        </div>
        <el-dialog v-model="showDialog" title="考试选择" width="60%"
            :close-on-press-escape="false" :destroy-on-close="true" :close-on-click-modal="false">

            <el-form :inline="true" :model="examTable.searchParam" ref="searchFormRef">
                <el-form-item prop="select_type" class="form-item-wrap">
                    <el-select v-model="examTable.searchParam.select_type" @change="handleSelectTypeChange">
                        <el-option label="全部" value="all" />
                        <el-option label="已选" value="selected" />
                    </el-select>
                </el-form-item>
				<el-form-item class="form-item-wrap" label="归属科目" prop="subject_id">
				    <el-cascader v-model="examTable.searchParam.subject_id" :options="examSubjectOptions" placeholder="请选择科目" clearable :props="{ value: 'value', label: 'label', emitPath:false }"/>
				</el-form-item>
                <el-form-item label="考试名称" prop="title" class="form-item-wrap">
                    <el-input v-model="examTable.searchParam.title" placeholder="请输入考试名称" maxlength="60" />
                </el-form-item>
               
                <el-form-item class="form-item-wrap">
                    <el-button type="primary" @click="loadExamList()">{{ t('search') }}</el-button>
                    <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                </el-form-item>
            </el-form>

            <el-table :data="examTable.data" size="large" v-loading="examTable.loading" ref="examListTableRef"
                max-height="400" @select="handleSelectChange" @select-all="handleSelectAllChange">
                <template #empty>
                    <span>{{ !examTable.loading ? t('emptyData') : '' }}</span>
                </template>
                <el-table-column type="selection" width="55" />
				
				<el-table-column prop="subject.full_name" label="归属科目" min-width="180" :show-overflow-tooltip="true"/>
				
				<el-table-column prop="title" label="考试名称" min-width="200" :show-overflow-tooltip="true"/>
				
				<el-table-column label="封面图片" min-width="150" align="left">
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
				
				<el-table-column prop="mode_arr.name" label="考试模式" min-width="120" :show-overflow-tooltip="true"/>
				<el-table-column prop="paper.mode_name" :label="t('选题模式')" min-width="120" :show-overflow-tooltip="true"/>
				
				

            </el-table>
            <div class="mt-[16px] flex">
                <div class="flex items-center flex-1">
                    <div class="layui-table-bottom-left-container mr-[10px]" v-show="selectExamNum">
                        <span>已选择</span>
                        <span class="text-primary mx-[2px]">{{ selectExamNum }}</span>
                    </div>
                    <el-button type="primary" link @click="clear" v-show="selectExamNum">
                        取消选择
                    </el-button>
                </div>
                <el-pagination v-model:current-page="examTable.page" v-model:page-size="examTable.limit"
                    layout="total, sizes, prev, pager, next, jumper" :total="examTable.total"
                    @size-change="loadExamList()" @current-change="loadExamList" />
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
import { img } from '@/utils/common'
import { ElMessage } from 'element-plus'
import { getExamSelectPageList, getSubjectTree } from '@/addon/zzexam/api/exam'

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

const emit = defineEmits(['update:modelValue'])

const examIds: any = computed({
    get () {
        return prop.modelValue
    },
    set (value) {
        emit('update:modelValue', value)
    }
})

const showDialog = ref(false)

// 已选考试列表
const selectExam: any = reactive({})

// 已选考试数量
const selectExamNum: any = computed(() => {
    return Object.keys(selectExam).length
})

const examTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        title: '',
		subject_id:'',
        select_type: 'all',
        exam_ids: '',
        verify_exam_ids: '',
    }
})

const searchFormRef = ref()

// 条件筛选查询

// 查询全部/已选考试
const handleSelectTypeChange = (value: any) => {
    loadExamList()
}

// 考试科目
const examSubjectOptions: any = reactive([])
const examSubjectProps = {
    checkStrictly: true
}

// 初始化数据
const initData = () => {
	// 查询科目树结构
    getSubjectTree().then((res) => {
        const data = res.data
        if (data) {
            const examSubjectTree: any = []
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
                examSubjectTree.push({
                    value: item.subject_id,
                    label: item.name,
                    children
                })
            })
            examSubjectOptions.splice(0, examSubjectOptions.length, ...examSubjectTree)
        }
    })
    
}

initData()

const examListTableRef = ref()

// 选中数据
const multipleSelection: any = ref([])

// 监听表格复选框
const handleSelectChange = (selection: any, row: any) => {
    // 是否选中
    let isSelected = false
    for (let i = 0; i < selection.length; i++) {
        if (selection[i].exam_id == row.exam_id) {
            isSelected = true
            break
        }
    }
    if (isSelected) {
        selectExam['exam_' + row.exam_id] = row
    } else {
        // 未选中，删除当前考试
        delete selectExam['exam_' + row.exam_id]
    }
}

// 监听表格全选
const handleSelectAllChange = (selection: any) => {
    if (selection.length) {
        selection.forEach((item: any) => {
            selectExam['exam_' + item.exam_id] = item
        })
    } else {
        // 未选中，删除当前页面的数据
        examTable.data.forEach((item: any) => {
            delete selectExam['exam_' + item.exam_id]
        })
    }
}

/**
 * 获取考试列表
 */
const loadExamList = (page: number = 1, callback: any = null) => {
    examTable.loading = true
    examTable.page = page

    const searchData = cloneDeep(examTable.searchParam);

    if (searchData.select_type == 'selected') {
        const exam_ids = <any>[]
        for (let k in selectExam) {
            exam_ids.push(parseInt(k.replace('exam_', '')))
        }
        searchData.exam_ids = exam_ids
    } else {
        searchData.exam_ids = '';
    }

    getExamSelectPageList({
        page: examTable.page,
        limit: examTable.limit,
        ...searchData
    }).then(res => {
        examTable.loading = false
        examTable.data = res.data.data
        examTable.total = res.data.total

        if (callback) callback(res.data.verify_exam_ids)

        setExamSelected();

    }).catch(() => {
        examTable.loading = false
    })

}

// 表格设置选中状态
const setExamSelected = () => {
    nextTick(() => {
        if (!examListTableRef.value) return;
        for (let i = 0; i < examTable.data.length; i++) {
            examListTableRef.value.toggleRowSelection(examTable.data[i], false);
            if (selectExam['exam_' + examTable.data[i].exam_id]) {
                examListTableRef.value.toggleRowSelection(examTable.data[i], true);
            }
        }
    });
}

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()

    loadExamList()
}

const show = () => {
    // 检测考试id集合是否存在，移除不存在的考试id，纠正数据准确性
    examTable.searchParam.verify_exam_ids = examIds.value;
    loadExamList(1, (verify_exam_ids: any) => {
        // 第一次打开弹出框时，纠正数据，并且赋值已选考试
        if (examIds.value) {
            examIds.value.splice(0, examIds.value.length, ...verify_exam_ids)
            examIds.value.forEach((item: any) => {
                if (!selectExam['exam_' + item]) {
                    selectExam['exam_' + item] = {};
                }
            })

            // 赋值已选择的考试
            for (let i = 0; i < examTable.data.length; i++) {
                if (examIds.value.indexOf(examTable.data[i].exam_id) != -1) {
                    selectExam['exam_' + examTable.data[i].exam_id] = examTable.data[i];
                }
            }
        }
    })
    showDialog.value = true
}

// 清空已选考试
const clear = () => {
    for (let k in selectExam) {
        delete selectExam[k];
    }
    setExamSelected();
}

const save = () => {
    if (prop.min && selectExamNum.value < prop.min) {
        ElMessage({
            type: 'warning',
            message: `${t('examSelectPopupExamMinTip')}${prop.min}${t('examSelectPopupPiece')}`,
        });
        return;
    }

    if (prop.max && prop.max > 0 && selectExamNum.value && selectExamNum.value > prop.max) {
        ElMessage({
            type: 'warning',
            message: `${t('examSelectPopupExamMaxTip')}${prop.max}${t('examSelectPopupPiece')}`,
        });
        return;
    }

    let ids: any = [];
    for (let k in selectExam) {
        ids.push(parseInt(k.replace('exam_', '')));
    }

    examIds.value.splice(0, examIds.value.length, ...ids)

    showDialog.value = false
}

defineExpose({
    showDialog,
    selectExam,
    selectExamNum
})
</script>

<style lang="scss" scoped>
.form-item-wrap {
    margin-right: 10px !important;
    margin-bottom: 10px !important;

    &.last-child {
        margin-right: 0 !important;
    }
}
</style>
