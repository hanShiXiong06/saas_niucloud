<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">
            <div class="flex justify-between items-center mb-[5px]">
                <span class="text-page-title">{{ pageName }}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addSubject') }}
                </el-button>
            </div>
			
            <div class="mt-[10px]">
                <el-table :data="subjectTable.data" ref="tableRef" size="large" v-loading="subjectTable.loading" row-key="subject_id" :tree-props="{ hasChildren: 'hasChildren', children: 'child_list' }">
                    <template #empty>
                        <span>{{ !subjectTable.loading ? t('emptyData') : '' }}</span>
                    </template>
					
                    <el-table-column :label="t('subjectName')" min-width="300" align="left">
                        <template #default="{ row }">
                            <i class="order-0 iconfont icontuodong vues-rank mr-[8px]"></i>
                            <span class="order-2">{{ row.name }} （ID:{{row.subject_id}}）</span>
                        </template>
                    </el-table-column>
                    <el-table-column :label="t('image')" min-width="220" align="left">
                        <template #default="{ row }">
                            <div class="h-[30px]">
                                <el-image class="w-[30px] h-[30px] " :src="img(row.image)" fit="contain">
                                    <template #error>
                                        <div class="image-slot">
                                            <img class="w-[30px] h-[30px]" src="@/addon/zzexam/assets/no_img.png" />
                                        </div>
                                    </template>
                                </el-image>
                            </div>
                        </template>
                    </el-table-column>
                    <el-table-column prop="status" :label="t('Status')" min-width="220" align="left">
                        <template #default="{ row }">
                            <el-tag class="cursor-pointer" :type="row.status == 'normal' ? 'success' : 'danger'" @click="showClick(row)">{{ row.status == 'normal' ? '显示' : '隐藏' }}</el-tag>
                        </template>
                    </el-table-column>
                    <el-table-column prop="sort" :label="t('sort')" min-width="220" />
                    <el-table-column :label="t('operation')" fixed="right" align="right" width="220">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                            <el-button type="primary" link @click="deleteEvent(row)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
            </div>

            <subject-edit ref="editSubjectDialog" @complete="loadSubjectList" />
        </el-card>

    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, onMounted, nextTick } from 'vue'
import { t } from '@/lang'
import { getSubjectTree, deleteSubject, updateSubject, editSubject } from '@/addon/zzexam/api/exam'
import { img } from '@/utils/common'
import { ElMessageBox } from 'element-plus'
import subjectEdit from '@/addon/zzexam/views/exam/components/subject-edit.vue'
import { useRoute,useRouter } from 'vue-router'
import Sortable from 'sortablejs'
import { useTemplateRefsList } from '@vueuse/core'
import { cloneDeep } from 'lodash-es'

const route = useRoute()
const pageName = route.meta.title
const tableRef = useTemplateRefsList<HTMLElement>()
const subjectTable = reactive({
    loading: true,
    data: []
})

onMounted(() => {
    nextTick(() => {
        rowDrop()
    })
    loadSubjectList()
})

// 拖拽
const activeRows = ref<any[]>([])
// 拖拽排序
const rowDrop = () => {
    const tbody = tableRef.value.$el.querySelector('.el-table__body-wrapper tbody')
    Sortable.create(tbody, {
        handle: '.vues-rank',
        animation: 300,
        onMove: ({ dragged, related }) => {
            const oldRow = activeRows.value[dragged.rowIndex] // 移动的那个元素
            const newRow = activeRows.value[related.rowIndex] // 新的元素
            if (oldRow.pid !== newRow.pid) { // 移动的元素与新元素父级id不相同
                return false // 不允许跨级拖动
            }
        },
        onStart: () => { // 开始拖拽前把树形结构数据扁平化
            activeRows.value = treeToTile(cloneDeep(subjectTable.data)) // 把树形的结构转为列表再进行拖拽
        },
        onEnd: e => {
            const oldRow = activeRows.value[e.oldIndex] // 移动的那个元素
            const newRow = activeRows.value[e.newIndex] // 新的元素

            if (e.oldIndex === e.newIndex || oldRow.pid !== newRow.pid) return false

            const index = activeRows.value.indexOf(oldRow)

            if (index < 0) return false

            const currRow = activeRows.value.splice(e.oldIndex, 1)[0]
            activeRows.value.splice(e.newIndex, 0, currRow)
            const pid = newRow.pid
            const currentRows = activeRows.value.filter(c => c.pid === pid)?.map((item, index) => {
                if (item.level === 1 && item.subject_id === currRow.subject_id) {
                    subjectTable.data = subjectTable.data.filter(c => c.subject_id !== currRow.subject_id)
                    subjectTable.data.splice(index, 0, currRow)
                }
                if (item.level === 2 && item.subject_id === currRow.subject_id) {
                    const treeIndex = subjectTable.data.findIndex(el => el.subject_id === item.pid)
                    const obj = cloneDeep(subjectTable.data[treeIndex].child_list.filter(c => c.subject_id !== currRow.subject_id))
                    subjectTable.data[treeIndex].child_list = []
                    subjectTable.data[treeIndex].child_list.push(...obj)
                    subjectTable.data[treeIndex].child_list.splice(index, 0, currRow)
                }
                return {
                    subject_id: item.subject_id, // 当前行的唯一标识
                    sort: 9999 - index
                }
            })
            updateSubjectFn({ subject_sort_array: currentRows })
        }
    })
}

/**
  * 将树数据转化为平铺数据
  * @param <Array> treeData当前要转的id
  * @param <String> childKey 子级字段
  * @return <Array> 返回数据
  */
const treeToTile = (treeData:any, childKey = 'child_list') => {
    const arr:Array<any> = []
    const expanded = (data:any) => {
        if (data && data.length > 0) {
            data.filter((d:any) => d).forEach((e:any) => {
                arr.push(e)
                expanded(e[childKey] || [])
            })
        }
    }
    expanded(treeData)
    return arr
}

/**
 * 获取题目分类列表
 */
const loadSubjectList = () => {
    subjectTable.loading = true

    getSubjectTree().then(res => {
        subjectTable.loading = false
        subjectTable.data = res.data
    }).catch(() => {
        subjectTable.loading = false
    })
}
const updateSubjectFn = (params: any) => {
    updateSubject(params).then(res => {
        loadSubjectList()
    })
}

const showClick = (row: any) => {
    row.status = row.status === 'hidden' ? 'normal' : 'hidden'
    const obj = cloneDeep(row)
    delete obj.child_list
    editSubject(obj)
}
const editSubjectDialog: Record<string, any> | null = ref(null)

/**
 * 添加题目分类
 */
const addEvent = () => {
    editSubjectDialog.value.setFormData()
    editSubjectDialog.value.showDialog = true
}

/**
 * 编辑题目分类
 * @param data
 */
const editEvent = (data: any) => {
    editSubjectDialog.value.setFormData(data)
    editSubjectDialog.value.showDialog = true
}

/**
 * 删除题目分类
 */
const deleteEvent = (row: any) => {
    ElMessageBox.confirm(!row.child_list || !row.child_list.length ? t('subjectDeleteTips') : t('subjectDeleteTips1'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning'
        }
    ).then(() => {
        deleteSubject(row.subject_id).then(() => {
            loadSubjectList()
        }).catch(() => {
        })
    })
}

const handleClick = (event: any) => {
    subjectType.value = event;
    loadSubjectList()
}

</script>

<style lang="scss" scoped>
:deep(.el-table__row) {
    > .el-table__cell:nth-child(1) {
        .cell {
            display: flex;
            align-items: center;

            .el-table__expand-icon,
            .el-table__placeholder {
                order: 1;
            }

        }

    }
}
</style>
