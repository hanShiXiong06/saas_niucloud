<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex justify-between items-center">

                <el-button type="primary" @click="addshow = true">
                    生成卡密
                </el-button>
            </div>

            <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
                <el-form :inline="true" :model="cardTable.searchParam" ref="searchFormRef">
                    <!-- <el-form-item label="会员" prop="member_id">
                        <el-select class="input-width" v-model="cardTable.searchParam.member_id" clearable
                            :placeholder="t('memberIdPlaceholder')">
                            <div class="mt-2 mb-2 ml-4">
                                <el-input @change="change" v-model="keyword" style="width: 200px"
                                    placeholder="搜索会员支持昵称/会员名">
                                    <template #append>搜索 </template></el-input>
</div>
<el-option label="请选择" value=""></el-option>
<el-option v-for="(item, index) in memberIdList" :key="index" :label="item['nickname']" :value="item['member_id']" />
</el-select>
</el-form-item> -->
                    <el-form-item :label="t('cardNum')" prop="card_num">
                        <el-input v-model="cardTable.searchParam.card_num" :placeholder="t('cardNumPlaceholder')" />
                    </el-form-item>
                    <el-form-item :label="t('isUse')" prop="is_use">
                        <el-select class="w-[280px]" v-model="cardTable.searchParam.is_use" clearable
                            placeholder="请选择状态">
                            <el-option label="全部" value="" />
                            <el-option label="未兑换" :value="0" />
                            <el-option label="已兑换" :value="1" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('status')" prop="status">

                        <el-select class="w-[280px]" v-model="cardTable.searchParam.status" clearable
                            placeholder="请选择状态">
                            <el-option label="全部" value="" />
                            <el-option label="已分配" :value="0" />
                            <el-option label="待分配" :value="1" />
                        </el-select>
                    </el-form-item>
                    <el-form-item :label="t('remark')" prop="remark">
                        <el-input v-model="cardTable.searchParam.remark" :placeholder="t('remarkPlaceholder')" />
                    </el-form-item>

                    <el-form-item :label="t('levelId')" prop="level_id">
                        <el-select class="w-[280px]" v-model="cardTable.searchParam.level_id" clearable
                            :placeholder="t('levelIdPlaceholder')">
                            <el-option v-for="(item, index) in levelIdList" :key="index" :label="item['name']"
                                :value="item['id']" />
                        </el-select>
                    </el-form-item>

                    <el-form-item :label="t('createTime')" prop="create_time">
                        <el-date-picker v-model="cardTable.searchParam.create_time" type="datetimerange"
                            format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')"
                            :end-placeholder="t('endDate')" />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" @click="loadCardList()">{{ t('search') }}</el-button>
                        <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
                        <el-button type="primary" @click="exportEvent">{{ t('export') }}</el-button>
                    </el-form-item>
                </el-form>
            </el-card>
            <el-button @click="deleteSelectEvent()">删除选中</el-button>
            <div class="mt-[10px]">
                <el-table :data="cardTable.data" size="large" v-loading="cardTable.loading"   @selection-change="handleSelectionChange">
                    <template #empty>
                        <span>{{ !cardTable.loading ? t('emptyData') : '' }}</span>
                    </template>
                    <!-- <el-table-column prop="member_id_name" :label="t('memberId')" min-width="120"
                        :show-overflow-tooltip="true" /> -->
                        <el-table-column type="selection" width="85" />
                    <el-table-column prop="card_num" :label="t('cardNum')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column prop="is_use" label="兑换状态" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.is_use == 1" type="error">已兑换</el-tag>
                            <el-tag v-if="row.is_use == 0" type="success">未兑换</el-tag>
                        </template>
                    </el-table-column>

                    <el-table-column prop="status" label="状态" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <el-tag v-if="row.status == 0" type="error">已分配</el-tag>
                            <el-tag v-if="row.status == 1" type="success">待分配</el-tag>
                        </template>
                    </el-table-column>

                    <el-table-column prop="remark" :label="t('remark')" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="level_id_name" :label="t('levelId')" min-width="120"
                        :show-overflow-tooltip="true" />

                    <el-table-column :label="t('operation')" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
                            <el-button type="primary" link @click="deleteEvent(row.id)">{{ t('delete') }}</el-button>
                        </template>
                    </el-table-column>

                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="cardTable.page" v-model:page-size="cardTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="cardTable.total"
                        @size-change="loadCardList()" @current-change="loadCardList" />
                </div>
            </div>

            <edit ref="editCardDialog" @complete="loadCardList" />
        </el-card>
        <el-dialog v-model="addshow" title="生成卡密" width="500px">
            <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form"
                v-loading="loading">
                <el-form-item label="生成数量" prop="num">
                    <el-input v-model="formData.num" type="number" min="0" max="500" clearable placeholder="请输入生成数量"
                        class="input-width" />
                </el-form-item>

                <el-form-item :label="t('levelId')" prop="level_id">
                    <el-select class="input-width" v-model="formData.level_id" clearable
                        :placeholder="t('levelIdPlaceholder')">
                        <el-option label="请选择" value=""></el-option>
                        <el-option v-for="(item, index) in levelIdList" :key="index" :label="item['name']"
                            :value="item['id']" />
                    </el-select>
                </el-form-item>

                <!-- <el-form-item label="会员" prop="member_id">
                    <el-select class="input-width" v-model="formData.member_id" clearable
                        :placeholder="t('memberIdPlaceholder')">
                        <div class="mt-2 mb-2 ml-4">
                            <el-input @change="change" v-model="keyword" style="width: 200px"
                                placeholder="搜索会员支持昵称/会员名">
                                <template #append>搜索 </template></el-input>
                        </div>
                        <el-option label="请选择" value=""></el-option>
                        <el-option v-for="(item, index) in memberIdList" :key="index" :label="item['nickname']"
                            :value="item['member_id']" />
                    </el-select>
                </el-form-item> -->

                <el-form-item :label="t('remark')" prop="remark">
                    <el-input v-model="formData.remark" clearable :placeholder="t('remarkPlaceholder')"
                        class="input-width" />
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="addCardEvent()">确认</el-button>
                </el-form-item>
            </el-form>
        </el-dialog>
    </div>
    <export-sure ref="exportSureDialog" :show="flag" type="tk_partner_card" :searchParam="cardTable.searchParam" @close="handleClose" />
  
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { useDictionary } from '@/app/api/dict'
import { getCardList, deleteCard, getWithLevelList, addCard,delselect } from '@/addon/tk_partner/api/card'
import { getWithMemberList } from '@/addon/tk_partner/api/partner'
import { img } from '@/utils/common'
import { ElMessageBox, FormInstance } from 'element-plus'
import Edit from '@/addon/tk_partner/views/card/components/card-edit.vue'
import { useRoute } from 'vue-router'
/**
 * 导出
 */
 const exportSureDialog = ref(null)
const flag = ref(false)
const handleClose = (val) => {
    flag.value = val
}
const exportEvent = () => {
    flag.value = true
}
const change = () => {
    setMemberIdList();
};
const keyword = ref();
const memberIdList = ref([]);
const setMemberIdList = async () => {
    memberIdList.value = await (
        await getWithMemberList({ keyword: keyword.value })
    ).data.data;
};
setMemberIdList();
// 表单数据
interface FormData {
    num: string
    remark: string
    level_id: number | string,
    member_id: 0,
}

const formData = ref<FormData>({
    num: '',
    remark: '',
    level_id: '',
    member_id: 0,
})

// 表单验证规则
const formRules = {
    num: [
        { required: true, message: '请输入生成数量', trigger: 'blur' },
    ],
    level_id: [
        { required: true, message: t('levelIdRequired'), trigger: 'change' }
    ]
}

const loading = ref(false)
const formRef = ref<FormInstance>()

// 添加卡密事件
const addCardEvent = async () => {
    if (!formRef.value) return

    await formRef.value.validate(async (valid: boolean) => {
        if (valid) {
            loading.value = true
            try {
                await addCard({
                    num: formData.value.num,
                    remark: formData.value.remark,
                    level_id: formData.value.level_id,
                    member_id: formData.value.member_id
                })
                addshow.value = false
                resetAddForm()
                loadCardList()
            } catch (error) {
                console.error(error)
            } finally {
                loading.value = false
            }
        }
    })
}

// 重置添加表单
const resetAddForm = () => {
    if (!formRef.value) return
    formRef.value.resetFields()
    formData.value = {
        num: '',
        remark: '',
        level_id: ''
    }
}

const route = useRoute()
const pageName = route.meta.title;
const addshow = ref(false)
let cardTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        "card_num": "",
        "is_use": "",
        "status": "",
        "remark": "",
        "level_id": "",
        "member_id": "",
        "create_time": []
    }
})

const searchFormRef = ref<FormInstance>()

// 选中数据
const selectData = ref<any[]>([]);
const handleSelectionChange = (val) => {
  selectData.value = val.map((item) => item.id);
};
const deleteSelectEvent = async () => {
  if (selectData.value.length > 0) {
    delselect(selectData.value).then((res) => {
      loadCardList();
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
 * 获取店主列列表
 */
const loadCardList = (page: number = 1) => {
    cardTable.loading = true
    cardTable.page = page

    getCardList({
        page: cardTable.page,
        limit: cardTable.limit,
        ...cardTable.searchParam
    }).then(res => {
        cardTable.loading = false
        cardTable.data = res.data.data
        cardTable.total = res.data.total
    }).catch(() => {
        cardTable.loading = false
    })
}
loadCardList()

const editCardDialog: Record<string, any> | null = ref(null)

/**
 * 添加店主列
 */
const addEvent = () => {
    editCardDialog.value.setFormData()
    editCardDialog.value.showDialog = true
}

/**
 * 编辑店主列
 * @param data
 */
const editEvent = (data: any) => {
    editCardDialog.value.setFormData(data)
    editCardDialog.value.showDialog = true
}

/**
 * 删除店主列
 */
const deleteEvent = (id: number) => {
    ElMessageBox.confirm(t('cardDeleteTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning',
        }
    ).then(() => {
        deleteCard(id).then(() => {
            loadCardList()
        }).catch(() => {
        })
    })
}


const levelIdList = ref([])
const setLevelIdList = async () => {
    levelIdList.value = await (await getWithLevelList({})).data
}
setLevelIdList()

const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return
    formEl.resetFields()
    loadCardList()
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
