<template>
  <div class="main-container">
    <el-form :model="formData" label-width="150px" ref="ruleFormRef" :rules="rules" class="page-form"
      v-loading="loading">
      <el-card class="box-card !border-none" shadow="never">
        <div style="width: 640px" class="mb-2">
          <el-alert type="info" title="温馨提示：分销相关配置" :closable="false" show-icon />
        </div>

        <el-form-item label="分销" prop="is_open_fenxiao">
          <el-radio-group v-model="formData.is_open_fenxiao">
            <el-radio :label="0">关闭</el-radio>
            <el-radio :label="1">开启</el-radio>
          </el-radio-group>
        </el-form-item>
        <template v-if="formData.is_open_fenxiao == 1">
          <el-form-item label="分销名称" prop="name">
            <el-input v-model="formData.name" placeholder="请输入分销别名" class="input-width" show-word-limit clearable />
          </el-form-item>
          <el-form-item label="分销级别" prop="fenxiao_level">
            <el-radio-group v-model="formData.fenxiao_level">
              <el-radio :label="1">一级分销</el-radio>
              <el-radio :label="2">二级分销</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="分销类型" prop="join_type">
            <el-radio-group v-model="formData.join_type">
              <el-radio :label="0">人人分销</el-radio>
              <el-radio :label="1">申请分销</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="申请价格" prop="apply_price" v-if="formData.join_type == 1">
            <el-input-number v-model="formData.apply_price" placeholder="请输入申请价格" class="input-width" show-word-limit
              clearable />
            <div class="ml-2 text-gray-400">价格为0,用户申请不需付费就可成为分销</div>
          </el-form-item>
          <el-form-item label="赠送点数" prop="give_point" v-if="formData.apply_price > 0 && formData.join_type == 1">
            <el-input-number v-model="formData.give_point" placeholder="请输入赠送点数" class="input-width" show-word-limit
              clearable />
            <div class="ml-2 text-gray-400">申请分销，且需要付费时才会赠送</div>
          </el-form-item>
          <el-form-item label="分销自购" prop="is_self">
            <el-radio-group v-model="formData.is_self">
              <el-radio :label="0">关闭</el-radio>
              <el-radio :label="1">开启</el-radio>
            </el-radio-group>
            <div v-if="formData.is_self == 1" class="ml-2 text-gray-400">开启分销自购，将会额外给分销者激励</div>
          </el-form-item>
          <el-form-item label="自购佣金比" prop="self_rate" v-if="formData.is_self == 1">
            <el-input-number v-model="formData.self_rate" placeholder="请输入自购比" class="input-width" min="0" max="99"
              show-word-limit clearable />
            <div class="ml-2 text-gray-400">百分数，如填10则代表分佣百分10%</div>
          </el-form-item>
          <el-form-item label="一级分销比例" prop="first_rate">
            <el-input v-model="formData.first_rate" placeholder="请输入一级分销比例" class="input-width" show-word-limit
              clearable />
            <div class="ml-2 text-gray-400">百分数，如填10则代表分佣百分10%</div>
          </el-form-item>
          <el-form-item label="二级分销比例" prop="second_rate" v-if="formData.fenxiao_level == 2">
            <el-input v-model="formData.second_rate" placeholder="请输入二级分销比例" class="input-width" show-word-limit
              clearable />
            <div class="ml-2 text-gray-400">百分数，如填10则代表分佣百分10%</div>
          </el-form-item>
          <el-form-item label="分销说明" prop="content">
            <div class="w-1/3">
              <editor v-model="formData.content" />
            </div>
          </el-form-item>
        </template>

      </el-card>
    </el-form>
    <div class="fixed-footer-wrap">
      <div class="fixed-footer">
        <el-button type="primary" @click="onSave()">{{ t("save") }}</el-button>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, computed } from "vue";
import { t } from "@/lang";
import { FormInstance, ElMessage } from "element-plus";
import { getFenxiaoConfig, setFenxiaoConfig } from "@/addon/ai_humans/api/config";

const loading = ref(true);
const ruleFormRef = ref<FormInstance>();
const formData = reactive({
  is_open_fenxiao: 0,//开启分销
  fenxiao_level: 2, //分销级别
  join_type: 0,//  0人人分销   1 申请
  apply_price: 0,// 申请价格
  give_point: 0,// 赠送点数
  is_self: 0,// 分销自购
  self_rate: 0,// 自购佣金比
  first_rate: 0,
  second_rate: 0,
  content: '',
  name: '分销',
});
const rules = computed(() => {
  return {
    name: [
      { required: true, message: '请输入分销别名', trigger: 'blur' },
    ],
    is_open_fenxiao: [
      { required: true, message: '请选择开启分销', trigger: 'blur' },
    ],
    join_type: [
      { required: true, message: '请选择分销类型', trigger: 'blur' },
    ],
    fenxiao_level: [
      { required: true, message: '请选择分销级别', trigger: 'blur' },
    ],
    apply_price: [
      { required: true, message: '请输入申请价格', trigger: 'blur' },
    ],
    give_point: [
      { required: true, message: '请输入赠送点数', trigger: 'blur' },
    ],
    is_self: [
      { required: true, message: '请选择分销自购', trigger: 'blur' },
    ],
    first_rate: [
      { required: true, message: '请输入一级分销比例', trigger: 'blur' },
    ],
    second_rate: [
      { required: true, message: '请输入二级分销比例', trigger: 'blur' },
    ],
    content: [
      { required: true, message: '请输入分销说明', trigger: 'blur' },
    ],
    self_rate: [
      { required: true, message: '请输入自购佣金比', trigger: 'blur' },
    ]

  }
})
const getData = async () => {
  const data = await getFenxiaoConfig();
  loading.value = false;
  for (const key in formData) {
    formData[key] = data.data[key];
  }
};
getData();
const onSave = async () => {
  await setFenxiaoConfig(formData);
  getData();
};
</script>

<style lang="scss" scoped></style>
