<template>
    <el-card class="pathSelectContainer" v-loading="loading">
        <template #header>
            <el-input type="text" v-model="filterText" placeholder="请输入搜索内容" />
        </template>
        <div class="mainTree">
            <el-scrollbar style="height: 100%">
                <el-empty v-if="!data || data.length == 0" description="无数据" :image-size="80"></el-empty>
                <div class="treeBody" v-else>
                    <el-tree
                        ref="tree"
                        :data="data"
                        node-key="id"
                        :show-checkbox="!this.disabled"
                        check-strictly
                        default-expand-all
                        :filter-node-method="filterNode"
                        @check-change="handleCheckChange"
                    >
                        <template #default="{ node }">
                            <span class="treeNode">
                                <span class="name"
                                    ><el-tag type="info">目录: {{ node.label }}</el-tag>
                                    <el-tag type="success" v-if="node?.data?.alias_name !== ''">别名: {{ node.data.alias_name }}</el-tag>
                                    <template v-if="node?.data?.parent_id == 0">
                                        <el-tag type="warning" v-if="node?.data?.name === 'blog'">动态根目录</el-tag>
                                        <el-tag type="warning" v-if="node?.data?.name === 'docs'">文档根目录</el-tag>
                                    </template>
                                </span>
                            </span>
                        </template>
                    </el-tree>
                </div>
            </el-scrollbar>
        </div>
    </el-card>
</template>

<script>
import { selectTree as  selectTreeApi} from "@/addon/ydc_docvite/api/path";
export default {
    name: 'pathSelectTree',
    emits: ['checked', 'update:modelValue'],
    props: {
        disabled: {
            type: Boolean,
            default: () => {
                return false
            },
        },
        modelValue: {
            type: Number,
            default: () => {
                return 0
            },
        },
        vaultId: {
            type: Number,
            default: () => {
                return 0
            },
        },
        selectedId: {
            type: Number,
            default: () => {
                return 0
            },
        },
    },
    data() {
        return {
            loading: false,
            filterText: '',
            checkedItem: this.modelValue ?? null,
            data: [],
        }
    },
    watch: {
        // 过滤操作
        filterText(val) {
            if (!this.data || this.data.length == 0) {
                return
            }
            this.$refs.tree.filter(val)
        },
        vaultId: {
            handler(newVal) {
                if (newVal) {
                    this.loadFormPath()
                }
            },
            immediate: true,
            deep: true,
        },
        checkedItem: {
            handler(newVal) {
                if (newVal) {
                    this.$emit('checked', newVal)
                }
            },
            immediate: true,
            deep: true,
        },
    },
    computed: {
        checkedId: {
            get() {
                return this.modelValue
            },
            set(value) {
                this.$emit('update:modelValue', value)
            },
        },
    },
    mounted() {
        // this.loadFormPath()
    },
    methods: {
        loadFormPath() {
            if (this.vaultId === 0) {
                this.$message.error('未选择仓库')
                return
            }
            selectTreeApi({
                vault_id: this.vaultId,
            })
                .then((res) => {
                    this.data = res?.data ?? []
                })
                .finally(() => {})
        },
        filterNode(v, data) {
            if (!v) {
                return true
            }

            return data.label.indexOf(v) !== -1 || data?.alias_name?.indexOf(v) !== -1
        },
        handleCheckChange(data, checked) {
            if (checked) {
                this.checkedId = data.id
                this.checkedItem = data
                this.$refs.tree.setCheckedKeys([data.id])
                return
            }

            this.$refs.tree.setCheckedKeys([])
        },
    },
}
</script>

<style scoped lang="scss">
.pathSelectContainer {
    width: 100%;
    height: 400px;
    overflow-y: auto;
    .el-tag + .el-tag {
        margin-left: 5px;
    }
    .mainTree {
        margin-top: 30px;
        overflow: auto;
        width: 100%;

        .treeBody {
            margin-bottom: 30px;
            :deep(.el-tree-node > .el-tree-node__children) {
                overflow: inherit !important;
            }
        }
    }
}
</style>
