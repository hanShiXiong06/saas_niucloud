<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div class="flex justify-between items-center">
        <span class="text-lg">{{ pageName }}</span>
      </div>

      <el-card
        class="box-card !border-none my-[10px] table-search-wrap"
        shadow="never"
      >
        <el-form
          :inline="true"
          :model="qflogTable.searchParam"
          ref="searchFormRef"
        >
          <el-form-item :label="t('addonName')" prop="addon_name">
            <el-input
              v-model="qflogTable.searchParam.addon_name"
              :placeholder="t('addonNamePlaceholder')"
            />
          </el-form-item>
          <el-form-item :label="t('type')" prop="type">
            <el-input
              v-model="qflogTable.searchParam.type"
              :placeholder="t('typePlaceholder')"
            />
          </el-form-item>
          <el-form-item :label="t('createTime')" prop="create_time">
            <el-date-picker
              v-model="qflogTable.searchParam.create_time"
              type="datetimerange"
              format="YYYY-MM-DD hh:mm:ss"
              :start-placeholder="t('startDate')"
              :end-placeholder="t('endDate')"
            />
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="loadQflogList()">{{
              t("search")
            }}</el-button>
            <el-button @click="resetForm(searchFormRef)">{{
              t("reset")
            }}</el-button>
          </el-form-item>
        </el-form>
      </el-card>
      <el-button @click="deleteSelectEvent()">删除选中</el-button>
      <div class="mt-[10px]">
        <el-table
          :data="qflogTable.data"
          size="large"
          v-loading="qflogTable.loading"
          @selection-change="handleSelectionChange"
        >
          <template #empty>
            <span>{{ !qflogTable.loading ? t("emptyData") : "" }}</span>
          </template>
          <el-table-column type="selection" width="85" />
          <el-table-column
            prop="addon_name"
            :label="t('addonName')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="wx_openid"
            :label="t('wxOpenid')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <!-- <el-table-column prop="email" :label="t('email')" min-width="120" :show-overflow-tooltip="true"/>
                    
                    <el-table-column prop="mobile" :label="t('mobile')" min-width="120" :show-overflow-tooltip="true"/> -->

          <el-table-column
            prop="type_name"
            :label="t('type')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="log"
            :label="t('log')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            :label="t('operation')"
            fixed="right"
            min-width="120"
          >
            <template #default="{ row }">
              <el-button type="primary" link @click="deleteEvent(row.id)">{{
                t("delete")
              }}</el-button>
            </template>
          </el-table-column>
        </el-table>
        <div class="mt-[16px] flex justify-end">
          <el-pagination
            v-model:current-page="qflogTable.page"
            v-model:page-size="qflogTable.limit"
            layout="total, sizes, prev, pager, next, jumper"
            :total="qflogTable.total"
            @size-change="loadQflogList()"
            @current-change="loadQflogList"
          />
        </div>
      </div>

      <edit ref="editQflogDialog" @complete="loadQflogList" />
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from "vue";
import { t } from "@/lang";
import { useDictionary } from "@/app/api/dict";
import {
  getQflogList,
  deleteQflog,
  delselect,
} from "@/addon/qf_notice/api/qflog";
import { img } from "@/utils/common";
import { ElMessageBox, FormInstance } from "element-plus";
import Edit from "@/addon/qf_notice/views/qflog/components/qflog-edit.vue";
import { useRoute } from "vue-router";
const route = useRoute();
const pageName = route.meta.title;

let qflogTable = reactive({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    addon_name: "",
    type: "",
    create_time: [],
  },
});

const searchFormRef = ref<FormInstance>();

// 选中数据
const selectData = ref<any[]>([]);
const handleSelectionChange = (val) => {
  selectData.value = val.map((item) => item.id);
};
const deleteSelectEvent = async () => {
  if (selectData.value.length > 0) {
    delselect(selectData.value).then((res) => {
      loadQflogList();
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
 * 获取发送日志列表
 */
const loadQflogList = (page: number = 1) => {
  qflogTable.loading = true;
  qflogTable.page = page;

  getQflogList({
    page: qflogTable.page,
    limit: qflogTable.limit,
    ...qflogTable.searchParam,
  })
    .then((res) => {
      qflogTable.loading = false;
      qflogTable.data = res.data.data;
      qflogTable.total = res.data.total;
    })
    .catch(() => {
      qflogTable.loading = false;
    });
};
loadQflogList();

const editQflogDialog: Record<string, any> | null = ref(null);

/**
 * 添加发送日志
 */
const addEvent = () => {
  editQflogDialog.value.setFormData();
  editQflogDialog.value.showDialog = true;
};

/**
 * 编辑发送日志
 * @param data
 */
const editEvent = (data: any) => {
  editQflogDialog.value.setFormData(data);
  editQflogDialog.value.showDialog = true;
};

/**
 * 删除发送日志
 */
const deleteEvent = (id: number) => {
  ElMessageBox.confirm(t("qflogDeleteTips"), t("warning"), {
    confirmButtonText: t("confirm"),
    cancelButtonText: t("cancel"),
    type: "warning",
  }).then(() => {
    deleteQflog(id)
      .then(() => {
        loadQflogList();
      })
      .catch(() => {});
  });
};

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  loadQflogList();
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
