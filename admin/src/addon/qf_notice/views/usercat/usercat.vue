<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addUserCat') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="userCatTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="userCatTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadUserCatList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="userCatTable.data" size="large" v-loading="userCatTable.loading">
                    <template #empty>
                        <span>{{ !userCatTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="userCatTable.page" v-model:page-size="userCatTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="userCatTable.total"
                        @size-change="loadUserCatList()" @current-change="loadUserCatList" />
                </div>
            </div>

            <edit ref="editUserCatDialog" @complete="loadUserCatList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getUserCatList, deleteUserCat } from '@/addon/qf_notice/api/usercat'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/qf_notice/views/usercat/components/usercat-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let userCatTable = reactive({
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
 * 获取用户分类列表
 */
const loadUserCatList = (page: number = 1) => {
    userCatTable.loading = true
    userCatTable.page = page

    getUserCatList({
        page: userCatTable.page,
        limit: userCatTable.limit,
         ...userCatTable.searchParam
    }).then(res => {
        userCatTable.loading = false
        userCatTable.data = res.data.data
        userCatTable.total = res.data.total
    }).catch(() => {
        userCatTable.loading = false
    })
}
loadUserCatList()

const editUserCatDialog: Record<string, any> | null = ref(null)

/**
 * 添加用户分类
 */
const addEvent = () => {
    editUserCatDialog.value.setFormData()
    editUserCatDialog.value.showDialog = true
}

/**
 * 编辑用户分类
 * @param data
 */
const editEvent = (data: any) => {
    editUserCatDialog.value.setFormData(data)
    editUserCatDialog.value.showDialog = true
}

/**
 * 删除用户分类
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('userCatDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteUserCat(id).then(() => {
            loadUserCatList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadUserCatList()
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
