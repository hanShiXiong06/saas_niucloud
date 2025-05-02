import { defineAsyncComponent } from "vue";

// 注册应用使用的DIY组件
export default {
  // 骑手入口组件
  RiderTechnician: defineAsyncComponent(
    () => import("./diy/rider-technician/index.vue")
  ),
  // 其他组件...
};
