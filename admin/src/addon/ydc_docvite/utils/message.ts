import { ElMessage, ElNotification } from "element-plus";

const showSuccessMsg = (msg: string, duration: number = 2000) => {
  ElMessage.success({ message: msg, duration: duration });
};
const showWarningMsg = (msg: string, duration: number = 2000) => {
  ElMessage.warning({ message: msg, duration: duration });
};
const showErrorMsg = (msg: string, duration: number = 2000) => {
  ElMessage.error({ message: msg, duration: duration });
};
const showInfoMsg = (msg: string, duration: number = 2000) => {
  ElMessage.info({ message: msg, duration: duration });
};

const showSuccessNotify = (msg: string, duration: number = 2000) => {
  ElNotification.success({ message: msg, duration: duration });
};
const showWarningNotify = (msg: string, duration: number = 2000) => {
  ElNotification.warning({ message: msg, duration: duration });
};
const showErrorNotify = (msg: string, duration: number = 2000) => {
  ElNotification.error({ message: msg, duration: duration });
};
const showInfoNotify = (msg: string, duration: number = 2000) => {
  ElNotification.info({ message: msg, duration: duration });
};

export { showSuccessMsg, showErrorMsg, showWarningMsg, showInfoMsg };
export {
  showSuccessNotify,
  showWarningNotify,
  showErrorNotify,
  showInfoNotify,
};
