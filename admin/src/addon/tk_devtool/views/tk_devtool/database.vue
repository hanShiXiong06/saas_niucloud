<template>
  <div class="main-container p-4">
    <el-card>
      <el-descriptions title="数据库管理操作说明" column="1">
        <el-descriptions-item label="备份数据库"
          >执行本操作会备份数据库到niucloud/backup/sql目录下</el-descriptions-item
        >
        <el-descriptions-item label="新建表"
          >执行本操作可以快速新建数据表</el-descriptions-item
        >
        <el-descriptions-item label="复制语句/导出表"
          >这里的操作是直接获取表结构和数据且已经替换好前缀,可以快速复制到插件inatll.sql</el-descriptions-item
        >
      </el-descriptions>
    </el-card>
    <el-card class="box-card !border-none" shadow="never">
      <el-button type="primary" plain @click="backupDatabase"
        >备份数据库</el-button
      >
      <el-button
        type="primary"
        @click="router.push({ path: '/tk_devtool_admin_database_edit' })"
        >新建表</el-button
      >
      <div class="mt-4">
        <el-table :data="listData" style="width: 100%">
          <el-table-column prop="name" label="数据表" width="240" />
          <el-table-column prop="comment" label="描述" width="240" />
          <el-table-column label="操作" width="480">
            <template #default="{ row }">
              <el-button type="danger" link @click="dodeleteTable(row)"
                >删除</el-button
              >
              <el-button type="primary" link @click="editEvent(row)"
                >编辑</el-button
              >
              <el-button type="primary" link @click="exportEvent(row)"
                >导出表</el-button
              >
              <el-button type="primary" link @click="exportTextEvent(row)"
                >复制语句</el-button
              >
            </template> </el-table-column
          >/>
        </el-table>
      </div>
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import {
  getTables,
  exportTable,
  deleteTable,
  backupDatabase,
  exportTableText,
} from "@/addon/tk_devtool/api/tkdevtool";
import { reactive, ref } from "vue";
import { ElMessageBox, ElMessage } from "element-plus";
import { useRouter, useRoute } from "vue-router";
import { useClipboard } from "@vueuse/core";
const router = useRouter();
const listData = ref();
const dialogVisible = ref(false);
const editEvent = (data: any) => {
  router.push("/tk_devtool_admin_database_edit?name=" + data.name);
};
const exportTextEvent = async (e) => {
  const data = await exportTableText({ name: e.name });
  copyEvent(data.data);
};
const exportEvent = async (e) => {
  const data = await exportTable({ name: e.name });
  window.open(data.data, "_blank");
};
/**
 * 复制
 */
const { copy, isSupported, copied } = useClipboard();
const copyEvent = (text: string) => {
  if (!isSupported.value) {
    ElMessage({
      message: "当前浏览器不支持一键复制",
      type: "warning",
    });
  }
  copy(text);
  ElMessage({
    message: "复制sql成功",
    type: "success",
  });
};
const dodeleteTable = async (e) => {
  try {
    await ElMessageBox.confirm(
      "确定删除数据表" + e.name + "吗?" + "---请谨慎操作---",
      "确认",
      {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }
    );
    await deleteTable({ name: e.name });
    tabelist();
  } catch (error) {}
};
const tabelist = async () => {
  const data = await getTables();
  listData.value = data.data;
};
tabelist();
</script>

<style lang="scss" scoped></style>
