import { copy } from "@/utils/common"
import { img, getToken, redirect } from '@/utils/common'
import { useLogin } from "@/hooks/useLogin";

export function authLoginWx() {
    if (!getToken()) {
        const login = useLogin();
        // 第三方平台自动登录
        // #ifdef MP
        if (uni.getStorageSync('autoLoginLock')) return;
        login.getAuthCode();
        // #endif
    }
    return true //自动进行登录
}
export function authLogin() {
    if (!getToken()) {
        const login = useLogin();
        // 第三方平台自动登录
        // #ifdef MP
        login.getAuthCode();
        // #endif
        // #ifdef H5
        useLogin().setLoginBack({ url: '/addon/tk_partner/pages/partner/index' })
        // #endif
    }
    return true //自动进行登录
}


export function dateChange(date) {
    return new Date(date).getTime() // 将日期值转换为时间戳
}
export function timeChange(timestamp) {
    const date = new Date(timestamp * 1000);
    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const day = date.getDate();
    const hours = date.getHours();
    const minutes = date.getMinutes();
    const seconds = date.getSeconds();
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}
/**
 * 生成唯一字符
 * @param {Number} len
 * @param {Boolean} firstU
 * @param {Nubmer} radix
 */
export function guid(len = 10, firstU = true, radix = null) {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('')
    const uuid = []
    radix = radix || chars.length

    if (len) {
        // 如果指定uuid长度,只是取随机的字符,0|x为位运算,能去掉x的小数位,返回整数位
        for (let i = 0; i < len; i++) uuid[i] = chars[0 | Math.random() * radix]
    } else {
        let r
        // rfc4122标准要求返回的uuid中,某些位为固定的字符
        uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-'
        uuid[14] = '4'

        for (let i = 0; i < 36; i++) {
            if (!uuid[i]) {
                r = 0 | Math.random() * 16
                uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r]
            }
        }
    }
    // 移除第一个字符,并用u替代,因为第一个字符为数值时,该guuid不能用作id或者class
    if (firstU) {
        uuid.shift()
        return `u${uuid.join('')}`
    }
    return uuid.join('')
}

export async function downloadFileEvent(url: string): Promise<void> {
    const platform = uni.getSystemInfoSync().platform;
    if (platform === 'devtools' || /^mp-/.test(platform)) {
        // 小程序环境
        try {
            await handleMediaDownload(url);
        } catch (err: any) {
            console.error('下载过程发生错误:', err);
            uni.$u.toast(err.errMsg || '下载失败，请稍后重试');
        }
    } else {
        // H5 环境
        const ua = window.navigator.userAgent.toLowerCase();
        const isWeixin = ua.indexOf('micromessenger') !== -1;
        if (isWeixin) {
            copy(url, '')
            uni.$u.toast('链接已复制，请在在浏览器中打开下载');
        } else {
            const a = document.createElement('a');
            a.href = url;
            a.download = url.substring(url.lastIndexOf('/') + 1);
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            uni.$u.toast('开始下载');
        }
    }
};

// 处理媒体文件下载
const handleMediaDownload = async (url: string): Promise<void> => {
    showLoading();
    try {
        const downloadRes = await downloadFile(url);
        if (downloadRes.statusCode === 200) {
            uni.$u.toast('文件下载成功');
        } else {
            throw new Error(`下载失败，状态码: ${downloadRes.statusCode}`);
        }
    } catch (error: any) {
        console.error('文件下载失败:', error);
        uni.$u.toast(error.message || '文件下载失败');
    } finally {
        hideLoading();
    }
};

// 显示加载提示
const showLoading = () => {
    uni.showLoading({
        title: '下载中...',
        mask: true
    });
};

// 隐藏加载提示
const hideLoading = () => {
    uni.hideLoading();
};

// 下载文件
const downloadFile = (url: string): Promise<UniApp.DownloadFileSuccessData> => {
    return new Promise((resolve, reject) => {
        uni.downloadFile({
            url: url,
            success: resolve,
            fail: reject
        });
    });
};

/**
 * 截断长文本，保留两端，中间用省略号替代
 * @param {string} text 需要处理的文本
 * @param {number} start 开头保留的字符数
 * @param {number} end 结尾保留的字符数
 * @returns {string} 处理后的文本
 */
export function truncateMiddle(text: string, start: number = 2, end: number = 4): string {
    if (!text) return '';
    if (text.length <= start + end) return text;

    const startText = text.substring(0, start);
    const endText = text.substring(text.length - end);

    return `${startText}...${endText}`;
}

/**
 * 获取URL参数
 * @param {string} url 需要处理的URL
 * @returns {Object} 参数对象
 */
export function queryParamsString(url: string, mid: string) {
    if (!url) return '';
    return url.includes('?') ? `${url}&mid=${mid}` : `${url}?mid=${mid}`;
}