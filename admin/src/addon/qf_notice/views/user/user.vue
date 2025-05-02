<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <el-card
        class="box-card !border-none my-[10px] table-search-wrap"
        shadow="never"
      >
        <el-form
          :inline="true"
          :model="userTable.searchParam"
          ref="searchFormRef"
        >
          <el-form-item :label="t('catId')" prop="cat_id">
            <el-select
              class="w-[280px]"
              v-model="userTable.searchParam.cat_id"
              clearable
              :placeholder="t('catIdPlaceholder')"
            >
              <el-option
                v-for="(item, index) in catIdList"
                :key="index"
                :label="item['name']"
                :value="item['id']"
              />
            </el-select>
          </el-form-item>

          <el-form-item :label="t('mobile')" prop="mobile">
            <el-input
              v-model="userTable.searchParam.mobile"
              :placeholder="t('mobilePlaceholder')"
            />
          </el-form-item>
          <el-form-item :label="t('createTime')" prop="create_time">
            <el-date-picker
              v-model="userTable.searchParam.create_time"
              type="datetimerange"
              format="YYYY-MM-DD hh:mm:ss"
              :start-placeholder="t('startDate')"
              :end-placeholder="t('endDate')"
            />
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="loadUserList()">{{
              t("search")
            }}</el-button>
            <el-button @click="resetForm(searchFormRef)">{{
              t("reset")
            }}</el-button>
          </el-form-item>
        </el-form>
      </el-card>
      <div class="flex justify-between items-center">
        <div>
          <el-button @click="deleteSelectEvent()">删除选中</el-button>
          <el-button
            :loading="clearLoading"
            @click="clearUserEvent()"
            type="primary"
            >清除所有</el-button
          >
        </div>
        <el-button type="primary" @click="addEvent">
          {{ t("addUser") }}
        </el-button>
      </div>
      <div class="mt-[20px]">
        <el-table
          :data="userTable.data"
          size="large"
          v-loading="userTable.loading"
          @selection-change="handleSelectionChange"
        >
          <template #empty>
            <span>{{ !userTable.loading ? t("emptyData") : "" }}</span>
          </template>
          <el-table-column type="selection" width="85" />
          <el-table-column
            prop="cat_id_name"
            :label="t('catId')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="nickname"
            :label="t('nickname')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="mobile"
            :label="t('mobile')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="openid"
            :label="t('openid')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="email"
            :label="t('email')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <!-- <el-table-column prop="num" :label="t('num')" min-width="120" :show-overflow-tooltip="true"/> -->

          <el-table-column
            :label="t('operation')"
            fixed="right"
            min-width="120"
          >
            <template #default="{ row }">
              <el-button type="primary" link @click="editEvent(row)">{{
                t("edit")
              }}</el-button>
              <el-button type="primary" link @click="deleteEvent(row.id)">{{
                t("delete")
              }}</el-button>
            </template>
          </el-table-column>
        </el-table>
        <div class="mt-[16px] flex justify-end">
          <el-pagination
            v-model:current-page="userTable.page"
            v-model:page-size="userTable.limit"
            layout="total, sizes, prev, pager, next, jumper"
            :total="userTable.total"
            @size-change="loadUserList()"
            @current-change="loadUserList"
          />
        </div>
      </div>

      <edit ref="editUserDialog" @complete="loadUserList" />
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from "vue";
import { t } from "@/lang";
import { useDictionary } from "@/app/api/dict";
import {
  getUserList,
  deleteUser,
  getWithUserCatList,
  delselect,
  clearUser,
} from "@/addon/qf_notice/api/user";
import { img } from "@/utils/common";
import { ElMessageBox, FormInstance } from "element-plus";
import Edit from "@/addon/qf_notice/views/user/components/user-edit.vue";
import { useRoute } from "vue-router";
const route = useRoute();
const pageName = route.meta.title;
const clearLoading = ref(false);
const clearUserEvent = () => {
  clearLoading.value = true;
  clearUser().then(() => {
    clearLoading.value = false;
    loadUserList();
  });
};
let userTable = reactive({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    cat_id: "",
    mobile: "",
    create_time: [],
  },
});

const searchFormRef = ref<FormInstance>();

// 选中数据
const selectData = ref<any[]>([]);
const handleSelectionChange = (val) => {
  selectData.value = val.map((item) => item.id);
};
const deleteSelectEvent = async () => {
  if (selectData.value.length > 0) {
    delselect(selectData.value).then((res) => {
      loadUserList();
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
 * 获取用户列列表
 */
const loadUserList = (page: number = 1) => {
  userTable.loading = true;
  userTable.page = page;

  getUserList({
    page: userTable.page,
    limit: userTable.limit,
    ...userTable.searchParam,
  })
    .then((res) => {
      userTable.loading = false;
      userTable.data = res.data.data;
      userTable.total = res.data.total;
    })
    .catch(() => {
      userTable.loading = false;
    });
};
loadUserList();

const editUserDialog: Record<string, any> | null = ref(null);

/**
 * 添加用户列
 */
const addEvent = () => {
  editUserDialog.value.setFormData();
  editUserDialog.value.showDialog = true;
};

/**
 * 编辑用户列
 * @param data
 */
const editEvent = (data: any) => {
  editUserDialog.value.setFormData(data);
  editUserDialog.value.showDialog = true;
};

/**
 * 删除用户列
 */
const deleteEvent = (id: number) => {
  ElMessageBox.confirm(t("userDeleteTips"), t("warning"), {
    confirmButtonText: t("confirm"),
    cancelButtonText: t("cancel"),
    type: "warning",
  }).then(() => {
    deleteUser(id)
      .then(() => {
        loadUserList();
      })
      .catch(() => {});
  });
};

const catIdList = ref([]);
const setCatIdList = async () => {
  catIdList.value = await (await getWithUserCatList({})).data;
};
setCatIdList();

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  loadUserList();
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
