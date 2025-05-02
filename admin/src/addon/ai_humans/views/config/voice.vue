<template>
  <div class="main-container">
    <el-form :model="formData" label-width="150px" ref="ruleFormRef" :rules="rules" class="page-form"
      v-loading="loading">
      <el-card class="box-card !border-none" shadow="never">
        <div style="width: 640px" class="mb-2">
          <el-alert type="info" title="温馨提示：声音合成通道含Pro通道+视频合成免费通道均使用此密钥" :closable="false" show-icon />
        </div>
        <el-form-item label="壹定开放平台KEY" prop="yiding_key">
          <el-input v-model="formData.yiding_key" placeholder="请输入壹定开放平台KEY" class="input-width" show-word-limit
            clearable />
          <el-button class="ml-2">
            <a href=" https://api.yidevs.com/" target="_blank">前往注册</a>
          </el-button>
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
import { getVoiceConfig, setVoiceConfig } from "@/addon/ai_humans/api/config";

const loading = ref(true);
const ruleFormRef = ref<FormInstance>();
const formData = reactive({
  driver: "yiding", //声音合成驱动
  yiding_key: "",//壹定开放平台KEY
  channel: "free", //合成通道
});
const rules = computed(() => {
  return {
    driver: [
      { required: true, message: '请选择声音合成驱动', trigger: 'blur' },
    ],
    yiding_key: [
      { required: true, message: '请输入壹定开放平台KEY', trigger: 'blur' },
    ],
    channel: [
      { required: true, message: '请输入合成通道', trigger: 'blur' },
    ],

  }
})
const getData = async () => {
  const data = await getVoiceConfig();
  loading.value = false;
  for (const key in formData) {
    formData[key] = data.data[key];
  }
};
getData();
const onSave = async () => {
  await setVoiceConfig(formData);
  getData();
};
</script>

<style lang="scss" scoped></style>
