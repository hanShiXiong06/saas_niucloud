<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{ pageName }}</span>
                <!-- <el-button type="primary" @click="addEvent">
                    {{ t('addVoice') }}
                </el-button> -->
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="voiceTable.searchParam" ref="searchFormRef">

                    <el-form-item label="会员" prop="member_id">
                        <el-select class="input-width" v-model="voiceTable.searchParam.member_id" clearable
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
                        <el-input v-model="voiceTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="voiceTable.searchParam.create_time" type="datetimerange"
                            format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadVoiceList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="voiceTable.data" size="large" v-loading="voiceTable.loading">
                    <template #empty>
                        <span>{{ !voiceTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true" />


                    <el-table-column prop="voice_url" label="音频" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-button v-if="row.voice_url != ''" type="plain"
                                @click="playVoice(img(row.voice_url))">播放</el-button>
                        </template>
                    </el-table-column>

                    <!-- <el-table-column prop="duration" :label="t('duration')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <!-- <el-table-column prop="content" :label="t('content')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <!-- <el-table-column prop="platform" :label="t('platform')" min-width="120"
                        :show-overflow-tooltip="true" /> -->

                    <!-- <el-table-column prop="task_id" :label="t('taskId')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <el-table-column prop="voice_id" :label="t('voiceId')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="status_name" :label="t('status')" min-width="120"
                        :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.status == '3'" type="error">合成失败</el-tag>
                            <el-tag v-else type="success">{{ row.status_name }}</el-tag>
                        </template>
                    </el-table-column>

                    <!--                     
                    <el-table-column prop="is_audit" :label="t('isAudit')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="is_open" :label="t('isOpen')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="point" :label="t('point')" min-width="120" :show-overflow-tooltip="true"/>
                     -->
                    <el-table-column prop="create_time" label="创建时间" min-width="120"
                        :show-overflow-tooltip="true" />
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <!-- <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button> -->
                            <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="voiceTable.page" v-model:page-size="voiceTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="voiceTable.total"
                        @size-change="loadVoiceList()" @current-change="loadVoiceList" />
                </div>
            </div>

            <edit ref="editVoiceDialog" @complete="loadVoiceList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getVoiceList, deleteVoice, getWithMemberList } from '@/addon/ai_humans/api/voice'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance } from 'element-plus'
import Edit from '@/addon/ai_humans/views/voice/components/voice-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;
// 当前正在播放的音频对象
let currentAudio: HTMLAudioElement | null = null;
// 当前播放音频的 URL
let currentAudioUrl: string | null = null;

const playVoice = (url: string) => {
    if (currentAudioUrl === url && currentAudio) {
        // 如果点击的是同一个音频，且音频正在播放，则暂停
        if (!currentAudio.paused) {
            currentAudio.pause();
        } else {
            // 如果音频已暂停，则继续播放
            currentAudio.play().catch((error) => {
                console.error('播放音频时出错:', error);
            });
        }
    } else {
        // 如果点击的是新的音频，暂停当前音频并播放新音频
        if (currentAudio) {
            currentAudio.pause();
            currentAudio.currentTime = 0;
        }
        if (url) {
            const audio = new Audio(url);
            audio.play().catch((error) => {
                console.error('播放音频时出错:', error);
            });
            // 更新当前正在播放的音频对象和 URL
            currentAudio = audio;
            currentAudioUrl = url;
        }
    }
};
let voiceTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "member_id": "",
        "name": "",
        "create_time": []
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据


/**
 * 获取声音合成列列表
 */
const loadVoiceList = (page: number = 1) => {
    voiceTable.loading = true
    voiceTable.page = page

    getVoiceList({
        page: voiceTable.page,
        limit: voiceTable.limit,
        ...voiceTable.searchParam
    }).then(res => {
        voiceTable.loading = false
        voiceTable.data = res.data.data
        voiceTable.total = res.data.total
    }).catch(() => {
        voiceTable.loading = false
    })
}
loadVoiceList()

const editVoiceDialog: Record<string, any> | null = ref(null)

/**
 * 添加声音合成列
 */
const addEvent = () => {
    editVoiceDialog.value.setFormData()
    editVoiceDialog.value.showDialog = true
}

/**
 * 编辑声音合成列
 * @param data
 */
const editEvent = (data: any) => {
    editVoiceDialog.value.setFormData(data)
    editVoiceDialog.value.showDialog = true
}

/**
 * 删除声音合成列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('voiceDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteVoice(id).then(() => {
            loadVoiceList()
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
    loadVoiceList()
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
