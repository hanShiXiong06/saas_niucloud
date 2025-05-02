<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div class="flex justify-between items-center">
        <span class="text-lg">点餐订单</span>
      </div>
      <el-card
        class="box-card !border-none my-[10px] table-search-wrap"
        shadow="never"
      >
        <el-form :inline="true" :model="Table.searchParam" ref="searchFormRef">
          <el-form-item label="开始时间" prop="time">
            <el-date-picker
              v-model="Table.searchParam.time"
              type="datetimerange"
              format="YYYY-MM-DD hh:mm:ss"
              range-separator="-"
              start-placeholder="开始时间"
              end-placeholder="结束时间"
            />
          </el-form-item>
          <el-form-item label="订单ID" prop="orderid">
            <el-input
              v-model="Table.searchParam.orderid"
              placeholder="请输入订单ID"
            />
          </el-form-item>
          <el-form-item label="订单状态" prop="status">
            <el-select
              class="w-[280px]"
              v-model="Table.searchParam.status"
              clearable
              placeholder="请选择"
            >
              <el-option label="全部" value=""></el-option>
              <block v-for="(item, index) in status" key="index">
                <el-option :label="item" :value="index"></el-option>
              </block>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadList()">搜索</el-button>
            <el-button @click="resetForm(searchFormRef)">重置</el-button>
          </el-form-item>
        </el-form>
      </el-card>
      <div class="mt-[10px]">
        <el-table :data="Table.data" size="large" v-loading="Table.loading">
          <template #empty>
            <span>{{ !Table.loading ? "还没有订单哟~~~" : "" }}</span>
          </template>
          <el-table-column
            prop="orderid"
            label="订单ID"
            min-width="80"
            :show-overflow-tooltip="true"
          />
          <el-table-column
            prop="storeName"
            label="门店"
            min-width="120"
            :show-overflow-tooltip="true"
          />
          <el-table-column
            prop="goodsCount"
            label="数量"
            min-width="60"
            :show-overflow-tooltip="true"
          />
          <el-table-column
            prop="payprice"
            label="支付金额"
            min-width="80"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <div>{{ row.payprice / 100 }}</div>
            </template>
          </el-table-column>
          <el-table-column
            prop="commission"
            label="佣金"
            min-width="80"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <div>{{ row.commission }}</div>
            </template>
          </el-table-column>

          <el-table-column
            prop="status"
            label="状态"
            min-width="120"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <block v-for="(item, index) in status" :key="index">
                <div v-if="index == row.status">{{ item }}</div>
              </block>
            </template>
          </el-table-column>
          <el-table-column
            prop="closetxt"
            label="关闭原因"
            min-width="120"
            :show-overflow-tooltip="true"
          />
          <el-table-column
            prop="createdtime"
            label="创建时间"
            min-width="120"
            :show-overflow-tooltip="true"
          >
            <template #default="{ row }">
              <div>{{ timeChange(row.createdtime) }}</div>
            </template> </el-table-column
          >/>
        </el-table>
        <div class="mt-[16px] flex justify-end">
          <el-pagination
            v-model:current-page="Table.page"
            v-model:page-size="Table.limit"
            layout="total, sizes, prev, pager, next, jumper"
            :total="Table.total"
            @size-change="loadList()"
            @current-change="loadList"
          />
        </div>
      </div>
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from "vue";
import { t } from "@/lang";
import { useDictionary } from "@/app/api/dict";
import { getDcOrderList, getDcOrderStatus } from "@/addon/tk_cps/api/myxq";
import { img } from "@/utils/common";
import { FormInstance } from "element-plus";
import { useRoute } from "vue-router";
const route = useRoute();
const searchFormRef = ref<FormInstance>();
const Table = reactive({
  page: 1,
  limit: 30,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    time: [],
    orderid: "",
    status: "",
  },
});
const timeChange = (timestamp) => {
  const date = new Date(timestamp * 1000);
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  const hours = date.getHours();
  const minutes = date.getMinutes();
  const seconds = date.getSeconds();
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};
const status = ref();
const getStatus = async () => {
  const data = await getDcOrderStatus();
  status.value = data.data;
};
getStatus();
const loadList = (page: number = 1) => {
  Table.loading = true;
  Table.page = page;
  getDcOrderList({
    page: Table.page,
    limit: Table.limit,
    ...Table.searchParam,
  })
    .then((res) => {
      Table.loading = false;
      Table.data = res.data.list;
      console.log(Table.data);
      Table.total = res.data.total;
    })
    .catch(() => {
      Table.loading = false;
    });
};
loadList();

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  loadList();
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