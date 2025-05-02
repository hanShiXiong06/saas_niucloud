<template>
	<!-- 内容 -->
	<div class="content-wrap" v-show="diyStore.editTab == 'content'">
		
		<div class="edit-attr-item-wrap">
			<h3 class="mb-[20px]">显示标题</h3>
			<el-form >
				<el-form-item>
					<el-input v-model="diyStore.editComponent.title_text" />
				</el-form-item>
			</el-form>
		</div>
		
		<div class="edit-attr-item-wrap">
			<h3 class="mb-[20px]">选择数据源</h3>
			<el-form >
				
				<el-form-item>
					<el-radio-group v-model="diyStore.editComponent.source" class="mb-[18px]">
						<el-radio label="all">全部考试</el-radio>
						<el-radio label="subject">选择科目</el-radio>
						<el-radio label="custom">手动选择</el-radio>
					</el-radio-group>
				</el-form-item>
				
				<el-form-item label="选择科目" v-if="diyStore.editComponent.source == 'subject'">
					<div class="flex items-center w-full">
						<div class="cursor-pointer ml-auto" @click="subjectShowDialogOpen">
							<span class="text-[var(--el-color-primary)]">{{ currSubjectName }}</span>
							<span class="iconfont iconxiangyoujiantou"></span>
						</div>
					</div>
				</el-form-item>
				<el-form-item v-if="diyStore.editComponent.source == 'custom'">
					<exam-select-popup ref="examSelectPopupRef" v-model="diyStore.editComponent.exam_ids" :min="1" :max="99" />
				</el-form-item>
				
				<el-form-item label="考试数量" v-if="diyStore.editComponent.source == 'all' || diyStore.editComponent.source == 'subject'">
					<div class="flex items-center w-full ml-[5px]">
						<el-slider class="flex-1" v-model="diyStore.editComponent.num" max="20" size="small" />
						<span class="ml-[15px]">{{ diyStore.editComponent.num }}</span>
					</div>
				</el-form-item>
			</el-form>

			<el-dialog v-model="subjectShowDialog" title="选择科目" width="1000px" :close-on-press-escape="false" :destroy-on-close="true" :close-on-click-modal="false">
				<el-table :data="subjectTable.data" ref="subjectTableRef" size="large" v-loading="subjectTable.loading"
					height="490px" @selection-change="handleSelectionChange" row-key="subject_id"
					:tree-props="{ hasChildren: 'hasChildren', children: 'child_list' }">
					<template #empty>
						<span>{{ !subjectTable.loading ? t('emptyData') : '' }}</span>
					</template>
					<el-table-column type="selection" width="55" />
					<el-table-column :label="t('科目名称')" min-width="120">
						<template #default="{ row }">
							<span class="order-2">{{ row.name }}</span>
						</template>
					</el-table-column>
					<el-table-column :label="t('科目图片')" width="170" align="left">
						<template #default="{ row }">
							<div class="h-[30px]">
								<el-image class="w-[30px] h-[30px] " :src="img(row.image)" fit="contain">
									<template #error>
										<div class="image-slot">
											<img class="w-[30px] h-[30px]" src="@/addon/zzexam/assets/no_img.png" />
										</div>
									</template>
								</el-image>
							</div>
						</template>
					</el-table-column>
				</el-table>
				<div class="flex items-center justify-end mt-[15px]">
					<el-button type="primary" @click="saveSubjectId">{{ t('confirm') }}</el-button>
					<el-button @click="subjectShowDialog = false">{{ t('cancel') }}</el-button>
				</div>
			</el-dialog>

		</div>
	</div>

	<!-- 样式 -->
	<div class="style-wrap" v-show="diyStore.editTab == 'style'">
		<!-- 组件样式 -->
		<slot name="style"></slot>
	</div>
</template>

<script lang="ts" setup>
import { getSubjectTree } from '@/addon/zzexam/api/exam'
import { t } from '@/lang'
import { img } from '@/utils/common'
import useDiyStore from '@/stores/modules/diy'
import { ref, reactive, onMounted } from 'vue'
import { ElTable } from 'element-plus'
import examSelectPopup from '@/addon/zzexam/views/exam/components/exam-select-popup.vue'

const diyStore:any = useDiyStore()
diyStore.editComponent.ignore = [] // 忽略公共属性

const subjectShowDialog = ref(false)

const subjectTable = reactive({
    loading: true,
    data: [],
})
onMounted(() => {
    loadSubjectList()
})

const subjectTableRef = ref<InstanceType<typeof ElTable>>()
/**
 * 获取科目列表
 */
let currSubjectData: string | null = null
const loadSubjectList = () => {
    subjectTable.loading = true

    getSubjectTree().then(res => {
        subjectTable.loading = false
        subjectTable.data = res.data
        if (diyStore.editComponent.source == 'subject') {
            subjectTable.data.forEach((item:any, index) => {
                if (diyStore.editComponent.subject_id == item.subject_id) {
                    currSubjectName.value = item.name
                    currSubjectData = item
                }
            })
        }
    }).catch(() => {
        subjectTable.loading = false
    })
}

// 选择文章分类
let currSubject:any = {}
const currSubjectName = ref('请选择')
const handleSelectionChange = (val: string | any[]) => {
    let data = ''
    if (val) data = val[val.length - 1]
    if (val.length > 1) subjectTableRef.value!.clearSelection()
    if (data) subjectTableRef.value!.toggleRowSelection(data, true)
    currSubjectData = data
    currSubject = data
}

const saveSubjectId = () => {
    diyStore.editComponent.subject_id = currSubject.subject_id
    currSubjectName.value = currSubject.full_name
    subjectShowDialog.value = false
}

const subjectShowDialogOpen = () => {
    subjectShowDialog.value = true
    if (currSubjectData) {
        setTimeout(() => {
			subjectTableRef.value!.toggleRowSelection(currSubjectData, true)
        }, 200)
    }
}

defineExpose({})

</script>

<style lang="scss" scoped></style>
