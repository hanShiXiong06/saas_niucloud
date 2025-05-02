<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div class="flex justify-between items-center">
        <span class="text-page-title">{{ pageName }}</span>
        <el-button type="primary" class="w-[100px]" @click="addEvent">
          {{ t("addVault") }}
        </el-button>
      </div>
      <el-card
        class="box-card !border-none my-[10px] table-search-wrap"
        shadow="never"
      >
        <el-form
          :inline="true"
          :model="vaultTable.searchParam"
          ref="searchFormRef"
        >
          <el-form-item :label="t('name')" prop="name">
            <el-input
              v-model.trim="vaultTable.searchParam.name"
              :placeholder="t('namePlaceholder')"
            />
          </el-form-item>
          <el-form-item :label="t('createTime')" prop="create_time">
            <el-date-picker
              v-model="vaultTable.searchParam.create_time"
              type="datetimerange"
              value-format="YYYY-MM-DD HH:mm:ss"
              :start-placeholder="t('startDate')"
              :end-placeholder="t('endDate')"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadVaultList()">{{
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
          :data="vaultTable.data"
          size="large"
          v-loading="vaultTable.loading"
        >
          <template #empty>
            <span>{{ !vaultTable.loading ? t("emptyData") : "" }}</span>
          </template>
          <el-table-column :label="t('name')" min-width="100" align="left">
            <template #default="{ row }">
              <div class="flex items-center">
                {{ row.name }}
              </div>
            </template>
          </el-table-column>
          <el-table-column
            prop="alias_name"
            :label="t('aliasName')"
            min-width="100"
          >
            <template #default="{ row }">
              {{ row.alias_name }}
            </template>
          </el-table-column>

          <el-table-column label="发布状态" align="center" width="150">
            <template #default="scope">
              <!-- 0-未发布; 1-发布中; 2-已发布; 3-错误; 4-清理中; 5-排队中 -->
              <el-tag v-if="scope.row.vite_status == 0" type="info">
                未发布
              </el-tag>
              <el-tag v-if="scope.row.vite_status == 1" type="primary">
                发布中
              </el-tag>
              <el-tag v-if="scope.row.vite_status == 2" type="success">
                已发布
              </el-tag>
              <el-tag v-if="scope.row.vite_status == 3" type="error">
                错误
              </el-tag>
              <el-tag v-if="scope.row.vite_status == 4" type="warning">
                清理中
              </el-tag>
              <el-tag v-if="scope.row.vite_status == 5" type="info">
                排队中
              </el-tag>
            </template>
          </el-table-column>

          <el-table-column label="发布结果" align="center" width="150">
            <template #default="scope">
              <el-tooltip
                v-if="scope.row.vite_status == 3"
                class="box-item"
                effect="dark"
                content="点击查看错误详情"
                placement="top"
              >
                <el-button
                  plain
                  circle
                  icon="View"
                  @click="
                    () => {
                      control.showLastError = true;
                      control.lastErr = scope.row.vite_last_err_msg;
                    }
                  "
                />
              </el-tooltip>
              <el-tag v-else type="success">正常</el-tag>
            </template>
          </el-table-column>

          <el-table-column label="访问地址" align="center" width="150">
            <template #default="scope">
              <div
                style="display: flex; justify-content: space-around"
                v-if="scope.row.vite_status == 2"
              >
                <el-tooltip
                  effect="dark"
                  content="复制访问地址"
                  placement="right-start"
                >
                  <el-button
                    type="primary"
                    circle
                    color="lightgrey"
                    @click="copyUrl(scope.row)"
                    ><el-icon :size="15"> <el-icon-CopyDocument /> </el-icon
                  ></el-button>
                </el-tooltip>
                <el-tooltip
                  effect="dark"
                  content="访问仓库文档首页"
                  placement="right-start"
                >
                  <el-button
                    type="primary"
                    circle
                    color="lightgrey"
                    @click="openUrl(scope.row)"
                    ><el-icon :size="15"> <el-icon-Link /> </el-icon
                  ></el-button>
                </el-tooltip>
              </div>
              <el-tag type="danger" v-else>不可用</el-tag>
            </template>
          </el-table-column>
          <el-table-column
            prop="create_time"
            :label="t('createTime')"
            min-width="150"
          />
          <el-table-column :label="t('operation')" width="240">
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
          <el-table-column :label="t('publishOpr')" width="240">
            <template #default="{ row }">
              <el-popconfirm
                :title="t('confirmToPublish')"
                @confirm="publishEvent(row)"
              >
                <template #reference>
                  <el-button
                    type="primary"
                    plain
                    icon="Position"
                    size="small"
                    >{{ t("publish") }}</el-button
                  >
                </template>
              </el-popconfirm>
              <el-popconfirm
                title="清空发布内容"
                @confirm="clearPublishEvent(row)"
              >
                <template #reference>
                  <el-button type="warning" plain icon="Aim" size="small"
                    >清空发布</el-button
                  >
                </template>
              </el-popconfirm>
            </template>
          </el-table-column>
        </el-table>
        <div class="mt-[16px] flex justify-end">
          <el-pagination
            v-model:current-page="vaultTable.page"
            v-model:page-size="vaultTable.limit"
            layout="total, sizes, prev, pager, next, jumper"
            :total="vaultTable.total"
            @size-change="loadVaultList"
            @current-change="loadVaultList"
          />
        </div>
      </div>
    </el-card>
    <AddVaultPopup ref="addVaultPopupRef" @success="loadVaultList()" />
    <EditVaultPopup ref="editVaultPopupRef" @success="loadVaultList()" />

    <el-dialog
      title="错误详情"
      v-model="control.showLastError"
      width="70%"
      destroy-on-close
    >
      <el-input
        style="font-size: 15px; font-weight: bold"
        type="textarea"
        :readonly="true"
        v-model="control.lastErr"
        :autosize="{ minRows: 5, maxRows: 10 }"
      />
      <template #footer>
        <div></div>
      </template>
    </el-dialog>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref } from "vue";
import { t } from "@/lang";
import {
  getIndex,
  del,
  publish,
  clearPublish,
  pullPublishStatus,
} from "@/addon/ydc_docvite/api/vault";
import { FormInstance } from "element-plus";
import { useRoute } from "vue-router";
import AddVaultPopup from "./components/addVaultPopup.vue";
import EditVaultPopup from "./components/editVaultPopup.vue";
import {
  showErrorMsg,
  showSuccessMsg,
  showSuccessNotify,
  showWarningNotify,
} from "@/addon/ydc_docvite/utils/message";

const route = useRoute();
const pageName = route.meta.title;

interface TableType {
  page: number;
  limit: number;
  total: number;
  loading: boolean;
  data: any[];
  searchParam: {
    name: string;
    alias_name: string;
    create_time: [];
  };
}
const vaultTable = reactive<TableType>({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    name: "",
    alias_name: "",
    create_time: [],
  },
});

const searchFormRef = ref<FormInstance>();

const addVaultPopupRef: any = ref(null);
const addEvent = () => {
  addVaultPopupRef?.value.show();
};

const editVaultPopupRef: any = ref(null);
const editEvent = (row: any) => {
  editVaultPopupRef?.value.show(row);
};

const loadVaultList = () => {
  vaultTable.loading = true;
  getIndex({
    page: vaultTable.page,
    limit: vaultTable.limit,
    ...vaultTable.searchParam,
  })
    .then((res) => {
      vaultTable.loading = false;
      vaultTable.data = res.data.data;
      vaultTable.total = res.data.total;
    })
    .catch(() => {
      vaultTable.loading = false;
    });
};

const control = reactive({
  showLastError: false,
  lastErr: "",
});

loadVaultList();

const delEvent = (row: any) => {
  vaultTable.loading = true;
  del({ id: row.id })
    .then(() => {
      loadVaultList();
    })
    .finally(() => {
      vaultTable.loading = false;
    });
};

let pullPublishStatusIntr: any = null;
const pullPublishStatusEvent = (row: any) => {
  pullPublishStatus({ id: row.id })
    .then((rsp) => {
      console.debug("pullPublishStatusEvent -> ", rsp);
      // 0-未发布; 1-发布中; 2-已发布; 3-错误; 4-清理中; 5-排队中
      if (rsp.data?.status == 2) {
        showSuccessNotify(`仓库 【${row.name}】 发布成功！`, 5000);
        loadVaultList();
        if (pullPublishStatusIntr) {
          clearInterval(pullPublishStatusIntr);
        }
        return;
      }
      if (rsp.data?.status == 3) {
        showWarningNotify(
          `仓库 【${row.name}】 发布失败，可点击发布结果查看原因！`,
          5000
        );
        loadVaultList();
        if (pullPublishStatusIntr) {
          clearInterval(pullPublishStatusIntr);
        }
        return;
      }
      if (pullPublishStatusIntr === null) {
        pullPublishStatusIntr = setInterval(() => {
          pullPublishStatusEvent(row);
        }, 3000);
      }
    })
    .catch((err) => {
      showErrorMsg("轮询发布状态错误: " + err);
      if (pullPublishStatusIntr) {
        clearInterval(pullPublishStatusIntr);
      }
    });
};

let pullClearPublishStatusIntr: any = null;
const pullClearPublishStatusEvent = (row: any) => {
  pullPublishStatus({ id: row.id })
    .then((rsp) => {
      console.debug("pullClearPublishStatusEvent -> ", rsp);
      // 0-未发布; 1-发布中; 2-已发布; 3-错误; 4-清理中; 5-排队中
      if (rsp.data?.status == 0) {
        showSuccessNotify(`仓库 【${row.name}】 清理发布成功！`, 5000);
        loadVaultList();
        if (pullClearPublishStatusIntr) {
          clearInterval(pullClearPublishStatusIntr);
        }
        return;
      }
      if (rsp.data?.status == 3) {
        showWarningNotify(
          `仓库 【${row.name}】 清理发布失败，可点击发布结果查看原因！`,
          5000
        );
        loadVaultList();
        if (pullClearPublishStatusIntr) {
          clearInterval(pullClearPublishStatusIntr);
        }
        return;
      }
      if (pullClearPublishStatusIntr === null) {
        pullClearPublishStatusIntr = setInterval(() => {
          pullClearPublishStatusEvent(row);
        }, 3000);
      }
    })
    .catch((err) => {
      showErrorMsg("轮询发布状态错误: " + err);
      if (pullClearPublishStatusIntr) {
        clearInterval(pullClearPublishStatusIntr);
      }
    });
};

const publishEvent = (row: any) => {
  vaultTable.loading = true;
  publish({ id: row.id })
    .then(() => {
      showSuccessMsg("操作成功，发布任务已进入队列");
      loadVaultList();
      pullPublishStatusEvent(row);
    })
    .finally(() => {
      vaultTable.loading = false;
    });
};

const clearPublishEvent = (row: any) => {
  vaultTable.loading = true;
  clearPublish({ id: row.id })
    .then(() => {
      showSuccessMsg("操作成功，清空发布任务已进入队列");
      loadVaultList();
      pullClearPublishStatusEvent(row);
    })
    .finally(() => {
      vaultTable.loading = false;
    });
};

const openUrl = (row: any) => {
  let uu = row.url;
  window?.open(uu, "_blank")?.focus();
};

const copyUrl = (row: any) => {
  let uu = row.url;
  navigator.clipboard.writeText(uu).then(
    function () {
      showSuccessMsg("复制成功");
    },
    function (er) {
      showSuccessMsg("复制失败" + er);
    }
  );
  return;
};

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
};
</script>

<style lang="scss" scoped></style>
