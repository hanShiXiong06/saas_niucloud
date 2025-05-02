<template>
  <div class="main-container">
    <el-card class="box-card">
      <el-form
        :model="formData"
        label-width="120px"
        ref="formRef"
        :rules="formRules"
        class="page-form"
        v-loading="loading"
      >
        <el-form-item label="发送对象" prop="is_main">
          <el-radio-group v-model="formData.is_main">
            <el-radio border :value="1" size="large" style="margin-right: 10px"
              >系统会员</el-radio
            >
            <el-radio border :value="0" size="large" style="margin-right: 10px"
              >用户列表</el-radio
            >
          </el-radio-group>
          <div class="text-gray-500 text-xs ml-2">
            系统会员将会发送给系统会员，用户列表将会发送给导入/手动添加的用户列表中的用户
          </div>
        </el-form-item>
        <el-form-item label="应用状态" prop="status">
          <el-radio-group v-model="formData.status">
            <el-radio :value="1" size="large" style="margin-right: 10px"
              >启用</el-radio
            >
            <el-radio :value="0" size="large" style="margin-right: 10px"
              >禁用</el-radio
            >
          </el-radio-group>
          <div class="text-gray-500 text-xs ml-2">禁用状态将无法发送信息</div>
        </el-form-item>
        <el-form-item :label="t('categoryId')" prop="category_id">
          <el-select
            class="input-width"
            v-model="formData.category_id"
            clearable
            :placeholder="t('categoryIdPlaceholder')"
          >
            <el-option label="请选择" value=""></el-option>
            <el-option
              v-for="(item, index) in categoryIdList"
              :key="index"
              :label="item['name']"
              :value="item['id']"
            />
          </el-select>
        </el-form-item>
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
        <el-form-item
          v-if="formData.is_main == 1"
          label="会员等级"
          prop="level_id"
        >
          <el-select
            class="input-width"
            v-model="formData.level_id"
            clearable
            placeholder="不限制"
          >
            <el-option label="不限制" :value="-1"></el-option>
            <el-option label="默认等级" :value="0"></el-option>
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
        <el-form-item
          v-if="formData.is_main == 0"
          label="选择分类"
          prop="cat_id"
        >
          <el-select
            class="input-width"
            v-model="formData.cat_id"
            clearable
            placeholder="请选择分类"
          >
            <el-option label="不限制" :value="0"></el-option>
            <el-option
              v-for="(item, index) in catIdList"
              :key="index"
              :label="item['name']"
              :value="item['id']"
            />
          </el-select>
        </el-form-item>

        <el-form-item
          v-if="formData.is_main == 1"
          :label="t('type')"
          prop="type"
        >
          <el-radio-group v-model="formData.type" placeholder="请选择类型">
            <block v-for="(item, index) in addonType">
              <el-radio
                style="margin-right: 10px"
                v-if="index != 'email'"
                :key="item['name']"
                :label="index"
              >
                {{ item["name"] }}
              </el-radio>
            </block>
          </el-radio-group>
        </el-form-item>
        <el-form-item
          v-if="formData.is_main == 0"
          :label="t('type')"
          prop="type"
        >
          <el-radio-group v-model="formData.type" placeholder="请选择类型">
            <block v-for="(item, index) in addonType">
              <el-radio
                style="margin-right: 10px"
                v-if="index != 'wechat'"
                :key="item['name']"
                :label="index"
              >
                {{ item["name"] }}
              </el-radio>
            </block>
          </el-radio-group>
        </el-form-item>
        <el-form-item
          v-if="formData.type == 'email'"
          label="邮件标题"
          prop="email_title"
        >
          <el-input
            v-model="formData.email_title"
            clearable
            placeholder="请输入邮件标题"
            class="input-width"
          />
          <div class="text-gray-500 text-xs ml-2">
            可输入发送的公司/品牌/LOGO名称等
          </div>
        </el-form-item>
        <el-form-item
          v-if="formData.type == 'email'"
          label="邮件描述"
          prop="email_desc"
        >
          <el-input
            v-model="formData.email_desc"
            clearable
            placeholder="请输入邮件描述"
            class="input-width"
          />
          <div class="text-gray-500 text-xs ml-2">
            发送的邮件简要概述，如：云南野生菌限时抢购
          </div>
        </el-form-item>
        <el-form-item
          v-if="formData.type == 'email'"
          label="邮件正文"
          prop="email_content"
        >
          <div class="text-gray-500 text-xs ml-2">
            本编辑器可能和您选择的邮件厂商的正文格式有所差异，正式发送前请先发送测试邮件确认格式是否正确
          </div>
        </el-form-item>
        <el-form-item v-if="formData.type == 'email'">
          <div class="w-[720px]">
            <editor v-model="formData.email_content" />
          </div>
        </el-form-item>

        <el-form-item
          v-if="formData.type == 'wechat' || formData.type == 'sms'"
          label="模板ID"
          prop="template_id"
        >
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
          <div class="text-gray-500 text-xs ml-2">
            '{}'内的变量为申请模板变量，请按照模板变量的格式填写,各平台申请可能会有所不同,申请模板时候自行调整即可
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
            <el-button @click="addValue()" type="primary"
              >添加变量内容</el-button
            >
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
      </el-form>
    </el-card>
    <div class="fixed-footer-wrap">
      <div class="fixed-footer">
        <el-button type="primary" @click="confirm(formRef)">{{
          t("save")
        }}</el-button>
        <el-button @click="back()">{{ t("cancel") }}</el-button>
      </div>
    </div>
  </div>
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
  getWithCategoryList,
} from "@/addon/qf_notice/api/addon";
import { useRoute } from "vue-router";
const route = useRoute();
const id: number = parseInt(route.query.id);
const categoryIdList = ref([]);
const setCategoryIdList = async () => {
  categoryIdList.value = await (await getWithCategoryList({})).data;
};
setCategoryIdList();
import { getWithUserCatList } from "@/addon/qf_notice/api/user";
const catIdList = ref([] as any[]);
const setCatIdList = async () => {
  catIdList.value = await (await getWithUserCatList({})).data;
};
setCatIdList();
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
  is_main: 1,
  type: "sms",
  config_id: "",
  value: [],
  is_go_url: "",
  url: "",
  page: "",
  template_id: "",
  sms_content: "",
  level_id: -1,
  cat_id: 0,
  email_content: "",
  email_title: "",
  email_desc: "",
  category_id: "",
  status: 1,
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
    category_id: [{ required: true, message: "请选择分类", trigger: "blur" }],
    level_id: [{ required: true, message: "请选择等级", trigger: "blur" }],
    cat_id: [{ required: true, message: "请选择分类", trigger: "blur" }],
    status: [{ required: true, message: "请选择状态", trigger: "blur" }],
    email_content: [
      { required: true, message: "请输入邮件正文", trigger: "blur" },
    ],
    email_title: [
      { required: true, message: "请输入邮件标题", trigger: "blur" },
    ],
    email_desc: [
      { required: true, message: "请输入邮件描述", trigger: "blur" },
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
          history.back();
        })
        .catch((err) => {
          loading.value = false;
        });
    }
  });
};

// 获取字典数据

const setFormData = async (id: number = 0) => {
  Object.assign(formData, initialFormData);
  const data = await (await getAddonInfo(id)).data;
  Object.keys(formData).forEach((key: string) => {
    if (data[key] != undefined) formData[key] = data[key];
  });
};
if (id) setFormData(id);

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
