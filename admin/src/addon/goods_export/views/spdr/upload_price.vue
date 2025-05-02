<template>
    <div class="main-container">
        <el-form v-loading="loading" element-loading-text="正在导入数据......" :model="formData" label-width="140px"
            ref="formRef" :rules="formRules" class="page-form">
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




                <el-form-item label="上传文件" prop="file_url">
                    <div class="v-[320px]">
                        <upload-xlsx v-model="formData.file_url" api="sys/document/applet" />
                    </div>
                </el-form-item>


                <el-form-item label="" prop="">
                    <div class="flex">
                        <el-button type="primary" :loading="loading" @click="confirm(formRef)">{{ t("confirm")
                            }}</el-button>

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
import { checkShop, importRecycleCategory } from "@/addon/goods_export/api/goods";
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
            importRecycleCategory(data)
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
                    router.push("/site_spdr/shop/goods/upload_price");
                    // showDialog.value = false
                });
        }
    });
};

</script>

<style lang="scss" scoped></style>