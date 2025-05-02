<template>
  <el-card class="vaultPathSelectContainer" shadow="never" v-loading="loading">
    <template #header>
      <div>{{ trans(title) }}</div>
      <div class="searchInput">
        <el-input
          type="text"
          v-model="filterText"
          :placeholder="trans('searchPathName')"
        />
      </div>
      <div class="tips">
        <el-tag class="tagVault">{{ trans("vault") }}</el-tag>
        <el-tag type="info">{{ trans("path") }}</el-tag>
        <el-tag type="success">{{ trans("aliasName") }}</el-tag>
      </div>
    </template>
    <div class="mainTree">
      <el-scrollbar style="height: 100%">
        <el-empty
          v-if="!data || data.length == 0"
          :description="trans('noData')"
          :image-size="80"
        ></el-empty>
        <div v-else class="treeBody">
          <el-tree
            ref="tree"
            :data="data"
            node-key="id"
            show-checkbox
            check-strictly
            default-expand-all
            :filter-node-method="filterNode"
            @check-change="handleCheckChange"
          >
            <template #default="{ node }">
              <span class="treeNode">
                <span>
                  <template v-if="node?.data?.is_vault">
                    <el-tag class="tagVault">{{ node.label }}</el-tag>
                    <el-tag
                      type="success"
                      v-if="node?.data?.alias_name !== ''"
                      >{{ node.data.alias_name }}</el-tag
                    >
                  </template>
                  <template v-else>
                    <el-tag type="info">{{ node.label }}</el-tag>
                    <el-tag
                      type="success"
                      v-if="node?.data?.alias_name !== ''"
                      >{{ node.data.alias_name }}</el-tag
                    >
                    <template v-if="node?.data?.parent_id == 0">
                      <el-tag
                        type="danger"
                        v-if="node?.data?.name === 'blog'"
                        >{{ trans("blogPathName") }}</el-tag
                      >
                      <el-tag
                        type="danger"
                        v-if="node?.data?.name === 'docs'"
                        >{{ trans("docsPathName") }}</el-tag
                      >
                    </template>
                  </template>
                </span>
              </span>
            </template>
          </el-tree>
        </div>
      </el-scrollbar>
    </div>
  </el-card>
</template>

<script>
import { t } from "@/lang";
import { selectTree as selectTreeApi } from "@/addon/ydc_docvite/api/vault";
export default {
  data() {
    return {
      trans: t,
      loading: false,
      filterText: "",
      data: [],
    };
  },
  name: "vaultPathSelectTree",
  emits: ["checked", "update:modelValue"],
  props: {
    title: {
      type: String,
      default: () => "saveLocation",
    },
    modelValue: {
      type: Object,
      default: () => {
        return {};
      },
    },
    selectedPathId: {
      type: Number,
      default: () => {
        return -1;
      },
    },
    enableVaultSelect: {
      type: Boolean,
      default: () => false,
    },
    // -1:获取全部根目录;0-只获取docs根目录;1-只获取blog根目录
    mode: {
      type: Number,
      default: () => -1,
    },
  },
  watch: {
    // 过滤操作
    filterText(val) {
      if (!this.data || this.data.length == 0) {
        return;
      }
      this.$refs.tree.filter(val);
    },
  },
  computed: {
    checkedItem: {
      get() {
        return this.modelValue;
      },
      set(value) {
        this.$emit("update:modelValue", value);
      },
    },
  },
  async mounted() {
    await this.loadData();
    if (this.checkedItem?.pathId != 0) {
      this.$refs?.tree?.setCheckedKeys([this.checkedItem?.pathId]);
    }
    if (this.selectedPathId !== -1) {
      this.$refs?.tree?.setCheckedKeys([this.selectedPathId]);
    }
  },
  methods: {
    async loadData() {
      try {
        this.loading = true;
        const rsp = await selectTreeApi({
          tree: 1,
          enableVaultSelect: this.enableVaultSelect ? 1 : 0,
          mode: this.mode,
        });
        this.data = rsp?.data ?? [];
        this.loading = false;
      } catch {}
    },
    filterNode(v, data) {
      if (!v) {
        return true;
      }

      return (
        data?.label?.indexOf(v) !== -1 || data?.alias_name?.indexOf(v) !== -1
      );
    },
    handleCheckChange(data, checked) {
      // console.log("handleCheckChange:", data, checked);
      if (!checked) {
        this.checkedItem = {
          vaultId: null,
          pathId: null,
        };
        return;
      }

      const newCheckItem = {};
      for (const [key, value] of Object.entries(data)) {
        newCheckItem[key] = value;
      }
      newCheckItem["vaultId"] = data?.vault_id;
      newCheckItem["pathId"] = data?.id;
      this.checkedItem = newCheckItem;
      this.$refs.tree.setCheckedKeys([data.id]);
    },
  },
};
</script>

<style scoped lang="scss">
.vaultPathSelectContainer {
  width: 100%;
  height: 94%;
  :deep(.el-tag + .el-tag) {
    margin-left: 10px;
  }
  .searchInput {
    margin-top: 10px;
  }
  .tips {
    margin-top: 10px;
  }
  .mainTree {
    margin-top: 30px;
    overflow: auto;
    width: 100%;
    height: 100%;
    .treeBody {
      margin-bottom: 30px;
      :deep(.el-tree-node > .el-tree-node__children) {
        overflow: inherit !important;
      }
    }
  }
  .tagVault {
    font-weight: bold;
    color: black;
  }
}
</style>
