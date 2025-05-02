<template>
  <div class="main-container p-4">
    <el-card>
      <el-descriptions title="构建工具使用说明">
        <el-descriptions-item label="同步内容"
          >此操作步骤会初始化打包环境、合并文件</el-descriptions-item
        >
        <el-descriptions-item label="安装依赖"
          >执行npm install</el-descriptions-item
        >
        <el-descriptions-item label="打包操作"
          >打包操作会自动完成打包、修改配置、移动文件到对应目录</el-descriptions-item
        >
        <el-descriptions-item label="自定义命令">
          选择对应目录可便捷执行，npm、composer命令(环境需要安装正确)
        </el-descriptions-item>
        <el-descriptions-item label="温馨提示">
          使用构建工具必须确保您的环境：npm -v 能返回版本号
        </el-descriptions-item>
        <el-descriptions-item label="文件权限">
          为保证程序能正常运行，设置站点所有文件权限为755，所有者为www
        </el-descriptions-item>
        <el-descriptions-item label="一键打包">
          一键打包需要配合队列功能，请先开启队列，请勿重复执行，尽量在服务器空闲执行
        </el-descriptions-item>
      </el-descriptions>
    </el-card>
    <div class="flex items-center mt-6">
      <el-button class="" type="primary" @click="asyncBuild()"
        >一键打包</el-button
      >
      <el-button v-if="isbuilding == true">
        正在执行编译任务，预计3-5分钟完成
        <span class="ml-8 relative flex h-3 w-3 mb">
          <span
            class="animate-ping absolute inline-flex h-full w-full rounded-full bg-sky-400 opacity-75"
          ></span>
          <span
            class="relative inline-flex rounded-full h-3 w-3 bg-sky-400"
          ></span>
        </span>
      </el-button>
    </div>

    <el-card
      v-loading="loading"
      element-loading-text="执行中,请稍后..."
      class="box-card !border-none mt-6"
      shadow="never"
    >
      <el-tabs v-model="value" @tab-click="handleClick">
        <el-tab-pane label="后端构建" name="admin" class="flex">
          <el-card class="d-card mr-4" @click="asyncAdmin">
            <el-icon size="35" color="#ffffff" class="no-inherit mr-2">
              <Switch />
            </el-icon>
            <div class="pt-2">1、同步内容</div>
          </el-card>

          <el-card class="d-card mr-4" @click="installadmin">
            <el-icon size="35" color="#ffffff" class="no-inherit mr-2">
              <Download />
            </el-icon>
            <div class="pt-2">2、安装依赖</div>
          </el-card>

          <el-card class="d-card" @click="buildadmin">
            <el-icon size="35" color="#ffffff" class="no-inherit mr-2">
              <Sort />
            </el-icon>
            <div class="pt-2">3、打包后端</div>
          </el-card>
        </el-tab-pane>
        <el-tab-pane label="前端构建" name="uni-app-cli" class="flex">
          <el-card class="d-card mr-4" @click="asyncUniapp">
            <el-icon size="35" color="#ffffff" class="no-inherit mr-2">
              <Switch />
            </el-icon>
            <div class="pt-2">1、同步内容</div>
          </el-card>

          <el-card class="d-card mr-4" @click="installUniapp">
            <el-icon size="35" color="#ffffff" class="no-inherit mr-2">
              <Download />
            </el-icon>
            <div class="pt-2">2、安装依赖</div>
          </el-card>

          <el-card class="d-card mr-4" @click="buildH5">
            <el-icon size="35" color="#ffffff" class="no-inherit mr-2">
              <Sort />
            </el-icon>
            <div class="pt-2">3、编译H5</div>
          </el-card>
          <!-- <el-card class="d-card" @click="buildMpWeixin">
            <el-icon size="35" color="#ffffff" class="no-inherit mr-2">
              <PartlyCloudy />
            </el-icon>
            <div class="pt-2">4、编译小程序</div>
          </el-card> -->
        </el-tab-pane>
        <el-tab-pane label="自定义命令" name="other">
          <el-card style="width: 720px">
            <div style="font-size: medium; margin-bottom: 12px">
              自定义命令操作
            </div>
            <div>
              <el-radio v-model="data.path" label="admin">admin目录</el-radio>
              <el-radio v-model="data.path" label="uni-app"
                >uni-app目录</el-radio
              >
              <el-radio v-model="data.path" label="niucloud"
                >niucloud目录</el-radio
              >
              <el-col :span="14" class="mt-4 mb-4 flex">
                <el-input
                  v-model="data.cmd"
                  placeholder="请输入命令"
                ></el-input>
              </el-col>

              <el-button type="primary" @click="docmd()">确认操作</el-button>
            </div>
          </el-card>
        </el-tab-pane>
      </el-tabs>
    </el-card>
    <el-card class="ml-5" style="width: 720px">
      <el-descriptions column="1" title="命令参考">
        <el-descriptions-item label="npm install"
          >安装依赖，admin和uni-app目录可用</el-descriptions-item
        >
        <el-descriptions-item label="npm run build"
          >打包后端,admin目录可用</el-descriptions-item
        >
        <el-descriptions-item label="npm run build:h5"
          >打包H5,uni-app目录可用</el-descriptions-item
        >
        <el-descriptions-item label="npm run build:mp-weixin"
          >打包微信小程序,uni-app目录可用</el-descriptions-item
        >
        <el-descriptions-item label="composer install"
          >安装后端站点依赖,composer目录可用</el-descriptions-item
        >
        <el-descriptions-item label="说明"
          >1、只列举常用命令,如需更多自定义请在代码后台放行；2、需便捷构建前端按照对应顺序执行即可，如遇报错请按照报错排查；3、构建一般在所有插件都安装完成后再执行，没必要安装一个插件执行一次
          4、请确保站点有完整的admin,uni-app,niucloud目录
        </el-descriptions-item>
      </el-descriptions>
    </el-card>
  </div>
</template>

<script lang="ts" setup>
import {
  doExecute,
  doasyncadmin,
  moveFile,
  asyncBuild,
  checkBuild,
} from "@/addon/tk_devtool/api/tkdevtool";
import { reactive, ref, onMounted, onUnmounted } from "vue";
let timer: NodeJS.Timeout | null = null;
const startTimer = () => {
  timer = setInterval(() => {
    checkBuildEvent();
  }, 1000);
};
const stopTimer = () => {
  if (timer) {
    clearInterval(timer);
    timer = null;
  }
};

onMounted(() => {
  startTimer();
});

onUnmounted(() => {
  stopTimer();
});
const isbuilding = ref(false);
const checkBuildEvent = async () => {
  const res = await (await checkBuild()).data;
  console.log(res);
  if (res.code == 0) {
    isbuilding.value = true;
  } else {
    isbuilding.value = false;
    stopTimer();
  }
};
const data = reactive({
  path: "admin",
  cmd: "npm run build",
});
const value = ref("admin");
const loading = ref(false);
const docmd = () => {
  sendExecute();
};
const asyncAdmin = async () => {
  loading.value = true;
  const res = await doasyncadmin({});
  if (res.code == 1) {
    loading.value = false;
    isbuilding.value = true;
    startTimer();
  }
};
const buildadmin = () => {
  data.path = "admin";
  data.cmd = "npm run build";
  sendExecute();
};
const installadmin = () => {
  data.path = "admin";
  data.cmd = "npm install";
  sendExecute();
};
const installUniapp = () => {
  data.path = "uni-app";
  data.cmd = "npm install";
  sendExecute();
};
const buildH5 = () => {
  data.path = "uni-app";
  data.cmd = "npm run build:h5";
  sendExecute();
};
const buildMpWeixin = () => {
  data.path = "uni-app";
  data.cmd = "npm run build:mp-weixin";
  sendExecute();
};
const asyncUniapp = async () => {
  loading.value = true;
  const res = await moveFile({});
  if (res.code == 1) {
    loading.value = false;
  }
};
const sendExecute = async () => {
  loading.value = true;
  const res = await doExecute(data);
  if (res.code == 1) {
    loading.value = false;
  }
};
</script>

<style lang="scss" scoped>
.d-card {
  margin-top: 12px;
  width: 180px;
  text-align: center;
  background: linear-gradient(127deg, #273de3, #273de3 70.71%);
  color: aliceblue;
  backdrop-filter: blur(10px);
  font-size: 18px;
  border-radius: 18px;
}
</style>
