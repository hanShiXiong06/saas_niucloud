<template>
  <div class="main-container">
    <el-form :model="formData" label-width="150px" ref="ruleFormRef" :rules="rules" class="page-form"
      v-loading="loading">
      <el-card class="box-card !border-none" shadow="never">
        <div style="width: 640px" class="mb-2">
          <el-alert type="info" title="温馨提示：此处配置内容将会出现在自由对话界面" :closable="false" show-icon />
        </div>
        <el-form-item label="系统名称" prop="name">
          <el-input v-model="formData.name" style="width: 200px" placeholder="如:AI助理" />
        </el-form-item>
        <el-form-item label="系统LOGO" prop="logo">
          <upload-image v-model="formData.logo" />
        </el-form-item>
        <el-form-item label="连续对话" prop="continuity">
          <el-radio-group v-model="formData.continuity">
            <el-radio :label="'0'">否</el-radio>
            <el-radio :label="'1'">是</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="演示问题" prop="demo">
          <div class="flex flex-col gap-2">
            <div v-for="(item, index) in formData.demo" :key="index" class="flex items-center gap-2">
              <el-input v-model="formData.demo[index]" placeholder="请输入问题" />
              <el-button type="danger" @click="removeDemo(index)">
                <el-icon>
                  <Delete />
                </el-icon>
              </el-button>
            </div>
            <el-button type="primary" @click="addDemo">新增问题</el-button>
          </div>
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
import { getAiChatConfig, setAiChatConfig } from "@/addon/ai_humans/api/config";
import { FormInstance, ElMessage } from "element-plus";
import { ColorPicker } from "vue3-colorpicker";
import { Delete } from '@element-plus/icons-vue'
import "vue3-colorpicker/style.css";
const loading = ref(true);
const ruleFormRef = ref<FormInstance>();
const formData = reactive({
  name: "",
  logo: "",
  continuity: "0",
  demo: [],
});
const rules = computed(() => {
  return {
    name: [
      { required: true, message: '请输入系统名称', trigger: 'blur' },
    ],
    logo: [
      { required: true, message: '请上传系统LOGO', trigger: 'blur' },
    ],
    continuity: [
      { required: true, message: '请选择连续对话', trigger: 'blur' },
    ],
    demo: [
      { required: true, message: '请输入问题', trigger: 'blur' }
    ]
  }
})
const getData = async () => {
  const data = await getAiChatConfig();
  console.log(data);
  loading.value = false;
  for (const key in formData) {
    formData[key] = data.data[key];
  }
};
getData();
const onSave = async () => {
  await setAiChatConfig(formData);
  getData();
};
const addDemo = () => {
  if (formData.demo.length > 4) {
    ElMessage.error('最多只能添加5个问题')
    return
  }
  formData.demo.push('');
};

const removeDemo = (index: number) => {
  formData.demo.splice(index, 1);
};
</script>

<style lang="scss" scoped></style>
