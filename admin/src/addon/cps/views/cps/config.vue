<template>
    <div class="main-container">
        <div class="flex ml-[18px] justify-between items-center mt-[20px] mb-[5px]">
			<span class="text-[20px]">{{pageName}}</span>
		</div>
		<div class="flex ml-[18px] justify-between items-center mt-[20px] mb-[5px]">
			<span class="text-[15px]"><a href="https://xuanloo.com/faq/67.html" target="_blank">点击查看cps联盟教程</a></span>
		</div> 
        <el-form :model="formData" label-width="150px" ref="formRef" :rules="formRules" class="page-form" v-loading="loading">
            <el-card class="box-card !border-none" shadow="never">
                <h3 class="panel-title !text-sm">蚂蚁星球<a href="http://www.haojingke.com" target="_blank">  点我注册</a></h3>

                <el-form-item label="会员id" prop="my_uid">
                    <el-input v-model="formData.my_uid" placeholder="请输入会员id" class="input-width" clearable />
                </el-form-item> 
              
              <el-form-item label="apikey" prop="my_apikey">
                  <el-input v-model="formData.my_apikey" placeholder="请输入apikey" class="input-width" clearable />
              </el-form-item>
              
              <el-form-item label="secret" prop="my_secret">
                  <el-input v-model="formData.my_secret" placeholder="请输入secret" class="input-width" clearable />
              </el-form-item> 
            </el-card>
            <el-card class="box-card !border-none" shadow="never">
                <h3 class="panel-title !text-sm">聚推客配置<a href="https://www.jutuike.com" target="_blank">  点我注册</a></h3>
				<el-form-item label="pub_id" prop="jutuike_pub_id">
				    <el-input v-model="formData.jutuike_pub_id" placeholder="请输入pub_id" class="input-width" clearable   />
				</el-form-item> <el-form-item label="apikey" prop="jutuike_apikey">
                  <el-input v-model="formData.jutuike_apikey" placeholder="请输入apikey" class="input-width" clearable  />
              </el-form-item>
			  
            </el-card>
			 
        </el-form>

        <div class="fixed-footer-wrap">
            <div class="fixed-footer">
                <el-button type="primary" :loading="loading" @click="save(formRef)">{{ t('save') }}</el-button>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref } from 'vue'
import { t } from '@/lang'
import { setConfig, getConfig } from '@/addon/cps/api/cps'
import { FormInstance, FormRules } from 'element-plus'
import storage from '@/utils/storage'
import { getAppType } from '@/utils/common'
import { useRoute } from 'vue-router'

const route = useRoute()
const pageName = route.meta.title
const loading = ref(true)
const app_type = ref()
const formData = reactive<Record<string, string>>({ 
    my_uid: '',
    my_apikey: '',
    my_secret: '',
    jutuike_pub_id: '',
    jutuike_apikey: ''
})

const setFormData = async (id: number = 0) => {
    const data = await (await getConfig()).data
    Object.keys(formData).forEach((key: string) => {
        if (data[key] != undefined) formData[key] = data[key]
    })
	
 	app_type.value = getAppType();
    loading.value = false
}
setFormData()

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = reactive<FormRules>({
    my_uid: [
        { required: true, message:'蚂蚁星球会员id不能空', trigger: 'blur' }
    ],
    my_apikey: [
        { required: true, message:'蚂蚁星球apikey不能空', trigger: 'blur' }
    ],
    my_secret: [
        { required: true, message:'蚂蚁星球secret不能空', trigger: 'blur' }
    ],
    jutuike_pub_id: [
        { required: true, message:'聚推客pub_id不能空', trigger: 'blur' }
    ],
    jutuike_apikey: [
        { required: true, message:'聚推客apikey不能空', trigger: 'blur' }
    ]
})

/**
 * 保存
 */
const save = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return

    await formEl.validate(async (valid) => {
        if (valid) {
            loading.value = true

            setConfig(formData).then(() => {
                loading.value = false
                setStore()
            }).catch(() => {
                loading.value = false
            })
        }
    })
}

const setStore = async () => {
    const data = await (await getConfig()).data
    storage.set({ key: 'siteInfo', data })
}

</script>

<style lang="scss" scoped></style>
