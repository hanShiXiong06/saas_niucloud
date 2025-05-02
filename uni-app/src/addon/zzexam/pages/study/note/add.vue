<template>
    <view  :style="themeColor()" class="w-screen h-screen bg-[var(--page-bg-color)] overflow-hidden pb-[100rpx]">
        <scroll-view scroll-y="true" >
            <view>
                <u-form :model="formData"  errorType='toast' :rules="rules" ref="formRef">
					<view class="py-[10rpx] px-[30rpx]  mt-[2rpx] relative">
					    <u-form-item prop="content">
					        <textarea class="bg-white rounded-[10rpx] p-[20rpx] w-[650rpx]" v-model="formData.content" placeholder="请在此输入笔记内容" maxlength="500" />
					        <view class="text-right text-[24rpx] text-[#888] absolute right-[40rpx] bottom-[40rpx]">
					             {{ formData.content.length }}/500
					        </view>
					    </u-form-item>
					</view>
                </u-form>
            </view>
			<view class="common-tab-bar-placeholder"></view>
			<view class="common-tab-bar fixed left-[var(--sidebar-m)] right-[var(--sidebar-m)] bottom-[0]">
				<button :loading="loading" class="primary-btn-bg text-[#fff] h-[80rpx] leading-[80rpx] rounded-[100rpx] text-[26rpx] font-500" @click="handleSave">保存</button>
			</view>
        </scroll-view>
    </view>
</template>

<script setup lang="ts">
    import { ref, computed, reactive } from 'vue'
	import { onLoad } from '@dcloudio/uni-app'
    import { addNote,getNoteDetail,editNote } from '@/addon/zzexam/api/study'
    import { redirect,goback } from '@/utils/common'
	
    const loading = ref(false)
    const formRef: any = ref(null)
    const formData = reactive<AnyObject>({
		note_id:'',
		content:'',
		type:'',
		target_id:''
    })
	
	onLoad((option) => {
		formData.type = option.type;
		formData.target_id = option.target_id;
		if(option.note_id){
			getNoteDetail(option.note_id).then((res) => {
				const data = res.data
				Object.keys(formData).forEach((key: string) => {
				    if (data[key] != undefined) formData[key] = data[key]
				})
			});
		}
	})

    const rules = computed(() => {
        return {
			'content': {
			    type: 'string',
			    required: true,
			    message: '请输入笔记内容',
			    trigger: ['blur', 'change'],
			},
        }
    })

    const handleSave = () => {
        formRef.value.validate().then(() => {
            if (loading.value) return
            loading.value = true
			
			const save = formData.note_id ? editNote : addNote
			
            save(formData).then(() => {
				loading.value = false
				
				
                setTimeout(()=>{
					let url = '';
					if(formData.type == 'know'){
						url = '/addon/zzexam/pages/study/know/detail'
					}
					if(formData.type == 'notice'){
						url = '/addon/zzexam/pages/study/notice/detail'
					}
					if(formData.type == 'article'){
						url = '/addon/zzexam/pages/study/article/detail'
					}
					redirect({
					    url: url,
					    mode: 'redirectTo',
					    param: {id: formData.target_id}
					})
				},2000)
            }).catch(() => {
                loading.value = false
            })
        })
    }
	
	const buildChange = (e: any) => {
		buildIndex.value = e.detail.value;
		formData.member_build_id = buildList.value[buildIndex.value].id;
		formData.build_name	= buildList.value[buildIndex.value].build_name;
		formData.realname = buildList.value[buildIndex.value].realname;
		formData.mobile = buildList.value[buildIndex.value].mobile;
	}
    
</script>

<style>
	@import '@/addon/zzexam/styles/common.scss';
</style>
