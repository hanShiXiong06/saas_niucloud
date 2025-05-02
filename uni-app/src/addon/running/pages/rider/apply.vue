<template>
	<view class="rider-apply-page bg-gray-50 min-h-screen">
		<!-- <u-navbar title="申请成为骑手" :border="false" :autoBack="true"></u-navbar> -->

		<!-- 加载中状态 -->
		<view v-if="loading" class="flex items-center justify-center p-10">
			<u-loading-icon size="36" mode="circle"></u-loading-icon>
		</view>

		<!-- 已申请，待审核状态 -->
		<view v-else-if="riderInfo && riderInfo.status === 0" class="p-4">
			<view class="bg-white rounded-lg shadow-sm p-5 mb-4">
				<view class="py-10 flex flex-col items-center">
					<u-icon name="hourglass" color="#3B82F6" size="60"></u-icon>
					<view class="text-lg font-bold mt-4 text-blue-600">申请审核中</view>
					<view class="text-sm text-gray-500 mt-2 text-center">您的骑手申请正在审核中，请耐心等待</view>
					<view class="text-sm text-gray-500 mt-1 text-center">审核结果将通过短信通知您</view>
					<button class="mt-8 px-6 py-2 bg-gray-200 text-gray-600 rounded-full" @click="goBack">返回</button>
				</view>
			</view>
		</view>

		<!-- 申请被驳回，需要重新提交 -->
		<view v-else-if="riderInfo && riderInfo.status === 2" class="p-4">
			<view class="bg-white rounded-lg shadow-sm p-5 mb-4">
				<view class="py-10 flex flex-col items-center">
					<u-icon name="close-circle" color="#EF4444" size="60"></u-icon>
					<view class="text-lg font-bold mt-4 text-red-500">申请未通过</view>
					<view class="text-sm text-gray-500 mt-2 text-center">很抱歉，您的申请未通过审核</view>
					<view class="text-sm text-gray-500 mt-1 text-center px-4">{{ riderInfo.reason ||
						'请检查您提交的资料是否有误，并重新提交申请' }}</view>
					<button class="mt-8 px-6 py-2 bg-blue-500 text-white rounded-full"
						@click="showApplyForm">重新提交</button>
				</view>
			</view>
		</view>

		<!-- 申请表单 -->
		<view v-else-if="showForm" class="p-4">
			<!-- 申请表单 -->
			<view class="bg-white rounded-lg shadow-sm p-5 mb-4">
				<view class="text-lg font-bold text-center mb-6 text-blue-600">骑手申请</view>

				<u-form :model="formData" ref="formRef" :rules="rules" :errorType="['message']">
					<u-form-item labelWidth='120px' label="学校" prop="school_id" required borderBottom>
						<picker :value="schoolIndex" :range="schoolList" range-key="name" @change="onSchoolChange"
							class="flex-1">
							<view class="flex items-center justify-between text-right">
								<text class="text-blue-600 font-medium ">{{ currentSchool.name || '请选择学校' }}</text>
								<text
									class="iconfont icon-right text-gray-400 text-lg transform transition-transform group-hover:translate-x-1"></text>
							</view>
						</picker>
					</u-form-item>
					<u-form-item labelWidth='120px' label="姓名" prop="real_name" required borderBottom>
						<u-input v-model="formData.real_name" placeholder="请输入您的真实姓名" border="none"
							inputAlign="right" />
					</u-form-item>

					<u-form-item labelWidth='120px' label="手机号" prop="mobile" required borderBottom>
						<u-input v-model="formData.mobile" placeholder="请输入您的手机号码" border="none" inputAlign="right" />
					</u-form-item>

					<u-form-item labelWidth='120px' label="身份证号" prop="id_card" required borderBottom>
						<u-input v-model="formData.id_card" placeholder="请输入您的身份证号码" border="none" inputAlign="right" />
					</u-form-item>

					<!-- 照片上传区域 -->
					<view class="mt-6">
						<view class="text-base mb-3 font-medium">身份证照片 <text class="text-red-500 text-sm">*</text>
						</view>

						<!-- 身份证正面 -->
						<view class="mb-4">
							<view class="text-sm text-gray-600 mb-2">身份证正面</view>
							<view class="upload-container" @click="chooseImage('avatar')">
								<image v-if="formData.avatar" :src="img(formData.avatar)" mode="aspectFit"
									class="upload-preview"></image>
								<view v-else class="upload-placeholder">
									<view class="upload-icon">
										<u-icon name="camera-fill" size="30" color="#94a3b8"></u-icon>
									</view>
									<text class="upload-text">点击上传</text>
								</view>
								<view class="loading-overlay" v-if="uploadingType === 'avatar'">
									<u-loading-icon mode="circle" size="32" color="#ffffff"></u-loading-icon>
								</view>
							</view>
						</view>

						<!-- 身份证反面 -->
						<!-- <view class="mb-4">
							<view class="text-sm text-gray-600 mb-2">身份证反面</view>
							<view class="upload-container" @click="chooseImage('id_card_back')">
								<image v-if="formData.id_card_back" :src="img(formData.id_card_back)" mode="aspectFit" class="upload-preview"></image>
								<view v-else class="upload-placeholder">
									<view class="upload-icon">
										<u-icon name="camera-fill" size="30" color="#94a3b8"></u-icon>
									</view>
									<text class="upload-text">点击上传</text>
								</view>
								<view class="loading-overlay" v-if="uploadingType === 'id_card_back'">
									<u-loading-icon mode="circle" size="32" color="#ffffff"></u-loading-icon>
								</view>
							</view>
						</view> -->

						<!-- 手持身份证 -->
						<!-- <view>
							<view class="text-sm text-gray-600 mb-2">手持身份证照片</view>
							<view class="upload-container" @click="chooseImage('id_card_holding')">
								<image v-if="formData.id_card_holding" :src="img(formData.id_card_holding)" mode="aspectFit" class="upload-preview"></image>
								<view v-else class="upload-placeholder">
									<view class="upload-icon">
										<u-icon name="camera-fill" size="30" color="#94a3b8"></u-icon>
									</view>
									<text class="upload-text">点击上传</text>
								</view>
								<view class="loading-overlay" v-if="uploadingType === 'id_card_holding'">
									<u-loading-icon mode="circle" size="32" color="#ffffff"></u-loading-icon>
								</view>
							</view>
						</view> -->
					</view>
				</u-form>

				<!-- 提交按钮 -->
				<view class="mt-8">
					<button class="submit-btn" @click="submitForm" :disabled="submitting">
						<text v-if="!submitting">提交申请</text>
						<u-loading-icon v-else mode="circle" size="20" color="#ffffff"></u-loading-icon>
					</button>
				</view>
			</view>

			<!-- 骑手须知 -->
			<view class="bg-white rounded-lg shadow-sm p-5">
				<view class="text-base font-medium mb-3 text-blue-600">骑手须知</view>
				<view class="text-sm text-gray-600 leading-6">
					<view class="mb-2 flex">
						<text class="mr-2 text-blue-500">1.</text>
						<text>骑手需年满18周岁，身体健康，无犯罪记录。</text>
					</view>
					<view class="mb-2 flex">
						<text class="mr-2 text-blue-500">2.</text>
						<text>需持有有效的身份证件和学生证。</text>
					</view>
					<view class="mb-2 flex">
						<text class="mr-2 text-blue-500">3.</text>
						<text>熟悉服务区域，具备良好的沟通能力和服务意识。</text>
					</view>
					<view class="mb-2 flex">
						<text class="mr-2 text-blue-500">4.</text>
						<text>一个账号只能入驻到一所学校,暂不支持多学校入驻。</text>
					</view>
					<view class="flex">
						<text class="mr-2 text-blue-500">5.</text>
						<text>平台将在3个工作日内审核您的申请，请保持电话畅通。</text>
					</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { uploadImage } from '@/app/api/system';
import { submitRiderApply, getRiderInfo } from '@/addon/running/api/rider';
import { img } from '@/utils/common';
import { getSchoolList } from '@/addon/running/api/index';

const formRef = ref<any>(null);
const submitting = ref(false);
const uploadingType = ref('');
const schoolIndex = ref(0);
const currentSchool = ref<any>({});
const loading = ref(true);
const showForm = ref(false);
const riderInfo = ref<any>(null);

// 表单数据
const formData = reactive({
	real_name: '',
	mobile: '',
	id_card: '',
	school_id: '',
	avatar: '',
	id_card_back: '',
	id_card_holding: ''
});

// 获取骑手信息
const checkRiderStatus = async () => {
	loading.value = true;
	try {
		const res: any = await getRiderInfo();
		console.log('骑手信息:', res);

		if (res.code === 1) {
			if (res.data.info) {
				// 已有申请记录
				riderInfo.value = res.data.info;
				// 如果状态是2(驳回)，预填充表单数据
				if (res.data.info.status === 2) {
					// 可以预填充之前的数据，方便用户修改
					if (res.data.info.real_name) formData.real_name = res.data.info.real_name;
					if (res.data.info.mobile) formData.mobile = res.data.info.mobile;
					if (res.data.info.id_card) formData.id_card = res.data.info.id_card;
					if (res.data.info.school_id) formData.school_id = res.data.info.school_id;
					// 如果有照片信息，也可以预填充
					if (res.data.info.photo && res.data.info.photo.length > 0) {
						formData.avatar = res.data.info.photo[0];
					}
				}
			} else {
				// 没有申请记录，显示申请表单
				showForm.value = true;
			}
		} else {
			uni.showToast({
				title: res.msg || '获取信息失败',
				icon: 'none'
			});
			showForm.value = true;
		}
	} catch (error) {
		console.error('获取骑手信息失败:', error);
		uni.showToast({
			title: '获取信息失败',
			icon: 'none'
		});
		showForm.value = true;
	} finally {
		loading.value = false;
	}
};

// 显示申请表单
const showApplyForm = () => {
	// 将 status 设置为 0
	riderInfo.value.status = null;

	showForm.value = true;
};

// 返回上一页
const goBack = () => {
	uni.navigateBack();
};

// 组件加载时检查骑手状态
onMounted(() => {
	checkRiderStatus();
	getSchoolListFn();
});

const schoolShow = ref(false);
// 学校选择改变
const onSchoolChange = (e: any) => {
	schoolIndex.value = e.detail.value;
	currentSchool.value = schoolList.value[schoolIndex.value] || {};

	// 明确设置school_id为字符串类型的ID
	if (currentSchool.value && currentSchool.value.id) {
		formData.school_id = String(currentSchool.value.id);
	} else {
		formData.school_id = '';
	}

	console.log('选择学校后的formData:', formData);
}

// 学校列表
const schoolList = ref<any[]>([]);

const getSchoolListFn = async () => {
	try {
		const res: any = await getSchoolList();
		if (res.code === 1) {
			schoolList.value = res.data;

			// 如果有school_id，尝试找到对应的学校并设置索引
			if (formData.school_id && schoolList.value.length > 0) {
				const index = schoolList.value.findIndex(school => String(school.id) === String(formData.school_id));
				if (index !== -1) {
					schoolIndex.value = index;
					currentSchool.value = schoolList.value[index];
				}
			}
		}
	} catch (error) {
		console.error('获取学校列表失败:', error);
	}
};

// 表单验证规则
const rules = {
	school_id: [
		{ required: true, message: '请选择学校', trigger: 'change' }
	],
	real_name: [
		{ required: true, message: '请输入姓名', trigger: 'blur' }
	],
	mobile: [
		{ required: true, message: '请输入手机号', trigger: 'blur' },
		{ pattern: /^1[3-9]\d{9}$/, message: '手机号格式不正确', trigger: 'blur' }
	],
	id_card: [
		{ required: true, message: '请输入身份证号', trigger: 'blur' },
		{ pattern: /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/, message: '身份证号格式不正确', trigger: 'blur' }
	]
};

// 选择图片
const chooseImage = (type: 'avatar') => {
	// 正在上传中的逻辑，防止重复点击
	if (uploadingType.value) return;

	uni.chooseImage({
		count: 1,
		sizeType: ['compressed'],
		sourceType: ['album', 'camera'],
		success: (res) => {
			uploadRiderImage(res.tempFilePaths[0], type);
		},
		fail: () => {
			uni.showToast({
				title: '选择图片失败',
				icon: 'none'
			});
		}
	});
};

// 上传图片
const uploadRiderImage = async (filePath: string, type: 'avatar') => {
	uploadingType.value = type;

	try {
		const res: any = await uploadImage({
			filePath: filePath,
			name: 'file'
		});

		if (res.code === 1 && res.data && res.data.url) {
			formData[type] = res.data.url;
		} else {
			uni.showToast({
				title: res.msg || '上传失败',
				icon: 'none'
			});
		}
	} catch (error) {
		uni.showToast({
			title: '上传失败',
			icon: 'none'
		});
	} finally {
		uploadingType.value = '';
	}
};

// 提交表单
const submitForm = async () => {
	console.log('点击提交按钮');
	console.log('当前表单数据:', formData);

	if (!formRef.value) {
		uni.showToast({
			title: '表单组件未初始化',
			icon: 'none'
		});
		return;
	}

	// 手动检查各项
	if (!formData.school_id) {
		uni.showToast({
			title: '请选择学校',
			icon: 'none'
		});
		return;
	}

	if (!formData.real_name) {
		uni.showToast({
			title: '请输入姓名',
			icon: 'none'
		});
		return;
	}

	if (!formData.mobile) {
		uni.showToast({
			title: '请输入手机号',
			icon: 'none'
		});
		return;
	}

	if (!formData.id_card) {
		uni.showToast({
			title: '请输入身份证号',
			icon: 'none'
		});
		return;
	}

	if (!formData.avatar) {
		uni.showToast({
			title: '请上传身份证照片',
			icon: 'none'
		});
		return;
	}

	// 所有检查通过，直接提交
	submitting.value = true;

	try {
		const submitData = {
			real_name: formData.real_name,
			mobile: formData.mobile,
			id_card: formData.id_card,
			school_id: formData.school_id,
			photo: [formData.avatar]
		};

		console.log('提交数据:', submitData);

		const res: any = await submitRiderApply(submitData);
		console.log('提交响应:', res);

		if (res.code === 1) {
			uni.showModal({
				title: '申请已提交',
				content: '我们将在3个工作日内审核您的申请，请保持电话畅通',
				showCancel: false,
				success: () => {
					// 重新检查状态
					checkRiderStatus();
				}
			});
		} else {
			uni.showToast({
				title: res.msg || '提交失败',
				icon: 'none'
			});
		}
	} catch (error) {
		console.error('提交异常:', error);
		uni.showToast({
			title: '提交失败，请重试',
			icon: 'none'
		});
	} finally {
		submitting.value = false;
	}
}
</script>

<style lang="scss" scoped>
.upload-container {
	position: relative;
	width: 100%;
	height: 160rpx;
	border: 1px dashed #e2e8f0;
	border-radius: 8rpx;
	overflow: hidden;

	.upload-preview {
		width: 100%;
		height: 100%;
	}

	.upload-placeholder {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		width: 100%;
		height: 100%;
		background-color: #f8fafc;

		.upload-icon {
			margin-bottom: 10rpx;
		}

		.upload-text {
			font-size: 24rpx;
			color: #94a3b8;
		}
	}

	.loading-overlay {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background-color: rgba(0, 0, 0, 0.5);
		display: flex;
		align-items: center;
		justify-content: center;
	}
}

.submit-btn {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100%;
	height: 88rpx;
	background-color: #3b82f6;
	color: #ffffff;
	font-size: 30rpx;
	font-weight: 500;
	border-radius: 44rpx;

	&:active {
		background-color: #2563eb;
	}

	&[disabled] {
		background-color: #93c5fd;
	}
}
</style>