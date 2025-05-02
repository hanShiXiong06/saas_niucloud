<template>
    <div class="main-container">
        <el-card>
            <el-tabs v-model="activeName" class="demo-tabs" @tab-click="handleClick">
                <el-tab-pane label="使用文档" name="second">
                    <div style="height: 100%;">
                        <iframe scrolling="yes"
                            src="https://jq5lf6h243n.feishu.cn/wiki/YaUzw5ZLSifld7kQ2SIcr6XNndb?from=from_copylink"
                            style="width: 100%;height: 100%;"></iframe>
                    </div>
                </el-tab-pane>

            </el-tabs>
        </el-card>

    </div>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue'
const activeName = ref('second')
const iframeSrc = ref('https://6gp5778g2b.k.topthink.com/@l4rz136xpx/pingtaiduijie.html');
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