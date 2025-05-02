<template>
    <u-popup :show="show" @close="show = false" mode="bottom" :round="10" :closeable="true">
        <view class="text-center p-[30rpx] font-500">密码验证</view>
        <scroll-view class="h-[40vh]">
            <view class="p-[30rpx] pt-0 text-sm">
                <u-form labelPosition="left" :model="formData" labelWidth="200rpx" errorType='toast' :rules="rules" ref="formRef">
                    <view class="mt-[10rpx]">
                        <u-form-item label="密码" prop="realname" :border-bottom="true">
                            <u-input type="password" v-model="formData.password" border="none" clearable
                                placeholder="请输入密码"></u-input>
                        </u-form-item>
                    </view>
                </u-form>
            </view>
        </scroll-view>
        <view class="p-[30rpx]">
            <u-button type="primary" shape="circle" @click="confirm">确认</u-button>
        </view>
		
    </u-popup>
</template>

<script setup lang="ts">
    import { ref, computed } from 'vue'

    const show = ref(false)
	
    const formData = ref({
        password: '',
    })
    
    const formRef = ref(null)

    const rules = computed(() => {
        return {
            'password': {
                type: 'string',
                required: true,
                message: '请输入密码',
                trigger: ['blur', 'change'],
            },
        }
    })

    const open = () => {
        show.value = true
    }
	
	const close = () => {
		show.value = false
	}

    const emits = defineEmits(['confirm'])

    const confirm = () => {
        formRef.value.validate().then(() => {
            emits('confirm', formData.value)
        })
    }
	

    defineExpose({
        open,
		close
    })
</script>

<style>
	@import '@/addon/zzexam/styles/common.scss';
</style>
