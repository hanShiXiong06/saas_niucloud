<template>
  <el-dialog v-model="showDialog" title="123盘" width="580px" :destroy-on-close="true">
    <el-form :model="formData" label-width="140px" ref="formRef" :rules="formRules" class="page-form"
      v-loading="loading">
      <el-card class="box-card !border-none" shadow="never">
        <div style="width: 520px">
          <el-alert type="info" title="本存储需使用123盘直链功能，会员/超级会员才可使用，流量费用请参以最新资费为准" :closable="false" show-icon />
        </div>
        <el-form-item label="是否启用">
          <el-radio-group v-model="formData.is_use">
            <el-radio :label="'1'">启用</el-radio>
            <el-radio :label="'0'">停用</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="clientID" prop="clientID">
          <el-input v-model="formData.clientID" placeholder="请填写client_id" class="input-width" clearable />
        </el-form-item>

        <el-form-item label="clientSecret" prop="clientSecret">
          <el-input v-model="formData.clientSecret" placeholder="请填写client_secret" class="input-width" clearable />
        </el-form-item>
        <el-form-item label="上传目录" prop="dir">
          <el-input v-model="formData.dir" placeholder="如oss,根目录下需要不存在这个目录" class="input-width" clearable />
        </el-form-item>
        <el-form-item label="域名前缀" prop="domain">
          <el-input v-model="formData.domain" placeholder="进入123盘的直链空间获取地址" class="input-width" clearable />
          <div class="text-slate-400">
            域名组成：https://vip.123pan.cn/会员uid/目录
          </div>
        </el-form-item>
        <el-form-item label="开发者权益">
          <el-radio-group v-model="formData.is_dev">
            <el-radio :label="'1'">拥有开发者权益</el-radio>
            <el-radio :label="'0'">不拥有开发者权益</el-radio>
          </el-radio-group>
          <span class="text-slate-400">注：拥有开发者权益，可以增加上传QPS</span>
        </el-form-item>

        <el-form-item label="快速导航">
          <el-button>
            <a href="https://www.123pan.com/s/Ggx9-gAmJv.html" target="_blank">123网盘注册</a>
          </el-button>

          <el-button>
            <a href="https://www.123pan.com/developer" target="_blank">开放平台申请</a>
          </el-button>
          <!-- <el-button type="primary" @click="addDriver()"> 注入驱动 </el-button> -->
        </el-form-item>
      </el-card>
    </el-form>

    <template #footer>
      <span class="dialog-footer">
        <el-button @click="showDialog = false">{{ t("cancel") }}</el-button>
        <el-button type="primary" :loading="loading" @click="confirm(formRef)">{{ t("confirm") }}</el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script lang="ts" setup>
import { ref, reactive, computed } from "vue";
import { t } from "@/lang";
import type { FormInstance } from "element-plus";
import { getStorageInfo, editStorage } from "@/app/api/sys";
import { addDriver } from "@/addon/tk_pan/api/storage";
const showDialog = ref(false);
const loading = ref(true);

/**
 * 表单数据
 */
const initialFormData = {
  storage_type: "",
  clientID: "",
  clientSecret: "",
  dir: "",
  domain: "https://vip.123pan.cn/id/dir",
  is_use: "0",
  is_dev: "0",
};
const formData: Record<string, any> = reactive({ ...initialFormData });

const formRef = ref<FormInstance>();

// 表单验证规则
const formRules = computed(() => {
  return {
    clientID: [
      { required: true, message: "client_id必须填写", trigger: "blur" },
    ],
    clientSecret: [
      { required: true, message: "client_secret必须填写", trigger: "blur" },
    ],
    dir: [{ required: true, message: "目录名称必须填写", trigger: "blur" }],
  };
});

const emit = defineEmits(["complete"]);

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

      editStorage(data)
        .then((res) => {
          loading.value = false;
          showDialog.value = false;
          emit("complete");
        })
        .catch(() => {
          loading.value = false;
          // showDialog.value = false
        });
    }
  });
};

const setFormData = async (row: any = null) => {
  loading.value = true;
  Object.assign(formData, initialFormData);
  if (row) {
    const data = await (await getStorageInfo(row.storage_type)).data;
    Object.keys(formData).forEach((key: string) => {
      if (data[key] != undefined) formData[key] = data[key];
      if (data.params[key] != undefined) formData[key] = data.params[key].value;
    });
  }
  loading.value = false;
};

defineExpose({
  showDialog,
  setFormData,
});
</script>

<style lang="scss" scoped></style>
