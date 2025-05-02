<template>
    <div class="main-container">
        <div class="detail-head">
            <div class="left cursor-pointer flex items-center" @click="back()">
                <span class="iconfont iconxiangzuojiantou !text-xs"></span>
                <span class="ml-[1px]">{{ t('returnToPreviousPage') }}</span>
            </div>
            <span class="adorn">|</span>
            <span class="right font-medium">{{ pageName }}</span>
        </div>
        <el-card class="box-card !border-none !mb-16" shadow="never">
            <el-form :model="formData" label-width="100px" ref="formRef" :rules="formRules" class="page-form">

                <!-- 基本设置卡片 -->
                <div class="section-card mb-6">
                    <div class="section-header">
                        <div class="flex items-center">
                            <div class="section-icon"><i class="el-icon-setting"></i></div>
                            <h3 class="section-title">基本设置</h3>
                        </div>
                    </div>
                    <div class="section-body p-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-4">
                            <el-form-item :label="t('type')" v-if="formData.id == 0" prop="type"
                                class="col-span-1 md:col-span-2">
                                <el-select v-model="formData.type" placeholder="请选择活动类型" class="input-width"
                                    @change="handleTypeChange">
                                    <block v-if="actType" v-for="(item, index) in actType" :key="index">
                                        <el-option v-if="index !== 'api'" :label="item" :value="index" />
                                    </block>

                                </el-select>
                                <div class="text-xs text-gray-400 ml-2">本地类型推广参数自定义，小程序类型将支持直接跳转小程序进行做任务</div>
                            </el-form-item>
                            <el-form-item :label="t('status')" prop="status">
                                <el-radio-group v-model="formData.status" class="mt-2">
                                    <el-radio-button :label="1">上架</el-radio-button>
                                    <el-radio-button :label="0">下架</el-radio-button>
                                </el-radio-group>
                            </el-form-item>

                            <el-form-item :label="t('simpleDescription')">
                                <el-input v-model="formData.simpleDescription" clearable
                                    :placeholder="t('simpleDescriptionPlaceholder')" class="input-width" />
                            </el-form-item>

                            <el-form-item :label="t('fromId')" v-if="formData.type != 'api'" prop="form_id"
                                class="col-span-1 md:col-span-2">
                                <el-select class="input-width" v-model="formData.form_id" clearable
                                    :placeholder="t('fromIdPlaceholder')">
                                    <el-option label="请选择" value=""></el-option>
                                    <el-option v-for="(item, index) in fromIdList" :key="index"
                                        :label="item['page_title']" :value="item['form_id']" />
                                </el-select>
                            </el-form-item>

                            <!-- <el-form-item :label="t('startTime')" class="input-width">
                                <el-date-picker class="!w-full" v-model="formData.start_time" clearable type="datetime"
                                    value-format="YYYY-MM-DD HH:mm:ss" :placeholder="t('startTimePlaceholder')">
                                </el-date-picker>
                            </el-form-item>

                            <el-form-item :label="t('endTime')" class="input-width">
                                <el-date-picker class="!w-full" v-model="formData.end_time" clearable type="datetime"
                                    value-format="YYYY-MM-DD HH:mm:ss" :placeholder="t('endTimePlaceholder')">
                                </el-date-picker>
                            </el-form-item> -->

                            <el-form-item :label="t('type')" v-if="formData.id > 0" class="col-span-1 md:col-span-2">
                                <el-tag type="success" v-if="formData.type == 'api'" class="text-sm">{{
                                    formData.type_name }}</el-tag>
                                <el-tag type="primary" v-else-if="formData.type == 'weapp'" class="text-sm">{{
                                    formData.type_name }}</el-tag>
                                <el-tag v-else class="text-sm">{{ formData.type_name }}</el-tag>
                            </el-form-item>

                            <el-form-item :label="t('actId')" v-if="formData.id > 0" class="col-span-1 md:col-span-2">
                                <el-input disabled v-model="formData.act_id" clearable
                                    :placeholder="t('actIdPlaceholder')" class="input-width" />
                            </el-form-item>
                            <el-form-item v-if="formData.type == 'system'" label="选择推广链接">
                                <diy-link v-model="formData.system_info" />
                            </el-form-item>
                            <el-form-item v-if="formData.type == 'weapp'" label="小程序配置"
                                class="col-span-1 md:col-span-2">
                                <div
                                    class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-4 bg-gray-50 p-4 rounded-lg border border-gray-200">
                                    <div class="col-span-1">
                                        <div class="mb-4">
                                            <div class="text-sm font-medium text-gray-700 mb-2">AppID</div>
                                            <el-input v-model="formData.weapp_info.appid" clearable
                                                placeholder="请输入小程序AppID" class="w-full" />
                                        </div>
                                        <div class="mb-4">
                                            <div class="text-sm font-medium text-gray-700 mb-2">页面路径</div>
                                            <el-input v-model="formData.weapp_info.page" placeholder="请输入小程序页面路径"
                                                class="w-full" />
                                        </div>
                                        <div>
                                            <div class="text-sm font-medium text-gray-700 mb-2">短链接</div>
                                            <el-input v-model="formData.weapp_info.shortlink" placeholder="请输入小程序短链接"
                                                class="w-full" />
                                        </div>
                                    </div>
                                    <div
                                        class="col-span-1 flex flex-col items-center justify-center bg-white p-4 rounded-lg border border-gray-100">
                                        <div class="text-sm font-medium text-gray-700 mb-4">小程序二维码</div>
                                        <upload-image v-model="formData.weapp_info.qrcode" />
                                        <div class="text-xs text-gray-400 mt-2">上传小程序码图片</div>
                                    </div>
                                </div>
                            </el-form-item>
                        </div>
                    </div>
                </div>

                <!-- 活动内容卡片 -->
                <div class="section-card mb-6">
                    <div class="section-header">
                        <div class="flex items-center">
                            <div class="section-icon"><i class="el-icon-document"></i></div>
                            <h3 class="section-title">活动内容</h3>
                        </div>
                    </div>
                    <div class="section-body p-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-4">
                            <el-form-item :label="t('title')" prop="title" class="col-span-1 md:col-span-2">
                                <el-input v-model="formData.title" clearable :placeholder="t('titlePlaceholder')"
                                    class="input-width" />
                            </el-form-item>

                            <el-form-item :label="t('itemPic')" prop="itemPic" class="col-span-1 md:col-span-2">
                                <upload-image v-model="formData.itemPic" />
                                <div class="text-xs text-gray-400 mt-1">主图</div>
                            </el-form-item>

                            <el-form-item :label="t('minMoney')" prop="minMoney">
                                <el-input-number min="0" v-model="formData.minMoney" clearable
                                    :placeholder="t('minMoneyPlaceholder')" class="!w-full" />
                            </el-form-item>

                            <el-form-item :label="t('maxMoney')" prop="maxMoney">
                                <el-input-number min="0" v-model="formData.maxMoney" clearable
                                    :placeholder="t('maxMoneyPlaceholder')" class="!w-full" />
                            </el-form-item>

                            <el-form-item :label="t('labelText')" prop="labelText" class="col-span-1 md:col-span-2">
                                <el-input v-model="formData.labelText" clearable
                                    :placeholder="t('labelTextPlaceholder')" class="input-width" />
                                <div class="text-xs text-gray-400 mt-1">用英文','隔开，如高佣,地推</div>
                            </el-form-item>
                        </div>
                    </div>
                </div>

                <!-- 推广参数卡片 -->
                <div class="section-card mb-6">
                    <div class="section-header">
                        <div class="flex items-center">
                            <div class="section-icon"><i class="el-icon-share"></i></div>
                            <h3 class="section-title">推广参数</h3>
                        </div>
                    </div>
                    <div class="section-body p-6">
                        <el-form-item label="" prop="extraData">
                            <div class="flex items-center mb-3">

                                <span class="text-xs text-gray-400 ml-2">自定义推广参数，需配合相关介绍教程使用</span>

                                <el-button type="primary" @click="addExtraData" size="small"
                                    class="!flex !items-center ml-8">
                                    <i class="el-icon-plus mr-1"></i>添加
                                </el-button>
                            </div>
                            <el-table :data="formData.extra_data" border class="w-full">
                                <el-table-column label="名称" prop="name" min-width="150" />
                                <el-table-column label="类型" prop="type" min-width="100">
                                    <template #default="scope">
                                        <el-tag v-if="scope.row.type === 'text'" type="info" effect="plain"
                                            size="small">文本</el-tag>
                                        <el-tag v-else-if="scope.row.type === 'image'" type="success" effect="plain"
                                            size="small">图像</el-tag>
                                        <el-tag v-else-if="scope.row.type === 'rich_text'" type="warning" effect="plain"
                                            size="small">富文本</el-tag>
                                        <el-tag v-else-if="scope.row.type === 'url'" type="primary" effect="plain"
                                            size="small">网址链接</el-tag>
                                        <el-tag v-else type="info" effect="plain" size="small">文本</el-tag>
                                    </template>
                                </el-table-column>
                                <el-table-column label="值" prop="value" min-width="300">
                                    <template #default="scope">
                                        <span v-if="scope.row.type === 'text' || !scope.row.type">{{ scope.row.value
                                            }}</span>
                                        <el-image v-else-if="scope.row.type === 'image'" :src="scope.row.value"
                                            fit="cover" class="w-20 h-20" :preview-src-list="[scope.row.value]">
                                        </el-image>
                                        <div v-else-if="scope.row.type === 'rich_text'" v-html="scope.row.value"
                                            class="rich-text-preview"></div>
                                        <el-link v-else-if="scope.row.type === 'url'" type="primary"
                                            :href="scope.row.value" target="_blank" class="url-link">
                                            {{ scope.row.value }}
                                            <i class="el-icon-link ml-1"></i>
                                        </el-link>
                                    </template>
                                </el-table-column>
                                <el-table-column label="操作" width="160">
                                    <template #default="scope">
                                        <el-button type="primary" link @click="editExtraData(scope.row)">编辑</el-button>
                                        <el-button v-if="formData.type !== 'weapp'" type="danger" link
                                            @click="deleteExtraData(scope.row)">删除</el-button>
                                    </template>
                                </el-table-column>
                            </el-table>
                        </el-form-item>
                    </div>
                </div>

                <!-- 详细描述信息卡片 -->
                <div class="section-card mb-6">
                    <div class="section-header">
                        <div class="flex items-center">
                            <div class="section-icon"><i class="el-icon-tickets"></i></div>
                            <h3 class="section-title">详细描述信息</h3>
                        </div>
                    </div>
                    <div class="section-body p-6">
                        <el-form-item :label="t('settlementDesc')" prop="settlementDesc" class="mb-8">
                            <div class="border border-gray-200 rounded-md overflow-hidden h-[300px]">
                                <div class="bg-gray-50 px-4 py-2 border-b border-gray-200 flex items-center">
                                    <i class="el-icon-money mr-2 text-gray-500"></i>
                                    <span class="text-sm text-gray-700 font-medium">结算说明</span>
                                </div>
                                <editor v-model="formData.settlementDesc" class="min-h-[100px]" />
                            </div>
                        </el-form-item>

                        <el-form-item :label="t('projectDesc')" prop="projectDesc" class="mb-8">
                            <div class="border border-gray-200 rounded-md overflow-hidden h-[300px]">
                                <div class="bg-gray-50 px-4 py-2 border-b border-gray-200 flex items-center">
                                    <i class="el-icon-info mr-2 text-gray-500"></i>
                                    <span class="text-sm text-gray-700 font-medium">项目说明</span>
                                </div>
                                <editor v-model="formData.projectDesc" class="min-h-[200px]" />
                            </div>
                        </el-form-item>

                        <el-form-item :label="t('promotionDesc')" prop="promotionDesc" class="mb-8">
                            <div class="border border-gray-200 rounded-md overflow-hidden h-[300px]">
                                <div class="bg-gray-50 px-4 py-2 border-b border-gray-200 flex items-center">
                                    <i class="el-icon-promotion mr-2 text-gray-500"></i>
                                    <span class="text-sm text-gray-700 font-medium">推广说明</span>
                                </div>
                                <editor v-model="formData.promotionDesc" class="min-h-[200px]" />
                            </div>
                        </el-form-item>
                    </div>
                </div>
            </el-form>
        </el-card>

        <!-- 悬浮可拖拽按钮 -->
        <div class="float-action-btns" ref="dragEl" :style="{ top: btnPos.y + 'px', right: btnPos.x + 'px' }"
            @mousedown="startDrag">
            <div class="action-btns-wrapper">
                <el-button type="primary" @click="onSave(formRef)" :loading="loading" size="large" class="action-btn">
                    <i class="el-icon-check mr-1"></i>{{ t('save') }}
                </el-button>
                <el-button @click="back()" size="large" class="action-btn">
                    <i class="el-icon-close mr-1"></i>{{ t('cancel') }}
                </el-button>
                <div class="drag-handle">
                    <i class="el-icon-rank"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- 额外数据弹窗 -->
    <el-dialog v-model="extraDataDialogVisible" :title="isEditMode ? '编辑推广参数' : '添加推广参数'" width="600px">
        <el-form :model="extraData" label-width="80px">
            <el-form-item label="名称" required>
                <el-select v-if="formData.type === 'weapp'" v-model="extraData.name" placeholder="请选择参数名称">
                    <el-option label="appid" value="appid" />
                    <el-option label="page" value="page" />
                    <el-option label="shorturl" value="shorturl" />
                </el-select>
                <el-input v-else v-model="extraData.name" placeholder="请输入名称" />
            </el-form-item>

            <el-form-item label="参数类型" required v-if="formData.type !== 'weapp'">
                <el-radio-group v-model="extraData.type">
                    <el-radio-button label="text">文本</el-radio-button>
                    <el-radio-button label="image">图像</el-radio-button>
                    <el-radio-button label="rich_text">富文本</el-radio-button>
                    <el-radio-button label="url">网址链接</el-radio-button>
                </el-radio-group>
            </el-form-item>

            <el-form-item label="值" required>
                <!-- 文本类型 -->
                <el-input v-if="extraData.type === 'text' || !extraData.type || formData.type === 'weapp'"
                    v-model="extraData.value" placeholder="请输入值" />

                <!-- 图像类型 -->
                <div v-else-if="extraData.type === 'image'" class="w-full">
                    <upload-image v-model="extraData.value" />
                    <div class="text-xs text-gray-400 mt-1">请上传图片</div>
                </div>

                <!-- 富文本类型 -->
                <div v-else-if="extraData.type === 'rich_text'"
                    class="border border-gray-200 rounded-md overflow-hidden">
                    <div class="bg-gray-50 px-4 py-2 border-b border-gray-200 flex items-center">
                        <i class="el-icon-edit mr-2 text-gray-500"></i>
                        <span class="text-sm text-gray-700 font-medium">富文本编辑</span>
                    </div>
                    <editor v-model="extraData.value" class="min-h-[200px]" />
                </div>

                <!-- 网址链接类型 -->
                <div v-else-if="extraData.type === 'url'" class="w-full">
                    <el-input v-model="extraData.value" placeholder="请输入完整网址，例如：https://www.example.com" class="w-full">
                        <template #prepend>
                            <div class="w-[70px] text-center">URL</div>
                        </template>
                        <template #append>
                            <el-button @click="previewUrl" :disabled="!isValidUrl(extraData.value)">
                                <i class="el-icon-view mr-1"></i>预览
                            </el-button>
                        </template>
                    </el-input>
                    <div class="text-xs text-gray-400 mt-1">请输入有效的URL地址，包含http://或https://前缀</div>
                </div>
            </el-form-item>
        </el-form>
        <template #footer>
            <span class="dialog-footer">
                <el-button @click="extraDataDialogVisible = false">取消</el-button>
                <el-button type="primary" @click="confirmAddExtraData">确定</el-button>
            </span>
        </template>
    </el-dialog>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, onMounted, onBeforeUnmount } from 'vue'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import { getActInfo, addAct, editAct, getWithMemberList, getWithDiyFormList, getActType } from '@/addon/tk_cpa/api/act';
import { useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
const actType = ref()
getActType().then((res: any) => {
    actType.value = res.data
})
const route = useRoute()
const id: number = parseInt(route.query.id as string || '0');
const loading = ref(false)
const pageName = route.meta.title

// 拖拽相关状态
const dragEl = ref<HTMLElement | null>(null)
const isDragging = ref(false)
const startPos = reactive({ x: 0, y: 0 })
const btnPos = reactive({ x: 20, y: 100 }) // 初始位置

// 开始拖拽
const startDrag = (e: MouseEvent) => {
    // 只有点击拖拽手柄时才能拖动
    if (!(e.target as HTMLElement).closest('.drag-handle')) return

    isDragging.value = true
    startPos.x = e.clientX
    startPos.y = e.clientY

    // 记住当前的按钮位置，以便计算偏移量
    const elRect = dragEl.value?.getBoundingClientRect()
    if (elRect) {
        // 记录初始位置，以便拖动时计算偏移
        startPos.elRight = window.innerWidth - elRect.right
        startPos.elTop = elRect.top
    }

    e.preventDefault()
}

// 拖拽移动
const onDrag = (e: MouseEvent) => {
    if (!isDragging.value) return

    const dx = startPos.x - e.clientX
    const dy = e.clientY - startPos.y

    // 更新位置
    btnPos.x = Math.max(10, startPos.elRight + dx)
    btnPos.y = Math.max(10, startPos.elTop + dy)
}

// 停止拖拽
const stopDrag = () => {
    isDragging.value = false
}

// 挂载全局事件监听
onMounted(() => {
    window.addEventListener('mousemove', onDrag)
    window.addEventListener('mouseup', stopDrag)
})

// 卸载前移除事件监听
onBeforeUnmount(() => {
    window.removeEventListener('mousemove', onDrag)
    window.removeEventListener('mouseup', stopDrag)
})

const extraDataDialogVisible = ref(false)
const isEditMode = ref(false)
const editIndex = ref(-1)
const extraData = ref({
    name: '',
    value: '',
    type: 'text'
})

/**
 * 添加额外数据
 */
const addExtraData = () => {
    isEditMode.value = false
    extraData.value = { name: '', value: '', type: 'text' }

    extraDataDialogVisible.value = true
}

/**
 * 验证URL是否有效
 */
const isValidUrl = (url: string): boolean => {
    if (!url) return false;

    try {
        new URL(url);
        return true;
    } catch (e) {
        return false;
    }
}

/**
 * 预览URL
 */
const previewUrl = () => {
    if (isValidUrl(extraData.value.value)) {
        window.open(extraData.value.value, '_blank');
    } else {
        ElMessage.warning('请输入有效的URL地址');
    }
}

/**
 * 编辑额外数据
 */
const editExtraData = (row: any) => {
    isEditMode.value = true
    extraData.value = { ...row }
    editIndex.value = formData.extra_data.findIndex((item: any) => item.name === row.name && item.value === row.value)
    extraDataDialogVisible.value = true
}

/**
 * 确认添加/编辑额外数据
 */
const confirmAddExtraData = () => {
    if (!extraData.value.name || !extraData.value.value) {
        ElMessage.warning('名称和值不能为空')
        return
    }

    if (!formData.extra_data) {
        formData.extra_data = []
    }


    if (isEditMode.value && editIndex.value !== -1) {
        // 编辑模式
        formData.extra_data[editIndex.value] = {
            name: extraData.value.name,
            value: extraData.value.value,
            type: extraData.value.type
        }
        ElMessage.success('修改成功')
    } else {
        // 添加模式
        formData.extra_data.push({
            name: extraData.value.name,
            value: extraData.value.value,
            type: extraData.value.type
        })
        ElMessage.success('添加成功')
    }

    extraDataDialogVisible.value = false
}

/**
 * 删除额外数据
 */
const deleteExtraData = (row: any) => {

    ElMessageBox.confirm('确定要删除该项吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        const index = formData.extra_data.findIndex((item: any) => item.name === row.name && item.value === row.value)
        if (index !== -1) {
            formData.extra_data.splice(index, 1)
            ElMessage.success('删除成功')
        }
    }).catch(() => { })
}

/**
 * 表单数据
 */
const initialFormData = {
    id: 0,
    member_id: '',
    type: '',
    type_name: '',
    act_id: 0,
    title: '',
    itemPic: '',
    minMoney: '',
    maxMoney: '',
    labelText: '',
    settlementDesc: '',
    projectDesc: '',
    promotionDesc: '',
    status: 0,
    simpleDescription: '',
    form_id: '',
    is_audit: 0,
    start_time: '',
    end_time: '',
    extra_data: [],
    weapp_info: {
        appid: '',
        page: '',
        shortlink: '',
        qrcode: ''
    },
    system_info: {
        name: '',
        url: ''
    }
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const setFormData = async (id: number = 0) => {
    Object.assign(formData, initialFormData)
    const data = await (await getActInfo(id)).data
    Object.keys(formData).forEach((key: string) => {
        if (data[key] != undefined) formData[key] = data[key]
    })
}
if (id) setFormData(id);

const formRef = ref<FormInstance>()
// 选中数据
const selectData = ref<any[]>([])

// 字典数据



const memberIdList = ref([] as any[])
const setMemberIdList = async () => {
    memberIdList.value = await (await getWithMemberList({})).data
}
setMemberIdList()
const fromIdList = ref([] as any[])
const setFromIdList = async () => {
    fromIdList.value = await (await getWithDiyFormList({})).data
}
setFromIdList()
// 表单验证规则
const formRules = computed(() => {
    return {
        title: [
            { required: true, message: t('titlePlaceholder'), trigger: 'blur' },
        ],
        itemPic: [
            { required: true, message: t('itemPicPlaceholder'), trigger: 'blur' },
        ],
        minMoney: [
            { required: true, message: t('minMoneyPlaceholder'), trigger: 'blur' },
        ],
        maxMoney: [
            { required: true, message: t('maxMoneyPlaceholder'), trigger: 'blur' },
        ],
        labelText: [
            { required: true, message: t('labelTextPlaceholder'), trigger: 'blur' },
        ],
        settlementDesc: [
            { required: true, message: t('settlementDescPlaceholder'), trigger: 'blur' },
        ],
        projectDesc: [
            { required: true, message: t('projectDescPlaceholder'), trigger: 'blur' },
        ],
        promotionDesc: [
            { required: true, message: t('promotionDescPlaceholder'), trigger: 'blur' },
        ],
        status: [
            { required: true, message: t('statusPlaceholder'), trigger: 'blur' },
        ],
        type: [
            { required: formData.id === 0, message: '请选择活动类型', trigger: 'change' },
        ],
        form_id: [
            { required: formData.id === 0, message: t('fromIdPlaceholder'), trigger: 'blur' },
        ],
        start_time: [
            { required: true, message: t('startTimePlaceholder'), trigger: 'blur' },
        ],
        end_time: [
            { required: true, message: t('endTimePlaceholder'), trigger: 'blur' },
        ],
        form_id: [
            { required: true, message: '请关联表单', trigger: 'blur' },
        ]
    }
})

const onSave = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    await formEl.validate(async (valid) => {
        if (valid) {
            // 验证小程序参数
            if (!validateWeappParams()) {
                return
            }

            loading.value = true
            let data = formData

            const save = id ? editAct : addAct
            save(data).then(res => {
                loading.value = false
                history.back()
            }).catch(err => {
                loading.value = false
            })
        }
    })
}

// 验证手机号格式
const mobileVerify = (rule: any, value: any, callback: any) => {
    if (value && !/^1[3-9]\d{9}$/.test(value)) {
        callback(new Error(t('generateMobile')))
    } else {
        callback()
    }
}

// 验证身份证号
const idCardVerify = (rule: any, value: any, callback: any) => {
    if (value && !/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/.test(value)) {
        callback(new Error(t('generateIdCard')))
    } else {
        callback()
    }
}

// 验证邮箱号
const emailVerify = (rule: any, value: any, callback: any) => {
    if (value && !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test(value)) {
        callback(new Error(t('generateEmail')))
    } else {
        callback()
    }
}


// 验证请输入整数
const numberVerify = (rule: any, value: any, callback: any) => {
    if (!Number.isInteger(value)) {
        callback(new Error(t('generateNumber')))
    } else {
        callback()
    }
}
const back = () => {
    history.back()
}

const handleTypeChange = () => {
    // 当活动类型发生变化时，初始化默认的extra_data
    formData.extra_data = []

    // 当选择小程序类型时，初始化weapp_info
    if (formData.type === 'weapp') {
        formData.weapp_info = {
            appid: '',
            page: '',
            shortlink: '',
            qrcode: ''
        }
    }
}

// 保存前验证小程序参数
const validateWeappParams = () => {
    if (formData.type === 'weapp') {
        // 验证AppID是否填写
        if (!formData.weapp_info.appid) {
            ElMessage.warning('请填写小程序AppID');
            return false;
        }

        // 验证页面路径是否填写
        if (!formData.weapp_info.page) {
            ElMessage.warning('请填写小程序页面路径');
            return false;
        }

        // 验证短链接是否填写
        if (!formData.weapp_info.shortlink) {
            ElMessage.warning('请填写小程序短链接');
            return false;
        }

        // 验证二维码是否上传
        if (!formData.weapp_info.qrcode) {
            ElMessage.warning('请上传小程序二维码');
            return false;
        }
    }
    return true;
}
</script>

<style lang="scss" scoped>
.input-width {
    width: 100%;
    max-width: 500px;
}

.main-container {
    position: relative;
    z-index: 1;
}

.detail-head {
    display: flex;
    align-items: center;
    height: 54px;
    padding: 0 24px;
    margin-bottom: 20px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);

    .left {
        color: var(--el-color-primary);
        transition: all 0.2s;
        font-weight: 500;

        &:hover {
            opacity: 0.8;
        }
    }

    .adorn {
        color: #eaeaea;
        margin: 0 16px;
    }

    .right {
        color: #303133;
        font-weight: 600;
    }
}

.fixed-footer-wrap {
    height: 70px;
}

.fixed-footer {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    z-index: 1;
    padding: 14px 20px;
    background-color: #fff;
    box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.08);
    display: flex;
    justify-content: center;
    align-items: center;

    .footer-content {
        display: flex;
        gap: 16px;
        justify-content: center;
        width: 100%;
        max-width: 1200px;
    }
}

:deep(.el-form-item__label) {
    font-weight: 500;
    color: #333;
}

:deep(.el-card__body) {
    padding: 24px;
}

:deep(.page-form) {
    max-width: 1200px;
    margin: 0 auto;
}

:deep(.el-radio-button__inner) {
    padding: 10px 24px;
}

// 新增的样式
.section-card {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.02);
    border: 1px solid #edf2f7;
    overflow: hidden;
}

.section-header {
    background-color: #f9fafc;
    padding: 12px 16px;
    border-bottom: 1px solid #edf2f7;
}

.section-title {
    font-size: 15px;
    font-weight: 600;
    color: #1e293b;
    margin: 0;
}

.section-icon {
    margin-right: 8px;
    width: 24px;
    height: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 6px;
    background-color: var(--el-color-primary-light-9);
    color: var(--el-color-primary);
}

:deep(.el-table) {
    --el-table-border-color: #edf2f7;
    --el-table-header-bg-color: #f8fafc;
    --el-table-row-hover-bg-color: #f9fafb;
}

:deep(.el-table th) {
    font-weight: 600;
    color: #475569;
}

:deep(.el-input-number .el-input__wrapper) {
    width: 100%;
}

:deep(.el-button--primary) {
    font-weight: 500;
}

.rich-text-preview {
    max-height: 100px;
    overflow: auto;
    padding: 8px;
    border-radius: 4px;
    background-color: #fafafa;
    font-size: 12px;

    img {
        max-width: 100%;
        height: auto;
    }

    p {
        margin: 0.5em 0;
    }
}

.url-link {
    display: inline-flex;
    align-items: center;
    max-width: 100%;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

// 悬浮按钮样式
.float-action-btns {
    position: fixed;
    z-index: 99;
    filter: drop-shadow(0 0 8px rgba(0, 0, 0, 0.15));
    transition: transform 0.1s;

    &:hover {
        transform: translateX(-5px);
    }
}

.action-btns-wrapper {
    position: relative;
    display: flex;
    flex-direction: column;
    gap: 10px;
    background-color: #fff;
    padding: 16px;
    border-radius: 12px 0 0 12px;
    border: 1px solid #ebeef5;
    border-right: none;
}

.action-btn {
    min-width: 90px;
}

.drag-handle {
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: move;
    color: #909399;
    opacity: 0;
    transition: opacity 0.2s;

    &:hover {
        color: var(--el-color-primary);
    }
}

.action-btns-wrapper:hover .drag-handle {
    opacity: 1;
}
</style>
