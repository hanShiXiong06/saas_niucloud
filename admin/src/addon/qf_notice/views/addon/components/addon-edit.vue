<template>
  <el-dialog
    v-model="showDialog"
    :title="formData.id ? t('updateAddon') : t('addAddon')"
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
      <el-form-item :label="t('name')" prop="name">
        <el-input
          v-model="formData.name"
          clearable
          :placeholder="t('namePlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('desc')" prop="desc">
        <el-input
          v-model="formData.desc"
          clearable
          :placeholder="t('descPlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('image')">
        <upload-image v-model="formData.image" />
      </el-form-item>
      <el-form-item label="会员等级" prop="level_id">
        <el-select
          class="input-width"
          v-model="formData.level_id"
          clearable
          placeholder="不限制"
        >
          <el-option label="不限制" value="-1"></el-option>
          <el-option label="默认等级" value="0"></el-option>
          <el-option
            v-for="(item, index) in levelIdList"
            :key="index"
            :label="item['level_name']"
            :value="item['level_id']"
          />
        </el-select>
        <div class="text-gray-500 text-xs ml-2">
          默认不限制，选择将会只给当前等级会员发送消息
        </div>
      </el-form-item>
      <!-- <el-form-item :label="t('isMain')" >
                    <el-input v-model="formData.is_main" clearable :placeholder="t('isMainPlaceholder')" class="input-width" />
                </el-form-item> -->

      <el-form-item :label="t('type')" prop="type">
        <el-radio-group v-model="formData.type" placeholder="请选择类型">
          <el-radio
            v-for="(item, index) in addonType"
            :key="item['name']"
            :label="index"
          >
            {{ item["name"] }}
          </el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="模板ID" prop="template_id">
        <el-input
          v-model="formData.template_id"
          clearable
          placeholder="请填入模板ID"
          class="input-width"
        />
        <div class="text-gray-500 text-xs ml-2">
          消息模板的ID，短信填写短信厂商申请的模板ID，微信公众号填写类目模板ID
        </div>
      </el-form-item>
      <el-form-item
        label="短信内容"
        v-if="formData.type == 'sms'"
        prop="sms_content"
      >
        <el-input
          type="textarea"
          v-model="formData.sms_content"
          placeholder="顾客您好{product}已到货,您可前往{url}下单抢占名额"
          style="width: 360px"
        />
        <div class="text-red text-xs">
          '{}'内的变量为申请模板变量，请按照模板变量的格式填写,各平台申请可能会有所不同,申请模板时候自行调整即
        </div>
        <div class="text-gray-500 text-xs">
          如：顾客您好{product}已到货,您可前往{url}下单抢占名额;在下面需添加字段'product'和'url'和对应的值
        </div>
      </el-form-item>
      <el-form-item
        prop="value"
        v-if="formData.type == 'wechat' || formData.type == 'sms'"
      >
        <div class="">
          <el-button @click="addValue()" type="primary">添加变量内容</el-button>
          <block v-for="(item, index) in formData.value" :key="index">
            <div class="flex items-center mt-[5px]">
              <div class="flex items-center mt-[5px]">
                <span class="ml-[10px] mr-4"
                  >字段
                  <span class="text-red-500">*</span>
                </span>
                <el-input
                  style="width: 120px"
                  v-model="item.field"
                  placeholder="thing8"
                  class="w-[120px]"
                />
              </div>
              <div class="flex items-center mt-[5px] ml-[8px]">
                <span class="ml-[10px] mr-4"
                  >内容 <span class="text-red-500">*</span>
                </span>
                <el-input
                  mini="0"
                  style="width: 140px"
                  v-model="item.value"
                  placeholder="对应值"
                  class="w-[120px]"
                />
              </div>
              <div class="ml-8">
                <el-button plain @click="delSpec(index)" type="info"
                  >删除</el-button
                >
              </div>
            </div>
          </block>
        </div>
      </el-form-item>

      <!-- <el-form-item :label="t('isGoUrl')">
        <el-input
          v-model="formData.is_go_url"
          clearable
          :placeholder="t('isGoUrlPlaceholder')"
          class="input-width"
        />
      </el-form-item> -->

      <el-form-item
        :label="t('url')"
        v-if="formData.type == 'wechat'"
        prop="url"
      >
        <el-input
          v-model="formData.url"
          clearable
          :placeholder="t('urlPlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <!-- <el-form-item :label="t('page')">
        <el-input
          v-model="formData.page"
          clearable
          :placeholder="t('pagePlaceholder')"
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
  addAddon,
  editAddon,
  getAddonInfo,
  getAddonType,
  getWithMemberLevelList,
} from "@/addon/qf_notice/api/addon";
const levelIdList = ref([] as any[]);
const setLevelIdList = async () => {
  levelIdList.value = await (await getWithMemberLevelList({})).data;
};
setLevelIdList();
const addonType = ref();
getAddonType().then((res) => {
  if (res.data) {
    addonType.value = res.data;
  }
});
const addValue = () => {
  // 确保 feeInfo 是一个数组
  if (!Array.isArray(formData.value)) {
    formData.value = [];
  }
  formData.value.push({
    field: "",
    value: "商品上新",
  });
};
const delSpec = (e) => {
  formData.value.splice(e, 1);
};
let showDialog = ref(false);
const loading = ref(false);

/**
 * 表单数据
 */
const initialFormData = {
  id: "",
  name: "",
  desc: "",
  image: "",
  is_main: "",
  type: "",
  config_id: "",
  value: [],
  is_go_url: "",
  url: "",
  page: "",
  template_id: "",
  sms_content: "",
  level_id: "-1",
};
const formData: Record<string, any> = reactive({ ...initialFormData });

const formRef = ref<FormInstance>();

// 表单验证规则
const formRules = computed(() => {
  return {
    name: [{ required: true, message: t("namePlaceholder"), trigger: "blur" }],
    desc: [{ required: true, message: t("descPlaceholder"), trigger: "blur" }],
    image: [
      { required: true, message: t("imagePlaceholder"), trigger: "blur" },
    ],
    sms_content: [
      { required: true, message: "请配置短信模板内容", trigger: "blur" },
    ],
    template_id: [{ required: true, message: "请配置模板ID", trigger: "blur" }],
    is_main: [
      { required: true, message: t("isMainPlaceholder"), trigger: "blur" },
    ],
    type: [{ required: true, message: t("typePlaceholder"), trigger: "blur" }],
    config_id: [
      { required: true, message: t("configIdPlaceholder"), trigger: "blur" },
    ],
    value: [
      { required: true, message: t("valuePlaceholder"), trigger: "blur" },
    ],
    is_go_url: [
      { required: true, message: t("isGoUrlPlaceholder"), trigger: "blur" },
    ],
    url: [{ required: true, message: t("urlPlaceholder"), trigger: "blur" }],
    page: [{ required: true, message: t("pagePlaceholder"), trigger: "blur" }],
  };
});

const emit = defineEmits(["complete"]);

/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
  if (loading.value || !formEl) return;
  let save = formData.id ? editAddon : addAddon;

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

const setFormData = async (row: any = null) => {
  Object.assign(formData, initialFormData);
  loading.value = true;
  if (row) {
    const data = await (await getAddonInfo(row.id)).data;
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
