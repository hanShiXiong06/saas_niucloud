<template>
    <div class="main-container">
		
		<el-card class="box-card !border-none" shadow="never">
			
			<div class="flex justify-between items-center">
			    <div class="detail-head" style="margin-left: 0;">
			        <div class="left" @click="back()">
			            <span class="iconfont iconxiangzuojiantou !text-xs"></span>
			            <span class="ml-[1px]">{{t('returnToPreviousPage')}}</span>
			        </div>
			        <span class="adorn">|</span>
			        <span class="right">{{ pageName }} - {{paperInfo.title}}</span>
			    </div>
			    <question-select-popup v-if="paperInfo.status != 3" v-model="questionIds" @questionSelect="questionSelect" :min="1" :max="500" />
			</div>
			
			<div class="mt-[25px] mb-[15px] text-[#666666] flex">
				<div>
					总分{{paperInfo.total_score}}，需要（<span class="text-[20px] text-[red]">{{paperInfo.question_num}}</span>题,已选<span class="text-[20px] text-[red]">{{paperQuestionCount}}</span>题）
				</div>
				<div  v-for="(item,index) in paperQuestionList" :key="index">
					{{item.name}}{{item.score}}分（需数量<span class="text-[20px] text-[red]">{{item.num}}</span>，已选数量<span class="text-[20px] text-[red]">{{item.count}}</span>）
				</div>
			</div>

            <div class="mt-[10px]" v-if="paperQuestionCount == 0">
                <el-empty description="暂未选择题目"></el-empty>
            </div>
			<div class="mt-[10px] text-[13px]" v-else>
				<table class="options-table w-[100%]">
				    <colgroup>
				        <col width="5%">
				        <col width="10%">
				        <col width="40%">
				        <col width="15%">
						<col width="5%">
						<col width="15%">
						<col width="10%" v-if="paperInfo.status != 3">
				    </colgroup>
				    <thead class="bg-[#f7f7f7]">
				        <tr>
				            <th>排序</th>
				            <th>题型</th>
				            <th>题目</th>
							<th>分类</th>
							<th>难度</th>
							<th>添加时间</th>
				            <th v-if="paperInfo.status != 3">操作</th>
				        </tr>
				    </thead>
				    <tbody class="options-new">
				        <template v-for="(item,index) in paperQuestionList" :key="index">
				            <tr v-for="(item1,index1) in item.question_list" :key="index1">
				                <td>
									<el-input-number type="number" :min="1" v-model="item1.sort" @change="changeSort(item1)" :disabled="paperInfo.status == 3" />
								</td>
				                <td>
									{{item1.question.type_name}}
				                </td>
								<td>
									{{item1.question.title}}
								</td>
								<td>
									{{item1.question.category.full_name}}
								</td>
								<td>
									{{item1.question.difficulty_name}}
								</td>
								<td>
									{{item1.create_time}}
								</td>
								<td v-if="paperInfo.status != 3">
									<span class="cursor-pointer text-[var(--el-color-primary)]" @click="deleteEvent(item1.id)">删除</span>
								</td>
				            </tr>
				        </template>
				        
				    </tbody>
				</table>
			</div>
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { deletePaperQuestion, getPaperQuestionInfo, addPaperQuestion,editPaperQuestion } from '@/addon/zzexam/api/paper'
import questionSelectPopup from '@/addon/zzexam/views/question/components/question-select-popup.vue'
import { img, deepClone,filterDigit } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRoute } from 'vue-router'
const route = useRoute()
const paper_id:number = parseInt(route.query.paper_id);
const pageName = route.meta.title;


// 试卷信息
const paperInfo = ref({});

// 试卷已保存题目
const paperQuestionList = ref([]);

// 试卷已保存题数
const paperQuestionCount = ref(0);

// 已选题目IDs
const questionIds = ref([]);

const loadPaperQuestionInfo = () => {

    getPaperQuestionInfo(paper_id).then(res => {
        console.log(res);
		paperInfo.value = res.data.paper_info
		paperQuestionList.value = res.data.question_list
		paperQuestionCount.value = res.data.question_count
    }).catch(() => {})
	
}
loadPaperQuestionInfo()




/**
 * 更改排序
 */

const changeSort = (item: any) => {
	editPaperQuestion({id:item.id,sort:item.sort}).then(res => {
	  loadPaperQuestionInfo()
	}).catch(err => {})
}



/**
 * 删除试卷题目
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('paperQuestionDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deletePaperQuestion(id).then(() => {
            loadPaperQuestionInfo()
        }).catch(() => {})
    })
}

//选中题目回调
const questionSelect = (value: any) => {
	
	let questionList = deepClone(Object.values(value)).map((el: any, index: number) => { return el })
	let data = [];
	questionList.forEach((item,index) => {
		if(item.question_id && item.type){
			data.push({question_id:item.question_id,type:item.type})
		}
	})
	
	addPaperQuestion({paper_id:paperInfo.value.paper_id,question:data}).then(res => {
	    loadPaperQuestionInfo();
	}).catch(err => {})
	
}

const back = () => {
    history.back()
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
	.options-table {
		border: 1px solid #e6e6e6;
		
		thead tr, tbody tr {
			border-bottom: 1px solid #e6e6e6;
		}
		
		thead th, tbody td {
			padding: 5px 10px;
			border-right: 1px solid #e6e6e6;
		}
		
		thead th {
			text-align: center;
			font-weight: normal;
			font-size: 14px;
			color: #666;
			box-sizing: border-box;
		}
		
		tbody td {
			text-align: center;
		}
	}
</style>
