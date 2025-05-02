<template>
    <el-dialog
      v-model="showDialog"
      title="一号通短信"
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
        <el-form-item :label="t('isUse')">
          <el-radio-group v-model="formData.is_use">
            <el-radio :label="1">{{ t("startUsing") }}</el-radio>
            <el-radio :label="0">{{ t("statusDeactivate") }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="access_key" prop="access_key">
          <el-input
            v-model="formData.access_key"
            placeholder="access_key一号通后台应用管理获得APPID"
            class="input-width"
            clearable
          />
        </el-form-item>
  
        <el-form-item label="secret_key" prop="secret_key">
          <el-input
            v-model="formData.secret_key"
            placeholder="secret_key一号通后台应用管理获得AppSecret"
            class="input-width"
            clearable
          />
        </el-form-item>
        <el-form-item label="常用导航">
          <el-button>
            <a href="https://api.crmeb.com/" target="_blank">打开一号通后台</a>
          </el-button>
          <el-button @click="toLink('/setting/notice/template')">
            设置模板
            <span class="ml-2 relative flex h-3 w-3 mb">
              <span
                class="animate-ping absolute inline-flex h-full w-full rounded-full bg-sky-400 opacity-75"
              ></span>
              <span
                class="relative inline-flex rounded-full h-3 w-3 bg-sky-400"
              ></span>
            </span>
          </el-button>
        </el-form-item>
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
  import { getSmsInfo, editSms } from "@/app/api/notice";
  import { useRoute, useRouter } from "vue-router";
  const route = useRoute();
  const router = useRouter();
  /**
   * 链接跳转
   */
  const toLink = (link: any) => {
    router.push(link);
  };
  const showDialog = ref(false);
  const loading = ref(true);
  
  /**
   * 表单数据
   */
  const initialFormData = {
    sms_type: "",
    is_use: "",
    access_key: "",
    secret_key: "",
  };
  const formData: Record<string, any> = reactive({ ...initialFormData });
  
  const formRef = ref<FormInstance>();
  
  // 表单验证规则
  const formRules = computed(() => {
    return {
        access_key: [
            { required: true, message: 'access_key必须填写', trigger: 'blur' }
        ],
        secret_key: [
            { required: true, message: 'secret_key必须填写', trigger: 'blur' }
        ]
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
  
        editSms(data)
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
      const data = await (await getSmsInfo(row.sms_type)).data;
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
    