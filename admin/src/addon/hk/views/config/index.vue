<template>
  <div class="main-container">
    <el-form :model="formData" label-width="150px" ref="ruleFormRef" :rules="rules" class="page-form"
      v-loading="loading">
      <el-card class="box-card !border-none" shadow="never">
        <div style="width: 640px" class="mb-2">
          <el-alert type="info" title="请先完善配置,否则系统无法正常使用" :closable="false" show-icon />
        </div>
        <el-form-item label="商品上架" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio :label="0" size="large">仓库中</el-radio>
            <el-radio :label="1" size="large">上架</el-radio>
          </el-radio-group>
          <span class="ml-4">同步商品后商品状态，仓库中需要手动上架产品</span>
        </el-form-item>
        <el-form-item label="商户ID" prop="userid">
          <el-input clearable v-model="formData.userid" style="width: 300px" placeholder="请输入商户ID" />
        </el-form-item>
        <el-form-item label="APIKEY" prop="userkey">
          <el-input clearable v-model="formData.userkey" placeholder="请输入APIKEY" style="width: 300px" />
        </el-form-item>
        <el-form-item label="请求域名" prop="domain">
          <el-input clearable v-model="formData.domain" style="width: 300px" placeholder="请输入请求域名" />
          <span class="ml-4 text-slate-400">域名需要加上http;如http://kaka.com</span>
        </el-form-item>
        <el-form-item label="回调地址">
          <div>{{ formData.callback_url }}</div>
          <span class="ml-4 text-red-400">请正确配置回调地址，以便及时调整产品状态</span>
        </el-form-item>
        <el-form-item label="身份证上传" prop="is_card_upload">
          <el-radio-group v-model="formData.is_card_upload">
            <el-radio :label="0" size="large">关闭</el-radio>
            <el-radio :label="1" size="large">开启</el-radio>
          </el-radio-group>
          <span class="ml-4 text-gray-400">开启身份证上传将会在提交订单时候要求上传身份证</span>
        </el-form-item>
        <el-form-item label="实名认证" prop="is_open_real">
          <el-radio-group v-model="formData.is_open_real">
            <el-radio :label="0" size="large">关闭</el-radio>
            <el-radio :label="1" size="large">开启</el-radio>
          </el-radio-group>
          <span class="ml-4 text-gray-400">开启实名认证将在用户下单时候进行实名认证，认证失败会阻止订单提交</span>
        </el-form-item>
        <el-form-item v-if="formData.is_open_real == 1" label="阿里APPCODE" prop="app_code">
          <el-input v-model="formData.app_code" placeholder="请输入APPCODE" class="input-width" show-word-limit
            clearable />
        </el-form-item>
        <el-form-item v-if="formData.is_open_real == 1" label="快速导航">
          <el-button>
            <a href="https://market.aliyun.com/apimarket/detail/cmapi00037883#sku=yuncode31883000025"
              target="_blank">购买地址</a>
          </el-button>
        </el-form-item>
        <el-form-item label="物流APPCODE" prop="express_key">
          <el-input v-model="formData.express_key" placeholder="请输入阿里物流APPCODE" class="input-width" show-word-limit
            clearable />
          <el-button class="ml-2">
            <a href="https://market.aliyun.com/apimarket/detail/cmapi00066593#sku=yuncode6059300002"
              target="_blank">购买地址</a>
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
import { getConfig, setConfig } from "@/addon/hk/api/config";
import { FormInstance, ElMessage } from "element-plus";
const loading = ref(true);
const ruleFormRef = ref<FormInstance>();
const formData = reactive({
  userid: "",
  userkey: "",
  domain: "",
  app_code: "",
  status: "",//是否上架商家端管理
  is_open_real: 0,//是否开启实名认证
  callback_url: "",
  express_key: "",//物流key
  is_card_upload: 0,//是否开启身份证上传
});
const rules = computed(() => {
  return {
    domain: [
      { required: true, message: '请输入域名', trigger: 'blur' },

    ],
    userid: [
      { required: true, message: '请输入商户ID', trigger: 'blur' },

    ],
    userkey: [
      { required: true, message: '请输入APIKEY', trigger: 'blur' },
    ],
    app_code: [
      { required: true, message: '请输入APPCODE', trigger: 'blur' },
    ],
    express_key: [
      { required: true, message: '请输入阿里物流APPCODE', trigger: 'blur' },
    ],
    status: [
      { required: true, message: '请选择商品上架状态', trigger: 'blur' },
    ],
    is_card_upload: [
      { required: true, message: '请选择是否上传身份证', trigger: 'blur' },
    ],
    is_open_real: [
      { required: true, message: '请选择是否开启实名', trigger: 'blur' },
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
