<template>
  <div class="main-container">
    <el-form
      :model="formData"
      label-width="140px"
      ref="formRef"
      :rules="formRules"
      class="page-form"
      v-loading="loading"
    >
      <el-card class="box-card !border-none" shadow="never">
        <el-card class="!border-none" shadow="never" style="width: 640px">
          <el-alert
            type="warning"
            title="请完善接口信息为自己联盟后台信息"
            :closable="false"
            show-icon
          />
        </el-card>

        <el-form-item label="联盟appkey" prop="appkey">
          <el-input
            v-model="formData.appkey"
            placeholder="联盟appkey"
            class="input-width"
            clearable
          />
        </el-form-item>
        <el-form-item label="联盟appsecret" prop="appsecret">
          <el-input
            v-model="formData.appsecret"
            placeholder="联盟appsecret"
            class="input-width"
            clearable
          />
        </el-form-item>
        <el-form-item label="客户分佣比" prop="fanxianratio">
          <el-input
            type="number"
            max="100"
            min="0"
            step="1"
            v-model="formData.fanxianratio"
            placeholder="客户分佣比"
            class="input-width"
            clearable
          />
          <span class="text-gray-400 ml-2">%</span>
        </el-form-item>
        <el-form-item label="结算账户" prop="js_type">
          <el-radio-group v-model="formData.js_type">
            <el-radio :label="'0'">可提现余额</el-radio>
            <el-radio :label="'1'">不可提现余额</el-radio>
            <el-radio :label="'2'">积分</el-radio>
          </el-radio-group>
          <span class="text-gray-400 ml-4"
            >这里直接结算到站点会员账户，可以配合其他应用使用</span
          >
        </el-form-item>
       
      </el-card>
    </el-form>

    <div class="fixed-footer-wrap">
      <div class="fixed-footer">
        <el-button
          type="primary"
          :loading="loading"
          @click="confirm(formRef)"
          >{{ t("confirm") }}</el-button
        >
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, computed } from "vue";
import { t } from "@/lang";
import { getBwcConfig, setBwcConfig } from "@/addon/tk_cps/api/config";
import { FormInstance, FormRules } from "element-plus";
import { useRoute, useRouter } from "vue-router";
const route = useRoute();
const router = useRouter();
const pageName = route.meta.title;
const ruleFormRef = ref<FormInstance>();
const isAdmin = ref(false);
const loading = ref(true);
const formRef = ref<FormInstance>();
const posterOptions = ref();
/**
 * 链接跳转
 */
const toLink = (link: any) => {
  router.push(link);
};
// 表单验证规则
const formRules = computed(() => {
  return {
    appkey: [{ required: true, message: "appkey必须填写", trigger: "blur" }],
    appsecret: [
      { required: true, message: "appsecret必须填写", trigger: "blur" },
    ],
    fanxianratio: [
      { required: true, message: "客户端返现比率必须填写", trigger: "blur" },
    ],
    js_type: [
      { required: true, message: "请选择结算账户类型", trigger: "blur" },
    ],
  };
});
/**
 * 表单数据
 */
const initialFormData = {
  appkey: "",
  appsecret: "",
  fanxianratio: "",
  js_type: 1,
};
const formData: Record<string, any> = reactive({ ...initialFormData });

const getData = async () => {
  loading.value = true;
  const data = await getBwcConfig();
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
      setBwcConfig(data)
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
</script>

<style lang="scss" scoped></style>
