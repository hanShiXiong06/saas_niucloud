<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{ pageName }}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addVideoClone') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="videoCloneTable.searchParam" ref="searchFormRef">

                    <el-form-item label="会员" prop="member_id">
                        <el-select class="input-width" v-model="videoCloneTable.searchParam.member_id" clearable
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

                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="videoCloneTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('status')" prop="status">
                        <el-input v-model="videoCloneTable.searchParam.status" :placeholder="t('statusPlaceholder')" />
                    </el-form-item>
                    <!-- <el-form-item :label="t('isOpen')" prop="is_open">
                        <el-input v-model="videoCloneTable.searchParam.is_open" :placeholder="t('isOpenPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('isAudit')" prop="is_audit">
                        <el-input v-model="videoCloneTable.searchParam.is_audit" :placeholder="t('isAuditPlaceholder')" />
                    </el-form-item> -->
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="videoCloneTable.searchParam.create_time" type="datetimerange"
                            format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadVideoCloneList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="videoCloneTable.data" size="large" v-loading="videoCloneTable.loading">
                    <template #empty>
                        <span>{{ !videoCloneTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true" />
                    <!--                     
                    <el-table-column prop="desc" :label="t('desc')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="tag" :label="t('tag')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <el-table-column prop="task_id" :label="t('taskId')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="video_url" label="视频" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-button @click="openVideoInNewWindow(row.video_url)">播放</el-button>
                        </template>
                    </el-table-column>

                    <!-- <el-table-column prop="callback_url" :label="t('callbackUrl')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <el-table-column prop="status_name" :label="t('status')" min-width="120"
                        :show-overflow-tooltip="true" >
                        <template #default="{ row }">
                            <el-tag v-if="row.status == '3'" type="error">克隆失败</el-tag>
                            <el-tag v-else type="success">{{ row.status_name }}</el-tag>
                        </template>
                    </el-table-column>


                    <el-table-column prop="platform" :label="t('platform')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <!-- <el-table-column prop="is_open" :label="t('isOpen')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="point" :label="t('point')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <el-table-column prop="msg" :label="t('msg')" min-width="120" :show-overflow-tooltip="true" />

                    <!-- <el-table-column prop="is_audit" :label="t('isAudit')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <el-table-column prop="create_time" label="创建时间" min-width="120"
                        :show-overflow-tooltip="true" />
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                            <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="videoCloneTable.page" v-model:page-size="videoCloneTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="videoCloneTable.total"
                        @size-change="loadVideoCloneList()" @current-change="loadVideoCloneList" />
                </div>
            </div>

            <edit ref="editVideoCloneDialog" @complete="loadVideoCloneList" />
        </el-card>
    </div>
    
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getVideoCloneList, deleteVideoClone, getWithMemberList } from '@/addon/ai_humans/api/videoclone'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance } from 'element-plus'
import Edit from '@/addon/ai_humans/views/videoclone/components/videoclone-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;
const openVideoInNewWindow = (url: string) => {
    const newWindow = window.open('', '_blank');
    if (newWindow) {
        newWindow.document.write(`
            <html>
                <head>
                    <title>视频播放</title>
                </head>
                <body>
                    <video width="640" height="360" controls>
                        <source src="${url}" type="video/mp4">
                        您的浏览器不支持视频播放。
                    </video>
                </body>
            </html>
        `);
        newWindow.document.close();
    }
};
let videoCloneTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "member_id": "",
        "name": "",
        "status": "",
        "is_open": "",
        "is_audit": "",
        "create_time": []
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据


/**
 * 获取视频克隆列列表
 */
const loadVideoCloneList = (page: number = 1) => {
    videoCloneTable.loading = true
    videoCloneTable.page = page

    getVideoCloneList({
        page: videoCloneTable.page,
        limit: videoCloneTable.limit,
        ...videoCloneTable.searchParam
    }).then(res => {
        videoCloneTable.loading = false
        videoCloneTable.data = res.data.data
        videoCloneTable.total = res.data.total
    }).catch(() => {
        videoCloneTable.loading = false
    })
}
loadVideoCloneList()

const editVideoCloneDialog: Record<string, any> | null = ref(null)

/**
 * 添加视频克隆列
 */
const addEvent = () => {
    editVideoCloneDialog.value.setFormData()
    editVideoCloneDialog.value.showDialog = true
}

/**
 * 编辑视频克隆列
 * @param data
 */
const editEvent = (data: any) => {
    editVideoCloneDialog.value.setFormData(data)
    editVideoCloneDialog.value.showDialog = true
}

/**
 * 删除视频克隆列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('videoCloneDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteVideoClone(id).then(() => {
            loadVideoCloneList()
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
    loadVideoCloneList()
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
