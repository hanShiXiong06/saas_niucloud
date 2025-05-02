<template>
  <div>
    <el-dialog
      v-model="showDialog"
      :title="t('addVaultDialog')"
      width="70%"
      :destroy-on-close="true"
    >
      <el-form
        :model="formData"
        label-width="120px"
        :rules="formRules"
        ref="formRef"
      >
        <el-card shadow="never">
          <template #header> 基础属性 </template>
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
        </el-card>

        <el-card shadow="never">
          <template #header> 发布属性 </template>
          <el-form-item label="站点名称" prop="site_name" class="items-center">
            <el-input v-model="formData.site_name" />
          </el-form-item>
          <el-form-item label="站点标题" prop="site_title" class="items-center">
            <el-input v-model="formData.site_title" />
          </el-form-item>
          <el-form-item
            label="站点副标题"
            prop="site_subtitle"
            class="items-center"
          >
            <el-input v-model="formData.site_subtitle" />
          </el-form-item>
          <el-form-item label="站点logo" prop="site_logo" class="items-center">
            <upload-image v-model="formData.site_logo" :limit="1" />
          </el-form-item>
          <el-form-item
            label="首页特色栏目"
            prop="site_feature_list"
            class="items-center"
          >
            <FeatureListFormItem v-model="formData.site_feature_list" />
          </el-form-item>

          <el-card shadow="never">
            <template #header> 首页自定义内容 </template>
            <MDEditorFormItem
              v-model="formData.site_home_content"
              :height="600"
            />
          </el-card>
        </el-card>
      </el-form>

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
import { add } from "@/addon/ydc_docvite/api/vault";
import MDEditorFormItem from "@/addon/ydc_docvite/views/components/MarkdownEditorFormItem.vue";
import { t } from "@/lang";
import { showErrorMsg } from "@/addon/ydc_docvite/utils/message";
import { ref, reactive, computed } from "vue";
import FeatureListFormItem from "@/addon/ydc_docvite/views/components/FeatureListFormItem.vue";

const emit = defineEmits(["success"]);

export type DataType = {
  name: string;
  alias_name: string;
  site_name: string;
  site_title: string;
  site_subtitle: string;
  site_logo: string;
  site_home_content: string;
  site_feature_list: any[];
  site_custom_property: string;
  site_custom_scripts: any[];
};

const formData: DataType = reactive({
  name: "",
  alias_name: "",
  site_name: "",
  site_title: "",
  site_subtitle: "",
  site_logo: "",
  site_home_content: "",
  site_feature_list: [],
  site_custom_property: "",
  site_custom_scripts: [],
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
const formRef = ref();
const control = reactive({
  saveLoading: false,
});
const save = () => {
  if (control.saveLoading) return false;
  formRef?.value?.validate((valid: boolean) => {
    if (valid) {
      control.saveLoading = true;
      add(formData)
        .then(() => {
          formData.name = "";
          formData.alias_name = "";
          emit("success");
          showDialog.value = false;
        })
        .finally(() => {
          control.saveLoading = false;
        });
      return;
    }
    showErrorMsg(t("formInvalid"));
  });
};

const onSaveHomeContent = ({
  content,
}: {
  content: string;
  attachs: any[];
}) => {
  formData.site_home_content = content;
};

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
