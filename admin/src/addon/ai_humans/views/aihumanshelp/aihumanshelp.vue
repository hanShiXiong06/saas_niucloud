<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addAihumansHelp') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="aihumansHelpTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('title')" prop="title">
                        <el-input v-model="aihumansHelpTable.searchParam.title" :placeholder="t('titlePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="aihumansHelpTable.searchParam.create_time" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadAihumansHelpList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="aihumansHelpTable.data" size="large" v-loading="aihumansHelpTable.loading">
                    <template #empty>
                        <span>{{ !aihumansHelpTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="title" :label="t('title')" min-width="120" :show-overflow-tooltip="true"/>
                    
                     <el-table-column :label="t('image')" width="100" align="left">
                        <template #default="{ row }">
                            <el-avatar v-if="row.image" :src="img(row.image)" />
                            <el-avatar v-else icon="UserFilled" />
                        </template>
                    </el-table-column>
                    <el-table-column prop="desc" :label="t('desc')" min-width="120" :show-overflow-tooltip="true"/>
                    
                
                    <el-table-column prop="view_num" :label="t('viewNum')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="aihumansHelpTable.page" v-model:page-size="aihumansHelpTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="aihumansHelpTable.total"
                        @size-change="loadAihumansHelpList()" @current-change="loadAihumansHelpList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getAihumansHelpList, deleteAihumansHelp } from '@/addon/ai_humans/api/aihumanshelp'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let aihumansHelpTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "title":"",
      "content":"",
      "create_time":[]
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取帮助中心列表
 */
const loadAihumansHelpList = (page: number = 1) => {
    aihumansHelpTable.loading = true
    aihumansHelpTable.page = page

    getAihumansHelpList({
        page: aihumansHelpTable.page,
        limit: aihumansHelpTable.limit,
         ...aihumansHelpTable.searchParam
    }).then(res => {
        aihumansHelpTable.loading = false
        aihumansHelpTable.data = res.data.data
        aihumansHelpTable.total = res.data.total
    }).catch(() => {
        aihumansHelpTable.loading = false
    })
}
loadAihumansHelpList()

const router = useRouter()

/**
 * 添加帮助中心
 */
const addEvent = () => {
    router.push('/aihumanshelp/aihumanshelp_edit')
}

/**
 * 编辑帮助中心
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/aihumanshelp/aihumanshelp_edit?id='+data.id)
}

/**
 * 删除帮助中心
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('aihumansHelpDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteAihumansHelp(id).then(() => {
            loadAihumansHelpList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadAihumansHelpList()
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
