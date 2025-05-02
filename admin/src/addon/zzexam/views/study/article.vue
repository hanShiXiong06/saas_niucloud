<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
                <el-button type="primary" @click="addEvent">
                    {{ t('addArticle') }}
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="articleTable.searchParam" ref="searchFormRef">
                    <el-form-item :label="t('title')" prop="title">
                        <el-input v-model="articleTable.searchParam.title" clearable :placeholder="t('titlePlaceholder')" />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="loadArticleList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>
			
			<el-tabs class="mt-[10px]" v-model="articleTable.searchParam.type" @tab-change="handleClick">
				<el-tab-pane v-for="(item, key) in typeList" :label="item" :name="key"></el-tab-pane>
			</el-tabs>

            <div class="mt-[10px]">
                <el-table :data="articleTable.data" size="large" v-loading="articleTable.loading">
                    <template #empty>
                        <span>{{ !articleTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column prop="category.full_name" :label="t('categoryId')" min-width="180" :show-overflow-tooltip="true"/>
                    
                    <el-table-column :label="t('image')" width="170" align="left">
                        <template #default="{ row }">
                            <div class="h-[65px]">
                                <el-image class="w-[70px] h-[65px] " :src="img(row.image)" fit="contain">
                                    <template #error>
                                        <div class="image-slot">
                                            <img class="w-[70px] h-[65px]" src="@/addon/zzexam/assets/no_img.png" />
                                        </div>
                                    </template>
                                </el-image>
                            </div>
                        </template>
                    </el-table-column>
                    
                    <el-table-column prop="title" :label="t('title')" min-width="320" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="views" :label="t('views')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="sort" :label="t('sort')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="status" :label="t('status')" width="120">
						<template #default="{ row }">
							<el-tag class="cursor-pointer" :type="row.status != 'hidden' ? 'success' : 'danger'" @click="statusClick(row)">{{ row.status != 'hidden' ? '显示' : '隐藏' }}</el-tag>
						</template>
					</el-table-column>
                    
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                           <el-button type="primary" link @click="deleteEvent(row.article_id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="articleTable.page" v-model:page-size="articleTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="articleTable.total"
                        @size-change="loadArticleList()" @current-change="loadArticleList" />
                </div>
            </div>

            
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getArticleList, deleteArticle,getArticleTypeList } from '@/addon/zzexam/api/study'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRouter } from 'vue-router'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let articleTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "type":"know",
      "title":"",
      "status":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
const typeList = ref([])
const getArticleTypeListFn = async () => {
	typeList.value = await (await getArticleTypeList()).data
}
getArticleTypeListFn()

/**
 * 获取内容列表
 */
const loadArticleList = (page: number = 1) => {
    articleTable.loading = true
    articleTable.page = page

    getArticleList({
        page: articleTable.page,
        limit: articleTable.limit,
         ...articleTable.searchParam
    }).then(res => {
        articleTable.loading = false
        articleTable.data = res.data.data
        articleTable.total = res.data.total
    }).catch(() => {
        articleTable.loading = false
    })
}
loadArticleList()

const router = useRouter()

/**
 * 添加内容
 */
const addEvent = () => {
    router.push('/zzexam/article_edit')
}

/**
 * 编辑内容
 * @param data
 */
const editEvent = (data: any) => {
    router.push('/zzexam/article_edit?id='+data.article_id)
}

/**
 * 删除内容
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('articleDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteArticle(id).then(() => {
            loadArticleList()
        }).catch(() => {
        })
    })
}

const handleClick = (event: any) => {
    articleTable.searchParam.type = event;
    loadArticleList()
}
    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadArticleList()
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
