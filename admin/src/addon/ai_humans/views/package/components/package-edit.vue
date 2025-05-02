<template>
    <el-dialog v-model="showDialog" :title="formData.id ? t('updatePackage') : t('addPackage')" width="50%"
        custom-class="package-dialog" :destroy-on-close="true">
        <el-form :model="formData" label-width="120px" ref="formRef" :rules="formRules" class="page-form"
            v-loading="loading">
            <el-form-item label="基础信息" class="benefit-section">
                <el-card shadow="hover" class="card-with-hover border-0 benefit-card">
                    <template #header>
                        <div class="card-header flex items-center">
                            <el-icon class="mr-2">
                                <Microphone />
                            </el-icon>
                            <span class="font-medium text-gray-800 text-lg">基础信息配置</span>
                            <span class="ml-2 text-gray-400">点数永久有效，天数0表示不限制到期时间,注意针对套餐权益里面的数量有效</span>
                        </div>
                    </template>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 px-4 py-2">
                        <div class="flex items-center benefit-item">
                            <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                <el-icon class="mr-1 text-blue-600">
                                    <Connection />
                                </el-icon>
                                套餐名称
                            </div>
                            <el-input v-model="formData.name" clearable :placeholder="t('namePlaceholder')"
                                class="flex-1 input-with-hover" />
                        </div>

                        <div class="flex items-center benefit-item">
                            <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                <el-icon class="mr-1 text-purple-600">
                                    <Document />
                                </el-icon>
                                套餐描述
                            </div>
                            <el-input v-model="formData.desc" clearable placeholder="请输入描述" maxlength="40"
                                class="flex-1 input-with-hover" />
                        </div>

                        <div class="flex items-center benefit-item">
                            <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                <el-icon class="mr-1 text-green-600">
                                    <Connection />
                                </el-icon>
                                价格
                            </div>
                            <el-input-number v-model="formData.price" controls-position="right"
                                :placeholder="t('pricePlaceholder')" :min="0" class="flex-1 input-number-custom" />
                        </div>

                        <div class="flex items-center benefit-item">
                            <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                <el-icon class="mr-1 text-orange-600">
                                    <Connection />
                                </el-icon>
                                天数
                            </div>
                            <el-input-number v-model="formData.day" controls-position="right" placeholder="请输入有效天数"
                                :min="0" max="100" class="flex-1 input-number-custom" />
                        </div>

                        <div class="flex items-center benefit-item">
                            <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                <el-icon class="mr-1 text-rose-600">
                                    <Connection />
                                </el-icon>
                                点数
                            </div>
                            <el-input-number :min="0" v-model="formData.point" controls-position="right"
                                :placeholder="t('pointPlaceholder')" class="flex-1 input-number-custom" />
                        </div>

                        <div class="flex items-center benefit-item">
                            <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                <el-icon class="mr-1 text-teal-600">
                                    <Connection />
                                </el-icon>
                                标签
                            </div>
                            <el-input v-model="formData.tab" clearable placeholder="请输入标签"
                                class="flex-1 input-with-hover" />
                        </div>

                        <div class="flex items-center benefit-item">
                            <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                <el-icon class="mr-1 text-indigo-600">
                                    <Connection />
                                </el-icon>
                                排序
                            </div>
                            <el-input v-model="formData.sort" clearable :placeholder="t('sortPlaceholder')"
                                class="flex-1 input-with-hover" />
                        </div>
                    </div>
                </el-card>
            </el-form-item>
            <el-form-item label="套餐权益" class="benefit-section">
                <div class="space-y-4">
                    <el-card shadow="hover" class="card-with-hover border-0 benefit-card">
                        <template #header>
                            <div class="card-header flex items-center">
                                <el-icon class="mr-2">
                                    <Microphone />
                                </el-icon>
                                <span class="font-medium text-gray-800 text-lg">声音相关权益</span>
                            </div>
                        </template>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 px-4 py-2">
                            <div class="flex items-center benefit-item">
                                <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                    <el-icon class="mr-1 text-blue-600">
                                        <Connection />
                                    </el-icon>
                                    普通声音克隆
                                </div>
                                <el-input-number v-model="formData.benefits.clone_voice_num" controls-position="right"
                                    :placeholder="t('cloneVoiceNumPlaceholder')" :min="0"
                                    class="flex-1 input-number-custom" />
                            </div>
                            <!-- <div class="flex items-center benefit-item">
                                <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                    <el-icon class="mr-1 text-purple-600">
                                        <Star />
                                    </el-icon>
                                    PRO声音克隆
                                </div>
                                <el-input-number v-model="formData.benefits.clone_voice_pro_num"
                                    controls-position="right" :placeholder="t('cloneVoiceNumPlaceholder')" :min="0"
                                    class="flex-1 input-number-custom" />
                            </div> -->
                            <div class="flex items-center benefit-item">
                                <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                    <el-icon class="mr-1 text-green-600">
                                        <Connection />
                                    </el-icon>
                                    普通声音生成
                                </div>
                                <el-input-number v-model="formData.benefits.create_voice_num" controls-position="right"
                                    :placeholder="t('createVoiceNumPlaceholder')" :min="0"
                                    class="flex-1 input-number-custom" />
                            </div>
                            <!-- <div class="flex items-center benefit-item">
                                <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                    <el-icon class="mr-1 text-rose-600">
                                        <Star />
                                    </el-icon>
                                    PRO声音生成
                                </div>
                                <el-input-number v-model="formData.benefits.create_voice_pro_num"
                                    controls-position="right" :placeholder="t('createVoiceNumPlaceholder')" :min="0"
                                    class="flex-1 input-number-custom" />
                            </div> -->
                        </div>
                    </el-card>

                    <el-card shadow="hover" class="card-with-hover border-0 benefit-card">
                        <template #header>
                            <div class="card-header flex items-center">
                                <el-icon class="mr-2">
                                    <VideoCamera />
                                </el-icon>
                                <span class="font-medium text-gray-800 text-lg">视频相关权益</span>
                            </div>
                        </template>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 px-4 py-2">
                            <div class="flex items-center benefit-item">
                                <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                    <el-icon class="mr-1 text-blue-600">
                                        <Connection />
                                    </el-icon>
                                    普通视频克隆
                                </div>
                                <el-input-number v-model="formData.benefits.clone_video_num" controls-position="right"
                                    :placeholder="t('cloneVideoNumPlaceholder')" :min="0"
                                    class="flex-1 input-number-custom" />
                            </div>
                            <div class="flex items-center benefit-item">
                                <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                    <el-icon class="mr-1 text-purple-600">
                                        <Star />
                                    </el-icon>
                                    PRO视频克隆
                                </div>
                                <el-input-number v-model="formData.benefits.clone_video_pro_num"
                                    controls-position="right" :placeholder="t('cloneVideoNumPlaceholder')" :min="0"
                                    class="flex-1 input-number-custom" />
                            </div>
                            <div class="flex items-center benefit-item">
                                <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                    <el-icon class="mr-1 text-green-600">
                                        <Connection />
                                    </el-icon>
                                    普通视频生成
                                </div>
                                <el-input-number v-model="formData.benefits.create_video_num" controls-position="right"
                                    :placeholder="t('createVideoNumPlaceholder')" :min="0"
                                    class="flex-1 input-number-custom" />
                            </div>
                            <div class="flex items-center benefit-item">
                                <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                    <el-icon class="mr-1 text-rose-600">
                                        <Star />
                                    </el-icon>
                                    PRO视频生成
                                </div>
                                <el-input-number v-model="formData.benefits.create_video_pro_num"
                                    controls-position="right" :placeholder="t('createVideoNumPlaceholder')" :min="0"
                                    class="flex-1 input-number-custom" />
                            </div>
                        </div>
                    </el-card>

                    <el-card shadow="hover" class="card-with-hover border-0 benefit-card">
                        <template #header>
                            <div class="card-header flex items-center">
                                <el-icon class="mr-2">
                                    <ChatDotRound />
                                </el-icon>
                                <span class="font-medium text-gray-800 text-lg">其他权益</span>
                            </div>
                        </template>
                        <div class="grid grid-cols-1 gap-6 px-4 py-2">
                            <div class="flex items-center benefit-item">
                                <div class="mr-3 text-gray-600 w-32 shrink-0 font-medium flex items-center">
                                    <el-icon class="mr-1 text-cyan-600">
                                        <ChatLineRound />
                                    </el-icon>
                                    对话数量
                                </div>
                                <el-input-number v-model="formData.benefits.chat_num" controls-position="right"
                                    :placeholder="t('cloneVideoNumPlaceholder')" :min="0"
                                    class="flex-1 input-number-custom" />
                            </div>
                        </div>
                    </el-card>
                </div>
            </el-form-item>

            <el-form-item label="自定义权益" class="custom-benefits benefit-section">
                <div>
                    <div class="flex justify-between mb-4 items-center">
                        <span class="text-gray-800 font-medium text-lg flex items-center">
                            <el-icon
                                class="mr-2 bg-gradient-to-r from-indigo-500 to-purple-500 text-white p-1.5 rounded-md">
                                <Medal />
                            </el-icon>
                            已添加权益项
                        </span>
                        <el-button type="primary" size="default" @click="addAward()" class="btn-add-benefit ml-2">
                            <el-icon class="mr-1">
                                <Plus />
                            </el-icon>添加权益
                        </el-button>
                    </div>

                    <!-- 使用栅格布局 -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <el-card v-for="(item, index) in formData.award" :key="index" shadow="hover"
                            class="border-0 card-with-hover benefit-item-card benefit-card">
                            <template #header>
                                <div class="flex justify-between items-center">
                                    <span class="text-gray-700 font-medium flex items-center">
                                        <el-icon class="mr-1 text-amber-500">
                                            <Star />
                                        </el-icon>
                                        权益项 #{{ index + 1 }}
                                    </span>
                                    <el-button type="danger" size="small" @click="removeAward(index)"
                                        class="btn-delete">
                                        <el-icon>
                                            <Delete />
                                        </el-icon>
                                    </el-button>
                                </div>
                            </template>
                            <div class="space-y-4 p-2">
                                <div class="flex items-center">
                                    <span class="w-20 shrink-0 text-gray-600 font-medium">名称</span>
                                    <el-input v-model="item.name" clearable placeholder="请输入权益名称" maxlength="12"
                                        class="flex-1 input-with-hover" />
                                </div>

                                <div class="flex items-center">
                                    <span class="w-20 shrink-0 text-gray-600 font-medium">描述</span>
                                    <el-input v-model="item.desc" clearable placeholder="请输入权益描述" maxlength="12"
                                        class="flex-1 input-with-hover" />
                                </div>

                                <div class="flex items-center">
                                    <span class="w-20 shrink-0 text-gray-600 font-medium">图标</span>
                                    <upload-image v-model="item.icon" class="flex-1" />
                                </div>
                            </div>
                        </el-card>
                    </div>

                    <!-- 空状态提示 -->
                    <el-empty v-if="!formData.award.length" description="暂无自定义权益" class="mt-4 empty-state" />
                </div>
            </el-form-item>

        </el-form>

        <template #footer>
            <span class="dialog-footer flex justify-end space-x-3">
                <el-button @click="showDialog = false" class="btn-cancel">{{ t('cancel') }}</el-button>
                <el-button type="primary" :loading="loading" @click="confirm(formRef)" class="btn-confirm">
                    {{ t('confirm') }}
                </el-button>
            </span>
        </template>
    </el-dialog>
</template>

<script lang="ts" setup>
import { ref, reactive, computed, watch } from 'vue'
import { useDictionary } from '@/app/api/dict'
import { t } from '@/lang'
import type { FormInstance } from 'element-plus'
import { Plus, Delete, Document, Microphone, VideoCamera, ChatDotRound, Star, Connection, Medal, ChatLineRound } from '@element-plus/icons-vue'
import { addPackage, editPackage, getPackageInfo } from '@/addon/ai_humans/api/package'

let showDialog = ref(false)
const loading = ref(false)

/**
 * 表单数据
 */
const initialFormData = {
    id: '',
    name: '',
    desc: '',
    price: '',
    point: '',
    sort: '',
    tab: '',
    award: [],
    benefits: {
        'clone_voice_num': 0,
        'clone_voice_pro_num': 0,
        'create_voice_num': 0,
        'create_voice_pro_num': 0,
        'clone_video_num': 0,
        'clone_video_pro_num': 0,
        'create_video_num': 0,
        'create_video_pro_num': 0,
        'chat_num': 0,
    },
    day: 0,//有效天数
}
const addAward = () => {
    // 每次添加时创建一个新的对象
    const newAward = {
        name: '',
        desc: '',
        icon: ''
    };
    formData.award.push(newAward);
}
const removeAward = (index: number) => {
    formData.award.splice(index, 1)
}
const formData: Record<string, any> = reactive({ ...initialFormData })

const formRef = ref<FormInstance>()

// 表单验证规则
const formRules = computed(() => {
    return {
        name: [
            { required: true, message: t('namePlaceholder'), trigger: 'blur' },

        ]
        ,
        price: [
            { required: true, message: t('pricePlaceholder'), trigger: 'blur' },
            { validator: (rule: any, value: string, callback: any) => { if (value && !/^\d{0,100}$/.test(value)) { callback(new Error(t('generateBetween'))) } else { callback() } } },
        ]
        ,
        point: [
            { required: true, message: t('pointPlaceholder'), trigger: 'blur' },

        ]
        ,
        sort: [
            { required: true, message: t('sortPlaceholder'), trigger: 'blur' },

        ]

    }
})

const emit = defineEmits(['complete'])

/**
 * 确认
 * @param formEl
 */
const confirm = async (formEl: FormInstance | undefined) => {
    if (loading.value || !formEl) return
    let save = formData.id ? editPackage : addPackage

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



const setFormData = async (row: any = null) => {
    Object.assign(formData, initialFormData)
    loading.value = true
    if (row) {
        const data = await (await getPackageInfo(row.id)).data
        if (data) Object.keys(formData).forEach((key: string) => {
            if (data[key] != undefined) formData[key] = data[key]
        })
    }
    loading.value = false
}

// 验证手机号格式
const mobileVerify = (rule: any, value: any, callback: any) => {
    if (value && !/^1[3-9]\d{9}$/.test(value)) {
        callback(new Error(t('generateMobile')))
    } else {
        callback()
    }
}

// 验证身份证号
const idCardVerify = (rule: any, value: any, callback: any) => {
    if (value && !/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/.test(value)) {
        callback(new Error(t('generateIdCard')))
    } else {
        callback()
    }
}

// 验证邮箱号
const emailVerify = (rule: any, value: any, callback: any) => {
    if (value && !/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test(value)) {
        callback(new Error(t('generateEmail')))
    } else {
        callback()
    }
}

// 验证请输入整数
const numberVerify = (rule: any, value: any, callback: any) => {
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

<style lang="scss" scoped>
.package-dialog {
    :deep(.el-dialog__header) {
        background: linear-gradient(135deg, #4a6cf7 0%, #7e57c2 100%);
        color: white;
        padding: 16px 24px;
        border-radius: 12px 12px 0 0;
        margin-right: 0;
    }

    :deep(.el-dialog__title) {
        color: white;
        font-weight: 600;
        font-size: 1.2rem;
    }

    :deep(.el-dialog__body) {
        padding: 24px 28px;
    }

    :deep(.el-dialog__footer) {
        padding: 16px 28px;
        border-top: 1px solid #edf2f7;
    }

    .card-with-hover {
        transition: all 0.3s ease;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        border-radius: 12px;
        overflow: hidden;
        margin-bottom: 16px;

        &:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
        }

        :deep(.el-card__header) {
            padding: 16px 20px;
            background: linear-gradient(135deg, rgba(74, 108, 247, 0.08) 0%, rgba(126, 87, 194, 0.08) 100%);
            border-bottom: 1px solid #f0f0f0;
        }

        :deep(.el-card__body) {
            padding: 18px 10px;
        }
    }

    .benefit-item {
        padding: 10px;
        transition: all 0.3s ease;
        border-radius: 8px;
        margin-bottom: 4px;

        &:hover {
            background-color: #f9fafc;
            transform: translateX(2px);
        }
    }

    .benefit-item-card {
        overflow: hidden;
        transition: all 0.3s ease;
        margin-bottom: 0;

        &:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
        }
    }

    .input-with-hover {
        transition: all 0.3s;

        :deep(.el-input__wrapper) {
            box-shadow: 0 0 0 1px #dcdfe6 inset;
            border-radius: 8px;

            &:hover {
                box-shadow: 0 0 0 1px #a0a6b1 inset;
            }

            &:focus,
            &.is-focus {
                box-shadow: 0 0 0 2px rgba(74, 108, 247, 0.2);
            }
        }
    }

    .input-number-custom {
        :deep(.el-input__wrapper) {
            box-shadow: 0 0 0 1px #dcdfe6 inset;
            transition: all 0.3s;
            border-radius: 8px;

            &:hover {
                box-shadow: 0 0 0 1px #a0a6b1 inset;
            }

            &:focus,
            &.is-focus {
                box-shadow: 0 0 0 2px rgba(74, 108, 247, 0.2);
            }
        }
    }

    .btn-add-benefit {
        background: linear-gradient(135deg, #4a6cf7 0%, #7e57c2 100%);
        border: none;
        border-radius: 8px;
        transition: all 0.3s;
        padding: 10px 16px;

        &:hover {
            background: linear-gradient(135deg, #3d5ce0 0%, #6c48ab 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
        }
    }

    .btn-delete {
        border-radius: 8px;
        transition: all 0.3s;

        &:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 8px rgba(220, 38, 38, 0.25);
        }
    }

    .empty-state {
        opacity: 0.7;
        transition: opacity 0.3s;
        padding: 30px 0;

        &:hover {
            opacity: 1;
        }
    }

    .btn-cancel {
        border-radius: 8px;
        transition: all 0.3s;
        padding: 10px 20px;

        &:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
    }

    .btn-confirm {
        background: linear-gradient(135deg, #4a6cf7 0%, #7e57c2 100%);
        border: none;
        border-radius: 8px;
        transition: all 0.3s;
        padding: 10px 24px;

        &:hover {
            background: linear-gradient(135deg, #3d5ce0 0%, #6c48ab 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
        }
    }

    // 统一卡片标题样式
    .card-header {
        .el-icon {
            background: linear-gradient(135deg, #4a6cf7 0%, #7e57c2 100%);
            color: white;
            padding: 6px;
            border-radius: 8px;
            font-size: 18px;
        }
    }
}

// 统一卡片外观
.el-form-item.benefit-section {
    .benefit-card:last-child {
        margin-bottom: 0;
    }
}

.el-form-item.custom-benefits {
    .benefit-item-card {
        margin-bottom: 16px;
    }
}
</style>
<style lang="scss">
.diy-dialog-wrap .el-form-item__label {
    height: auto !important;
}

.package-dialog {
    border-radius: 12px !important;
    overflow: hidden;
    box-shadow: 0 12px 32px rgba(0, 0, 0, 0.12);

    .el-dialog__headerbtn {
        top: 18px;
        right: 18px;

        .el-dialog__close {
            color: white;
            font-size: 18px;

            &:hover {
                transform: rotate(90deg);
                transition: all 0.3s;
            }
        }
    }

    .el-form-item__label {
        font-weight: 500;
        font-size: 15px;
        color: #374151;
    }

    .el-form-item {
        margin-bottom: 22px;
    }
}
</style>
