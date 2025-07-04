<template>
    <div class="main-container">
        <el-card class="box-card !border-none" shadow="never">

            <div class="flex flex-wrap min-w-[1200px]" v-if="page.use_template">
                <div class="page-item relative w-[340px] mr-[40px] pt-[90px] pb-[20px] bg-[#f7f7f7] bg-no-repeat">
                    <p class="absolute top-[54px] left-[50%] translate-x-[-50%] w-[130px] text-[14px] truncate text-center">{{ page.use_template.title }}</p>

                    <div v-show="page.use_template.url" class="w-[320px] h-[550px] mx-auto">
                        <iframe :id="'previewIframe_' + type" v-show="page.loadingIframe" class="w-[320px] h-[550px] mx-auto" :src="page.use_template.wapPreview" frameborder="0"></iframe>
                        <div v-show="page.loadingDev" class="w-[320px] h-[550px] mx-auto bg-body pt-[20px] px-[20px]">
                            <div class="font-bold text-xl mb-[40px]">{{ t('developTitle') }}</div>
                            <div class="mb-[20px] flex flex-col">
                                <text class="mb-[10px]">{{ t('wapDomain') }}</text>
                                <el-input v-model.trim="wapDomain" :placeholder="t('wapDomainPlaceholder')" clearable />
                            </div>
                            <div class="flex">
                                <el-button type="primary" @click="saveDomain()">{{ t('confirm') }}</el-button>
                                <el-button type="primary" @click="settingTips()" plain>{{ t('settingTips') }}</el-button>
                            </div>
                        </div>
                    </div>

                    <div v-show="!page.use_template.wapPreview" class="overflow-hidden w-[320px] h-[550px] mx-auto">
                        <img class="max-w-full" v-if="page.use_template.cover" :src="img(page.use_template.cover)" />
                    </div>

                    <div class="popup-wrap absolute inset-x-0 inset-y-0 select-none" :class="{ 'disabled': page.isDisabledPop }"></div>

                </div>

                <div class="w-[700px]">
                    <div class="flex flex-wrap">
                        <diy-link v-model="link" :ignore="['OTHER_LINK']" @success="changePage">
                            <el-button type="primary">{{ t('changePage') }}</el-button>
                        </diy-link>
                        <el-button type="primary" @click="toDecorate()" v-show="page.use_template.action == 'decorate'" class="ml-[12px]">{{ t('decorate') }}</el-button>
                    </div>

                    <div class="info-wrap">
                        <div class="mt-[20px] p-[20px] flex items-center justify-between bg">
                            <div>
                                <div class="font-bold">{{ t('H5') }}</div>
                                <el-form label-width="40px" class="mt-[5px]">
                                    <el-form-item :label="t('link')" class="mb-[5px]">
                                        <el-input readonly :value="page.shareUrl" class="!w-[390px]">
                                            <template #append>
                                                <el-button @click="copyEvent(page.shareUrl)" class="bg-primary copy">{{ t('copy') }}</el-button>
                                            </template>
                                        </el-input>
                                    </el-form-item>
                                </el-form>
                                <div class="text-[#999] text-base">{{ t('scanQRCodeOnRight') }}</div>
                            </div>
                            <div class="text-center">
                                <el-image class="w-[100px] h-[100px] mb-[5px]" :src="wapImage" />
                                <div @click="toPreview()" class="text-primary text-base cursor-pointer">{{ t('preview') }}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </el-card>
    </div>
</template>

<script lang="ts" setup>
import { reactive, ref, watch } from 'vue'
import { t } from '@/lang'
import { img } from '@/utils/common'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { getDecoratePage, changeTemplate } from '@/app/api/diy'
import storage from '@/utils/storage'
import QRCode from 'qrcode'
import { useClipboard } from '@vueuse/core'

const type: any = ref('DIY_INDEX');
const page: any = reactive({})
const router = useRouter()
const wapDomain = ref('')
const wapImage = ref('')
const link: any = ref({
    name: ''
})

// 切换页面
const formData = reactive({
    type: '',
    name: '',
    parent:'',
    page: '',
    title: '',
    action: ''
})

// 初始化数据
const refreshData = () => {
    getDecoratePage({
        type : type.value
    }).then(res => {
        for (const key in res.data) {
            page[key] = res.data[key]
        }

        link.value.name = page.use_template.name;
        link.value.title = page.use_template.title;
        link.value.url = page.use_template.page;
        link.value.action = page.use_template.action;
        link.value.parent = page.use_template.parent;

        if (page.use_template.url) {
            page.loadingIframe = false // 加载iframe
            page.loadingDev = false // 加载开发环境配置
            page.isDisabledPop = false // 是否禁止打开遮罩层
            page.difference = 0 // 检测页面加载差异，小于1000毫秒，则配置wap端域名

            wapDomain.value = page.domain_url.wap_domain
            page.wapUrl = page.domain_url.wap_url

            let repeat = true; // 防重复执行

            if (import.meta.env.MODE == 'development') {
                // 开发模式情况下，并且未配置wap域名，则获取缓存域名
                if (wapDomain.value && wapDomain.value.indexOf('localhost') != -1) {
                    page.wapUrl = wapDomain.value + '/wap'
                    repeat = false
                    setDomain()
                }
                if (storage.get('wap_domain')) {
                    page.wapUrl = storage.get('wap_domain')
                    repeat = false
                    setDomain()
                }
            }

            if(repeat) {
                setDomain()
            }
        }
    })
}

refreshData()

const uniAppLoadStatus = ref(false) // uni-app 加载状态，true：加载完成，false：未完成

// 监听 uni-app 端 是否加载完成
window.addEventListener('message', (event) => {
    try {
        let data = {
            type :''
        };
        if(typeof event.data == 'string') {
            data = JSON.parse(event.data)
        }else if(typeof event.data == 'object') {
            data = event.data
        }
        if (data.type && ['appOnLaunch', 'appOnReady'].indexOf(data.type) != -1) {
            page.loadingDev = false // 禁用开发环境配置
            page.loadingIframe = true // 加载iframe
            let loadTime = new Date().getTime()
            page.difference = loadTime - page.timeIframe
            page.isDisabledPop = false // 是否禁止打开遮罩层
            uniAppLoadStatus.value = true // 加载完成
        }
    } catch (e) {
        initLoad()
        console.log('diy index 后台接受数据错误', e)
    }
}, false)

// 将数据发送到uniapp
const postMessage = () => {
    const diyData = JSON.stringify({
        type: 'appOnReady',
        message: '加载完成'
    })
    if (window['previewIframe_' + type.value]) window['previewIframe_' + type.value].contentWindow.postMessage(diyData, '*')
}

// 初始化加载状态
const initLoad = () => {
    page.loadingDev = true
    page.isDisabledPop = true
    page.loadingIframe = false
}

const saveDomain = () => {
    if (wapDomain.value.trim().length == 0) {
        ElMessage({
            type: 'warning',
            message: `${t('wapDomainPlaceholder')}`,
        })
        return
    }
    const wapUrl = wapDomain.value + '/wap'
    storage.set({key: 'wap_domain', data: wapUrl})

    if (page.use_template.url) {
        page.wapUrl = wapUrl
        setDomain()
    }
    setTimeout(() => {
        if (page.use_template.url) {
            page.loadingIframe = true // 加载iframe
            page.loadingDev = false // 加载开发环境配置
            page.isDisabledPop = false // 是否禁止打开遮罩层
        }
    }, 100 * 3)
}

const settingTips = () => {
    window.open('https://www.kancloud.cn/niucloud/niucloud-admin-develop/3213393')
}

const setDomain = () => {
    page.use_template.wapPreview = page.wapUrl + page.use_template.url
    page.shareUrl = page.wapUrl + '/';
    QRCode.toDataURL(page.shareUrl, { errorCorrectionLevel: 'L', margin: 0, width: 100 }).then(url => {
        wapImage.value = url
    })

    const send = ()=>{
        page.timeIframe = new Date().getTime()
        postMessage()
    }

    // 同步发送一次消息
    send()

    // 如果同步发送消息的 uni-app没有接收到回应，则定时发送消息
    let sendCount = 0;
    let timeInterVal = setInterval(()=>{
        // 接收 uni-app 发送的消息 或者 发送50次后未响应，则停止发送
        if(uniAppLoadStatus.value || sendCount >= 50){
            clearInterval(timeInterVal)
            return
        }

        send()
        sendCount++;
    },200)

    // 如果10秒内加载不出来，则需要配置域名
    setTimeout(() => {
        if (page.difference == 0) initLoad()
    }, 1000 * 10)
}

// 跳转去装修
const toDecorate = () => {
    const query: any = {
        back: '/site/diy/index'
    }
    if (page.use_template.id) {
        query.id = page.use_template.id
    } else if (page.use_template.type) {
        query.name = page.use_template.type
    } else if (page.use_template.url) {
        query.url = page.use_template.url
    }
    const url = router.resolve({
        path: '/decorate/edit',
        query
    })
    window.open(url.href)
}

// 跳转去预览
const toPreview = () => {
    let value = page.use_template.page
    if (page.use_template.url) {
        value = page.use_template.url
    } else if (page.use_template.id) {
        value += '?id=' + page.use_template.id
    }
    const url = router.resolve({
        path: '/preview/wap',
        query: {
            page:value
        }
    })
    window.open(url.href)
}

const isRepeat = ref(false)
const changePage = ()=>{
    formData.type = type.value;
    formData.name = link.value.name;
    formData.page = link.value.url;
    formData.title = link.value.title;
    formData.action = link.value.action;
    formData.parent = link.value.parent;

    if (isRepeat.value) return
    isRepeat.value = true

    changeTemplate({
        ...formData
    }).then((res) => {
        isRepeat.value = false
        refreshData()
    })
}

// 复制
const { copy, isSupported, copied } = useClipboard()
const copyEvent = (text: string) => {
    if (!isSupported.value) {
        ElMessage({
            message: t('notSupportCopy'),
            type: 'warning'
        })
    }
    copy(text)
}

watch(copied, () => {
    if (copied.value) {
        ElMessage({
            message: t('copySuccess'),
            type: 'success'
        })
    }
})
</script>

<style lang="scss" scoped>
    .page-item {
        background-image: url(@/app/assets/images/iphone_bg.png);
        background-color: var(--el-bg-color);
        background-size: 100%;

        .popup-wrap {
            display: none;
        }

        &:hover {
            .popup-wrap:not(.disabled) {
                display: block !important;
            }
        }
    }
</style>
