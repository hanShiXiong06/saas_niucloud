<template>
  <div class="main-container">
    <el-card class="box-card !border-none" shadow="never">
      <div class="flex justify-between items-center">
        <span class="text-lg">{{ pageName }}</span>
        <el-button type="primary" @click="addEvent">
          {{ t('addRunningBuilding') }}
        </el-button>
      </div>

      <el-card class="box-card !border-none my-[10px] table-search-wrap" shadow="never">
        <el-form :inline="true" :model="runningBuildingTable.searchParam" ref="searchFormRef">
          <el-form-item :label="t('schoolId')" prop="school_id">
            <el-select class="w-[280px]" v-model="runningBuildingTable.searchParam.school_id" clearable
              :placeholder="t('schoolIdPlaceholder')">
              <el-option v-for="(item, index) in schoolIdList" :key="index" :label="item['name']" :value="item['id']" />
            </el-select>
          </el-form-item>

          <el-form-item :label="t('name')" prop="name">
            <el-input v-model="runningBuildingTable.searchParam.name" :placeholder="t('namePlaceholder')" />
          </el-form-item>

          <el-form-item :label="t('status')" prop="status">
            <el-select class="w-[280px]" v-model="runningBuildingTable.searchParam.status" clearable
              :placeholder="t('statusPlaceholder')">
              <el-option label="全部" value=""></el-option>
              <el-option v-for="(item, index) in statusList" :key="index" :label="item.name" :value="item.value" />
            </el-select>
          </el-form-item>

          <el-form-item :label="t('createTime')" prop="create_time">
            <el-input v-model="runningBuildingTable.searchParam.create_time"
              :placeholder="t('createTimePlaceholder')" />
          </el-form-item>
          <el-form-item :label="t('updateTime')" prop="update_time">
            <el-input v-model="runningBuildingTable.searchParam.update_time"
              :placeholder="t('updateTimePlaceholder')" />
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="loadRunningBuildingList()">{{
              t('search')
              }}</el-button>
            <el-button @click="resetForm(searchFormRef)">{{ t('reset') }}</el-button>
          </el-form-item>
        </el-form>
      </el-card>

      <div class="mt-[10px]">
        <el-table :data="runningBuildingTable.data" ref="tableRef" size="large" v-loading="runningBuildingTable.loading"
          row-key="id" :tree-props="{ hasChildren: 'hasChildren', children: 'children' }">
          <template #empty>
            <span>{{ !runningBuildingTable.loading ? t('emptyData') : '' }}</span>
          </template>

          <el-table-column :label="t('name')" min-width="150">
            <template #default="{ row }">
              <i class="order-0 iconfont icontuodong vues-rank mr-[8px]"></i>
              <span class="order-2">{{ row.name }}</span>
            </template>
          </el-table-column>

          <el-table-column prop="school_id_name" :label="t('schoolId')" min-width="120" :show-overflow-tooltip="true" />

          <el-table-column :label="t('status')" min-width="120" align="center" :show-overflow-tooltip="true">
            <template #default="{ row }">
              <el-tag :type="row.status === 1 ? 'success' : 'danger'" class="cursor-pointer" @click="changeStatus(row)">
                {{ row.status === 1 ? '启用' : '禁用' }}
              </el-tag>
            </template>
          </el-table-column>

          <el-table-column prop="sort" :label="t('sort')" min-width="80" />

          <el-table-column prop="level" :label="t('level')" min-width="80" />

          <el-table-column :label="t('operation')" fixed="right" width="200">
            <template #default="{ row }">
              <el-button type="primary" link @click="addChildEvent(row)">{{ t('添加子类') }}</el-button>
              <el-button type="primary" link @click="editEvent(row)">{{ t('edit') }}</el-button>
              <el-button type="primary" link @click="deleteEvent(row.id)">{{
                t('delete')
                }}</el-button>
            </template>
          </el-table-column>
        </el-table>
        <div class="mt-[16px] flex justify-end">
          <el-pagination v-model:current-page="runningBuildingTable.page" v-model:page-size="runningBuildingTable.limit"
            layout="total, sizes, prev, pager, next, jumper" :total="runningBuildingTable.total"
            @size-change="loadRunningBuildingList()" @current-change="loadRunningBuildingList" />
        </div>
      </div>

      <edit ref="editRunningBuildingDialog" @complete="loadRunningBuildingList" />
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import {
  deleteRunningBuilding,
  getRunningBuildingList,
  getWithRunningSchoolList,
  editRunningBuilding
} from '@/addon/running/api/running_building'
import Edit from '@/addon/running/views/running_building/components/running-building-edit.vue'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import { ElMessageBox, FormInstance } from 'element-plus'
import { reactive, ref, onMounted, nextTick } from 'vue'
import { useRoute } from 'vue-router'
import Sortable from 'sortablejs'
import { cloneDeep } from 'lodash-es'

const route = useRoute()
const pageName = route.meta.title
const tableRef = ref()

const runningBuildingTable = reactive({
  page: 1,
  limit: 10,
  total: 0,
  loading: true,
  data: [],
  searchParam: {
    school_id: '',
    name: '',
    status: ''
  }
})

const searchFormRef = ref<FormInstance>()

// 字典数据
const statusList = ref([] as any[])
const statusDictList = async () => {
  statusList.value = await (await useDictionary('status')).data.dictionary
}
statusDictList()

onMounted(() => {
  nextTick(() => {
    rowDrop()
  })
  loadRunningBuildingList()
})

// 拖拽
const activeRows = ref<any[]>([])
// 拖拽排序
const rowDrop = () => {
  const tbody = tableRef.value.$el.querySelector('.el-table__body-wrapper tbody')
  Sortable.create(tbody, {
    handle: '.vues-rank',
    animation: 300,
    onMove: ({ dragged, related }) => {
      const oldRow = activeRows.value[dragged.rowIndex] // 移动的那个元素
      const newRow = activeRows.value[related.rowIndex] // 新的元素
      if (oldRow.pid !== newRow.pid) { // 移动的元素与新元素父级id不相同
        return false // 不允许跨级拖动
      }
    },
    onStart: () => { // 开始拖拽前把树形结构数据扁平化
      activeRows.value = treeToTile(cloneDeep(runningBuildingTable.data)) // 把树形的结构转为列表再进行拖拽
    },
    onEnd: e => {
      const oldRow = activeRows.value[e.oldIndex] // 移动的那个元素
      const newRow = activeRows.value[e.newIndex] // 新的元素

      if (e.oldIndex === e.newIndex || oldRow.pid !== newRow.pid) return false

      const index = activeRows.value.indexOf(oldRow)

      if (index < 0) return false

      const currRow = activeRows.value.splice(e.oldIndex, 1)[0]
      activeRows.value.splice(e.newIndex, 0, currRow)

      const pid = newRow.pid
      const currentRows = activeRows.value.filter(c => c.pid === pid)?.map((item, index) => {
        if (item.level === 1 && item.id === currRow.id) {
          runningBuildingTable.data = runningBuildingTable.data.filter(c => c.id !== currRow.id)
          runningBuildingTable.data.splice(index, 0, currRow)
        }
        if (item.level > 1 && item.id === currRow.id) {
          const treeIndex = findTreeIndexById(runningBuildingTable.data, item.pid)
          if (treeIndex !== -1) {
            const parent = getNodeById(runningBuildingTable.data, item.pid)
            if (parent && parent.children) {
              const obj = cloneDeep(parent.children.filter(c => c.id !== currRow.id))
              parent.children = []
              parent.children.push(...obj)
              parent.children.splice(index, 0, currRow)
            }
          }
        }
        return {
          id: item.id, // 当前行的唯一标识
          sort: 9999 - index
        }
      })
      updateSort(currentRows)
    }
  })
}

/**
 * 查找节点在树中的索引
 */
const findTreeIndexById = (tree, id) => {
  for (let i = 0; i < tree.length; i++) {
    if (tree[i].id === id) {
      return i
    }
    if (tree[i].children) {
      const index = findTreeIndexById(tree[i].children, id)
      if (index !== -1) {
        return index
      }
    }
  }
  return -1
}

/**
 * 根据ID获取节点
 */
const getNodeById = (tree, id) => {
  for (let i = 0; i < tree.length; i++) {
    if (tree[i].id === id) {
      return tree[i]
    }
    if (tree[i].children) {
      const node = getNodeById(tree[i].children, id)
      if (node) {
        return node
      }
    }
  }
  return null
}

/**
 * 更新排序
 */
const updateSort = (sortData) => {
  if (!sortData || !sortData.length) return

  sortData.forEach(item => {
    editRunningBuilding({
      id: item.id,
      sort: item.sort
    }).catch(() => { })
  })

  setTimeout(() => {
    loadRunningBuildingList()
  }, 500)
}

/**
 * 将树数据转化为平铺数据
 * @param <Array> treeData当前要转的id
 * @param <String> childKey 子级字段
 * @return <Array> 返回数据
 */
const treeToTile = (treeData, childKey = 'children') => {
  const arr = []
  const expanded = (data) => {
    if (data && data.length > 0) {
      data.filter((d) => d).forEach((e) => {
        arr.push(e)
        expanded(e[childKey] || [])
      })
    }
  }
  expanded(treeData)
  return arr
}

/**
 * 获取收货楼栋列表
 */
const loadRunningBuildingList = () => {
  runningBuildingTable.loading = true

  getRunningBuildingList({
    ...runningBuildingTable.searchParam
  })
    .then((res) => {
      runningBuildingTable.loading = false
      runningBuildingTable.data = res.data
    })
    .catch(() => {
      runningBuildingTable.loading = false
    })
}

const editRunningBuildingDialog = ref(null)

/**
 * 添加收货楼栋
 */
const addEvent = () => {
  editRunningBuildingDialog.value.setFormData()
  editRunningBuildingDialog.value.showDialog = true
}

/**
 * 添加子楼栋
 */
const addChildEvent = (row) => {
  editRunningBuildingDialog.value.setFormData({
    pid: row.id,
    school_id: row.school_id
  })
  editRunningBuildingDialog.value.showDialog = true
}

/**
 * 编辑收货楼栋
 * @param data
 */
const editEvent = (data) => {
  editRunningBuildingDialog.value.setFormData(data)
  editRunningBuildingDialog.value.showDialog = true
}

/**
 * 删除收货楼栋
 */
const deleteEvent = (id) => {
  ElMessageBox.confirm(t('runningBuildingDeleteTips'), t('warning'), {
    confirmButtonText: t('confirm'),
    cancelButtonText: t('cancel'),
    type: 'warning'
  }).then(() => {
    deleteRunningBuilding(id)
      .then(() => {
        loadRunningBuildingList()
      })
      .catch(() => { })
  })
}

/**
 * 修改状态
 */
const changeStatus = (row) => {
  const newStatus = row.status === 1 ? 0 : 1
  editRunningBuilding({
    id: row.id,
    status: newStatus
  }).then(() => {
    row.status = newStatus
  }).catch(() => { })
}

const schoolIdList = ref([])
const setSchoolIdList = async () => {
  schoolIdList.value = await (await getWithRunningSchoolList({})).data
}
setSchoolIdList()

const resetForm = (formEl) => {
  if (!formEl) return
  formEl.resetFields()
  loadRunningBuildingList()
}
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

:deep(.el-table__row) {
  >.el-table__cell:nth-child(1) {
    .cell {
      display: flex;
      align-items: center;
    }
  }
}
</style>
