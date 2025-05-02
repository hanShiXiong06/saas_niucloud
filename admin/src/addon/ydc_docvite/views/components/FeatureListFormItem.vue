<template>
  <mnFormTable
    v-model="data"
    drag-sort
    :addTemplate="addTemplate"
    placeholder="暂无数据"
  >
    <el-table-column prop="title" label="标题">
      <template #default="scope">
        <el-input
          v-model="scope.row.title"
          placeholder="请输入标题"
          :minlength="10"
          :maxlength="100"
          :show-word-limit="true"
        ></el-input>
      </template>
    </el-table-column>
    <el-table-column prop="text" label="内容">
      <template #default="scope">
        <el-input
          v-model="scope.row.text"
          placeholder="请输入内容"
          :minlength="10"
          :maxlength="200"
          :show-word-limit="true"
        ></el-input>
      </template>
    </el-table-column>
    <el-table-column prop="url" label="链接">
      <template #default="scope">
        <el-input
          v-model="scope.row.url"
          placeholder="链接"
          :minlength="10"
          :maxlength="200"
          :show-word-limit="true"
        ></el-input>
      </template>
    </el-table-column>
    <el-table-column prop="iconSrc" label="图片">
      <template #default="scope">
        <upload-image v-model="scope.row.iconSrc" :limit="1" />
      </template>
    </el-table-column>
    <el-table-column prop="iconWidth" label="宽度">
      <template #default="scope">
        <el-input
          type="number"
          v-model="scope.row.iconWidth"
          placeholder="图片宽度"
        ></el-input>
      </template>
    </el-table-column>
    <el-table-column prop="iconHeight" label="高度">
      <template #default="scope">
        <el-input
          type="number"
          v-model="scope.row.iconHeight"
          placeholder="图片高度"
        ></el-input>
      </template>
    </el-table-column>
  </mnFormTable>
</template>

<script>
import mnFormTable from "./FormTable.vue";
export default {
  components: { mnFormTable },
  emits: ["update:modelValue"],
  props: {
    modelValue: {
      type: Array,
      default: () => {
        return [];
      },
    },
  },
  data() {
    return {
      visible: false,
      addTemplate: {
        title: "",
        text: "",
        url: "",
        iconSrc: "",
        iconWidth: 100,
        iconHeight: 100,
      },
    };
  },
  computed: {
    data: {
      get() {
        return this.modelValue;
      },
      set(value) {
        this.$emit("update:modelValue", value);
      },
    },
  },
  methods: {},
};
</script>

<style scoped lang="scss">
.el-form-item .el-form-item {
  margin-bottom: 18px;
}
.header {
  width: 100%;
  display: flex;
  justify-content: space-between;
  .icon {
    display: none;
  }
}
.header:hover {
  .icon {
    display: block;
  }
}
</style>
