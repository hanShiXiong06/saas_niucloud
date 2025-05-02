<template>
  <div class="main-container">
    <el-form :model="formData" label-width="150px" ref="ruleFormRef" :rules="rules" class="page-form"
      v-loading="loading">
      <el-card class="box-card !border-none" shadow="never">
        <div style="width: 640px" class="mb-2">
          <el-alert type="info" title="温馨提示：openai兼容接口，支持此接口的平台均可接入" :closable="false" show-icon />
        </div>
        <el-form-item label="AI对话KEY" prop="api_key">
          <el-input v-model="formData.api_key" placeholder="请输入KEY" class="input-width" show-word-limit
            clearable />
        </el-form-item>
        <el-form-item label="模型" prop="version">
          <el-input v-model="formData.version" placeholder="请输入模型" class="input-width" show-word-limit
            clearable />
        </el-form-item>
        <el-form-item label="域名" prop="host">
          <el-input v-model="formData.host" placeholder="请输入域名" class="input-width" show-word-limit
            clearable />
            <span class="text-gray-400 ml-2">这里域名需填写完整请求域名需带http请求地址</span>
        </el-form-item>
      </el-card>
    </el-form>
    <div class="fixed-footer-wrap">
      <div class="fixed-footer">
        <el-button type="primary" @click="onSave()">{{ t("save") }}</el-button>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, computed } from "vue";
import { t } from "@/lang";
import { FormInstance, ElMessage } from "element-plus";
import { getAiConfig, setAiConfig } from "@/addon/ai_humans/api/config";

const loading = ref(true);
const ruleFormRef = ref<FormInstance>();
const formData = reactive({
  api_key: "",
  host: "", 
  version: "",
});
const rules = computed(() => {
  return {
    api_key: [
      { required: true, message: '请输入KEY', trigger: 'blur' },
    ],
    host: [
      { required: true, message: '请输入请求域名', trigger: 'blur' },
    ],
    version: [
      { required: true, message: '请输入模型', trigger: 'blur' },
    ],

  }
})
const getData = async () => {
  const data = await getAiConfig();
  loading.value = false;
  for (const key in formData) {
    formData[key] = data.data[key];
  }
};
getData();
const onSave = async () => {
  await setAiConfig(formData);
  getData();
};
</script>

<style lang="scss" scoped></style>
