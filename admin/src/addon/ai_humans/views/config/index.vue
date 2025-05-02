<template>
  <div class="main-container">
    <el-form :model="formData" label-width="150px" ref="ruleFormRef" :rules="rules" class="page-form"
      v-loading="loading">
      <el-card class="box-card !border-none" shadow="never">
        <div style="width: 640px" class="mb-2">
          <el-alert type="info" title="温馨提示：请配置各场景消耗点数,是否开启Pro通道仅在前端显示有效果" :closable="false" show-icon />
        </div>
        <!-- <el-form-item label="声音Pro" prop="is_voice_pro">
          <el-radio-group v-model="formData.is_voice_pro">
            <el-radio :label="0">关闭</el-radio>
            <el-radio :label="1">开启</el-radio>
          </el-radio-group>
        </el-form-item> -->
        <el-form-item label="视频Pro" prop="is_video_pro">
          <el-radio-group v-model="formData.is_video_pro">
            <el-radio :label="0">关闭</el-radio>
            <el-radio :label="1">开启</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="计量别名" prop="name">
          <el-input v-model="formData.name" clearable placeholder="请输入计量别名" class="input-width" />
          <div class="ml-2 text-gray-400">如：算力;仅在前端显示有效</div>
        </el-form-item>
        <el-form-item label="新用户赠送" prop="give_point">
          <el-input-number v-model="formData.give_point" clearable placeholder="请输入新用户赠送点数" class="input-width" :min="0"
           />
          <div class="ml-2 text-gray-400">新用户注册赠送点数</div>
        </el-form-item>
        <el-form-item label="克隆声音" prop="clone_voice">
          <el-input-number v-model="formData.clone_voice" clearable placeholder="请输入克隆声音消耗点数" class="input-width"
            :min="0"  />
          <div class="ml-2 text-gray-400">克隆声音消耗点数</div>
        </el-form-item>
        <el-form-item v-if="formData.is_voice_pro==1" label="克隆声音Pro" prop="clone_voice_pro">
          <el-input-number v-model="formData.clone_voice_pro" clearable placeholder="请输入克隆声音Pro消耗点数" class="input-width"
            :min="0" />
          <div class="ml-2 text-gray-400">克隆声音pro消耗点数</div>
        </el-form-item>
        <el-form-item label="合成声音" prop="create_voice">
          <el-input-number v-model="formData.create_voice" clearable placeholder="请输入创建声音消耗点数" class="input-width"
            :min="0"  />
          <div class="ml-2 text-gray-400">合成声音消耗点数</div>
        </el-form-item>
        <el-form-item v-if="formData.is_voice_pro==1" label="合成声音Pro" prop="create_voice_pro">
          <el-input-number v-model="formData.create_voice_pro" clearable placeholder="请输入合成声音Pro消耗点数"
            class="input-width" :min="0"/>
          <div class="ml-2 text-gray-400">合成声音消耗点数</div>
        </el-form-item>

        <el-form-item label="克隆视频" prop="clone_video">
          <el-input-number v-model="formData.clone_video" clearable placeholder="请输入克隆视频消耗点数" class="input-width"
            :min="0"/>
          <div class="ml-2 text-gray-400">克隆视频声音消耗点数</div>
        </el-form-item>
        <el-form-item v-if="formData.is_video_pro==1" label="克隆视频Pro" prop="clone_video_pro">
          <el-input-number v-model="formData.clone_video_pro" clearable placeholder="请输入克隆视频Pro消耗点数" class="input-width"
            :min="0" />
          <div class="ml-2 text-gray-400">克隆视频消耗点数</div>
        </el-form-item>
        <el-form-item label="合成视频" prop="create_video">
          <el-input-number v-model="formData.create_video" clearable placeholder="请输入合成视频消耗点数" class="input-width"
            :min="0"  />
          <div class="ml-2 text-gray-400">合成视频消耗点数，按分钟计算</div>
        </el-form-item>
        <el-form-item v-if="formData.is_video_pro==1" label="合成视频Pro" prop="create_video_pro">
          <el-input-number v-model="formData.create_video_pro" clearable placeholder="请输入合成视频Pro消耗点数" class="input-width"
            :min="0" />
          <div class="ml-2 text-gray-400">合成视频视频消耗点数，按分钟计算</div>
        </el-form-item>
        <el-form-item label="模型对话" prop="model_chat">
          <el-input-number v-model="formData.model_chat" clearable placeholder="请输入模型对话消耗点数" class="input-width"
            :min="0"/>
          <div class="ml-2 text-gray-400">使用ai大模型消耗点数</div>
        </el-form-item>
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
import { getConfig, setConfig } from "@/addon/ai_humans/api/config";

const loading = ref(true);
const ruleFormRef = ref<FormInstance>();
const formData = reactive({
  is_voice_pro: 0,
  is_video_pro: 0,
  clone_voice: 10,
  clone_voice_pro: 20,
  create_voice: 10,
  create_voice_pro: 10,
  clone_video: 10,
  clone_video_pro: 10,
  create_video: 10,
  create_video_pro: 10,
  model_chat: 10,
  name: '算力',
  give_point: 10,//新用户赠送算力

});
const rules = computed(() => {
  return {
    clone_voice: [
      { required: true, message: '请输入克隆声音消耗点数', trigger: 'blur' },
    ],
    create_voice: [
      { required: true, message: '请输入合成声音消耗点数', trigger: 'blur' },
    ],
    clone_video: [
      { required: true, message: '请输入克隆视频消耗点数', trigger: 'blur' },
    ],
    create_video: [
      { required: true, message: '请输入合成视频消耗点数', trigger: 'blur' },
    ],
    clone_voice_pro: [
      { required: true, message: '请输入克隆声音消耗点数', trigger: 'blur' },
    ],
    create_voice_pro: [
      { required: true, message: '请输入合成声音消耗点数', trigger: 'blur' },
    ],
    clone_video_pro: [
      { required: true, message: '请输入克隆视频消耗点数', trigger: 'blur' },
    ],
    create_video_pro: [
      { required: true, message: '请输入合成视频消耗点数', trigger: 'blur' },
    ],
    model_chat: [
      { required: true, message: '请输入模型对话消耗点数', trigger: 'blur' },
    ],
    name: [
      { required: true, message: '请输入计量别名', trigger: 'blur' },
    ],
    give_point: [
      { required: true, message: '请输入新用户赠送点数', trigger: 'blur' },
    ],
    is_voice_pro: [
      { required: true, message: '请选择声音Pro', trigger: 'blur' },
    ],
    is_video_pro: [
      { required: true, message: '请选择视频Pro', trigger: 'blur' },
    ]
  }
})
const getData = async () => {
  const data = await getConfig();
  loading.value = false;
  for (const key in formData) {
    formData[key] = data.data[key];
  }
};
getData();
const onSave = async () => {
  await setConfig(formData);
  getData();
};
</script>

<style lang="scss" scoped></style>
