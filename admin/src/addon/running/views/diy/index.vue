<template>
    <div class="w-full">
        <component :is="diyEditComponent" v-if="diyStore.currentComponent != 'edit-page'">
            <template #style>
                <!-- 此处原本引用了不存在的DiyStyle组件 -->
            </template>
        </component>
    </div>
</template>

<script lang="ts" setup>
import { computed, markRaw } from 'vue'
import useDiyStore from '@/stores/modules/diy'
import EditRiderTechnician from './components/edit-rider-technician.vue'

const diyStore = useDiyStore()

// 编辑组件映射
const componentMap: Record<string, any> = {
    EditRiderTechnician
}

const diyEditComponent = computed(() => {
    const component = componentMap[diyStore.currentComponent] || null
    return component ? markRaw(component) : null
})

// 组件类别数据
const riderComponents = [
    {
        type: 'base',
        name: '基础组件',
        components: [
            {
                name: 'RiderTechnician',
                title: '骑手入口',
                icon: 'iconfont icon-fuwurenyuan',
                componentTitle: '骑手入口',
                componentName: 'RiderTechnician',
                componentType: 'EditRiderTechnician',
                isDelete: false,
                isDisabled: false,
                allPages: true,
                defaultDataList: {},
                extra: {},
                marginTop: 5,
                paddingTop: 10,
                paddingBottom: 10,
                marginBottom: 5,
                bgColor: '#f0f5ff',
                textColor: '#3B82F6',
                imageUrl: ''
            }
        ]
    }
]

// 加入到全局组件列表中
if (diyStore.components) {
    diyStore.components.push(...riderComponents)
}
</script>

<style lang="scss" scoped>
</style> 