<template>
    <mnFormTable v-model="data" drag-sort :addTemplate="addTemplate" placeholder="暂无数据">
        <el-table-column prop="key" label="键名">
            <template #default="scope">
                <el-input v-model="scope.row.key" placeholder="请输入内容"></el-input>
            </template>
        </el-table-column>
        <el-table-column prop="value" label="键值">
            <template #default="scope">
                <el-input v-model="scope.row.value" placeholder="请输入内容"></el-input>
            </template>
        </el-table-column>
    </mnFormTable>
</template>

<script>
import mnFormTable from './FormTable.vue'
export default {
    components: { mnFormTable },
    emits: ['update:modelValue'],
    props: {
        modelValue: {
            type: Array,
            default: () => {
                return []
            },
        },
        isAdd: {
            type: Boolean,
            default: true,
        },
    },
    data() {
        return {
            visible: false,
            formlist: [],
            addTemplate: {
                key: '',
                value: '',
            },
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
    methods: {},
}
</script>

<style scoped lang="scss">
.el-form-item .el-form-item {
    margin-bottom: 18px;
}
.header {
    width: 100%;
    display: flex;
    justify-content: space-between;
    .icon {
        display: none;
    }
}
.header:hover {
    .icon {
        display: block;
    }
}
</style>
