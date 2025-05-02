<template>
  <div class="main-container">
    <div class="flex ml-[18px] justify-between items-center mt-[20px]">
      <span class="text-page-title">{{ pageName }}</span>
    </div>
    <el-form
      :model="formData"
      label-width="200px"
      ref="formRef"
      :rules="formRules"
      class="page-form"
      v-loading="loading"
    >
      <el-card class="box-card !border-none" shadow="never">
        <el-form-item :label="t('status')">
          <el-switch v-model="formData.status" />
        </el-form-item>
        <el-form-item :label="t('isSupplement')"  v-if="formData.status">
          <el-switch v-model="formData.isSupplement" :disabled="formData.isSupplement && formData.adUnitId !=''" />
        </el-form-item>
        <el-form-item :label="t('stimulateVideoAd')" v-if="formData.isSupplement && formData.status" prop="adUnitId">
          <el-input
              v-model="formData.adUnitId"
              style="width:150px"
              :placeholder="t('inputAdUintIDPlaceholder')"
              clearable
          />
          <div class="form-tip">{{ t("inputAdUintIDTops") }}</div>
        </el-form-item>
        <el-form-item
          :label="t('signInPeriod')"
          v-if="formData.status"
          prop="cycle"
          class="pt-[10px]"
        >
          <el-input-number
            v-model="formData.cycle"
            controls-position="right"
            :min="7"
            :max="100"
          />
          <div class="form-tip">{{ t("periodLengthTips") }}</div>
        </el-form-item>
        <el-form-item
          :label="t('everyDaySignIn')"
          v-if="formData.status"
          prop="point"
          class="pt-[20px]"
        >
          <span class="text-base">{{ t("bonusForDailySignIn") }}</span>
          <el-input-number
            v-model="formData.point"
            controls-position="right"
            class="ml-2"
            :min="1"
          />
          <span class="ml-2">{{ t("point") }}</span>
        </el-form-item>
        <el-form-item v-if="formData.status" prop="growth">
          <el-input-number
            v-model="formData.growth"
            controls-position="right"
            class="ml-[120px]"
            :min="0"
          />
          <span class="ml-2">{{ t("growth") }}</span>
          <div class="form-tip">{{ t("everyDayTips") }}</div>
        </el-form-item>
        <el-form-item
          :label="t('continuousSignIn')"
          v-if="formData.status"
          class="pt-[20px]"
        >
          <el-table size="large" :data="signInTableData.data">
            <template #empty>
              <span>{{ !loading ? t("emptyData") : "" }}</span>
            </template>
            <el-table-column
              :label="t('continuousSignInDay')"
              min-width="120"
              align="left"
              header-align="left"
            >
              <template #default="scope">
                <el-input-number
                  v-model="scope.row.day"
                  controls-position="right"
                  :min="scope.row.day"
                ></el-input-number>
              </template>
            </el-table-column>
            <el-table-column
              :label="t('awardPoint')"
              min-width="120"
              align="left"
              header-align="left"
            >
              <template #default="scope">
                <el-input-number
                  v-model="scope.row.point"
                  controls-position="right"
                  :min="1"
                ></el-input-number>
              </template>
            </el-table-column>
            <el-table-column
              :label="t('awardGrowth')"
              min-width="120"
              align="left"
              header-align="left"
            >
              <template #default="scope">
                <el-input-number
                  v-model="scope.row.growth"
                  controls-position="right"
                  :min="0"
                ></el-input-number>
              </template>
            </el-table-column>
            <el-table-column
              :label="t('actions')"
              min-width="120"
              align="center"
              header-align="center"
            >
              <template #default="scope">
                <el-button
                  type="danger"
                  size="mini"
                  @click="deleteRow(scope.$index)"
                  >{{ t('delete') }}</el-button
                >
              </template>
            </el-table-column>
          </el-table>
          <el-button
            class="el-button el-button--success mt-[25px] w-[220px]"
            @click="addSign()"
            >{{ t("saveContinuosSignInAward") }}</el-button
          >
          <div class="form-tip pt-5">{{ t("continuosSignInDescribe") }}</div>
        </el-form-item>
      </el-card>
    </el-form>
    <div class="fixed-footer-wrap">
      <div class="fixed-footer">
        <el-button
          class="el-button el-button--primary w-[200px]"
          align="center"
          :loading="loading"
          @click="confirm(formRef)"
          >{{ t("save") }}</el-button
        >
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { reactive, ref } from 'vue'
import { t } from '@/lang'
import { useRoute } from 'vue-router'
import {ElMessage, FormInstance, FormRules} from 'element-plus'
import { create, getSignInList } from '@/addon/dailySignIn/api/signIn'
import { fa } from 'element-plus/es/locale'
const formRef = ref<FormInstance>()

const route = useRoute()
const pageName = route.meta.title

const loading = ref(true)
const formData = reactive<Record<string, string | boolean | Array<string>>>({
    status: false,
    cycle: '0',
    point: '0',
    growth: '0',
    isSupplement:'0',
    adUnitId:'',
    data: []
})
const signInTableData = reactive({
    data: []
})
// 表单验证规则
const formRules = reactive<FormRules>({
    cycle: [
        { required: true, message: t('signInPeriodNotEmpty'), trigger: 'blur' }
    ],
    point: [
        { required: true, message: t('everyDayPointNotEmpty'), trigger: 'blur' }
    ],
    growth: [
        { required: true, message: t('everyDayGrowthNotEmpty'), trigger: 'blur' }
    ],
})



/**
 * 获取签到配置列表
 */
const loadSignInlList = () => {
    loading.value = false
    getSignInList()
        .then((response) => {
            // 将返回的数据从第二个节点开始赋值给 signInTableData.data
            signInTableData.data = response.data.value.data.slice(1)
            // 填充表单数据
            formData.cycle = response.data.value.cycle.toString()
            if (response.data.value.data.length > 0) {
                formData.point = response.data.value.data[0].point
                formData.growth = response.data.value.data[0].growth
            }
            if (response.data.status === 1) {
                formData.status = true
            }
            if(response.data.value.isSupplement){
              formData.isSupplement = true
              formData.adUnitId = response.data.value.adUnitId
            }
            formData.data = response.data.value.data
        })
        .finally(() => {
            loading.value = false
        })
}
// 单行删除
const deleteRow = (index: number) => {
    signInTableData.data.splice(index, 1)
    if (signInTableData.data.length == 1) {
        signInTableData.data[0].day = 2
    }
}
const addSign = () => {
    let nextDay = 1
    if (signInTableData.data.length == 0) {
        nextDay = 2
    } else {
        const lastDay = signInTableData.data[signInTableData.data.length - 1]?.day || 0
        nextDay = lastDay + 1
    }
    const newRow = {
        day: nextDay.toString(), // 将连续天数节点设为上一行连续天数节点的值加 1
        point: '',
        growth: ''
    }
    signInTableData.data.push(newRow)
}
// 在组件挂载时加载数据
loadSignInlList()

// 保存
const confirm = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    await formEl.validate((valid) => {
        if (valid) {
           if(formData.isSupplement == true){
             console.log(formData.adUnitId)
              if(formData.adUnitId ==''){
                 ElMessage({ message: '激励广告位ID不能为空', type: 'warning' })
                 return false
              }
           }
            formData.data[0].point = formData.point
            formData.data[0].growth = formData.growth
            formData.data = formData.status === true ? [formData.data[0], ...signInTableData.data] : []
            create(formData).then(() => {
                loading.value = false
            }).catch(() => {
                loading.value = false
            })
        }
    })
}
</script>

<style lang="scss" scoped></style>
