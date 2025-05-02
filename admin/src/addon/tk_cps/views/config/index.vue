<template>
  <div class="main-container">
    <div class="!border-none mt-4" shadow="never" style="width: 640px">
      <el-alert type="info" title="请先在渠道-微信小程序里面配置好小程序APPID、密钥和上传密钥，小程序需要关闭白名单或者放行IP；这里上传小程序会自动尝试申请插件" :closable="false"
        show-icon />
      <div class="flex ml-6 mt-6 mb-6 items-center">
        <div class="text-slate-400 text-xs">站点KEY:</div>
        <div class="text-[#1F1F1F] font-bold ml-2">{{ formData.site_key }}</div>
      </div>

      <el-button :loading="loading" class="mb-6 ml-6" type="primary" plain @click="addPlugin()">
        申请小程序插件
      </el-button>
      <el-button :loading="loading" class="mb-6 ml-6" type="primary" @click="codeUploadEvent()">
        云上传小程序
      </el-button>
    </div>
  </div>
</template>
<script lang="ts" setup>
import { reactive, ref, computed } from "vue";
import { t } from "@/lang";
import {
  getConfig,
  setConfig,
  downCode,
  addFile,
  delFile,
  codeUpload,
  addPlugin,
} from "@/addon/tk_cps/api/config";
import { FormInstance, FormRules } from "element-plus";
import { useRoute, useRouter } from "vue-router";
const route = useRoute();
const router = useRouter();
const pageName = route.meta.title;
const ruleFormRef = ref<FormInstance>();
const isAdmin = ref(false);
const loading = ref(true);
const selectedActivity = ref({});

const downCodeEvent = async () => {
  const res = await downCode();
  const fileUrl = res.data;
  const link = document.createElement("a");
  link.href = fileUrl;
  link.target = "_blank";
  link.download = "uniapp.zip";
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};
/**
 * 链接跳转
 */
const toLink = (link: any) => {
  router.push(link);
};
// 表单验证规则
const formRules = computed(() => {
  return {
    pub_id: [
      { required: true, message: "聚推客pub_id必须填写", trigger: "blur" },
    ],
    api_key: [
      { required: true, message: "聚推客apikey必须填写", trigger: "blur" },
    ],
    mapi_key: [
      { required: true, message: "蚂蚁星球apikey必须填写", trigger: "blur" },
    ],
    secret: [
      { required: true, message: "蚂蚁星球secret必须填写", trigger: "blur" },
    ],
  };
});
/**
 * 表单数据
 */
const initialFormData = {
  pub_id: "",
  api_key: "",
  mapi_key: "",
  secret: "",
  site_key: "",
};
const formData: Record<string, any> = reactive({ ...initialFormData });

const getData = async () => {
  loading.value = true;
  const data = await getConfig();
  for (const key in formData) {
    formData[key] = data.data[key];
  }
  loading.value = false;
};
getData();
/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
  if (loading.value || !formEl) return;

  await formEl.validate(async (valid) => {
    if (valid) {
      loading.value = true;
      const data = formData;
      setConfig(data)
        .then((res) => {
          loading.value = false;
        })
        .catch(() => {
          loading.value = false;
          // showDialog.value = false
        });
    }
  });
};

const codeUploadEvent = async () => {
  loading.value = true;
  try {
    await codeUpload();
    router.push("/channel/weapp/code");
  } catch (error) {
  } finally {
    loading.value = false;
  }
};
</script>

<style lang="scss" scoped></style>
