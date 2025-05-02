<template>
    <!-- 内容配置 -->
    <div class="content-wrap" v-show="diyStore.editTab == 'content'">
        <div class="edit-attr-item-wrap">
            <h3 class="mb-[10px]">骑手入口设置</h3>
            <el-form label-width="100px" class="px-[10px]">
                <el-form-item label="标题文本">
                    <el-input v-model.trim="diyStore.editComponent.title" placeholder="请输入标题文本" clearable maxlength="20" show-word-limit />
                </el-form-item>
                <el-form-item label="背景颜色">
                    <el-color-picker v-model="diyStore.editComponent.bgColor" show-alpha />
                </el-form-item>
                <el-form-item label="文字颜色">
                    <el-color-picker v-model="diyStore.editComponent.textColor" show-alpha />
                </el-form-item>
                <el-form-item label="上传图片">
                    <upload-image v-model="diyStore.editComponent.imageUrl" :limit="1" />
                    <div class="el-form-item-msg">
                        <span>建议尺寸：690 x 180 像素</span>
                    </div>
                </el-form-item>
            </el-form>
        </div>
    </div>
    
    <!-- 样式配置 -->
    <div class="style-wrap" v-show="diyStore.editTab == 'style'">
        <!-- 组件样式 -->
        <slot name="style"></slot>
    </div>
</template>

<script lang="ts" setup>
import useDiyStore from '@/stores/modules/diy'

const diyStore = useDiyStore()

// 初始化组件默认值
if (!diyStore.editComponent.title) {
    diyStore.editComponent.title = '骑手招募'
}

if (!diyStore.editComponent.bgColor) {
    diyStore.editComponent.bgColor = '#f0f5ff'
}

if (!diyStore.editComponent.textColor) {
    diyStore.editComponent.textColor = '#3B82F6'
}

// 忽略公共属性
diyStore.editComponent.ignore = []

defineExpose({})
</script>

<style lang="scss" scoped>
.el-form-item-msg {
    font-size: 12px;
    color: #999;
    margin-top: 5px;
}
</style> 