<template>

    <el-dialog v-model="showDialog" :title="t('selectLinkTips')" width="40%" :close-on-press-escape="false"
        :destroy-on-close="true" :close-on-click-modal="false" @close="cancel">

        <div class="mt-[10px]">
            <el-table :data="actTable.data" size="large" v-loading="actTable.loading">
                <template #empty>
                    <span>{{ !actTable.loading ? t("emptyData") : "" }}</span>
                </template>

                <el-table-column prop="act_name" :label="t('actName')" min-width="120" :show-overflow-tooltip="true" />

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
                <el-table-column prop="commission_rate" :label="t('commissionRate')" min-width="120"
                    :show-overflow-tooltip="true" />

                <el-table-column prop="settlement_time" :label="t('settlementTime')" min-width="120"
                    :show-overflow-tooltip="true" />

                <el-table-column prop="start_date" label="开始时间" min-width="120" :show-overflow-tooltip="true" />

                <el-table-column prop="end_date" label="结束时间" min-width="120" :show-overflow-tooltip="true" />

                <el-table-column :label="t('operation')" fixed="right" min-width="120">
                    <template #default="{ row }">
                        <el-button type="primary" link @click="editEvent(row)">详情</el-button>

                        <el-button type="primary" link @click="shareEvent(row.id)">立即推广</el-button>
                        <el-button type="primary" link :loading="saveloading"
                            @click="saveImgEvent(row.id)">保存素材</el-button>
                    </template>
                </el-table-column>
            </el-table>
            <div class="mt-[16px] flex justify-end">
                <el-pagination v-model:current-page="actTable.page" v-model:page-size="actTable.limit"
                    layout="total, sizes, prev, pager, next, jumper" :total="actTable.total"
                    @size-change="loadActList()" @current-change="loadActList" />
            </div>
        </div>

        <template #footer>
            <span class="dialog-footer">
                <el-button @click="cancel">{{ t('cancel') }}</el-button>
                <el-button type="primary" @click="save">{{ t('confirm') }}</el-button>
            </span>
        </template>
    </el-dialog>

</template>

<script lang="ts" setup>
import { t } from '@/lang'
import { ref, computed, reactive } from 'vue'
import { cloneDeep } from 'lodash-es'
import {
    getActList,
    asyncAct,
    saveImg,
} from "@/addon/tk_cps/api/act";
import { ElMessage } from 'element-plus'

const prop = defineProps({
    modelValue: {
        type: Object,
        default: () => { }
    },
    ignore: {
        type: Array,
        default: []
    }
})

const emit = defineEmits(['update:modelValue', 'confirm', 'success'])

const value: any = computed({
    get() {
        return prop.modelValue
    },
    set(value) {
        emit('update:modelValue', value)
    }
})
const saveloading = ref(false)
//保存素材
const saveImgEvent = async (id) => {
    saveloading.value = true;
    const res = await saveImg(id);
    if (res.code == 1) {
        saveloading.value = false;
    }
};
let actTable = reactive({
    page: 1,
    limit: 10,
    total: 0,
    loading: true,
    data: [],
    searchParam: {
        act_id: "",
        act_name: "",
        type: "",
        desc: "",
        img: "",
        icon: "",
        poster: "",
        commission_rate: "",
        introduce: "",
        attribution_explain: "",
        settlement_time: "",
        start_date: "",
        end_date: "",
        create_time: "",
    },
});
/**
 * 获取CPS活动链接列表
 */
const loadActList = (page: number = 1) => {
    actTable.loading = true;
    actTable.page = page;

    getActList({
        page: actTable.page,
        limit: actTable.limit,
        ...actTable.searchParam,
    })
        .then((res) => {
            actTable.loading = false;
            actTable.data = res.data.data;
            actTable.total = res.data.total;
        })
        .catch(() => {
            actTable.loading = false;
        });
};
loadActList();

defineExpose({
    showDialog
})
</script>

<style lang="scss">
.link-input .el-input__inner {
    cursor: pointer;
}
</style>
