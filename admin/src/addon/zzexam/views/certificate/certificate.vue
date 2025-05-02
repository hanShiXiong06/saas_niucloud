<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <span class="text-lg">{{pageName}}</span>
               
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                
            </el-card>

            <div class="mt-[10px]">
                <el-table :data="certificateTable.data" size="large" v-loading="certificateTable.loading">
                    <template #empty>
                        <span>{{ !certificateTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column :label="t('memberId')" min-width="170" :show-overflow-tooltip="true">
                         <template #default="{ row }">
                     		 <div class="flex items-center cursor-pointer" v-if="row.member">
                     		     <img class="w-[50px] h-[50px] mr-[10px]" v-if="row.member.headimg" :src="img(row.member.headimg)" alt="">
                     		     <img class="w-[50px] h-[50px] mr-[10px] rounded-full" v-else src="@/app/assets/images/member_head.png" alt="">
                     		     <div class="flex flex flex-col">
                     		        <div>{{ row.member.member_no || '' }}</div>
                     				<div>{{ row.member.nickname || '' }}</div>
                     		     </div>
                     			
                     		 </div>
                          </template>
                    </el-table-column>
                    
                    
                    <el-table-column prop="poster.name" :label="t('证书名称')" min-width="120" :show-overflow-tooltip="true"/>
                    
                   <el-table-column prop="create_time" :label="t('createTime')" min-width="220" :show-overflow-tooltip="true"/>
                   
                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                       <template #default="{ row }">
                           <el-button type="primary" link @click="deleteEvent(row.certificate_id)">{{ t('delete') }}</el-button>
                       </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="certificateTable.page" v-model:page-size="certificateTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="certificateTable.total"
                        @size-change="loadCertificateList()" @current-change="loadCertificateList" />
                </div>
            </div>

            <edit ref="editCertificateDialog" @complete="loadCertificateList" />
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getCertificateList, deleteCertificate } from '@/addon/zzexam/api/certificate'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import Edit from '@/addon/zzexam/views/certificate/components/certificate-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;

let certificateTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam:{
      "exam_name":"",
      "realname":"",
      "mobile":"",
      "status":"",
      "create_time":""
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([])

// 字典数据
    

/**
 * 获取会员证书列表
 */
const loadCertificateList = (page: number = 1) => {
    certificateTable.loading = true
    certificateTable.page = page

    getCertificateList({
        page: certificateTable.page,
        limit: certificateTable.limit,
         ...certificateTable.searchParam
    }).then(res => {
        certificateTable.loading = false
        certificateTable.data = res.data.data
        certificateTable.total = res.data.total
    }).catch(() => {
        certificateTable.loading = false
    })
}
loadCertificateList()

const editCertificateDialog: Record<string, any> | null = ref(null)

/**
 * 添加会员证书
 */
const addEvent = () => {
    editCertificateDialog.value.setFormData()
    editCertificateDialog.value.showDialog = true
}

/**
 * 编辑会员证书
 * @param data
 */
const editEvent = (data: any) => {
    editCertificateDialog.value.setFormData(data)
    editCertificateDialog.value.showDialog = true
}

/**
 * 删除会员证书
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('certificateDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteCertificate(id).then(() => {
            loadCertificateList()
        }).catch(() => {
        })
    })
}

    

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadCertificateList()
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
