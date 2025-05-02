import { copy } from "@/utils/common"
import { getConfig } from "@/addon/ai_humans/api/config"
import { checkAccount } from '@/addon/ai_humans/api/member'
import { redirect } from '@/utils/common'
import { img, getToken } from '@/utils/common'
import { useLogin } from "@/hooks/useLogin";
export function authLoginWx() {
    if (!getToken()) {
        const login = useLogin();
        // 第三方平台自动登录
        // #ifdef MP
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
        useLogin().setLoginBack({ url: '/addon/ai_humans/pages/fenxiao/index' })
        // #endif
    }
    return true //自动进行登录
}
export async function checkAccountEvent(scene: string) {
    const res = await checkAccount(scene)
    if (res.data.type == 'error') {
        redirect({ url: '/addon/ai_humans/pages/package/package' })
        uni.$u.toast('余量不足，请先购买套餐')
        return false
    }
    return true
}

export function dateChange(date) {
    return new Date(date).getTime() // 将日期值转换为时间戳
}
export async function getBaseConfig() {
    let res = await getConfig()
    return res.data
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
    try {
        const platform = uni.getSystemInfoSync().platform;

        // 微信小程序环境
        // #ifdef MP-WEIXIN
        // 检查链接是否有效
        if (!url || typeof url !== 'string') {
            uni.showToast({
                title: '下载链接无效',
                icon: 'none'
            });
            return;
        }

        // 判断文件类型
        const isVideo = url.match(/\.(mp4|avi|mov|wmv|flv|mkv)$/i);
        const isAudio = url.match(/\.(mp3|wav|ogg|aac|m4a)$/i);

        // 显示下载提示
        uni.showLoading({
            title: '准备下载...',
            mask: true
        });

        // 处理视频和音频文件
        if (isVideo || isAudio) {
            const fileType = isVideo ? '视频' : '音频';

            try {
                // 先将链接保存到本地临时文件
                const downloadRes = await new Promise<UniApp.DownloadSuccessData>((resolve, reject) => {
                    const downloadTask = uni.downloadFile({
                        url,
                        success: resolve,
                        fail: reject
                    });

                    // 添加下载进度监听
                    downloadTask.onProgressUpdate((res) => {
                        uni.showLoading({
                            title: `下载中 ${res.progress}%`,
                            mask: true
                        });
                    });
                });

                if (downloadRes.statusCode === 200) {
                    uni.hideLoading();
                    uni.showToast({
                        title: '下载完成',
                        icon: 'success',
                        duration: 1500
                    });

                    // 保存到手机相册
                    if (isVideo) {
                        uni.saveVideoToPhotosAlbum({
                            filePath: downloadRes.tempFilePath,
                            success: () => {
                                uni.showToast({
                                    title: '视频已保存到相册',
                                    icon: 'success'
                                });
                            },
                            fail: (err) => {
                                console.error('保存视频到相册失败:', err);
                                // 如果是权限问题，引导用户授权
                                if (err.errMsg && err.errMsg.includes('authorize')) {
                                    uni.showModal({
                                        title: '提示',
                                        content: '需要授权保存到相册',
                                        success: (res) => {
                                            if (res.confirm) {
                                                uni.openSetting();
                                            }
                                        }
                                    });
                                } else {
                                    uni.showToast({
                                        title: '保存到相册失败',
                                        icon: 'none'
                                    });
                                }
                            }
                        });
                    } else if (isAudio) {
                        // 音频文件处理 - 提供预览或播放选项
                        uni.showModal({
                            title: '下载成功',
                            content: '音频文件已下载，是否立即播放？',
                            confirmText: '播放',
                            cancelText: '关闭',
                            success: (res) => {
                                if (res.confirm) {
                                    const innerAudioContext = uni.createInnerAudioContext();
                                    innerAudioContext.src = downloadRes.tempFilePath;
                                    innerAudioContext.play();
                                    uni.showToast({
                                        title: '播放中...',
                                        icon: 'none',
                                        duration: 2000
                                    });
                                }
                            }
                        });
                    }
                } else {
                    uni.hideLoading();
                    throw new Error(`下载失败，状态码: ${downloadRes.statusCode}`);
                }
            } catch (error: any) {
                uni.hideLoading();
                console.error(`${fileType}下载失败:`, error);
                uni.showToast({
                    title: error.message || `${fileType}下载失败，请稍后重试`,
                    icon: 'none'
                });
            }
        } else {
            // 其他类型文件的处理
            try {
                const downloadTask = uni.downloadFile({
                    url,
                    success: (res) => {
                        if (res.statusCode === 200) {
                            uni.hideLoading();
                            // 保存文件到本地
                            uni.saveFile({
                                tempFilePath: res.tempFilePath,
                                success: (saveRes) => {
                                    uni.showToast({
                                        title: '文件已保存',
                                        icon: 'success'
                                    });
                                    // 打开文档预览
                                    uni.openDocument({
                                        filePath: saveRes.savedFilePath,
                                        showMenu: true,
                                        success: () => {
                                            console.log('打开文档成功');
                                        },
                                        fail: (err) => {
                                            console.error('打开文档失败:', err);
                                            uni.showToast({
                                                title: '无法预览此类型文件',
                                                icon: 'none'
                                            });
                                        }
                                    });
                                },
                                fail: (err) => {
                                    uni.hideLoading();
                                    console.error('保存文件失败:', err);
                                    uni.showToast({
                                        title: '保存文件失败',
                                        icon: 'none'
                                    });
                                }
                            });
                        } else {
                            uni.hideLoading();
                            uni.showToast({
                                title: `下载失败，状态码: ${res.statusCode}`,
                                icon: 'none'
                            });
                        }
                    },
                    fail: (err) => {
                        uni.hideLoading();
                        console.error('下载文件失败:', err);
                        uni.showToast({
                            title: '下载失败',
                            icon: 'none'
                        });
                    }
                });

                // 添加下载进度监听
                downloadTask.onProgressUpdate((res) => {
                    uni.showLoading({
                        title: `下载中 ${res.progress}%`,
                        mask: true
                    });
                });
            } catch (error: any) {
                uni.hideLoading();
                console.error('下载过程发生错误:', error);
                uni.showToast({
                    title: error.message || '下载失败，请稍后重试',
                    icon: 'none'
                });
            }
        }
        // #endif

        // 其他平台环境处理
        // #ifndef MP-WEIXIN
        // H5 环境
        // #ifdef H5
        const ua = window.navigator.userAgent.toLowerCase();
        const isWeixin = ua.indexOf('micromessenger') !== -1;

        if (isWeixin) {
            copy(url, '');
            uni.showToast({
                title: '链接已复制，请在浏览器中打开下载',
                icon: 'none'
            });
        } else {
            try {
                const a = document.createElement('a');
                a.href = url;
                a.download = url.substring(url.lastIndexOf('/') + 1);
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);

                uni.showToast({
                    title: '开始下载',
                    icon: 'none'
                });
            } catch (error) {
                console.error('H5下载文件失败:', error);
                uni.showToast({
                    title: '下载失败，请稍后重试',
                    icon: 'none'
                });
            }
        }
        // #endif
        // #endif
    } catch (error) {
        uni.hideLoading();
        console.error('下载文件过程中发生未知错误:', error);
        uni.showToast({
            title: '下载失败，请稍后重试',
            icon: 'none'
        });
    }
}