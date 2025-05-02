<template>
  <div class="main-container p-4">
    <el-card>
      <el-descriptions title="数据表编辑/新增使用说明" column="1">
        <el-descriptions-item label="字段id"
          >如果存在/添加字段id,默认会设置为主键并自动递增</el-descriptions-item
        >
        <el-descriptions-item label="数据库名称"
          >需要填写完整的名称包含前缀</el-descriptions-item
        >
        <el-descriptions-item label="温馨提示"
          >数据表操作属于敏感操作，操作前请随时做好数据备份，不可完全依赖，部分字段未兼容请注意甄别</el-descriptions-item
        >
      </el-descriptions>
    </el-card>
    <el-card class="mt-4">
      <div class="flex">
        <div>
          <span class="text-[#7a7a7a] font-thin text-sm"> 数据表名称 </span>
          <el-input
            v-if="name == ''"
            v-model="formData.name"
            class="w-52 mt-2"
          ></el-input>
          <el-input
            v-if="name !== ''"
            disabled="true"
            v-model="formData.name"
            class="w-52 mt-2"
          ></el-input>
        </div>
        <div class="ml-12">
          <span class="text-[#7a7a7a] font-thin text-sm"> 描述 </span>
          <el-input v-model="formData.comment" class="w-52 mt-2"></el-input>
        </div>
      </div>
      <el-button class="mt-8" type="primary" @click="addRow"
        >新增字段</el-button
      >
      <el-card class="box-card !border-none" shadow="never">
        <div class="mt-4">
          <el-table
            :data="formData.fields"
            stripe
            style="width: 100%"
            :editable="true"
          >
            <el-table-column prop="name" label="字段" width="220">
              <template #default="scope">
                <input
                  type="text"
                  autosize
                  minlength="24"
                  v-model="scope.row.name"
                />
              </template>
            </el-table-column>
            <el-table-column prop="comment" label="描述" width="220">
              <template #default="scope">
                <input
                  type="text"
                  autosize
                  minlength="24"
                  v-model="scope.row.comment"
                />
              </template>
            </el-table-column>
            <el-table-column prop="type" label="类型" width="220">
              <template #default="scope">
                <el-select
                  v-model="scope.row.type"
                  placeholder="Select"
                  class="w-44"
                >
                  <el-option
                    v-for="item in typeOptions"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                    :disabled="item.disabled"
                  />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column prop="length" label="长度" width="120">
              <template #default="scope">
                <input
                  type="text"
                  autosize
                  width="8"
                  v-model="scope.row.length"
                />
              </template>
            </el-table-column>
            <el-table-column prop="not_null" label="不为空" width="120">
              <template #default="scope">
                <el-switch v-model="scope.row.not_null" />
              </template>
            </el-table-column>
            <el-table-column label="操作" width="360">
              <template #default="{ row }">
                <el-button type="primary" link @click="deleteRow(index)"
                  >删除</el-button
                >
              </template> </el-table-column
            >/>
          </el-table>
        </div>
      </el-card>
    </el-card>

    <div class="fixed-footer-wrap">
      <div class="fixed-footer">
        <el-button @click="back()">返回</el-button>
        <el-button type="primary" @click="onSave()">保存</el-button>
        <!-- <el-button type="primary" @click="goCurd()">生成代码</el-button> -->
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { getTableInfo, updateTable } from "@/addon/tk_devtool/api/tkdevtool";
import { reactive, ref } from "vue";
import { ElMessageBox } from "element-plus";
import { useRoute, useRouter } from "vue-router";
const route = useRoute();
const router = useRouter();
const name = route.query.name || "";
const formData = reactive({
  name: "",
  fields: [],
  comment: "",
  type: 0,
});
const goCurd = async () => {
  formData.type = 1;
  const data = await updateTable(formData);
  router.push("/tk_devtool_code_edit?id=" + data.data);
};
const back = () => {
  router.push("/tk_devtool_admin_database");
};
const onSave = async () => {
  await updateTable(formData);
};
const typeOptions = [
  {
    value: "int",
    label: "int",
  },
  {
    value: "varchar",
    label: "varchar",
  },
  {
    value: "text",
    label: "text",
  },
  {
    value: "longtext",
    label: "longtext",
  },
  {
    value: "datatime",
    label: "datatime",
  },
];
const deleteRow = (index) => {
  formData.fields.splice(index, 1);
};
const addRow = () => {
  formData.fields.push({
    name: "请修改为您的字段", // 新行的字段名
    type: "varchar", // 新行的类型
    comment: "默认描述", // 字段描述
    length: "13", // 新行的长度
    not_null: false, // 新行的不为空
  });
};
const setFormData = async (name) => {
  const data = await getTableInfo({ name: name });
  Object.assign(formData, data.data);
};
if (name) setFormData(name);
</script>

<style lang="scss" scoped></style>
