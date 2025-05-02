<template>
  <div class="main-container">
    <el-form :model="formData" label-width="150px" ref="ruleFormRef" :rules="rules" class="page-form"
      v-loading="loading">
      <el-card class="box-card !border-none mt-[15px]" shadow="never">
        <h3 class="panel-title !text-sm">店主端小程序配置（内测中）</h3>

        <el-form-item label="小程序AppID" prop="app_id">
          <el-input v-model.trim="formData.app_id" placeholder="请输入APPID" class="input-width" clearable />
        </el-form-item>

        <el-form-item label="小程序密钥" prop="app_secret">
          <el-input v-model.trim="formData.app_secret" placeholder="请输入密钥" class="input-width" clearable />
        </el-form-item>

        <el-form-item label="上传密钥" prop="upload_private_key">
          <div class="input-width">
            <upload-file v-model="formData.upload_private_key" api="sys/document/wechat" />
          </div>
          <div class="form-tip">如果小程序代码上传开启了ip白名单设置，在ip白名单中添加ip：8.130.66.240</div>
        </el-form-item>

      </el-card>
    </el-form>
    <div class="fixed-footer-wrap">
      <div class="fixed-footer">
        <!-- <el-button type="primary">即将开放（内测中）</el-button> -->
        <el-button type="primary" @click="onSave()">{{ t("save") }}</el-button>
        <el-button type="primary" @click="uploadshow = true">上传小程序</el-button>
      </div>
    </div>
  </div>
  <el-dialog v-model="uploadshow" title="店主端小程序上传" width="30%">
    <el-form :model="formData" label-width="150px" ref="ruleFormRef" :rules="rules" class="page-form"
      v-loading="loading">
      <el-form-item label="版本号" prop="version">
        <el-input v-model.trim="version" placeholder="请输入版本号" class="input-width" clearable />
        <el-button type="primary" @click="onUpload()" :loading="uploading" :disabled="uploading">
          {{ uploading ? '上传中...' : '确认上传' }}
        </el-button>
      </el-form-item>
      <el-form-item label="" prop="upload_private_key">
        <div class="form-tip">版本号格式如1.0.0</div>
      </el-form-item>
    </el-form>
  </el-dialog>
</template>

<script lang="ts" setup>
import { reactive, ref, computed } from "vue";
import { t } from "@/lang";
import { FormInstance, ElMessage } from "element-plus";
import { getWeappConfig, setWeappConfig, weappVersion } from "@/addon/tk_partner/api/config";
import { Share } from "@element-plus/icons-vue";
import { useRoute, useRouter } from "vue-router";
const route = useRoute();
const router = useRouter();
const loading = ref(true);
const ruleFormRef = ref<FormInstance>();
const version = ref('1.0.0');
const uploadshow = ref(false);
const uploading = ref(false); // 添加上传状态
const onUpload = async () => {
  uploading.value = true; // 开始上传，设置为加载状态
  try {
    await weappVersion({ version: version.value });
    router.push("/channel/weapp/code");
    uploadshow.value = false;
  } catch (error) {
    ElMessage.error('上传失败');
  } finally {
    uploading.value = false; // 上传结束，取消加载状态
  }
};
const formData = reactive({
  app_id: "",
  app_secret: "",
  upload_private_key: ""
});
const rules = computed(() => {
  return {
    app_id: [
      { required: true, message: '请输入appid', trigger: 'blur' },
    ],
    app_secret: [
      { required: true, message: '请输入appsecret', trigger: 'blur' },
    ],
    upload_private_key: [
      { required: true, message: '请上传私钥', trigger: 'blur' },
    ]
  }
})
const getData = async () => {
  const data = await getWeappConfig();
  loading.value = false;
  for (const key in formData) {
    formData[key] = data.data[key];
  }
};
getData();
const onSave = async () => {
  await setWeappConfig(formData);
  getData();
};
</script>

<style lang="scss" scoped></style>
