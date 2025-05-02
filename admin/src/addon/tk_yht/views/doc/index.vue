<template>
    <div class="main-container">
        <el-card>
            <el-tabs v-model="activeName" class="demo-tabs" @tab-click="handleClick">
                <el-tab-pane label="接口调用" name="first">
                    <div style="height: 100%;">
                        <iframe :src="iframeSrc" ref="iframeRef" scrolling="yes"
                            style="width: 100%;height: 100%;"></iframe>
                    </div>
                </el-tab-pane>
                <el-tab-pane label="使用文档" name="second">
                    <div style="height: 100%;">
                        <iframe scrolling="yes" src="https://jq5lf6h243n.feishu.cn/wiki/MKnQwkE41i2HWlkfYA2cOMJHnEc"
                            style="width: 100%;height: 100%;"></iframe>
                    </div>
                </el-tab-pane>

            </el-tabs>
        </el-card>

    </div>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue'
const activeName = ref('first')
const iframeSrc = ref('https://api.crmeb.com/docs/%E5%BF%AB%E9%80%9F%E5%85%A5%E9%97%A8/');
const iframeRef = ref(null);


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

.el-tabs--card {
    height: calc(100vh - 110px);
    /* overflow-y: auto; */
}

.el-tab-pane {
    height: calc(100vh - 110px);
    overflow-y: auto;
}
</style>