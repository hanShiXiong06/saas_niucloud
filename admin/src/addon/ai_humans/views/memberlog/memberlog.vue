<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>

            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="memberLogTable.searchParam" ref="searchFormRef">
                    
                    <el-form-item label="会员" prop="member_id">
                        <el-select class="input-width" v-model="memberLogTable.searchParam.member_id" clearable
                            :placeholder="t('memberIdPlaceholder')">
                            <div class="mt-2 mb-2 ml-4">
                                <el-input @change="change" v-model="keyword" style="width: 200px"
                                    placeholder="搜索会员支持昵称/会员名">
                                    <template #append>搜索 </template></el-input>
                            </div>
                            <el-option label="请选择" value=""></el-option>
                            <el-option v-for="(item, index) in memberIdList" :key="index" :label="item['nickname']"
                                :value="item['member_id']" />
                        </el-select>
                    </el-form-item>

                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="memberLogTable.searchParam.create_time" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadMemberLogList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="memberLogTable.data" size="large" v-loading="memberLogTable.loading">
                    <template #empty>
                        <span>{{ !memberLogTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                      
                    <el-table-column prop="num" :label="t('num')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="desc" :label="t('desc')" min-width="120" :show-overflow-tooltip="true"/>
                    <el-table-column prop="create_time" label="创建时间" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                        
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="memberLogTable.page" v-model:page-size="memberLogTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="memberLogTable.total"
                        @size-change="loadMemberLogList()" @current-change="loadMemberLogList" />
                </div>
            </div>

            <edit ref="editMemberLogDialog" @complete="loadMemberLogList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getMemberLogList, deleteMemberLog, getWithMemberList } from '@/addon/ai_humans/api/memberlog'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/ai_humans/views/memberlog/components/memberlog-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let memberLogTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "member_id":"",
      "chang_type":"",
      "create_time":[]
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取会员日志列表
 */
const loadMemberLogList = (page: number = 1) => {
    memberLogTable.loading = true
    memberLogTable.page = page

    getMemberLogList({
        page: memberLogTable.page,
        limit: memberLogTable.limit,
         ...memberLogTable.searchParam
    }).then(res => {
        memberLogTable.loading = false
        memberLogTable.data = res.data.data
        memberLogTable.total = res.data.total
    }).catch(() => {
        memberLogTable.loading = false
    })
}
loadMemberLogList()

const editMemberLogDialog: Record<string, any> | null = ref(null)

/**
 * 添加会员日志
 */
const addEvent = () => {
    editMemberLogDialog.value.setFormData()
    editMemberLogDialog.value.showDialog = true
}

/**
 * 编辑会员日志
 * @param data
 */
const editEvent = (data: any) => {
    editMemberLogDialog.value.setFormData(data)
    editMemberLogDialog.value.showDialog = true
}

/**
 * 删除会员日志
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('memberLogDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteMemberLog(id).then(() => {
            loadMemberLogList()
        }).catch(() => {
        })
    })
}

    
const change = () => {
    setMemberIdList();
};
const keyword = ref();
const memberIdList = ref([]);
const setMemberIdList = async () => {
    memberIdList.value = await (
        await getWithMemberList({ keyword: keyword.value })
    ).data.data;
};
setMemberIdList();

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadMemberLogList()
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
