<template>
	<div class="main-container">
		<el-card class="box-card !border-none" shadow="never">

			<div class="flex justify-between items-center">
				<span class="text-lg">{{pageName}}</span>
				<div class="flex">
					<el-button type="primary" @click="addEvent">
						{{ t('addTie') }}
					</el-button>
					<el-button type="success" @click="shenheEvent">
						{{ t('批量审核') }}
					</el-button>
				</div>
			</div>

			<el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
				<el-form :inline="true" :model="tieTable.searchParam" ref="searchFormRef">
					<el-form-item :label="t('cateId')" prop="cate_id">
						<el-select class="w-[280px]" v-model="tieTable.searchParam.cate_id" clearable
							:placeholder="t('cateIdPlaceholder')">
							<el-option v-for="(item, index) in cateIdList" :key="index" :label="item['name']"
								:value="item['id']" />
						</el-select>
					</el-form-item>
					<el-form-item :label="t('memberId')" prop="member_id">
						<el-select class="w-[280px]" v-model="tieTable.searchParam.member_id" clearable
							:placeholder="t('memberIdPlaceholder')">
							<el-option v-for="(item, index) in memberIdList" :key="index" :label="item['nickname']"
								:value="item['member_id']" />
						</el-select>
					</el-form-item>
					<el-form-item :label="t('status')" prop="status">
						<el-input v-model="tieTable.searchParam.status" :placeholder="t('statusPlaceholder')" />
					</el-form-item>
					<!-- <el-form-item :label="t('status')" prop="status">
						<el-input v-model="tieTable.searchParam.status" :placeholder="t('statusPlaceholder')" />
					</el-form-item>

					<el-form-item :label="t('label')" prop="label">
						<el-select class="w-[280px]" v-model="tieTable.searchParam.label" clearable
							:placeholder="t('labelPlaceholder')">
							<el-option v-for="(item, index) in labelList" :key="index" :label="item['name']"
								:value="item['id']" />
						</el-select>
					</el-form-item>

					<el-form-item :label="t('labelname')" prop="labelname">
						<el-input v-model="tieTable.searchParam.labelname" :placeholder="t('labelnamePlaceholder')" />
					</el-form-item> -->
					<el-form-item :label="t('adddate')" prop="adddate">
						<el-date-picker v-model="tieTable.searchParam.adddate" type="datetimerange"
							format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
							:end-placeholder="t('endDate')" />
					</el-form-item>

					<el-form-item>
						<el-button type="primary" @click="loadTieList()">{{ t('search') }}</el-button>
						<el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
					</el-form-item>
				</el-form>
			</el-card>

			<div class="mt-[10px]">
				<el-table :data="tieTable.data" size="large" v-loading="tieTable.loading"
					@selection-change="handleSelectionChange">
					<template #empty>
						<span>{{ !tieTable.loading ? t('emptyData') : '' }}</span>
					</template>
					<el-table-column type="selection" width="55">
					</el-table-column>
					<el-table-column prop="id" :label="t('id')" min-width="120" :show-overflow-tooltip="true" />

					<el-table-column prop="details" :label="t('details')" min-width="280"
						:show-overflow-tooltip="true" />

					<el-table-column prop="cate_id_name" :label="t('cateId')" min-width="120"
						:show-overflow-tooltip="true" />

					<el-table-column prop="labelname" :label="t('label')" min-width="200"
						:show-overflow-tooltip="true" />

					<el-table-column :label="t('imgs')" width="180" align="left">
						<template #default="{ row }">
							<div>
								<a :href="img(it)" v-for="(it,ind) in row.imgs" target="__blank">
									<el-avatar :src="img(it)" style="border-radius: 0;margin-right:5px" />
								</a>
							</div>
						</template>
					</el-table-column>
					<el-table-column :label="t('status')" min-width="120" align="center">
						<template #default="{ row }">
							<span v-if="row.status == 2" style="color:#1ba035">{{ t('审核通过') }}</span>
							<span v-if="row.status == 1" style="color:#1677ff">{{ t('待审核') }}</span>
							<span v-if="row.status == 0" style="color:#f00">{{t('已下架')}}</span>
						</template>
					</el-table-column>
					<el-table-column prop="member_id_name" :label="t('memberId')" min-width="120"
						:show-overflow-tooltip="true" />

					<el-table-column prop="top_enddate" :label="t('置顶到期时间')" min-width="120"
						:show-overflow-tooltip="true" />

					<!-- <el-table-column prop="views" :label="t('views')" min-width="120" :show-overflow-tooltip="true" /> -->




					<!-- <el-table-column prop="labelname_name" :label="t('labelname')" min-width="120"
						:show-overflow-tooltip="true" /> -->

					<el-table-column prop="adddate" :label="t('adddate')" min-width="150"
						:show-overflow-tooltip="true" />

					<el-table-column :label="t('operation')" fixed="right" min-width="220">
						<template #default="{ row }">
							<el-button type="primary" link @click="commentsEvent(row)">{{ t('查看评论') }}</el-button>
							<el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
							<el-button type="danger" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
						</template>
					</el-table-column>

				</el-table>
				<div class="mt-[16px] flex justify-end">
					<el-pagination v-model:current-page="tieTable.page" v-model:page-size="tieTable.limit"
						layout="total, sizes, prev, pager, next, jumper" :total="tieTable.total"
						@size-change="loadTieList()" @current-change="loadTieList" />
				</div>
			</div>

			<edit ref="editTieDialog" @complete="loadTieList" />
		</el-card>


		<el-dialog title="批量审核" v-model="showshenhe" width="900px" class="projectInfo">
			<el-form ref="suoruleForm" label-width="120px" class="demo-ruleForm">

				<el-form-item label="审核状态" prop="refusal">
					<el-radio-group v-model="shenhe_status">
						<el-radio value="0" size="large">下架帖子</el-radio>
						<!-- <el-radio value="1" size="large">待审核</el-radio> -->
						<el-radio value="2" size="large">审核通过</el-radio>
					</el-radio-group>
				</el-form-item>
				<el-form-item>
					<el-button type="primary" @click="toshenhe">确定</el-button>
				</el-form-item>
			</el-form>
		</el-dialog>

		<el-dialog title="查看评论" v-model="showcomments" width="900px" class="projectInfo">
			<comments ref="commentsRef" :fromType="1"></comments>
		</el-dialog>


	</div>
</template>

<script lang="ts" setup>
	import { reactive, ref, watch } from 'vue'
	import { t } from '@/lang'
	import { useDictionary } from '@/app/api/dict'
	import { getTieList, deleteTie, getWithCateList, getWithMemberList, getWithLabelList, shenhe_tie } from '@/addon/blog/api/tie'
	import { img } from '@/utils/common'
	import { ElMessageBox, FormInstance, ElMessage } from 'element-plus'
	import Edit from '@/addon/blog/views/tie/components/tie-edit.vue'

	import comments from '@/addon/blog/views/comments/comments.vue';

	import { useRouter, useRoute } from 'vue-router'
	const route = useRoute()
	const pageName = route.meta.title;

	let tieTable = reactive({
		page: 1,
		limit: 10,
		total: 0,
		loading: true,
		data: [],
		searchParam: {
			"cate_id": "",
			"details": "",
			"member_id": "",
			"status": "",
			"label": "",
			"labelname": "",
			"adddate": []
		}
	})

	const searchFormRef = ref<FormInstance>()

	// 选中数据
	const selectData = ref<any[]>([])

	const multipleSelection = ref([])
	const handleSelectionChange = (val) => {
		multipleSelection.value = val
	}
	const showshenhe = ref(false);
	const shenheEvent = () => {
		if (multipleSelection.value.length == 0) {
			ElMessage.error('请选择数据'); return;
		}
		showshenhe.value = true;
	}
	const shenhe_status = ref('2');
	const toshenhe = () => {
		if (!shenhe_status.value) {
			ElMessage.error('请选择审核状态'); return;
		}

		var ids = [];
		multipleSelection.value.map((item) => {
			ids.push(item.id)
		})
		shenhe_tie({
			ids: ids.join(','),
			status: shenhe_status.value
		}).then(res => {
			showshenhe.value = false;
			tieTable.loading = false
			tieTable.data = res.data.data
			tieTable.total = res.data.total
		}).catch(() => {
			tieTable.loading = false
		})

	}
	/**
	 * 获取帖子列表
	 */
	const loadTieList = (page : number = 1) => {
		tieTable.loading = true
		tieTable.page = page

		getTieList({
			page: tieTable.page,
			limit: tieTable.limit,
			...tieTable.searchParam
		}).then(res => {
			tieTable.loading = false
			tieTable.data = res.data.data
			tieTable.total = res.data.total
		}).catch(() => {
			tieTable.loading = false
		})
	}
	loadTieList()

	const editTieDialog : Record<string, any> | null = ref(null)

	/**
	 * 添加帖子
	 */
	const addEvent = () => {
		editTieDialog.value.setFormData()
		editTieDialog.value.showDialog = true
	}

	/**
	 * 编辑帖子
	 * @param data
	 */
	const editEvent = (data : any) => {

		editTieDialog.value.setFormData(data)
		editTieDialog.value.showDialog = true
	}

	/**
	 * 删除帖子
	 */
	const deleteEvent = (id : number) => {
		ElMessageBox.confirm(t('tieDeleteTips'), t('warning'),
			{
				confirmButtonText: t('confirm'),
				cancelButtonText: t('cancel'),
				type: 'warning',
			}
		).then(() => {
			deleteTie(id).then(() => {
				loadTieList(tieTable.page)
			}).catch(() => {
			})
		})
	}


	const cateIdList = ref([])
	const setCateIdList = async () => {
		cateIdList.value = await (await getWithCateList({})).data
	}
	setCateIdList()
	const memberIdList = ref([])
	const setMemberIdList = async () => {
		memberIdList.value = await (await getWithMemberList({})).data
	}
	setMemberIdList()

	const labelnameList = ref([])
	const setLabelnameList = async () => {
		labelnameList.value = await (await getWithLabelList({})).data
	}
	setLabelnameList()

	const resetForm = (formEl : FormInstance | undefined) => {
		if (!formEl) return
		formEl.resetFields()
		loadTieList()
	}


	const showcomments = ref(false);
	const commentsRef = ref(null)
	const router = useRouter()
	const commentsEvent = (row) => {

		// console.log(commentsRef)
		// if (commentsRef.value) {
		// 	commentsRef.value.reload2(row.id);
		// 	showcomments.value = true;
		// }
		// this.$router.push('/about',query:{tid:row.id});
		router.push('/blog/comments?tid=' + row.id)
	};
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