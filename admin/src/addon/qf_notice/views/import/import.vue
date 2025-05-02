<template>
  <div class="main-container">
    <el-form
      v-loading="loading"
      element-loading-text="正在导入数据......"
      :model="formData"
      label-width="140px"
      ref="formRef"
      :rules="formRules"
      class="page-form"
    >
      <el-card class="box-card !border-none" shadow="never">
        <el-card class="!border-none" shadow="never" style="width: 640px">
          <el-alert
            type="info"
            title="说明:请按照模板格式导入xlsx文件，格式不正确会导入失败；执行后请刷新用户列表，后台依次处理上传的xlsx文件"
            :closable="false"
            show-icon
          />
        </el-card>
        <div class="flex">
          <el-button
            :loading="loading"
            class="mb-6 ml-6"
            type="primary"
            plain
            @click="downFile()"
          >
            下载模板
          </el-button>
        </div>

        <el-form-item label="上传文件" prop="file_url">
          <div class="v-[320px]">
            <upload-xlsx
              v-model="formData.file_url"
              api="sys/document/applet"
            />
          </div>
        </el-form-item>
        <el-form-item label="选择分类" prop="cat_id">
          <el-select
            class="input-width"
            v-model="formData.cat_id"
            clearable
            placeholder="请选择分类"
          >
            <el-option label="请选择" value=""></el-option>
            <el-option
              v-for="(item, index) in catIdList"
              :key="index"
              :label="item['name']"
              :value="item['id']"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="" prop="">
          <div class="flex">
            <el-button
              type="primary"
              :loading="loading"
              @click="confirm(formRef)"
              >{{ t("confirm") }}</el-button
            >
          </div>
        </el-form-item>
      </el-card>
    </el-form>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, computed } from "vue";
import { t } from "@/lang";
import { FormInstance, FormRules } from "element-plus";
import { useRoute, useRouter } from "vue-router";
import { importMember } from "@/addon/qf_notice/api/config";
import { ElMessage } from "element-plus";
import { img } from "@/utils/common";
import uploadXlsx from "@/addon/qf_notice/views/import/upload-xlsx/index.vue";
import { getWithUserCatList } from "@/addon/qf_notice/api/user";
const catIdList = ref([] as any[]);
const setCatIdList = async () => {
  catIdList.value = await (await getWithUserCatList({})).data;
};
setCatIdList();

const route = useRoute();
const router = useRouter();
const pageName = route.meta.title;
const ruleFormRef = ref<FormInstance>();
const loading = ref(false);
const formRef = ref<FormInstance>();
const downFile = () => {
  const link = document.createElement("a");
  link.href = img("addon/qf_notice/file/member.xlsx");
  link.target = "_blank";
  link.download = "会员管理列表.xlsx";
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
    file_url: [{ required: true, message: "请上传文件", trigger: "blur" }],
    cat_id: [{ required: true, message: "请选择分类", trigger: "blur" }],
  };
});
/**
 * 表单数据
 */
const initialFormData = {
  file_url: "",
  cat_id: "",
};
const formData: Record<string, any> = reactive({ ...initialFormData });
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
      console.log(data);
      importMember(data)
        .then((res) => {
          loading.value = false;
          ElMessage({
            message: "正在处理导入数据，请稍后刷新用户列表",
            type: "success",
          });
          const url = "/qf_notice/user/user";
          router.push(url);
        })
        .catch(() => {
          loading.value = false;
        });
    }
  });
};
</script>

<style lang="scss" scoped></style>
