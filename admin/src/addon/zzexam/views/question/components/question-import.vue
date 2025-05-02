<template>
    <el-dialog v-model="importDialog" :title="t('导入题目')" width="70%" heigh="90%">
        <div>
            <el-form :model="importData" ref="importDataFormRef" :rules="formRules" label-width="150px" label-position="left" >
                <div>
                    <div class="form-tip cursor-pointer !text-[var(--el-color-primary)]">
						<el-button type="primary" @click="examineTemplate" >点击下载EXECL样板</el-button>
                    </div>
					<div class="my-[10px]">
						<div>
							<img class="w-[100%]" :src="img('/addon/zzexam/batch/batch_question_template.png')" />
						</div>
					    <div class="text-[red] my-[10px]">
							<div class="flex">
								<p class="font-bold w-[220px] text-right pr-[30px]">（必填）一级分类:</p>
								<p>填写 题目一级分类的名称，请先添加好分类，否则题目不会导入</p>
							</div>
							<div class="flex mt-[5px]">
								<p class="font-bold w-[220px] text-right pr-[30px]">（选填）一级分类:</p>
								<p>填写 题目二级分类的名称，请先添加好分类，否则题目归属一级分类</p>
							</div>
							<div class="flex mt-[5px]">
								<p class="font-bold w-[220px] text-right pr-[30px]">（必填）题型:</p>
								<p>填写 单选题，多选题，判断题，填空题，其中一个。</p>
							</div>
							<div class="flex mt-[5px]">
								<p class="font-bold w-[220px] text-right pr-[30px]">（必填）难度:</p>
								<p>填写 1 至 10 的其中一个，非法值将视为 1 存入。</p>
							</div>
							<div class="flex mt-[5px]">
								<p class="font-bold w-[220px] text-right pr-[30px]">（必填）题目:</p>
								<p>填写 题目标题、可填入HTML代码</p>
							</div>
							<div class="flex mt-[5px]">
								<p class="font-bold w-[220px] text-right pr-[30px]">（条件选填）选项内容:</p>
								<p>单选题、判断题、多选题选填、需填写选项，"\n" 为分隔符，对应答案按顺序个数从A到J，选项如：选项1\n选项2\n选项3\n选项4 答案则：A到D</p>
							</div>
							<div class="flex mt-[5px]">
								<p class="font-bold w-[220px] text-right pr-[30px]">（条件选填）选项图片链接:</p>
								<p>单选题、判断题、多选题选填、需填写选项，"\n" 为分隔符，对应答案按顺序个数从A到J，选项如：链接1\n链接2\n链接3\n链接4 答案则：A到D</p>
							</div>
							<div class="flex mt-[5px]">
								<p class="font-bold w-[220px] text-right pr-[30px]">（条件选填）选项视频链接:</p>
								<p>单选题、判断题、多选题选填、需填写选项，"\n" 为分隔符，对应答案按顺序个数从A到J，选项如：链接1\n链接2\n链接3\n链接4 答案则：A到D</p>
							</div>
							<div class="flex mt-[5px]">
								<p class="font-bold w-[220px] text-right pr-[30px]">（条件必填）答案:</p>
								<p>单选题、判断题、多选题、填空题必填，多个答案请使用全角逗号（中文输入法）作为分隔符。例子：A，D。</p>
							</div>
							<div class="flex mt-[5px]">
								<p class="font-bold w-[220px] text-right pr-[30px]">（选填）解析:</p>
								<p>答题解析（可填写HTML代码）</p>
							</div>
						</div>
					</div>
                </div>

                <el-form-item :label="t('上传EXCEL文件')" prop="path">
                    <upload-file v-model="importData.path" api="sys/document/excel" />
                </el-form-item>
            </el-form>
        </div>
        <template #footer>
            <span class="dialog-footer">
                <el-button @click="importDialog = false">{{ t('cancel') }}</el-button>
                <el-button type="primary" :loading="importDialogLoading" @click="importDialogConfirm(importDataFormRef)">{{ t('confirm') }}</el-button>
            </span>
        </template>
    </el-dialog>
</template>

<script lang="ts" setup>
import { ref, computed } from 'vue'
import { t } from '@/lang'
import { FormInstance } from 'element-plus'
import { addBatchQuestion } from '@/addon/zzexam/api/question'
import { useRouter } from 'vue-router'
import { img } from '@/utils/common'

const router = useRouter()
const importDialog = ref(false)

/**
 * 表单数据
 */
const importData = ref({
    path: ''
})

// 重置数据
const initDataFn = ()=>{
    importData.value.path = '';
    importDialogLoading.value = false;
}

// 打开弹窗
const open = ()=>{
    initDataFn();
    importDialog.value = true;
}
const importDialogLoading = ref(false)

const emit = defineEmits(['complete'])
const importDialogConfirm = async (formEl: FormInstance | undefined) => {
    if (importDialogLoading.value || !formEl) return
    await formEl.validate(async (valid) => {
        if (valid) {
            importDialogLoading.value = true
            const data = importData.value
            addBatchQuestion(data).then((res) => {
                emit('complete');
                importDialog.value = false;
            }).catch(() => {
                importDialogLoading.value = false
            })
        }
    })
}
const importDataFormRef = ref<FormInstance>()

const examineTemplate = ()=>{
    let url = `${import.meta.env.VITE_IMG_DOMAIN || location.origin}/addon/zzexam/batch/batch_question_template.xlsx`;
    window.open(url)
}

// 表单验证规则
const formRules = computed(() => {
    return {
        path: [{ required: true, message: t('请上传EXCEL文件'), trigger: 'blur' }]
    }
})
defineExpose({
    open
})
</script>
