<template>
  <el-dialog
    v-model="showDialog"
    :title="formData.id ? t('updateManageOss') : t('addManageOss')"
    width="50%"
    class="diy-dialog-wrap"
    :destroy-on-close="true"
  >
    <el-form
      :model="formData"
      label-width="120px"
      ref="formRef"
      :rules="formRules"
      class="page-form"
      v-loading="loading"
    >
      <el-form-item :label="t('siteId')">
        <el-select
          class="input-width"
          v-model="formData.site_id"
          clearable
          :placeholder="t('siteIdPlaceholder')"
          filterable
          allow-create
          default-first-option
        >
          <el-option label="请选择" value=""></el-option>
          <el-option
            v-for="(item, index) in siteIdList"
            :key="index"
            :label="item['site_name']"
            :value="item['site_id']"
          />
        </el-select>
        <el-input
          v-model="formData.site_id"
          class="w-[80px] ml-2"
          clearable
          placeholder="请输入或选择站点ID"
          style="width: 120px"
        ></el-input>
      </el-form-item>

      <el-form-item :label="t('value')" prop="value">
        <el-checkbox-group
          v-model="formData.value"
          @change="handleCheckedStorageChange"
        >
          <el-checkbox
            v-for="(item, index) in storagList"
            :key="index"
            :label="item.name"
            :value="item.storage_type"
          >
            {{ item.name }}
          </el-checkbox>
        </el-checkbox-group>
      </el-form-item>

      <!-- <el-form-item :label="t('size')">
        <el-input
          v-model="formData.size"
          clearable
          :placeholder="t('sizePlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('useSize')">
        <el-input
          v-model="formData.use_size"
          clearable
          :placeholder="t('useSizePlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('limit')">
        <el-input
          v-model="formData.limit"
          clearable
          :placeholder="t('limitPlaceholder')"
          class="input-width"
        />
      </el-form-item> -->
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
import { ref, reactive, computed, watch } from "vue";
import { useDictionary } from "@/app/api/dict";
import { t } from "@/lang";
import type { FormInstance } from "element-plus";
import {
  addManageOss,
  editManageOss,
  getManageOssInfo,
  getStorageList,
  getWithSiteList,
} from "@/addon/manage_oss/api/manageoss";

let showDialog = ref(false);
const loading = ref(false);
const storagList = ref([]);
const getStorageListData = () => {
  getStorageList({ type: 2 }).then((res) => {
    storagList.value = res.data;
  });
};
getStorageListData();

const checkAll = ref(false);
const isIndeterminate = ref(true);
const checkedStorage = ref([]);
const handleCheckedStorageChange = (value: string[]) => {
  formData.value = value;
};
/**
 * 表单数据
 */
const initialFormData = {
  id: "",
  value: [],
  size: "",
  use_size: "",
  limit: "",
  site_id: "",
};
const formData: Record<string, any> = reactive({ ...initialFormData });

const formRef = ref<FormInstance>();

// 表单验证规则
const formRules = computed(() => {
  return {
    value: [
      { required: true, message: t("valuePlaceholder"), trigger: "blur" },
    ],
    size: [{ required: true, message: t("sizePlaceholder"), trigger: "blur" }],
    use_size: [
      { required: true, message: t("useSizePlaceholder"), trigger: "blur" },
    ],
    limit: [
      { required: true, message: t("limitPlaceholder"), trigger: "blur" },
    ],
  };
});

const emit = defineEmits(["complete"]);

/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
  if (loading.value || !formEl) return;
  let save = formData.id ? editManageOss : addManageOss;

  await formEl.validate(async (valid) => {
    if (valid) {
      loading.value = true;

      let data = formData;

      save(data)
        .then((res) => {
          loading.value = false;
          showDialog.value = false;
          emit("complete");
        })
        .catch((err) => {
          loading.value = false;
        });
    }
  });
};

// 获取字典数据
const siteIdList = ref([] as any[]);
const setSiteIdList = async () => {
  siteIdList.value = await (await getWithSiteList({})).data;
};
setSiteIdList();
const setFormData = async (row: any = null) => {
  Object.assign(formData, initialFormData);
  loading.value = true;
  if (row) {
    const data = await (await getManageOssInfo(row.id)).data;
    if (data)
      Object.keys(formData).forEach((key: string) => {
        if (data[key] != undefined) formData[key] = data[key];
      });
  }
  loading.value = false;
};

// 验证手机号格式
const mobileVerify = (rule: any, value: any, callback: any) => {
  if (value && !/^1[3-9]\d{9}$/.test(value)) {
    callback(new Error(t("generateMobile")));
  } else {
    callback();
  }
};

// 验证身份证号
const idCardVerify = (rule: any, value: any, callback: any) => {
  if (
    value &&
    !/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/.test(
      value
    )
  ) {
    callback(new Error(t("generateIdCard")));
  } else {
    callback();
  }
};

// 验证邮箱号
const emailVerify = (rule: any, value: any, callback: any) => {
  if (value && !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test(value)) {
    callback(new Error(t("generateEmail")));
  } else {
    callback();
  }
};

// 验证请输入整数
const numberVerify = (rule: any, value: any, callback: any) => {
  if (!Number.isInteger(value)) {
    callback(new Error(t("generateNumber")));
  } else {
    callback();
  }
};

defineExpose({
  showDialog,
  setFormData,
});
</script>

<style lang="scss" scoped></style>
<style lang="scss">
.diy-dialog-wrap .el-form-item__label {
  height: auto !important;
}
</style>
