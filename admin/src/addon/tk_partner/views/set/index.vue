<template>
  <el-card class="box-card mt-[15px] !border-none" shadow="never">
    <div style="width: 840px" class="mb-2">
      <el-alert type="info" title="温馨提示：请合理填写相关应用场景得配置信息" :closable="false" show-icon />
    </div>
    <div v-for="item in partnerDict">
      <component :is="item.component" v-model="formData[item.key]" ref="partnerRefs" v-if="item.component" />
    </div>
    <div class="fixed-footer-wrap">
      <div class="fixed-footer">
        <el-button type="primary" :loading="loading" @click="save()">保存</el-button>
      </div>
    </div>
  </el-card>
</template>

<script lang="ts" setup>
import { ref, defineAsyncComponent } from 'vue'
import { getPartnerDict } from "@/addon/tk_partner/api/partner";
import { getPartnerCommissionConfig, setPartnerCommissionConfig } from "@/addon/tk_partner/api/config";
import { ElMessage } from 'element-plus';
const modules: any = import.meta.glob('@/**/*.vue')
const partnerDict = ref([]);
const loading = ref(false)
getPartnerDict().then(({ data }) => {
  Object.keys(data).forEach((key: string) => {
    data[key].component && (data[key].component = defineAsyncComponent(modules[data[key].component]))
  })
  partnerDict.value = data
})
const formData = ref()
getPartnerCommissionConfig().then((res: any) => {
    formData.value = res.data
})
const save = async () => {
  console.log(formData.value)
  const data = {
    data: formData.value
  }
  await setPartnerCommissionConfig(data)
}

</script>

<style lang="scss" scoped></style>
