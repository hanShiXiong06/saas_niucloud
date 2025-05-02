<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div class="flex justify-between items-center">
        <span class="text-lg">{{ pageName }}</span>
        <el-button type="primary" @click="addEvent">
          {{ t("addAddon") }}
        </el-button>
      </div>

      <el-card
        class="box-card !border-none my-[10px] table-search-wrap"
        shadow="never"
      >
        <el-form
          :inline="true"
          :model="addonTable.searchParam"
          ref="searchFormRef"
        >
          <el-form-item :label="t('name')" prop="name">
            <el-input
              v-model="addonTable.searchParam.name"
              :placeholder="t('namePlaceholder')"
            />
          </el-form-item>
          <el-form-item :label="t('categoryId')" prop="category_id">
            <el-select
              class="w-[280px]"
              v-model="addonTable.searchParam.category_id"
              clearable
              :placeholder="t('categoryIdPlaceholder')"
            >
              <el-option
                v-for="(item, index) in categoryIdList"
                :key="index"
                :label="item['name']"
                :value="item['id']"
              />
            </el-select>
          </el-form-item>
          <el-form-item :label="t('type')" prop="type">
            <el-select
              class=""
              v-model="addonTable.searchParam.type"
              clearable
              :placeholder="t('typePlaceholder')"
            >
              <el-option label="全部" value=""></el-option>
              <el-option
                v-for="(item, index) in addonType"
                :key="index"
                :label="item.name"
                :value="item.status"
              ></el-option>
            </el-select>
          </el-form-item>
          <el-form-item :label="t('createTime')" prop="create_time">
            <el-date-picker
              v-model="addonTable.searchParam.create_time"
              type="datetimerange"
              format="YYYY-MM-DD hh:mm:ss"
              :start-placeholder="t('startDate')"
              :end-placeholder="t('endDate')"
            />
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="loadAddonList()">{{
              t("search")
            }}</el-button>
            <el-button @click="resetForm(searchFormRef)">{{
              t("reset")
            }}</el-button>
          </el-form-item>
        </el-form>
      </el-card>
      <div class="mt-[40px]">
        <div class="flex flex-wrap ml-8 mt-4 mb-4">
          <block v-for="(item, index) in addonTable.data" :key="index" class="">
            <div
              class="hover:bg-gray-100 cursor-pointer w-[320px] rounded-lg shadow-md p-4 mr-6 mb-8"
            >
              <div class="flex items-center justify-between mb-4">
                <div>ID: {{ item.id }}</div>
                <div>
                  <el-tag
                    effect="plain"
                    v-if="item.type == 'sms'"
                    type="error"
                    >{{ item.type_name }}</el-tag
                  >
                  <el-tag
                    effect="plain"
                    v-if="item.type == 'wechat'"
                    type="warning"
                    >{{ item.type_name }}</el-tag
                  >
                  <el-tag effect="plain" v-if="item.type == 'email'">{{
                    item.type_name
                  }}</el-tag>
                </div>
              </div>
              <div class="flex">
                <div @click.stop="editEvent(item)" class="mr-4">
                  <el-avatar :size="50" :src="img(item.image)" />
                </div>

                <div class="flex flex-col w-[220px]">
                  <div @click.stop="editEvent(item)" class="flex items-center">
                    <h2
                      class="font-bold truncate overflow-hidden whitespace-nowrap"
                    >
                      {{ item.name }}
                    </h2>
                  </div>
                  <div
                    @click.stop="editEvent(item)"
                    class="flex items-center mt-1 mb-2"
                  >
                    <el-tag v-if="item.is_main == 1" type="info"
                      >系统会员</el-tag
                    >
                    <el-tag v-if="item.is_main == 0" type="primary"
                      >用户列表</el-tag
                    >
                    <h2
                      class="text-gray-400 text-xs truncate overflow-hidden whitespace-nowrap ml-2"
                    >
                      {{ item.desc }}
                    </h2>
                  </div>
                </div>
              </div>
              <div class="flex justify-between mt-3">
                <div>
                  <el-tag effect="plain" v-if="item.status == 0" type="error"
                    >禁用</el-tag
                  >
                  <el-tag effect="plain" v-if="item.status == 1">启用</el-tag>
                </div>
                <div>
                  <el-button
                    type="primary"
                    link
                    @click.stop="editEvent(item)"
                    >{{ t("edit") }}</el-button
                  >
                  <el-button
                    type="info"
                    link
                    @click.stop="deleteEvent(item.id)"
                    >{{ t("delete") }}</el-button
                  >
                  <el-button
                    type="primary"
                    round
                    size="small"
                    @click.stop="sendNoticeEvent(item.id)"
                    >发送</el-button
                  >
                </div>
              </div>
            </div>
          </block>
        </div>
      </div>

      <div class="mt-[10px]">
        <div class="mt-[16px] flex justify-end">
          <el-pagination
            v-model:current-page="addonTable.page"
            v-model:page-size="addonTable.limit"
            layout="total, sizes, prev, pager, next, jumper"
            :total="addonTable.total"
            @size-change="loadAddonList()"
            @current-change="loadAddonList"
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
import {
  getAddonList,
  deleteAddon,
  sendNotice,
  getAddonType,
  getWithCategoryList,
} from "@/addon/qf_notice/api/addon";
import { img } from "@/utils/common";
import { ElMessageBox, FormInstance } from "element-plus";
import { useRouter } from "vue-router";
import { useRoute } from "vue-router";
const route = useRoute();
const router = useRouter();
const pageName = route.meta.title;
const categoryIdList = ref([]);
const setCategoryIdList = async () => {
  categoryIdList.value = await (await getWithCategoryList({})).data;
};
setCategoryIdList();
const addonType = ref();
getAddonType().then((res) => {
  if (res.data) {
    addonType.value = res.data;
  }
});
const sendNoticeEvent = async (id) => {
  try {
    await ElMessageBox.confirm(
      "即将进行消息发送，请核对消息内容及消息接收人",
      t("warning"),
      {
        confirmButtonText: t("confirm"),
        cancelButtonText: t("cancel"),
        type: "warning",
      }
    );

    await sendNotice(id);
    loadAddonList();
  } catch (error) {
    // 处理错误，例如显示错误消息
  }
};

let addonTable = reactive({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    name: "",
    image: "",
    type: "",
    category_id: "",
    create_time: [],
  },
});

const searchFormRef = ref<FormInstance>();

// 选中数据
const selectData = ref<any[]>([]);

// 字典数据

/**
 * 获取群发应用列表
 */
const loadAddonList = (page: number = 1) => {
  addonTable.loading = true;
  addonTable.page = page;

  getAddonList({
    page: addonTable.page,
    limit: addonTable.limit,
    ...addonTable.searchParam,
  })
    .then((res) => {
      addonTable.loading = false;
      addonTable.data = res.data.data;
      addonTable.total = res.data.total;
    })
    .catch(() => {
      addonTable.loading = false;
    });
};
loadAddonList();

const editAddonDialog: Record<string, any> | null = ref(null);

/**
 * 添加群发应用
 */
const addEvent = () => {
  router.push("/qf_notice/addon/addon_edit");
};

/**
 * 编辑群发应用
 * @param data
 */
const editEvent = (data: any) => {
  router.push("/qf_notice/addon/addon_edit?id=" + data.id);
};

/**
 * 删除群发应用
 */
const deleteEvent = (id: number) => {
  ElMessageBox.confirm(t("addonDeleteTips"), t("warning"), {
    confirmButtonText: t("confirm"),
    cancelButtonText: t("cancel"),
    type: "warning",
  }).then(() => {
    deleteAddon(id)
      .then(() => {
        loadAddonList();
      })
      .catch(() => {});
  });
};

const resetForm = (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  formEl.resetFields();
  loadAddonList();
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
