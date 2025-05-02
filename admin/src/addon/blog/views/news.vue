<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addNews') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="newsTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('name')" prop="name">
                        <el-input v-model="newsTable.searchParam.name" :placeholder="t('namePlaceholder')" />
                    </el-form-item>
                   <!-- <el-form-item :label="t('link')" prop="link">
                        <el-input v-model="newsTable.searchParam.link" :placeholder="t('linkPlaceholder')" />
                    </el-form-item> -->
                    <el-form-item :label="t('adddate')" prop="adddate">
                        <el-date-picker v-model="newsTable.searchParam.adddate" type="datetimerange" format="YYYY-MM-DD hh:mm:ss"
                            :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
                    </el-form-item>
                    
                    <el-form-item>
                        <el-button type="primary" @click="loadNewsList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="newsTable.data" size="large" v-loading="newsTable.loading">
                    <template #empty>
                        <span>{{ !newsTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="id" :label="t('id')" min-width="50" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="name" :label="t('name')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="adddate" :label="t('adddate')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="newsTable.page" v-model:page-size="newsTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="newsTable.total"
                        @size-change="loadNewsList()" @current-change="loadNewsList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getNewsList, deleteNews } from '@/addon/blog/api/news'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let newsTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "name":"",
      "link":"",
      "adddate":[]
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取公告资讯列表
 */
const loadNewsList = (page: number = 1) => {
    newsTable.loading = true
    newsTable.page = page

    getNewsList({
        page: newsTable.page,
        limit: newsTable.limit,
         ...newsTable.searchParam
    }).then(res => {
        newsTable.loading = false
        newsTable.data = res.data.data
        newsTable.total = res.data.total
    }).catch(() => {
        newsTable.loading = false
    })
}
loadNewsList()

const router = useRouter()

/**
 * 添加公告资讯
 */
const addEvent = () => {
    router.push('/blog/news/news_edit')
}

/**
 * 编辑公告资讯
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/blog/news/news_edit?id='+data.id)
}

/**
 * 删除公告资讯
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('newsDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteNews(id).then(() => {
            loadNewsList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadNewsList()
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
