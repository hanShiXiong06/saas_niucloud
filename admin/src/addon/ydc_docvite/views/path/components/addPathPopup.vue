<template>
  <div>
    <el-dialog
      v-model="showDialog"
      :title="t('addPathDialog')"
      width="600px"
      :destroy-on-close="true"
    >
      <el-card v-loading="control.saveLoading">
        <el-form
          :model="formData"
          label-width="90px"
          :rules="formRules"
          ref="formRef"
        >
          <el-form-item :label="t('vault')" prop="vault_id">
            <el-select
              v-model="formData.vault_id"
              size="large"
              filterable
              remote
              placeholder="搜索或选取"
              :remote-method="loadVaults"
              :loading="control.vaultsLoading"
              @change="loadVaults"
            >
              <el-option
                v-for="item in selectData.vaults"
                :key="item.id"
                :label="item.name"
                :value="item.id"
              />
            </el-select>
          </el-form-item>
          <el-form-item :label="t('parentPath')" prop="parent_id">
            <PathSelectTree
              v-model="formData.parent_id"
              :vault-id="formData.vault_id"
            />
          </el-form-item>

          <el-form-item :label="t('name')" prop="name" class="items-center">
            <el-input
              v-model="formData.name"
              maxlength="50"
              :show-word-limit="true"
            ></el-input>
          </el-form-item>
          <el-form-item
            :label="t('aliasName')"
            prop="alias_name"
            class="items-center"
          >
            <el-input
              v-model="formData.alias_name"
              maxlength="50"
              :show-word-limit="true"
            ></el-input>
          </el-form-item>
        </el-form>
      </el-card>

      <template #footer>
        <span class="dialog-footer">
          <el-button @click="showDialog = false">{{ t("cancel") }}</el-button>
          <el-button type="primary" @click="save">{{ t("confirm") }}</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script lang="ts" setup>
import { add } from "@/addon/ydc_docvite/api/path";
import { select as vaultSelectApi } from "@/addon/ydc_docvite/api/vault";
import { t } from "@/lang";
import { ref, reactive, computed, onMounted } from "vue";
import PathSelectTree from "@/addon/ydc_docvite/views/components/PathSelectTree.vue";
import { showErrorMsg } from "@/addon/ydc_docvite/utils/message";

const emit = defineEmits(["success"]);

const formRef: any = ref(null);

const formData: {
  vault_id: number;
  parent_id: number;
  name: string;
  alias_name: string;
} = reactive({
  vault_id: 0,
  parent_id: 0,
  name: "",
  alias_name: "",
});

const formRules = computed(() => {
  return {
    name: [
      {
        required: true,
        message: t("formNameRequired"),
        trigger: ["blur", "change"],
      },
      {
        pattern: /^[a-zA-Z0-9_]{2,50}$/,
        message: t("formNameInvalidRegex"),
        trigger: ["blur", "change"],
      },
    ],
    parent_id: [
      {
        required: true,
        message: t("formParentPathRequired"),
        trigger: ["blur", "change"],
      },
    ],
    alias_name: [
      {
        min: 0,
        max: 50,
        message: t("formAliasNameInvalid"),
        trigger: ["blur", "change"],
      },
    ],
  };
});

const showDialog = ref(false);

const show = () => {
  showDialog.value = true;
};

const control = reactive({
  saveLoading: false,
  vaultsLoading: false,
});

const selectData: {
  path: any[];
  vaults: any[];
} = reactive({
  path: [],
  vaults: [],
});

const loadVaults = (keywords = "") => {
  control.vaultsLoading = true;
  const params: {
    name?: string;
  } = {};
  if (keywords !== "") {
    params.name = keywords;
  }
  vaultSelectApi({ ...params })
    .then((res) => {
      selectData.vaults = res.data;
      if (formData.vault_id == 0) {
        formData.vault_id = selectData?.vaults[0]?.id;
      }
    })
    .finally(() => {
      control.vaultsLoading = false;
    });
};

const save = () => {
  if (control.saveLoading) return false;
  if (formData.vault_id == 0) {
    showErrorMsg(t("formVaultRequired"));
    return false;
  }
  if (formData.parent_id == 0) {
    showErrorMsg(t("formParentPathRequired"));
    return false;
  }
  formRef?.value.validate((valid: boolean) => {
    if (valid) {
      if (formData.parent_id < 1) {
        showErrorMsg(t("pathNeedParentId"));
        return;
      }
      control.saveLoading = true;

      add(formData)
        .then(() => {
          formData.name = ""
          formData.alias_name = ""
          formData.vault_id = 0
          formData.parent_id = 0
          emit("success");
          showDialog.value = false;
        })
        .finally(() => {
          control.saveLoading = false;
        });

      return true;
    }

    showErrorMsg(t('formInvalid'));
    return false;
  });
};

onMounted(() => {
  loadVaults();
});

defineExpose({
  showDialog,
  show,
});
</script>

<style lang="scss" scoped>
.form-item-wrap {
  margin-right: 10px !important;

  &.last-child {
    margin-right: 0 !important;
  }
}
</style>
