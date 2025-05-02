<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addPwd') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="pwdTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('examId')" prop="exam_id">
                        <el-input v-model="pwdTable.searchParam.exam_id" :placeholder="t('examIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('memberId')" prop="member_id">
                        <el-input v-model="pwdTable.searchParam.member_id" :placeholder="t('memberIdPlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadPwdList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="pwdTable.data" size="large" v-loading="pwdTable.loading">
                    <template #empty>
                        <span>{{ !pwdTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="exam_id" :label="t('examId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="member_id" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="password" :label="t('password')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.sign_id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="pwdTable.page" v-model:page-size="pwdTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="pwdTable.total"
                        @size-change="loadPwdList()" @current-change="loadPwdList" />
                </div>
            </div>

            <edit ref="editPwdDialog" @complete="loadPwdList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getPwdList, deletePwd } from '@/addon/zzexam/api/exam'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/zzexam/views/exam/components/pwd-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let pwdTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "exam_id":"",
      "member_id":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取考试密码列表
 */
const loadPwdList = (page: number = 1) => {
    pwdTable.loading = true
    pwdTable.page = page

    getPwdList({
        page: pwdTable.page,
        limit: pwdTable.limit,
         ...pwdTable.searchParam
    }).then(res => {
        pwdTable.loading = false
        pwdTable.data = res.data.data
        pwdTable.total = res.data.total
    }).catch(() => {
        pwdTable.loading = false
    })
}
loadPwdList()

const editPwdDialog: Record<string, any> | null = ref(null)

/**
 * 添加考试密码
 */
const addEvent = () => {
    editPwdDialog.value.setFormData()
    editPwdDialog.value.showDialog = true
}

/**
 * 编辑考试密码
 * @param data
 */
const editEvent = (data: any) => {
    editPwdDialog.value.setFormData(data)
    editPwdDialog.value.showDialog = true
}

/**
 * 删除考试密码
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('pwdDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deletePwd(id).then(() => {
            loadPwdList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadPwdList()
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
