<template>
	<el-dialog v-model="showDialog" :title="formData.id ? t('updateTie') : t('addTie')" width="50%"
		class="diy-dialog-wrap" :destroy-on-close="true">
		<el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form"
			v-loading="loading">
			<el-form-item :label="t('cateId')" prop="cate_id">
				<el-select class="input-width" v-model="formData.cate_id" clearable @change="changecate"
					:placeholder="t('cateIdPlaceholder')">
					<el-option label="请选择" value=""></el-option>
					<el-option v-for="(item, index) in cateIdList" :key="index" :label="item['name']"
						:value="item['id']" />
				</el-select>
			</el-form-item>
			
			<el-form-item :label="t('子类目')">
				<el-select class="input-width" v-model="formData.cate_id2" clearable
					:placeholder="t('子类目')">
					<el-option label="请选择" value=""></el-option>
					<el-option v-for="(item, index) in cateIdList2" :key="index" :label="item['name']"
						:value="item['id']" />
				</el-select>
			</el-form-item>

			<el-form-item :label="t('details')" prop="details">
				<el-input v-model="formData.details" type="textarea" rows="4" clearable
					:placeholder="t('detailsPlaceholder')" class="input-width" />
			</el-form-item>
			<el-form-item :label="t('imgs')">
				<upload-image v-model="formData.imgs"  limit="9"/>
			</el-form-item>

			<el-form-item :label="t('发帖人(可选)')">
				<el-select class="input-width" v-model="formData.member_id" clearable
					:placeholder="t('memberIdPlaceholder')">
					<el-option label="请选择" value=""></el-option>
					<el-option v-for="(item, index) in memberIdList" :key="index" :label="item['nickname']"
						:value="item['member_id']" />
				</el-select>
				  (后台发布帖子信息, 可以不选择)
			</el-form-item>
			<el-form-item :label="t('用户昵称')" prop="nickname">
				<el-input v-model="formData.nickname" type="text" rows="4" clearable :placeholder="t('请填写用户名称')" class="input-width" />
				
			</el-form-item>
			<el-form-item :label="t('用户头像')" prop="headimg">
				<upload-image v-model="formData.headimg"  limit="1"/>
			</el-form-item>

			<el-form-item :label="t('likenum')">
				<el-input-number v-model="formData.likenum" clearable :placeholder="t('likenumPlaceholder')"
					class="input-width" :min="0" max="100000" />
			</el-form-item>

			<el-form-item :label="t('views')">
				<el-input-number v-model="formData.views" clearable :placeholder="t('viewsPlaceholder')"
					class="input-width" :min="0" max="100000" />
			</el-form-item>
			
			<el-form-item :label="t('所在地址')">
				<el-input v-model="formData.address" type="text" clearable  class="input-width" />
			</el-form-item>
			<el-form-item :label="t('所在地址')">
				<div style="display: flex;">
					<el-input v-model="formData.lng" type="text" clearable style="width:200px"  placeholder="格式116.xxxx" />
					<el-input v-model="formData.lat" type="text" clearable style="width:200px" placeholder="格式39.xxxx" />
					<a href="https://api.map.baidu.com/lbsapi/getpoint/index.html" style="color: #1677ff;" target="_blank">获取坐标</a>
				</div>
			</el-form-item>
			<el-form-item :label="t('联系电话')">
				<el-input v-model="formData.mobile" type="text" clearable class="input-width" />
			</el-form-item>
			<el-form-item :label="t('置顶到期时间')">
				<el-date-picker v-model="formData.top_enddate" type="datetime" clearable  class="input-width" placeholder="选择日期时间"></el-date-picker>
			</el-form-item>
			
			
			<el-form-item :label="t('status')" >
			    <el-select class="input-width"  v-model="formData.status" clearable :placeholder="t('statusPlaceholder')">
			      <el-option :label=" t('审核通过') "  value="2"/>
			      <el-option :label=" t('待审核') "  value="1"/>
			      <el-option :label=" t('隐藏') "  value="0"/>
			    </el-select>
			</el-form-item>

			<el-form-item :label="t('label')">
				<el-select class="input-width" multiple v-model="formData.label_ids" clearable :placeholder="t('labelPlaceholder')">
					<el-option label="请选择" value=""></el-option>
					<el-option v-for="(item, index) in labelList" :key="index" :label="item['name']"
						:value="item['id']" />
				</el-select>
			</el-form-item>

		<!-- 	<el-form-item :label="t('label')">
				<el-input v-model="formData.labelname" clearable :placeholder="t('labelnamePlaceholder')"
					class="input-width" />
			</el-form-item> -->

		</el-form>

		<template #footer>
			<span class="dialog-footer">
				<el-button @click="showDialog = false">{{ t('cancel') }}</el-button>
				<el-button type="primary" :loading="loading" @click="confirm(formRef)">{{
                    t('confirm')
                }}</el-button>
			</span>
		</template>
	</el-dialog>
</template>

<script lang="ts" setup>
	import { ref, reactive, computed, watch } from 'vue'
	import { useDictionary } from '@/app/api/dict'
	import { t } from '@/lang'
	import type { FormInstance } from 'element-plus'
	import { addTie, editTie, getTieInfo, getWithCateList, getWithMemberList, getWithLabelList } from '@/addon/blog/api/tie'

	let showDialog = ref(false)
	const loading = ref(false)

	/**
	 * 表单数据
	 */
	const initialFormData = {
		id: '',
		cate_id: '',
		cate_id2: '',
		details: '',
		imgs: '',
		member_id: '',
		likenum: '',
		views: '',
		status: '',
		label_ids: [],
		labelname: '',
		address: '',
		lng: '',
		lat: '',
		mobile: '',
		top_enddate: '',
		headimg: '',
		nickname: '',
	}
	const formData : Record<string, any> = reactive({ ...initialFormData })

	const formRef = ref<FormInstance>()

	// 表单验证规则
	const formRules = computed(() => {
		return {
			cate_id: [
				{ required: true, message: t('cateIdPlaceholder'), trigger: 'blur' }, 
			]
			,
			details: [
				{ required: true, message: t('detailsPlaceholder'), trigger: 'blur' },

			]
			,
			// imgs: [
			// 	{ required: true, message: t('imgsPlaceholder'), trigger: 'blur' },

			// ]
			// ,
			nickname: [
				{ required: true, message: t('请填写用户昵称'), trigger: 'blur' },
			
			]
			,
			headimg: [
				{ required: true, message: t('请上传用户头像'), trigger: 'blur' },
			
			]
			,
			// member_id: [
			// 	{ required: true, message: t('memberIdPlaceholder'), trigger: 'blur' },

			// ]
			// ,
			likenum: [
				{ required: true, message: t('likenumPlaceholder'), trigger: 'blur' },
				{ validator: (rule : any, value : string, callback : any) => { if (value && !/^\d{0,100000}$/.test(value)) { callback(new Error(t('generateBetween'))) } else { callback() } } },
			]
			,
			views: [
				{ required: true, message: t('viewsPlaceholder'), trigger: 'blur' },
				{ validator: (rule : any, value : string, callback : any) => { if (value && !/^\d{0,100000}$/.test(value)) { callback(new Error(t('generateBetween'))) } else { callback() } } },
			]
			,
			status: [
				{ required: true, message: t('statusPlaceholder'), trigger: 'blur' },

			]
			,
			label: [
				{ required: true, message: t('labelPlaceholder'), trigger: 'blur' },
			]
			,
			labelname: [
				{ required: true, message: t('labelnamePlaceholder'), trigger: 'blur' },

			]
			,
		}
	})

	const emit = defineEmits(['complete'])

	/**
	 * 确认
	 * @param formEl
	 */
	const confirm = async (formEl : FormInstance | undefined) => {
		if (loading.value || !formEl) return
		let save = formData.id ? editTie : addTie

		await formEl.validate(async (valid) => {
			if (valid) {
				loading.value = true

				let data = formData

				save(data).then(res => {
					loading.value = false
					showDialog.value = false
					emit('complete')
				}).catch(err => {
					loading.value = false
				})
			}
		})
	}

	// 获取字典数据



	const cateIdList = ref([] as any[])
	const cateIdList2 = ref([] as any[])
	const setCateIdList = async () => {
		cateIdList.value = await (await getWithCateList({})).data
		cateIdList2.value = cateIdList.value.child
	}
	setCateIdList()
	
	
	const changecate = async (e) => {
		cateIdList2.value = await (await getWithCateList({pid:e})).data
	}
	
	
	
	
	const memberIdList = ref([] as any[])
	const setMemberIdList = async () => {
		memberIdList.value = await (await getWithMemberList({})).data
	}
	setMemberIdList()
	const labelList = ref([] as any[])
	const setLabelList = async () => {
		labelList.value = await (await getWithLabelList({})).data
	}
	 setLabelList()
	// const labelnameList = ref([] as any[])
	// const setLabelnameList = async () => {
	// labelnameList.value = await (await getWithLabelList({})).data
	// }
	// setLabelnameList()
	const setFormData = async (row : any = null) => {
		Object.assign(formData, initialFormData)
		loading.value = true
		if (row) {
			const data = await (await getTieInfo(row.id)).data
			if (data) Object.keys(formData).forEach((key : string) => {
				if (data[key] != undefined) formData[key] = data[key]
			})
		}
		loading.value = false
		changecate(formData.cate_id)
	}

	// 验证手机号格式
	const mobileVerify = (rule : any, value : any, callback : any) => {
		if (value && !/^1[3-9]\d{9}$/.test(value)) {
			callback(new Error(t('generateMobile')))
		} else {
			callback()
		}
	}

	// 验证身份证号
	const idCardVerify = (rule : any, value : any, callback : any) => {
		if (value && !/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/.test(value)) {
			callback(new Error(t('generateIdCard')))
		} else {
			callback()
		}
	}

	// 验证邮箱号
	const emailVerify = (rule : any, value : any, callback : any) => {
		if (value && !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test(value)) {
			callback(new Error(t('generateEmail')))
		} else {
			callback()
		}
	}

	// 验证请输入整数
	const numberVerify = (rule : any, value : any, callback : any) => {
		if (!Number.isInteger(value)) {
			callback(new Error(t('generateNumber')))
		} else {
			callback()
		}
	}

	defineExpose({
		showDialog,
		setFormData
	})
</script>

<style lang="scss" scoped></style>
<style lang="scss">
	.diy-dialog-wrap .el-form-item__label {
		height: auto !important;
	}
</style>