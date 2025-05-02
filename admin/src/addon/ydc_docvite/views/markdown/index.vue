<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div class="flex justify-between items-center">
        <span class="text-page-title">{{ pageName }}</span>
        <el-button type="primary" class="w-[100px]" @click="addEvent">
          {{ t("addMarkdown") }}
        </el-button>
      </div>

      <el-card
        class="box-card !border-none my-[10px] table-search-wrap"
        shadow="never"
      >
        <el-form
          :inline="true"
          :model="markdownTable.searchParam"
          ref="searchFormRef"
        >
          <el-form-item :label="t('markdownName')" prop="filename">
            <el-input
              v-model.trim="markdownTable.searchParam.filename"
              :placeholder="t('markdownNamePlaceholder')"
            />
          </el-form-item>
          <el-form-item :label="t('createTime')" prop="create_time">
            <el-date-picker
              v-model="markdownTable.searchParam.create_time"
              type="datetimerange"
              value-format="YYYY-MM-DD HH:mm:ss"
              :start-placeholder="t('startDate')"
              :end-placeholder="t('endDate')"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadMarkdownList()">{{
              t("search")
            }}</el-button>
            <el-button @click="resetForm(searchFormRef)">{{
              t("reset")
            }}</el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <div class="tableContainer">
        <div class="leftFilter">
          <VaultPathSelectTree
            v-model="filterVaultPath.data"
            title="保存位置筛选"
            :enable-vault-select="true"
          />
        </div>
        <div class="rightTable">
          <el-table
            :data="markdownTable.data"
            size="large"
            v-loading="markdownTable.loading"
          >
            <template #empty>
              <span>{{ !markdownTable.loading ? t("emptyData") : "" }}</span>
            </template>
            <el-table-column
              :label="t('vaultName')"
              min-width="100"
              align="left"
            >
              <template #default="{ row }">
                <div class="flex items-center">
                  {{ row.vault_name }}
                </div>
              </template>
            </el-table-column>
            <el-table-column
              prop="path_name"
              :label="t('pathName')"
              min-width="100"
            >
              <template #default="{ row }">
                {{ row.path_name }}
              </template>
            </el-table-column>
            <el-table-column prop="title" :label="t('title')" min-width="150" />
            <el-table-column
              prop="create_time"
              :label="t('createTime')"
              min-width="150"
            />
            <el-table-column
              prop="update_time"
              :label="t('updateTime')"
              min-width="150"
            />
            <el-table-column :label="t('operation')" width="300">
              <template #default="{ row }">
                <el-button
                  type="primary"
                  plain
                  icon="Edit"
                  size="small"
                  @click="editEvent(row)"
                  >{{ t("edit") }}</el-button
                >
                <el-popconfirm
                  :title="t('confirmToPublish')"
                  @confirm="publishEvent(row)"
                >
                  <template #reference>
                    <el-button
                      type="success"
                      plain
                      icon="Position"
                      size="small"
                      >{{ t("publish") }}</el-button
                    >
                  </template>
                </el-popconfirm>
                <el-popconfirm
                  :title="t('confirmToDelete')"
                  @confirm="delEvent(row)"
                >
                  <template #reference>
                    <el-button type="danger" plain icon="Delete" size="small">{{
                      t("delete")
                    }}</el-button>
                  </template>
                </el-popconfirm>
              </template>
            </el-table-column>
          </el-table>
          <div class="mt-[16px] flex justify-end">
            <el-pagination
              v-model:current-page="markdownTable.page"
              v-model:page-size="markdownTable.limit"
              layout="total, sizes, prev, pager, next, jumper"
              :total="markdownTable.total"
              @size-change="loadMarkdownList"
              @current-change="loadMarkdownList"
            />
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from "vue";
import { t } from "@/lang";
import { getIndex, del, publish } from "@/addon/ydc_docvite/api/markdown";
import VaultPathSelectTree from "@/addon/ydc_docvite/views/components/VaultPathSelectTree.vue";
import { FormInstance, ElLoading } from "element-plus";
import { useRoute, useRouter } from "vue-router";
import {
  showErrorMsg,
  showSuccessMsg,
} from "@/addon/ydc_docvite/utils/message";

const route = useRoute();
const pageName = route.meta.title;

let filterVaultPath = reactive({
  data: {
    vaultId: null,
    pathId: null,
  },
});

interface TableType {
  page: number;
  limit: number;
  total: number;
  loading: boolean;
  data: any[];
  vault_id: null | number;
  path_id: null | number;
  searchParam: {
    filename: string;
    create_time: [];
  };
}
const markdownTable = reactive<TableType>({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  vault_id: 0,
  path_id: 0,
  searchParam: {
    filename: "",
    create_time: [],
  },
});

const searchFormRef = ref<FormInstance>();

const loadMarkdownList = () => {
  markdownTable.loading = true;

  getIndex({
    page: markdownTable.page,
    limit: markdownTable.limit,
    vault_id: markdownTable.vault_id,
    path_id: markdownTable.path_id,
    ...markdownTable.searchParam,
  })
    .then((res) => {
      markdownTable.loading = false;
      markdownTable.data = res.data.data;
      markdownTable.total = res.data.total;
    })
    .catch(() => {
      markdownTable.loading = false;
    });
};
loadMarkdownList();

const router = useRouter();

const addEvent = () => {
  router.push("/ydc_docvite/markdown/add");
};
const editEvent = (row: any) => {
  router.push({
    path: "/ydc_docvite/markdown/edit",
    query: {
      id: row.id,
    },
  });
};
const delEvent = (row: any) => {
  del({ id: row.id })
    .then(() => {
      loadMarkdownList();
    })
    .finally(() => {
      markdownTable.loading = false;
    });
};

const publishEvent = (row: any) => {
  const loading = ElLoading.service({
    fullscreen: true,
    text: t("publishing"),
  });
  publish({ id: row.id })
    .then(() => {
      showSuccessMsg(t("publishSuccess"));
      loadMarkdownList();
    })
    .catch(() => {
      showErrorMsg(t("publishFailed"));
    })
    .finally(() => {
      loading.close();
    });
};

watch(
  [() => filterVaultPath.data.pathId, () => filterVaultPath.data.vaultId],
  (newVal, oldVal) => {
    // console.log("filterVaultPath change:", newVal, oldVal);
    markdownTable.vault_id = filterVaultPath.data.vaultId;
    markdownTable.path_id = filterVaultPath.data.pathId;
    loadMarkdownList();
  }
);

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  loadMarkdownList();
};
</script>

<style lang="scss" scoped>
.tableContainer {
  display: flex;
  flex-direction: row;
  height: 100%;
  .leftFilter {
    width: 20%;
  }
  .rightTable {
    margin-left: 10px;
    width: 80%;
    height: 100%;
    :deep(.el-table) {
      min-height: 700px;
    }
    :deep(.el-table__empty-block) {
      min-height: 500px;
    }
    :deep(.el-scrollbar) {
      min-height: 700px;
    }
  }
}
</style>
