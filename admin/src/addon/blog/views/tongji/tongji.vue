<template>
    <div v-loading="loading">
        <el-card class="box-card !border-none" shadow="never">
            <div class="p-[30px] box-border border-[1px] border-[var(--el-border-color)] border-solid bg-[var(--el-bg-color)]">
                <el-card class="box-card !border-none profile-data" shadow="never">
                    <template #header>
                        <div class="card-header mb-[10px] w-full">
                            <span class="text-[18px]">{{ t("数据统计") }}</span>
                            <span class="text-[12px] text-[#666] leading-[16px] ml-[18px]">更新时间 : </span>
                            <span class="text-[12px] text-[#666] leading-[16px]">{{ time }}</span>
                        </div>
                    </template>

                    <el-row :gutter="12" class="mt-[10px] top">
                        <el-col style="">
                            <div @click="toHref('/blog/tie','1')" class="cursor-pointer" style="background: #23c5c7;">
                                <el-statistic :value="statInfo.today_data.views_num0" >
                                    <template #title>
                                        <div class="text-[14px] mb-[9px] text-[#fff]">
                                            {{ t("浏览次数") }}
                                        </div>
                                    </template>
                                </el-statistic>
                            </div>
                        </el-col>
                        <el-col>
                            <div @click="toHref('/blog/tie','1')" class="cursor-pointer" style="background: #519dfe;">
                                <el-statistic :value="statInfo.today_data.zan_num0" >
                                    <template #title>
                                        <div class="text-[14px] mb-[9px] text-[#fff]">
                                            {{ t("点赞次数") }}
                                        </div>
                                    </template>
                                </el-statistic>
                            </div>
                        </el-col>
                        <el-col>
                            <div @click="toHref('/blog/tie','2')" class="cursor-pointer" style="background: #ff8585;">
                                <el-statistic :value="statInfo.today_data.tie_num0">
                                    <template #title>
                                        <div class="text-[14px] mb-[9px] text-[#fff]">
                                            {{ t("帖子数量") }}
                                        </div>
                                    </template>
                                </el-statistic>
                            </div>
                        </el-col>
                       <el-col>
                           <div @click="toHref('/blog/tie','2')" class="cursor-pointer" style="background: #3fb84e;">
                               <el-statistic :value="statInfo.today_data.ping_num0">
                                   <template #title>
                                       <div class="text-[14px] mb-[9px] text-[#fff]">
                                           {{ t("评论回复次数") }}
                                       </div>
                                   </template>
                               </el-statistic>
                           </div>
                       </el-col>
                    </el-row>
                </el-card>
                
               

                <div class="mt-[20px] flex site">
                    <el-card class="box-card !border-none flex-1 profile-data mr-[30px]" shadow="never">
						
                        <template #header>
                            <div class="card-header mb-[20px]" style="display: flex;justify-content: space-between;width: 100%;">
                                <div class="text-[18px]">{{ t("趋势图") }}</div>
								<el-form :inline="true" :model="tongjiTable.searchParam" ref="searchFormRef">
								
									<el-form-item :label="t('搜索时间')" prop="adddate">
										<el-date-picker v-model="tongjiTable.searchParam.adddate" type="datetimerange"
											format="YYYY-MM-DD" :start-placeholder="t('请选择开始时间')"
											:end-placeholder="t('请选择结束时间')" />
									</el-form-item>
								
									<el-form-item>
										<el-button type="primary" @click="getStatInfoFn()">{{ t('search') }}</el-button>
										<el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
									</el-form-item>
								</el-form>
                            </div>
                        </template>
                        <div ref="newSiteStat" class="mt-[20px]" :style="{ width: '100%', height: '300px' }"></div>
                    </el-card>
                   <!-- <el-card class="box-card !border-none flex-1 profile-data" shadow="never">
                        <template #header>
                            <div class="card-header mb-[20px]">
                                <span class="text-[18px]">{{ t("addUser") }}</span>
                            </div>
                        </template>
                        <div ref="addUser" class="mt-[20px]" :style="{ width: '100%', height: '300px' }"></div>
                    </el-card> -->
                </div>
            </div>
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { ref, watch, reactive} from 'vue'
import { t } from '@/lang'
import { getStatInfo } from '@/addon/blog/api/config'
import * as echarts from 'echarts'
import { getFrameworkNewVersion } from '@/app/api/module'
import { useRoute, useRouter } from 'vue-router'
import { AnyObject } from '@/types/global'
import useStyleStore from '@/stores/modules/style'

const loading = ref(true)
const newSiteStat = ref<any>(null)
const addUser = ref<any>(null)
const styleStore = useStyleStore()

interface NewVersion{
    last_version: string
}
interface StatInfo {
    today_data: AnyObject,
    system: AnyObject,
    version: AnyObject,
    about: any,
    site_stat: AnyObject,
    site_group_stat: AnyObject,
    member_count_stat: AnyObject,
    app: AnyObject
}

const newVersion = ref<NewVersion>({
    last_version: ''
})

getFrameworkNewVersion().then(({ data }) => {
    newVersion.value = data
})

const statInfo = ref<StatInfo>({
    today_data: {},
    system: {},
    version: {},
    about: [],
    member_count_stat: {},
    site_stat: {},
    site_group_stat: {},
    app: {}
})
let tongjiTable = reactive({
		page: 1,
		limit: 10,
		total: 0,
		loading: true,
		data: [],
		searchParam: {
			"name": "",
			"status": "",
			"adddate": []
		}
	})
	const resetForm = (formEl : FormInstance | undefined) => {
		if (!formEl) return
		formEl.resetFields()
		getStatInfoFn()
	}
	
	
const getStatInfoFn = async (id: number = 0) => {
	console.log(tongjiTable.searchParam)
    statInfo.value = await (await getStatInfo({
		...tongjiTable.searchParam
	})).data
    loading.value = false
    setTimeout(() => {
        drawChart()
    }, 20)
}
 getStatInfoFn()

// 绘制折线图
const drawChart = () => {
    // 新增站点
    const newSiteStatChart = echarts.init(newSiteStat.value)
    const newSiteStatOption = ref({
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
                name: t('浏览次数'),
                type: 'line',
                data: []
            }, {
                name: t('点赞次数'),
                type: 'line',
                data: []
            }, {
                name: t('帖子数量'),
                type: 'line',
                data: []
            }, {
                name: t('评论回复次数'),
                type: 'line',
                data: []
            }
        ]
    })
    newSiteStatOption.value.xAxis.data = statInfo.value.site_stat.date
    newSiteStatOption.value.series[0].data = statInfo.value.site_stat.value
    newSiteStatOption.value.series[1].data = statInfo.value.site_stat.value1
    newSiteStatOption.value.series[2].data = statInfo.value.site_stat.value2
    newSiteStatOption.value.series[3].data = statInfo.value.site_stat.value3
    newSiteStatChart.setOption(newSiteStatOption.value)

    // 新增用户
    // const newUserChart = echarts.init(addUser.value)
    // const newUserOption:AnyObject = ref({
    //     legend: {},
    //     xAxis: {
    //         data: []
    //     },
    //     yAxis: {},
    //     tooltip: {
    //         trigger: 'axis'
    //     },
    //     series: [
    //         {
    //             name: t('addUser'),
    //             type: 'line',
    //             data: []
    //         }
    //     ]
    // })
    // newUserOption.value.xAxis.data = statInfo.value.member_count_stat.date
    // newUserOption.value.series[0].data = statInfo.value.member_count_stat.value
    // newUserChart.setOption(newUserOption.value)

    window.addEventListener('resize', () => {
        // 页面大小变化后Echarts也更改大小
        newSiteStatChart.resize()
        newUserChart.resize()
    })
}

const router = useRouter()
const route = useRoute()
if (route.path == '/admin/index') {
    styleStore.changeStyle()
}
watch(() => route.path, (newval, oldval) => {
    if (newval !== '/admin/index') {
        styleStore.changeBlack()
    }
})

/**
 * 链接跳转
 */
const toLink = (link:any) => {
    router.push(link)
}
const toHref = (url:any, id:any) => {
    router.push({
        path: url,
        query: { id }
    })
}
const toApplication = () => {
    window.open('https://www.niucloud.com/app')
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
        max-width: calc(100% / 4) !important;
    }
	.cursor-pointer{
		background-color: #f5f5f5;padding:15px 20px;border-radius: 5px;flex:1;color:#fff;
	}
	:deep(.el-statistic__number) {
	    color: #fff !important;
	}
</style>
