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
        <!-- <el-card class="!border-none" shadow="never" style="width: 640px">
          <el-alert
            type="info"
            title="手机通知，开启后配置的手机号可以接收相关通知"
            :closable="false"
            show-icon
          />
        </el-card>
        <el-form-item label="">
          <el-radio-group v-model="formData.is_mobile">
            <el-radio :label="'0'">否</el-radio>
            <el-radio :label="'1'">是</el-radio>
          </el-radio-group>
          <span class="ml-4">是否开启通知</span>
        </el-form-item>
        <el-form-item class="font-bold text-xs" label="通知手机" prop="mobile">
          <el-input
            clearable
            v-model="formData.mobile"
            style="width: 300px"
            placeholder="请输入接收通知的手机号"
          />
        </el-form-item>
        <el-form-item class="font-bold text-xs" label="通知频率" prop="msg">
          <el-input
            clearable
            v-model="formData.mobile_min"
            style="width: 300px"
            placeholder="以分钟计算，默认30分钟"
          />
          <span class="ml-4"> 单位:分钟，默认30分内只通知一次,0不限制</span>
        </el-form-item> -->
        <el-card class="!border-none" shadow="never" style="width: 640px">
          <el-alert
            type="info"
            title="webhook通知,支持企业微信，飞书，钉钉机器人通知"
            :closable="false"
            show-icon
          />
        </el-card>
        <el-form-item label="">
          <el-radio-group v-model="formData.is_webhook">
            <el-radio :label="'0'">否</el-radio>
            <el-radio :label="'1'">是</el-radio>
          </el-radio-group>
          <span class="ml-4">是否开启通知</span>
        </el-form-item>

        <el-form-item
          class="font-bold text-xs"
          label="通知类型"
          prop="checktype"
        >
          <el-select
            v-model="formData.webhook_type"
            clearable
            placeholder="请选择"
          >
            <el-option key="0" label="企业微信" value="0" />
            <el-option key="1" label="飞书" value="1" />
            <el-option key="2" label="钉钉" value="2" />
          </el-select>
        </el-form-item>
        <div class="w-[400px]">
          <el-form-item
            v-if="formData.webhook_type == 0"
            class="font-bold text-xs"
            label="Webhook 地址"
            prop="action"
          >
            <el-input
              clearable
              type="textarea"
              v-model="formData.qwurl"
              class="w-60"
              placeholder="请输入webhook地址"
            />
          </el-form-item>
          <el-form-item
            v-if="formData.webhook_type == 1"
            class="font-bold text-xs"
            label="Webhook 地址"
            prop="msg"
          >
            <el-input
              type="textarea"
              clearable
              v-model="formData.fsurl"
              style="width: 300px"
              placeholder="请输入webhook地址"
            />
          </el-form-item>
          <el-form-item
            v-if="formData.webhook_type == 2"
            class="font-bold text-xs"
            label="Webhook 地址"
            prop="msg"
          >
            <el-input
              type="textarea"
              clearable
              v-model="formData.ddurl"
              class="w-60"
              placeholder="请输入webhook地址"
            />
          </el-form-item>
        </div>
        <el-form-item class="font-bold text-xs" label="通知频率" prop="msg">
          <el-input
            clearable
            v-model="formData.min"
            style="width: 200px"
            placeholder="以分钟计算，默认30分钟"
          />
          <span class="ml-4"> 单位:分钟，默认30分内只通知一次,0不限制</span>
        </el-form-item>
        <el-card class="!border-none" shadow="never" style="width: 640px">
          <el-alert
            type="info"
            title="邮箱通知,支持163邮箱和QQ邮箱"
            :closable="false"
            show-icon
          />
        </el-card>
        <el-form-item label="">
          <el-radio-group v-model="formData.is_email">
            <el-radio :label="'0'">否</el-radio>
            <el-radio :label="'1'">是</el-radio>
          </el-radio-group>
          <span class="ml-4">是否开启邮箱通知</span>
        </el-form-item>

        <el-form-item class="font-bold text-xs" label="SMTP地址" prop="action">
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
        <el-form-item
          class="font-bold text-xs flex"
          label="收件邮箱"
          prop="action"
        >
          <el-input
            clearable
            v-model="formData.email_to"
            style="width: 300px"
            placeholder="请输入接收邮件的邮箱"
          />
          <span class="ml-4">这里需要是接收具体业务通知的邮箱</span>
        </el-form-item>
        <el-form-item
          class="font-bold text-xs flex"
          label="邮箱标题"
          prop="action"
        >
          <el-input
            clearable
            v-model="formData.email_title"
            style="width: 300px"
            placeholder="请输入发送邮件标题"
          />
          <span class="ml-4">这里可以是你的公司或品牌名</span>
        </el-form-item>
        <el-form-item class="font-bold text-xs" label="通知频率" prop="msg">
          <el-input
            clearable
            v-model="formData.email_min"
            style="width: 300px"
            placeholder="以分钟计算，默认30分钟"
          />
          <span class="ml-4"> 单位:分钟，默认30分内只通知一次,0不限制</span>
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
import { getConfig, setConfig } from "@/addon/tk_notice/api/config";
import { FormInstance, ElMessage } from "element-plus";

const loading = ref(true);
const ruleFormRef = ref<FormInstance>();
const formData = reactive({
  is_webhook: "0",
  webhook_type: "0",
  qwurl: "",
  fsurl: "",
  ddurl: "",
  min: "30",
  is_email: "0",
  email_from: "",
  email_to: "",
  email_password: "",
  email_host: "smtp.qq.com",
  email_min: "",
  email_title: "",
  is_mobile: "",
  mobile: "",
  mobile_min: "",
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
  