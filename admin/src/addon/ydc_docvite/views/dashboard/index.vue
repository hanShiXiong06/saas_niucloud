<template>
  <div class="main-container">
    <el-card
      class="box-card !border-none"
      shadow="never"
      v-loading="control.loading"
    >
      <el-tabs v-model="activeName" class="demo-tabs">
        <!-- <el-tab-pane label="基础配置" name="publishConfig"></el-tab-pane> -->
        <el-tab-pane label="发布站点全局配置" name="siteConfig"></el-tab-pane>
      </el-tabs>
      <el-form
        :model="formData"
        label-width="100px"
        ref="formRef"
        :rules="formRules"
        class="page-form"
      >
        <div v-if="activeName == 'publishConfig'">
          <el-form-item label="NPM程序位置" prop="npmBin">
            <el-input v-model="formData.npmBin"></el-input>
          </el-form-item>
        </div>

        <div v-if="activeName == 'siteConfig'">
          <el-form-item label="顶部附加导航" prop="addonNavis">
            <CustomNaviFormItem
              v-model="formData.addonNavis"
            ></CustomNaviFormItem>
          </el-form-item>

          <el-card shadow="never">
            <template #header>文档页编辑链接配置</template>
            <el-form-item label="文本" prop="docPageEditLinkText">
              <el-input v-model="formData.docPageEditLinkText" />
            </el-form-item>
            <el-form-item label="链接" prop="docPageEditLink">
              <el-input v-model="formData.docPageEditLink" />
            </el-form-item>
          </el-card>

          <el-card shadow="never">
            <template #header>页脚配置</template>
            <el-form-item label="页脚文本" prop="footerText">
              <CustomNaviFormItem v-model="formData.footerText" />
              <el-alert type="info"
                >注意：目前只支持一条，多余的不显示</el-alert
              >
            </el-form-item>
            <el-form-item label="页脚版权信息" prop="footerCopyright">
              <CustomNaviFormItem v-model="formData.footerCopyright" />
              <el-alert type="info"
                >注意：目前只支持一条，多余的不显示</el-alert
              >
            </el-form-item>
          </el-card>
        </div>
      </el-form>
    </el-card>
    <div class="fixed-footer-wrap">
      <div class="fixed-footer">
        <el-button type="primary" @click="onSave(formRef)">{{
          t("save")
        }}</el-button>
        <el-button @click="back()">{{ t("cancel") }}</el-button>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, onMounted } from "vue";
import { getIndex, edit } from "@/addon/ydc_docvite/api/config";
import { t } from "@/lang";
import type { FormInstance } from "element-plus";
import CustomNaviFormItem from "@/addon/ydc_docvite/views/components/CustomNaviFormItem.vue";
import { showErrorMsg } from "@/addon/ydc_docvite//utils/message";

const activeName = ref("siteConfig");

onMounted(() => {});

const control = reactive({
  loading: false,
});

const formData: Record<string, any> = reactive({
  npmBin: "",
  addonNavis: [],
  docPageEditLinkText: "",
  docPageEditLink: "",
  footerText: [],
  footerCopyright: [],
});

const loadConfig = () => {
  control.loading = true;
  getIndex()
    .then((rsp) => {
      const data = rsp.data;
      formData.npmBin = data.npmBin ?? "";
      formData.addonNavis = data.addonNavis ?? [];
      formData.docPageEditLinkText = data.docPageEditLinkText ?? "";
      formData.docPageEditLink = data.docPageEditLink ?? "";
      formData.footerText = data.footerText ?? [];
      formData.footerCopyright = data.footerCopyright ?? [];
    })
    .finally(() => {
      control.loading = false;
    });
};

onMounted(() => {
  loadConfig();
});

const formRef = ref<FormInstance>();

// 表单验证规则
const formRules = computed(() => {
  return {
    docPageEditLink: [
      {
        pattern:
          /^(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_+.~#?&//=]*)$/,
        message: '链接无效',
        trigger: ["change", "blur"],
      },
    ],
  };
});

const onSave = async (formEl: FormInstance | undefined) => {
  if (control.loading || !formEl) return;
  await formEl.validate(async (valid) => {
    if (valid) {
      control.loading = true;
      const data = { data: formData };
      edit(data)
        .then(() => {
          control.loading = false;
          loadConfig();
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
.widgets-form-item {
  display: flex;
  justify-content: space-around;
}
.fixed-footer {
  z-index: 4 !important;
}
</style>
