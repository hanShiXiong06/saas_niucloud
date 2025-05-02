<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">
<!-- 
            <div class="flex justify-between items-center">
                <span class="text-lg">{{ pageName }}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addVideo') }}
                </el-button>
            </div> -->

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <div style="width: 640px" class="mb-4">
                    <el-alert type="info" title="温馨提示：默认已对生成视频本地处理，合成云视频地址非永久地址" :closable="false" show-icon />
                </div>
                <el-form :inline="true" :model="videoTable.searchParam" ref="searchFormRef">

                    <el-form-item label="会员" prop="member_id">
                        <el-select class="input-width" v-model="videoTable.searchParam.member_id" clearable
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
                        <el-input v-model="videoTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('status')" prop="status">
                        <el-input v-model="videoTable.searchParam.status" :placeholder="t('statusPlaceholder')" />
                    </el-form-item>
                    <!-- <el-form-item :label="t('platform')" prop="platform">
                        <el-input v-model="videoTable.searchParam.platform" :placeholder="t('platformPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('isAudit')" prop="is_audit">
                        <el-input v-model="videoTable.searchParam.is_audit" :placeholder="t('isAuditPlaceholder')" />
                    </el-form-item> -->
                    <el-form-item>
                        <el-button type="primary" @click="loadVideoList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="videoTable.data" size="large" v-loading="videoTable.loading">
                    <template #empty>
                        <span>{{ !videoTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true" />

                    <!-- <el-table-column prop="desc" :label="t('desc')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="tag" :label="t('tag')" min-width="120" :show-overflow-tooltip="true" /> -->



                    <el-table-column prop="video_url" label="视频" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-button v-if="row.video_url != ''"
                                @click="openVideoInNewWindow(row.video_url)">播放</el-button>
                        </template>
                    </el-table-column>

                    <el-table-column prop="voice_url" label="音频" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-button v-if="row.voice_url != ''" type="plain"
                                @click="playVoice(img(row.voice_url))">播放</el-button>
                        </template>
                    </el-table-column>


                    <!-- <el-table-column prop="voice_id" :label="t('voiceId')" min-width="120"
                        :show-overflow-tooltip="true" /> -->

                    <el-table-column prop="cloud_video_url" :label="t('cloudVideoUrl')" min-width="120"
                        :show-overflow-tooltip="true" />
                    <!-- 
                    <el-table-column prop="callback_url" :label="t('callbackUrl')" min-width="120"
                        :show-overflow-tooltip="true" /> -->

                    <el-table-column prop="status_name" :label="t('status')" min-width="120"
                        :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.status == '3'" type="error">合成失败</el-tag>
                            <el-tag v-else type="success">{{ row.status_name }}</el-tag>
                        </template>
                    </el-table-column>

                    <!-- <el-table-column prop="platform" :label="t('platform')" min-width="120"
                        :show-overflow-tooltip="true" /> -->

                    <el-table-column prop="type" :label="t('type')" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.type == 'text'" type="primary">文本驱动</el-tag>
                            <el-tag v-if="row.type == 'audio'" type="warning">音频驱动</el-tag>
                        </template>
                    </el-table-column>

                    <!-- <el-table-column prop="is_open" :label="t('isOpen')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="point" :label="t('point')" min-width="120" :show-overflow-tooltip="true" /> -->

                    <el-table-column prop="msg" :label="t('msg')" min-width="120" :show-overflow-tooltip="true" />

                    <!-- <el-table-column prop="is_audit" :label="t('isAudit')" min-width="120"
                        :show-overflow-tooltip="true" /> -->
                        <el-table-column prop="create_time" label="创建时间" min-width="120" :show-overflow-tooltip="true" />
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="editEvent(row)">详情</el-button>
                            <el-button :loading="loading" v-if="row.status==1" type="primary" link @click="asyncVideoEvent(row.id)">同步状态</el-button>
                            <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="videoTable.page" v-model:page-size="videoTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="videoTable.total"
                        @size-change="loadVideoList()" @current-change="loadVideoList" />
                </div>
            </div>

            <edit ref="editVideoDialog" @complete="loadVideoList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getVideoList, deleteVideo, getWithMemberList,asyncVideo } from '@/addon/ai_humans/api/video'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance } from 'element-plus'
import Edit from '@/addon/ai_humans/views/video/components/video-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;
const loading = ref(false)
const asyncVideoEvent=(id:number)=>{
    loading.value = true
    asyncVideo(id).then(res=>{
        loading.value = false
        loadVideoList()
    })
}
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
let videoTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "member_id": "",
        "name": "",
        "status": "",
        "platform": "",
        "is_audit": ""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据


/**
 * 获取视频生成列列表
 */
const loadVideoList = (page: number = 1) => {
    videoTable.loading = true
    videoTable.page = page

    getVideoList({
        page: videoTable.page,
        limit: videoTable.limit,
        ...videoTable.searchParam
    }).then(res => {
        videoTable.loading = false
        videoTable.data = res.data.data
        videoTable.total = res.data.total
    }).catch(() => {
        videoTable.loading = false
    })
}
loadVideoList()

const editVideoDialog: Record<string, any> | null = ref(null)

/**
 * 添加视频生成列
 */
const addEvent = () => {
    editVideoDialog.value.setFormData()
    editVideoDialog.value.showDialog = true
}

/**
 * 编辑视频生成列
 * @param data
 */
const editEvent = (data: any) => {
    editVideoDialog.value.setFormData(data)
    editVideoDialog.value.showDialog = true
}

/**
 * 删除视频生成列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('videoDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteVideo(id).then(() => {
            loadVideoList()
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
    loadVideoList()
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
