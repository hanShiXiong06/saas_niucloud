<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>

            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="msgTable.searchParam" ref="searchFormRef">
                    
                    <el-form-item label="会员" prop="member_id">
                        <el-select class="input-width" v-model="msgTable.searchParam.member_id" clearable
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
                        <el-date-picker v-model="msgTable.searchParam.create_time" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadMsgList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="msgTable.data" size="large" v-loading="msgTable.loading">
                    <template #empty>
                        <span>{{ !msgTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                      <el-table-column prop="msg_id" :label="t('msgId')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="role" :label="t('role')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="content" :label="t('content')" min-width="120" :show-overflow-tooltip="true"/>
                    
                   
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                              <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="msgTable.page" v-model:page-size="msgTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="msgTable.total"
                        @size-change="loadMsgList()" @current-change="loadMsgList" />
                </div>
            </div>

            <edit ref="editMsgDialog" @complete="loadMsgList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getMsgList, deleteMsg, getWithMemberList } from '@/addon/ai_humans/api/msg'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/ai_humans/views/msg/components/msg-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let msgTable = reactive({
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
 * 获取对话记录列表
 */
const loadMsgList = (page: number = 1) => {
    msgTable.loading = true
    msgTable.page = page

    getMsgList({
        page: msgTable.page,
        limit: msgTable.limit,
         ...msgTable.searchParam
    }).then(res => {
        msgTable.loading = false
        msgTable.data = res.data.data
        msgTable.total = res.data.total
    }).catch(() => {
        msgTable.loading = false
    })
}
loadMsgList()

const editMsgDialog: Record<string, any> | null = ref(null)

/**
 * 添加对话记录
 */
const addEvent = () => {
    editMsgDialog.value.setFormData()
    editMsgDialog.value.showDialog = true
}

/**
 * 编辑对话记录
 * @param data
 */
const editEvent = (data: any) => {
    editMsgDialog.value.setFormData(data)
    editMsgDialog.value.showDialog = true
}

/**
 * 删除对话记录
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('msgDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteMsg(id).then(() => {
            loadMsgList()
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
    loadMsgList()
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
