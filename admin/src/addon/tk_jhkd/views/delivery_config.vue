<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div class="flex justify-between items-center">
        <span class="text-page-title">{{ pageName }}</span>
      </div>
      <div class="mt-[20px]">
        <el-table :data="DeliveryTableData.data" size="large" v-loading="DeliveryTableData.loading">
          <template #empty>
            <span>{{ !DeliveryTableData.loading ? t("emptyData") : "" }}</span>
          </template>

          <el-table-column prop="name" label="渠道" min-width="100" :show-overflow-tooltip="true" />
          <el-table-column label="状态" min-width="180" align="center">
            <template #default="{ row }">
              <el-tag class="ml-2" type="success" v-if="row.is_use == 1">{{
                t("statusNormal")
              }}</el-tag>
              <el-tag class="ml-2" type="error" v-if="row.is_use == 0">{{
                t("statusDeactivate")
              }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column :label="t('operation')" align="right" fixed="right" width="100">
            <template #default="{ row }">
              <el-button type="primary" link @click="editEvent(row)">设置</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <yunyang ref="yunyangDialog" @complete="loadDeliveryList()" />
      <yida ref="yidaDialog" @complete="loadDeliveryList()" />
      <xinda ref="xindaDialog" @complete="loadDeliveryList()" />
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref } from "vue";
import { t } from "@/lang";
import { getDeliveryList } from "@/addon/tk_jhkd/api/delivery";
import yida from "@/addon/tk_jhkd/views/components/yida.vue";
import yunyang from "@/addon/tk_jhkd/views/components/yunyang.vue";
import xinda from "@/addon/tk_jhkd/views/components/xinda.vue";
import { useRoute } from "vue-router";

const route = useRoute();
const pageName = route.meta.title;

const yidaDialog: Record<string, any> | null = ref(null);

const yunyangDialog: Record<string, any> | null = ref(null);
const xindaDialog: Record<string, any> | null = ref(null);
const DeliveryTableData = reactive({
  loading: true,
  data: [],
});

/**
 * 获取配置信息
 */
const loadDeliveryList = () => {
  DeliveryTableData.loading = true;
  getDeliveryList()
    .then((res) => {
      DeliveryTableData.data = res.data;
      DeliveryTableData.loading = false;
    })
    .catch(() => {
      DeliveryTableData.loading = false;
    });
};

loadDeliveryList();
const editEvent = (data: any) => {
  console.log(data)
  eval(data.delivery_type + "Dialog.value.setFormData(data)");
  eval(data.delivery_type + "Dialog.value.showDialog = true;");
};
</script>

<style lang="scss" scoped></style>