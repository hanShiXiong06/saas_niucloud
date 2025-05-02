<template>
  <el-dialog v-model="showDialog" :title="formData.id ? t('updateRunningBuilding') : t('addRunningBuilding')"
    width="50%" class="diy-dialog-wrap" :destroy-on-close="true">
    <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form"
      v-loading="loading">
      <el-form-item :label="t('schoolId')" prop="school_id">
        <el-select class="input-width" v-model="formData.school_id" clearable :placeholder="t('schoolIdPlaceholder')">
          <el-option label="请选择" value=""></el-option>
          <el-option v-for="(item, index) in schoolIdList" :key="index" :label="item['name']" :value="item['id']" />
        </el-select>
      </el-form-item>



      <el-form-item :label="t('name')" prop="name">
        <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')" class="input-width" />
      </el-form-item>

      <el-form-item :label="t('sort')" prop="sort">
        <el-input-number v-model="formData.sort" :min="0" :max="9999" class="input-width" />
      </el-form-item>

      <el-form-item :label="t('status')" prop="status">
        <el-radio-group v-model="formData.status">
          <el-radio :label="1">{{ t('开启') }}</el-radio>
          <el-radio :label="0">{{ t('关闭') }}</el-radio>
        </el-radio-group>
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
  addRunningBuilding,
  editRunningBuilding,
  getRunningBuildingInfo,
  getWithRunningSchoolList,
  getRunningBuildingList
} from '@/addon/running/api/running_building'
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
  name: '',
  pid: 0,
  level: 1,
  sort: 0,
  status: 1
}
const formData = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
  return {
    school_id: [{ required: true, message: t('schoolIdPlaceholder'), trigger: 'blur' }],
    name: [{ required: true, message: t('namePlaceholder'), trigger: 'blur' }],
    sort: [{ required: true, type: 'number', message: t('sortPlaceholder'), trigger: 'blur' }]
  }
})

const emit = defineEmits(['complete'])

/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
  if (loading.value || !formEl) return
  const save = formData.id ? editRunningBuilding : addRunningBuilding

  await formEl.validate(async (valid) => {
    if (valid) {
      loading.value = true

      const data = { ...formData }

      // 确保数字类型
      data.sort = Number(data.sort)
      data.level = Number(data.level)
      data.pid = Number(data.pid) || 0

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
const statusList = ref([])
const statusDictList = async () => {
  statusList.value = await (await useDictionary('status')).data.dictionary
}
statusDictList()

const schoolIdList = ref([] as any[])
const setSchoolIdList = async () => {
  schoolIdList.value = await (await getWithRunningSchoolList({})).data
}
setSchoolIdList()

// 楼栋选项
const buildingOptions = ref([] as any[])
const loadBuildingOptions = async (schoolId: number) => {
  if (!schoolId) {
    buildingOptions.value = []
    return
  }

  try {
    const res = await getRunningBuildingList({
      school_id: schoolId
    })

    if (res.data && res.data.data) {
      // 如果在编辑模式且有ID，需要过滤掉自己和自己的子节点
      if (formData.id) {
        buildingOptions.value = res.data.data.filter(item => item.id != formData.id)
      } else {
        buildingOptions.value = res.data.data
      }
    } else {
      buildingOptions.value = []
    }
  } catch (error) {
    buildingOptions.value = []
  }
}

watch(() => formData.school_id, (newVal) => {
  if (newVal) {
    loadBuildingOptions(newVal)
  } else {
    buildingOptions.value = []
  }
})

const setFormData = async (row: any = null) => {
  Object.assign(formData, initialFormData)
  loading.value = true

  if (row) {
    if (row.id) {
      // 编辑模式
      const data = await (await getRunningBuildingInfo(row.id)).data
      if (data) {
        Object.keys(formData).forEach((key: string) => {
          if (data[key] != undefined) formData[key] = data[key]
        })
      }
    } else {
      // 添加子楼栋模式
      Object.keys(row).forEach((key: string) => {
        if (formData[key] !== undefined) formData[key] = row[key]
      })
    }

    // 如果设置了学校ID，加载楼栋选项
    if (formData.school_id) {
      await loadBuildingOptions(formData.school_id)
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

<style lang="scss" scoped>
.input-width {
  width: 100%;
  max-width: 500px;
}
</style>
<style lang="scss">
.diy-dialog-wrap .el-form-item__label {
  height: auto !important;
}
</style>
