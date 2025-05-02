<template>
	<div class="main-container">
		<el-card class="box-card !border-none" shadow="never">

			<div class="flex justify-between items-center">
				<span class="text-lg">{{pageName}}</span>
				<!-- <el-button type="primary" @click="addEvent">
					{{ t('addComments') }}
				</el-button> -->
				<el-button type="danger" @click="batchdelEvent">
					{{ t('批量删除') }}
				</el-button>
			</div>

			<el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
				<el-form :inline="true" :model="commentsTable.searchParam" ref="searchFormRef">
					<el-form-item :label="t('tid')" prop="tid">
						<el-input v-model="commentsTable.searchParam.tid" :placeholder="t('tidPlaceholder')" />
					</el-form-item>
					<!-- <el-form-item :label="t('details')" prop="details">
						<el-input v-model="commentsTable.searchParam.details" :placeholder="t('detailsPlaceholder')" />
					</el-form-item> -->
					<!-- <el-form-item :label="t('用户')" prop="member_id">
						<el-select class="w-[280px]" v-model="commentsTable.searchParam.member_id" clearable searchable
							:placeholder="t('memberIdPlaceholder')">
							<el-option v-for="(item, index) in memberIdList" :key="index" :label="item['nickname']"
								:value="item['member_id']" />
						</el-select>
					</el-form-item> -->
					<el-form-item :label="t('评价时间')" prop="adddate">
						<el-date-picker v-model="commentsTable.searchParam.adddate" type="datetimerange"
							format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
							:end-placeholder="t('endDate')" />
					</el-form-item>
					<el-form-item>
						<el-button type="primary" @click="loadCommentsList()">{{ t('search') }}</el-button>
						<el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
					</el-form-item>
				</el-form>
			</el-card>

			<div class="mt-[10px]">
				<el-table :data="commentsTable.data" size="large" v-loading="commentsTable.loading" @selection-change="handleSelectionChange">
					<template #empty>
						<span>{{ !commentsTable.loading ? t('emptyData') : '' }}</span>
					</template>
					 <el-table-column
					      type="selection"
					      width="55"></el-table-column>
					<el-table-column prop="tid" :label="t('tid')" min-width="120" :show-overflow-tooltip="true" />

					<el-table-column prop="member_name" :label="t('发布人')" min-width="120"
						:show-overflow-tooltip="true" />

					<el-table-column prop="details" :label="t('评论内容')" min-width="320" :show-overflow-tooltip="true" />
					<!-- <el-table-column prop="like_num" :label="t('点赞数')" min-width="80" :show-overflow-tooltip="true"/> -->

					<el-table-column :label="t('status')" min-width="120" align="center">
						<template #default="{ row }">
							<span v-if="row.status == 1">{{ t('show') }}</span>
							<span v-if="row.status == 0">{{t('hidden')}}</span>
						</template>
					</el-table-column>
					<el-table-column prop="adddate" :label="t('评论时间')" min-width="140" :show-overflow-tooltip="true" />

					<el-table-column :label="t('operation')" fixed="right" min-width="180">
						<template #default="{ row }">
							<el-button type="primary" link @click="hflistEvent(row)">{{ t('查看回复') }}</el-button>
							<!-- <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button> -->
							<el-button type="danger" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
						</template>
					</el-table-column>


				</el-table>
				<div class="mt-[16px] flex justify-end">
					<el-pagination v-model:current-page="commentsTable.page" v-model:page-size="commentsTable.limit"
						layout="total, sizes, prev, pager, next, jumper" :total="commentsTable.total"
						@size-change="loadCommentsList()" @current-change="loadCommentsList" />
				</div>
			</div>


		</el-card>

		<hflist ref="hflistRef" :fromType="1"></hflist>

	</div>
</template>

<script lang="ts" setup>
	import { reactive, ref, watch } from 'vue'
	import { t } from '@/lang'
	import { useDictionary } from '@/app/api/dict'
	import { getCommentsList, deleteComments,batchdel } from '@/addon/blog/api/comments'
	import { getWithMemberList } from '@/addon/blog/api/tie'
	import { img } from '@/utils/common'
	import { ElMessageBox, FormInstance } from 'element-plus'
	import { useRouter } from 'vue-router'
	import { useRoute } from 'vue-router'
	const route = useRoute()
	const pageName = route.meta.title;
	import hflist from '@/addon/blog/views/comments/components/hflist.vue';
	let commentsTable = reactive({
		page: 1,
		limit: 10,
		total: 0,
		loading: true,
		data: [],
		searchParam: {
			"tid": "",
			"details": "",
			"addtime": "",
			"reply": "",
			"hf_time": "",
			"member_id": "",
			"member_name": "",
			"bid": "",
			"hf_id": "",
			"status": "",
			"touid": "",
			"adddate": "",
			"site_id": ""
		}
	})
	
	const reload2 = (tid) => {
		console.log(tid)
		if (!tid) return;
		commentsTable.searchParam.tid = tid
		loadCommentsList(1)
	}
	const tid: number = parseInt((route.query.tid || 0))
	if(tid>0){
		commentsTable.searchParam.tid = tid
	}
	

	const searchFormRef = ref<FormInstance>()

	// 选中数据
	const selectData = ref<any[]>([])

	// 字典数据
	const multipleSelection = ref([])
	const handleSelectionChange = (val) => {
		multipleSelection.value = val
	}
	const batchdelEvent = () => {
		if (multipleSelection.value.length == 0) {
			ElMessage.error('请选择数据'); return;
		}
		ElMessageBox.confirm(t('确定批量删除吗'), t('提示'),
			{
				confirmButtonText: t('确定'),
				cancelButtonText: t('取消'),
				type: 'warning',
			}
		).then(() => {
			var ids = [];
			multipleSelection.value.map((item) => {
				ids.push(item.id)
			})
			batchdel({
				ids: ids.join(',')
			}).then(res => {
				loadCommentsList()
			}).catch(() => {
				commentsTable.loading = false
			})
		})
		

	}
	
	
	
	const memberIdList = ref([] as any[])
		const setMemberIdList = async () => {
			memberIdList.value = await (await getWithMemberList({})).data
		}
		setMemberIdList()

	const hflistRef : Record<string, any> | null = ref(null)

	const hflistEvent = (row) => {
		hflistRef.value.showDialog = true;
		console.log(row.id)
		hflistRef.value.reload(row.id);
	};


	/**
	 * 获取评价列表
	 */
	const loadCommentsList = (page : number = 1) => {
		commentsTable.loading = true
		commentsTable.page = page

		getCommentsList({
			page: commentsTable.page,
			limit: commentsTable.limit,
			...commentsTable.searchParam
		}).then(res => {
			commentsTable.loading = false
			commentsTable.data = res.data.data
			commentsTable.total = res.data.total
		}).catch(() => {
			commentsTable.loading = false
		})
	}
	loadCommentsList()

	const router = useRouter()

	/**
	 * 添加评价
	 */
	const addEvent = () => {
		router.push('/comments/comments_edit')
	}

	/**
	 * 编辑评价
	 * @param data
	 */
	const editEvent = (data : any) => {
		router.push('/comments/comments_edit?id=' + data.id)
	}

	/**
	 * 删除评价
	 */
	const deleteEvent = (id : number) => {
		ElMessageBox.confirm(t('commentsDeleteTips'), t('warning'),
			{
				confirmButtonText: t('confirm'),
				cancelButtonText: t('cancel'),
				type: 'warning',
			}
		).then(() => {
			deleteComments(id).then(() => {
				loadCommentsList(commentsTable.page)
			}).catch(() => {
			})
		})
	}



	const resetForm = (formEl : FormInstance | undefined) => {
		if (!formEl) return
		formEl.resetFields()
		loadCommentsList()
	}
	defineExpose({
		reload2
	})
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