<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addHelpCat') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="helpCatTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('title')" prop="title">
                        <el-input v-model="helpCatTable.searchParam.title" :placeholder="t('titlePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadHelpCatList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="helpCatTable.data" size="large" v-loading="helpCatTable.loading">
                    <template #empty>
                        <span>{{ !helpCatTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="title" :label="t('title')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="helpCatTable.page" v-model:page-size="helpCatTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="helpCatTable.total"
                        @size-change="loadHelpCatList()" @current-change="loadHelpCatList" />
                </div>
            </div>

            <edit ref="editHelpCatDialog" @complete="loadHelpCatList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getHelpCatList, deleteHelpCat } from '@/addon/tk_partner/api/helpcat'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/tk_partner/views/helpcat/components/helpcat-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let helpCatTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "title":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取帮助分类列表
 */
const loadHelpCatList = (page: number = 1) => {
    helpCatTable.loading = true
    helpCatTable.page = page

    getHelpCatList({
        page: helpCatTable.page,
        limit: helpCatTable.limit,
         ...helpCatTable.searchParam
    }).then(res => {
        helpCatTable.loading = false
        helpCatTable.data = res.data.data
        helpCatTable.total = res.data.total
    }).catch(() => {
        helpCatTable.loading = false
    })
}
loadHelpCatList()

const editHelpCatDialog: Record<string, any> | null = ref(null)

/**
 * 添加帮助分类
 */
const addEvent = () => {
    editHelpCatDialog.value.setFormData()
    editHelpCatDialog.value.showDialog = true
}

/**
 * 编辑帮助分类
 * @param data
 */
const editEvent = (data: any) => {
    editHelpCatDialog.value.setFormData(data)
    editHelpCatDialog.value.showDialog = true
}

/**
 * 删除帮助分类
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('helpCatDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteHelpCat(id).then(() => {
            loadHelpCatList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadHelpCatList()
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
