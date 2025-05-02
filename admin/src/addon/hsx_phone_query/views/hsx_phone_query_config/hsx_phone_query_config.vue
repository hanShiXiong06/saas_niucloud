<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addHsxPhoneQueryConfig') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="hsxPhoneQueryConfigTable.searchParam" ref="searchFormRef">
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadHsxPhoneQueryConfigList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="hsxPhoneQueryConfigTable.data" size="large" v-loading="hsxPhoneQueryConfigTable.loading">
                    <template #empty>
                        <span>{{ !hsxPhoneQueryConfigTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="appid" :label="t('appid')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="Secret" :label="t('secret')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="hsxPhoneQueryConfigTable.page" v-model:page-size="hsxPhoneQueryConfigTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="hsxPhoneQueryConfigTable.total"
                        @size-change="loadHsxPhoneQueryConfigList()" @current-change="loadHsxPhoneQueryConfigList" />
                </div>
            </div>

            <edit ref="editHsxPhoneQueryConfigDialog" @complete="loadHsxPhoneQueryConfigList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getHsxPhoneQueryConfigList, deleteHsxPhoneQueryConfig } from '@/addon/hsx_phone_query/api/hsx_phone_query_config'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/hsx_phone_query/views/hsx_phone_query_config/components/hsx-phone-query-config-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let hsxPhoneQueryConfigTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取配置信息列表
 */
const loadHsxPhoneQueryConfigList = (page: number = 1) => {
    hsxPhoneQueryConfigTable.loading = true
    hsxPhoneQueryConfigTable.page = page

    getHsxPhoneQueryConfigList({
        page: hsxPhoneQueryConfigTable.page,
        limit: hsxPhoneQueryConfigTable.limit,
         ...hsxPhoneQueryConfigTable.searchParam
    }).then(res => {
        hsxPhoneQueryConfigTable.loading = false
        hsxPhoneQueryConfigTable.data = res.data.data
        hsxPhoneQueryConfigTable.total = res.data.total
    }).catch(() => {
        hsxPhoneQueryConfigTable.loading = false
    })
}
loadHsxPhoneQueryConfigList()

const editHsxPhoneQueryConfigDialog: Record<string, any> | null = ref(null)

/**
 * 添加配置信息
 */
const addEvent = () => {
    editHsxPhoneQueryConfigDialog.value.setFormData()
    editHsxPhoneQueryConfigDialog.value.showDialog = true
}

/**
 * 编辑配置信息
 * @param data
 */
const editEvent = (data: any) => {
    editHsxPhoneQueryConfigDialog.value.setFormData(data)
    editHsxPhoneQueryConfigDialog.value.showDialog = true
}

/**
 * 删除配置信息
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('hsxPhoneQueryConfigDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteHsxPhoneQueryConfig(id).then(() => {
            loadHsxPhoneQueryConfigList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadHsxPhoneQueryConfigList()
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
