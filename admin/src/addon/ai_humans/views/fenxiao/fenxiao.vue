<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <!-- <el-button type="primary" @click="addEvent">
                    {{ t('addFenxiao') }}
                </el-button> -->
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="fenxiaoTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('status')" prop="status">
             
                        <el-select class="w-[280px]" v-model="fenxiaoTable.searchParam.status" clearable
                            placeholder="请选择状态">
                            <el-option label="全部" value="" />
                            <block v-for="(item,index) in fenxiaoStatus" :key="index">
                                <el-option :label="item" :value="index" />
                            </block>
        
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="fenxiaoTable.searchParam.create_time" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadFenxiaoList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="fenxiaoTable.data" size="large" v-loading="fenxiaoTable.loading">
                    <template #empty>
                        <span>{{ !fenxiaoTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="status_name" :label="t('status')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <!-- <el-table-column prop="value" :label="t('value')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="bind_time" :label="t('bindTime')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.member_id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="fenxiaoTable.page" v-model:page-size="fenxiaoTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="fenxiaoTable.total"
                        @size-change="loadFenxiaoList()" @current-change="loadFenxiaoList" />
                </div>
            </div>

            <edit ref="editFenxiaoDialog" @complete="loadFenxiaoList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getFenxiaoList, deleteFenxiao, getWithMemberList,getFenxiaoStatus } from '@/addon/ai_humans/api/fenxiao'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/ai_humans/views/fenxiao/components/fenxiao-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;
const fenxiaoStatus=ref()
getFenxiaoStatus().then(res=>{
  fenxiaoStatus.value=res.data
})
let fenxiaoTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "status":"",
      "create_time":[]
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取分销会员列表
 */
const loadFenxiaoList = (page: number = 1) => {
    fenxiaoTable.loading = true
    fenxiaoTable.page = page

    getFenxiaoList({
        page: fenxiaoTable.page,
        limit: fenxiaoTable.limit,
         ...fenxiaoTable.searchParam
    }).then(res => {
        fenxiaoTable.loading = false
        fenxiaoTable.data = res.data.data
        fenxiaoTable.total = res.data.total
    }).catch(() => {
        fenxiaoTable.loading = false
    })
}
loadFenxiaoList()

const editFenxiaoDialog: Record<string, any> | null = ref(null)

/**
 * 添加分销会员
 */
const addEvent = () => {
    editFenxiaoDialog.value.setFormData()
    editFenxiaoDialog.value.showDialog = true
}

/**
 * 编辑分销会员
 * @param data
 */
const editEvent = (data: any) => {
    editFenxiaoDialog.value.setFormData(data)
    editFenxiaoDialog.value.showDialog = true
}

/**
 * 删除分销会员
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('fenxiaoDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteFenxiao(id).then(() => {
            loadFenxiaoList()
        }).catch(() => {
        })
    })
}

    
    const memberIdList = ref([])
    const setMemberIdList = async () => {
    memberIdList.value = await (await getWithMemberList({})).data
    }
    setMemberIdList()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadFenxiaoList()
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
