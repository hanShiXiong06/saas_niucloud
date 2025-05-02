<template>
	<el-dialog v-model="showDialog" :title="'查看回复'" width="90%" height="90%" style="margin-top:3%"
		class="diy-dialog-wrap" :destroy-on-close="true">
		<el-card class="box-card !border-none" shadow="never">
		
			<div>
				<el-button type="danger" @click="batchdelEvent">
					{{ t('批量删除') }}
				</el-button>
			</div>

			<div class="mt-[10px]">
				<el-table :data="commentsTable.data" size="large" v-loading="commentsTable.loading" @selection-change="handleSelectionChange">
					<template #empty>
						<span>{{ !commentsTable.loading ? t('emptyData') : '' }}</span>
					</template>
					 <el-table-column
					      type="selection"
					      width="55"></el-table-column>
					<!-- <el-table-column prop="id" :label="t('id')" min-width="80" :show-overflow-tooltip="true"/>
		           
				   <el-table-column prop="tie_name" :label="t('视频信息')" min-width="150" :show-overflow-tooltip="true"/> -->
					<el-table-column prop="member_name" :label="t('发布人')" min-width="120"
						:show-overflow-tooltip="true" />

					<el-table-column prop="details" :label="t('回复内容')" min-width="320" :show-overflow-tooltip="true" />

					<el-table-column :label="t('status')" min-width="120" align="center">
						<template #default="{ row }">
							<span v-if="row.status == 1">{{ t('show') }}</span>
							<span v-if="row.status == 0">{{t('hidden')}}</span>
						</template>
					</el-table-column>
					<el-table-column prop="adddate" :label="t('回复时间')" min-width="140" :show-overflow-tooltip="true" />

					<el-table-column :label="t('operation')" fixed="right" min-width="180">
						<template #default="{ row }">
							<!-- <el-button type="primary" link @click="hflistEvent(row)">{{ t('查看回复') }}</el-button> -->
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

			<!-- <edit ref="editCommentsDialog" @complete="loadCommentsList" /> -->


		</el-card>
		<hflist ref="hflistRef" :fromType="1"></hflist>

	</el-dialog>
</template>

<script lang="ts" setup>
	let showDialog = ref(false)
	const loading = ref(false)


	import { reactive, ref, watch } from 'vue'
	import { t } from '@/lang'
	import { getCommentsReplyList, deleteCommentsReply } from '@/addon/blog/api/comments_reply'
	import { batchdel } from '@/addon/blog/api/comments'
	//import { getWithMemberList } from '@/addon/blog/api/tie'

	import { img } from '@/utils/common'
	import { ElMessageBox, FormInstance } from 'element-plus'
	// import Edit from '@/addon/blog/views/comments/components/hflist-edit.vue'
	// import hflist from '@/addon/blog/views/comments/components/hflist.vue';
	import { useRoute } from 'vue-router'
	const route = useRoute()
	const pageName = route.meta.title;

	let commentsTable = reactive({
		page: 1,
		limit: 10,
		hf_id: 0,
		total: 0,
		loading: true,
		data: [],
		searchParam: {
			"tid": "",
			"adddate": []
		}
	})

	const searchFormRef = ref<FormInstance>()

	// 选中数据
	const selectData = ref<any[]>([])

	const reload = (hf_id) => {
		if (!hf_id) return;
		commentsTable.hf_id = hf_id
		loadCommentsList(1)
	}



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
	
	
	/**
	 * 获取分类列表
	 */
	const loadCommentsList = (page : number = 1) => {
		commentsTable.loading = true
		commentsTable.page = page

		getCommentsReplyList({
			page: commentsTable.page,
			hf_id: commentsTable.hf_id,
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

	const editCommentsDialog : Record<string, any> | null = ref(null)

	const memberIdList = ref([] as any[])
	const setMemberIdList = async () => {
		memberIdList.value = await (await getWithMemberList({})).data
	}
	setMemberIdList()

	// const tieList = ref([] as any[])
	// 	const settielistList = async () => {
	// 		tieList.value = await (await getWithtielist({})).data
	// 	}
	// 	settielistList()
	/**
	 * 添加分类
	 */
	const addEvent = () => {
		editCommentsDialog.value.setFormData()
		editCommentsDialog.value.showDialog = true
	}


	const hflistRef : Record<string, any> | null = ref(null)

	const hflistEvent = (row) => {
		hflistRef.value.showDialog = true;
		hflistRef.value.loadCommentsList(1, row.id);
	};


	/**
	 * 编辑分类
	 * @param data
	 */
	const editEvent = (data : any) => {
		editCommentsDialog.value.setFormData(data)
		editCommentsDialog.value.showDialog = true
	}

	/**
	 * 删除分类
	 */
	const deleteEvent = (id : number) => {
		ElMessageBox.confirm(t('commentsDeleteTips'), t('warning'),
			{
				confirmButtonText: t('confirm'),
				cancelButtonText: t('cancel'),
				type: 'warning',
			}
		).then(() => {
			deleteCommentsReply(id).then(() => {
				loadCommentsList()
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
		showDialog, reload
	})
</script>

<style lang="scss" scoped></style>
<style lang="scss">
	.diy-dialog-wrap .el-form-item__label {
		height: auto !important;
	}
</style>