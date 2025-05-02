<template>
  <!--平台设置-->
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div style="width: 840px" class="mb-2">
        <el-alert type="info" title="提示:下面为Pro通道配置(显示为实际计费通道，如选壹定免费通道，合成时候也是免费通道)，普通通道默认为壹定免费通道" :closable="false" show-icon />
      </div>
      <div class="mt-[20px]">
        <el-table :data="platformTableData.data" size="large" v-loading="platformTableData.loading">
          <template #empty>
            <span>{{ !platformTableData.loading ? t("emptyData") : "" }}</span>
          </template>

          <el-table-column prop="name" label="平台名称" min-width="100" :show-overflow-tooltip="true" />
          <el-table-column label="是否使用" min-width="180" align="center">
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
            <template #default="{ row, $index }">
              <el-button type="primary" link @click="editEvent(row, $index)">设置</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <template v-for="(item, index) in platformTableData.data">
        <component :is="item.component" :ref="(el) => setPlatformTypeRefs(el, index)" v-if="item.component"
          @complete="loadPlatformList()" />
      </template>
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import { defineAsyncComponent, reactive, ref } from "vue";
import { t } from "@/lang";
import { getPlatformList } from "@/addon/ai_humans/api/platform";
import { useRoute } from "vue-router";

const route = useRoute();
const pageName = route.meta.title;
const platformTypeRefs = ref([]);

const platformTableData = reactive({
  loading: true,
  data: [],
});

const modules: any = import.meta.glob("@/**/*.vue");
/**
 * 获取配置信息
 */
const loadPlatformList = () => {
  platformTableData.loading = true;
  getPlatformList()
    .then(({ data }) => {
      Object.keys(data).forEach((key: string) => {
        data[key].component &&
          (data[key].component = defineAsyncComponent(
            modules[data[key].component]
          ));
      });
      platformTableData.data = data;
      platformTableData.loading = false;
    })
    .catch(() => {
      platformTableData.loading = false;
    });
};

const setPlatformTypeRefs = (el, index) => {
  platformTypeRefs.value[index] = el;
};

loadPlatformList();
const editEvent = (data: any, index: number) => {
  platformTypeRefs.value[index].setFormData(data);
  platformTypeRefs.value[index].showDialog = true;
};
</script>

<style lang="scss" scoped></style>
