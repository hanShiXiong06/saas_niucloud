<template>
	<!-- 内容 -->
	<div class="content-wrap" v-show="diyStore.editTab == 'content'">
		<div class="edit-attr-item-wrap">
			<h3 class="mb-[10px]">海报设置</h3>
			<el-form label-width="80px" class="px-[10px]">
				<el-form-item label="落地页">
					<el-radio-group v-model="diyStore.editComponent.page">
						<el-radio :label="''">首页</el-radio>
						<el-radio :label="'member'">个人中心</el-radio>
					</el-radio-group>
				</el-form-item>
				<el-form-item label="海报" v-show="diyStore.editComponent.sources == 'diy'" class="flex">
					<span @click="showPoster" class="cursor-pointer flex-1" :class="{ 'text-primary': diyStore.editComponent.posterId }">{{ diyStore.editComponent.posterName || t('selectPlaceholder') }}</span>
					<el-icon>
						<ArrowRight />
					</el-icon>
				</el-form-item>
			</el-form>
			<h3 class="mb-[10px]">文本内容</h3>
			<el-form label-width="80px" class="px-[10px]">
				<el-form-item label="宣传语">
					<el-input v-model.trim="diyStore.editComponent.text" placeholder="邀请好友一起赚钱，好友推广你也有收益" clearable maxlength="19" show-word-limit />
				</el-form-item>
				<el-form-item label="提示语">
					<el-input v-model.trim="diyStore.editComponent.tip" placeholder="马上推广" clearable maxlength="25" show-word-limit />
				</el-form-item>
			</el-form>
		</div>

		<el-dialog v-model="showDialog" title="海报选择" width="60%" :close-on-press-escape="false" :close-on-click-modal="false">

			<div>
				<el-table :data="posterTableData.data" size="large" v-loading="posterTableData.loading">
					<template #empty>
						<span>{{ !posterTableData.loading ? t('emptyData') : '' }}</span>
					</template>

					<el-table-column prop="name" label="海报名称" min-width="120" />
                	<el-table-column prop="type_name" label="海报类型" min-width="80" />

                	<el-table-column :label="t('operation')" fixed="right" align="right" min-width="160">
	                    <template #default="{ row }">
	                        <el-button type="primary" @click="save(row)">{{ t('confirm') }}</el-button>
	                    </template>
	                </el-table-column>

				</el-table>
				<div class="mt-[16px] flex justify-end">
					<el-pagination v-model:current-page="posterTableData.page" v-model:page-size="posterTableData.limit"
						layout="total, sizes, prev, pager, next, jumper" :total="posterTableData.total"
						@size-change="loadPosterList()" @current-change="loadPosterList" />
				</div>
			</div>
		</el-dialog>
	</div>

	<!-- 样式 -->
	<div class="style-wrap" v-show="diyStore.editTab == 'style'">
		<div class="edit-attr-item-wrap">
			<h3 class="mb-[10px]">文本样式</h3>
			<el-form label-width="90px" class="px-[10px]">
				
				<el-form-item label="宣传语颜色">
					<el-color-picker v-model="diyStore.editComponent.textColor"/>
				</el-form-item>

				<el-form-item label="提示语颜色">
					<el-color-picker v-model="diyStore.editComponent.tipColor"/>
				</el-form-item>
				
			</el-form>
		</div>

		<!-- 组件样式 -->
		<slot name="style"></slot>
	</div>
</template>

<script lang="ts" setup>
import { t } from '@/lang'
import useDiyStore from '@/stores/modules/diy'
import { ref, reactive } from 'vue'
import { img } from '@/utils/common'
import { getPosterPageList } from '@/app/api/poster'

const diyStore: any = useDiyStore()
diyStore.editComponent.ignore = [] // 忽略公共属性

// 组件验证
diyStore.editComponent.verify = (index: number) => {
    const res = { code: true, message: '' }
    if (diyStore.value[index].sources === 'diy' && !diyStore.value[index].posterId) {
        res.code = false
        res.message = '请选择海报'
    }
    return res
}

const showDialog = ref(false)

const showPoster = () => {
    showDialog.value = true
}

const posterTableData = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
})

/**
 * 获取文章列表
 */
const loadPosterList = (page: number = 1) => {
    posterTableData.loading = true
    posterTableData.page = page

    getPosterPageList({
        page: posterTableData.page,
        limit: posterTableData.limit,
        type: 'ttn_fenxiao',
    }).then(res => {
        posterTableData.loading = false
        posterTableData.data = res.data.data
        posterTableData.total = res.data.total
    }).catch(() => {
        posterTableData.loading = false
    })
}

loadPosterList()

const save = (row) => {
    diyStore.editComponent.posterName = row.type_name + '-' +  row.name 
    diyStore.editComponent.type = row.type
    diyStore.editComponent.posterId = row.id
    showDialog.value = false
}



defineExpose({})
</script>

<style lang="scss">.article-slider {
	.el-slider__input {
		width: 100px;
	}
}</style>
<style lang="scss" scoped></style>
