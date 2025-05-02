<template>
    <view class="bg-[var(--page-bg-color)] min-h-screen" :style="themeColor()">
        <!-- 等级切换选项卡 -->
        <view class="level-tabs-wrapper" v-if="levelList.length > 1">
            <view class="level-tabs flex items-center rounded-[16rpx] mb-2 overflow-hidden">
                <view v-for="(item, index) in levelList" :key="index"
                    class="level-tab flex-1 py-2 px-2 text-center text-[28rpx] relative"
                    :class="[selectedLevelIndex === index ? 'active-tab font-bold' : 'text-gray-500']"
                    @click="changeLevel(index)">
                    {{ item.name }}
                    <view v-if="selectedLevelIndex === index" class="tab-indicator"></view>
                </view>
            </view>
        </view>

        <!-- 内容区域，不使用swiper改用直接显示 -->
        <view class="mb-6">
            <view v-if="levelList.length > 0 && selectedLevel">
                <u-parse :content="selectedLevel.content"
                    :tagStyle="{ img: 'max-width: 100%; height: auto; vertical-align: top;', p: 'overflow: hidden;word-break:break-word;margin: 10rpx 0;' }">
                </u-parse>
            </view>
            <view v-else class="py-10 text-center text-gray-400 text-[28rpx]">
                加载中...
            </view>
        </view>

        <view class="h-22"></view>

        <view v-if="baseConfig"
            class="py-[var(--top-m)] px-[var(--sidebar-m)] footer w-full fixed bottom-0 left-0 right-0 box-border bg-[var(--page-bg-color)] safe-area-inset-bottom">
            <view class="flex items-center ml-4">
                <checkbox-group class="flex items-center uni-list" @change="checkboxChange">
                    <u-checkbox v-model="isOpenAgreement" shape="circle" :name="true" size="18"
                        activeColor="var(--primary-color)" @change="checkboxChange"></u-checkbox>
                    <view class="hover:text-gray-500 active:text-gray-600 inline-flex items-center text-[24rpx]"
                        role="button" tabindex="0">
                        阅读并同意
                        <span @click="
                            redirect({
                                url: '/app/pages/auth/agreement?key=tk_partner_service',
                            })" class="text-[24rpx]" style="">
                            《{{ "服务协议" }}》
                        </span>
                    </view>
                </checkbox-group>
            </view>
            <view class="ml-4 mr-4 mt-2">
                <button hover-class="none" v-if="baseConfig.join_type == 'pay'"
                    class="h-[80rpx] leading-[80rpx] rounded-[24rpx] text-[32rpx] text-[var(--primary-color-light)] w-full"
                    :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color2))' }"
                    @click="submitEvent()">支付{{ selectedLevel?.price || 0 }}成为{{ selectedLevel?.name || '合伙人'
                    }}</button>
               <button hover-class="none" v-if="baseConfig.join_type == 'contact'"
                    class="h-[80rpx] leading-[80rpx] rounded-[24rpx] text-[32rpx] text-[var(--primary-color-light)] w-full"
                    :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color2))' }"
                    @click="contactShow = true">联 系 顾 问 开 通</button>
            </view>
            <u-safe-bottom></u-safe-bottom>
        </view>
        <u-popup :show="contactShow" @close="contactShow = false" mode="center" :closeable="true">
            <view class="p-6 contact-popup">
                <view class="text-center font-bold text-lg mb-4">联系顾问开通</view>
                <view class="contact-content">
                    <view class="qrcode-container">
                        <image 
                            class="qrcode-image" 
                            :src="img(contact_qrcode)" 
                            mode="aspectFill"
                            @click="previewImage(contact_qrcode)"
                        ></image>
                        <view class="mt-2 text-center text-sm text-gray-500">点击二维码可预览</view>
                    </view>
                    <view @click="saveQrCode" class="save-btn">
                        <u-icon name="download" size="14" class="mr-1"></u-icon>
                        <text>保存二维码到相册</text>
                    </view>
                    <view class="divider"></view>
                    <view class="phone-container">
                        <view class="text-gray-600">联系电话：</view>
                        <view class="phone-action">
                            <text class="phone-number">{{phone}}</text>
                            <view @click="makePhoneCall(phone)" class="call-btn">
                                <u-icon name="phone" color="#ffffff" size="14" class="mr-1"></u-icon>
                                拨打
                            </view>
                        </view>
                    </view>
                </view>
            </view>
        </u-popup>
        <u-popup :show="shareShow" @close="shareShow = false" mode="center" :closeable="true"
            :safe-area-inset-bottom="true" :close-icon-pos="'top-right'">
            <view class="p-6">
                <view class="text-center font-bold text-lg mb-4">请输入邀请码</view>
                <view class="text-center text-gray-500 text-[24rpx] mb-2">该权益属于邀请制，需邀请码才能开通权益</view>
                <u-input v-model="shareCode" placeholder="请输入邀请码" borderBottom class="mb-5" />
                <button class="mt-4 h-[80rpx] leading-[80rpx] text-[32rpx] font-500 rounded-[24rpx] text-white w-full"
                    :style="{ background: 'linear-gradient(to right, var(--primary-color), var(--primary-help-color2))' }"
                    @click="submit()">马上支付</button>
            </view>
        </u-popup>
        <pay ref="payRef" @close="payLoading = false"></pay>
    </view>
    <!-- #ifdef MP-WEIXIN -->
    <!-- 小程序隐私协议 -->
    <wx-privacy-popup ref="wxPrivacyPopupRef"></wx-privacy-popup>
    <!-- #endif -->
</template>

<script setup lang="ts">
import { ref, reactive, onUnmounted, nextTick, onMounted } from "vue";
import { img, copy, redirect } from "@/utils/common";
import { onLoad, onReachBottom, onShow } from "@dcloudio/uni-app";
import { getLevelList } from "@/addon/tk_partner/api/level";
import { getConfig } from "@/addon/tk_partner/api/config";
import { addOrder } from "@/addon/tk_partner/api/order";
import { checkPartnerOpen } from '@/addon/tk_partner/api/partner'
import { authLogin } from "@/addon/tk_partner/utils/ts/common";
const contactShow = ref<boolean>(false)
import { getPartnerInfo, getPartnerInfoByPid } from '@/addon/tk_partner/api/partner';
onShow(() => {
    authLogin()
})
const contact_qrcode = ref<string>('');
const phone = ref<string>('');
const partnerInfo = ref<any>(null);

import useConfigStore from "@/stores/config";
const baseConfig = ref<any>({});
const shareCode = ref<string>('');

// 获取配置信息
getConfig().then((res: any) => {
    baseConfig.value = res.data;
    contact_qrcode.value = baseConfig.value.contact_qrcode;
    phone.value = baseConfig.value.phone;
});

// 根据pid获取合伙人信息
if (uni.getStorageSync("pid") > 0) {
    getPartnerInfoByPid(uni.getStorageSync("pid")).then((res: any) => {
        partnerInfo.value = res.data;
        
        // 如果合伙人信息中有联系方式，则优先使用
        if (partnerInfo.value && partnerInfo.value.contact_qrcode && partnerInfo.value.phone) {
            contact_qrcode.value = partnerInfo.value.contact_qrcode[0];
            phone.value = partnerInfo.value.phone;
        }
    });
}

// 定义接口类型
interface LevelItem {
    content: string;
    name: string;
    price: number;
    [key: string]: any;
}

const config = ref<any>({});
const isOpenAgreement = ref<boolean>(false);
const showFenxiaoDetail = ref<boolean>(false);
const selectedLevel = ref<LevelItem | null>(null);
const selectedLevelIndex = ref<number>(0);
const levelList = ref<LevelItem[]>([]);

// 获取分销等级列表
getLevelList().then((res: any) => {
    if (res.data && res.data.data) {
        levelList.value = res.data.data;
        selectedLevel.value = levelList.value[0];
        selectedLevelIndex.value = 0;
           checkPartnerOpen().then((res: any) => {
        if (res.data.type == 'success') {
            uni.showToast({
                title: '您已开通' + selectedLevel.value?.name + '权益',
                icon: 'none'
            });
            return;
        }
    })
    }
});

// 切换等级
const changeLevel = (index: number) => {
    selectedLevelIndex.value = index;
    selectedLevel.value = levelList.value[index];
    // 滚动到顶部
    uni.pageScrollTo({
        scrollTop: 0,
        duration: 300
    });
 
};

const checkboxChange = (e: any) => {
    isOpenAgreement.value = e;
};

const payRef = ref<any>(null);
const payLoading = ref(false);
const shareShow = ref(false)
const submitEvent = async () => {
    authLogin()
    if (!isOpenAgreement.value) {
        uni.showToast({
            title: '请先阅读并同意协议',
            icon: 'none'
        });
        return;
    }
    checkPartnerOpen().then((res: any) => {
        if (res.data.type == 'success') {
            uni.showToast({
                title: '您已开通' + selectedLevel.value?.name + '权益',
                icon: 'none'
            });
            return;
        }
    })
    if (baseConfig.value.is_share_code == 1) {
        shareShow.value = true
        return
    } else {
        submit()
    }
};
const submit = async () => {
    addOrder({
        level_id: selectedLevel.value?.id,
        share_code: shareCode.value,
        pid: uni.getStorageSync("pid"),
    }).then((res: any) => {
        if (res.data.type == 'success') {
            redirect({ url: '/addon/tk_partner/pages/partner/index' });
            uni.showToast({
                title: '申请成功',
                icon: 'none'
            });
            return;
        }
        payLoading.value = true;
        payRef.value?.open(res.data.trade_type, res.data.trade_id, '/addon/tk_partner/pages/partner/index');
    })
}


// 获取主题颜色方法
const configStore = useConfigStore();
const themeColor = () => {
    return configStore.getThemeColor();
};

// 预览图片
const previewImage = (url: string) => {
    // 确保弹窗关闭状态下再预览图片，防止层级问题
    contactShow.value = false;
    // 短暂延迟确保弹窗已关闭
    setTimeout(() => {
        uni.previewImage({
            urls: [img(url)],
            current: img(url),
            // #ifdef H5
            // H5环境设置高层级
            style: {
                zIndex: 999999
            },
            // #endif
            success: () => {
                // 预览成功
            },
            fail: () => {
                uni.showToast({
                    title: '预览失败，请重试',
                    icon: 'none'
                });
                // 预览失败时直接在新窗口打开图片
                // #ifdef H5
                window.open(img(url));
                // #endif
            }
        });
    }, 100);
};

// 保存二维码到相册
const saveQrCode = () => {
    // #ifdef H5
    saveImageInH5(contact_qrcode.value);
    // #endif
    
    // #ifndef H5
    uni.showLoading({
        title: '保存中...'
    });
    uni.downloadFile({
        url: img(contact_qrcode.value),
        success: (res) => {
            if (res.statusCode === 200) {
                uni.saveImageToPhotosAlbum({
                    filePath: res.tempFilePath,
                    success: () => {
                        uni.showToast({
                            title: '保存成功',
                            icon: 'success'
                        });
                    },
                    fail: (err) => {
                        if (err.errMsg.indexOf('auth deny') > -1) {
                            uni.showModal({
                                title: '提示',
                                content: '需要您授权保存到相册',
                                success: (res) => {
                                    if (res.confirm) {
                                        uni.openSetting();
                                    }
                                }
                            });
                        } else {
                            uni.showToast({
                                title: '保存失败',
                                icon: 'none'
                            });
                        }
                    }
                });
            }
        },
        fail: () => {
            uni.showToast({
                title: '下载失败',
                icon: 'none'
            });
        },
        complete: () => {
            uni.hideLoading();
        }
    });
    // #endif
};

// H5环境下保存图片
const saveImageInH5 = (imageUrl: string) => {
    uni.showLoading({
        title: '准备下载...'
    });
    
    // 创建a标签用于下载
    const a = document.createElement('a');
    const event = new MouseEvent('click');
    
    // 使用Canvas处理跨域图片
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');
    const imgObj = new Image();
    
    // 处理跨域问题
    imgObj.crossOrigin = 'Anonymous';
    
    // 图片加载完成后处理
    imgObj.onload = () => {
        // 设置Canvas尺寸与图片一致
        canvas.width = imgObj.width;
        canvas.height = imgObj.height;
        
        // 绘制图片到Canvas
        ctx?.drawImage(imgObj, 0, 0);
        
        try {
            // 转换为Blob并下载
            canvas.toBlob((blob) => {
                if (blob) {
                    const url = URL.createObjectURL(blob);
                    a.href = url;
                    a.download = '二维码_' + new Date().getTime() + '.png';
                    a.dispatchEvent(event);
                    URL.revokeObjectURL(url);
                    
                    uni.hideLoading();
                    uni.showToast({
                        title: '图片已准备，请查看下载',
                        icon: 'none',
                        duration: 2000
                    });
                }
            }, 'image/png');
        } catch (e) {
            // 降级处理：直接打开图片，让用户自行保存
            window.open(img(imageUrl));
            uni.hideLoading();
            uni.showToast({
                title: '请长按图片保存',
                icon: 'none',
                duration: 2000
            });
        }
    };
    
    // 图片加载失败
    imgObj.onerror = () => {
        uni.hideLoading();
        uni.showToast({
            title: '图片加载失败，请长按二维码保存',
            icon: 'none',
            duration: 2000
        });
        
        // 降级方案：直接打开图片
        setTimeout(() => {
            window.open(img(imageUrl));
        }, 1500);
    };
    
    // 设置图片源
    imgObj.src = img(imageUrl);
};

// 拨打电话
const makePhoneCall = (phone: string) => {
    uni.makePhoneCall({
        phoneNumber: phone,
        fail: () => {
            uni.showToast({
                title: '拨号取消',
                icon: 'none'
            });
        }
    });
};
</script>

<style lang="scss">
@import "@/addon/tk_partner/utils/styles/common.scss";

/* 等级选项卡样式 */
.level-tabs-wrapper {
    width: 100%;
    z-index: 99;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    padding: 8rpx 16rpx;
    z-index: 999;
    background-color: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(20rpx);
    transition: all 0.3s;
}

.level-tabs {
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.level-tab {
    transition: all 0.3s;
}

.active-tab {
    color: var(--primary-color);
    position: relative;
}

.tab-indicator {
    position: absolute;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 30%;
    height: 4rpx;
    background: var(--primary-color);
    border-radius: 2rpx;
}

.swipe-tip {
    background-color: rgba(255, 255, 255, 0.7);
    border-radius: 30rpx;
    padding: 6rpx 16rpx;
    width: fit-content;
    margin: 0 auto;
}

/* 内容区域样式 */
.content-wrapper {
    width: 100%;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    box-sizing: border-box;
}

/* 富文本样式优化 */
:deep(.u-parse) {
    width: 100%;

    img {
        max-width: 100% !important;
        height: auto !important;
        margin: 5rpx 0;
    }

    p,
    div {
        line-height: 1.6;
        margin: 10rpx 0;
    }

    h1,
    h2,
    h3,
    h4,
    h5,
    h6 {
        margin-top: 20rpx;
        margin-bottom: 15rpx;
    }

    table {
        width: 100% !important;
        border-collapse: collapse;
        margin: 10rpx 0;
    }

    td,
    th {
        border: 1px solid #ddd;
        padding: 8rpx;
    }
}

.float-btn {
    position: fixed;
    right: 30rpx;
    bottom: 240rpx;
    width: 90rpx;
    height: 90rpx;
    border-radius: 50%;
    background: linear-gradient(to right, var(--primary-color-light), var(--primary-color-light));
    display: flex;
    justify-content: center;
    align-items: center;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    z-index: 999;
}

/* 弹窗样式优化 */
:deep(.u-popup) {
    border-radius: 24rpx !important;
    overflow: hidden;
}

:deep(.u-popup__content) {
    border-radius: 24rpx !important;
}

/* 底部安全区域适配 */
.safe-bottom {
    padding-bottom: constant(safe-area-inset-bottom);
    padding-bottom: env(safe-area-inset-bottom);
}

/* 联系顾问弹窗样式 */
.contact-popup {
    width: 600rpx;
    max-width: 90vw;
    box-sizing: border-box;
}

.contact-content {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.qrcode-container {
    width: 100%;
    margin-bottom: 20rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.qrcode-image {
    width: 400rpx;
    height: 400rpx;
    border-radius: 12rpx;
}

.save-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f5f5f5;
    padding: 12rpx 30rpx;
    border-radius: 100rpx;
    margin-bottom: 20rpx;
    font-size: 26rpx;
    color: #666;
}

.save-btn:active {
    background-color: #e5e5e5;
}

.divider {
    width: 100%;
    height: 1rpx;
    background-color: #f0f0f0;
    margin: 16rpx 0;
}

.phone-container {
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16rpx 0;
}

.phone-action {
    display: flex;
    align-items: center;
}

.phone-number {
    color: var(--primary-color);
    font-weight: bold;
    margin-right: 16rpx;
}

.call-btn {
    display: flex;
    align-items: center;
    background: var(--primary-color);
    color: #fff;
    padding: 8rpx 20rpx;
    border-radius: 100rpx;
    font-size: 24rpx;
}

.call-btn:active {
    opacity: 0.8;
}
</style>
