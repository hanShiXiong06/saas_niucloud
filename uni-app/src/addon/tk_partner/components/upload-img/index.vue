<template>
    <view class="upload-img">
        <u-upload :fileList="fileList" @afterRead="afterRead" @delete="deletePic" :maxCount="maxCount"
            :multiple="multiple" :width="width" :height="height" :imageMode="imageMode" :uploadIcon="uploadIcon"
            :uploadText="uploadText" :deletable="true" :maxSize="maxSize" :accept="accept"></u-upload>
    </view>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

interface Props {
    modelValue: string | string[]
    maxCount?: number
    multiple?: boolean
    width?: number
    height?: number
    imageMode?: string
    uploadIcon?: string
    uploadText?: string
    maxSize?: number
    accept?: string
}

const props = withDefaults(defineProps<Props>(), {
    maxCount: 1,
    multiple: false,
    width: 200,
    height: 200,
    imageMode: 'aspectFill',
    uploadIcon: 'camera-fill',
    uploadText: '上传图片',
    maxSize: 10,
    accept: 'image'
})

const emit = defineEmits(['update:modelValue'])

const fileList = ref<any[]>([])

// 监听modelValue变化
watch(() => props.modelValue, (newVal) => {
    if (newVal) {
        if (Array.isArray(newVal)) {
            fileList.value = newVal.map(url => ({
                url,
                status: 'success'
            }))
        } else {
            fileList.value = [{
                url: newVal,
                status: 'success'
            }]
        }
    } else {
        fileList.value = []
    }
}, { immediate: true })

// 上传后回调
const afterRead = (event: any) => {
    const { file } = event
    // 这里可以处理文件上传逻辑
    // 示例：直接使用本地文件URL
    if (props.multiple) {
        const urls = fileList.value.map(item => item.url)
        emit('update:modelValue', urls)
    } else {
        emit('update:modelValue', file.url)
    }
}

// 删除图片
const deletePic = (event: any) => {
    const { index } = event
    if (props.multiple) {
        const urls = fileList.value.map(item => item.url)
        urls.splice(index, 1)
        emit('update:modelValue', urls)
    } else {
        emit('update:modelValue', '')
    }
}
</script>

<style lang="scss" scoped>
.upload-img {
    :deep(.u-upload) {
        .u-upload__wrap {
            .u-upload__wrap__preview {
                .u-upload__wrap__preview__image {
                    width: 100%;
                    height: 100%;
                }
            }
        }
    }
}
</style>