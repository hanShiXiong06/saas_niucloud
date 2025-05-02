<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addFenxiaoMember') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="fenxiaoMemberTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('isFenxiao')" prop="is_fenxiao">
                        <el-input v-model="fenxiaoMemberTable.searchParam.is_fenxiao" :placeholder="t('isFenxiaoPlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadFenxiaoMemberList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="fenxiaoMemberTable.data" size="large" v-loading="fenxiaoMemberTable.loading">
                    <template #empty>
                        <span>{{ !fenxiaoMemberTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="pid" :label="t('pid')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="fenxiao_member_id" :label="t('fenxiaoMemberId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="is_fenxiao" :label="t('isFenxiao')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="status" :label="t('status')" min-width="120" :show-overflow-tooltip="true"/>
                    
                     <el-table-column :label="t('bindTime')" min-width="180" align="center" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            {{ row.bind_time || '' }}
                        </template>
                    </el-table-column>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.member_id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="fenxiaoMemberTable.page" v-model:page-size="fenxiaoMemberTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="fenxiaoMemberTable.total"
                        @size-change="loadFenxiaoMemberList()" @current-change="loadFenxiaoMemberList" />
                </div>
            </div>

            <edit ref="editFenxiaoMemberDialog" @complete="loadFenxiaoMemberList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getFenxiaoMemberList, deleteFenxiaoMember, getWithMemberList } from '@/addon/ai_humans/api/fenxiaomember'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/ai_humans/views/fenxiaomember/components/fenxiaomember-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let fenxiaoMemberTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "is_fenxiao":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取分销会员列列表
 */
const loadFenxiaoMemberList = (page: number = 1) => {
    fenxiaoMemberTable.loading = true
    fenxiaoMemberTable.page = page

    getFenxiaoMemberList({
        page: fenxiaoMemberTable.page,
        limit: fenxiaoMemberTable.limit,
         ...fenxiaoMemberTable.searchParam
    }).then(res => {
        fenxiaoMemberTable.loading = false
        fenxiaoMemberTable.data = res.data.data
        fenxiaoMemberTable.total = res.data.total
    }).catch(() => {
        fenxiaoMemberTable.loading = false
    })
}
loadFenxiaoMemberList()

const editFenxiaoMemberDialog: Record<string, any> | null = ref(null)

/**
 * 添加分销会员列
 */
const addEvent = () => {
    editFenxiaoMemberDialog.value.setFormData()
    editFenxiaoMemberDialog.value.showDialog = true
}

/**
 * 编辑分销会员列
 * @param data
 */
const editEvent = (data: any) => {
    editFenxiaoMemberDialog.value.setFormData(data)
    editFenxiaoMemberDialog.value.showDialog = true
}

/**
 * 删除分销会员列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('fenxiaoMemberDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteFenxiaoMember(id).then(() => {
            loadFenxiaoMemberList()
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
    loadFenxiaoMemberList()
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
