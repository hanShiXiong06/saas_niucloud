<template>
    <u-popup :show="show" @close="show = false" mode="bottom" :round="10" :closeable="true">
        <view class="text-center p-[30rpx] font-500">考试报名</view>
        <scroll-view class="h-[40vh]">
            <view class="p-[30rpx] pt-0 text-sm">
                <u-form labelPosition="left" :model="formData" labelWidth="200rpx" errorType='toast' :rules="rules" ref="formRef">
                    <view class="mt-[10rpx]">
                        <u-form-item label="姓名" prop="realname" :border-bottom="true">
                            <u-input v-model="formData.realname" border="none" clearable
                                placeholder="请输入姓名"></u-input>
                        </u-form-item>
                    </view>
					
					<view class="mt-[10rpx]">
					    <u-form-item label="手机号码" prop="mobile" :border-bottom="true">
					        <u-input v-model="formData.mobile" border="none" clearable
					            placeholder="请输入手机号码"></u-input>
					    </u-form-item>
					</view>
                </u-form>
            </view>
        </scroll-view>
        <view class="p-[30rpx]">
            <u-button type="primary" shape="circle" @click="confirm">确认报名</u-button>
        </view>
		
    </u-popup>
</template>

<script setup lang="ts">
    import { ref, computed } from 'vue'

    const show = ref(false)
	
    const formData = ref({
        realname: '',
        mobile: '',
    })
    
    const formRef = ref(null)

    const rules = computed(() => {
        return {
            'realname': {
                type: 'string',
                required: true,
                message: '请输入姓名',
                trigger: ['blur', 'change'],
            },
            'mobile': [
                {
                    type: 'string',
                    required: true,
                    message: '请输入手机号码',
                    trigger: ['blur', 'change'],
                },
                {
                    validator(rule: any, value: any, callback: any) {
                        let mobile = /^1[3-9]\d{9}$/;
                        if (!mobile.test(value)){
                            callback(new Error('请输入正确的手机号'))
                        } else {
                            callback()
                        }
                    }
                }
            ],
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
