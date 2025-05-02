<template>
    <div class="w-[280px] select-box" @click="openSelector">
        <el-input :model-value="modelValue?.title" placeholder="请选择活动" readonly :suffix-icon="ArrowDown"
            class="cursor-pointer hover:opacity-80" />
    </div>

    <el-dialog v-model="dialogVisible" title="活动快速选择" width="50%" @close="handleClose">
        <div class="main-container">
            <el-form :inline="true" :model="actTable.searchParam" ref="searchFormRef">
                <el-form-item label="活动名称" prop="act_name">
                    <el-input v-model="actTable.searchParam.act_name" placeholder="请输入活动名称" />
                </el-form-item>
                <el-form-item label="推广渠道" prop="type">
                    <el-select class="w-[280px]" v-model="actTable.searchParam.type" clearable placeholder="请选择">
                        <el-option label="全部" value=""></el-option>
                        <block v-for="(item, index) in drivers" :key="index">
                            <el-option :label="item.name" :value="item.type"></el-option>
                        </block>
                    </el-select>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="loadActList()">搜索</el-button>
                    <el-button @click="resetForm(searchFormRef)">重置</el-button>
                </el-form-item>
            </el-form>

            <div class="mt-[10px]">
                <el-table :data="actTable.data" size="large" v-loading="actTable.loading">
                    <template #empty>
                        <span>{{ !actTable.loading ? "暂无数据" : "" }}</span>
                    </template>

                    <el-table-column prop="act_name" label="活动名称" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column prop="type" label="渠道" min-width="120" :show-overflow-tooltip="true">
                        <template #default="{ row }">
                            <block v-for="(item, index) in drivers" :key="index">
                                <el-tag v-if="row.type == item.type"> {{ item.name }} </el-tag>
                            </block>
                        </template>
                    </el-table-column>

                    <el-table-column :label="t('icon')" width="100" align="left">
                        <template #default="{ row }">
                            <el-avatar v-if="row.icon" :src="img(row.icon)" />
                            <el-avatar v-else icon="UserFilled" />
                        </template>
                    </el-table-column>
                    <el-table-column prop="commission_rate" label="佣金" min-width="120" :show-overflow-tooltip="true" />

                    <el-table-column label="操作" fixed="right" min-width="120">
                        <template #default="{ row }">
                            <el-button type="primary" link @click="saveImgEvent(row)"
                                :loading="row.saving">保存素材</el-button>
                            <el-button type="primary"  @click="handleSelect(row)">选择</el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <div class="mt-[16px] flex justify-end">
                    <el-pagination v-model:current-page="actTable.page" v-model:page-size="actTable.limit"
                        layout="total, sizes, prev, pager, next, jumper" :total="actTable.total"
                        @size-change="loadActList()" @current-change="loadActList" />
                </div>
            </div>
        </div>
    </el-dialog>

    <el-dialog v-model="saveloading" :title="savingTitle" width="400px" :show-close="false" align-center>
        <div class="flex flex-col items-center saving-container">
            <div class="loading-icon-container mb-4" v-if="saveloading">
                <el-icon class="text-4xl loading-icon">
                    <Loading />
                </el-icon>
            </div>
            <span
                :class="{ 'success-message': savingMessage.includes('成功'), 'error-message': savingMessage.includes('失败') }">
                {{ savingMessage }}
            </span>
        </div>
    </el-dialog>
</template>

<script lang="ts" setup>
import { reactive, ref } from "vue";
import { t } from "@/lang";
import { getActList, getDrivers, saveImg } from "@/addon/tk_cps/api/act";
import { img } from "@/utils/common";
import { FormInstance } from "element-plus";
import { ArrowDown, Loading } from '@element-plus/icons-vue';
import { ElMessage } from 'element-plus';

//保存素材
const saveloading = ref(false);
const savingTitle = ref('正在保存素材');
const savingMessage = ref('正在保存，请稍候...');

const saveImgEvent = async (row) => {
    if (row.saving) return;

    try {
        row.saving = true;
        saveloading.value = true;
        savingMessage.value = '正在保存，请稍候...';

        const res = await saveImg(row.id);

        if (res.code === 1) {
            savingMessage.value = '保存成功';
            ElMessage.success('素材保存成功');
        } else {
            savingMessage.value = '保存失败：' + (res.msg || '未知错误');
            ElMessage.error(res.msg || '保存失败');
        }
    } catch (error) {
        savingMessage.value = '保存失败：' + (error.message || '未知错误');
        ElMessage.error('保存失败');
    } finally {
        setTimeout(() => {
            saveloading.value = false;
            row.saving = false;
        }, 1000);
    }
};

const props = defineProps({
    modelValue: {
        type: Object,
        default: () => ({})
    }
});

const emit = defineEmits(['update:modelValue']);

const dialogVisible = ref(false);

const openSelector = () => {
    dialogVisible.value = true;
    loadActList();
};

const drivers = ref([]);
const getDriverList = async () => {
    try {
        const res = await getDrivers();
        if (res.code === 1 && res.data) {
            drivers.value = res.data;
        }
    } catch (error) {
        console.error('获取驱动列表失败:', error);
    }
};

const actTable = reactive({
    page: 1,
    limit: 6,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        act_name: "",
        type: "",
    },
});

const searchFormRef = ref<FormInstance>();

// 加载活动列表
const loadActList = async (page: number = 1) => {
    actTable.loading = true;
    try {
        const res = await getActList({
            page: page || actTable.page,
            limit: actTable.limit,
            ...actTable.searchParam,
        });
        if (res.code === 1 && res.data) {
            actTable.data = (res.data.data || []).map(item => ({
                ...item,
                saving: false
            }));
            actTable.total = res.data.total || 0;
            actTable.page = page || actTable.page;
        }
    } catch (error) {
        console.error('加载活动列表失败:', error);
    } finally {
        actTable.loading = false;
    }
};

// 选择活动
const handleSelect = (row: any) => {
    const data = {
        title: row.act_name,
        name: 'DIY_LINK',
        parent: 'DIY_LINK',
        url: '/addon/tk_cps/pages/index?type=' + row.type + '&act_id=' + row.act_id + '&style=embedded',
        action: '',
    };
    emit('update:modelValue', data);
    dialogVisible.value = false;
};

// 重置表单
const resetForm = (formEl: FormInstance | undefined) => {
    if (!formEl) return;
    formEl.resetFields();
    actTable.searchParam.act_name = "";
    actTable.searchParam.type = "";
    loadActList(1);
};

// 关闭弹窗
const handleClose = () => {
    dialogVisible.value = false;
};

// 初始化
getDriverList();
</script>

<style lang="scss" scoped>
.select-box {
    cursor: pointer;

    :deep(.el-input) {
        .el-input__wrapper {
            cursor: pointer;
        }

        .el-input__inner {
            cursor: pointer;
        }

        .el-input__suffix {
            cursor: pointer;
        }
    }
}

.saving-container {
    .loading-icon-container {
        position: relative;
        width: 60px;
        height: 60px;

        .loading-icon {
            position: absolute;
            font-size: 3rem;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            animation: loading-animation 2s infinite;
            color: var(--el-color-primary);
        }
    }

    .success-message {
        color: var(--el-color-success);
        animation: message-fade 0.3s ease-in-out;
    }

    .error-message {
        color: var(--el-color-danger);
        animation: message-fade 0.3s ease-in-out;
    }
}

@keyframes loading-animation {
    0% {
        transform: translate(-50%, -50%) rotate(0deg) scale(1);
    }

    50% {
        transform: translate(-50%, -50%) rotate(180deg) scale(1.2);
    }

    100% {
        transform: translate(-50%, -50%) rotate(360deg) scale(1);
    }
}

@keyframes message-fade {
    0% {
        opacity: 0;
        transform: translateY(10px);
    }

    100% {
        opacity: 1;
        transform: translateY(0);
    }
}
</style>