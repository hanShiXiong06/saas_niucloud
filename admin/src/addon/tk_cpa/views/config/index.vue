<template>
  <div class="main-container">
    <el-form :model="formData" label-width="150px" ref="ruleFormRef" :rules="rules" class="page-form"
      v-loading="loading">
      <el-card class="box-card !border-none" shadow="never">
      
        <div style="width: 640px" class="mb-2">
          <el-alert type="info" title="请先完善配置" :closable="false" show-icon />
        </div>
        <el-form-item label="站点KEY" prop="site_key" v-if="formData.site_key">
          <span class="font-bold text-[24px]">{{formData.site_key}}</span>
        </el-form-item>
        <el-form-item label="app_key" prop="app_key">
          <el-input clearable v-model="formData.app_key" style="width: 300px" placeholder="请输入app_key" />
        </el-form-item>
        <el-form-item label="app_secret" prop="app_key">
          <el-input clearable v-model="formData.app_secret" style="width: 300px" placeholder="请输入app_secret" />
        </el-form-item>
        <el-form-item label="分成比例" prop="rate">
          <el-input-number min="1" max="99" clearable v-model="formData.rate" style="width: 300px" placeholder="请输入抽成" />
          <span class="ml-2 text-gray-400">百分比，如填写80，代表用户活动实际订单佣金的80%，平台抽成20%</span>
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
import { getConfig, setConfig } from "@/addon/tk_cpa/api/config";
import { FormInstance, ElMessage } from "element-plus";
const loading = ref(true);
const ruleFormRef = ref<FormInstance>();
const formData = reactive({
  domain: "",
  app_key: "",
  app_secret: "",
  type: "",
  rate: 10,
  site_key:''
});
const rules = computed(() => {
  return {
    app_key: [
      { required: true, message: '请输入app_key', trigger: 'blur' },
    ],
    app_secret: [
      { required: true, message: '请输入app_secret', trigger: 'blur' },
    ],
    rate: [
      { required: true, message: '请输入分成比例', trigger: 'blur' },
    ]
  }
})
const getData = async () => {
  const data = await getConfig();
  console.log(data);
  loading.value = false;
  for (const key in formData) {
    formData[key] = data.data[key];
  }
};
getData();
const onSave = async () => {
  await setConfig(formData);
  getData();
};
</script>

<style lang="scss" scoped></style>
