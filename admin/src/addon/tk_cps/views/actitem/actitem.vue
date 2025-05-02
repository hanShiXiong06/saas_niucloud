<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <el-alert
        type="warning"
        title="活动推广详情信息，如遇到推广链接失效，可以删除推广或者在活动列表里面点击立即推广，推广信息将在用户访问或者操作时候更新"
        :closable="false"
        show-icon
      />
      <el-card
        class="box-card !border-none my-[10px] table-search-wrap"
        shadow="never"
      >
        <el-form
          :inline="true"
          :model="actItemTable.searchParam"
          ref="searchFormRef"
        >
          <el-form-item :label="t('actName')" prop="act_name">
            <el-input
              v-model="actItemTable.searchParam.act_name"
              :placeholder="t('actNamePlaceholder')"
            />
          </el-form-item>
          <el-form-item label="类型" prop="type">
            <el-select
              class="w-[280px]"
              v-model="actItemTable.searchParam.type"
              clearable
              placeholder="请选择"
            >
              <el-option label="全部" value=""></el-option>
              <el-option label="聚推客" value="0"></el-option>
              <el-option label="蚂蚁星球" value="1"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadActItemList()">{{
              t("search")
            }}</el-button>
            <el-button @click="resetForm(searchFormRef)">{{
              t("reset")
            }}</el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <div class="mt-[10px]">
        <el-table
          @selection-change="handleSelectionChange"
          :data="actItemTable.data"
          size="large"
          v-loading="actItemTable.loading"
        >
          <template #empty>
            <span>{{ !actItemTable.loading ? t("emptyData") : "" }}</span>
          </template>
          <el-table-column type="selection" width="55" />
          <el-table-column
            prop="act_name"
            :label="t('actName')"
            min-width="180"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="type"
            :label="t('type')"
            min-width="40"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <el-tag v-if="row.type == 0"> 聚推客 </el-tag>
              <el-tag v-if="row.type == 1"> 蚂蚁星球 </el-tag>
            </template>
          </el-table-column>

          <el-table-column label="支持渠道" min-width="120">
            <template #default="{ row }">
              <el-tag class="ml-2" v-if="row.h5 != ''">h5</el-tag>
              <el-tag class="ml-2" v-if="JSON.parse(row.weapp).appid != ''"
                >微信小程序</el-tag
              >
              <el-tag class="ml-2" v-if="JSON.parse(row.aliapp).appid != ''"
                >支付宝小程序</el-tag
              >
            </template>
          </el-table-column>
          <el-table-column
            :label="t('operation')"
            fixed="right"
            min-width="120"
          >
            <template #default="{ row }">
              <el-button type="primary" link @click="editEvent(row)"
                >推广信息</el-button
              >
              <el-button type="primary" link @click="deleteEvent(row.id)">{{
                t("delete")
              }}</el-button>
            </template>
          </el-table-column>
        </el-table>
        <div class="mt-[16px] flex justify-between">
          <el-button @click="deleteSelectEvent()">删除选中</el-button>
          <el-pagination
            v-model:current-page="actItemTable.page"
            v-model:page-size="actItemTable.limit"
            layout="total, sizes, prev, pager, next, jumper"
            :total="actItemTable.total"
            @size-change="loadActItemList()"
            @current-change="loadActItemList"
          />
        </div>
      </div>

      <edit ref="editActItemDialog" @complete="loadActItemList" />
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from "vue";
import { t } from "@/lang";
import { useDictionary } from "@/app/api/dict";
import {
  getActItemList,
  deleteActItem,
  delselect,
} from "@/addon/tk_cps/api/actitem";
import { img } from "@/utils/common";
import { ElMessageBox, FormInstance } from "element-plus";
import Edit from "@/addon/tk_cps/views/actitem/components/actitem-edit.vue";
import { useRoute } from "vue-router";
const route = useRoute();
const pageName = route.meta.title;

let actItemTable = reactive({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    act_id: "",
    act_name: "",
    type: "",
    h5: "",
    weapp: "",
    aliapp: "",
    share_info: "",
    create_time: "",
  },
});

const searchFormRef = ref<FormInstance>();

// 选中数据
const selectData = ref<any[]>([]);
const handleSelectionChange = (val) => {
  selectData.value = val.map((item) => item.id);
  console.log(selectData.value);
};
const deleteSelectEvent = async () => {
  if (selectData.value.length > 0) {
    delselect(selectData.value).then((res) => {
      loadActItemList();
    });
  } else {
    ElMessageBox.confirm("请先选择要删除的数据", t("warning"), {
      confirmButtonText: t("confirm"),
      cancelButtonText: t("cancel"),
      type: "warning",
    });
  }
};
// 字典数据

/**
 * 获取活动详情列表
 */
const loadActItemList = (page: number = 1) => {
  actItemTable.loading = true;
  actItemTable.page = page;

  getActItemList({
    page: actItemTable.page,
    limit: actItemTable.limit,
    ...actItemTable.searchParam,
  })
    .then((res) => {
      actItemTable.loading = false;
      actItemTable.data = res.data.data;
      actItemTable.total = res.data.total;
    })
    .catch(() => {
      actItemTable.loading = false;
    });
};
loadActItemList();

const editActItemDialog: Record<string, any> | null = ref(null);

/**
 * 添加活动详情
 */
const addEvent = () => {
  editActItemDialog.value.setFormData();
  editActItemDialog.value.showDialog = true;
};

/**
 * 编辑活动详情
 * @param data
 */
const editEvent = (data: any) => {
  editActItemDialog.value.setFormData(data);
  editActItemDialog.value.showDialog = true;
};

/**
 * 删除活动详情
 */
const deleteEvent = (id: number) => {
  ElMessageBox.confirm(t("actItemDeleteTips"), t("warning"), {
    confirmButtonText: t("confirm"),
    cancelButtonText: t("cancel"),
    type: "warning",
  }).then(() => {
    deleteActItem(id)
      .then(() => {
        loadActItemList();
      })
      .catch(() => {});
  });
};

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  loadActItemList();
};
</script>

<style lang="scss" scoped>
/* 多行超出隐藏 */
.multi-hidden {
  word-break: break-all;
  text-overflow: ellipsis;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}
</style>
