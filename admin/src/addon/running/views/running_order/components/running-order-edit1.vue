<template>
  <el-dialog
    v-model="showDialog"
    :title="formData.id ? t('updateRunningOrder') : t('addRunningOrder')"
    width="50%"
    class="diy-dialog-wrap"
    :destroy-on-close="true"
  >
    <el-form
      :model="formData"
      label-width="120px"
      ref="formRef"
      :rules="formRules"
      class="page-form"
      v-loading="loading"
    >
      <el-form-item :label="t('schoolId')" prop="school_id">
        <el-select
          class="input-width"
          v-model="formData.school_id"
          clearable
          :placeholder="t('schoolIdPlaceholder')"
        >
          <el-option label="请选择" value=""></el-option>
          <el-option
            v-for="(item, index) in schoolIdList"
            :key="index"
            :label="item['address']"
            :value="item['id']"
          />
        </el-select>
      </el-form-item>

      <el-form-item :label="t('orderNo')" prop="order_no">
        <el-input
          v-model="formData.order_no"
          clearable
          :placeholder="t('orderNoPlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('memberId')" prop="member_id">
        <el-select
          class="input-width"
          v-model="formData.member_id"
          clearable
          :placeholder="t('memberIdPlaceholder')"
        >
          <el-option label="请选择" value=""></el-option>
          <el-option
            v-for="(item, index) in memberIdList"
            :key="index"
            :label="item['username']"
            :value="item['member_id']"
          />
        </el-select>
      </el-form-item>

      <el-form-item :label="t('riderId')">
        <el-select
          class="input-width"
          v-model="formData.rider_id"
          clearable
          :placeholder="t('riderIdPlaceholder')"
        >
          <el-option label="请选择" value=""></el-option>
          <el-option
            v-for="(item, index) in riderIdList"
            :key="index"
            :label="item['username']"
            :value="item['member_id']"
          />
        </el-select>
      </el-form-item>

      <el-form-item :label="t('type')" prop="type">
        <el-select
          class="input-width"
          v-model="formData.type"
          clearable
          :placeholder="t('typePlaceholder')"
        >
          <el-option label="请选择" value=""></el-option>
          <el-option
            v-for="(item, index) in typeList"
            :key="index"
            :label="item.name"
            :value="item.value"
          />
        </el-select>
      </el-form-item>

      <el-form-item :label="t('status')" prop="status">
        <el-select
          class="input-width"
          v-model="formData.status"
          clearable
          :placeholder="t('statusPlaceholder')"
        >
          <el-option label="请选择" value=""></el-option>
          <el-option
            v-for="(item, index) in statusList"
            :key="index"
            :label="item.name"
            :value="item.value"
          />
        </el-select>
      </el-form-item>

      <el-form-item :label="t('amount')" prop="amount">
        <el-input
          v-model="formData.amount"
          clearable
          :placeholder="t('amountPlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('deliveryFee')" prop="delivery_fee">
        <el-input
          v-model="formData.delivery_fee"
          clearable
          :placeholder="t('deliveryFeePlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('commissionRate')" prop="commission_rate">
        <el-input
          v-model="formData.commission_rate"
          clearable
          :placeholder="t('commissionRatePlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('commissionAmount')" prop="commission_amount">
        <el-input
          v-model="formData.commission_amount"
          clearable
          :placeholder="t('commissionAmountPlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('pickupAddress')" prop="pickup_address">
        <el-input
          v-model="formData.pickup_address"
          clearable
          :placeholder="t('pickupAddressPlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('pickupName')">
        <el-input
          v-model="formData.pickup_name"
          clearable
          :placeholder="t('pickupNamePlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('pickupMobile')">
        <el-input
          v-model="formData.pickup_mobile"
          clearable
          :placeholder="t('pickupMobilePlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('deliveryAddress')" prop="delivery_address">
        <el-input
          v-model="formData.delivery_address"
          clearable
          :placeholder="t('deliveryAddressPlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('contactName')" prop="contact_name">
        <el-input
          v-model="formData.contact_name"
          clearable
          :placeholder="t('contactNamePlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('contactMobile')" prop="contact_mobile">
        <el-input
          v-model="formData.contact_mobile"
          clearable
          :placeholder="t('contactMobilePlaceholder')"
          class="input-width"
        />
      </el-form-item>

      <el-form-item :label="t('remark')">
        <el-input
          v-model="formData.remark"
          clearable
          :placeholder="t('remarkPlaceholder')"
          class="input-width"
        />
      </el-form-item>
    </el-form>

    <template #footer>
      <span class="dialog-footer">
        <el-button @click="showDialog = false">{{ t('cancel') }}</el-button>
        <el-button type="primary" :loading="loading" @click="confirm(formRef)">{{
          t('confirm')
        }}</el-button>
      </span>
    </template>
  </el-dialog>
</template>

<script lang="ts" setup>
import {
  addRunningOrder,
  editRunningOrder,
  getRunningOrderInfo
} from '@/addon/running/api/running_order'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import { computed, reactive, ref, watch } from 'vue'

const showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
  id: '',
  school_id: '',
  order_no: '',
  member_id: '',
  rider_id: '',
  type: '',
  status: '',
  amount: '',
  delivery_fee: '',
  commission_rate: '',
  commission_amount: '',
  pickup_address: '',
  pickup_name: '',
  pickup_mobile: '',
  delivery_address: '',
  contact_name: '',
  contact_mobile: '',
  remark: ''
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
  return {
    school_id: [{ required: true, message: t('schoolIdPlaceholder'), trigger: 'blur' }],
    order_no: [{ required: true, message: t('orderNoPlaceholder'), trigger: 'blur' }],
    member_id: [{ required: true, message: t('memberIdPlaceholder'), trigger: 'blur' }],
    rider_id: [{ required: true, message: t('riderIdPlaceholder'), trigger: 'blur' }],
    type: [{ required: true, message: t('typePlaceholder'), trigger: 'blur' }],
    status: [{ required: true, message: t('statusPlaceholder'), trigger: 'blur' }],
    amount: [{ required: true, message: t('amountPlaceholder'), trigger: 'blur' }],
    delivery_fee: [{ required: true, message: t('deliveryFeePlaceholder'), trigger: 'blur' }],
    commission_rate: [{ required: true, message: t('commissionRatePlaceholder'), trigger: 'blur' }],
    commission_amount: [
      { required: true, message: t('commissionAmountPlaceholder'), trigger: 'blur' }
    ],
    pickup_address: [{ required: true, message: t('pickupAddressPlaceholder'), trigger: 'blur' }],
    pickup_name: [{ required: true, message: t('pickupNamePlaceholder'), trigger: 'blur' }],
    pickup_mobile: [{ required: true, message: t('pickupMobilePlaceholder'), trigger: 'blur' }],
    delivery_address: [
      { required: true, message: t('deliveryAddressPlaceholder'), trigger: 'blur' }
    ],
    contact_name: [{ required: true, message: t('contactNamePlaceholder'), trigger: 'blur' }],
    contact_mobile: [{ required: true, message: t('contactMobilePlaceholder'), trigger: 'blur' }],
    remark: [{ required: true, message: t('remarkPlaceholder'), trigger: 'blur' }]
  }
})

const emit = defineEmits(['complete'])

/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
  if (loading.value || !formEl) return
  const save = formData.id ? editRunningOrder : addRunningOrder

  await formEl.validate(async (valid) => {
    if (valid) {
      loading.value = true

      const data = formData

      save(data)
        .then((res) => {
          loading.value = false
          showDialog.value = false
          emit('complete')
        })
        .catch((err) => {
          loading.value = false
        })
    }
  })
}

// 获取字典数据
const typeList = ref([])
const typeDictList = async () => {
  typeList.value = await (await useDictionary('school_business_type')).data.dictionary
}
typeDictList()
watch(
  () => typeList.value,
  () => {
    formData.type = typeList.value[0].value
  }
)
const statusList = ref([])
const statusDictList = async () => {
  statusList.value = await (await useDictionary('school_order_status')).data.dictionary
}
statusDictList()
watch(
  () => statusList.value,
  () => {
    formData.status = statusList.value[0].value
  }
)

// const schoolIdList = ref([] as any[])
// const setSchoolIdList = async () => {
//   schoolIdList.value = await (await getWithRunningSchoolList({})).data
// }
// setSchoolIdList()

const props = defineProps({
  memberIdList: {
    type: Array as PropType<any[]>,
    required: true
  },
  riderIdList: {
    type: Array as PropType<any[]>,
    required: true
  },
  schoolIdList: {
    type: Array as PropType<any[]>,
    required: true
  }
})

// const memberIdList = ref([] as any[])
// const riderIdList = ref([] as any[])
// const setMemberIdList = async () => {
//   riderIdList.value = memberIdList.value = await (await getWithMemberList({})).data
// }
// setMemberIdList()

const setFormData = async (row: any = null) => {
  Object.assign(formData, initialFormData)
  loading.value = true
  if (row) {
    const data = await (await getRunningOrderInfo(row.id)).data
    if (data) {
      Object.keys(formData).forEach((key: string) => {
        if (data[key] != undefined) formData[key] = data[key]
      })
    }
  }
  loading.value = false
}

// 验证手机号格式
const mobileVerify = (rule: any, value: any, callback: any) => {
  if (value && !/^1[3-9]\d{9}$/.test(value)) {
    callback(new Error(t('generateMobile')))
  } else {
    callback()
  }
}

// 验证身份证号
const idCardVerify = (rule: any, value: any, callback: any) => {
  if (
    value &&
    !/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/.test(value)
  ) {
    callback(new Error(t('generateIdCard')))
  } else {
    callback()
  }
}

// 验证邮箱号
const emailVerify = (rule: any, value: any, callback: any) => {
  if (value && !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test(value)) {
    callback(new Error(t('generateEmail')))
  } else {
    callback()
  }
}

// 验证请输入整数
const numberVerify = (rule: any, value: any, callback: any) => {
  if (!Number.isInteger(value)) {
    callback(new Error(t('generateNumber')))
  } else {
    callback()
  }
}

defineExpose({
  showDialog,
  setFormData
})
</script>

<style lang="scss" scoped></style>
<style lang="scss">
.diy-dialog-wrap .el-form-item__label {
  height: auto !important;
}
</style>
