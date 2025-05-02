<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div class="flex justify-between items-center">
        <span class="text-lg">站点存储管理</span>
        <el-button type="primary" @click="addEvent">
          {{ t("addManageOss") }}
        </el-button>
      </div>

      <el-card
        class="box-card !border-none my-[10px] table-search-wrap"
        shadow="never"
      >
        <el-form
          :inline="true"
          :model="manageOssTable.searchParam"
          ref="searchFormRef"
        >
          <el-form-item :label="t('siteId')" prop="site_id">
            <el-select
              class="w-[280px]"
              v-model="manageOssTable.searchParam.site_id"
              clearable
              :placeholder="t('siteIdPlaceholder')"
            >
              <el-option
                v-for="(item, index) in siteIdList"
                :key="index"
                :label="item['site_name']"
                :value="item['site_id']"
              />
            </el-select>
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="loadManageOssList()">{{
              t("search")
            }}</el-button>
            <el-button @click="resetForm(searchFormRef)">{{
              t("reset")
            }}</el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <div class="mt-[10px]">
        <el-table
          :data="manageOssTable.data"
          size="large"
          v-loading="manageOssTable.loading"
        >
          <template #empty>
            <span>{{ !manageOssTable.loading ? t("emptyData") : "" }}</span>
          </template>
          <el-table-column
            prop="site_id_name"
            label="站点"
            min-width="80"
            :show-overflow-tooltip="true"
          />
          <el-table-column
            prop="storage_name"
            :label="t('value')"
            min-width="120"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <el-tag
                class="mr-1 mb-1"
                v-for="(item, index) in row.storage_name"
                :key="index"
                >{{ item }}</el-tag
              >
            </template>
          </el-table-column>

          <!-- <el-table-column
            prop="size"
            :label="t('size')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="use_size"
            :label="t('useSize')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="limit"
            :label="t('limit')"
            min-width="120"
            :show-overflow-tooltip="true"
          /> -->

          <el-table-column
            :label="t('operation')"
            fixed="right"
            min-width="120"
          >
            <template #default="{ row }">
              <el-button type="primary" link @click="editEvent(row)">{{
                t("edit")
              }}</el-button>
              <el-button type="primary" link @click="deleteEvent(row.id)">{{
                t("delete")
              }}</el-button>
            </template>
          </el-table-column>
        </el-table>
        <div class="mt-[16px] flex justify-end">
          <el-pagination
            v-model:current-page="manageOssTable.page"
            v-model:page-size="manageOssTable.limit"
            layout="total, sizes, prev, pager, next, jumper"
            :total="manageOssTable.total"
            @size-change="loadManageOssList()"
            @current-change="loadManageOssList"
          />
        </div>
      </div>

      <edit ref="editManageOssDialog" @complete="loadManageOssList" />
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from "vue";
import { t } from "@/lang";
import { useDictionary } from "@/app/api/dict";
import {
  getManageOssList,
  deleteManageOss,
  getWithSiteList,
} from "@/addon/manage_oss/api/manageoss";
import { img } from "@/utils/common";
import { ElMessageBox, FormInstance } from "element-plus";
import Edit from "@/addon/manage_oss/views/manageoss/components/manageoss-edit.vue";
import { useRoute } from "vue-router";
const route = useRoute();
const pageName = route.meta.title;

let manageOssTable = reactive({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    site_id: "",
  },
});

const searchFormRef = ref<FormInstance>();

// 选中数据
const selectData = ref<any[]>([]);

// 字典数据

/**
 * 获取存储管理列表
 */
const loadManageOssList = (page: number = 1) => {
  manageOssTable.loading = true;
  manageOssTable.page = page;

  getManageOssList({
    page: manageOssTable.page,
    limit: manageOssTable.limit,
    ...manageOssTable.searchParam,
  })
    .then((res) => {
      manageOssTable.loading = false;
      manageOssTable.data = res.data.data;
      manageOssTable.total = res.data.total;
    })
    .catch(() => {
      manageOssTable.loading = false;
    });
};
loadManageOssList();

const editManageOssDialog: Record<string, any> | null = ref(null);

/**
 * 添加存储管理
 */
const addEvent = () => {
  editManageOssDialog.value.setFormData();
  editManageOssDialog.value.showDialog = true;
};

/**
 * 编辑存储管理
 * @param data
 */
const editEvent = (data: any) => {
  editManageOssDialog.value.setFormData(data);
  editManageOssDialog.value.showDialog = true;
};

/**
 * 删除存储管理
 */
const deleteEvent = (id: number) => {
  ElMessageBox.confirm(t("manageOssDeleteTips"), t("warning"), {
    confirmButtonText: t("confirm"),
    cancelButtonText: t("cancel"),
    type: "warning",
  }).then(() => {
    deleteManageOss(id)
      .then(() => {
        loadManageOssList();
      })
      .catch(() => {});
  });
};

const siteIdList = ref([]);
const setSiteIdList = async () => {
  siteIdList.value = await (await getWithSiteList({})).data;
};
setSiteIdList();

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  loadManageOssList();
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