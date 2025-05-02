<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addChatModel') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="chatModelTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="chatModelTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadChatModelList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="chatModelTable.data" size="large" v-loading="chatModelTable.loading">
                    <template #empty>
                        <span>{{ !chatModelTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                     <el-table-column :label="t('logo')" width="100" align="left">
                        <template #default="{ row }">
                            <el-avatar v-if="row.logo" :src="img(row.logo)" />
                            <el-avatar v-else icon="UserFilled" />
                        </template>
                    </el-table-column>
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="desc" :label="t('desc')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="demo" :label="t('demo')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="content" :label="t('content')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="chatModelTable.page" v-model:page-size="chatModelTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="chatModelTable.total"
                        @size-change="loadChatModelList()" @current-change="loadChatModelList" />
                </div>
            </div>

            <edit ref="editChatModelDialog" @complete="loadChatModelList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getChatModelList, deleteChatModel } from '@/addon/ai_humans/api/chatmodel'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/ai_humans/views/chatmodel/components/chatmodel-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let chatModelTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "name":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取对话模型列表
 */
const loadChatModelList = (page: number = 1) => {
    chatModelTable.loading = true
    chatModelTable.page = page

    getChatModelList({
        page: chatModelTable.page,
        limit: chatModelTable.limit,
         ...chatModelTable.searchParam
    }).then(res => {
        chatModelTable.loading = false
        chatModelTable.data = res.data.data
        chatModelTable.total = res.data.total
    }).catch(() => {
        chatModelTable.loading = false
    })
}
loadChatModelList()

const editChatModelDialog: Record<string, any> | null = ref(null)

/**
 * 添加对话模型
 */
const addEvent = () => {
    editChatModelDialog.value.setFormData()
    editChatModelDialog.value.showDialog = true
}

/**
 * 编辑对话模型
 * @param data
 */
const editEvent = (data: any) => {
    editChatModelDialog.value.setFormData(data)
    editChatModelDialog.value.showDialog = true
}

/**
 * 删除对话模型
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('chatModelDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteChatModel(id).then(() => {
            loadChatModelList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadChatModelList()
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
