<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div class="flex justify-between items-center">
        <span class="text-lg">{{ pageName }}</span>
      </div>

      <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
        <el-form :inline="true" :model="spdrListTable.searchParam" ref="searchFormRef">
          <!-- <el-form-item :label="t('status')" prop="status">
            <el-input
              v-model="spdrListTable.searchParam.status"
              :placeholder="t('statusPlaceholder')"
            />
          </el-form-item> -->
          <el-form-item :label="t('createTime')" prop="create_time">
            <el-date-picker v-model="spdrListTable.searchParam.create_time" type="datetimerange"
              format="YYYY-MM-DD hh:mm:ss" :start-placeholder="t('startDate')" :end-placeholder="t('endDate')" />
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="loadSpdrListList()">{{
              t("search")
              }}</el-button>
            <el-button @click="resetForm(searchFormRef)">{{
              t("reset")
              }}</el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <div class="mt-[10px]">
        <el-table :data="spdrListTable.data" size="large" v-loading="spdrListTable.loading">
          <template #empty>
            <span>{{ !spdrListTable.loading ? t("emptyData") : "" }}</span>
          </template>
          <el-table-column prop="flie" :label="t('flie')" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column prop="num" :label="t('num')" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column prop="success_num" :label="t('successNum')" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column prop="fail_num" :label="t('failNum')" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column :label="t('operation')" fixed="right" min-width="120">
            <template #default="{ row }">
              <el-button type="primary" link @click="deleteEvent(row.id)">{{
                t("delete")
                }}</el-button>
            </template>
          </el-table-column>
        </el-table>
        <div class="mt-[16px] flex justify-end">
          <el-pagination v-model:current-page="spdrListTable.page" v-model:page-size="spdrListTable.limit"
            layout="total, sizes, prev, pager, next, jumper" :total="spdrListTable.total"
            @size-change="loadSpdrListList()" @current-change="loadSpdrListList" />
        </div>
      </div>

      <edit ref="editSpdrListDialog" @complete="loadSpdrListList" />
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from "vue";
import { t } from "@/lang";
import { useDictionary } from "@/app/api/dict";
import { getSpdrListList, deleteSpdrList } from "@/addon/goods_export/api/spdrlist";
import { img } from "@/utils/common";
import { ElMessageBox, FormInstance } from "element-plus";
import Edit from "@/addon/goods_export/views/spdrlist/components/spdrlist-edit.vue";
import { useRoute } from "vue-router";
const route = useRoute();
const pageName = route.meta.title;

let spdrListTable = reactive({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    status: "",
    create_time: [],
  },
});

const searchFormRef = ref<FormInstance>();

// 选中数据
const selectData = ref<any[]>([]);

// 字典数据

/**
 * 获取商品导入列列表
 */
const loadSpdrListList = (page: number = 1) => {
  spdrListTable.loading = true;
  spdrListTable.page = page;

  getSpdrListList({
    page: spdrListTable.page,
    limit: spdrListTable.limit,
    ...spdrListTable.searchParam,
  })
    .then((res) => {
      spdrListTable.loading = false;
      spdrListTable.data = res.data.data;
      spdrListTable.total = res.data.total;
    })
    .catch(() => {
      spdrListTable.loading = false;
    });
};
loadSpdrListList();

const editSpdrListDialog: Record<string, any> | null = ref(null);

/**
 * 添加商品导入列
 */
const addEvent = () => {
  editSpdrListDialog.value.setFormData();
  editSpdrListDialog.value.showDialog = true;
};

/**
 * 编辑商品导入列
 * @param data
 */
const editEvent = (data: any) => {
  editSpdrListDialog.value.setFormData(data);
  editSpdrListDialog.value.showDialog = true;
};

/**
 * 删除商品导入列
 */
const deleteEvent = (id: number) => {
  ElMessageBox.confirm(t("spdrListDeleteTips"), t("warning"), {
    confirmButtonText: t("confirm"),
    cancelButtonText: t("cancel"),
    type: "warning",
  }).then(() => {
    deleteSpdrList(id)
      .then(() => {
        loadSpdrListList();
      })
      .catch(() => { });
  });
};

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  loadSpdrListList();
};
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
