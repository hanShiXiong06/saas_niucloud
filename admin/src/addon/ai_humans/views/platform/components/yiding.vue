<template>
  <el-dialog v-model="showDialog" title="壹定开放平台" width="680px" :destroy-on-close="true">
    <el-form :model="formData" label-width="140px" ref="formRef" :rules="formRules" class="page-form"
      v-loading="loading">
      <div style="width: 640px" class="mb-2">
        <el-alert type="info" title="提示：请正确配置KEY及PRO视频合成通道" :closable="false" show-icon />
      </div>
      <el-form-item label="是否启用" prop="is_use">
        <el-radio-group v-model="formData.is_use">
          <el-radio label="1">{{ t("startUsing") }}</el-radio>
          <el-radio label="0">{{ t("statusDeactivate") }}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="密钥" prop="api_key">
        <el-input v-model="formData.api_key" placeholder="请输入KEY" class="input-width" show-word-limit clearable />
      </el-form-item>
      <el-form-item label="通道" prop="channel">
        <el-radio-group v-model="formData.channel">
          <el-radio label="free">免费通道</el-radio>
          <el-radio label="PRO">PRO通道</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="快速导航">
        <el-button>
          <a href="https://api.yidevs.com/" target="_blank">开放平台</a>
        </el-button>
      </el-form-item>
    </el-form>

    <template #footer>
      <span class="dialog-footer">
        <el-button @click="showDialog = false">{{ t("cancel") }}</el-button>
        <el-button type="primary" :loading="loading" @click="confirm(formRef)">{{ t("confirm") }}</el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script lang="ts" setup>
import { ref, reactive, computed } from "vue";
import { t } from "@/lang";
import type { FormInstance } from "element-plus";
import { getPlatformInfo, editPlatform } from "@/addon/ai_humans/api/platform";
import { useRoute, useRouter } from "vue-router";
import { padStart } from "lodash-es";
const route = useRoute();
const router = useRouter();
/**
 * 链接跳转
 */
const toLink = (link: any) => {
  router.push(link);
};
const showDialog = ref(false);
const loading = ref(true);

/**
 * 表单数据
 */
const initialFormData = {
  type: "",
  is_use: '0',
  api_key: "",
  channel: "free",
  site_id: "",
};
const formData: Record<string, any> = reactive({ ...initialFormData });

const formRef = ref<FormInstance>();

// 表单验证规则
const formRules = computed(() => {
  return {
    api_key: [{ required: true, message: "请输入api_key", trigger: "blur" }],
    channel: [{ required: true, message: "请选择合成通道", trigger: "blur" }],
    is_use: [{ required: true, message: "请选择是否启用", trigger: "blur" }],
  };
});

const emit = defineEmits(["complete"]);

/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
  if (loading.value || !formEl) return;

  await formEl.validate(async (valid) => {
    if (valid) {
      loading.value = true;
      formData.site_id = JSON.parse(
        localStorage.getItem("site.siteInfo")
      ).site_id;
      const data = formData;

      editPlatform(data)
        .then((res) => {
          loading.value = false;
          showDialog.value = false;
          emit("complete");
        })
        .catch(() => {
          loading.value = false;
          // showDialog.value = false
        });
    }
  });
};

const setFormData = async (row: any = null) => {
  loading.value = true;
  Object.assign(formData, initialFormData);
  if (row) {
    const data = await (await getPlatformInfo(row.type)).data;
    Object.keys(formData).forEach((key: string) => {
      if (data[key] != undefined) formData[key] = data[key];
      if (data.params[key] != undefined) formData[key] = data.params[key].value;
    });
  }
  loading.value = false;
};

defineExpose({
  showDialog,
  setFormData,
});
</script>

<style lang="scss" scoped></style>
