<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">
            <el-page-header :content="pageName" :icon="ArrowLeft" @back="router.push({ path: '/shop_giftcard/order/list' })" />
        </el-card>
        <el-form :model="formData" label-width="100px" ref="formRef" class="page-form" v-loading="loading" label-position="left">
			<div v-if="formData">
				<el-card class="box-card !border-none relative" shadow="never">
					<h3 class="panel-title">{{ t('orderInfo') }}</h3>
					<el-row class="row-bg px-[30px] mb-[20px]" :gutter="20">
						<el-col :span="8">
							<el-form-item :label="t('orderNo')">
								<div class="input-width">{{ formData.order_no }}</div>
							</el-form-item>
							<el-form-item :label="t('orderForm')">
								<div class="input-width">{{ formData.order_from_name }}</div>
							</el-form-item>
							<el-form-item :label="t('outTradeNo')" v-if="formData.out_trade_no">
								<div class="input-width">{{ formData.out_trade_no }}</div>
							</el-form-item>
							<el-form-item :label="t('orderStatus')">
								<div class="input-width">{{ formData.status_name }}</div>
							</el-form-item>
							<el-form-item :label="t('buyInfo')">
								<div class="input-width text-primary cursor-pointer" @click="toMemberDetailEvent(formData.member.member_id)">{{ formData.member.nickname }}</div>
							</el-form-item>
							<el-form-item :label="t('payType')" v-if="formData.pay">
								<div class="input-width">{{ formData.pay.type_name }}</div>
							</el-form-item>
						</el-col>
						<el-col :span="8">
							<el-form-item :label="t('giftCardName')">
								<div class="input-width line-feed">{{ formData.body }}</div>
							</el-form-item>
							<el-form-item :label="t('cardRightType')">
								<div class="input-width line-feed">{{ formData.card_right_type_name }}</div>
							</el-form-item>
							<el-form-item :label="t('giftCardNum')">
								<div class="input-width line-feed">{{ formData.num }}</div>
							</el-form-item>
						</el-col>
						<el-col :span="8">
							<el-form-item :label="t('createTime')">
								<div class="input-width">{{ formData.create_time }}</div>
							</el-form-item>
							<el-form-item :label="t('memberRemark')">
								<div class="input-width line-feed">{{ formData.member_remark ?? '--' }}</div>
							</el-form-item>
							<el-form-item :label="t('notes')">
								<div class="input-width line-feed">{{ formData.shop_remark ?? '--' }}</div>
							</el-form-item>
						</el-col>
					</el-row>
					<h3 class="panel-title">{{ t('orderStatus') }}</h3>
					<div class="mb-[20px]">
						<p>
							<span class="ml-[30px] text-[14px] mr-[20px]">{{ t('orderStatus') }}：</span>
							<span class="text-[14px]">{{ formData.status_name }}</span>
						</p>
						<div class="flex mt-[10px]">
							<span class="text-[14px] px-[15px] py-[5px] ml-[30px] text-[#ff7f5b] bg-[#fff0e5] cursor-pointer" @click="setNotes">{{ t('notes') }}</span>
							<span class="text-[14px] px-[15px] py-[5px] ml-[30px] text-[#5c96fc] bg-[#ebf3ff] cursor-pointer" @click="close" v-if="formData.status == 1">{{ t('close') }}</span>
						</div>
						<div class="flex ml-[30px] mt-[15px]">
							<span class="text-[14px] text-[#ff7f5b]">{{ t('remind') }}：</span>
							<div class="ml-[10px]">
								<p class="text-[14px] text-[#a4a4a4]">{{ t('remindTips1') }}</p>
							</div>
						</div>
					</div>
				</el-card>
			
				<!-- 礼品卡列表 -->
				<el-card class="box-card !border-none relative" shadow="never">
					<h3 class="panel-title">{{ t('cardListTitle') }}</h3>
					<el-table :data="formData.card" size="large" max-height="400">
						<el-table-column :label="t('cardNo')" min-width="120">
							<template #default="{ row }">
								<span class="text-[14px]">{{ row.card_no }}</span>
							</template>
						</el-table-column>
						<el-table-column prop="balance" :label="t('cardBalance')" min-width="120" :show-overflow-tooltip="true" v-if="formData.card_right_type == 'balance'">
							<template #default="{ row }">
								<span>￥{{ row.balance }}</span>
							</template>
						</el-table-column>
						<el-table-column prop="status_name" :label="t('cardStatus')" min-width="120" :show-overflow-tooltip="true"/>
						<el-table-column prop="validity_time" :label="t('validityTime')" min-width="120" :show-overflow-tooltip="true">
							<template #default="{ row }">
								<div v-if="row.validity_time">{{ row.validity_time }}</div>
								<div v-else>{{ t('validityForever') }}</div>
							</template>
						</el-table-column>
						<el-table-column prop="total_num" :label="t('totalNum')" min-width="120" :show-overflow-tooltip="true">
							<template #default="{ row }">
								<span>{{ row.use_num }}/{{ row.total_num }}</span>
							</template>
						</el-table-column>
						<el-table-column :label="t('operation')" min-width="120" align="right">
							<template #default="{ row }">
								<el-button type="primary" link @click="toDetailEvent(row)">{{ t('toCardDetail') }}</el-button>
							</template>
						</el-table-column>
					</el-table>
				</el-card>
			</div>
        </el-form>
		<order-notes ref="orderNotesDialog" @complete="setFormData(orderId)" />
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref } from 'vue'
import { t } from '@/lang'
import { getShopGiftcardOrderInfo, closeShopGiftcardOrder } from '@/addon/shop_giftcard/api/order'
import OrderNotes from '@/addon/shop_giftcard/views/order/components/order-notes.vue'
import { img } from '@/utils/common'
import { ElMessageBox,FormInstance } from 'element-plus'
import { useRoute,useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()
const pageName = route.meta.title;
const orderId: number = parseInt(route.query.order_id as string)
const loading = ref(true)

const formData: Record<string, any> | null = ref(null)

const setFormData = async(orderId: number = 0) => {
    loading.value = true
    formData.value = null
    await getShopGiftcardOrderInfo(orderId).then(({ data }) => {
        formData.value = data
    })
    loading.value = false
}

if (orderId) setFormData(orderId)
else loading.value = false

const orderNotesDialog: Record<string, any> | null = ref(null)

/**
 * 设置备注
 */
 const setNotes = () => {
    orderNotesDialog.value.setFormData(formData.value)
    orderNotesDialog.value.showDialog = true
}

/**
 * 关闭订单
 */
const close = () => {
    ElMessageBox.confirm(t('orderCloseTips'), t('warning'),
        {
            confirmButtonText: t('confirm'),
            cancelButtonText: t('cancel'),
            type: 'warning'
        }).then(() => {
		closeShopGiftcardOrder(orderId).then(() => {
            setFormData(orderId)
        })
    })
}

// 跳转到礼品卡详情
const toDetailEvent = (data: any)=>{
    const url = router.resolve({
        path: '/shop_giftcard/giftcard/card_detail',
        query: {
            card_id: data.card_id
        }
    })
    window.open(url.href)
}

/**
 * 跳转会员详情
 */
 const toMemberDetailEvent = (member_id: any) => {
    const url = router.resolve({
        path: '/member/detail',
        query: {
            id: member_id
        }
    })
    window.open(url.href)
}

</script>

<style lang="scss" scoped>
</style>
