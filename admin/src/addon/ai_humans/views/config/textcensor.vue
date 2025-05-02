<template>
  <div class="main-container">
    <el-card>
      <div style="width: 640px" class="mb-2">
        <el-alert
          type="warning"
          title="温馨提示：开启后相关内容会先经过百度内容审核接口审核，审核通过后才会进行下一步操作"
          :closable="false"
          show-icon
        />
      </div>
      <el-form
        :model="formData"
        label-width="150px"
        ref="ruleFormRef"
        :rules="formRules"
        class="page-form"
        v-loading="loading"
      >
    
        <el-form-item label="安全审核" prop="create_audit">
          <el-radio-group v-model="formData.create_audit">
            <el-radio :label="'0'">关闭</el-radio>
            <el-radio :label="'1'">开启</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="api_key" prop="api_key">
          <el-input
            v-model="formData.api_key"
            placeholder="请输入api_key"
            class="input-width"
            show-word-limit
            clearable
          />
        </el-form-item>
        <el-form-item label="secret_key" prop="secret_key">
          <el-input
            v-model="formData.secret_key"
            placeholder="请输入secret_key"
            class="input-width"
            show-word-limit
            clearable
          />
        </el-form-item>
        <el-form-item label="快速导航">
          <el-button>
            <a
              href="https://cloud.baidu.com/solution/censoring?track=search"
              target="_blank"
              >立即购买</a
            >
          </el-button>
        </el-form-item>
      </el-form>
      <div class="fixed-footer-wrap">
        <div class="fixed-footer">
          <el-button type="primary" @click="onSave()">{{
            t("save")
          }}</el-button>
        </div>
      </div>
    </el-card>
  </div>
</template>
  
  <script lang="ts" setup>
import { reactive, ref, computed } from "vue";
import { t } from "@/lang";
import {
  getTextCensorConfig,
  setTextCensorConfig,
} from "@/addon/ai_humans/api/config";
import { FormInstance, ElMessage } from "element-plus";

const loading = ref(true);
const ruleFormRef = ref<FormInstance>();
const formData = reactive({
  api_key: "",
  secret_key: "",
  send_audit: "0",
  create_audit: "0",
});
// 表单验证规则
const formRules = computed(() => {
  return {
    api_key: [{ required: true, message: "请输入api_key", trigger: "blur" }],
    secret_key: [
      { required: true, message: "请输入secret_key", trigger: "blur" },
    ],
    send_audit: [
      { required: true, message: "请选择是否开启审核", trigger: "blur" },
    ],
    create_audit: [
      { required: true, message: "请选择是否开启审核", trigger: "blur" },
    ],
  };
});

const getData = async () => {
  const data = await getTextCensorConfig();
  console.log(data);
  loading.value = false;
  for (const key in formData) {
    formData[key] = data.data[key];
  }
};
getData();
const onSave = async () => {
  await setTextCensorConfig(formData);
  getData();
};
</script>
  
  <style lang="scss" scoped></style>
  