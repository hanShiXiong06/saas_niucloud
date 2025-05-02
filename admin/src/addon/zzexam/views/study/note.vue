<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
            </div>

            

            <div class="mt-[10px]">
                <el-table :data="noteTable.data" size="large" v-loading="noteTable.loading">
                    <template #empty>
                        <span>{{ !noteTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column :label="t('memberId')" min-width="170" :show-overflow-tooltip="true">
                         <template #default="{ row }">
                     		 <div class="flex items-center cursor-pointer" v-if="row.member">
                     		     <img class="w-[50px] h-[50px] mr-[10px]" v-if="row.member.headimg" :src="img(row.member.headimg)" alt="">
                     		     <img class="w-[50px] h-[50px] mr-[10px] rounded-full" v-else src="@/app/assets/images/member_head.png" alt="">
                     		     <div class="flex flex flex-col">
                     		        <div>{{ row.member.member_no || '' }}</div>
                     				<div>{{ row.member.nickname || '' }}</div>
                     		     </div>
                     			
                     		 </div>
                          </template>
                    </el-table-column>
                    
                    <el-table-column prop="type_name" :label="t('type')" min-width="120" :show-overflow-tooltip="true"/>
                    
					<el-table-column prop="target.title" :label="t('标题')" min-width="280" :show-overflow-tooltip="true"/>
					
                    <el-table-column prop="content" :label="t('content')" min-width="300" :show-overflow-tooltip="true"/>
                    
					<el-table-column prop="create_time" :label="t('createTime')" min-width="220" :show-overflow-tooltip="true"/>
                    
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="deleteEvent(row.note_id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="noteTable.page" v-model:page-size="noteTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="noteTable.total"
                        @size-change="loadNoteList()" @current-change="loadNoteList" />
                </div>
            </div>

            <edit ref="editNoteDialog" @complete="loadNoteList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getNoteList, deleteNote } from '@/addon/zzexam/api/study'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/zzexam/views/study/components/note-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let noteTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "member_id":"",
      "type":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取会员笔记列表
 */
const loadNoteList = (page: number = 1) => {
    noteTable.loading = true
    noteTable.page = page

    getNoteList({
        page: noteTable.page,
        limit: noteTable.limit,
         ...noteTable.searchParam
    }).then(res => {
        noteTable.loading = false
        noteTable.data = res.data.data
        noteTable.total = res.data.total
    }).catch(() => {
        noteTable.loading = false
    })
}
loadNoteList()

const editNoteDialog: Record<string, any> | null = ref(null)

/**
 * 添加会员笔记
 */
const addEvent = () => {
    editNoteDialog.value.setFormData()
    editNoteDialog.value.showDialog = true
}

/**
 * 编辑会员笔记
 * @param data
 */
const editEvent = (data: any) => {
    editNoteDialog.value.setFormData(data)
    editNoteDialog.value.showDialog = true
}

/**
 * 删除会员笔记
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('noteDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteNote(id).then(() => {
            loadNoteList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadNoteList()
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
