<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addShequn') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="shequnTable.searchParam" ref="searchFormRef">
                    
                    <el-form-item :label="t('cateId')" prop="cate_id">
                        <el-select class="w-[280px]" v-model="shequnTable.searchParam.cate_id" clearable :placeholder="t('cateIdPlaceholder')">
                           <el-option
                                       v-for="(item, index) in cateIdList"
                                       :key="index"
                                       :label="item['name']"
                                       :value="item['id']"
                                   />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="shequnTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('adddate')" prop="adddate">
                        <el-date-picker v-model="shequnTable.searchParam.adddate" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadShequnList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="shequnTable.data" size="large" v-loading="shequnTable.loading">
                    <template #empty>
                        <span>{{ !shequnTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="id" :label="t('id')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="cate_id_name" :label="t('cateId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <!-- <el-table-column prop="image" :label="t('image')" min-width="120" :show-overflow-tooltip="true"/> -->
                    
                    <el-table-column prop="adddate" :label="t('adddate')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="shequnTable.page" v-model:page-size="shequnTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="shequnTable.total"
                        @size-change="loadShequnList()" @current-change="loadShequnList" />
                </div>
            </div>

            <edit ref="editShequnDialog" @complete="loadShequnList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getShequnList, deleteShequn, getWithShequncateList } from '@/addon/blog/api/shequn'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/blog/views/shequn/components/shequn-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let shequnTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "cate_id":"",
      "name":"",
      "adddate":[]
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取微信社群列表
 */
const loadShequnList = (page: number = 1) => {
    shequnTable.loading = true
    shequnTable.page = page

    getShequnList({
        page: shequnTable.page,
        limit: shequnTable.limit,
         ...shequnTable.searchParam
    }).then(res => {
        shequnTable.loading = false
        shequnTable.data = res.data.data
        shequnTable.total = res.data.total
    }).catch(() => {
        shequnTable.loading = false
    })
}
loadShequnList()

const editShequnDialog: Record<string, any> | null = ref(null)

/**
 * 添加微信社群
 */
const addEvent = () => {
    editShequnDialog.value.setFormData()
    editShequnDialog.value.showDialog = true
}

/**
 * 编辑微信社群
 * @param data
 */
const editEvent = (data: any) => {
    editShequnDialog.value.setFormData(data)
    editShequnDialog.value.showDialog = true
}

/**
 * 删除微信社群
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('shequnDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteShequn(id).then(() => {
            loadShequnList()
        }).catch(() => {
        })
    })
}

    
    const cateIdList = ref([])
    const setCateIdList = async () => {
    cateIdList.value = await (await getWithShequncateList({})).data
    }
    setCateIdList()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadShequnList()
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
