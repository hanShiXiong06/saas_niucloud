<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>

            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="partnerTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('type')" prop="type">
                        <el-input v-model="partnerTable.searchParam.type" :placeholder="t('typePlaceholder')" />
                    </el-form-item>
                    
                    <el-form-item :label="t('memberId')" prop="member_id">
                        <el-select class="w-[280px]" v-model="partnerTable.searchParam.member_id" clearable :placeholder="t('memberIdPlaceholder')">
                           <el-option
                                       v-for="(item, index) in memberIdList"
                                       :key="index"
                                       :label="item['nickname']"
                                       :value="item['member_id']"
                                   />
                        </el-select>
                    </el-form-item>
                    
                    
                    <el-form-item :label="t('levelId')" prop="level_id">
                        <el-select class="w-[280px]" v-model="partnerTable.searchParam.level_id" clearable :placeholder="t('levelIdPlaceholder')">
                           <el-option
                                       v-for="(item, index) in levelIdList"
                                       :key="index"
                                       :label="item['name']"
                                       :value="item['id']"
                                   />
                        </el-select>
                    </el-form-item>
                    
                    <el-form-item :label="t('mobile')" prop="mobile">
                        <el-input v-model="partnerTable.searchParam.mobile" :placeholder="t('mobilePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('status')" prop="status">
                        <el-input v-model="partnerTable.searchParam.status" :placeholder="t('statusPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('shareCode')" prop="share_code">
                        <el-input v-model="partnerTable.searchParam.share_code" :placeholder="t('shareCodePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('expireTime')" prop="expire_time">
                        <el-date-picker v-model="partnerTable.searchParam.expire_time" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadPartnerList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="partnerTable.data" size="large" v-loading="partnerTable.loading">
                    <template #empty>
                        <span>{{ !partnerTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                      <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="level_id_name" :label="t('levelId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                     <el-table-column :label="t('logo')" width="100" align="left">
                        <template #default="{ row }">
                            <el-avatar v-if="row.logo" :src="img(row.logo)" />
                            <el-avatar v-else icon="UserFilled" />
                        </template>
                    </el-table-column>
                    
                    <!-- <el-table-column prop="pid" :label="t('pid')" min-width="120" :show-overflow-tooltip="true"/>
                      -->
                    <el-table-column prop="status_name" :label="t('status')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="share_code" :label="t('shareCode')" min-width="120" :show-overflow-tooltip="true"/>
                      
                     
                    <!-- <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column> -->

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="partnerTable.page" v-model:page-size="partnerTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="partnerTable.total"
                        @size-change="loadPartnerList()" @current-change="loadPartnerList" />
                </div>
            </div>

            <edit ref="editPartnerDialog" @complete="loadPartnerList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getPartnerList, deletePartner, getWithMemberList, getWithLevelList } from '@/addon/tk_partner/api/partner'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/tk_partner/views/partner/components/partner-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let partnerTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "type":"",
      "member_id":"",
      "level_id":"",
      "mobile":"",
      "status":"",
      "share_code":"",
      "expire_time":[]
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取店主列列表
 */
const loadPartnerList = (page: number = 1) => {
    partnerTable.loading = true
    partnerTable.page = page

    getPartnerList({
        page: partnerTable.page,
        limit: partnerTable.limit,
         ...partnerTable.searchParam
    }).then(res => {
        partnerTable.loading = false
        partnerTable.data = res.data.data
        partnerTable.total = res.data.total
    }).catch(() => {
        partnerTable.loading = false
    })
}
loadPartnerList()

const editPartnerDialog: Record<string, any> | null = ref(null)

/**
 * 添加店主列
 */
const addEvent = () => {
    editPartnerDialog.value.setFormData()
    editPartnerDialog.value.showDialog = true
}

/**
 * 编辑店主列
 * @param data
 */
const editEvent = (data: any) => {
    editPartnerDialog.value.setFormData(data)
    editPartnerDialog.value.showDialog = true
}

/**
 * 删除店主列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('partnerDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deletePartner(id).then(() => {
            loadPartnerList()
        }).catch(() => {
        })
    })
}

    
    const memberIdList = ref([])
    const setMemberIdList = async () => {
    memberIdList.value = await (await getWithMemberList({})).data
    }
    setMemberIdList()
    const levelIdList = ref([])
    const setLevelIdList = async () => {
    levelIdList.value = await (await getWithLevelList({})).data
    }
    setLevelIdList()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadPartnerList()
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
