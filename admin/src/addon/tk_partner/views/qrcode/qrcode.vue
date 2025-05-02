<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">
                <div style="width: 640px" class="mb-2">
                    <el-alert type="info" title="温馨提示：已导出/已绑定的码导出会自动过滤，如需再次导出请先修改状态" :closable="false" show-icon />
                </div>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="qrcodeTable.searchParam" ref="searchFormRef">

                    <el-form-item :label="t('levelId')" prop="level_id">
                        <el-select class="w-[280px]" v-model="qrcodeTable.searchParam.level_id" clearable
                            :placeholder="t('levelIdPlaceholder')">
                            <el-option v-for="(item, index) in levelIdList" :key="index" :label="item['name']"
                                :value="item['id']" />
                        </el-select>
                    </el-form-item>


                    <!-- <el-form-item :label="t('memberId')" prop="member_id">
                        <el-select class="w-[280px]" v-model="qrcodeTable.searchParam.member_id" clearable
                            :placeholder="t('memberIdPlaceholder')">
                            <el-option v-for="(item, index) in memberIdList" :key="index" :label="item['nickname']"
                                :value="item['member_id']" />
                        </el-select>
                    </el-form-item> -->

                    <!-- <el-form-item :label="t('code')" prop="code">
                        <el-input v-model="qrcodeTable.searchParam.code" :placeholder="t('codePlaceholder')" />
                    </el-form-item> -->
                    <el-form-item :label="t('isBind')" prop="is_bind">
                        <el-select v-model="qrcodeTable.searchParam.is_bind" clearable
                            :placeholder="t('isBindPlaceholder')">
                            <el-option label="全部" value="" />
                            <el-option label="已绑定" value="1" />
                            <el-option label="未绑定" value="0" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('isExport')" prop="is_export">
                        <el-select v-model="qrcodeTable.searchParam.is_export" clearable placeholder="请选择是否导出">
                            <el-option label="全部" value="" />
                            <el-option label="已导出" value="1" />
                            <el-option label="未导出" value="0" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="qrcodeTable.searchParam.create_time" type="datetimerange"
                            format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadQrcodeList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>
            <el-button @click="deleteSelectEvent()">删除选中</el-button>
            <el-button @click="downloadEvent()">下载选中</el-button>
            <el-button type="primary" @click="showDialog = true">
                    生成空码
                </el-button>
            <div class="mt-[10px]">
                <el-table :data="qrcodeTable.data" size="large" v-loading="qrcodeTable.loading"
                    @selection-change="handleSelectionChange">
                    <template #empty>
                        <span>{{ !qrcodeTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <el-table-column type="selection" width="85" />
                    <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="level_id_name" :label="t('levelId')" min-width="120"
                        :show-overflow-tooltip="true" />
                        <el-table-column prop="page" label="页面" min-width="120"
                        :show-overflow-tooltip="true" />

                    <!-- <el-table-column prop="code" :label="t('code')" min-width="120" :show-overflow-tooltip="true" /> -->

                    <el-table-column :label="t('weappQrcode')" width="160" align="left">
                        <template #default="{ row }">
                            <div class="flex flex-col items-center">
                                <el-avatar v-if="row.weapp_qrcode" :src="img(row.weapp_qrcode)" />
                                <el-avatar v-else icon="UserFilled" />
                                <div v-if="row.weapp_qrcode" class="mt-2 flex space-x-1">
                                    <el-button type="primary" size="small" link
                                        @click="downloadImage(row.weapp_qrcode, '小程序码')">
                                        <el-icon>
                                            <Download />
                                        </el-icon>
                                    </el-button>
                                    <el-button type="primary" size="small" link @click="copyImageUrl(row.weapp_qrcode)">
                                        <el-icon>
                                            <CopyDocument />
                                        </el-icon>
                                    </el-button>
                                </div>
                            </div>
                        </template>
                    </el-table-column>
                    <el-table-column :label="t('h5Qrcode')" width="160" align="left">
                        <template #default="{ row }">
                            <div class="flex flex-col items-center">
                                <el-avatar v-if="row.h5_qrcode" :src="img(row.h5_qrcode)" />
                                <el-avatar v-else icon="UserFilled" />
                                <div v-if="row.h5_qrcode" class="mt-2 flex space-x-1">
                                    <el-button type="primary" size="small" link
                                        @click="downloadImage(row.h5_qrcode, 'H5码')">
                                        <el-icon>
                                            <Download />
                                        </el-icon>
                                    </el-button>
                                    <el-button type="primary" size="small" link @click="copyImageUrl(row.h5_qrcode)">
                                        <el-icon>
                                            <CopyDocument />
                                        </el-icon>
                                    </el-button>
                                </div>
                            </div>
                        </template>
                    </el-table-column>

                    <el-table-column prop="is_bind" :label="t('isBind')" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.is_bind" type="success">已绑定</el-tag>
                            <el-tag v-else type="danger">未绑定</el-tag>
                        </template>
                    </el-table-column>

                    <el-table-column prop="is_export" :label="t('isExport')" min-width="120"
                        :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.is_export" type="success">已导出</el-tag>
                            <el-tag v-else type="danger">未导出</el-tag>
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                            <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="qrcodeTable.page" v-model:page-size="qrcodeTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="qrcodeTable.total"
                        @size-change="loadQrcodeList()" @current-change="loadQrcodeList" />
                </div>
            </div>

            <edit ref="editQrcodeDialog" @complete="loadQrcodeList" />
        </el-card>
    </div>
    <el-dialog title="生成空码" v-model="showDialog" width="40%" :close-on-click-modal="false" :loading="isLoading">
        <el-form :model="formData" :rules="formRules" ref="formRef" label-width="120px">
            <el-form-item label="等级" prop="level_id">
                <el-select v-model="formData.level_id" clearable :placeholder="t('levelIdPlaceholder')">
                    <el-option v-for="(item, index) in levelIdList" :key="index" :label="item['name']"
                        :value="item['id']" />
                </el-select>
            </el-form-item>
            <el-form-item label="数量" prop="num">
                <el-input-number type="number" min="1" max="100" v-model="formData.num" clearable placeholder="请输入生成数量"
                    style="width:180px;" />
            </el-form-item>
            <el-form-item label="页面路径" prop="page_value">
        <div>
          <diy-link v-model="formData.page_value" :ignore="['DIY_LINK', 'DIY_JUMP_OTHER_APPLET', 'DIY_MAKE_PHONE_CALL']"
            @confirm="linkselect()" />
        </div>

        <div v-if="formData.page != ''" class="mb-2 pl-2">
          <el-input v-model="formData.page" clearable placeholder="小程序页面路径" class="input-width mt-2" />
        </div>
      </el-form-item>
            <el-form-item>
                <el-button type="primary" :loading="isLoading" @click="submitForm()">{{ isLoading ? '生成中...' :
                    t('confirm')
                }}</el-button>
            </el-form-item>
        </el-form>
    </el-dialog>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getQrcodeList, deleteQrcode, getWithLevelList, getWithMemberList, addQrcode, delselect, downloadQrcode } from '@/addon/tk_partner/api/qrcode'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance, ElMessage } from 'element-plus'
import { Download, CopyDocument } from '@element-plus/icons-vue'
import Edit from '@/addon/tk_partner/views/qrcode/components/qrcode-edit.vue'
import { useRoute } from 'vue-router'
const route = useRoute()
const pageName = route.meta.title;
const linkselect = () => {
  formData.page = formData.page_value.url;
  if (formData.name == "") {
    console.log(formData.page_value);
    formData.name = formData.page_value.title;
  }
};
let qrcodeTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "level_id": "",
        "member_id": "",
        "code": "",
        "is_bind": "",
        "is_export": "",
        "create_time": []
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([]);
const handleSelectionChange = (val: any[]) => {
    selectData.value = val.map((item: any) => item.id);
};
const downloadEvent = async () => {
    if (selectData.value.length > 0) {
        try {
            const res = await downloadQrcode(selectData.value);
            console.log(res);
            const url = img(res.data.url);
            // 在新窗口中打开下载链接
            window.open(url, '_blank');
            ElMessage.success("下载成功");
        } catch (error) {
            console.error('下载失败', error);
            ElMessage.error("下载失败");
        }
    } else {
        ElMessageBox.confirm("请先选择要下载的数据", t("warning"), {
            confirmButtonText: t("confirm"),
            cancelButtonText: t("cancel"),
            type: "warning",
        });
    }
};


const deleteSelectEvent = async () => {
    if (selectData.value.length > 0) {
        delselect(selectData.value).then((res) => {
            loadQrcodeList();
        });
    } else {
        ElMessageBox.confirm("请先选择要删除的数据", t("warning"), {
            confirmButtonText: t("confirm"),
            cancelButtonText: t("cancel"),
            type: "warning",
        });
    }
};

// 字典数据


/**
 * 获取空码列列表
 */
const loadQrcodeList = (page: number = 1) => {
    qrcodeTable.loading = true
    qrcodeTable.page = page

    getQrcodeList({
        page: qrcodeTable.page,
        limit: qrcodeTable.limit,
        ...qrcodeTable.searchParam
    }).then(res => {
        qrcodeTable.loading = false
        qrcodeTable.data = res.data.data
        qrcodeTable.total = res.data.total
    }).catch(() => {
        qrcodeTable.loading = false
    })
}
loadQrcodeList()

const editQrcodeDialog: Record<string, any> | null = ref(null)

/**
 * 添加空码列
 */
const addEvent = () => {
    editQrcodeDialog.value.setFormData()
    editQrcodeDialog.value.showDialog = true
}

/**
 * 编辑空码列
 * @param data
 */
const editEvent = (data: any) => {
    editQrcodeDialog.value.setFormData(data)
    editQrcodeDialog.value.showDialog = true
}

/**
 * 删除空码列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('qrcodeDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteQrcode(id).then(() => {
            loadQrcodeList()
        }).catch(() => {
        })
    })
}


const levelIdList = ref([])
const setLevelIdList = async () => {
    levelIdList.value = await (await getWithLevelList({})).data
}
setLevelIdList()
const memberIdList = ref([])
const setMemberIdList = async () => {
    memberIdList.value = await (await getWithMemberList({})).data
}
setMemberIdList()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadQrcodeList()
}

// 定义 showDialog 变量
const showDialog = ref(false)

// 定义 formData 和 formRules
const formData = reactive({
    level_id: '',
    num: 1,
    page:'',
    page_value:{}
})

const formRules = reactive({
    level_id: [
        { required: true, message: '请选择等级', trigger: 'change' }
    ],
    num: [
        { required: true, message: '请输入生成数量', trigger: 'blur' }
    ]
})

const formRef = ref<FormInstance>()

const isLoading = ref(false)
const isAdding = ref(false)

/**
 * 提交表单
 */
const submitForm = () => {
    formRef.value?.validate((valid) => {
        if (valid) {
            isLoading.value = true
            isAdding.value = true
            addQrcode(formData).then(res => {
                isLoading.value = false
                ElMessageBox.alert('生成成功', '提示', {
                    confirmButtonText: '确定',
                    callback: () => {
                        showDialog.value = false
                        isLoading.value = false
                        isAdding.value = false
                        loadQrcodeList() // 重新加载列表
                    }
                })
            }).catch(() => {
                isLoading.value = false
                isAdding.value = false
            })
        } else {
            console.log('表单验证失败')
        }
    })
}

/**
 * 下载图像
 * @param url 图像URL
 * @param fileName 文件名
 */
const downloadImage = (url: string, fileName: string) => {
    // 在新标签页中打开图像
    const imgUrl = img(url)
    window.open(imgUrl, '_blank')
    ElMessage.success('图像已在新页面打开')
}

/**
 * 复制图像链接
 * @param url 图像URL
 */
const copyImageUrl = (url: string) => {
    const imgUrl = img(url)
    navigator.clipboard.writeText(imgUrl).then(() => {
        ElMessage.success('链接已复制到剪贴板')
    }).catch(() => {
        ElMessage.error('复制失败，请手动复制')
    })
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
