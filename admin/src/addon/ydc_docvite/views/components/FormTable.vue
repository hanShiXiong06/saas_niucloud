<template>
    <div class="ydc-shipmarkdown-form-table">
        <el-table :data="data" ref="table" :key="toggleIndex" border stripe>
            <el-table-column type="index" width="50" fixed="left">
                <template #header>
                    <el-button type="primary" icon="Plus" size="small" :plain="true" :circle="true" @click="rowAdd"></el-button>
                </template>
                <template #default="scope">
                    <div class="ydc-shipmarkdown-form-table-handle">
                        <span>{{ scope.$index + 1 }}</span>
                        <el-button
                            v-if="scope.row.hideInTable"
                            disabled
                            type="danger"
                            icon="Delete"
                            size="small"
                            plain
                            circle
                            @click="rowDel(scope.row, scope.$index)"
                        ></el-button>
                        <el-button
                            v-else
                            type="danger"
                            icon="Delete"
                            size="small"
                            plain
                            circle
                            @click="rowDel(scope.row, scope.$index)"
                        ></el-button>
                    </div>
                </template>
            </el-table-column>
            <el-table-column label="" width="58" v-if="dragSort">
                <template #default>
                    <el-tag class="move" style="cursor: move">
                        <el-icon><DCaret /></el-icon>
                    </el-tag>
                </template>
            </el-table-column>
            <slot></slot>
            <template #empty>
                {{ placeholder }}
            </template>
        </el-table>
    </div>
</template>

<script>
import Sortable from 'sortablejs'

export default {
    props: {
        modelValue: { type: Array, default: () => [] },
        addTemplate: { type: Object, default: () => {} },
        placeholder: { type: String, default: '暂无数据' },
        dragSort: { type: Boolean, default: false },
    },
    data() {
        return {
            toggleIndex: 0,
        }
    },
    mounted() {
        this.data = this.modelValue
        if (this.dragSort) {
            this.rowDrop()
        }
    },
    computed: {
        data: {
            get() {
                return this.modelValue
            },
            set(value) {
                this.$emit('update:modelValue', value)
            },
        },
    },
    methods: {
        rowDrop() {
            const _this = this
            const tbody = this.$refs.table.$el.querySelector('.el-table__body-wrapper tbody')
            Sortable.create(tbody, {
                handle: '.move',
                animation: 300,
                ghostClass: 'ghost',
                onEnd({ newIndex, oldIndex }) {
                    const tableData = _this.data
                    const currRow = tableData.splice(oldIndex, 1)[0]
                    tableData.splice(newIndex, 0, currRow)
                    _this.toggleIndex += 1
                    _this.$nextTick(() => {
                        _this.rowDrop()
                    })
                },
            })
        },
        rowAdd() {
            const temp = JSON.parse(JSON.stringify(this.addTemplate))
            this.data.push(temp)
        },
        rowDel(row, index) {
            this.data.splice(index, 1)
        },
    },
}
</script>

<style scoped lang="scss">
.move {
    :deep(.el-icon) {
        width: 13px;
        height: 13px;
        color: #206de0;
    }
}
.ydc-shipmarkdown-form-table {
    width: 100%;
}
.ydc-shipmarkdown-form-table .ydc-shipmarkdown-form-table-handle {
    text-align: center;
}
.ydc-shipmarkdown-form-table .ydc-shipmarkdown-form-table-handle span {
    display: inline-block;
}
.ydc-shipmarkdown-form-table .ydc-shipmarkdown-form-table-handle button {
    display: none;
}
.ydc-shipmarkdown-form-table .hover-row .ydc-shipmarkdown-form-table-handle span {
    display: none;
}
.ydc-shipmarkdown-form-table .hover-row .ydc-shipmarkdown-form-table-handle button {
    display: inline-block;
}
</style>
