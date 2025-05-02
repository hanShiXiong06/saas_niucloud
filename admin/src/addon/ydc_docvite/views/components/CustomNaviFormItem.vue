<template>
    <mnFormTable v-model="data" drag-sort :addTemplate="addTemplate" placeholder="暂无数据">
        <el-table-column prop="text" label="文本">
            <template #default="scope">
                <el-input v-model="scope.row.text" placeholder="请输入文本"></el-input>
            </template>
        </el-table-column>
        <el-table-column prop="url" label="链接">
            <template #default="scope">
                <el-input v-model="scope.row.url" placeholder="请输入链接"></el-input>
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
    },
    data() {
        return {
            visible: false,
            formlist: [],
            addTemplate: {
                text: '',
                url: '',
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
