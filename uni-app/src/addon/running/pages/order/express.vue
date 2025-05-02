<template>
  <view class="flex flex-col h-full bg-gray-50" :style="themeColor()">
    <!-- 顶部背景渐变 -->
    <view
      class=" h-52 bg-gradient-to-br from-blue-600 via-blue-500 to-blue-400 absolute top-0 left-0 rounded-b-[40px] shadow-lg backdrop-blur-lg">
      <view class="absolute inset-0 bg-white/10 backdrop-blur-sm"></view>
      <view class="absolute -bottom-6 left-1/2 transform -translate-x-1/2 w-32 h-1 bg-white/20 rounded-full blur-xl">
      </view>
    </view>

    <!-- 主内容区 -->
    <view class="flex-1 px-5 pt-8 pb-24 relative z-10">
      <!-- 学校选择 -->
      <!-- #ifdef H5 -->
      <view
        class="bg-white/90 backdrop-blur-md  rounded-2xl shadow-lg mb-5 p-5 transform transition-all duration-300 active:scale-98 border border-white/20">
        <view class="flex items-center">
          <text class="nc-iconfont nc-icon-dizhiguanliV6xx ml-2 text-gray-800"></text>
          <picker :value="schoolIndex" :range="schoolList" range-key="name" @change="onSchoolChange" class="flex-1">
            <view class="flex items-center justify-between">
              <text class="text-blue-600 ml-2 font-medium">{{ currentSchool.name || '请选择学校' }}</text>
            </view>
          </picker>
        </view>
      </view>
      <!-- #endif -->
      <!-- #ifndef H5 -->
      <view
        class="bg-white/90 backdrop-blur-md w-[426rpx] sticky top-11 z-99 rounded-2xl shadow-lg mb-5 p-2 transform transition-all duration-300 active:scale-98 border border-white/20">
        <view class="flex items-center">
          <text class="nc-iconfont nc-icon-dizhiguanliV6xx ml-2 text-gray-800"></text>
          <picker :value="schoolIndex" :range="schoolList" range-key="name" @change="onSchoolChange" class="flex-1">
            <view class="flex items-center justify-between">
              <text class="text-blue-600 ml-2 font-medium">{{ currentSchool.name || '请选择学校' }}</text>
            </view>
          </picker>
        </view>
      </view>
      <!-- #endif -->

      <!-- 温馨提示 -->
      <view class="relative overflow-hidden bg-blue-50 dark:bg-blue-900 rounded-xl p-4 mb-5">
        <!-- 背景装饰 -->
        <view
          class="absolute right-0 top-0 -mt-4 -mr-4 w-24 h-24 bg-blue-100 dark:bg-blue-800 rounded-full opacity-50 transform rotate-45">
        </view>
        <view
          class="absolute left-0 bottom-0 -ml-4 -mb-4 w-16 h-16 bg-blue-100 dark:bg-blue-800 rounded-full opacity-50">
        </view>

        <!-- 内容区域 -->
        <view class="relative flex items-start space-x-4 z-10">
          <!-- 图标 -->
          <view
            class="flex-shrink-0 w-12 h-12 bg-blue-100 dark:bg-blue-800 rounded-full flex items-center justify-center">

          </view>

          <!-- 文本内容 -->
          <view class="flex-1">
            <text class="block text-base font-medium text-blue-900 dark:text-blue-100 mb-1">温馨提示</text>
            <text class="text-blue-700 dark:text-blue-200 text-sm leading-relaxed">
              如遇到订单问题，请联系客服。配送时间6:00-22:30，请合理安排下单时间。
            </text>
          </view>

          <!-- 关闭按钮 -->
          <view class="flex-shrink-0 self-start">
            <view
              class="w-6 h-6 rounded-full hover:bg-blue-100 dark:hover:bg-blue-800 flex items-center justify-center cursor-pointer transition-colors">

            </view>
          </view>
        </view>

        <!-- 进度条动画 -->
        <view class="absolute bottom-0 left-0  h-1 bg-blue-100 dark:bg-blue-800">
          <view class="h-full bg-blue-500 dark:bg-blue-400 animate-progress"></view>
        </view>
      </view>

      <!-- 业务类型 -->
      <view class="bg-white/90 backdrop-blur-md rounded-2xl shadow-lg mb-5 overflow-hidden border border-white/20">
        <view class="flex">
          <view v-for="(tab, index) in businessTabs" :key="index"
            class="flex-1 py-4 text-center relative transition-all duration-300 group"
            :class="currentTab === index ? 'tab_active' : ''" @click="onTabChange(index)">
            <text class="iconfont text-lg transform transition-all group-hover:scale-110"
              :class="tab.icon + ' mr-2'"></text>
            <text class="font-medium">{{ tab.name }}</text>
            <view v-if="currentTab === index"
              class="absolute bottom-0 left-1/4 w-1/2 h-0.5 bg-blue-600 rounded-full shadow-sm"></view>
          </view>
        </view>
      </view>

      <!-- 快递代取表单 -->
      <block v-if="currentTab === 0">
        <!-- 收货信息 -->
        <view class="bg-white/90 backdrop-blur-md rounded-2xl shadow-lg mb-5 p-5 border border-white/20">
          <view class="flex items-center pb-4 mb-4 border-b border-gray-100">
            <text
              class="iconfont icon-location text-blue-600 text-xl mr-3 transform transition-all group-hover:scale-110"></text>
            <text class="font-semibold text-gray-800">收货信息</text>
          </view>

          <view class="space-y-4">
            <view class="group flex items-center">
              <text
                class="text-gray-600 w-[140rpx] whitespace-nowrap overflow-hidden text-ellipsis  mb-2 block text-sm font-medium group-hover:text-blue-600 transition-colors">送达楼栋</text>
              <picker class="ml-2  flex-1" mode="multiSelector" :value="[buildingFirstIndex, buildingSecondIndex]"
                :range="buildingArray" range-key="name" @change="onBuildingChange"
                @columnchange="onBuildingColumnChange">
                <!-- 文本不换行 -->
                <view
                  class="flex items-center  justify-between p-3 bg-gray-50/80 rounded-xl border border-gray-200 active:bg-gray-100 transition-all group-hover:border-blue-300">
                  <text class="text-gray-700 whitespace-nowrap overflow-hidden text-ellipsis">{{ selectedBuildingText
                  }}</text>
                  <text
                    class="iconfont icon-right text-gray-400 transform transition-transform group-hover:translate-x-1"></text>
                </view>
              </picker>
            </view>

            <view class="group flex items-center">
              <text
                class="text-gray-600 w-[140rpx] mb-2 block text-sm font-medium group-hover:text-blue-600 transition-colors">房间号</text>
              <input v-model="orderForm.room_number"
                class="ml-2 flex-1 p-3 bg-gray-50/80 rounded-xl  border border-gray-200 focus:border-blue-500 transition-all group-hover:border-blue-300 focus:ring-2 focus:ring-blue-200"
                placeholder="如：101" />
            </view>

            <view class="group flex items-center">
              <text
                class="text-gray-600 w-[140rpx]  mb-2 block text-sm font-medium group-hover:text-blue-600 transition-colors">收件人</text>
              <input v-model="orderForm.receiver_name"
                class="ml-2 flex-1  p-3 bg-gray-50/80 rounded-xl  border border-gray-200 focus:border-blue-500 transition-all group-hover:border-blue-300 focus:ring-2 focus:ring-blue-200"
                placeholder="请输入姓名" />
            </view>

            <view class="group flex items-center">
              <text
                class="text-gray-600 w-[140rpx]  mb-2 block text-sm font-medium group-hover:text-blue-600 transition-colors">联系电话</text>
              <input v-model="orderForm.receiver_phone"
                class="ml-2 flex-1 p-3 bg-gray-50/80 rounded-xl  border border-gray-200 focus:border-blue-500 transition-all group-hover:border-blue-300 focus:ring-2 focus:ring-blue-200"
                placeholder="请输入联系电话" type="number" maxlength="11" />
            </view>
          </view>
        </view>

        <!-- 快递列表 -->
        <view class="bg-white/90 backdrop-blur-md rounded-2xl shadow-lg mb-5 p-5 border border-white/20">
          <view class="flex items-center justify-between pb-4 mb-4 border-b border-gray-100">
            <view class="flex items-center">
              <text
                class="nc-iconfont nc-icon-daifahuoV6xx text-xl mr-3 transform transition-all group-hover:scale-110"></text>
              <text class="font-semibold text-gray-800">快递信息</text>
            </view>
            <view @click="showExpressForm"
              class="flex items-center bg-blue-50/80 text-blue-600 px-4 py-2 rounded-full active:bg-blue-100 transition-all hover:shadow-md hover:-translate-y-0.5">
              <text class="nc-iconfont nc-icon-jiahaoV6xx mr-2"></text>
              <text class="text-sm font-medium">添加快递</text>
            </view>
          </view>

          <view v-if="expressItems.length === 0" class="py-8 flex flex-col items-center">
            <text class="nc-iconfont nc-icon-youjianV6mm text-4xl text-gray-300 mb-3 animate-bounce"></text>
            <text class="text-gray-400">暂无快递信息，请添加</text>
          </view>

          <!-- 快递列表 -->
          <view v-for="(item, index) in expressItems" :key="index"
            class="mb-4 last:mb-0 bg-gray-50/80 rounded-xl p-4 border border-gray-100 transition-all hover:shadow-md hover:-translate-y-0.5 group">
            <view class="flex justify-between items-start mb-3">
              <view class="flex items-center">
                <text class="text-blue-600 font-semibold group-hover:text-blue-700">{{ item.express_name }}</text>
                <text class="ml-2 px-3 py-1 bg-blue-100/80 text-blue-700 rounded-full text-xs font-medium">
                  {{ item.name }}
                </text>
              </view>
              <view class="flex space-x-2">
                <view class="p-2 hover:bg-gray-200/80 rounded-full transition-all hover:shadow-sm"
                  @click="editExpressItem(index)">
                  <text class="nc-iconfont nc-icon-bianjiV6xx1 text-gray-600"></text>
                </view>
                <view class="p-2 hover:bg-red-100/80 rounded-full transition-all hover:shadow-sm"
                  @click="deleteExpressItem(index)">
                  <text
                    class="nc-iconfont nc-icon-shanchu-yuangaizhiV6xx text-gray-600 group-hover:text-red-500"></text>
                </view>
              </view>
            </view>
            <view class="mb-2">
              <text class="text-gray-500">取件码：</text>
              <text class="text-xl font-semibold text-gray-800 group-hover:text-blue-600">{{ item.code }}</text>
            </view>
            <view class="flex justify-between items-center">
              <text class="text-gray-500">配送费</text>
              <text class="text-red-500 font-medium text-lg group-hover:text-red-600">¥{{ item.price }}</text>
            </view>
          </view>
        </view>
      </block>

      <!-- 跑腿服务表单 -->
      <block v-else>
        <!-- 取货信息（手风琴） -->
        <view
          class="bg-white/90 backdrop-blur-md rounded-2xl shadow-lg mb-3 overflow-hidden border border-white/20 transition-all duration-300"
          :class="{ 'shadow-xl': activeAccordion === 'pickup' }">
          <view class="flex items-center p-5 cursor-pointer transition-all duration-300"
            :class="{ 'bg-blue-50/80': activeAccordion === 'pickup' }" @click="toggleAccordion('pickup')">
            <text class="iconfont icon-takeaway text-xl mr-3"
              :class="activeAccordion === 'pickup' ? 'text-blue-600' : 'text-gray-600'"></text>
            <text class="font-semibold"
              :class="activeAccordion === 'pickup' ? 'text-blue-600' : 'text-gray-800'">取货信息</text>
            <text class="iconfont icon-right ml-auto transition-transform duration-300" :class="[
              activeAccordion === 'pickup' ? 'rotate-90 text-blue-600' : 'text-gray-400',
              'transform'
            ]"></text>
            <u-icon name="arrow-right" color="#2979ff" size="28" v-if="activeAccordion === 'pickup'"></u-icon>
            <u-icon name="arrow-down" color="#2979ff" size="28" v-else></u-icon>
          </view>

          <view class="overflow-hidden transition-all duration-300"
            :class="activeAccordion === 'pickup' ? 'max-h-[500px] opacity-100' : 'max-h-0 opacity-0'">
            <view class="p-5 pt-0 space-y-4">
              <view class="group">
                <text
                  class="text-gray-600 mb-2 block text-sm font-medium group-hover:text-blue-600 transition-colors">取货地址</text>
                <input v-model="orderForm.pickup_address"
                  class="p-3 bg-gray-50/80 rounded-xl  border border-gray-200 focus:border-blue-500 transition-all group-hover:border-blue-300 focus:ring-2 focus:ring-blue-200"
                  placeholder="请输入详细地址" />
              </view>

              <view class="group">
                <text
                  class="text-gray-600 mb-2 block text-sm font-medium group-hover:text-blue-600 transition-colors">联系人</text>
                <input v-model="orderForm.pickup_name"
                  class="p-3 bg-gray-50/80 rounded-xl  border border-gray-200 focus:border-blue-500 transition-all group-hover:border-blue-300 focus:ring-2 focus:ring-blue-200"
                  placeholder="请输入姓名" />
              </view>

              <view class="group">
                <text
                  class="text-gray-600 mb-2 block text-sm font-medium group-hover:text-blue-600 transition-colors">联系电话</text>
                <input v-model="orderForm.pickup_phone"
                  class="p-3 bg-gray-50/80 rounded-xl  border border-gray-200 focus:border-blue-500 transition-all group-hover:border-blue-300 focus:ring-2 focus:ring-blue-200"
                  placeholder="请输入联系电话" type="number" maxlength="11" />
              </view>
            </view>
          </view>
        </view>

        <!-- 收货信息（手风琴） -->
        <view
          class="bg-white/90 backdrop-blur-md rounded-2xl shadow-lg mb-5 overflow-hidden border border-white/20 transition-all duration-300"
          :class="{ 'shadow-xl': activeAccordion === 'delivery' }">
          <view class="flex items-center p-5 cursor-pointer transition-all duration-300"
            :class="{ 'bg-blue-50/80': activeAccordion === 'delivery' }" @click="toggleAccordion('delivery')">
            <text class="iconfont icon-location text-xl mr-3"
              :class="activeAccordion === 'delivery' ? 'text-blue-600' : 'text-gray-600'"></text>
            <text class="font-semibold"
              :class="activeAccordion === 'delivery' ? 'text-blue-600' : 'text-gray-800'">收货信息</text>
            <text class="iconfont icon-right ml-auto transition-transform duration-300" :class="[
              activeAccordion === 'delivery' ? 'rotate-90 text-blue-600' : 'text-gray-400',
              'transform'
            ]"></text>
            <u-icon name="arrow-right" color="#2979ff" size="28" v-if="activeAccordion === 'delivery'"></u-icon>
            <u-icon name="arrow-down" color="#2979ff" size="28" v-else></u-icon>

          </view>

          <view class="overflow-hidden transition-all duration-300"
            :class="activeAccordion === 'delivery' ? 'max-h-[500px] opacity-100' : 'max-h-0 opacity-0'">
            <view class="p-5 pt-0 space-y-4">
              <view class="group">
                <text
                  class="text-gray-600 mb-2 block text-sm font-medium group-hover:text-blue-600 transition-colors">送达楼栋</text>
                <picker mode="multiSelector" :value="[buildingFirstIndex, buildingSecondIndex]" :range="buildingArray"
                  range-key="name" @change="onBuildingChange" @columnchange="onBuildingColumnChange">
                  <view
                    class="flex items-center justify-between p-3 bg-gray-50/80 rounded-xl border border-gray-200 active:bg-gray-100 transition-all group-hover:border-blue-300">
                    <text class="text-gray-700">{{ selectedBuildingText }}</text>
                    <text
                      class="iconfont icon-right text-gray-400 transform transition-transform group-hover:translate-x-1"></text>
                  </view>
                </picker>
              </view>

              <view class="group">
                <text
                  class="text-gray-600 mb-2 block text-sm font-medium group-hover:text-blue-600 transition-colors">房间号</text>
                <input v-model="orderForm.delivery_address"
                  class="p-3 bg-gray-50/80 rounded-xl  border border-gray-200 focus:border-blue-500 transition-all group-hover:border-blue-300 focus:ring-2 focus:ring-blue-200"
                  placeholder="请输入详细地址" />
              </view>

              <view class="group">
                <text
                  class="text-gray-600 mb-2 block text-sm font-medium group-hover:text-blue-600 transition-colors">收件人</text>
                <input v-model="orderForm.receiver_name"
                  class="p-3 bg-gray-50/80 rounded-xl  border border-gray-200 focus:border-blue-500 transition-all group-hover:border-blue-300 focus:ring-2 focus:ring-blue-200"
                  placeholder="请输入姓名" />
              </view>

              <view class="group">
                <text
                  class="text-gray-600 mb-2 block text-sm font-medium group-hover:text-blue-600 transition-colors">联系电话</text>
                <input v-model="orderForm.receiver_phone"
                  class="p-3 bg-gray-50/80 rounded-xl  border border-gray-200 focus:border-blue-500 transition-all group-hover:border-blue-300 focus:ring-2 focus:ring-blue-200"
                  placeholder="请输入联系电话" type="number" maxlength="11" />
              </view>
            </view>
          </view>
        </view>
      </block>

      <!-- 服务列表 -->
      <view class="bg-white rounded-2xl shadow-md mb-5 p-5" v-if="currentTab === 1">
        <view class="flex items-center pb-4 mb-4 border-b border-gray-100">
          <text class="nc-iconfont nc-icon-kefuV6xx text-blue-600 text-xl mr-3"></text>
          <text class="font-semibold text-gray-800">服务类型</text>
        </view>

        <view v-if="filteredServices.length === 0" class="py-8 flex flex-col items-center">
          <text class="iconfont icon-empty text-gray-300 text-4xl mb-2"></text>
          <text class="text-gray-400">暂无可用服务</text>
        </view>

        <view v-else>
          <view v-for="(service, index) in filteredServices" :key="index" class="mb-4 last:mb-0 p-4 rounded-xl border"
            :class="[
              selectedService && selectedService.id === service.id
                ? 'border-blue-500 bg-blue-50'
                : 'border-gray-100 bg-white'
            ]" @click="selectService(service)">
            <view class="flex justify-between items-center mb-2">
              <text class="font-medium">{{ service.name }}</text>
              <text class="text-red-500">¥{{ service.price }}</text>
            </view>
            <view class="flex justify-between items-center">
              <text class="text-gray-500 text-sm">{{ service.description || '暂无描述' }}</text>
              <view v-if="currentTab === 1" class="flex items-center">
                <view class="w-6 h-6 flex items-center justify-center bg-gray-200 rounded-full"
                  @click.stop="updateQuantity(service, -1)">
                  <text class="nc-iconfont nc-icon-jianV6xx"></text>
                </view>
                <text class="mx-2">{{ service.quantity || 1 }}</text>
                <view class="w-6 h-6 flex items-center justify-center bg-blue-500 rounded-full"
                  @click.stop="updateQuantity(service, 1)">
                  <text class="nc-iconfont nc-icon-jiahaoV6xx"></text>
                </view>
              </view>
            </view>
          </view>
        </view>
      </view>
    </view>

    <!-- 底部提交栏 -->
    <view
      class="fixed bottom-[168rpx] left-0 right-0 bg-white/90 backdrop-blur-md border-t border-gray-200 p-3 flex items-center justify-between shadow-xl z-20">
      <view class="flex items-baseline">
        <text class="text-gray-500 mr-1">合计:</text>
        <text class="text-2xl font-bold bg-gradient-to-r from-red-500 to-red-600 bg-clip-text text-transparent">¥{{
          calculateTotal() }}</text>
      </view>
      <view
        class="py-2.5 px-8 bg-gradient-to-r from-blue-500 to-blue-600 rounded-full text-white font-medium shadow-lg active:shadow-md transition-all hover:-translate-y-0.5 active:translate-y-0"
        :class="{ 'opacity-50': payLoading }" @click="submitOrder">
        <text>{{ payLoading ? '提交中...' : '提交订单' }}</text>
      </view>
    </view>

    <tabbar addon="running" />

    <!-- 快递信息弹窗 -->
    <view v-if="showExpress" class="fixed inset-0 bg-black bg-opacity-50 z-30 flex items-center justify-center">
      <view class="bg-white rounded-xl w-5/6 p-4">
        <view class="flex justify-between items-center pb-3 mb-3 border-b border-gray-100">
          <text class="font-medium text-lg">{{ isEditingExpress ? '编辑快递' : '添加快递' }}</text>
          <text class="iconfont icon-close text-gray-400" @click="closeExpressForm"></text>
        </view>

        <view class="mb-3">
          <text class="text-gray-500 mb-1 block text-sm">快递站点</text>
          <picker :value="expressFormData.siteIndex" :range="expressInfo.express_site" range-key="name"
            @change="onExpressFormSiteChange">
            <view class="flex items-center justify-between p-2 bg-gray-50 rounded-lg">
              <text>{{ expressFormData.express_name || '请选择快递站点' }}</text>
              <text class="iconfont icon-right text-gray-400"></text>
            </view>
          </picker>
        </view>

        <view class="mb-3">
          <text class="text-gray-500 mb-1 block text-sm">取件码</text>
          <input v-model="expressFormData.code" class="p-2 bg-gray-50 rounded-lg " placeholder="请输入取件码" />
        </view>

        <view class="mb-4">
          <text class="text-gray-500 mb-1 block text-sm">快递类型</text>
          <picker :value="expressFormData.serviceIndex" :range="filteredServices" range-key="name"
            @change="onExpressFormServiceChange">
            <view class="flex items-center justify-between p-2 bg-gray-50 rounded-lg">
              <text>{{ expressFormData.name || '请选择快递类型' }}</text>
              <text class="iconfont icon-right text-gray-400"></text>
            </view>
          </picker>
        </view>

        <view class="flex justify-end">
          <view class="mr-2 py-2 px-4 border border-gray-300 rounded-lg" @click="closeExpressForm">
            <text>取消</text>
          </view>
          <view class="mr-2 py-2 px-4 border border-gray-300 rounded-lg" @click="confirmExpressForm">
            <text>确定</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 支付组件 -->
    <Pay ref="payRef" />
  </view>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import {
  createOrder,
  getProductList,
  getSchoolExpressInfo,
  getSchoolList,
  type School
} from '../../api/index'

// 引入支付组件
import Pay from '@/components/pay/pay.vue'

// 自定义类型定义
interface Building {
  id: number
  name: string
  site_id: number
  school_id: number
  status: number
  create_time: string
  update_time: string
  pid?: number
  level?: number
  sort?: number
  children?: Building[]
}

interface ExpressStation {
  id: number
  site_id: number
  school_id: number
  name: string
  address: string
  status: number
  create_time: string
  update_time: string
}

interface ExpressInfo {
  express_site: ExpressStation[]
  building: Building[]
}

// 扩展Order接口以支持支付所需属性
interface PaymentOrderResponse {
  id: number
  order_no?: string
  trade_type?: string
  trade_id?: number | string
  order_status?: number
  order_status_text?: string
  member_id?: number
}

// 定义OrderData接口
interface OrderData {
  type: number
  school_id: number | string
  amount: number
  delivery_fee: number
  receiver_name: string
  receiver_phone: string
  express_items?: any[]
  building_id?: number
  room_number?: string
  service_id?: number
  service_quantity?: number
  pickup_address?: string
  pickup_name?: string
  pickup_phone?: string
  delivery_address?: string
  remark: string
}

// 业务类型定义
const businessTabs = [
  { name: '快递代取', type: 1, icon: 'nc-iconfont nc-icon-daifahuoV6xx' },
  { name: '跑腿服务', type: 2, icon: 'nc-iconfont nc-icon-fenxiangV6xx1' }
]

// 响应式数据
const schoolList = ref<School[]>([])
const schoolIndex = ref(0)
const currentSchool = ref<School>({ id: 0, name: '' })
const currentTab = ref(0)
const showExpress = ref(false) // 控制快递弹窗显示

// 服务数据
const serviceCategories = ref<any[]>([])
const selectedService = ref<any>(null)

// 快递代取数据
const expressInfo = ref<ExpressInfo>({ express_site: [], building: [] })
const expressSiteIndex = ref(0)
const buildingFirstIndex = ref(0)
const buildingSecondIndex = ref(0)
const buildingArray = ref<any[][]>([[], []])
const selectedBuilding = ref<Building | null>(null)
const selectedParentBuilding = ref<Building | null>(null)
const selectedExpressSite = ref<ExpressStation | null>(null) // 添加选中的快递站点

// 快递项列表
const expressItems = ref<
  {
    id: number
    express_name: string
    code: string
    service_id: number // 快递服务ID
    name: string // 快递服务名称
    price: string // 服务价格
  }[]
>([])

// 快递表单
const expressPopup = ref<any>(null)
const successPopup = ref<any>(null)
const isEditingExpress = ref(false)
const editingExpressIndex = ref(-1)
const expressFormData = ref({
  siteIndex: 0,
  serviceIndex: 0,
  id: 0,
  express_name: '',
  code: '',
  service_id: 0,
  name: '',
  price: '0.00'
})

// 支付相关
const payRef = ref<any>(null)
const payLoading = ref(false)

// 订单表单
interface OrderForm {
  pickup_address: string
  delivery_address: string
  room_number: string
  receiver_name: string
  receiver_phone: string
  pickup_name: string
  pickup_phone: string
}

// 表单数据
const orderForm = ref<OrderForm>({
  pickup_address: '',
  delivery_address: '',
  room_number: '',
  receiver_name: '',
  receiver_phone: '',
  pickup_name: '',
  pickup_phone: ''
})

// 根据当前tab过滤服务
const filteredServices = computed(() => {
  if (!serviceCategories.value.length) return []

  const categoryId = currentTab.value === 0 ? '1' : '2'
  const category = serviceCategories.value.find((c) => c.id === categoryId)

  if (!category) return []

  return category.service_list.map((service: any) => {
    if (!service.quantity && currentTab.value === 1) {
      service.quantity = 1
    }
    return service
  })
})

// 计算显示的楼栋文本
const selectedBuildingText = computed(() => {
  if (!selectedParentBuilding.value && !selectedBuilding.value) return '请选择楼栋'

  if (selectedParentBuilding.value && selectedBuilding.value) {
    return `${selectedParentBuilding.value.name} - ${selectedBuilding.value.name}`
  }

  if (selectedParentBuilding.value && !selectedBuilding.value) {
    return selectedParentBuilding.value.name
  }

  return selectedBuilding.value?.name || '请选择楼栋'
})

// 获取学校列表
const getSchools = async () => {
  try {
    const res = await getSchoolList()
    schoolList.value = res.data
    if (schoolList.value.length > 0) {
      currentSchool.value = schoolList.value[0]
      getServices()
      getExpressInfo()
    }
  } catch (error: any) {
    uni.showToast({
      title: error.message || '获取学校列表失败',
      icon: 'none'
    })
  }
}

// 获取服务列表
const getServices = async () => {
  if (!currentSchool.value.id) return
  try {
    const res = await getProductList({
      school_id: currentSchool.value.id
    })
    serviceCategories.value = res.data

    // 默认选中第一个服务
    if (filteredServices.value.length > 0) {
      selectedService.value = filteredServices.value[0]
    }
  } catch (error: any) {
    uni.showToast({
      title: error.message || '获取服务列表失败',
      icon: 'none'
    })
  }
}

// 获取快递站点和楼栋信息
const getExpressInfo = async () => {
  if (!currentSchool.value.id) return
  try {
    const res = await getSchoolExpressInfo({
      school_id: currentSchool.value.id
    })
    expressInfo.value = res.data

    // 默认选中第一个快递站点
    if (expressInfo.value.express_site.length > 0) {
      selectedExpressSite.value = expressInfo.value.express_site[0]
    }

    // 处理楼栋数据
    initBuildingPickers()
  } catch (error: any) {
    uni.showToast({
      title: error.message || '获取快递站点和楼栋信息失败',
      icon: 'none'
    })
  }
}

// 初始化楼栋选择器数据
const initBuildingPickers = () => {
  // 找出所有一级楼栋（pid为0或level为1的）
  // 直接使用接口返回的数据，不再额外过滤
  const parentBuildings = expressInfo.value.building || []

  // 默认选择第一个父级楼栋
  let defaultParentBuilding = parentBuildings[0] || null
  selectedParentBuilding.value = defaultParentBuilding

  // 初始化第一列数据为父级楼栋
  buildingArray.value[0] = parentBuildings

  // 如果有父级楼栋且有子楼栋，初始化第二列数据
  if (defaultParentBuilding && defaultParentBuilding.children && defaultParentBuilding.children.length > 0) {
    buildingArray.value[1] = defaultParentBuilding.children
    // 默认选择第一个子楼栋
    selectedBuilding.value = defaultParentBuilding.children[0] || null
  } else {
    buildingArray.value[1] = []
    selectedBuilding.value = null
  }

  // 设置选中索引
  buildingFirstIndex.value = 0
  buildingSecondIndex.value = 0
}

// 处理楼栋多列选择器的列变化
const onBuildingColumnChange = (e: any) => {
  const { column, value } = e.detail

  if (column === 0) {
    // 第一列变化，需要更新第二列数据
    const parentBuilding = buildingArray.value[0][value]
    selectedParentBuilding.value = parentBuilding

    // 更新第二列数据
    if (parentBuilding && parentBuilding.children && parentBuilding.children.length > 0) {
      buildingArray.value[1] = parentBuilding.children
      // 重置第二列选中索引
      buildingSecondIndex.value = 0
      selectedBuilding.value = parentBuilding.children[0] || null
    } else {
      buildingArray.value[1] = []
      selectedBuilding.value = null
    }
  }
}

// 楼栋选择改变
const onBuildingChange = (e: any) => {
  const [firstIndex, secondIndex] = e.detail.value
  buildingFirstIndex.value = firstIndex
  buildingSecondIndex.value = secondIndex

  selectedParentBuilding.value = buildingArray.value[0][firstIndex] || null
  selectedBuilding.value = buildingArray.value[1][secondIndex] || null
}

// 学校选择改变
const onSchoolChange = (e: any) => {
  schoolIndex.value = e.detail.value
  currentSchool.value = schoolList.value[schoolIndex.value]
  getServices()
  getExpressInfo()
  resetForm()
}

// tab切换
const onTabChange = (index: number) => {
  currentTab.value = index
  resetForm()

  // 切换到新tab后，默认选中第一个服务
  if (filteredServices.value.length > 0) {
    selectedService.value = filteredServices.value[0]
  } else {
    selectedService.value = null
  }
}

// 快递表单站点变更
const onExpressFormSiteChange = (e: any) => {
  const index = e.detail.value
  const site = expressInfo.value.express_site[index]
  expressFormData.value.siteIndex = index
  expressFormData.value.id = site.id
  expressFormData.value.express_name = site.name
}

// 快递表单服务变更
const onExpressFormServiceChange = (e: any) => {
  const index = e.detail.value
  const service = filteredServices.value[index]
  expressFormData.value.serviceIndex = index
  expressFormData.value.service_id = service.id
  expressFormData.value.name = service.name
  expressFormData.value.price = service.price
}

// 显示快递表单 - 添加新快递
const showExpressForm = () => {
  isEditingExpress.value = false
  editingExpressIndex.value = -1

  // 默认选择第一个站点
  const defaultSite = expressInfo.value.express_site[0] || null

  // 默认选择第一个服务
  const defaultService = filteredServices.value[0] || null

  expressFormData.value = {
    siteIndex: 0,
    serviceIndex: 0,
    id: defaultSite?.id || 0,
    express_name: defaultSite?.name || '',
    code: '',
    service_id: defaultService?.id || 0,
    name: defaultService?.name || '',
    price: defaultService?.price || '0.00'
  }

  // 使用响应式变量控制弹窗显示
  showExpress.value = true
}

// 编辑快递
const editExpressItem = (index: number) => {
  const item = expressItems.value[index]
  isEditingExpress.value = true
  editingExpressIndex.value = index

  // 查找站点索引
  const siteIndex = expressInfo.value.express_site.findIndex((site) => site.id === item.id)

  expressFormData.value = {
    siteIndex: siteIndex !== -1 ? siteIndex : 0,
    serviceIndex: 0,
    id: item.id,
    express_name: item.express_name,
    code: item.code,
    service_id: item.service_id,
    name: item.name,
    price: item.price
  }

  // 使用响应式变量控制弹窗显示
  showExpress.value = true
}

// 删除快递
const deleteExpressItem = (index: number) => {
  uni.showModal({
    title: '提示',
    content: '确定要删除这个快递吗？',
    success: (res) => {
      if (res.confirm) {
        expressItems.value.splice(index, 1)
      }
    }
  })
}

// 关闭快递表单
const closeExpressForm = () => {
  // 使用响应式变量控制弹窗关闭
  showExpress.value = false
}

// 关闭成功提示
const closeSuccessPopup = () => {
  if (successPopup && successPopup.value) {
    successPopup.value.close()
  }
}

// 确认快递表单
const confirmExpressForm = () => {
  // 验证表单
  if (!expressFormData.value.id) {
    uni.showToast({
      title: '请选择快递站点',
      icon: 'none'
    })
    return
  }

  if (!expressFormData.value.code) {
    uni.showToast({
      title: '请输入取件码',
      icon: 'none'
    })
    return
  }

  if (!expressFormData.value.service_id) {
    uni.showToast({
      title: '请选择快递类型',
      icon: 'none'
    })
    return
  }

  const expressItem = {
    id: expressFormData.value.id,
    express_name: expressFormData.value.express_name,
    code: expressFormData.value.code,
    service_id: expressFormData.value.service_id,
    name: expressFormData.value.name,
    price: expressFormData.value.price
  }

  if (isEditingExpress.value && editingExpressIndex.value !== -1) {
    // 编辑现有快递
    expressItems.value[editingExpressIndex.value] = expressItem
  } else {
    // 添加新快递
    expressItems.value.push(expressItem)
  }

  closeExpressForm()
}

// 选择服务
const selectService = (service: any) => {
  selectedService.value = service

  // 添加振动反馈
  uni.vibrateShort({
    success: function () {
      console.log('振动成功')
    }
  })
}

// 更新数量（跑腿服务）
const updateQuantity = (service: any, change: number) => {
  if (!service.quantity) {
    service.quantity = 1
  }

  const newQuantity = service.quantity + change
  if (newQuantity < 1) return

  service.quantity = newQuantity
}

// 计算总价
const calculateTotal = () => {
  if (currentTab.value === 0) {
    // 快递代取，累加每个快递项的价格
    if (expressItems.value.length === 0) return '0.00'

    return expressItems.value
      .reduce((sum, item) => {
        return sum + parseFloat(item.price)
      }, 0)
      .toFixed(2)
  } else {
    // 跑腿服务，根据数量计算
    if (!selectedService.value) return '0.00'
    return (
      parseFloat(selectedService.value.price) * (selectedService.value.quantity || 1)
    ).toFixed(2)
  }
}

// 重置表单
const resetForm = () => {
  if (currentTab.value === 0) {
    expressItems.value = []
    buildingFirstIndex.value = 0
    buildingSecondIndex.value = 0
    selectedBuilding.value = null
  } else {
    selectedService.value = null
  }

  orderForm.value = {
    pickup_address: '',
    delivery_address: '',
    room_number: '',
    receiver_name: '',
    receiver_phone: '',
    pickup_name: '',
    pickup_phone: ''
  }
}

// 表单验证
const validateForm = () => {
  if (!selectedService.value && currentTab.value === 1) {
    uni.showToast({
      title: '请选择服务',
      icon: 'none'
    })
    return false
  }

  if (currentTab.value === 0) {
    // 快递代取验证
    if (expressItems.value.length === 0) {
      uni.showToast({
        title: '请添加快递信息',
        icon: 'none'
      })
      return false
    }

    if (!selectedParentBuilding.value) {
      uni.showToast({
        title: '请选择送达楼栋',
        icon: 'none'
      })
      return false
    }

    if (!orderForm.value.room_number) {
      uni.showToast({
        title: '请输入房间号',
        icon: 'none'
      })
      return false
    }

    if (!orderForm.value.receiver_name) {
      uni.showToast({
        title: '请输入收件人姓名',
        icon: 'none'
      })
      return false
    }

    if (!orderForm.value.receiver_phone) {
      uni.showToast({
        title: '请输入收件人手机号',
        icon: 'none'
      })
      return false
    }
  } else {
    // 跑腿服务验证
    if (!orderForm.value.pickup_address) {
      uni.showToast({
        title: '请输入取货地址',
        icon: 'none'
      })
      return false
    }

    if (!orderForm.value.pickup_phone) {
      uni.showToast({
        title: '请输入取货联系人电话',
        icon: 'none'
      })
      return false
    }

    if (!orderForm.value.delivery_address) {
      uni.showToast({
        title: '请输入收货地址',
        icon: 'none'
      })
      return false
    }
  }

  return true
}

// 提交订单
const submitOrder = async () => {
  try {
    // 前端验证
    if (currentTab.value === 0) {
      // 快递代取验证
      if (expressItems.value.length === 0) {
        uni.showToast({
          title: '请添加快递信息',
          icon: 'none'
        })
        return
      }
      if (!selectedParentBuilding.value) {
        uni.showToast({
          title: '请选择送达楼栋',
          icon: 'none'
        })
        return
      }
      if (!orderForm.value.room_number) {
        uni.showToast({
          title: '请输入房间号',
          icon: 'none'
        })
        return
      }
    } else {
      // 跑腿服务验证
      if (!selectedService.value) {
        uni.showToast({
          title: '请选择服务',
          icon: 'none'
        })
        return
      }
      if (!orderForm.value.pickup_address) {
        uni.showToast({
          title: '请输入取货地址',
          icon: 'none'
        })
        return
      }
      if (!orderForm.value.delivery_address) {
        uni.showToast({
          title: '请输入收货地址',
          icon: 'none'
        })
        return
      }
    }

    console.log(selectedService.value)

    // 拼接楼栋和房间号
    let buildingName = selectedParentBuilding.value?.name || ''
    if (selectedBuilding.value) {
      buildingName += ` - ${selectedBuilding.value.name}`
    }
    const room_number = buildingName + ' ' + orderForm.value?.room_number

    // 确定使用哪个楼栋ID
    const building_id = selectedBuilding.value?.id || selectedParentBuilding.value?.id

    // 判断 当前tab 是 快递代取 还是 跑腿服务
    // 然后统一参数
    let express_items = []
    if (currentTab.value === 0) {
      express_items = expressItems.value
    } else {
      express_items = [
        {
          id: selectedService.value.id,
          express_name: selectedService.value.name,
          code: '',
          quantity: 1,
          service_id: selectedService.value.id,
          name: selectedService.value.name,
          price: selectedService.value.price
        }
      ]
    }

    // 构建订单数据
    const orderData: OrderData = {
      type: currentTab.value === 0 ? 1 : 2, // 1=快递代取，2=跑腿服务
      school_id: currentSchool.value.id,
      amount: parseFloat(calculateTotal()),
      delivery_fee: 0, // 此处可根据实际需求计算配送费

      // 通用信息
      receiver_name: orderForm.value.receiver_name || '匿名用户',
      receiver_phone: orderForm.value.receiver_phone || '',

      // 用户选中的商品

      // 商品信息 - 快递代取
      express_items,
      building_id,
      room_number,

      // 商品信息 - 跑腿服务
      service_id: currentTab.value === 1 ? selectedService.value?.id : undefined,
      service_quantity: currentTab.value === 1 ? selectedService.value?.quantity || 1 : undefined,
      pickup_address: currentTab.value === 1 ? orderForm.value.pickup_address : undefined,
      pickup_name: currentTab.value === 1 ? orderForm.value.pickup_name : undefined,
      pickup_phone: currentTab.value === 1 ? orderForm.value.pickup_phone : undefined,
      delivery_address: currentTab.value === 1 ? orderForm.value.delivery_address : undefined,

      remark: ''
    }

    // 显示加载中
    uni.showLoading({
      title: '提交中...'
    })

    try {
      const res = await createOrder(orderData)
      uni.hideLoading()

      if (res.code === 1) {
        const orderResponseData: PaymentOrderResponse = res.data

        // 检查后端是否实现了支付功能
        if (orderResponseData.trade_type && orderResponseData.trade_id) {
          // 调用支付
          payLoading.value = true

          // 有支付信息，调用支付组件
          const res = payRef.value?.open(
            orderResponseData.trade_type,
            orderResponseData.trade_id,
            orderResponseData.member_id,
            '/addon/running/pages/order/list'
          )
          console.log(res);
          // 如果 支付失败，则 提示 错误信息
          // 支付的状态 恢复
          payLoading.value = false
        } else {
          // 注意：这里处理的是后端未实现支付功能的情况
          // 如果要完整实现支付功能，请修改后端OrderService.php的create方法
          // 参考tk_jhkd插件中的OrderService.php的createOrder方法

          // 创建成功，更新activeOrder信息（兼容原有逻辑）
          activeOrder.value = {
            id: orderResponseData.id,
            status: orderResponseData.order_status || 0,
            status_text: orderResponseData.order_status_text || '待处理',
            type: currentTab.value,
            create_time: new Date().toISOString()
          }
          hasActiveOrder.value = true

          // 显示成功提示
          if (successPopup.value) {
            successPopup.value.open()
          }

          uni.showToast({
            title: '订单创建成功',
            icon: 'success'
          })
        }

        // 重置表单
        resetForm()
      } else {
        // 错误处理
        // 如果 订单创建失败，则 提示 错误信息

        uni.showToast({
          title: res.message || '订单创建失败',
          icon: 'none'
        })
      }
    } catch (error) {
      uni.hideLoading()
      console.error('API调用失败:', error)
      uni.showToast({
        title: '网络错误，请稍后重试',
        icon: 'none'
      })
    }
  } catch (error) {
    console.error('提交订单失败:', error)
    uni.hideLoading()

    uni.showToast({
      title: '提交失败，请重试',
      icon: 'none'
    })
  }
}

// 添加手风琴状态控制
const activeAccordion = ref('pickup') // 默认展开取货信息

// 切换手风琴
const toggleAccordion = (section: 'pickup' | 'delivery') => {
  activeAccordion.value = activeAccordion.value === section ? '' : section

  // 添加触感反馈
  uni.vibrateShort({
    success: function () {
      console.log('振动成功')
    }
  })
}

// 用于管理活动订单的状态
const activeOrder = ref<any>(null)
const hasActiveOrder = ref(false)

// 页面加载时初始化数据
onMounted(() => {
  getSchools()
})
</script>

<style lang="scss">
page {
  background-color: #f5f7fa;
  height: 100%;
}

.iconfont {
  font-family: 'iconfont';
}

/* 图标定义 */
.icon-express:before {
  content: '\e74f';
}

.icon-running:before {
  content: '\e7d5';
}

.icon-location:before {
  content: '\e790';
}

.icon-service:before {
  content: '\e68c';
}

.icon-takeaway:before {
  content: '\e738';
}

.icon-warning:before {
  content: '\e662';
}

.icon-add:before {
  content: '\e767';
}

.icon-edit:before {
  content: '\e668';
}

.icon-delete:before {
  content: '\e6cf';
}

.icon-right:before {
  content: '\e6a3';
}

.icon-close:before {
  content: '\e65c';
}

.icon-empty:before {
  content: '\e6a6';
}

/* 渐变背景 */
.bg-gradient-to-b {
  background-image: linear-gradient(to bottom, var(--tw-gradient-stops));
}

.bg-gradient-to-r {
  background-image: linear-gradient(to right, var(--tw-gradient-stops));
}

.from-blue-500 {
  --tw-gradient-from: #3b82f6;
  --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to, rgba(59, 130, 246, 0));
}

.to-blue-400 {
  --tw-gradient-to: #60a5fa;
}

.to-blue-600 {
  --tw-gradient-to: #2563eb;
}

/* 活跃状态 */
.active\:opacity-90:active {
  opacity: 0.9;
}

/* 最后一个子元素 */
.last\:mb-0:last-child {
  margin-bottom: 0;
}

/* 自适应布局 */
@media screen and (min-height: 700px) {
  .h-52 {
    height: 208px;
  }
}

@media screen and (max-width: 320px) {
  .px-5 {
    padding-left: 16px;
    padding-right: 16px;
  }

  .p-5 {
    padding: 16px;
  }
}

/* 添加新的动画效果 */
@keyframes pulse {

  0%,
  100% {
    opacity: 1;
  }

  50% {
    opacity: 0.5;
  }
}

.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

@keyframes bounce {

  0%,
  100% {
    transform: translateY(0);
  }

  50% {
    transform: translateY(-10px);
  }
}

.animate-bounce {
  animation: bounce 2s infinite;
}

/* 增强光影效果 */
.shadow-lg {
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
}

.shadow-xl {
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
}

/* 背景模糊效果 */
.backdrop-blur-md {
  backdrop-filter: blur(12px);
}

.backdrop-blur-sm {
  backdrop-filter: blur(4px);
}

/* 渐变文本 */
.bg-clip-text {
  -webkit-background-clip: text;
  background-clip: text;
}

.text-transparent {
  color: transparent;
}

/* 添加进度条动画 */
@keyframes progress {
  0% {
    width: 0%;
  }

  100% {
    width: 100%;
  }
}

.animate-progress {
  animation: progress 5s linear;
}

/* 添加旋转动画 */
.hover\:rotate-90:hover {
  transform: rotate(90deg);
}

.transition-transform {
  transition: transform 0.3s ease;
}

/* 暗色模式适配 */
.dark\:bg-blue-900 {
  background-color: #1e3a8a;
}

.dark\:bg-blue-800 {
  background-color: #1e40af;
}

.dark\:text-blue-300 {
  color: #93c5fd;
}

.dark\:text-blue-100 {
  color: #dbeafe;
}

.dark\:text-blue-200 {
  color: #bfdbfe;
}

.dark\:hover\:bg-blue-800:hover {
  background-color: #1e40af;
}

/* 添加光影效果 */
.shadow-inner {
  box-shadow: inset 0 2px 4px 0 rgba(0, 0, 0, 0.06);
}

.shadow-glow {
  box-shadow: 0 0 15px rgba(59, 130, 246, 0.5);
}

/* 添加过渡效果 */
.transition-colors {
  transition: background-color 0.3s ease, color 0.3s ease;
}

.tab_active {
  background-color: #000;
  color: #fff;
}
</style>
