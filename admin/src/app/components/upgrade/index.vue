<template>
    <el-dialog v-model="showDialog" :title="t('upgrade.title')" width="850px" :close-on-click-modal="false" :close-on-press-escape="false" :before-close="dialogClose">

        <template v-if="upgradeContent">
            <!-- 检测服务是否到期 -->
            <template v-if="step == 1">
                <div class="text-lg">
                    <template v-if="upgradeContent.upgrade_version">
                        <span>本次升级将从</span>
                        <span class="font-bold px-[2px]">{{ upgradeContent.version }}</span>
                        <span>升级到</span>
                        <span class="font-bold px-[2px]">{{ upgradeContent.upgrade_version }}</span>
                        <span>版本</span>
                    </template>
                    <template v-else>
                        <span>当前版本</span>
                        <span class="font-bold px-[2px]">{{ upgradeContent.version }}</span>
                    </template>
                </div>
                <div class="mt-[10px]">
                    <el-alert type="info" show-icon :closable="false">
                        <template #title>
                            <span>当前最新版本为{{ upgradeContent.last_version }}，您的服务{{ upgradeContent.expire_time ? `已于${upgradeContent.expire_time}到期` : '长期有效' }}。</span>
                            <span>如需升级到最新版可在<a class="text-primary" href="https://www.niucloud.com" target="_blank">niucloud-admin官网</a>购买相关服务后再进行升级</span>
                        </template>
                    </el-alert>
                </div>
            </template>
            <div v-if="step == 2">
                <el-steps :active="numberOfSteps" align-center class="number-of-steps" finish-status="success" process-status="process">
                    <el-step :title="t('testDirectoryPermissions')" />
                    <el-step :title="t('backupFiles')" />
                    <el-step :title="t('startUpgrade')" />
                    <el-step :title="t('upgradeEnd')" />
                </el-steps>
                <div class="h-[400px]" style="overflow: auto">
<!--                    <div class="time-dialog-wrap mt-[30px]" v-show="active == 'content'">-->
<!--                        <el-timeline style="width: 100%">-->
<!--                            <el-timeline-item v-for="(item, index) in upgradeContent.version_list" :key="index" placement="left">-->
<!--                                <div class="relative">-->
<!--                                    <span class="text-[#333333] text-[16px] absolute">{{ timeSplit(item.release_time)[0] }}</span>-->
<!--                                    <br />-->
<!--                                    <span class="text-[#999999] text-[14px] w-[78px] block mt-[10px] absolute" style="text-align: right"> {{ timeSplit(item.release_time)[1] }}</span>-->
<!--                                </div>-->
<!--                                <el-collapse v-model="activeName" accordion>-->
<!--                                    <el-collapse-item :name="index">-->
<!--                                        <template #title>-->
<!--                                            <span class="text-[#333] text-[16px]"> v{{ item.version_no }} </span>-->
<!--                                        </template>-->

<!--                                        <div class="px-[20px] py-[20px] bg-overlay timeline-log-wrap whitespace-pre-wrap rounded-[4px]" style="background: rgba(25, 103, 249, 0.03);" v-if="item['upgrade_log']">-->
<!--                                            <div v-html="item['upgrade_log']"></div>-->
<!--                                        </div>-->
<!--                                    </el-collapse-item>-->
<!--                                </el-collapse>-->
<!--                            </el-timeline-item>-->
<!--                        </el-timeline>-->
<!--                    </div>-->

                    <!-- 判断文件权限 -->
                    <div v-show="active == 'upgrade'">
                        <div class="flex flex-col" v-if="upgradeCheck && !upgradeTask">
                            <el-scrollbar>
                                <div class="bg-[#fff] my-3" v-if="upgradeCheck.dir">
                                    <div class="px-[20px] pt-[10px] text-[14px] el-table">
                                        <el-row class="py-[10px] items table-head-bg pl-[15px] mb-[10px]">
                                            <el-col :span="12">
                                                <span>{{ t("upgrade.path") }}</span>
                                            </el-col>
                                            <el-col :span="6">
                                                <span>{{ t("upgrade.demand") }}</span>
                                            </el-col>
                                            <el-col :span="6">
                                                <span>{{ t("status") }}</span>
                                            </el-col>
                                        </el-row>

                                        <div style="height: calc(300px); overflow: auto">
                                            <el-row class="pb-[10px] items pl-[15px]" v-for="item in upgradeCheck.dir.is_readable">
                                                <el-col :span="12">
                                                    <span>{{ item.dir }}</span>
                                                </el-col>
                                                <el-col :span="6">
                                                    <span>{{ t("upgrade.readable") }}</span>
                                                </el-col>
                                                <el-col :span="6">
                                                    <span v-if="item.status">
                                                        <el-icon color="green">
                                                            <Select />
                                                        </el-icon>
                                                    </span>
                                                    <span v-else>
                                                        <el-icon color="red">
                                                            <CloseBold />
                                                        </el-icon>
                                                    </span>
                                                </el-col>
                                            </el-row>
                                            <el-row class="pb-[10px] items pl-[15px]" v-for="item in upgradeCheck.dir.is_write">
                                                <el-col :span="12">
                                                    <span>{{ item.dir }}</span>
                                                </el-col>
                                                <el-col :span="6">
                                                    <span>{{ t("upgrade.write") }}</span>
                                                </el-col>
                                                <el-col :span="6">
                                                    <span v-if="item.status">
                                                        <el-icon color="green">
                                                            <Select />
                                                        </el-icon>
                                                    </span>
                                                    <span v-else>
                                                        <el-icon color="red">
                                                            <CloseBold />
                                                        </el-icon>
                                                    </span>
                                                </el-col>
                                            </el-row>
                                        </div>
                                    </div>
                                </div>
                            </el-scrollbar>
                        </div>
                        <div class="h-[370px] mt-[30px]" v-show="upgradeTask">
                            <terminal ref="terminalRef" :context="upgradeTask ? upgradeTask.upgrade.app_key : ''" :init-log="null" :show-header="false" :show-log-time="true" @exec-cmd="onExecCmd" />
                        </div>
                    </div>
                    <!-- 是否备份选择 -->
                    <div class="flex flex-col" v-show="active == 'backup'">
                        <el-scrollbar>
                            <div class="bg-[#fff] my-3">

                                <div class="px-[20px] pt-[10px] text-[14px] el-table">
                                    <el-row class="py-[10px] items table-head-bg pl-[15px] mb-[10px]">
                                        <el-col :span="20">
                                            <span>功能操作</span>
                                        </el-col>
                                        <el-col :span="4">
                                            <span>状态</span>
                                        </el-col>
                                    </el-row>
                                    <el-row class="pb-[10px] items pl-[15px]" v-for="item in excludeSteps">
                                        <el-col :span="20">
                                            <span>{{ item.name }}</span>
                                        </el-col>
                                        <el-col :span="4">
                                            <span>
                                                <el-icon color="green">
                                                    <Select />
                                                </el-icon>
                                            </span>
                                        </el-col>
                                    </el-row>
                                </div>
                            </div>
                        </el-scrollbar>
                    </div>
                    <div class="mt-[50px]" v-show="active == 'complete'">
                        <el-result icon="success" :title="t('upgrade.upgradeSuccess')"></el-result>
                        <el-alert :title="t('upgrade.upgradeCompleteTips')" type="error" :closable="false" v-show="upgradeTask && upgradeTask.executed && !upgradeTask.executed.includes('cloudBuild')"/>
                    </div>
                </div>
            </div>
        </template>
        <template #footer>
            <div class="dialog-footer">
                <!-- 查看升级内容 -->
                <el-button v-if="step == 1 && upgradeContent.version_list.length" @click="step = 2" type="primary">{{ t("upgrade.upgradeButton") }}</el-button>

                <template v-if="step == 2">
                <!--                <el-button v-if="active == 'content'" @click="showDialog = false">{{ t("return") }}</el-button>-->
                    <el-button type="primary" :disabled="!is_pass" v-if="active == 'upgrade' && !upgradeTask" @click="() => { active = 'backup'; numberOfSteps = 1 }">{{ t("nextStep") }}</el-button>
                    <el-button v-if="active == 'backup'" @click="() => { active = 'upgrade'; numberOfSteps = 1 } ">{{ t("prev") }}</el-button>
                    <el-button type="primary" v-if="active == 'backup'" :loading="uploading" @click="() => { upgradeAddonFn() }">{{ t("nextStep") }}</el-button>
                    <el-button v-if="active == 'complete'" @click="showDialog = false">{{ t("complete") }}</el-button>
                </template>
            </div>
        </template>
    </el-dialog>

    <el-dialog v-model="upgradeTipsShowDialog" :title="t('warning')" width="500px" draggable>
        <span v-html="t('upgrade.upgradeTips')"></span>
        <template #footer>
            <div class="flex justify-end">
                <el-button @click="upgradeTipsConfirm(true)" type="primary">{{ t("upgrade.knownToKnow") }}</el-button>
                <el-button @click="handleUpgrade()" type="primary" plain>{{ t("upgrade.upgradeButton") }}</el-button>
                <el-button @click="upgradeTipsShowDialog = false">{{ t("cancel") }}</el-button>
            </div>
        </template>
    </el-dialog>

    <el-dialog v-model="cloudBuildErrorTipsShowDialog" :title="t('warning')" width="500px" draggable :show-close="false">
        <span v-html="t('upgrade.cloudBuildErrorTips')"></span>
        <template #footer>
            <div class="flex justify-end">
                <el-button @click="cloudBuildError('local')" type="primary">{{ t("upgrade.localBuild") }}</el-button>
                <el-button @click="cloudBuildError('retry')" type="primary">{{ t("upgrade.cloudBuild") }}（{{ retrySecond }}S）</el-button>
                <el-button @click="cloudBuildError('rollback')" type="primary">{{ t("upgrade.rollback") }}</el-button>
            </div>
        </template>
    </el-dialog>
</template>

<script lang="ts" setup>
import { ref, h, watch } from "vue"
import { t } from "@/lang"
import { getVersions } from "@/app/api/auth"
import { getFrameworkNewVersion } from "@/app/api/module"
import {
    getUpgradeContent,
    getUpgradeTask,
    upgradeAddon,
    executeUpgrade,
    preUpgradeCheck,
    clearUpgradeTask, upgradeUserOperate
} from "@/app/api/upgrade"
import { Terminal, TerminalFlash } from "vue-web-terminal"
import "vue-web-terminal/lib/theme/dark.css"
import { AnyObject } from "@/types/global"
import { ElNotification, ElMessage, ElMessageBox } from "element-plus"
import Storage from "@/utils/storage"

const showDialog = ref<boolean>(false)
const upgradeContent = ref<null | AnyObject>(null)
const upgradeTask = ref<null | AnyObject>(null)
const active = ref('upgrade')
const step = ref(1)
const upgradeCheck = ref<null | AnyObject>(null)
const uploading = ref(false)
const terminalRef: any = ref(null)
const emits = defineEmits(["complete", "cloudbuild"])
const upgradeTipsShowDialog = ref<boolean>(false)
let upgradeLog: any = []
let errorLog: any = []
const cloudBuildErrorTipsShowDialog = ref<boolean>(false)
const retrySecond = ref(30)
let retrySecondInterval: any = null

// 升级步骤排除，backupCode 备份代码，backupSql 备份数据库
const excludeSteps: any = ref([
    {
        name: "备份源码",
        code: "backupCode"
    },
    {
        name: "备份数据库",
        code: "backupSql"
    }
])
/**
 * 查询升级任务
 */
const getUpgradeTaskFn = () => {
    getUpgradeTask().then(({ data }) => {
        if (!data) return

        if (!upgradeContent.value) upgradeContent.value = data.upgrade_content

        // 检测有没有正在进行中的升级任务
        if (!showDialog.value) {
            showElNotification()
            return
        }
        if (!upgradeTask.value) {
            terminalRef.value.execute("clear")
            terminalRef.value.execute("开始升级")
        }

        upgradeTask.value = data

        data.log.forEach((item) => {
            if (!upgradeLog.includes(item)) {
                terminalRef.value.pushMessage({ content: `${ item }` })
                upgradeLog.push(item)
            }
        })
        // 安装失败
        if (data.error) {
            data.error.forEach((item) => {
                if (!errorLog.includes(item)) {
                    terminalRef.value.pushMessage({ content: item, class: "error" })
                    errorLog.push(item)
                }
            })
        }
        // 恢复完毕
        if (data.step == "restoreComplete") {
            flashInterval && clearInterval(flashInterval)
            return
        }
        // 升级完成
        if (data.step == "upgradeComplete") {
            active.value = "complete"
            numberOfSteps.value = 4
            notificationEl && notificationEl.close()
            emits("complete")
            clearUpgradeTask()
            return
        }
        numberOfSteps.value = 2
        active.value = "upgrade"
        executeUpgradeFn()
    })
}

getUpgradeTaskFn()

const executeUpgradeFn = () => {
    executeUpgrade().then(() => {
        getUpgradeTaskFn()
    }).catch((err) => {
        if (err.message.indexOf('队列') != -1) {
            retrySecond.value = 30
            retrySecondInterval = setInterval(() => {
                retrySecond.value--
                if (retrySecond.value == 0) {
                    cloudBuildError('retry')
                }
            }, 1000)
            cloudBuildErrorTipsShowDialog.value = true
        } else {
            ElMessage({ message: err.message, type: 'error' })
        }
    })
}

let notificationEl: any = null
/**
 * 升级中任务提示
 */
const showElNotification = () => {
    notificationEl = ElNotification.success({
        title: t("warning"),
        dangerouslyUseHTMLString: true,
        message: h("div", {}, [t("upgrade.upgradingTips"), h("span", {
            class: "text-primary cursor-pointer",
            onClick: elNotificationClick
        }, [t("upgrade.clickView")])]),
        duration: 0,
        showClose: false
    })
}

const elNotificationClick = () => {
    showDialog.value = true
    getUpgradeTaskFn()
    active.value = "upgrade"
    notificationEl && notificationEl.close()
}

const frameworkVersion = ref("")
getVersions().then((res) => {
    frameworkVersion.value = res.data.version.version
})
const newFrameworkVersion = ref("")
getFrameworkNewVersion().then(({ data }) => {
    newFrameworkVersion.value = data.last_version
})

/**
 * 执行升级
 */
const is_pass = ref(false)
const repeat = ref(false)

const handleUpgrade = async() => {
    if (repeat.value) return
    repeat.value = true
    const appKey = upgradeContent.value?.app.app_key != "niucloud-admin" ? upgradeContent.value?.app.app_key : ""

    await preUpgradeCheck(appKey).then(async ({ data }) => {
        upgradeCheck.value = data
        is_pass.value = data.is_pass
        active.value = "upgrade"
        !upgradeTask.value ? (numberOfSteps.value = 0) : numberOfSteps.value
        upgradeTipsShowDialog.value = false
        showDialog.value = true
        repeat.value = false
    }).catch(() => {
        repeat.value = true
    })
}

const upgradeAddonFn = () => {
    if (!is_pass.value) return
    if (uploading.value) return
    uploading.value = true

    const appKey = upgradeContent.value?.app.app_key != "niucloud-admin" ? upgradeContent.value?.app.app_key : ""

    upgradeAddon(appKey).then(() => {
        getUpgradeTaskFn()
    }).catch(() => {
        uploading.value = false
    })
}

const open = (addonKey: string = "", callback = null) => {
    if (upgradeTask.value) {
        ElMessage({ message: "已有正在执行中的升级任务", type: "error" })
        showDialog.value = true
        if (callback) callback()
    } else {
        if (addonKey && frameworkVersion.value != newFrameworkVersion.value) {
            ElMessage({ message: "存在新版本框架，请先升级框架", type: "error" })
            if (callback) callback()
            return
        }
        getUpgradeContent(addonKey).then(({ data }) => {
            upgradeContent.value = data
            if (Storage.get("upgradeTipsLock")) {
                handleUpgrade()
            } else {
                upgradeTipsShowDialog.value = true
            }
            if (callback) callback()
        }).catch(() => {
            if (callback) callback()
        })
    }
}

/**
 * 升级进度动画
 */
let flashInterval: any = null
const terminalFlash = new TerminalFlash()
const onExecCmd = (key, command, success, failed, name) => {
    if (command == "开始升级") {
        success(terminalFlash)
        const frames = makeIterator(["/", "——", "\\", "|"])
        flashInterval = setInterval(() => {
            terminalFlash.flush("> " + frames.next().value)
        }, 150)
    }
}

const makeIterator = (array: string[]) => {
    var nextIndex = 0
    return {
        next() {
            if (nextIndex + 1 == array.length) {
                nextIndex = 0
            }
            return { value: array[nextIndex++] }
        }
    }
}

const dialogClose = (done: () => {}) => {
    if (active.value == "upgrade" && upgradeTask.value && ['upgradeComplete', 'restoreComplete'].includes(upgradeTask.value.step) === false) {
        ElMessageBox.confirm(t("upgrade.showDialogCloseTips"), t("warning"), {
            confirmButtonText: t("confirm"),
            cancelButtonText: t("cancel"),
            type: "warning"
        }).then(() => {
            done()
        })
    } else {
        done()
    }
}

watch(
    () => showDialog.value,
    () => {
        if (!showDialog.value) {
            clearUpgradeTaskFn()
        }
    }
)

const clearUpgradeTaskFn = () => {
    active.value = "upgrade"
    uploading.value = false
    upgradeTask.value = null
    upgradeLog = []
    errorLog = []
    numberOfSteps.value = 0
    flashInterval && clearInterval(flashInterval)
    retrySecondInterval && clearInterval(retrySecondInterval)
    clearUpgradeTask().then(() => {
    })
}

/**
 * 云编译队列不足操作
 * @param event
 */
const cloudBuildError = (event: string) => {
    cloudBuildErrorTipsShowDialog.value = false
    switch (event) {
        case "local":
            upgradeUserOperate(event).then(() => {
                getUpgradeTaskFn()
            })
            break
        case "retry":
            executeUpgradeFn()
            retrySecondInterval && clearInterval(retrySecondInterval)
            break
        case "rollback":
            upgradeUserOperate(event).then(() => {
                getUpgradeTaskFn()
            })
            break
    }
}

const timeSplit = (str: string) => {
    const [date, time] = str.split(" ")
    const [hours, minutes] = time.split(":")
    return [date, `${ hours }:${ minutes }`]
}

const upgradeTipsConfirm = (isLock: boolean = false) => {
    isLock && Storage.set({ key: "upgradeTipsLock", data: isLock })
    upgradeTipsShowDialog.value = false
    !isLock && (showDialog.value = true)
}
const activeName = ref(0)
const numberOfSteps = ref(0)
defineExpose({
    open
})
</script>

<style lang="scss" scoped>
.table-head-bg {
    background-color: var(--el-table-header-bg-color);
}

:deep(.terminal .t-log-box span) {
    white-space: pre-wrap;
}

::v-deep .number-of-steps {
    .el-step__line {
        margin: 0 25px;
        background: #dddddd;
    }

    .el-step__head {
        margin-top: 10px;
    }

    .is-success {
        color: var(--el-color-primary);
        border-color: var(--el-color-primary);

        .el-step__icon {
            background: var(--el-color-primary);

            box-shadow: 0 0 0 4px var(--el-color-primary-light-9);

            i {
                color: #fff;
            }
        }

        .el-step__line {
            margin: 0 25px;
            background: var(--el-color-primary);
        }
    }

    .is-process {
        color: var(--el-color-primary);
        font-weight: inherit;

        // font-size: 18px;
        .el-step__icon {
            padding: 10px;
            border: 1px solid var(--el-color-primary);
            box-shadow: 0 0 0 4px var(--el-color-primary-light-9);
        }
    }

    .is-wait {
        color: #333;
    }
}
</style>

<style scoped>
.el-timeline-item {
    min-height: 100px;
}

.el-timeline-item >>> .el-timeline-item__node--normal {
    left: 117px;
    width: 18px;
    height: 18px;

    background: rgba(25, 103, 249, 0.12) !important;
    border-radius: 50%;
    /* 创建圆形 */
    position: relative;
    /* 用于定位伪元素 */
}

.el-timeline-item >>> .el-timeline-item__node--normal::before {
    content: "";
    position: absolute;
    top: 50%;
    left: 50%;
    width: 8px;
    /* 中心圆直径 */
    height: 8px;
    background-color: var(--el-color-primary);
    /* 中心圆颜色 */
    border-radius: 50%;
    /* 中心圆为圆形 */
    transform: translate(-50%, -50%);
    /* 居中显示 */
}

.el-timeline-item >>> .el-timeline-item__tail {
    left: 125px;
    border-left-color: #dddddd;
    border-left-style: dashed;
    margin: 12px 0;
    margin-top: 24px;
    height: calc(100% - 24px - 12px);
}

.time-dialog-wrap >>> .el-dialog__header {
    padding: 10px 20px;
    height: 25px;
    line-height: 25px;
    text-align: left;
    background: #fff;
    border-bottom: solid 1px #e4e7ed;
}

.time-dialog-wrap >>> .el-card__body {
    padding: 8px;
}

.time-dialog-wrap >>> .el-card.is-always-shadow {
    box-shadow: none;
}

.time-dialog-wrap >>> .el-dialog__headerbtn .el-dialog__close {
    color: #666;
}

.time-dialog-wrap >>> .el-dialog__headerbtn:hover .el-dialog__close {
    color: #666;
}

.time-dialog-wrap >>> .el-dialog__headerbtn {
    top: 14px;
}

.time-dialog-wrap >>> .el-collapse {
    margin-left: 119px;
    border: none;
    margin-top: -22px;
}

.time-dialog-wrap >>> .el-collapse-item__header {
    border: none;
    line-height: 25px;
    height: 25px;
    position: relative;
    z-index: 999;
}

.time-dialog-wrap >>> .el-collapse-item__wrap {
    border: none;
}

.time-dialog-wrap >>> .el-collapse-item__content {
    margin-top: 15px;
    padding-bottom: 0 !important;
}

.time-dialog-wrap >>> .el-timeline-item__node--01 {
    width: 18px !important;
    height: 18px !important;
    left: 117px !important;
}
</style>
<style>
.time-dialog-wrap .el-dialog {
    margin: 0 auto !important;
    max-height: 90%;
    overflow: hidden;
    top: 5%;
}

.time-dialog-wrap .el-dialog {
    margin: 0 auto !important;
    height: 65%;
    overflow: hidden;
    top: 10%;
}

.time-dialog-wrap .el-dialog__body {
    position: absolute;
    left: 0;
    top: 46px;
    bottom: 0px;
    right: 0;
    z-index: 1;
    overflow: hidden;
    overflow-y: auto;
    padding: 10px 20px 0 0;
}

.time-dialog-wrap .el-timeline-item__wrapper {
    top: -20px !important;
}
</style>
