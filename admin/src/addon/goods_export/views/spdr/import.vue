<template>
  <div class="main-container">
    <el-form v-loading="loading" element-loading-text="正在导入数据......" :model="formData" label-width="140px" ref="formRef"
      :rules="formRules" class="page-form">
      <el-card class="box-card !border-none" shadow="never">
        <el-card class="!border-none" shadow="never" style="width: 640px">
          <el-alert type="info"
            title="说明:请按照模板格式导入xlsx文件，格式不正确会导入失败,暂未适配多规格,如要和其他平台数据进行批量导入，请适配正常格式才能执行成功。本操作需要确保队列正常运行。上传文件为临时文件，不长时存储，单次导入不超过50条，如需单次更多条数导入请联系管理员导入"
            :closable="false" show-icon />
        </el-card>
        <div class="flex">
          <el-button :loading="loading" class="mb-6 ml-6" type="primary" plain @click="downFile()">
            下载模板
          </el-button>
        </div>

        <el-form-item label="商品类型">
          <el-radio-group v-model="formData.goods_type">
            <block v-for="item in goodsType" :key="item.type">
              <el-radio border :label="item.type" size="large" style="margin-right: 10px">{{ item.name }}</el-radio>
            </block>
          </el-radio-group>
        </el-form-item>

        <!-- <el-form-item label="商品分类" prop="goods_category">
          <el-cascader v-model="formData.goods_category" :options="goodsCategoryOptions" :props="goodsCategoryProps"
            clearable filterable @change="categoryHandleChange" />
          <div class="ml-[10px]">
            <span class="cursor-pointer text-primary mr-[10px]" @click="refreshGoodsCategory">刷新</span>
            <span class="cursor-pointer text-primary" @click="toGoodsCategoryEvent">添加</span>
          </div>
        </el-form-item> -->
        <el-form-item label="上传文件" prop="file_url">
          <div class="v-[320px]">
            <upload-xlsx v-model="formData.file_url" api="sys/document/applet" />
          </div>
        </el-form-item>
        <!-- <el-form-item label="图片保存">
          <el-radio-group v-model="formData.islocal">

            <el-radio :label="'0'" size="large" style="margin-right: 10px;">不保存</el-radio>
            <el-radio :label="'1'" size="large" style="margin-right: 10px;">保存</el-radio>

          </el-radio-group>
        </el-form-item> -->
        <el-form-item label="上架产品">
          <el-radio-group v-model="formData.status">

            <el-radio :label="'0'" size="large" style="margin-right: 10px;">仓库中</el-radio>
            <el-radio :label="'1'" size="large" style="margin-right: 10px;">立即上架</el-radio>

          </el-radio-group>
        </el-form-item>
        <el-form-item label="" prop="">
          <div class="flex">
            <el-button type="primary" :loading="loading" @click="confirm(formRef)">{{ t("confirm") }}</el-button>
            <el-button v-if="isAdmin" type="primary" :loading="loading"
              @click="confirmAdmin(formRef)">管理员操作导入</el-button>
          </div>
        </el-form-item>
      </el-card>
    </el-form>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref, computed } from "vue";
import { t } from "@/lang";
import { FormInstance, FormRules } from "element-plus";
import { useRoute, useRouter } from "vue-router";
import {
  getCategoryTree,
  getGoodsType,
  checkShop,
  importGoods,
  importGoodsAdmin,
} from "@/addon/goods_export/api/goods";
import { ElMessage } from "element-plus";
import { img } from "@/utils/common";
import uploadXlsx from "@/addon/goods_export/views/upload-xlsx/index.vue"
const isAdmin = ref(false);
const checkAdmin = () => {
  let adminId = "00";
  let siteId = "-1";
  if (localStorage.getItem("admin.userinfo")) {
    adminId = JSON.parse(localStorage.getItem("admin.userinfo")).uid;
  }
  if (localStorage.getItem("site.userinfo")) {
    siteId = JSON.parse(localStorage.getItem("site.userinfo")).uid;
  }
  if (adminId === siteId) {
    isAdmin.value = true;
  }
};
checkAdmin();
const route = useRoute();
const router = useRouter();
const pageName = route.meta.title;
const ruleFormRef = ref<FormInstance>();
const loading = ref(false);
const formRef = ref<FormInstance>();
const downFile = () => {
  const link = document.createElement("a");
  link.href = img("addon/goods_export/file/goods.xlsx");
  link.target = "_blank";
  link.download = "goods.xlsx";
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};
const goodsCategory: any = [];
// 商品类型
const goodsType = reactive([]);

// 切换商品类型
const changeGoodsType = (data: any) => {
  router.push(data.path);
};
const docheckshop = async () => {
  await checkShop();
  refreshGoodsCategory();
  // 商品类型
  getGoodsType().then((res) => {
    const data = res.data;
    if (data) {
      for (const k in data) {
        goodsType.push(data[k]);
      }
    }
  });
};
docheckshop();

// 商品分类
const goodsCategoryOptions = reactive([]);
// 跳转到商品分类，添加分类
const toGoodsCategoryEvent = () => {
  const url = router.resolve({
    path: "/phone_shop/goods/category",
  });
  window.open(url.href);
};

// 刷新商品分类
const refreshGoodsCategory = () => {
  getCategoryTree().then((res) => {
    const data = res.data;
    if (data) {
      const goodsCategoryTree: any = [];
      data.forEach((item: any) => {
        const children: any = [];
        if (item.child_list) {
          item.child_list.forEach((childItem: any) => {
            children.push({
              value: childItem.category_id,
              label: childItem.category_name,
            });
          });
        }
        goodsCategoryTree.push({
          value: item.category_id,
          label: item.category_name,
          children,
        });
      });
      goodsCategoryOptions.splice(
        0,
        goodsCategoryOptions.length,
        ...goodsCategoryTree
      );
    }
  });
};

/**
 * 链接跳转
 */
const toLink = (link: any) => {
  router.push(link);
};
// 表单验证规则
const formRules = computed(() => {
  return {
    file_url: [{ required: true, message: "请上传文件", trigger: "blur" }],
    goods_category: [
      { required: true, message: "商品分类必须选择", trigger: "blur" },
    ],
  };
});
/**
 * 表单数据
 */
const initialFormData = {
  file_url: "",
  stock: 999,
  goods_category: "",
  goods_type: "real",
  islocal: "0",
  status: "0",
};
const formData: Record<string, any> = reactive({ ...initialFormData });
/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
  if (loading.value || !formEl) return;

  await formEl.validate(async (valid) => {
    if (valid) {
      loading.value = true;
      const data = formData;
      console.log(data);
      importGoods(data)
        .then((res) => {
          loading.value = false;
          ElMessage({
            message: "正在奋力导入，请稍后进入商品列表查看",
            type: "success",
          });

          // const url = "/phone_shop/goods/list";
          // router.push(url);
        })
        .catch(() => {
          loading.value = false;
          router.push("/site_spdr/shop/goods/import_do");
          // showDialog.value = false
        });
    }
  });
};
const confirmAdmin = async (formEl: FormInstance | undefined) => {
  if (loading.value || !formEl) return;

  await formEl.validate(async (valid) => {
    if (valid) {
      loading.value = true;
      const data = formData;
      console.log(data);
      importGoodsAdmin(data)
        .then((res) => {
          loading.value = false;
          ElMessage({
            message: "队列导入中，请稍后刷新页面查看",
            type: "success",
          });
          router.push("/site_spdr/shop/goods/import_do");

        })
        .catch(() => {
          loading.value = false;
          router.push("/site_spdr/shop/goods/import_do");
          // showDialog.value = false
        });
    }
  });
};
</script>

<style lang="scss" scoped></style>
