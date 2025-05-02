<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div class="flex justify-between items-center">
        <span class="text-page-title">{{ pageName }}</span>
        <el-button type="primary" class="w-[100px]" @click="addEvent">
          {{ t("addPath") }}
        </el-button>
      </div>
      <div class="mt-[10px]">
        <el-card>
          <div style="min-height: 36px; margin-left: 10px">
            <el-select
              v-model="treeData.vault_id"
              size="large"
              filterable
              remote
              :remote-method="loadVaults"
              :placeholder="t('filterVault')"
              :loading="control.vaultsLoading"
              @change="loadPathTree"
              style="width: 50%;"
            >
              <el-option
                v-for="item in treeData.vaults"
                :key="item.id"
                :label="item.name"
                :value="item.id"
              />
            </el-select>
          </div>
        </el-card>
        <el-card class="pathTree" v-loading="control.pageLoading">
          <el-scrollbar style="height: 100%; width: 100%">
            <el-empty
              v-if="!treeData.tree || treeData.tree.length == 0"
              :description="t('noData')"
              :image-size="80"
            ></el-empty>
            <div v-else class="treeBody">
              <el-tree :data="treeData.tree" node-key="id" default-expand-all>
                <template #default="{ node }">
                  <span class="tree-node">
                    <span class="name"
                      ><el-tag type="info"
                        >{{ t("path") }}: {{ node.label }}</el-tag
                      >
                      <el-tag
                        type="success"
                        v-if="node?.data?.alias_name !== ''"
                        >{{ t("aliasName") }}:
                        {{ node.data.alias_name }}</el-tag
                      >
                      <template v-if="node?.data?.parent_id == 0">
                        <el-tag
                          type="warning"
                          v-if="node?.data?.name === 'blog'"
                          >{{ t("blogPathName") }}</el-tag
                        >
                        <el-tag
                          type="warning"
                          v-if="node?.data?.name === 'docs'"
                          >{{ t("docsPathName") }}</el-tag
                        >

                        <el-tag
                          type="danger"
                          v-if="
                            node?.data?.name === 'docs' ||
                            node?.data?.name === 'blog'
                          "
                          >{{ t("removalForbidden") }}</el-tag
                        >
                      </template>
                    </span>
                    <span class="opr">
                      <el-popconfirm
                        :title="t('editPath')"
                        @confirm="delEvent(node.data)"
                      >
                        <template #reference>
                          <el-button
                            type="primary"
                            circle
                            color="lightgrey"
                            @click.prevent="editEvent(node.data)"
                          >
                            <el-icon :size="15">
                              <Edit />
                            </el-icon>
                          </el-button>
                        </template>
                      </el-popconfirm>

                      <el-popconfirm
                        v-if="node?.data?.parent_id != 0"
                        :title="t('delPath')"
                        @confirm="delEvent(node.data)"
                      >
                        <template #reference>
                          <el-button type="danger" circle color="lightgrey">
                            <el-icon :size="15"> <Delete /> </el-icon
                          ></el-button>
                        </template>
                      </el-popconfirm>
                    </span>
                  </span>
                </template>
              </el-tree>
            </div>
          </el-scrollbar>
        </el-card>
      </div>
    </el-card>
    <AddPathPopup ref="addPathPopupRef" @success="loadPathTree()" />
    <EditPathPopup ref="editPathPopupRef" @success="loadPathTree()" />
  </div>
</template>

<script lang="ts" setup>
import { onMounted, reactive, ref } from "vue";
import { t } from "@/lang";
import { del, getIndex } from "@/addon/ydc_docvite/api/path";
import { select as vaultSelectApi } from "@/addon/ydc_docvite/api/vault";
import AddPathPopup from "./components/addPathPopup.vue";
import EditPathPopup from "./components/editPathPopup.vue";
import { useRoute } from "vue-router";

const route = useRoute();
const pageName = route.meta.title;

interface TreeDataType {
  vault_id?: number;
  vaults: any[];
  tree: any[];
}

const control = reactive({
  pageLoading: false,
  vaultsLoading: false,
});

const treeData = reactive<TreeDataType>({
  vaults: [{ id: 0, name: "还没有仓库" }],
  tree: [],
});

const loadVaults = (keywords = "", callback: any = undefined) => {
  control.vaultsLoading = true;
  const params: {
    name?: string;
  } = {};
  if (keywords !== "") {
    params.name = keywords;
  }
  vaultSelectApi({ ...params })
    .then((res) => {
      console.log(res);
      treeData.vaults = res.data;
      if (!treeData.vault_id) {
        treeData.vault_id = treeData.vaults[0]?.id ?? 0;
      }
      if (callback) {
        callback();
      }
    })
    .finally(() => {
      control.vaultsLoading = false;
    });
};

const loadPathTree = () => {
  control.pageLoading = true;

  getIndex({
    vault_id_index: treeData.vault_id,
  })
    .then((res) => {
      treeData.tree = res.data;
    })
    .finally(() => {
      control.pageLoading = false;
    });
};

onMounted(() => {
  loadVaults("", () => {
    loadPathTree();
  });
});

const addPathPopupRef: any = ref(null);
const addEvent = () => {
  addPathPopupRef?.value.show();
};

const editPathPopupRef: any = ref(null);
const editEvent = (row: any) => {
  editPathPopupRef?.value.show(row);
};

const delEvent = (data: any) => {
  del({ id: data.id })
    .then(() => {
      loadPathTree();
    })
    .finally(() => {});
};
</script>

<style lang="scss" scoped>
.pathTree {
  height: 100%;
  width: 100%;
  :deep(.el-tree) {
    min-height: 600px;
  }
  .el-tag + .el-tag {
    margin-left: 5px;
  }
  :deep(.el-tree-node__content) {
    min-height: 40px;
    margin: 2px 0;
  }
  .treeBody {
    margin-bottom: 30px;
    :deep(.el-tree-node > .el-tree-node__children) {
      overflow: inherit !important;
    }
  }
  .tree-node {
    .name {
      padding: 0 30px;
      :deep(.el-tag) {
        font-size: 15px;
        font-weight: bold;
        height: 36px;
      }
    }
  }
}
</style>
