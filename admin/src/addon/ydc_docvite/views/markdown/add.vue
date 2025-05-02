<template>
  <div class="main-container">
    <el-card shadow="never" v-loading="control.loading">
      <el-card class="card !border-none mb-[15px]" shadow="never">
        <el-page-header
          :content="t('addMarkdown')"
          icon="ArrowLeft"
          @back="router.push({ path: '/ydc_docvite/markdown' })"
        />
      </el-card>

      <el-card class="box-card !border-none" shadow="never">
        <el-steps :active="activeStepCount" align-center>
          <el-step :title="t('saveLocation')" icon="Location"></el-step>
          <el-step :title="t('markdownProperty')" icon="Setting"></el-step>
          <el-step :title="t('markdownContent')" icon="Edit"></el-step>
        </el-steps>
      </el-card>
      <el-card class="box-card !border-none" shadow="never">
        <el-form
          :model="formData"
          label-width="100px"
          ref="formRef"
          :rules="formRules"
          class="page-form"
          :inline="true"
        >
          <div v-if="activeStepCount == 1">
            <VaultPathSelectTree
              title=""
              v-model="selectedVaultPath.data"
              :mode="-1"
              :enableVaultSelect="false"
            />
          </div>
          <div v-if="activeStepCount == 2">
            <el-form-item :label="t('markdownFontmatter')"  style="width: 100%">
              <CustomPropertyFormItem v-model="formData.customProperty" />
            </el-form-item>
          </div>
          <div v-if="activeStepCount == 3">
            <el-form-item :label="t('title')" prop="title"  style="width: 45%">
              <el-input
                v-model="formData.title"
                minlength="2"
                maxlength="100"
                clearable
                show-word-limit
              ></el-input>
            </el-form-item>
            <el-form-item :label="t('keywords')" prop="keywords"  style="width: 45%">
              <el-input
                v-model="formData.keywords"
                minlength="0"
                maxlength="100"
                clearable
                show-word-limit
              ></el-input>
            </el-form-item>
            <el-form-item :label="t('description')" prop="description"  style="width: 45%">
              <el-input
                v-model="formData.description"
                minlength="0"
                maxlength="100"
                clearable
                show-word-limit
              ></el-input>
            </el-form-item>
            <el-card class="editor" shadow="never">
              <MDEditor
                :content="formData.content"
                @on-confirm="onSave"
                @on-cancel="() => {}"
                :height="600"
              />
            </el-card>
          </div>
        </el-form>
      </el-card>
      <div class="fixed-footer-wrap">
        <div class="fixed-footer">
          <el-button
            v-if="activeStepCount > 1"
            type="primary"
            @click="lastStep"
            >{{ "<< " + control.lastStepText }}</el-button
          >
          <el-button
            v-if="activeStepCount < 3"
            type="primary"
            @click="nextStep"
            >{{ ">> " + control.nextStepText }}</el-button
          >
          <el-button @click="back()" type="danger">{{ t("cancel") }}</el-button>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import { ref, reactive, computed } from "vue";
import VaultPathSelectTree from "@/addon/ydc_docvite/views/components/VaultPathSelectTree.vue";
import CustomPropertyFormItem from "@/addon/ydc_docvite/views/components/CustomPropertyFormItem.vue";
import { t } from "@/lang";
import { useRouter } from "vue-router";
import { add } from "@/addon/ydc_docvite/api/markdown";
import MDEditor from "@/addon/ydc_docvite/views/components/VMarkdownEditor.vue";
import { showErrorMsg } from "@/addon/ydc_docvite/utils/message";

const router = useRouter();
const activeStepCount = ref(1);

const control = reactive({
  loading: false,
  nextStepText: t("markdownProperty"),
  lastStepText: "",
});

const nextStep = () => {
  activeStepCount.value++;
  // 1: saveLocation
  // 2: markdownProperty
  // 3: markdownContent
  if (activeStepCount.value == 2) {
    control.lastStepText = t("saveLocation");
    control.nextStepText = t("markdownContent");
  }
  if (activeStepCount.value == 3) {
    control.lastStepText = t("markdownProperty");
    control.nextStepText = "";
  }
};

const lastStep = () => {
  activeStepCount.value--;
  // 1: saveLocation
  // 2: markdownProperty
  // 3: markdownContent
  if (activeStepCount.value == 2) {
    control.lastStepText = t("saveLocation");
    control.nextStepText = t("markdownContent");
  }
  if (activeStepCount.value == 3) {
    control.lastStepText = t("markdownProperty");
    control.nextStepText = "";
  }
};

const selectedVaultPath = reactive({
  data: { pathId: 0, vaultId: 0 },
});

const formData: Record<string, any> = reactive({
  vault_id: 0,
  path_id: 0,
  title: "",
  keywords: "",
  description: "",
  content: "",
  customProperty: [],
});

const formRef: any = ref(null);

// 表单验证规则
const formRules = computed(() => {
  return {
    title: [
      { required: true, trigger: ["blur"], message: t("formTitleRequired") },
      { min: 2, max: 100, message: t("formTitleRange") },
    ],
    keywords: [{ min: 0, max: 100, message: t("formKeywordsMaxLen") }],
    description: [{ min: 0, max: 100, message: t("formDescriptionMaxLen") }],
    content: [{ min: 2, max: 20000, message: t("formContentRequired") }],
  };
});

const onSave = ({ content, attachs }: { content: string; attachs: any[] }) => {
  if (control.loading) return;
  console.debug("onSave.selectedVaultPath", selectedVaultPath);
  if (
    selectedVaultPath.data.pathId == 0 ||
    selectedVaultPath.data.vaultId == 0
  ) {
    showErrorMsg(t("formSaveLocationRequired"));
    return;
  }
  formRef?.value?.validate(async (valid: boolean) => {
    if (valid) {
      control.loading = true;
      formData.vault_id = selectedVaultPath.data.vaultId;
      formData.path_id = selectedVaultPath.data.pathId;
      formData.content = content;
      add(formData)
        .then(() => {
          control.loading = false;
          history.back();
        })
        .catch(() => {
          control.loading = false;
        });
      return;
    }

    showErrorMsg(t("formInvalid"));
  });
};

const back = () => {
  history.back();
};
</script>
<style lang="scss" scoped>
.el-form-item__content .el-check-tag {
  font-weight: unset;
}

.fixed-footer {
  z-index: 4 !important;
}
</style>
