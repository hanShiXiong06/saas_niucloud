<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <!-- <el-button type="primary" @click="addEvent">
                    {{ t('addPartnerMember') }}
                </el-button> -->
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="partnerMemberTable.searchParam" ref="searchFormRef">
                    
                    <!-- <el-form-item :label="t('memberId')" prop="member_id">
                        <el-select class="w-[280px]" v-model="partnerMemberTable.searchParam.member_id" clearable :placeholder="t('memberIdPlaceholder')">
                           <el-option
                                       v-for="(item, index) in memberIdList"
                                       :key="index"
                                       :label="item['nickname']"
                                       :value="item['member_id']"
                                   />
                        </el-select>
                    </el-form-item> -->
                    
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="partnerMemberTable.searchParam.create_time" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadPartnerMemberList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="partnerMemberTable.data" size="large" v-loading="partnerMemberTable.loading">
                    <template #empty>
                        <span>{{ !partnerMemberTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <!-- <el-table-column prop="pid" :label="t('pid')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="is_partner" :label="t('isPartner')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="expire_time" :label="t('expireTime')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="delete_time" :label="t('deleteTime')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <!-- <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button> -->
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="partnerMemberTable.page" v-model:page-size="partnerMemberTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="partnerMemberTable.total"
                        @size-change="loadPartnerMemberList()" @current-change="loadPartnerMemberList" />
                </div>
            </div>

            <edit ref="editPartnerMemberDialog" @complete="loadPartnerMemberList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getPartnerMemberList, deletePartnerMember, getWithMemberList } from '@/addon/tk_partner/api/partnermember'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/tk_partner/views/partnermember/components/partnermember-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let partnerMemberTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "member_id":"",
      "create_time":[]
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取会员列列表
 */
const loadPartnerMemberList = (page: number = 1) => {
    partnerMemberTable.loading = true
    partnerMemberTable.page = page

    getPartnerMemberList({
        page: partnerMemberTable.page,
        limit: partnerMemberTable.limit,
         ...partnerMemberTable.searchParam
    }).then(res => {
        partnerMemberTable.loading = false
        partnerMemberTable.data = res.data.data
        partnerMemberTable.total = res.data.total
    }).catch(() => {
        partnerMemberTable.loading = false
    })
}
loadPartnerMemberList()

const editPartnerMemberDialog: Record<string, any> | null = ref(null)

/**
 * 添加会员列
 */
const addEvent = () => {
    editPartnerMemberDialog.value.setFormData()
    editPartnerMemberDialog.value.showDialog = true
}

/**
 * 编辑会员列
 * @param data
 */
const editEvent = (data: any) => {
    editPartnerMemberDialog.value.setFormData(data)
    editPartnerMemberDialog.value.showDialog = true
}

/**
 * 删除会员列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('partnerMemberDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deletePartnerMember(id).then(() => {
            loadPartnerMemberList()
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
    loadPartnerMemberList()
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
