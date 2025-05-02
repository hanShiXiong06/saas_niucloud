<template>
  <div class="main-container p-4">
    <el-card
      v-loading="loading"
      element-loading-text="正在执行,请稍后..."
      class="box-card !border-none mt-2"
      shadow="never"
    >
      <el-tabs v-model="value" @tab-click="handleClick">
        <el-tab-pane label="插件上传" name="admin">
          <div style="width: 640px" class="mb-2">
            <el-alert
              type="warning"
              title="提示：上传插件会自动解析插件信息,未安装插件将会自动安装，已经安装插件将会自动替换成最新上传包，同时会备份插件相关的代码和数据到站点upgrade下，出错可快速恢复"
              :closable="false"
              show-icon
            />
          </div>
          <div class="flex">
            <div class="w-[320px]">
              <addon-file v-model="file_url" api="sys/document/applet">
                <div class="d-card p-4">
                  <el-icon color="#409efc"><Upload /></el-icon>
                  <div class="text-[#409efc]">上传插件</div>
                </div>
              </addon-file>
            </div>
          </div>
        </el-tab-pane>
        <el-tab-pane label="插件列表" name="addonlist">
          <el-card
            class="box-card !border-none mb-[10px] table-search-wrap"
            shadow="never"
          >
            <div class="flex justify-between">
              <el-form :inline="true" :model="params" ref="searchFormRef">
                <el-form-item :label="t('title')" prop="search">
                  <el-input
                    v-model="params.search"
                    :placeholder="t('titlePlaceholder')"
                  />
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="getAddonDevelopFn">{{
                    t("search")
                  }}</el-button>
                  <el-button @click="resetForm(searchFormRef)">{{
                    t("reset")
                  }}</el-button>
                </el-form-item>
              </el-form>
            </div>
          </el-card>

          <el-table
            :data="data"
            size="large"
            v-loading="loading"
            class="pt-[5px]"
          >
            <template #empty>
              <span>{{ t("emptyData") }}</span>
            </template>

            <el-table-column :label="t('title')" align="left" min-width="320">
              <template #default="{ row }">
                <div class="flex items-center justify-between">
                  <el-image
                    v-if="row.icon"
                    class="w-[45px] h-[45px]"
                    :src="
                      row.icon.indexOf('data:image') != -1
                        ? row.icon
                        : img(row.icon)
                    "
                    fit="contain"
                  >
                    <template #error>
                      <img
                        class="w-[45px] h-[45px]"
                        src="@/app/assets/images/category_default.png"
                        alt=""
                      />
                    </template>
                  </el-image>
                  <img
                    v-else
                    class="w-[45px] h-[45px]"
                    src="@/app/assets/images/category_default.png"
                    alt=""
                  />
                  <div class="flex-1 w-[236px] pl-[15px] truncate">
                    {{ row.title }}
                  </div>
                </div>
              </template>
            </el-table-column>
            <el-table-column
              prop="key"
              :label="t('key')"
              align="center"
              min-width="200"
            />
            <el-table-column
              prop="type_name"
              :label="t('type')"
              align="center"
              min-width="200"
            />
            <el-table-column
              prop="author"
              :label="t('author')"
              align="center"
              min-width="200"
            />
            <el-table-column
              prop="version"
              :label="t('version')"
              align="center"
              min-width="200"
            />
            <el-table-column
              :label="t('status')"
              align="center"
              min-width="200"
            >
              <template #default="{ row }">
                {{ Object.keys(row.install_info).length ? "已安装" : "未安装" }}
              </template>
            </el-table-column>
            <el-table-column
              :label="t('operation')"
              fixed="right"
              align="right"
              width="180"
              :show-overflow-tooltip="true"
            >
              <template #default="{ row }">
                <el-button type="primary" link @click="editEvent(row.key)">{{
                  t("edit")
                }}</el-button>
   
                <el-button
                  v-if="!Object.keys(row.install_info).length"
                  type="primary"
                  link
                  @click="deleteEvent(row.key)"
                  >{{ t("delete") }}</el-button
                >
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>
<script lang="ts" setup>
import addonFile from "@/addon/tk_devtool/views/tk_devtool/addon-file/index.vue";
import { reactive, ref, toRefs, onMounted, onUnmounted, watch } from "vue";
import { addonUpload, build } from "@/addon/tk_devtool/api/tkdevtool";
import {
  getAddonDevelop,
  deleteAddonDevelop,
  addonDevelopBuild,
  addonDevelopDownload,
} from "@/app/api/tools";
import { img } from "@/utils/common";
import { t } from "@/lang";
import { ElMessageBox } from "element-plus";
import { useRouter, useRoute } from "vue-router";
import type { FormInstance } from "element-plus";

const route = useRoute();
const router = useRouter();
const pageName = route.meta.title;
const searchFormRef = ref(null);
const state = reactive({
  params: {
    // page: 1,
    // limit: 10,
    // total: 0,
    // title: '',
    search: "",
  },
  loading: false,
  data: [],
  activeName: "developmentProcess",
  active: 0,
});
const { params, data, activeName, active } = toRefs(state);

onMounted(() => {
  if (window.addonActiveName) {
    state.activeName = window.addonActiveName + "";
    window.addonActiveName = null;
  }
  getAddonDevelopFn();
});
const getAddonDevelopFn = () => {
  loading.value = true;
  getAddonDevelop(state.params)
    .then((res) => {
      state.data = res.data;
      loading.value = false;
    })
    .catch(() => {
      loading.value = false;
    });
};
const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  getAddonDevelopFn();
};
const editEvent = (key: any) => {
  router.push({ path: "/tools/addon_edit", query: { key } });
};
const linkEvent = (url: string) => {
  window.open(url, "_blank");
};
// 打包插件
const addonDevelopBuildFn = (data: any) => {
  loading.value = true;
  build(data.key)
    .then((res) => {
      loading.value = false;
      linkEvent(res.data);
    })
    .catch(() => {
      loading.value = false;
    });
};

/**
 * 删除
 */
const deleteEvent = (key: any) => {
  ElMessageBox.confirm(t("codeDeleteTips"), t("warning"), {
    confirmButtonText: t("confirm"),
    cancelButtonText: t("cancel"),
    type: "warning",
  }).then(() => {
    loading.value = true;
    deleteAddonDevelop(key)
      .then(() => {
        getAddonDevelopFn();
      })
      .catch(() => {
        loading.value = false;
      });
  });
};
const value = ref("admin");
const loading = ref(false);
const file_url = ref();

const addonUploadEvent = () => {
  if (file_url.value) {
    loading.value = true;
    addonUpload({ file_url: file_url.value }).then((res) => {
      loading.value = false;
      file_url.value = "";
    });
  }
};

// 使用watch监听file_url的变化
watch(file_url, (newVal) => {
  if (newVal) {
    // 当file_url有值时，执行addonUploadEvent
    addonUploadEvent();
  }
});
</script>


<style lang="scss" scoped>
.d-card {
  margin-top: 12px;
  width: 180px;
  text-align: center;
  background: linear-gradient(
    127deg,
    rgba(156, 156, 229, 0.1),
    #b8ffd833 70.71%
  );
  color: aliceblue;
  backdrop-filter: blur(10px);
  font-size: 18px;
  border-radius: 18px;
}
</style>
