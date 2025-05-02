<template>
    <el-card class="card-box" shadow="never">
        <el-form ref="formRef" :model="formData" :rules="formRules" label-width="120px" size="default" @submit.prevent>

            <div class="diy-editor-title">基础配置</div>
            <el-form-item label="是否显示" prop="isShow">
                <el-switch v-model="formData.isShow" :active-value="1" :inactive-value="0" />
            </el-form-item>

            <el-form-item label="显示样式" prop="customStyle">
                <el-radio-group v-model="formData.customStyle">
                    <el-radio :label="true">自定义样式</el-radio>
                    <el-radio :label="false">图片样式</el-radio>
                </el-radio-group>
            </el-form-item>

            <template v-if="!formData.customStyle">
                <div class="diy-editor-title">图片设置</div>
                <el-form-item label="背景图片" prop="imageUrl">
                    <upload-image v-model="formData.imageUrl" :limit="1" />
                </el-form-item>

                <el-form-item label="图片高度" prop="imageHeight">
                    <el-input-number v-model="formData.imageHeight" :min="50" :max="300" :step="5" />
                </el-form-item>
            </template>

            <template v-else>
                <div class="diy-editor-title">自定义样式</div>
                <el-form-item label="背景颜色" prop="bgColor">
                    <el-color-picker v-model="formData.bgColor" show-alpha />
                </el-form-item>

                <el-form-item label="文字颜色" prop="textColor">
                    <el-color-picker v-model="formData.textColor" show-alpha />
                </el-form-item>

                <el-form-item label="主标题" prop="mainTitle">
                    <el-input v-model="formData.mainTitle" placeholder="请输入主标题" maxlength="10" show-word-limit />
                </el-form-item>

                <el-form-item label="副标题" prop="subTitle">
                    <el-input v-model="formData.subTitle" placeholder="请输入副标题" maxlength="15" show-word-limit />
                </el-form-item>

                <el-form-item label="按钮文字" prop="buttonText">
                    <el-input v-model="formData.buttonText" placeholder="请输入按钮文字" maxlength="8" show-word-limit />
                </el-form-item>

                <el-form-item label="图标颜色" prop="iconColor">
                    <el-color-picker v-model="formData.iconColor" show-alpha />
                </el-form-item>

                <el-form-item label="边距设置(上右下左)">
                    <el-row :gutter="10">
                        <el-col :span="6">
                            <el-input-number v-model="formData.marginTop" :min="0" :max="50" placeholder="上" />
                        </el-col>
                        <el-col :span="6">
                            <el-input-number v-model="formData.marginRight" :min="0" :max="50" placeholder="右" />
                        </el-col>
                        <el-col :span="6">
                            <el-input-number v-model="formData.marginBottom" :min="0" :max="50" placeholder="下" />
                        </el-col>
                        <el-col :span="6">
                            <el-input-number v-model="formData.marginLeft" :min="0" :max="50" placeholder="左" />
                        </el-col>
                    </el-row>
                </el-form-item>
            </template>

            <div class="diy-editor-title">跳转设置</div>
            <el-form-item label="跳转链接" prop="linkUrl">
                <el-select v-model="formData.linkUrl" placeholder="请选择跳转页面">
                    <el-option label="骑手大厅" value="/addon/running/pages/rider/hall" />
                    <el-option label="骑手中心" value="/addon/running/pages/rider/center" />
                    <el-option label="骑手订单" value="/addon/running/pages/rider/order" />
                </el-select>
            </el-form-item>
        </el-form>

        <div class="diy-preview-title">组件预览</div>
        <div class="diy-preview-box">
            <template v-if="formData.customStyle">
                <div class="custom-rider-preview" :style="customPreviewStyle">
                    <div class="preview-left">
                        <div class="icon-wrapper" :style="iconWrapperStyle">
                            <i class="iconfont icon-user" :style="{ color: formData.iconColor || '#ffffff' }"></i>
                        </div>
                        <div class="text-content">
                            <span class="main-text" :style="{ color: formData.textColor || '#ffffff' }">{{
                                formData.mainTitle }}</span>
                            <span class="sub-text" :style="{ color: formData.textColor || '#ffffff', opacity: 0.8 }">{{
                                formData.subTitle }}</span>
                        </div>
                    </div>
                    <div class="preview-right" :style="buttonStyle">
                        <span class="btn-text" :style="{ color: formData.textColor || '#ffffff' }">{{
                            formData.buttonText }}</span>
                        <i class="el-icon-arrow-right" :style="{ color: formData.textColor || '#ffffff' }"></i>
                    </div>
                </div>
            </template>
            <template v-else>
                <div class="image-rider-preview">
                    <img :src="formData.imageUrl || '/static/resource/images/diy/figure.png'"
                        :style="{ height: `${formData.imageHeight}px` }" class="rider-image" />
                </div>
            </template>
        </div>
    </el-card>
</template>

<script lang="ts">
import { defineComponent, reactive, computed, watch } from 'vue'
import UploadImage from '@/components/upload-image/index.vue'

export default defineComponent({
    name: 'EditRiderTechnician',
    components: {
        UploadImage
    },
    props: {
        value: {
            type: Object,
            default: () => ({})
        }
    },
    emits: ['update:value'],
    setup(props, { emit }) {
        // 表单默认值
        const defaultData = {
            componentName: 'RiderTechnician',
            isShow: 1,
            customStyle: true,
            imageUrl: '',
            imageHeight: 100,
            bgColor: '#3b82f6',
            textColor: '#ffffff',
            iconColor: '#ffffff',
            mainTitle: '骑手中心',
            subTitle: '查看接单大厅',
            buttonText: '立即前往',
            marginTop: 20,
            marginRight: 20,
            marginBottom: 20,
            marginLeft: 20,
            linkUrl: '/addon/running/pages/rider/hall'
        }

        // 合并传入的值和默认值
        const formData = reactive({
            ...defaultData,
            ...props.value
        })

        // 表单验证规则
        const formRules = {
            linkUrl: [{ required: true, message: '请选择跳转链接', trigger: 'change' }]
        }

        // 自定义样式预览
        const customPreviewStyle = computed(() => {
            return {
                background: `linear-gradient(135deg, ${formData.bgColor} 0%, ${lightenColor(formData.bgColor, -20)} 100%)`,
                padding: '15px',
                borderRadius: '8px',
                boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)',
                margin: `${formData.marginTop}px ${formData.marginRight}px ${formData.marginBottom}px ${formData.marginLeft}px`
            }
        })

        const iconWrapperStyle = computed(() => {
            return {
                backgroundColor: 'rgba(255, 255, 255, 0.2)',
                width: '40px',
                height: '40px',
                borderRadius: '50%',
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center'
            }
        })

        const buttonStyle = computed(() => {
            return {
                backgroundColor: 'rgba(255, 255, 255, 0.2)',
                borderRadius: '15px',
                padding: '6px 10px'
            }
        })

        // 颜色处理函数 - 变暗
        function lightenColor(color: string, percent: number) {
            if (!color) return '#2563eb'

            // 去掉可能的 # 前缀
            let hex = color.replace('#', '')

            // 补全3位色值为6位
            if (hex.length === 3) {
                hex = hex.split('').map(char => char + char).join('')
            }

            // 转为RGB
            let r = parseInt(hex.substring(0, 2), 16)
            let g = parseInt(hex.substring(2, 4), 16)
            let b = parseInt(hex.substring(4, 6), 16)

            // 调整亮度
            r = Math.min(255, Math.max(0, r + percent))
            g = Math.min(255, Math.max(0, g + percent))
            b = Math.min(255, Math.max(0, b + percent))

            // 转回十六进制
            return `#${Math.round(r).toString(16).padStart(2, '0')}${Math.round(g).toString(16).padStart(2, '0')}${Math.round(b).toString(16).padStart(2, '0')}`
        }

        // 监听数据变化，向父组件同步
        watch(formData, (newVal) => {
            emit('update:value', newVal)
        }, { deep: true })

        return {
            formData,
            formRules,
            customPreviewStyle,
            iconWrapperStyle,
            buttonStyle
        }
    }
})
</script>

<style lang="scss" scoped>
.card-box {
    margin-bottom: 20px;
}

.diy-editor-title {
    font-size: 16px;
    font-weight: bold;
    margin: 15px 0;
    padding-left: 10px;
    border-left: 3px solid #409eff;
}

.diy-preview-title {
    font-size: 16px;
    font-weight: bold;
    margin: 20px 0 15px;
    text-align: center;
}

.diy-preview-box {
    background-color: #f5f7fa;
    border-radius: 8px;
    padding: 20px;
}

.custom-rider-preview {
    display: flex;
    justify-content: space-between;
    align-items: center;
    max-width: 400px;
    margin: 0 auto;

    .preview-left {
        display: flex;
        align-items: center;

        .icon-wrapper {
            margin-right: 10px;

            i {
                font-size: 18px;
            }
        }

        .text-content {
            display: flex;
            flex-direction: column;

            .main-text {
                font-size: 16px;
                font-weight: 600;
                margin-bottom: 3px;
            }

            .sub-text {
                font-size: 12px;
            }
        }
    }

    .preview-right {
        display: flex;
        align-items: center;

        .btn-text {
            font-size: 13px;
            margin-right: 3px;
        }

        i {
            font-size: 12px;
        }
    }
}

.image-rider-preview {
    display: flex;
    justify-content: center;

    .rider-image {
        width: auto;
        max-width: 100%;
        object-fit: contain;
    }
}
</style>