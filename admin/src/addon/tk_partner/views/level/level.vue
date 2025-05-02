<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addLevel') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="levelTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="levelTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadLevelList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="levelTable.data" size="large" v-loading="levelTable.loading">
                    <template #empty>
                        <span>{{ !levelTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                     <el-table-column :label="t('icon')" width="100" align="left">
                        <template #default="{ row }">
                            <el-avatar v-if="row.icon" :src="img(row.icon)" />
                            <el-avatar v-else icon="UserFilled" />
                        </template>
                    </el-table-column>
                    <el-table-column prop="rate" :label="t('rate')" min-width="120" :show-overflow-tooltip="true"/>
                     
                    <el-table-column prop="price" :label="t('price')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="levelTable.page" v-model:page-size="levelTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="levelTable.total"
                        @size-change="loadLevelList()" @current-change="loadLevelList" />
                </div>
            </div>

            <edit ref="editLevelDialog" @complete="loadLevelList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getLevelList, deleteLevel } from '@/addon/tk_partner/api/level'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/tk_partner/views/level/components/level-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let levelTable = reactive({
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
 * 获取店主级别列列表
 */
const loadLevelList = (page: number = 1) => {
    levelTable.loading = true
    levelTable.page = page

    getLevelList({
        page: levelTable.page,
        limit: levelTable.limit,
         ...levelTable.searchParam
    }).then(res => {
        levelTable.loading = false
        levelTable.data = res.data.data
        levelTable.total = res.data.total
    }).catch(() => {
        levelTable.loading = false
    })
}
loadLevelList()

const editLevelDialog: Record<string, any> | null = ref(null)

/**
 * 添加店主级别列
 */
const addEvent = () => {
    editLevelDialog.value.setFormData()
    editLevelDialog.value.showDialog = true
}

/**
 * 编辑店主级别列
 * @param data
 */
const editEvent = (data: any) => {
    editLevelDialog.value.setFormData(data)
    editLevelDialog.value.showDialog = true
}

/**
 * 删除店主级别列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('levelDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteLevel(id).then(() => {
            loadLevelList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadLevelList()
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
