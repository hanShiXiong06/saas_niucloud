<template>
    <div v-if="!loading">
        <el-card class="box-card !border-none" shadow="never">
            <div class="p-[30px] box-border border-[1px] border-[var(--el-border-color)] border-solid bg-[var(--el-bg-color)]">
                <el-card class="box-card !border-none profile-data" shadow="never">
                    <template #header>
                        <div class="card-header mb-[20px] w-full">
                            <span class="text-[18px]">{{ t("数据概况") }}</span>
                            <span class="text-[12px] text-[#666] leading-[16px] ml-[18px]">更新时间 : </span>
                            <span class="text-[12px] text-[#666] leading-[16px]">{{ time }}</span>
                        </div>
                    </template>

                    <el-row :gutter="20" class="mt-[20px] top">
						<el-col>
						    <div class="cursor-pointer">
						        <el-statistic :value="statInfo.order_money.total" precision = "2">
						            <template #title>
						                <div class="text-[14px] mb-[9px] text-[#666]">
						                    总收入
						                </div>
						            </template>
						        </el-statistic>
						    </div>
						</el-col>
                        <el-col>
                            <div @click="toLink('/zzexam/exam/order')" class="cursor-pointer">
                                <el-statistic :value="statInfo.order_money.exam" precision = "2">
                                    <template #title>
                                        <div class="text-[14px] mb-[9px] text-[#666]">
                                            付费考试收入
                                        </div>
                                    </template>
                                </el-statistic>
                            </div>
                        </el-col>
                        <el-col>
                            <div @click="toLink('/zzexam/vip/order')" class="cursor-pointer">
                                <el-statistic :value="statInfo.order_money.vip" precision = "2">
                                    <template #title>
                                        <div class="text-[14px] mb-[9px] text-[#666]">
                                            开通VIP收入
                                        </div>
                                    </template>
                                </el-statistic>
                            </div>
                        </el-col>
                        <el-col>
                            <div class="cursor-pointer">
                                <el-statistic :value="statInfo.order_money.month" precision = "2">
                                    <template #title>
                                        <div class="text-[14px] mb-[9px] text-[#666]">
                                            本月收入
                                        </div>
                                    </template>
                                </el-statistic>
                            </div>
                        </el-col>
                        <el-col>
                            <div class="cursor-pointer">
                                <el-statistic :value="statInfo.order_money.year" precision = "2">
                                    <template #title>
                                        <div class="text-[14px] mb-[9px] text-[#666]">
                                            今年收入
                                        </div>
                                    </template>
                                </el-statistic>
                            </div>
                        </el-col>
                        
                    </el-row>
					
					<el-row :gutter="20" class="mt-[20px] top">
						<el-col>
						    <div @click="toLink('/zzexam/scores')" class="cursor-pointer">
						        <el-statistic :value="statInfo.count_action.scores">
						            <template #title>
						                <div class="text-[14px] mb-[9px] text-[#666]">
						                    考试次数
						                </div>
						            </template>
						        </el-statistic>
						    </div>
						</el-col>
					    <el-col>
					        <div @click="toLink('/zzexam/scores')" class="cursor-pointer">
					            <el-statistic :value="statInfo.count_action.people" >
					                <template #title>
					                    <div class="text-[14px] mb-[9px] text-[#666]">
					                        考生数量
					                    </div>
					                </template>
					            </el-statistic>
					        </div>
					    </el-col>
					    <el-col>
					        <div @click="toLink('/zzexam/note')" class="cursor-pointer">
					            <el-statistic :value="statInfo.count_action.note" >
					                <template #title>
					                    <div class="text-[14px] mb-[9px] text-[#666]">
					                        笔记数量
					                    </div>
					                </template>
					            </el-statistic>
					        </div>
					    </el-col>
					    <el-col>
					        <div @click="toLink('/zzexam/errors')" class="cursor-pointer">
					            <el-statistic :value="statInfo.count_action.errors">
					                <template #title>
					                    <div class="text-[14px] mb-[9px] text-[#666]">
					                        错题次数
					                    </div>
					                </template>
					            </el-statistic>
					        </div>
					    </el-col>
					    
					    <el-col>
					        <div @click="toLink('/zzexam/collect')" class="cursor-pointer">
					            <el-statistic :value="statInfo.count_action.collect">
					                <template #title>
					                    <div class="text-[14px] mb-[9px] text-[#666]">
					                        收藏数量
					                    </div>
					                </template>
					            </el-statistic>
					        </div>
					    </el-col>
					</el-row>
                </el-card>
                
                <div class="flex justify-between mt-[15px]">
					
					<div class="flex-1 h-[145px] bg-[var(--el-color-info-light-9)] flex justify-center flex-col items-center cursor-pointer mr-[25px]" @click="toLink('/zzexam/exam')">
						<div class="flex">
							<img class="w-[56px] h-[56px] rounded-[28px]" src="@/addon/zzexam/assets/exam.png" />
							<div class="ml-[10px]">
								<div>
									<span class="text-[16px] ">考试</span>
								</div>
								<div>
									<span class="text-[20px]">{{ statInfo.count_data.exam }}</span> 个
								</div>
							</div>
						</div>
					</div>
					<div class="flex-1 h-[145px] bg-[var(--el-color-info-light-9)] flex justify-center flex-col items-center cursor-pointer mr-[25px]" @click="toLink('/zzexam/paper')">
						<div class="flex">
							<img class="w-[56px] h-[56px] rounded-[28px]" src="@/addon/zzexam/assets/paper.png" />
							<div class="ml-[10px]">
								<div>
									<span class="text-[16px] ">试卷</span>
								</div>
								<div>
									<span class="text-[20px]">{{ statInfo.count_data.paper }}</span>
								</div>
							</div>
						</div>
					</div>
					<div class="flex-1 h-[145px] bg-[var(--el-color-info-light-9)] flex justify-center flex-col items-center cursor-pointer mr-[25px]" @click="toLink('/zzexam/question')">
						<div class="flex">
							<img class="w-[56px] h-[56px] rounded-[28px]" src="@/addon/zzexam/assets/question.png" />
							<div class="ml-[10px]">
								<div>
									<span class="text-[16px] ">题目</span>
								</div>
								<div>
									<span class="text-[20px]">{{ statInfo.count_data.question }}</span>
								</div>
							</div>
						</div>
					</div>
					<div class="flex-1 h-[145px] bg-[var(--el-color-info-light-9)] flex justify-center flex-col items-center cursor-pointer mr-[25px]" @click="toLink('/zzexam/article')">
						<div class="flex">
							<img class="w-[56px] h-[56px] rounded-[28px]" src="@/addon/zzexam/assets/note.png" />
							<div class="ml-[10px]">
								<div>
									<span class="text-[16px] ">知识点</span>
								</div>
								<div>
									<span class="text-[20px]">{{ statInfo.count_data.know }}</span> 
								</div>
							</div>
						</div>
					</div>
					<div class="flex-1 h-[145px] bg-[var(--el-color-info-light-9)] flex justify-center flex-col items-center cursor-pointer mr-[25px]" @click="toLink('/zzexam/article')">
						<div class="flex">
							<img class="w-[56px] h-[56px] rounded-[28px]" src="@/addon/zzexam/assets/article.png" />
							<div class="ml-[10px]">
								<div>
									<span class="text-[16px] ">学习动态</span>
								</div>
								<div>
									<span class="text-[20px]">{{ statInfo.count_data.article }}</span> 
								</div>
							</div>
						</div>
					</div>
					<div class="flex-1 h-[145px] bg-[var(--el-color-info-light-9)] flex justify-center flex-col items-center cursor-pointer mr-[25px]" @click="toLink('/zzexam/article')">
						<div class="flex">
							<img class="w-[56px] h-[56px] rounded-[28px]" src="@/addon/zzexam/assets/notice.png" />
							<div class="ml-[10px]">
								<div>
									<span class="text-[16px] ">公告</span>
								</div>
								<div>
									<span class="text-[20px]">{{ statInfo.count_data.notice }}</span> 
								</div>
							</div>
						</div>
					</div>
                </div>

                <div class="mt-[30px] flex site">
                    <el-card class="box-card !border-none flex-1 profile-data mr-[30px]" shadow="never">
						<div ref="examOrderStat" :style="{ width: '100%', height: '300px' }"></div>
                    </el-card>
                    <el-card class="box-card !border-none flex-1 profile-data" shadow="never">
                        <div ref="vipOrderStat" :style="{ width: '100%', height: '300px' }"></div>
                    </el-card>
                </div>
            </div>
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { ref, watch } from 'vue'
import { t } from '@/lang'
import { getStatInfo } from '@/addon/zzexam/api/stat'
import * as echarts from 'echarts'
import { useRoute, useRouter } from 'vue-router'
import { AnyObject } from '@/types/global'

const loading = ref(true)

const examOrderStat = ref<any>(null)
const vipOrderStat = ref<any>(null)


const statInfo = ref([]);
const getStatInfoFn = async () => {
    statInfo.value = await (await getStatInfo()).data
    loading.value = false
    setTimeout(() => {
        drawChart('')
        drawChartTo('')
    }, 20)
}
getStatInfoFn()

const drawChart = (item:any) => {
	
    let value = statInfo.value.stat_order.exam_order_num
    if (item) value = item
    if (!examOrderStat.value) return
	
    const examOrderStatChart = echarts.init(examOrderStat.value)
    const examOrderStatOption = ref({
        title: {
            text: '付费考试订单'
        },
        legend: {},
        xAxis: {
            data: []
        },
        yAxis: {},
        tooltip: {
            trigger: 'axis'
        },
        series: [
            {
                type: 'line',
                data: []
            }
        ]
    })
    examOrderStatOption.value.xAxis.data = statInfo.value.stat_order.date
    examOrderStatOption.value.series[0].data = value
    examOrderStatChart.setOption(examOrderStatOption.value)
}
const drawChartTo = (item:any) => {
    let valueTo = statInfo.value.stat_order.vip_order_num
    if (item) valueTo = item
    if (!vipOrderStat.value) return
    const vipOrderStatChart = echarts.init(vipOrderStat.value)
    const vipOrderStatOption = ref({
        title: {
            text: '开通VIP订单'
        },
        legend: {},
        xAxis: {
            data: []
        },
        yAxis: {},
        tooltip: {
            trigger: 'axis'
        },
        series: [
            {
                type: 'line',
                data: []
            }
        ]
    })
    vipOrderStatOption.value.xAxis.data = statInfo.value.stat_order.date
    vipOrderStatOption.value.series[0].data = valueTo
    vipOrderStatChart.setOption(vipOrderStatOption.value)
}

const router = useRouter()
const route = useRoute()

/**
 * 链接跳转
 */
const toLink = (link:any) => {
    router.push(link)
}

// 更新时间
const time = ref('')
const nowTime = () => {
    const date = new Date()
    const year = date.getFullYear()
    const month = date.getMonth() + 1
    const day = date.getDate()
    const hh = checkTime(date.getHours())
    const mm = checkTime(date.getMinutes())
    const ss = checkTime(date.getSeconds())
    function checkTime (i:any) {
        if (i < 10) {
            return '0' + i
        }
        return i
    }
    time.value = year + '-' + month + '-' + day + ' ' + hh + ':' + mm + ':' + ss
}
nowTime()

</script>

<style lang="scss" scoped>
    .profile-data {
        background-color: transparent !important;
    }

    :deep(.profile-data .el-card__header) {
        padding: 0 !important;
    }

    :deep(.profile-data .el-card__body) {
        padding: 20px 0 !important;
    }
    .top :deep(.el-col){
        max-width: calc(100% / 5) !important;
    }
</style>
