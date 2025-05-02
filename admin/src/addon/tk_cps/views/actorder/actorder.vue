<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <el-card class="box-card !border-none table-search-wrap" shadow="never">
        <div class="mb-4" style="width: 640px">
          <el-alert
            type="info"
            title="此处订单非实时订单，如需查看实时订单可在订单管理里面查看;激励计算是设置的会员等级、分销、积分等权益，在三方平台结算佣金后会自动进行激励结算"
            :closable="false"
            show-icon
          />
        </div>
        <el-form
          :inline="true"
          :model="actorderTable.searchParam"
          ref="searchFormRef"
        >
          <!-- <el-form-item :label="t('sid')" prop="sid">
            <el-input
              v-model="actorderTable.searchParam.sid"
              :placeholder="t('sidPlaceholder')"
            />
          </el-form-item> -->
          <el-form-item :label="t('orderId')" prop="order_id">
            <el-input
              v-model="actorderTable.searchParam.order_id"
              :placeholder="t('orderIdPlaceholder')"
            />
          </el-form-item>
          <el-form-item :label="t('jlJs')" prop="jl_js">
            <el-select
              class="w-[280px]"
              v-model="actorderTable.searchParam.jl_js"
              clearable
              :placeholder="t('statusPlaceholder')"
            >
              <el-option label="全部" value=""></el-option>
              <el-option label="未结算" value="0"></el-option>
              <el-option label="已结算" value="1"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item :label="t('ptJs')" prop="pt_js">
            <el-select
              class="w-[280px]"
              v-model="actorderTable.searchParam.pt_js"
              clearable
              :placeholder="t('statusPlaceholder')"
            >
              <el-option label="全部" value=""></el-option>
              <el-option label="未结算" value="0"></el-option>
              <el-option label="已结算" value="1"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item :label="t('createTime')" prop="create_time">
            <el-date-picker
              v-model="actorderTable.searchParam.create_time"
              type="datetimerange"
              format="YYYY-MM-DD hh:mm:ss"
              :start-placeholder="t('startDate')"
              :end-placeholder="t('endDate')"
            />
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="loadActorderList()">{{
              t("search")
            }}</el-button>
            <el-button @click="resetForm(searchFormRef)">{{
              t("reset")
            }}</el-button>
            <el-button @click="asyncOrder()">同步订单</el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <div class="mt-[10px]">
        <el-table
          :data="actorderTable.data"
          size="large"
          v-loading="actorderTable.loading"
        >
          <template #empty>
            <span>{{ !actorderTable.loading ? t("emptyData") : "" }}</span>
          </template>
          <el-table-column
            prop="sid"
            :label="t('sid')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="member_id"
            :label="t('memberId')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="name"
            :label="t('name')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="chanel"
            :label="t('chanel')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="order_id"
            :label="t('orderId')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="pay_money"
            :label="t('payMoney')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <!-- <el-table-column
            prop="rate"
            :label="t('rate')"
            min-width="120"
            :show-overflow-tooltip="true"
          /> -->

          <el-table-column
            prop="commission"
            :label="t('commission')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <!-- <el-table-column
            prop="status"
            :label="t('status')"
            min-width="120"
            :show-overflow-tooltip="true"
          /> -->

          <el-table-column
            prop="status_name"
            :label="t('statusName')"
            min-width="120"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="jl_js"
            :label="t('jlJs')"
            min-width="120"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <el-tag v-if="row.jl_js == 1">已结算</el-tag>
              <el-tag type="error" v-if="row.jl_js == 0">未结算</el-tag>
            </template>
          </el-table-column>

          <el-table-column
            prop="pt_js"
            :label="t('ptJs')"
            min-width="120"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <el-tag v-if="row.pt_js == 1">已结算</el-tag>
              <el-tag type="error" v-if="row.pt_js == 0">未结算</el-tag>
            </template>
          </el-table-column>

          <!-- <el-table-column
            :label="t('operation')"
            fixed="right"
            min-width="120"
          >
            <template #default="{ row }">
              <el-button type="primary" link @click="jsEvent(row)"
                >结算</el-button
              >
            </template>
          </el-table-column> -->
        </el-table>
        <div class="mt-[16px] flex justify-end">
          <el-pagination
            v-model:current-page="actorderTable.page"
            v-model:page-size="actorderTable.limit"
            layout="total, sizes, prev, pager, next, jumper"
            :total="actorderTable.total"
            @size-change="loadActorderList()"
            @current-change="loadActorderList"
          />
        </div>
      </div>

      <edit ref="editActorderDialog" @complete="loadActorderList" />
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from "vue";
import { t } from "@/lang";
import { useDictionary } from "@/app/api/dict";
import {
  getActorderList,
  deleteActorder,
  asyncOrder,
} from "@/addon/tk_cps/api/actorder";
import { img } from "@/utils/common";
import { ElMessageBox, FormInstance } from "element-plus";
import Edit from "@/addon/tk_cps/views/actorder/components/actorder-edit.vue";
import { useRoute } from "vue-router";
const route = useRoute();
const pageName = route.meta.title;

let actorderTable = reactive({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    sid: "",
    order_id: "",
    jl_js: "",
    pt_js: "",
    create_time: [],
  },
});

const searchFormRef = ref<FormInstance>();

// 选中数据
const selectData = ref<any[]>([]);

// 字典数据

/**
 * 获取CPS活动订单列表
 */
const loadActorderList = (page: number = 1) => {
  actorderTable.loading = true;
  actorderTable.page = page;

  getActorderList({
    page: actorderTable.page,
    limit: actorderTable.limit,
    ...actorderTable.searchParam,
  })
    .then((res) => {
      actorderTable.loading = false;
      actorderTable.data = res.data.data;
      actorderTable.total = res.data.total;
    })
    .catch(() => {
      actorderTable.loading = false;
    });
};
loadActorderList();

const editActorderDialog: Record<string, any> | null = ref(null);

/**
 * 添加CPS活动订单
 */
const addEvent = () => {
  editActorderDialog.value.setFormData();
  editActorderDialog.value.showDialog = true;
};

/**
 * 编辑CPS活动订单
 * @param data
 */
const editEvent = (data: any) => {
  editActorderDialog.value.setFormData(data);
  editActorderDialog.value.showDialog = true;
};

/**
 * 删除CPS活动订单
 */
const deleteEvent = (id: number) => {
  ElMessageBox.confirm(t("actorderDeleteTips"), t("warning"), {
    confirmButtonText: t("confirm"),
    cancelButtonText: t("cancel"),
    type: "warning",
  }).then(() => {
    deleteActorder(id)
      .then(() => {
        loadActorderList();
      })
      .catch(() => {});
  });
};

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  loadActorderList();
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
