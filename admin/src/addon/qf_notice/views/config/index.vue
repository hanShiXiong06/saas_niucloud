<template>
  <div class="main-container">
    <el-form
      :model="formData"
      label-width="150px"
      ref="ruleFormRef"
      :rules="rules"
      class="page-form"
      v-loading="loading"
    >
      <el-card class="box-card !border-none" shadow="never">
        <el-form-item label="短信参数控制" prop="is_sms_content">
          <el-radio-group v-model="formData.is_sms_content">
            <el-radio border :value="1" size="large" style="margin-right: 10px"
              >开启</el-radio
            >
            <el-radio border :value="0" size="large" style="margin-right: 10px"
              >关闭</el-radio
            >
          </el-radio-group>
          <div class="text-gray-500 text-xs ml-2">
            开启会传递'sms_content'参数（部分通道需要重新计算模板），目前使用短信宝发送需开启，其他渠道请关闭
          </div>
        </el-form-item>
        <el-alert
          type="info"
          title="温馨提示：需开启SMTP服务并配置正确下面信息才能发送邮件"
          :closable="false"
          show-icon
        />

        <el-form-item
          class="font-bold text-xs mt-4"
          label="SMTP地址"
          prop="action"
        >
          <el-input
            clearable
            v-model="formData.email_host"
            style="width: 300px"
            placeholder="请输入SMTP服务器地址"
          />
          <el-select
            v-model="formData.email_host"
            clearable
            class="input-item ml-4"
          >
            <el-option label="QQ邮箱" value="smtp.qq.com"></el-option>
            <el-option label="163邮箱" value="smtp.163.com"></el-option>
          </el-select>
          <span class="ml-4">其他邮箱需要支持SMTP,465端口发送</span>
        </el-form-item>

        <el-form-item
          class="font-bold text-xs flex"
          label="授权码"
          prop="action"
        >
          <el-input
            clearable
            v-model="formData.email_password"
            style="width: 300px"
            placeholder="请输入SMTP授权码/密码"
          />
          <span class="ml-4">SMTP开通时候邮箱授权码或者密码，非登录密码</span>
        </el-form-item>
        <el-form-item
          class="font-bold text-xs flex"
          label="发件邮箱"
          prop="action"
        >
          <el-input
            clearable
            v-model="formData.email_from"
            style="width: 300px"
            placeholder="请输入发送邮件的邮箱"
          />
          <span class="ml-4">这里需要SMTP邮箱保持一致</span>
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
import { reactive, ref } from "vue";
import { t } from "@/lang";
import { getConfig, setConfig } from "@/addon/qf_notice/api/config";
import { FormInstance, ElMessage } from "element-plus";
const loading = ref(true);
const ruleFormRef = ref<FormInstance>();
const formData = reactive({
  email_from: "",
  email_password: "",
  email_host: "smtp.qq.com",
  is_sms_content: 0,
});
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
