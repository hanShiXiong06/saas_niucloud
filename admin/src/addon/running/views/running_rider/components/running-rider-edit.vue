<template>
  <el-dialog v-model="showDialog" :title="formData.id ? t('updateRunningRider') : t('addRunningRider')" width="50%"
    class="diy-dialog-wrap" :destroy-on-close="true">

    <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form"
      v-loading="loading">
      <el-form-item :label="t('schoolId')" prop="school_id">
        <el-select class="input-width" v-model="formData.school_id" clearable :placeholder="t('schoolIdPlaceholder')">
          <el-option label="请选择" value=""></el-option>
          <el-option v-for="(item, index) in schoolIdList" :key="index" :label="item['name']" :value="item['id']" />
        </el-select>
      </el-form-item>

      <el-form-item :label="t('memberId')" prop="member_id">
        <el-select class="input-width" v-model="formData.member_id" clearable filterable
          :placeholder="t('memberIdPlaceholder')" @visible-change="handleSelectVisible" remote
          :remote-method="remoteMemberSearch" :loading="memberSearchLoading" reserve-keyword>
          <el-option v-for="(item, i) in memberIdList" :key="i"
            :label="item.username + (item.mobile ? ` (${item.mobile})` : '')" :value="item.member_id">
            <div class="member-option">
              <div class="member-avatar">
                <el-avatar :size="24" :src="item.headimg || ''" />
              </div>
              <div class="member-info">
                <div class="member-name">{{ item.username || '未设置昵称' }}</div>
                <div class="member-mobile">{{ item.mobile || '无手机号' }}</div>
              </div>
            </div>
          </el-option>
          <template #empty>
            <div class="empty-text">{{ memberIdList.length === 0 ? '请输入关键词搜索会员' : '没有找到匹配的会员' }}</div>
          </template>
        </el-select>
      </el-form-item>

      <el-form-item :label="t('realName')" prop="real_name">
        <el-input v-model="formData.real_name" clearable :placeholder="t('realNamePlaceholder')" class="input-width" />
      </el-form-item>

      <el-form-item :label="t('idCard')" prop="id_card">
        <el-input v-model="formData.id_card" clearable :placeholder="t('idCardPlaceholder')" class="input-width" />
      </el-form-item>

      <el-form-item :label="t('mobile')" prop="mobile">
        <el-input v-model="formData.mobile" clearable :placeholder="t('mobilePlaceholder')" class="input-width" />
      </el-form-item>

      <el-form-item :label="t('avatar')">
        <upload-image v-model="formData.avatar" />
      </el-form-item>

      <el-form-item :label="t('status')" prop="status">
        <el-select class="input-width" v-model="formData.status" clearable :placeholder="t('statusPlaceholder')">
          <el-option label="请选择" value=""></el-option>
          <el-option v-for="(item, index) in statusList" :key="index" :label="item['name']" :value="item['value']" />
        </el-select>
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
  addRunningRider,
  editRunningRider,
  getRunningRiderInfo,
  getWithMemberList,
  getWithRunningSchoolList
} from '@/addon/running/api/running_rider'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import { computed, reactive, ref, watch } from 'vue'

const showDialog = ref(false)
const loading = ref(false)
const memberSearchLoading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
  id: '',
  school_id: '',
  member_id: '',
  real_name: '',
  id_card: '',
  mobile: '',
  avatar: '',
  status: ''
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
  return {
    school_id: [{ required: true, message: t('schoolIdPlaceholder'), trigger: 'blur' }],
    member_id: [{ required: true, message: t('memberIdPlaceholder'), trigger: 'blur' }],
    real_name: [{ required: true, message: t('realNamePlaceholder'), trigger: 'blur' }],
    id_card: [{ required: true, message: t('idCardPlaceholder'), trigger: 'blur' }],
    mobile: [{ required: true, message: t('mobilePlaceholder'), trigger: 'blur' }],
    avatar: [{ required: true, message: t('avatarPlaceholder'), trigger: 'blur' }],
    status: [{ required: true, message: t('statusPlaceholder'), trigger: 'blur' }]
  }
})

const emit = defineEmits(['complete'])

/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
  if (loading.value || !formEl) return
  const save = formData.id ? editRunningRider : addRunningRider

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
        .catch((err: Error) => {
          console.error('保存失败:', err.message || err)
          loading.value = false
        })
    }
  })
}

// 获取字典数据
const statusList = ref<any[]>([])
const statusDictList = async () => {
  try {
    statusList.value = await (await useDictionary('rider_status')).data.dictionary
  } catch (error: any) {
    console.error('获取状态字典失败:', error?.message || error)
    statusList.value = []
  }
}
statusDictList()
watch(
  () => statusList.value,
  () => {
    if (statusList.value && statusList.value.length > 0) {
      formData.status = statusList.value[0].value
    }
  }
)

const schoolIdList = ref([] as any[])
const setSchoolIdList = async () => {
  try {
    schoolIdList.value = await (await getWithRunningSchoolList({})).data
  } catch (error: any) {
    console.error('获取学校列表失败:', error?.message || error)
    schoolIdList.value = []
  }
}
setSchoolIdList()

// 会员列表
const memberIdList = ref([] as any[])

// 加载会员列表
const loadMemberList = async (keyword = '') => {
  try {
    memberSearchLoading.value = true
    const params: Record<string, any> = {}
    if (keyword) {
      params.keyword = keyword
    }
    const res = await getWithMemberList(params)
    memberIdList.value = res.data || []
  } catch (error: any) {
    console.error('获取会员列表失败:', error?.message || error)
    memberIdList.value = []
  } finally {
    memberSearchLoading.value = false
  }
}

// 远程搜索会员
const remoteMemberSearch = async (query: string) => {
  if (query !== '') {
    await loadMemberList(query)
  } else {
    memberIdList.value = []
  }
}

// 选择框显示变化
const handleSelectVisible = async (visible: boolean) => {
  if (visible) {
    await loadMemberList()
  }
}

// 初始加载时获取会员数据
watch(
  () => showDialog.value,
  (val) => {
    if (val && formData.member_id) {
      // 编辑模式下，获取当前选中会员的详情
      loadMemberList()
    }
  }
)

// 选择会员后自动填充相关字段
watch(
  () => formData.member_id,
  (newVal) => {
    if (newVal) {
      const selectedMember = memberIdList.value.find(item => String(item.member_id) === String(newVal))
      if (selectedMember) {
        // 自动填充手机号
        if (selectedMember.mobile && !formData.mobile) {
          formData.mobile = selectedMember.mobile
        }
        // 自动填充头像
        if (selectedMember.headimg && !formData.avatar) {
          formData.avatar = selectedMember.headimg
        }
      }
    }
  }
)

const setFormData = async (row: any = null) => {
  Object.assign(formData, initialFormData)
  loading.value = true
  if (row) {
    try {
      const data = await (await getRunningRiderInfo(row.id)).data
      if (data) {
        Object.keys(formData).forEach((key: string) => {
          if (data[key] != undefined) formData[key] = data[key]
        })
      }
    } catch (error: any) {
      console.error('获取骑手信息失败:', error?.message || error)
    }
  }
  loading.value = false
}

defineExpose({
  showDialog,
  setFormData
})
</script>

<style lang="scss" scoped>
.member-option {
  display: flex;
  align-items: center;
  padding: 5px 0;

  .member-avatar {
    margin-right: 10px;
  }

  .member-info {
    display: flex;
    flex-direction: column;

    .member-name {
      font-weight: bold;
    }

    .member-mobile {
      font-size: 12px;
      color: #999;
    }
  }
}

.empty-text {
  padding: 10px 0;
  text-align: center;
  color: #999;
  font-size: 14px;
}
</style>
<style lang="scss">
.diy-dialog-wrap .el-form-item__label {
  height: auto !important;
}
</style>