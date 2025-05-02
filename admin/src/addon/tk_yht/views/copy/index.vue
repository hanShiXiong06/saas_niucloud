<template>
    <div class="main-container">
        <div class="flex ml-[18px] justify-between items-center mt-[20px]">
            <span class="text-[20px]">{{ pageName }}</span>
        </div>
        <el-form v-loading="loading" element-loading-text="采集中，请勿关闭页面......" :model="formData" label-width="140px"
            ref="formRef" :rules="formRules" class="page-form">
            <el-card class="box-card !border-none" shadow="never">
                <el-card class="!border-none" shadow="never" style="width: 640px;">
                    <el-alert type="warning"
                        title="说明:先完成通用配置并购买采集次数；本接口可以采集淘宝、天猫、1688、京东商品,生成的商品默认是没有上架的，请手动上架商品！请在系统空闲时使用，部分链接可能会采集失败，可尝试更换其他相似产品重试"
                        :closable="false" show-icon />
                </el-card>

                <el-form-item label="商品类型">
                    <el-radio-group v-model="formData.goods_type">
                        <block v-for="(item) in goodsType" :key="item.type">
                            <el-radio border :label="item.type" size="large" style="margin-right: 10px;">{{ item.name
                                }}</el-radio>
                        </block>
                    </el-radio-group>
                </el-form-item>
                <el-form-item label="图片保存">
                    <el-radio-group v-model="formData.islocal">

                        <el-radio :label="'0'" size="large" style="margin-right: 10px;">不保存</el-radio>
                        <el-radio :label="'1'" size="large" style="margin-right: 10px;">保存</el-radio>

                    </el-radio-group>
                </el-form-item>
                <el-form-item label="商品库存" prop="stock">
                    <el-input type="number" v-model="formData.stock" placeholder="输入产品库存" class="input-width"
                        clearable />
                </el-form-item>
                <el-form-item label="商品分类" prop="goods_category">
                    <el-cascader v-model="formData.goods_category" :options="goodsCategoryOptions"
                        :props="goodsCategoryProps" clearable filterable @change="categoryHandleChange" />
                    <div class="ml-[10px]">
                        <span class="cursor-pointer text-primary mr-[10px]" @click="refreshGoodsCategory">刷新</span>
                        <span class="cursor-pointer text-primary" @click="toGoodsCategoryEvent">添加</span>
                    </div>
                </el-form-item>

                <el-form-item label="商品链接" prop="url">
                    <el-input type="textarea" v-model="formData.url" placeholder="请输入待采集商品详情链接,换行可以采集多个链接"
                        class="input-width" clearable />
                </el-form-item>

            </el-card>
        </el-form>
        <div class="fixed-footer-wrap">
            <div class="fixed-footer">
                <el-button type="primary" :loading="loading" @click="confirm(formRef)">{{ t('confirm') }}</el-button>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, computed } from 'vue'
import { t } from '@/lang'
import { copyGoods } from '@/addon/tk_yht/api/copy'
import { FormInstance, FormRules } from 'element-plus'
import { useRoute, useRouter } from 'vue-router'
import {
    getCategoryTree,
    getGoodsType
} from '@/addon/tk_yht/api/goods'
import { getCommonConfig } from '@/addon/tk_yht/api/config'
import { ElMessage } from 'element-plus'
import { checkShop } from '@/addon/tk_yht/api/checkshop'
const route = useRoute()
const router = useRouter()
const pageName = route.meta.title
const ruleFormRef = ref<FormInstance>()
const loading = ref(false)
const formRef = ref<FormInstance>()
const getyhtConfig = async () => {
    const commondata = await getCommonConfig()
    if (commondata.data.access_key == 'AppId') {
        router.push('/commonconfig')
    }
}
getyhtConfig()
const goodsCategory: any = []
// 商品类型
const goodsType = reactive([])

// 切换商品类型
const changeGoodsType = (data: any) => {
    router.push(data.path)
}
const docheckshop = async () => {
    await checkShop()
    refreshGoodsCategory()
    // 商品类型
    getGoodsType().then((res) => {
        const data = res.data
        if (data) {
            for (const k in data) {
                goodsType.push(data[k])
            }
        }
    })
}
docheckshop()

// 商品分类
const goodsCategoryOptions = reactive([])
// 跳转到商品分类，添加分类
const toGoodsCategoryEvent = () => {
    const url = router.resolve({
        path: '/shop/goods/category'
    })
    window.open(url.href)
}

// 刷新商品分类
const refreshGoodsCategory = () => {
    getCategoryTree().then((res) => {
        const data = res.data
        if (data) {
            const goodsCategoryTree: any = []
            data.forEach((item: any) => {
                const children: any = []
                if (item.child_list) {
                    item.child_list.forEach((childItem: any) => {
                        children.push({
                            value: childItem.category_id,
                            label: childItem.category_name
                        })
                    })
                }
                goodsCategoryTree.push({
                    value: item.category_id,
                    label: item.category_name,
                    children
                })
            })
            goodsCategoryOptions.splice(0, goodsCategoryOptions.length, ...goodsCategoryTree)
        }
    })
}


/**
 * 链接跳转
 */
const toLink = (link: any) => {
    router.push(link)
}
// 表单验证规则
const formRules = computed(() => {
    return {
        url: [
            { required: true, message: 'url必须填写', trigger: 'blur' }
        ],
        goods_category: [
            { required: true, message: '商品分类必须选择', trigger: 'blur' }
        ]
    }
})
/**
 * 表单数据
 */
const initialFormData = {
    url: '',
    stock: 999,
    goods_category: '',
    goods_type: 'real',
    islocal: '0'
}
const formData: Record<string, any> = reactive({ ...initialFormData })
/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return

    await formEl.validate(async (valid) => {
        if (valid) {
            loading.value = true
            const data = formData
            copyGoods(data).then(res => {
                loading.value = false
                ElMessage({
                    message: '采集成功,可在仓库中编辑商品后上架',
                    type: 'success',
                })
                if (res.msg != '操作成功') {
                    const url = '/shop/goods/real_edit?goods_id=' + res.msg;
                    router.push(url);
                }

            }).catch(() => {
                loading.value = false
                // showDialog.value = false
            })
        }
    })
}
</script>

<style lang="scss" scoped></style>
