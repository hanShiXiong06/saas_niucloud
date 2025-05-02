<template>
  <div class="main-container">
    <el-form :model="formData" label-width="150px" ref="ruleFormRef" :rules="rules" class="page-form"
      v-loading="loading">
      <el-card class="box-card !border-none" shadow="never">
        <div style="width: 640px" class="mb-2">
          <el-alert type="info" title="温馨提示：请完成基础配置" :closable="false" show-icon />
        </div>
        <el-form-item label="别名" prop="alias_name">
          <el-input v-model="formData.alias_name" clearable placeholder="请输入别名" class="input-width" />
          <div class="ml-2 text-gray-400">如：店主</div>
        </el-form-item>
        <el-form-item label="邀请码" prop="is_share_code">
          <el-radio-group v-model="formData.is_share_code">
            <el-radio :label="0">关闭</el-radio>
            <el-radio :label="1">开启</el-radio>
          </el-radio-group>
          <span class="ml-2 text-gray-400">开启必须凭邀请码才允许开通</span>
        </el-form-item>
        <el-form-item label="邀请码" prop="share_code">
          <el-input v-model="formData.share_code" clearable placeholder="请输入邀请码" class="input-width" />
          <el-button @click="createShareCode" class="ml-2">生成邀请码</el-button>
        </el-form-item>
        <el-form-item label="广告语" prop="adv_name">
          <el-input v-model="formData.adv_name" clearable placeholder="请输入邀请码" class="input-width" />
          <span class="ml-2 text-gray-400">邀请店主语句</span>
        </el-form-item>
        <el-form-item label="加入方式" prop="join_type">
          <el-radio-group v-model="formData.join_type">
            <el-radio label="pay">在线支付</el-radio>
            <el-radio label="contact">联系客服</el-radio>
          </el-radio-group>
          <span class="ml-2 text-gray-400">在线支付直接支付就可成为店主，联系客服需客服线下手动添加或者给卡密/空码</span>
        </el-form-item>
        <template v-if="formData.join_type == 'contact'">
          <el-form-item label="联系客服二维码" prop="contact_qrcode">
            <upload-image v-model="formData.contact_qrcode" />
            <span class="ml-2 text-gray-400">联系客服二维码</span>
          </el-form-item>
          <el-form-item label="联系客服电话" prop="phone">
            <el-input v-model="formData.phone" clearable placeholder="请输入联系客服电话" class="input-width" />
            <span class="ml-2 text-gray-400">联系客服电话</span>
          </el-form-item>
        </template>
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
import { getConfig, setConfig,getShareCode } from "@/addon/tk_partner/api/config";
import { Share } from "@element-plus/icons-vue";
const createShareCode = async () => {
  const res= await getShareCode();
  formData.share_code = res.msg
}
const loading = ref(true);
const ruleFormRef = ref<FormInstance>();
const formData = reactive({
  alias_name:"店主",
  is_share_code: 0,
  share_code: "",
  adv_name:"邀请店主高额奖励",
  join_type:"pay",
  contact_qrcode:'',
  phone:'',
});
const rules = computed(() => {
  return {
    alias_name: [
      { required: true, message: '请输入名称', trigger: 'blur' },
    ],
    is_share_code: [
      { required: true, message: '请选择是否开启邀请码', trigger: 'blur' },
    ],
    share_code: [
      { required: true, message: '请输入邀请码', trigger: 'blur' },
    ],
    adv_name: [
      { required: true, message: '请输入邀请店主语句', trigger: 'blur' },
    ],
    join_type: [
      { required: true, message: '请选择加入方式', trigger: 'blur' },
    ],
    contact_qrcode: [
      { required: true, message: '请上传联系客服二维码', trigger: 'blur' },
    ],
    phone: [
      { required: true, message: '请输入联系客服电话', trigger: 'blur' },
    ],
  }
})
const getData = async () => {
  const data = await getConfig();
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
