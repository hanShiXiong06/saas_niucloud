<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <el-card class="!border-none" shadow="never" style="width: 640px">
        <el-alert type="warning" title="使用前请同步活动，部分活动下线了将不能正常生成推广链接；点击立即推广可以生成并获取到最新的推广信息；保存素材可以将素材保存到素材库，方便装修时候直接使用"
          :closable="false" show-icon />
        <div class="flex mt-4 ml-4">
          <el-button type="primary" plain @click="asyncActEvent()">同步活动</el-button>
        </div>
      </el-card>

      <el-card class="box-card !border-none -translate-y-[-6] table-search-wrap" shadow="never">
        <el-form :inline="true" :model="actTable.searchParam" ref="searchFormRef">
          <el-form-item :label="t('actName')" prop="act_name">
            <el-input v-model="actTable.searchParam.act_name" :placeholder="t('actNamePlaceholder')" />
          </el-form-item>
          <el-form-item :label="t('type')" prop="type">
            <el-select class="w-[280px]" v-model="actTable.searchParam.type" clearable placeholder="请选择">
              <el-option label="全部" value=""></el-option>
              <block v-for="(item, index) in drivers" :key="index">
                <el-option :label="item.name" :value="item.type"></el-option>
              </block>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadActList()">{{
              t("search")
            }}</el-button>
            <el-button @click="resetForm(searchFormRef)">{{
              t("reset")
            }}</el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <div class="mt-[10px]">
        <el-table :data="actTable.data" size="large" v-loading="actTable.loading">
          <template #empty>
            <span>{{ !actTable.loading ? t("emptyData") : "" }}</span>
          </template>

          <el-table-column prop="act_name" :label="t('actName')" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column prop="type" label="渠道" min-width="120" :show-overflow-tooltip="true">
            <template #default="{ row }">
              <block v-for="(item, index) in drivers" :key="index">
                <el-tag v-if="row.type == item.type"> {{ item.name }} </el-tag>
              </block>
            </template>
          </el-table-column>

          <el-table-column :label="t('icon')" width="100" align="left">
            <template #default="{ row }">
              <el-avatar v-if="row.icon" :src="img(row.icon)" />
              <el-avatar v-else icon="UserFilled" />
            </template>
          </el-table-column>
          <el-table-column prop="commission_rate" :label="t('commissionRate')" min-width="120"
            :show-overflow-tooltip="true" />

          <el-table-column prop="settlement_time" :label="t('settlementTime')" min-width="120"
            :show-overflow-tooltip="true" />

          <el-table-column prop="start_date" label="开始时间" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column prop="end_date" label="结束时间" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column :label="t('operation')" fixed="right" min-width="120">
            <template #default="{ row }">
              <el-button type="primary" link @click="editEvent(row)">详情</el-button>

              <el-button type="primary" link @click="shareEvent(row.id)">立即推广</el-button>
              <el-button type="primary" link :loading="saveloading" @click="saveImgEvent(row)">保存素材</el-button>
            </template>
          </el-table-column>
        </el-table>
        <div class="mt-[16px] flex justify-end">
          <el-pagination v-model:current-page="actTable.page" v-model:page-size="actTable.limit"
            layout="total, sizes, prev, pager, next, jumper" :total="actTable.total" @size-change="loadActList()"
            @current-change="loadActList" />
        </div>
      </div>

      <edit ref="editActDialog" @complete="loadActList" />
    </el-card>
    <el-dialog v-loading="shareloading" element-loading-text="Loading..." v-model="sharedialog" title="推广详情" width="60%"
      :before-close="handleClose">
      <div class="mb-2" v-if="shareInfo">
        <span class="font-bold">活动名称:{{ shareInfo.act_name }}</span>
      </div>
      <div class="mt-2">
        <span class="font-bold">支持渠道</span>
        <el-tag class="ml-2" v-if="shareInfo && shareInfo.h5 != ''">h5</el-tag>
        <el-tag class="ml-2" v-if="shareInfo && shareInfo.weapp.appid != ''">微信小程序</el-tag>
        <el-tag class="ml-2" v-if="shareInfo && shareInfo.aliapp.appid != ''">支付宝小程序</el-tag>
      </div>
      <div class="flex mt-2" v-if="
        (shareInfo && shareInfo.h5 != '') ||
        shareInfo.weapp.appid != '' ||
        shareInfo.aliapp.appid != ''
      ">
        <div class="font-bold mr-4">页面链接</div>
        <div>
          {{ pagepath }}
        </div>
        <el-icon class="ml-2" @click="copyEvent(pagepath)">
          <DocumentCopy />
        </el-icon>
      </div>
      <div class="flex mt-2" v-if="shareInfo && shareInfo.h5 != ''">
        <div class="font-bold mr-4">网页链接</div>
        <div>
          {{ h5path }}
        </div>
        <el-icon class="ml-2" @click="copyEvent(h5path)">
          <DocumentCopy />
        </el-icon>
      </div>
      <div class="flex mt-2" v-if="shareInfo && shareInfo.h5 != ''">
        <div class="font-bold mr-2">h5链接</div>
        <div class="multi-hidden w-[340px]">{{ shareInfo.h5 }}</div>
        <el-icon class="ml-2" @click="copyEvent(shareInfo.h5)">
          <DocumentCopy />
        </el-icon>
      </div>
      <div class="flex mt-2">
        <div v-if="shareInfo && shareInfo.weapp.appid != ''"
          class="mr-2 p-4 rounded-md statistic-card bg-gradient-to-r from-indigo-50 from-10% via-sky-50 via-10% to-emerald-50 to-10%">
          <div class="font-bold">微信小程序信息</div>
          <div class="mt-2" v-if="shareInfo.weapp.original_id">
            <div class="font-bold">原始id:</div>
            <div>
              {{ shareInfo.weapp.original_id }}
              <el-icon class="ml-2" @click="copyEvent(shareInfo.weapp.original_id)">
                <DocumentCopy />
              </el-icon>
            </div>
          </div>
          <div class="mt-2">
            <div class="font-bold">appid:</div>
            <div>
              {{ shareInfo.weapp.appid }}
              <el-icon class="ml-2" @click="copyEvent(shareInfo.weapp.appid)">
                <DocumentCopy />
              </el-icon>
            </div>
          </div>
          <div class="mt-2">
            <div class="font-bold">页面路径:</div>
            <div class="whitespace-normal w-[360px] break-words">
              {{ shareInfo.weapp.pagepath }}
              <el-icon class="ml-2" @click="copyEvent(shareInfo.weapp.pagepath)">
                <DocumentCopy />
              </el-icon>
            </div>
          </div>
        </div>
        <div v-if="shareInfo && shareInfo.aliapp.appid != ''"
          class="p-4 rounded-md statistic-card bg-gradient-to-r from-indigo-50 from-10% via-sky-50 via-10% to-emerald-50 to-10%">
          <div class="font-bold">支付宝小程序</div>
          <div class="mt-2">
            <div class="font-bold">appid:</div>
            <div>
              {{ shareInfo.aliapp.appid }}
              <el-icon class="ml-2" @click="copyEvent(shareInfo.aliapp.appid)">
                <DocumentCopy />
              </el-icon>
            </div>
          </div>
          <div class="mt-2">
            <div class="font-bold">页面路径:</div>
            <div class="whitespace-normal w-[360px] break-words">
              {{ shareInfo.aliapp.pagepath }}
              <el-icon class="ml-2" @click="copyEvent(shareInfo.aliapp.pagepath)">
                <DocumentCopy />
              </el-icon>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>
    <el-dialog v-model="saveloading" :title="savingTitle" width="400px" :show-close="false" align-center>
      <div class="flex flex-col items-center saving-container">
        <div class="loading-icon-container mb-4" v-if="saveloading">
          <el-icon class="text-4xl loading-icon">
            <Loading />
          </el-icon>
        </div>
        <span
          :class="{ 'success-message': savingMessage.includes('成功'), 'error-message': savingMessage.includes('失败') }">
          {{ savingMessage }}
        </span>
      </div>
    </el-dialog>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from "vue";
import { t } from "@/lang";
import { useDictionary } from "@/app/api/dict";
import {
  getActList,
  deleteAct,
  getShareInfo,
  getAllItem,
  asyncAct,
  saveImg,
  getDrivers,
} from "@/addon/tk_cps/api/act";
import { getWapDomain } from "@/addon/tk_cps/api/page";
import { img } from "@/utils/common";
import { ElMessageBox, FormInstance, ElMessage, ElButton } from "element-plus";
import { useClipboard } from "@vueuse/core";
import Edit from "@/addon/tk_cps/views/act/components/act-edit.vue";
import { useRoute } from "vue-router";
import { ArrowDown, Loading } from '@element-plus/icons-vue';
const drivers = ref();
const getDriverList = async () => {
  const res = await getDrivers();
  drivers.value = res.data;
};
getDriverList();
const route = useRoute();
const pageName = route.meta.title;
const sharedialog = ref(false);
const shareloading = ref(false);
const saveloading = ref(false);
let actTable = reactive({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    act_id: "",
    act_name: "",
    type: "",
    desc: "",
    img: "",
    icon: "",
    poster: "",
    commission_rate: "",
    introduce: "",
    attribution_explain: "",
    settlement_time: "",
    start_date: "",
    end_date: "",
    create_time: "",
  },
});
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

const shareInfo = ref();
const pagepath = ref();
const h5path = ref();
const searchFormRef = ref<FormInstance>();
//保存素材
const savingTitle = ref('正在保存素材');
const savingMessage = ref('正在保存，请稍候...');

const saveImgEvent = async (row) => {
  if (row.saving) return;

  try {
    row.saving = true;
    saveloading.value = true;
    savingMessage.value = '正在保存，请稍候...';

    const res = await saveImg(row.id);

    if (res.code === 1) {
      savingMessage.value = '保存成功';
      ElMessage.success('素材保存成功');
    } else {
      savingMessage.value = '保存失败：' + (res.msg || '未知错误');
      ElMessage.error(res.msg || '保存失败');
    }
  } catch (error) {
    savingMessage.value = '保存失败：' + (error.message || '未知错误');
    ElMessage.error('保存失败');
  } finally {
    setTimeout(() => {
      saveloading.value = false;
      row.saving = false;
    }, 1000);
  }
};
const shareEvent = async (id) => {
  actTable.loading = true;
  const data = await getShareInfo(id);
  const res = await getWapDomain();
  actTable.loading = false;
  sharedialog.value = true;
  shareloading.value = true;
  shareInfo.value = data.data;
  h5path.value =
    res.data +
    "/addon/tk_cps/pages/index?type=" +
    shareInfo.value.type +
    "&act_id=" +
    shareInfo.value.act_id;
  pagepath.value =
    "/addon/tk_cps/pages/index?type=" +
    shareInfo.value.type +
    "&act_id=" +
    shareInfo.value.act_id +
    "&style=embedded";
};
// 选中数据
const selectData = ref<any[]>([]);

// 字典数据

/**
 * 获取CPS活动链接列表
 */
const loadActList = (page: number = 1) => {
  actTable.loading = true;
  actTable.page = page;

  getActList({
    page: actTable.page,
    limit: actTable.limit,
    ...actTable.searchParam,
  })
    .then((res) => {
      actTable.loading = false;
      actTable.data = res.data.data;
      actTable.total = res.data.total;
    })
    .catch(() => {
      actTable.loading = false;
    });
};
loadActList();

const editActDialog: Record<string, any> | null = ref(null);
const asyncActEvent = async () => {
  actTable.loading = true;
  await asyncAct();
  loadActList();
  actTable.loading = false;
};
/**
 * 添加CPS活动链接
 */
const addEvent = () => {
  editActDialog.value.setFormData();
  editActDialog.value.showDialog = true;
};

/**
 * 编辑CPS活动链接
 * @param data
 */
const editEvent = (data: any) => {
  editActDialog.value.setFormData(data);
  editActDialog.value.showDialog = true;
};

/**
 * 删除CPS活动链接
 */
const deleteEvent = (id: number) => {
  ElMessageBox.confirm(t("actDeleteTips"), t("warning"), {
    confirmButtonText: t("confirm"),
    cancelButtonText: t("cancel"),
    type: "warning",
  }).then(() => {
    deleteAct(id)
      .then(() => {
        loadActList();
      })
      .catch(() => { });
  });
};

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  loadActList();
};
</script>

<style lang="scss" scoped>
.multi-hidden {
  word-break: break-all;
  text-overflow: ellipsis;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.saving-container {
  .loading-icon-container {
    position: relative;
    width: 60px;
    height: 60px;

    .loading-icon {
      position: absolute;
      font-size: 3rem;
      left: 50%;
      top: 50%;
      transform: translate(-50%, -50%);
      animation: loading-animation 2s infinite;
      color: var(--el-color-primary);
    }
  }

  .success-message {
    color: var(--el-color-success);
    animation: message-fade 0.3s ease-in-out;
  }

  .error-message {
    color: var(--el-color-danger);
    animation: message-fade 0.3s ease-in-out;
  }
}

@keyframes loading-animation {
  0% {
    transform: translate(-50%, -50%) rotate(0deg) scale(1);
  }

  50% {
    transform: translate(-50%, -50%) rotate(180deg) scale(1.2);
  }

  100% {
    transform: translate(-50%, -50%) rotate(360deg) scale(1);
  }
}

@keyframes message-fade {
  0% {
    opacity: 0;
    transform: translateY(10px);
  }

  100% {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
