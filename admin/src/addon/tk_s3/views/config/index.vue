<template>
  <el-dialog
    v-model="showDialog"
    title="S3存储"
    width="580px"
    :destroy-on-close="true"
  >
    <el-form
      :model="formData"
      label-width="140px"
      ref="formRef"
      :rules="formRules"
      class="page-form"
      v-loading="loading"
    >
      <el-card class="box-card !border-none" shadow="never">
        <div style="width: 520px">
          <el-alert
            type="info"
            title="理论上兼容S3协议的存储厂商均可使用本方案接入，部分厂商可能需要二次适配"
            :closable="false"
            show-icon
          />
        </div>
        <el-form-item label="是否启用">
          <el-radio-group v-model="formData.is_use">
            <el-radio :label="'1'">启用</el-radio>
            <el-radio :label="'0'">停用</el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="bucket" prop="bucket">
          <el-input
            v-model="formData.bucket"
            placeholder="请填写存储桶名称"
            class="input-width"
            clearable
          />
          <div class="ml-2 text-[#666]">存储桶名称，一般由用户自定义</div>
        </el-form-item>

        <el-form-item label="region" prop="region">
          <el-input
            v-model="formData.region"
            placeholder="请填写regin"
            class="input-width"
            clearable
          />
          <div class="ml-2 text-[#666]">
            一般为字母组合，不同厂商请核对s3兼容的地域编码
          </div>
        </el-form-item>
        <el-form-item label="key" prop="key">
          <el-input
            v-model="formData.key"
            placeholder="请填写key"
            class="input-width"
            clearable
          />
          <div class="ml-2 text-[#666]">接口的key,部分厂商为appid或者id</div>
        </el-form-item>
        <el-form-item label="secret" prop="secret">
          <el-input
            type="password"
            v-model="formData.secret"
            placeholder="请填写secret"
            class="input-width"
            clearable
          />
          <div class="ml-2 text-[#666]">接口的密钥</div>
        </el-form-item>
        <el-form-item label="endpoint" prop="endpoint">
          <el-input
            v-model="formData.endpoint"
            placeholder="请填写endpoint"
            class="input-width"
            clearable
          />
          <div class="ml-2 text-[#666]">https://或http://开头</div>
        </el-form-item>
        <el-form-item label="空间域名" prop="domain">
          <el-input
            v-model="formData.domain"
            placeholder="请填写空间域名"
            class="input-width"
            clearable
          />
          <div class="ml-2 text-[#666]">
            https://或http://开头,服务厂商分配的子域名或绑定的自定义域名
          </div>
        </el-form-item>
      </el-card>
    </el-form>

    <template #footer>
      <span class="dialog-footer">
        <el-button @click="showDialog = false">{{ t("cancel") }}</el-button>
        <el-button
          type="primary"
          :loading="loading"
          @click="confirm(formRef)"
          >{{ t("confirm") }}</el-button
        >
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
  is_use: "0",
  bucket: "",
  region: "",
  key: "",
  secret: "",
  endpoint: "",
  domain: "",
};
const formData: Record<string, any> = reactive({ ...initialFormData });

const formRef = ref<FormInstance>();

// 表单验证规则
const formRules = computed(() => {
  return {
    bucket: [{ required: true, message: "bucket必须填写", trigger: "blur" }],
    region: [{ required: true, message: "region必须填写", trigger: "blur" }],
    key: [{ required: true, message: "key必须填写", trigger: "blur" }],
    secret: [{ required: true, message: "secret必须填写", trigger: "blur" }],
    endpoint: [
      { required: true, message: "endpoint必须填写", trigger: "blur" },
    ],
    domain: [{ required: true, message: "空间域名必须填写", trigger: "blur" }],
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
