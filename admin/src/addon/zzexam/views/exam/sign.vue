<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="signTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('realname')" prop="realname">
                        <el-input v-model="signTable.searchParam.realname" :placeholder="t('realnamePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('mobile')" prop="mobile">
                        <el-input v-model="signTable.searchParam.mobile" :placeholder="t('mobilePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-input v-model="signTable.searchParam.create_time" :placeholder="t('createTimePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadSignList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="signTable.data" size="large" v-loading="signTable.loading">
                    <template #empty>
                        <span>{{ !signTable.loading ? t('emptyData') : '' }}</span>
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
					
					<el-table-column prop="exam.title" :label="t('examId')" min-width="320" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="realname" :label="t('realname')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="mobile" :label="t('mobile')" min-width="120" :show-overflow-tooltip="true"/>
                    
					<el-table-column prop="create_time" :label="t('createTime')" min-width="220" :show-overflow-tooltip="true"/>
					
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="deleteEvent(row.sign_id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="signTable.page" v-model:page-size="signTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="signTable.total"
                        @size-change="loadSignList()" @current-change="loadSignList" />
                </div>
            </div>

            <edit ref="editSignDialog" @complete="loadSignList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getSignList, deleteSign } from '@/addon/zzexam/api/exam'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/zzexam/views/exam/components/sign-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let signTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "realname":"",
      "mobile":"",
      "create_time":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取考试报名列表
 */
const loadSignList = (page: number = 1) => {
    signTable.loading = true
    signTable.page = page

    getSignList({
        page: signTable.page,
        limit: signTable.limit,
         ...signTable.searchParam
    }).then(res => {
        signTable.loading = false
        signTable.data = res.data.data
        signTable.total = res.data.total
    }).catch(() => {
        signTable.loading = false
    })
}
loadSignList()

const editSignDialog: Record<string, any> | null = ref(null)

/**
 * 添加考试报名
 */
const addEvent = () => {
    editSignDialog.value.setFormData()
    editSignDialog.value.showDialog = true
}

/**
 * 编辑考试报名
 * @param data
 */
const editEvent = (data: any) => {
    editSignDialog.value.setFormData(data)
    editSignDialog.value.showDialog = true
}

/**
 * 删除考试报名
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('signDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteSign(id).then(() => {
            loadSignList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadSignList()
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
