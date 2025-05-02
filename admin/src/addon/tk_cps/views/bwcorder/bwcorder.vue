<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div class="flex justify-between items-center">
        <span class="text-lg">{{ pageName }}</span>
      </div>

      <el-card
        class="box-card !border-none my-[10px] table-search-wrap"
        shadow="never"
      >
        <el-form
          :inline="true"
          :model="bwcOrderTable.searchParam"
          ref="searchFormRef"
        >
          <el-form-item :label="t('orderSn')" prop="orderSn">
            <el-input
              v-model="bwcOrderTable.searchParam.orderSn"
              :placeholder="t('orderSnPlaceholder')"
            />
          </el-form-item>

          <el-form-item :label="t('orderTelephone')" prop="orderTelephone">
            <el-input
              v-model="bwcOrderTable.searchParam.orderTelephone"
              :placeholder="t('orderTelephonePlaceholder')"
            />
          </el-form-item>

          <el-form-item :label="t('state')" prop="state">
            <el-select
              class="w-[280px]"
              v-model="bwcOrderTable.searchParam.state"
              clearable
              placeholder="请选择"
            >
              <el-option label="全部" value=""></el-option>
              <el-option
                v-for="(item, index) in orderStatus"
                :key="index"
                :label="item"
                :value="index"
              />
            </el-select>
          </el-form-item>

          <!-- <el-form-item :label="t('xgzSettleStatus')" prop="xgzSettleStatus">
            <el-input
              v-model="bwcOrderTable.searchParam.xgzSettleStatus"
              :placeholder="t('xgzSettleStatusPlaceholder')"
            />
          </el-form-item> -->

          <el-form-item :label="t('isFanxian')" prop="is_fanxian">
            <el-input
              v-model="bwcOrderTable.searchParam.is_fanxian"
              :placeholder="t('isFanxianPlaceholder')"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadBwcOrderList()">{{
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
          :data="bwcOrderTable.data"
          size="large"
          v-loading="bwcOrderTable.loading"
        >
          <template #empty>
            <span>{{ !bwcOrderTable.loading ? t("emptyData") : "" }}</span>
          </template>
          <el-table-column label="商家信息" width="200" align="left">
            <template #default="{ row }">
              <div class="flex items-center">
                <div>
                  <el-avatar
                    size="small"
                    v-if="row.logo"
                    :src="img(row.logo)"
                  />
                  <el-avatar size="small" v-else icon="UserFilled" />
                </div>
                <div
                  class="ml-2 font-bold overflow-hidden text-ellipsis whitespace-nowrap"
                >
                  {{ row.name }}
                </div>
              </div>
            </template>
          </el-table-column>

          <el-table-column
            prop="orderSn"
            :label="t('orderSn')"
            min-width="100"
            :show-overflow-tooltip="true"
          />

          <!-- <el-table-column
            prop="userOrderSn"
            label="外卖单号"
            min-width="100"
            :show-overflow-tooltip="true"
          /> -->
          <el-table-column
            prop="orderTelephone"
            :label="t('orderTelephone')"
            min-width="80"
            :show-overflow-tooltip="true"
          />
          <!-- <el-table-column
            prop="platformName"
            :label="t('platformName')"
            min-width="120"
            :show-overflow-tooltip="true"
          /> -->

          <el-table-column
            prop="source"
            :label="t('source')"
            min-width="80"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <el-tag v-if="row.source == 1" type="warning">美团</el-tag>
              <el-tag v-if="row.source == 3" type="primary">饿了么</el-tag>
              <el-tag v-if="row.source == 2" type="danger">三方</el-tag>
            </template>
          </el-table-column>

          <el-table-column
            prop="commissionType"
            :label="t('commissionType')"
            min-width="80"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <el-tag v-if="row.commissionType == 1" type="warning"
                >固定金额</el-tag
              >
              <el-tag v-if="row.commissionType == 2" type="primary"
                >按比例</el-tag
              >
            </template>
          </el-table-column>

          <el-table-column
            prop="commission"
            label="联盟佣金"
            min-width="80"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="commissionRatio"
            label="佣金比例"
            min-width="80"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }"> {{ row.commissionRatio }}% </template>
          </el-table-column>
          <el-table-column
            prop="xgzSettleStatus"
            label="联盟结算"
            min-width="80"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <el-tag v-if="row.xgzSettleStatus == 1" type="warning"
                >已结算</el-tag
              >
              <el-tag v-else type="primary">未结算</el-tag>
            </template>
          </el-table-column>
          <el-table-column
            prop="fanxian"
            label="客户佣金"
            min-width="80"
            :show-overflow-tooltip="true"
          />
          <el-table-column
            prop="is_fanxian"
            label="客户结算"
            min-width="80"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <el-tag v-if="row.is_fanxian == 1" type="warning">已结算</el-tag>
              <el-tag v-else type="primary">未结算</el-tag>
            </template>
          </el-table-column>
          <el-table-column
            prop="state"
            :label="t('state')"
            min-width="80"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <block v-for="(item, index) in orderStatus" :key="index">
                <el-tag v-if="row.state == index" type="warning">{{
                  item
                }}</el-tag>
              </block>
            </template>
          </el-table-column>

          <el-table-column
            prop="reason"
            :label="t('reason')"
            min-width="80"
            :show-overflow-tooltip="true"
          />

          <el-table-column
            prop="paidAmount"
            :label="t('paidAmount')"
            min-width="120"
            :show-overflow-tooltip="true"
          />
          <el-table-column :label="t('operation')" fixed="right" min-width="80">
            <template #default="{ row }">
              <el-button type="primary" link @click="shareEvent(row)"
                >推广店铺</el-button
              >
            </template>
          </el-table-column>
        </el-table>

        <div class="mt-[16px] flex justify-end">
          <el-pagination
            v-model:current-page="bwcOrderTable.page"
            v-model:page-size="bwcOrderTable.limit"
            layout="total, sizes, prev, pager, next, jumper"
            :total="bwcOrderTable.total"
            @size-change="loadBwcOrderList()"
            @current-change="loadBwcOrderList"
          />
        </div>
      </div>
    </el-card>
  </div>
  <el-dialog
    v-model="showBusinessDialog"
    title="店铺信息"
    width="50%"
    class="diy-dialog-wrap"
    :destroy-on-close="true"
  >
    <div>
      <div class="font-bold">小程序信息</div>
      <div v-if="source == 1">
        <div class="mt-2">
          <div class="font-bold">appid:</div>
          <div>
            {{ businessInfo.wxMini.mt.appid }}
            <el-icon
              class="ml-2"
              @click="copyEvent(businessInfo.wxMini.mt.appid)"
            >
              <DocumentCopy />
            </el-icon>
          </div>
        </div>
        <div class="mt-2">
          <div class="font-bold">path:</div>
          <div>
            {{ businessInfo.wxMini.mt.path }}
            <el-icon
              class="ml-2"
              @click="copyEvent(businessInfo.wxMini.mt.path)"
            >
              <DocumentCopy />
            </el-icon>
          </div>
        </div>
      </div>
      <div v-if="source == 3">
        <div class="mt-2">
          <div class="font-bold">appid:</div>
          <div>
            {{ businessInfo.wxMini.elm.appid }}
            <el-icon
              class="ml-2"
              @click="copyEvent(businessInfo.wxMini.elm.appid)"
            >
              <DocumentCopy />
            </el-icon>
          </div>
        </div>
        <div class="mt-2">
          <div class="font-bold">path:</div>
          <div>
            {{ businessInfo.wxMini.elm.path }}
            <el-icon
              class="ml-2"
              @click="copyEvent(businessInfo.wxMini.elm.path)"
            >
              <DocumentCopy />
            </el-icon>
          </div>
        </div>
      </div>
      <div v-if="source == 1" class="mt-4 font-bold">H5链接</div>
      <div v-if="source == 1" class="">{{ businessInfo.h5.mt }}</div>
    </div>
  </el-dialog>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from "vue";
import { t } from "@/lang";
import { useDictionary } from "@/app/api/dict";
import {
  getBwcOrderList,
  deleteBwcOrder,
  getOrderStatus,
} from "@/addon/tk_cps/api/bwcorder";
import { img } from "@/utils/common";
import { ElMessageBox, FormInstance } from "element-plus";
import { useRoute } from "vue-router";
import { useClipboard } from "@vueuse/core";
const showBusinessDialog = ref(false);
const businessInfo = ref();
const source = ref();
/**
 * 复制
 */
const { copy, isSupported, copied } = useClipboard();
const copyEvent = (text: string) => {
  if (!isSupported.value) {
    ElMessage({
      message: "当前浏览器不支持一键复制，请手动复制",
      type: "warning",
    });
    return;
  }
  copy(text);
  ElMessage({
    message: "复制成功",
    type: "success",
  });
};
const shareEvent = (e) => {
  showBusinessDialog.value = true;
  businessInfo.value = e.actionUrl;
  source.value = e.source;
};
const route = useRoute();
const pageName = route.meta.title;
const orderStatus = ref();
const getOrderStatusEvent = async () => {
  const res = await getOrderStatus();
  orderStatus.value = res.data;
};
getOrderStatusEvent();
let bwcOrderTable = reactive({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    member_id: "",
    orderSn: "",
    order_no: "",
    userOrderSn: "",
    paidAmount: "",
    shopOriginId: "",
    orderTelephone: "",
    name: "",
    logo: "",
    address: "",
    platformName: "",
    platformLogo: "",
    source: "",
    planId: "",
    planTypeCh: "",
    planTypeDescCh: "",
    commissionType: "",
    sid: "",
    minAmount: "",
    maxAmount: "",
    commission: "",
    commissionRatio: "",
    ecommission: "",
    ecommissionRatio: "",
    state: "",
    createTime: "",
    finishedTime: "",
    xgzSettleStatus: "",
    xgzSettleTime: "",
    create_time: "",
    close_time: "",
    reason: "",
    fanxian: "",
    is_fanxian: "",
  },
});

const searchFormRef = ref<FormInstance>();

// 选中数据
const selectData = ref<any[]>([]);

// 字典数据

/**
 * 获取霸王餐订单列表
 */
const loadBwcOrderList = (page: number = 1) => {
  bwcOrderTable.loading = true;
  bwcOrderTable.page = page;

  getBwcOrderList({
    page: bwcOrderTable.page,
    limit: bwcOrderTable.limit,
    ...bwcOrderTable.searchParam,
  })
    .then((res) => {
      bwcOrderTable.loading = false;
      bwcOrderTable.data = res.data.data;
      bwcOrderTable.total = res.data.total;
    })
    .catch(() => {
      bwcOrderTable.loading = false;
    });
};
loadBwcOrderList();

const editBwcOrderDialog: Record<string, any> | null = ref(null);

/**
 * 添加霸王餐订单
 */
const addEvent = () => {
  editBwcOrderDialog.value.setFormData();
  editBwcOrderDialog.value.showDialog = true;
};

/**
 * 编辑霸王餐订单
 * @param data
 */
const editEvent = (data: any) => {
  editBwcOrderDialog.value.setFormData(data);
  editBwcOrderDialog.value.showDialog = true;
};

/**
 * 删除霸王餐订单
 */
const deleteEvent = (id: number) => {
  ElMessageBox.confirm(t("bwcOrderDeleteTips"), t("warning"), {
    confirmButtonText: t("confirm"),
    cancelButtonText: t("cancel"),
    type: "warning",
  }).then(() => {
    deleteBwcOrder(id)
      .then(() => {
        loadBwcOrderList();
      })
      .catch(() => {});
  });
};

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  loadBwcOrderList();
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
