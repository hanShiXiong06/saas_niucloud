<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{ pageName }}</span>

            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="aihumansMemberTable.searchParam" ref="searchFormRef">


                    <el-form-item label="会员" prop="member_id">
                        <el-select class="input-width" v-model="aihumansMemberTable.searchParam.member_id" clearable
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
                    <el-form-item>
                        <el-button type="primary" @click="loadAihumansMemberList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="aihumansMemberTable.data" size="large" v-loading="aihumansMemberTable.loading">
                    <template #empty>
                        <span>{{ !aihumansMemberTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="point" :label="t('point')" min-width="120" :show-overflow-tooltip="true" />


                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                            <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="aihumansMemberTable.page"
                        v-model:page-size="aihumansMemberTable.limit" layout="total, sizes, prev, pager, next, jumper"
                        :total="aihumansMemberTable.total" @size-change="loadAihumansMemberList()"
                        @current-change="loadAihumansMemberList" />
                </div>
            </div>

            <edit ref="editAihumansMemberDialog" @complete="loadAihumansMemberList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getAihumansMemberList, deleteAihumansMember, getWithMemberList } from '@/addon/ai_humans/api/aihumansmember'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance } from 'element-plus'
import Edit from '@/addon/ai_humans/views/aihumansmember/components/aihumansmember-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let aihumansMemberTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "member_id": ""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据


/**
 * 获取会员列列表
 */
const loadAihumansMemberList = (page: number = 1) => {
    aihumansMemberTable.loading = true
    aihumansMemberTable.page = page

    getAihumansMemberList({
        page: aihumansMemberTable.page,
        limit: aihumansMemberTable.limit,
        ...aihumansMemberTable.searchParam
    }).then(res => {
        aihumansMemberTable.loading = false
        aihumansMemberTable.data = res.data.data
        aihumansMemberTable.total = res.data.total
    }).catch(() => {
        aihumansMemberTable.loading = false
    })
}
loadAihumansMemberList()

const editAihumansMemberDialog: Record<string, any> | null = ref(null)

/**
 * 添加会员列
 */
const addEvent = () => {
    editAihumansMemberDialog.value.setFormData()
    editAihumansMemberDialog.value.showDialog = true
}

/**
 * 编辑会员列
 * @param data
 */
const editEvent = (data: any) => {
    editAihumansMemberDialog.value.setFormData(data)
    editAihumansMemberDialog.value.showDialog = true
}

/**
 * 删除会员列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('aihumansMemberDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteAihumansMember(id).then(() => {
            loadAihumansMemberList()
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
    loadAihumansMemberList()
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
