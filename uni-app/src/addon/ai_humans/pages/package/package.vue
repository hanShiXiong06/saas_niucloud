<template>
	<view class="min-h-screen relative" v-if="config" :style="themeColor()">
		<!-- 固定背景层 - 添加科技感渐变和网格，但避免覆盖底部导航 -->
		<view class="tech-bg fixed inset-0 z-[-1]">
			<!-- 科技网格层 -->
			<view class="tech-grid absolute inset-0 pointer-events-none"></view>
			<!-- 光点装饰 -->
			<view class="tech-dots absolute inset-0 pointer-events-none"></view>
			<!-- 渐变光柱 -->
			<view class="tech-beam absolute top-0 right-[20%] pointer-events-none"></view>
			<view class="tech-beam absolute bottom-0 left-[15%] pointer-events-none"></view>
		</view>

		<!-- 内容区 - 添加底部空间以避免被固定导航遮挡 -->
		<view class="p-3 pb-[180rpx]">
			<mescroll-body ref="mescrollRef" top="40rpx" @init="mescrollInit" @down="downCallback"
				@up="getPackageListFn">
				<!-- 套餐为空时显示 -->
				<mescroll-empty :option="{ 'icon': img('static/resource/images/empty.png') }"
					v-if="!list.length && loading"></mescroll-empty>
				<!-- 套餐不为空时显示 -->
				<view v-if="list.length > 0" class="pb-[140rpx]">
					<!-- 套餐列表 - 卡片网格 -->
					<view class="px-3">
						<!-- 页面顶部标题 -->
						<view class="text-center mb-6">
							<view class="relative inline-block">
								<view class="text-[40rpx] font-bold tracking-wider mb-1"
									style="background: linear-gradient(to bottom, #ECCB87, #B0976A); -webkit-background-clip: text; color: transparent; text-shadow: 0 2px 4px rgba(0,0,0,0.2);">
									选择套餐
								</view>
								<view
									class="w-[80%] h-[3px] mx-auto bg-gradient-to-r from-transparent via-[#B0976A] to-transparent opacity-60">
								</view>
								<!-- 装饰性光点 -->

							</view>
						</view>

						<!-- 套餐卡片网格 -->
						<view class="flex flex-wrap justify-between">
							<view v-for="(item, index) in list" :key="index" @click="selectPackage(index)"
								class="w-[48%] mb-4 relative cursor-pointer transition duration-300 transform hover:scale-[1.02] active:scale-[0.98]">
								<!-- 卡片背景 - 添加高端金属质感 -->
								<view :class="[getCardClass(index), currentIndex === index ? 'border-[#ECCB87]' : 'border-[#ECCB87]/30',
									'relative rounded-[20rpx] border overflow-hidden shadow-lg px-5 py-4 bg-[#0A1018] h-[260rpx]']">

									<!-- 推荐标签 -->
									<view v-if="isRecommended(item)"
										class="absolute top-3 right-3 z-10 bg-gradient-to-r from-[#ECCB87] to-[#B0976A] px-2 py-0.5 rounded-full shadow-sm">
										<text class="text-[#0A0F14] text-[20rpx] font-medium">推荐</text>
									</view>

									<!-- 套餐标签 - 奢华精致角标设计 -->
									<view v-if="item.tab"
										class="absolute top-0 right-0 z-10 px-4 py-[8rpx] text-[20rpx] luxurious-tag"
										style="border-top-right-radius: 20rpx; border-bottom-left-radius: 14rpx;">
										<!-- 基础背景 - 更深的颜色 -->
										<view class="absolute inset-0 bg-gradient-to-br from-[#121212] to-[#050505]">
										</view>
										<!-- 金色光泽叠加层 -->
										<view
											class="absolute inset-0 bg-gradient-to-br from-[#ECCB87]/25 to-[#B0976A]/10 opacity-90">
										</view>
										<!-- 微妙纹理 -->
										<view class="absolute inset-0 opacity-10"
											style="background-image: url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1IiBoZWlnaHQ9IjUiPgo8cmVjdCB3aWR0aD0iNSIgaGVpZ2h0PSI1IiBmaWxsPSIjZmZmIj48L3JlY3Q+CjxyZWN0IHdpZHRoPSIxIiBoZWlnaHQ9IjEiIGZpbGw9IiNjY2MiPjwvcmVjdD4KPC9zdmc+'); background-repeat: repeat;">
										</view>
										<!-- 内层边框 -->
										<view
											class="absolute inset-[0.5px] rounded-tr-[20rpx] rounded-bl-[14rpx] border-b border-l border-[#ECCB87]/40">
										</view>
										<!-- 边缘金色微光 -->
										<view
											class="absolute -inset-[0.5px] rounded-tr-[20rpx] rounded-bl-[14rpx] opacity-0 glow-effect">
										</view>

										<!-- 精致装饰元素 -->
										<!-- 左下角装饰 -->
										<view
											class="absolute bottom-[2px] left-[2px] w-3 h-3 rounded-tr-md bg-gradient-to-tr from-[#ECCB87]/50 to-transparent">
										</view>
										<!-- 左下和底部装饰线条 -->
										<view
											class="absolute bottom-0 left-0 h-[1.5px] w-[70%] bg-gradient-to-r from-[#ECCB87] via-[#B0976A]/70 to-transparent">
										</view>
										<view
											class="absolute left-0 bottom-0 w-[1.5px] h-[70%] bg-gradient-to-t from-[#ECCB87] via-[#B0976A]/70 to-transparent">
										</view>
										<!-- 顶部光泽 -->
										<view class="absolute top-0 inset-x-[5px] h-[1px] bg-white/30"></view>
										<!-- 右上细微装饰 -->
										<view
											class="absolute top-[3px] right-[3px] w-1 h-1 rounded-full bg-[#ECCB87]/40">
										</view>
										<!-- 微光点缀 -->
										<view
											class="absolute bottom-[4px] right-[4px] w-[4px] h-[4px] rounded-full bg-[#ECCB87] opacity-50 shimmer-dot">
										</view>

										<!-- 文字 -->
										<text class="relative z-10 font-medium tracking-wide"
											style="background: linear-gradient(135deg, #ECCB87, #B0976A); -webkit-background-clip: text; color: transparent; text-shadow: 0 1px 3px rgba(0,0,0,0.4);">
											{{ item.tab }}
										</text>
									</view>

									<!-- 卡片内容区 -->
									<view class="flex flex-col justify-between h-full relative z-10 pt-4">
										<!-- 卡片顶部 - 标题和标签 -->
										<view>
											<!-- 套餐名称 -->
											<view class="text-[32rpx] font-bold mb-1"
												style="background: linear-gradient(to bottom, #ECCB87, #B0976A); -webkit-background-clip: text; color: transparent;">
												{{ item.name }}
											</view>

											<!-- 套餐描述 -->
											<view
												class="text-[24rpx] h-[32rpx] mt-2 leading-[32rpx] text-white/70 line-clamp-2 min-h-[32rpx]">
												{{ item.desc }}
											</view>
										</view>

										<!-- 卡片底部 - 价格信息 -->
										<view class="mt-1">
											<!-- 原价和折扣 -->
											<view class="flex items-center mb-1">
												<text v-if="item.origin_price && item.origin_price != item.price"
													class="text-[22rpx] text-white/50 line-through mr-2">¥{{
														item.origin_price }}</text>
												<view v-if="item.origin_price && item.origin_price != item.price"
													class="text-[20rpx] text-[#ECCB87] bg-[#ECCB87]/10 px-1.5 rounded-full">
													{{ ((1 - Number(item.price) / Number(item.origin_price)) *
														100).toFixed(0) }}% OFF
												</view>
											</view>

											<!-- 当前价格 -->
											<view class="flex items-baseline">
												<text class="text-[#ECCB87] text-[22rpx] mr-1">¥</text>
												<text class="text-[#ECCB87] text-[40rpx] font-bold"
													style="font-family: 'DIN Condensed', Arial, sans-serif;">{{
														item.price }}</text>
											</view>

											<!-- 充值数量 -->
											<view v-if="item.point" class="flex items-center mt-1 mb-4">

												<text class="text-[22rpx] text-white/70">
													<text class="text-[#ECCB87]">{{ item.point }}</text> {{
														config.name }}
												</text>
											</view>
										</view>
									</view>

									<!-- 装饰元素 -->
									<view
										class="absolute top-0 right-0 w-32 h-32 rounded-bl-full bg-gradient-to-bl from-[#ECCB87]/5 to-transparent opacity-30">
									</view>

									<view
										class="absolute -bottom-10 -left-10 w-40 h-40 rounded-tr-full bg-gradient-to-tr from-[#ECCB87]/5 to-transparent opacity-20">
									</view>

									<!-- 选中状态指示器 -->
									<view v-if="currentIndex === index"
										class="absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r from-[#ECCB87] to-[#B0976A]">
									</view>
									<view v-if="currentIndex === index"
										class="absolute inset-0 border-2 border-[#ECCB87]/30 rounded-[20rpx] pointer-events-none">
									</view>
								</view>
							</view>
						</view>


					</view>
					<view class="mt-5" v-if="list[currentIndex]?.benefits">
						<!-- 优化套餐权益标题 -->
						<view class="benefit-title flex items-center justify-center mb-4">
							<view
								class="w-16 h-[1px] bg-gradient-to-r from-transparent via-[#B0976A]/40 to-transparent">
							</view>
							<view class="relative mx-3 flex items-center">
								<text class="text-[30rpx] font-bold px-2 py-2"
									style="background: linear-gradient(to bottom, #ECCB87, #B0976A); -webkit-background-clip: text; color: transparent; ">
									套餐权益
								</text>

							</view>
							<view
								class="w-16 h-[1px] bg-gradient-to-r from-transparent via-[#B0976A]/40 to-transparent">
							</view>
						</view>

						<!-- 权益卡片网格 -->
						<view
							class="p-4 rounded-xl bg-gradient-to-br from-[#0A1018]/90 to-[#0A1018]/70 backdrop-blur-sm border border-[#ECCB87]/10 shadow-lg relative overflow-hidden transform transition-all duration-300 hover:scale-[1.02] active:scale-[0.98]">
							<!-- 装饰元素 -->
							<view
								class="absolute top-0 right-0 w-24 h-24 rounded-bl-full bg-gradient-to-bl from-[#ECCB87]/10 to-transparent opacity-40 animate-pulse-slow">
							</view>
							<view
								class="absolute -bottom-6 -left-6 w-24 h-24 rounded-tr-full bg-gradient-to-tr from-[#ECCB87]/10 to-transparent opacity-30 animate-pulse-slow delay-300">
							</view>

							<!-- 权益列表 -->
							<view class="space-y-4 relative z-10">
								<!-- 改为网格布局,上下结构一行两个 -->
								<view class="grid grid-cols-2 gap-3">
									<!-- 声音克隆 -->
									<view
										class="rights-item group bg-[#0A1018]/80 rounded-lg px-3 py-3 border border-[#ECCB87]/10 shadow-md hover:border-[#ECCB87]/30 transition-all duration-300"
										v-if="list[currentIndex]?.benefits.clone_voice_num > 0">
										<view class="flex items-center mb-2">
											<view
												class="w-2 h-2 rounded-full bg-gradient-to-r from-[#ECCB87] to-[#B0976A] mr-3 animate-pulse">
											</view>
											<text
												class="text-white/90 text-[26rpx] font-medium group-hover:text-white transition-colors duration-300">声音克隆</text>
										</view>
										<view class="flex items-center ml-5">
											<text
												class="text-[#ECCB87] text-[26rpx] font-bold group-hover:text-[#FFD700] transition-colors duration-300">{{
													list[currentIndex]?.benefits.clone_voice_num }}</text>
											<text class="text-white/60 text-[22rpx] ml-1">次</text>
										</view>
									</view>

									<!-- 声音克隆Pro -->
									<view
										class="rights-item group bg-[#0A1018]/80 rounded-lg px-3 py-3 border border-[#ECCB87]/10 shadow-md hover:border-[#ECCB87]/30 transition-all duration-300"
										v-if="list[currentIndex]?.benefits.clone_voice_pro_num > 0">
										<view class="flex items-center mb-2">
											<view
												class="w-2 h-2 rounded-full bg-gradient-to-r from-[#ECCB87] to-[#B0976A] mr-3 animate-pulse">
											</view>
											<text
												class="text-white/90 text-[26rpx] font-medium group-hover:text-white transition-colors duration-300">声音克隆Pro</text>
										</view>
										<view class="flex items-center ml-5">
											<text
												class="text-[#ECCB87] text-[26rpx] font-bold group-hover:text-[#FFD700] transition-colors duration-300">{{
													list[currentIndex]?.benefits.clone_voice_pro_num }}</text>
											<text class="text-white/60 text-[22rpx] ml-1">次</text>
										</view>
									</view>

									<!-- 声音合成 -->
									<view
										class="rights-item group bg-[#0A1018]/80 rounded-lg px-3 py-3 border border-[#ECCB87]/10 shadow-md hover:border-[#ECCB87]/30 transition-all duration-300"
										v-if="list[currentIndex]?.benefits.create_voice_num > 0">
										<view class="flex items-center mb-2">
											<view
												class="w-2 h-2 rounded-full bg-gradient-to-r from-[#ECCB87] to-[#B0976A] mr-3 animate-pulse">
											</view>
											<text
												class="text-white/90 text-[26rpx] font-medium group-hover:text-white transition-colors duration-300">声音合成</text>
										</view>
										<view class="flex items-center ml-5">
											<text
												class="text-[#ECCB87] text-[26rpx] font-bold group-hover:text-[#FFD700] transition-colors duration-300">{{
													list[currentIndex]?.benefits.create_voice_num }}</text>
											<text class="text-white/60 text-[22rpx] ml-1">分</text>
										</view>
									</view>

									<!-- 声音合成Pro -->
									<view
										class="rights-item group bg-[#0A1018]/80 rounded-lg px-3 py-3 border border-[#ECCB87]/10 shadow-md hover:border-[#ECCB87]/30 transition-all duration-300"
										v-if="list[currentIndex]?.benefits.create_voice_pro_num > 0">
										<view class="flex items-center mb-2">
											<view
												class="w-2 h-2 rounded-full bg-gradient-to-r from-[#ECCB87] to-[#B0976A] mr-3 animate-pulse">
											</view>
											<text
												class="text-white/90 text-[26rpx] font-medium group-hover:text-white transition-colors duration-300">声音合成Pro</text>
										</view>
										<view class="flex items-center ml-5">
											<text
												class="text-[#ECCB87] text-[26rpx] font-bold group-hover:text-[#FFD700] transition-colors duration-300">{{
													list[currentIndex]?.benefits.create_voice_pro_num }}</text>
											<text class="text-white/60 text-[22rpx] ml-1">分</text>
										</view>
									</view>

									<!-- 视频克隆 -->
									<view
										class="rights-item group bg-[#0A1018]/80 rounded-lg px-3 py-3 border border-[#ECCB87]/10 shadow-md hover:border-[#ECCB87]/30 transition-all duration-300"
										v-if="list[currentIndex]?.benefits.clone_video_num > 0">
										<view class="flex items-center mb-2">
											<view
												class="w-2 h-2 rounded-full bg-gradient-to-r from-[#ECCB87] to-[#B0976A] mr-3 animate-pulse">
											</view>
											<text
												class="text-white/90 text-[26rpx] font-medium group-hover:text-white transition-colors duration-300">视频克隆</text>
										</view>
										<view class="flex items-center ml-5">
											<text
												class="text-[#ECCB87] text-[26rpx] font-bold group-hover:text-[#FFD700] transition-colors duration-300">{{
													list[currentIndex]?.benefits.clone_video_num }}</text>
											<text class="text-white/60 text-[22rpx] ml-1">次</text>
										</view>
									</view>

									<!-- 视频克隆Pro -->
									<view
										class="rights-item group bg-[#0A1018]/80 rounded-lg px-3 py-3 border border-[#ECCB87]/10 shadow-md hover:border-[#ECCB87]/30 transition-all duration-300"
										v-if="list[currentIndex]?.benefits.clone_video_pro_num > 0">
										<view class="flex items-center mb-2">
											<view
												class="w-2 h-2 rounded-full bg-gradient-to-r from-[#ECCB87] to-[#B0976A] mr-3 animate-pulse">
											</view>
											<text
												class="text-white/90 text-[26rpx] font-medium group-hover:text-white transition-colors duration-300">视频克隆Pro</text>
										</view>
										<view class="flex items-center ml-5">
											<text
												class="text-[#ECCB87] text-[26rpx] font-bold group-hover:text-[#FFD700] transition-colors duration-300">{{
													list[currentIndex]?.benefits.clone_video_pro_num }}</text>
											<text class="text-white/60 text-[22rpx] ml-1">次</text>
										</view>
									</view>

									<!-- 视频合成 -->
									<view
										class="rights-item group bg-[#0A1018]/80 rounded-lg px-3 py-3 border border-[#ECCB87]/10 shadow-md hover:border-[#ECCB87]/30 transition-all duration-300"
										v-if="list[currentIndex]?.benefits.create_video_num > 0">
										<view class="flex items-center mb-2">
											<view
												class="w-2 h-2 rounded-full bg-gradient-to-r from-[#ECCB87] to-[#B0976A] mr-3 animate-pulse">
											</view>
											<text
												class="text-white/90 text-[26rpx] font-medium group-hover:text-white transition-colors duration-300">视频合成</text>
										</view>
										<view class="flex items-center ml-5">
											<text
												class="text-[#ECCB87] text-[26rpx] font-bold group-hover:text-[#FFD700] transition-colors duration-300">{{
													list[currentIndex]?.benefits.create_video_num }}</text>
											<text class="text-white/60 text-[22rpx] ml-1">分</text>
										</view>
									</view>

									<!-- 视频合成Pro -->
									<view
										class="rights-item group bg-[#0A1018]/80 rounded-lg px-3 py-3 border border-[#ECCB87]/10 shadow-md hover:border-[#ECCB87]/30 transition-all duration-300"
										v-if="list[currentIndex]?.benefits.create_video_pro_num > 0">
										<view class="flex items-center mb-2">
											<view
												class="w-2 h-2 rounded-full bg-gradient-to-r from-[#ECCB87] to-[#B0976A] mr-3 animate-pulse">
											</view>
											<text
												class="text-white/90 text-[26rpx] font-medium group-hover:text-white transition-colors duration-300">视频合成Pro</text>
										</view>
										<view class="flex items-center ml-5">
											<text
												class="text-[#ECCB87] text-[26rpx] font-bold group-hover:text-[#FFD700] transition-colors duration-300">{{
													list[currentIndex]?.benefits.create_video_pro_num }}</text>
											<text class="text-white/60 text-[22rpx] ml-1">分</text>
										</view>
									</view>

									<!-- AI创作 -->
									<view
										class="rights-item group bg-[#0A1018]/80 rounded-lg px-3 py-3 border border-[#ECCB87]/10 shadow-md hover:border-[#ECCB87]/30 transition-all duration-300"
										v-if="list[currentIndex]?.benefits.chat_num > 0">
										<view class="flex items-center mb-2">
											<view
												class="w-2 h-2 rounded-full bg-gradient-to-r from-[#ECCB87] to-[#B0976A] mr-3 animate-pulse">
											</view>
											<text
												class="text-white/90 text-[26rpx] font-medium group-hover:text-white transition-colors duration-300">AI创作</text>
										</view>
										<view class="flex items-center ml-5">
											<text
												class="text-[#ECCB87] text-[26rpx] font-bold group-hover:text-[#FFD700] transition-colors duration-300">{{
													list[currentIndex]?.benefits.chat_num }}</text>
											<text class="text-white/60 text-[22rpx] ml-1">次</text>
										</view>
									</view>
								</view>
							</view>
						</view>
					</view>
					<!-- 会员权益 - 改进样式 -->
					<view class="mt-5" v-if="list[currentIndex]?.award.length > 0">
						<view class="benefit-title flex items-center justify-center mb-4">
							<view
								class="w-16 h-[1px] bg-gradient-to-r from-transparent via-[#B0976A]/40 to-transparent">
							</view>
							<view class="relative mx-3 flex items-center">
								<text class="text-[30rpx] font-bold px-2 py-2"
									style="background: linear-gradient(to bottom, #ECCB87, #B0976A); -webkit-background-clip: text; color: transparent; ">
									尊享特权
								</text>
							</view>
							<view
								class="w-16 h-[1px] bg-gradient-to-r from-transparent via-[#B0976A]/40 to-transparent">
							</view>
						</view>

						<!-- 特权卡片网格 -->
						<view class="flex flex-wrap justify-between mt-6">
							<view class="benefit-item w-[48%] mb-3" v-for="(benefit, index) in list[currentIndex].award"
								:key="index">
								<view
									class="flex items-center p-4 relative overflow-hidden group rounded-[16rpx] bg-gradient-to-br from-[#0A1018] to-[#121B24] backdrop-blur-sm border border-[#ECCB87]/10 shadow-lg transform transition-all duration-300 hover:scale-[1.02] active:scale-[0.98]">
									<!-- 图标容器 -->
									<view
										class="mr-3 w-[48rpx] h-[48rpx] rounded-full flex items-center justify-center relative">
										<!-- 图标背景光晕 -->
										<view
											class="absolute inset-0 rounded-full bg-gradient-to-br from-[#ECCB87]/40 to-[#B0976A]/30 blur-sm">
										</view>
										<!-- 图标底层 -->
										<view
											class="absolute inset-0 rounded-full bg-gradient-to-br from-[#ECCB87]/20 to-[#B0976A]/10">
										</view>
										<!-- 图标 -->
										<view class="relative z-10">
											<u-image :src="img(benefit.icon)" width="46rpx" height="46rpx"
												mode="aspectFit"></u-image>
										</view>
										<!-- 图标边框 -->
										<view class="absolute inset-0 rounded-full border border-[#ECCB87]/30"></view>
									</view>

									<!-- 文本内容 -->
									<view class="flex-1 relative z-1 overflow-hidden">
										<view class="text-[#ECCB87] text-[26rpx] font-medium truncate mb-1"
											style="text-shadow: 0 1px 2px rgba(0,0,0,0.15);">
											{{ benefit.name }}
										</view>
										<view class="text-white/80 text-[22rpx] leading-tight line-clamp-2">
											{{ benefit.desc }}
										</view>
									</view>

									<!-- 装饰元素 -->
									<view
										class="absolute bottom-0 right-0 w-24 h-24 rounded-tl-[60rpx] bg-gradient-to-tr from-[#B0976A]/5 to-transparent opacity-30">
									</view>
									<!-- 光点装饰 -->

									<!-- 卡片流光效果 -->
									<view
										class="absolute inset-0 bg-gradient-to-r from-transparent via-white/5 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-1500 ease-in-out">
									</view>
								</view>
							</view>
						</view>
					</view>

					<!-- 信息说明部分 - 优化样式 -->
					<view
						class="mt-6 p-4 bg-gradient-to-br from-[#0A0F14]/90 to-[#0A0F14]/70 rounded-xl shadow-sm relative overflow-hidden border border-[#B0976A]/10">
						<!-- 装饰元素 -->
						<view
							class="absolute top-0 right-0 w-24 h-24 rounded-bl-full bg-gradient-to-bl from-[#ECCB87]/10 to-transparent opacity-40">
						</view>
						<view
							class="absolute -bottom-6 -left-6 w-24 h-24 rounded-tr-full bg-gradient-to-tr from-[#ECCB87]/10 to-transparent opacity-30">
						</view>

						<view class="flex items-center relative z-1">
							<view
								class="info-icon-bg bg-gradient-to-r from-[#ECCB87] to-[#B0976A] p-1.5 rounded-full shadow-md">
								<u-icon name="info-circle" color="white" size="16"></u-icon>
							</view>
							<text class="text-[28rpx] text-[#ECCB87] font-medium ml-2">{{ config.name }}说明</text>
						</view>

						<view class="flex items-start mt-2 relative z-1">
							<view
								class="w-0.5 h-full bg-gradient-to-b from-[#ECCB87] to-[#B0976A] rounded-full mr-2 self-stretch opacity-60 mt-1">
							</view>
							<text class="text-[22rpx] text-white/80 leading-6">{{ config.name
							}}可以用于数字人形象克隆、创作视频、声音克隆、智能体对话等场景。不同场景的{{ config.name }}消耗也不同，具体消耗请以实际为准，{{ config.name
								}}充值成功后不可提现、转账。</text>
						</view>
					</view>
				</view>
			</mescroll-body>
		</view>

		<!-- 底部导航区域 - 独立于内容区的固定定位 -->
		<view class="fixed bottom-0 left-0 right-0 z-20">
			<!-- 导航背景 - 增加渐变和模糊效果 -->
			<view
				class="footer-bg absolute inset-0 bg-gradient-to-b from-[#050A12] to-[#091018] backdrop-blur-md border-t border-[#B0976A]/15">
			</view>

			<view class="pt-[14rpx] pb-[20rpx] px-[20rpx] relative z-10">
				<view class="flex items-center ml-2">
					<checkbox-group class="flex items-center uni-list" @change="checkboxChange">
						<u-checkbox v-model="isOpenAgreement" shape="circle" :name="true" size="22"
							activeColor="#B0976A" @change="checkboxChange"></u-checkbox>
						<view
							class="ml-1 text-white/80 hover:text-gray-300 active:text-gray-400 inline-flex items-center text-[22rpx]"
							role="button" tabindex="0">
							阅读并同意
							<span @click="redirect({ url: '/app/pages/auth/agreement?key=ai_humans_privacy' })"
								class="text-[22rpx] mx-1"
								style="background: linear-gradient(to right, #ECCB87, #B0976A); -webkit-background-clip: text; color: transparent;">
								《隐私条款》
							</span>和
							<span @click="redirect({ url: '/app/pages/auth/agreement?key=ai_humans_service' })"
								class="text-[22rpx] mx-1"
								style="background: linear-gradient(to right, #ECCB87, #B0976A); -webkit-background-clip: text; color: transparent;">
								《服务协议》
							</span>
						</view>
					</checkbox-group>
				</view>

				<!-- 底部价格和按钮 - 优化样式 -->
				<view class="flex items-center justify-between mx-2 mt-2">
					<view class="flex base-inline items-end">
						<view class="flex items-baseline">
							<text class="text-[#ECCB87] text-[22rpx] mr-1">¥</text>
							<text class="text-[#ECCB87] text-[42rpx] font-bold"
								style="font-family: 'DIN Condensed', Arial, sans-serif; text-shadow: 0 2px 5px rgba(0,0,0,0.15);">
								{{ getCurrentPrice() }}
							</text>
						</view>
						<text class="text-white/40 text-[20rpx] line-through ml-2">¥{{ getCurrentOriginalPrice()
						}}</text>
					</view>

					<view class="relative">
						<!-- 立即购买按钮 - 增强效果 -->
						<button hover-class="none"
							class="h-[78rpx] leading-[78rpx] rounded-[20rpx] text-[26rpx] font-bold text-[#1E1E1E] w-[220rpx] relative overflow-hidden transform transition-transform duration-300 active:scale-95"
							style="background: linear-gradient(135deg, #ECCB87, #B0976A);"
							@click="submitOrder(getCurrentItem())">

							<!-- 按钮金属质感 -->
							<view class="metal-texture"></view>
							<view class="metal-highlight"></view>

							<view
								class="absolute inset-0 bg-black/10 opacity-0 hover:opacity-100 transition-opacity duration-300">
							</view>
							<view
								class="absolute inset-0 bg-gradient-to-r from-transparent via-white/30 to-transparent -translate-x-full animate-[shine_3s_infinite]">
							</view>
							<text class="relative z-10 tracking-wider">立即购买</text>
						</button>

						<!-- 按钮装饰光效 -->
						<view
							class="absolute -inset-[2rpx] bg-gradient-to-r from-[#ECCB87]/40 to-[#B0976A]/40 rounded-[24rpx] blur-md -z-10 opacity-70">
						</view>
					</view>
				</view>
			</view>
		</view>
		<pay ref="payRef" @close="payLoading = false"></pay>
	</view>
</template>

<script setup lang="ts">
import { ref, computed, reactive, watch } from 'vue';
import { img, redirect } from '@/utils/common';
import { createPackageOrder } from '@/addon/ai_humans/api/order';
import { getPackageList } from '@/addon/ai_humans/api/package';
import MescrollBody from '@/components/mescroll/mescroll-body/mescroll-body.vue';
import MescrollEmpty from '@/components/mescroll/mescroll-empty/mescroll-empty.vue';
import useMescroll from '@/components/mescroll/hooks/useMescroll.js';
import { onLoad, onPageScroll, onReachBottom } from '@dcloudio/uni-app';
import useDiyStore from '@/app/stores/diy'
const isOpenAgreement = ref(false);
const checkboxChange = (e) => {
	if (isOpenAgreement.value == true) {
		isOpenAgreement.value = false;
	} else {
		isOpenAgreement.value = true;
	}
};
const { mescrollInit, downCallback, getMescroll } = useMescroll(onPageScroll, onReachBottom);
import { useShare } from '@/hooks/useShare'
import { getConfig } from '@/addon/ai_humans/api/config';
const config = ref<any>({});
getConfig().then((res) => {
	config.value = res.data;
})
const { setShare, onShareAppMessage, onShareTimeline } = useShare()
let list = ref<Array<any>>([]);
let loading = ref<boolean>(false);
const currentIndex = ref(0);
setShare();
onShareAppMessage()
onShareTimeline()
const payRef = ref(null)
const payLoading = ref(false)
const type = ref('vip');

// 添加主题样式计算属性
const themeStyles = computed(() => {
	const diyStore = useDiyStore();
	return diyStore?.themeColor ? diyStore.themeColor() : '';
});

// 为每张卡片分配不同的背景渐变色
const getCardClass = (index: number) => {
	const classes = ['card-gradient-1', 'card-gradient-2', 'card-gradient-3'];
	return classes[index % classes.length];
};

// 会员权益数据
const benefits = reactive([
	{
		icon: 'clock',
		title: '视频合成时长',
		desc: '约66分钟'
	},
	{
		icon: 'mic',
		title: '声音高保真克隆',
		desc: '还原口音,说话风格'
	},
	{
		icon: 'account',
		title: '数字形象',
		desc: '无限生成'
	},
	{
		icon: 'people',
		title: '邀请好友加入',
		desc: '好友充值我获益'
	}
])

// 选择套餐
const selectPackage = (index: number) => {
	currentIndex.value = index;
};

// 滑动切换事件
const swiperChange = (e: any) => {
	currentIndex.value = e.detail.current;
};

// 判断是否为推荐套餐
const isRecommended = (item: any) => {
	// 可以根据特定条件判断是否为推荐套餐
	return item.recommend === 1;
};

// 根据价格计算赠送积分
const getPoints = (price: string | number) => {
	// 根据价格设置不同的积分赠送规则
	const priceNum = parseFloat(price as string);
	if (priceNum <= 10) return 750;
	if (priceNum <= 100) return 8000;
	return 40000;
};

// 获取当前选中的价格
const getCurrentPrice = () => {
	if (list.value.length === 0) return '0.00';
	return list.value[currentIndex.value]?.price || '0.00';
};

// 获取当前选中的原价
const getCurrentOriginalPrice = () => {
	if (list.value.length === 0) return '0.00';
	return list.value[currentIndex.value]?.origin_price || '0.00';
};

// 获取当前选中的套餐
const getCurrentItem = () => {
	if (list.value.length === 0) return null;
	return list.value[currentIndex.value];
};

//支付
const submitOrder = async (e: any) => {
	if (!e) {
		uni.$u.toast('请选择套餐');
		return;
	}
	if (!isOpenAgreement.value) {
		uni.$u.toast('请阅读并同意《隐私条款》和《服务协议》');
		return;
	}
	try {
		const res = await createPackageOrder({ package_id: e.id, price: e.price });
		if (res.data.type == 'success') {
			redirect({ url: '/addon/ai_humans/pages/package/order' });
			uni.$u.toast('购买成功');
			return;
		}
		payLoading.value = true;
		payRef.value?.open(res.data.trade_type, res.data.trade_id, '/addon/ai_humans/pages/package/order');
	} catch (error) {
		console.error('提交订单失败:', error);
		uni.$u.toast('提交订单失败，请重试');
	}
};



// 切换套餐类型
const sectionChange = (item: any) => {
	type.value = item.type;
	currentIndex.value = 0;
	reload();
};

const reload = () => {
	getMescroll().resetUpScroll();
};

const getPackageListFn = (mescroll: any) => {
	loading.value = false;
	let data = {
		page: mescroll.num,
		limit: mescroll.size,
		type: type.value
	};

	console.log('正在获取套餐列表，参数:', data);

	getPackageList(data).then((res) => {
		console.log('获取套餐列表成功:', res.data);

		let newArr = (res.data.data || []);

		//设置列表数据
		if (mescroll.num == 1) {
			list.value = []; //如果是第一页需手动制空列表
		}

		// 确保数据结构正确
		if (Array.isArray(newArr)) {
			list.value = list.value.concat(newArr);
		} else {
			console.error('套餐数据格式异常:', newArr);
		}

		currentIndex.value = 0; // 重置为第一个套餐
		mescroll.endSuccess(newArr.length);
		loading.value = true;

		console.log('处理后的列表:', list.value);
	}).catch((err) => {
		console.error('获取套餐列表失败:', err);
		loading.value = true;
		mescroll.endErr(); // 请求失败, 结束加载
	});
};

// 监听列表变化
watch(list, (newVal) => {
	console.log('列表数据已更新, 长度:', newVal.length);
	if (newVal.length > 0 && currentIndex.value >= newVal.length) {
		currentIndex.value = 0;
	}
}, { deep: true });

onLoad((options) => {
	console.log('页面加载, 参数:', options);
	if (options?.mid) {
		// getShareGive(options.mid);
		console.log('分享ID:', options.mid);
	}
});
</script>

<style lang="scss" scoped>
@import '@/addon/ai_humans/utils/styles/common.scss';

@keyframes float {

	0%,
	100% {
		transform: translateY(0) rotate(0);
	}

	50% {
		transform: translateY(-15rpx) rotate(5deg);
	}
}

@keyframes pulse-glow {

	0%,
	100% {
		opacity: 0.3;
		transform: scale(1);
	}

	50% {
		opacity: 0.8;
		transform: scale(1.5);
	}
}

@keyframes pulse-slow {
	0% {
		opacity: 0.3;
		transform: scale(0.95);
	}

	100% {
		opacity: 0.6;
		transform: scale(1.05);
	}
}

@keyframes shine {
	0% {
		left: -100%;
	}

	100% {
		left: 100%;
	}
}

@keyframes flow-x {

	0%,
	100% {
		transform: translateX(-100%);
		opacity: 0;
	}

	50% {
		transform: translateX(100%);
		opacity: 1;
	}
}

@keyframes flow-y {

	0%,
	100% {
		transform: translateY(-100%);
		opacity: 0;
	}

	50% {
		transform: translateY(100%);
		opacity: 1;
	}
}

@keyframes ping {
	0% {
		transform: scale(0.8);
		opacity: 0.8;
	}

	70%,
	100% {
		transform: scale(1.5);
		opacity: 0;
	}
}

// 新增金属质感卡片效果
.card-gradient-1 {
	background-image: linear-gradient(135deg, #0A0F14 0%, #1C3144 50%, #0A0F14 100%);
	box-shadow: inset 0 1px 1px rgba(255, 255, 255, 0.05),
		inset 0 -1px 1px rgba(0, 0, 0, 0.3);
}

.card-gradient-2 {
	background-image: linear-gradient(135deg, #0A0A1C 0%, #152C5B 50%, #0A0A1C 100%);
	box-shadow: inset 0 1px 1px rgba(255, 255, 255, 0.05),
		inset 0 -1px 1px rgba(0, 0, 0, 0.3);
}

.card-gradient-3 {
	background-image: linear-gradient(135deg, #120D16 0%, #2D1D36 50%, #120D16 100%);
	box-shadow: inset 0 1px 1px rgba(255, 255, 255, 0.05),
		inset 0 -1px 1px rgba(0, 0, 0, 0.3);
}

.class-select {
	position: relative;
	font-weight: bold;

	&::after {
		content: "";
		position: absolute;
		bottom: 0;
		height: 6rpx;
		background-color: var(--primary-color);
		width: 90%;
		left: 50%;
		transform: translateX(-50%);
		border-radius: 6rpx;
	}
}

.package-carousel {
	overflow: hidden;
	padding: 10rpx 0;
	perspective: 1000rpx;
}

.package-card {
	width: 650rpx;
	height: 280rpx;
	position: relative;
	border-radius: 24rpx;
	transform: scale(0.9);
	transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
	overflow: hidden;
	box-shadow: 0 8rpx 30rpx rgba(0, 0, 0, 0.15);
	backdrop-filter: blur(10rpx);
	border: 1rpx solid rgba(255, 255, 255, 0.1);
}

.package-card-active {
	transform: scale(1) translateZ(20rpx);
	box-shadow: 0 15rpx 40rpx rgba(var(--primary-color-rgb), 0.3);
}

.package-card-inner {
	position: relative;
	width: 100%;
	height: 100%;
	padding: 24rpx;
	overflow: hidden;
	z-index: 1;
}

.card-decoration-circle {
	position: absolute;
	width: 300rpx;
	height: 300rpx;
	border-radius: 50%;
	background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, rgba(255, 255, 255, 0) 70%);
	bottom: -150rpx;
	right: -150rpx;
	z-index: -1;
	animation: rotate 20s linear infinite;
}

.circle-2 {
	width: 200rpx;
	height: 200rpx;
	top: -100rpx;
	left: -100rpx;
	background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, rgba(255, 255, 255, 0) 70%);
	animation: rotate 15s linear infinite reverse;
}

@keyframes rotate {
	from {
		transform: rotate(0deg);
	}

	to {
		transform: rotate(360deg);
	}
}

.card-sparkle {
	position: absolute;
	width: 100rpx;
	height: 100rpx;
	border-radius: 50%;
	background: radial-gradient(circle, rgba(255, 255, 255, 0.9) 0%, rgba(255, 255, 255, 0) 70%);
	top: 20rpx;
	right: 40rpx;
	opacity: 0;
	filter: blur(5rpx);
	animation: sparkle 3s infinite ease-in-out;
}

.sparkle-2 {
	width: 60rpx;
	height: 60rpx;
	left: 60rpx;
	bottom: 30rpx;
	animation-delay: 1.5s;
}

@keyframes sparkle {
	0% {
		opacity: 0;
		transform: scale(0.8) translateY(10rpx);
	}

	50% {
		opacity: 0.5;
		transform: scale(1.2) translateY(0);
	}

	100% {
		opacity: 0;
		transform: scale(0.8) translateY(10rpx);
	}
}

.indicator-dot {
	width: 14rpx;
	height: 14rpx;
	border-radius: 50%;
	background: rgba(var(--primary-color-rgb), 0.3);
	transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
	position: relative;
	overflow: hidden;
}

.indicator-active {
	width: 28rpx;
	background: linear-gradient(90deg, var(--primary-color), var(--primary-help-color));
	border-radius: 100rpx;
	box-shadow: 0 2rpx 8rpx rgba(var(--primary-color-rgb), 0.4);
}

.indicator-active::after {
	content: "";
	position: absolute;
	top: 0;
	left: -100%;
	width: 100%;
	height: 100%;
	background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
	animation: shine 2s infinite;
}

@keyframes shine {
	to {
		left: 100%;
	}
}

.card-chip {
	width: 40rpx;
	height: 30rpx;
	background: rgba(255, 255, 255, 0.2);
	border-radius: 4rpx;
	position: relative;
	overflow: hidden;
	box-shadow: 0 0 6rpx rgba(255, 255, 255, 0.3);
}

.chip-lines {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-image: repeating-linear-gradient(90deg,
			rgba(255, 255, 255, 0),
			rgba(255, 255, 255, 0) 20rpx,
			rgba(255, 255, 255, 0.03) 20rpx,
			rgba(255, 255, 255, 0.03) 40rpx);
	z-index: -1;
}

.recommend-tag {
	background-color: rgba(255, 255, 255, 0.2);
	padding: 4rpx 16rpx;
	border-radius: 100rpx;
	backdrop-filter: blur(5rpx);
	box-shadow: 0 0 10rpx rgba(255, 255, 255, 0.2);
}

.dot {
	width: 6rpx;
	height: 6rpx;
	background-color: rgba(255, 255, 255, 0.7);
	border-radius: 50%;
	margin-right: 8rpx;
}

.indicator-dot {
	width: 14rpx;
	height: 14rpx;
	border-radius: 50%;
	background-color: #ddd;
	transition: all 0.3s;
}

.indicator-active {
	width: 28rpx;
	background: linear-gradient(90deg, var(--primary-color), var(--primary-help-color));
	border-radius: 100rpx;
}

.info-icon-bg {
	width: 40rpx;
	height: 40rpx;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
}

.hover-scale {
	transition: all 0.2s;

	&:active {
		transform: scale(0.95);
	}
}

.benefit-icon {
	width: 60rpx;
	height: 60rpx;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	box-shadow: 0 4rpx 8rpx rgba(0, 0, 0, 0.15);
}

// 金色主题优化
// 高端金色渐变定义 - 适用于高端质感
.benefit-icon-1 {
	background: linear-gradient(135deg, #AD9966, #8A7955);
}

.benefit-icon-2 {
	background: linear-gradient(135deg, #CBBA83, #9F8A60);
}

.benefit-icon-3 {
	background: linear-gradient(135deg, #D0C096, #AA9467);
}

.benefit-icon-4 {
	background: linear-gradient(135deg, #B8A47A, #907B58);
}

// 权益图标光晕效果
.benefit-glow-1 {
	background: radial-gradient(circle, rgba(201, 174, 130, 0.5) 0%, rgba(201, 174, 130, 0) 70%);
}

.benefit-glow-2 {
	background: radial-gradient(circle, rgba(203, 186, 131, 0.5) 0%, rgba(203, 186, 131, 0) 70%);
}

.benefit-glow-3 {
	background: radial-gradient(circle, rgba(208, 192, 150, 0.5) 0%, rgba(208, 192, 150, 0) 70%);
}

.benefit-glow-4 {
	background: radial-gradient(circle, rgba(184, 164, 122, 0.5) 0%, rgba(184, 164, 122, 0) 70%);
}

// 金属质感增强
@keyframes soft-shimmer {

	0%,
	100% {
		opacity: 0;
	}

	50% {
		opacity: 0.5;
	}
}

// 增强金属质感
.metal-texture {
	position: absolute;
	inset: 0;
	background-image: repeating-linear-gradient(45deg,
			rgba(236, 203, 135, 0),
			rgba(236, 203, 135, 0.03) 1px,
			rgba(236, 203, 135, 0) 2px);
	opacity: 0.4;
	pointer-events: none;
	z-index: 5;
	mix-blend-mode: overlay;
}

// 增强金属高光效果
.metal-highlight {
	position: absolute;
	inset: 0;
	background: linear-gradient(90deg,
			rgba(236, 203, 135, 0) 0%,
			rgba(236, 203, 135, 0.1) 25%,
			rgba(236, 203, 135, 0.1) 75%,
			rgba(236, 203, 135, 0) 100%);
	opacity: 0;
	z-index: 6;
	animation: soft-shimmer 8s infinite;
	pointer-events: none;
}

/* 科技感背景效果 - 修改为不影响底部导航 */
.tech-bg {
	background: linear-gradient(135deg, #050A12 0%, #091018 40%, #0A1A26 70%, #050A12 100%);
	position: fixed;
	/* 修改为fixed以确保全屏但不滚动 */
	width: 100%;
	height: 100%;
	overflow: hidden;
	isolation: isolate;
	z-index: 0;
	/* 底层z-index */
}

/* 科技网格 */
.tech-grid {
	background-image:
		linear-gradient(rgba(176, 151, 106, 0.05) 1px, transparent 1px),
		linear-gradient(90deg, rgba(176, 151, 106, 0.05) 1px, transparent 1px);
	background-size: 30px 30px;
	opacity: 0.25;
	/* 降低不透明度以减少视觉干扰 */
	z-index: 1;
}

.tech-grid::before {
	content: '';
	position: absolute;
	inset: 0;
	background-image:
		linear-gradient(rgba(0, 90, 190, 0.02) 2px, transparent 2px),
		linear-gradient(90deg, rgba(0, 90, 190, 0.02) 2px, transparent 2px);
	background-size: 120px 120px;
	background-position: -1px -1px;
}

.tech-grid::after {
	content: '';
	position: absolute;
	inset: 0;
	background-image: radial-gradient(circle at 30% 20%, rgba(0, 90, 190, 0.08) 0%, transparent 70%);
}

/* 科技点阵 - 降低明显程度 */
.tech-dots {
	background-image: radial-gradient(rgba(176, 151, 106, 0.25) 1px, transparent 1px);
	background-size: 40px 40px;
	opacity: 0.08;
	z-index: 1;
}

/* 光束效果 - 微调位置避开底部 */
.tech-beam {
	width: 2px;
	height: 400rpx;
	/* 减少高度，避免触碰底部 */
	background: linear-gradient(to bottom, transparent, rgba(0, 120, 255, 0.08), transparent);
	filter: blur(5px);
	opacity: 0.4;
	z-index: 1;
	animation: beam-float 15s ease-in-out infinite alternate;
}

/* 确保卡片内容区域有合适的z-index */
.package-carousel,
.swiper,
.benefit-item,
.info-container {
	position: relative;
	z-index: 5;
	/* 确保内容在网格上方 */
}

/* 底部导航额外样式 */
.footer {
	position: relative;
	z-index: 10;
	/* 确保始终在最上层 */
	/* 添加一点微妙的阴影分隔效果 */
	box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.3);
}

@keyframes beam-float {

	0%,
	100% {
		transform: translateY(-5%) rotate(5deg) scale(1);
		opacity: 0.3;
	}

	50% {
		transform: translateY(5%) rotate(-2deg) scale(1.5);
		opacity: 0.5;
	}
}

/* 添加全局的光晕悬停效果 */
.hover-glow {
	position: relative;
}

.hover-glow:before {
	content: '';
	position: absolute;
	inset: -5px;
	background: radial-gradient(circle, rgba(176, 151, 106, 0.2), transparent 70%);
	opacity: 0;
	transition: opacity 0.3s ease;
	border-radius: inherit;
	z-index: -1;
}

.hover-glow:hover:before {
	opacity: 1;
}

/* 底部导航增强样式 */
.footer-bg {
	box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.4);
	/* 增强阴影效果 */
	opacity: 0.95;
	/* 稍微透明以融合科技背景 */
}

/* 调整内容区域，确保不被底部导航遮挡 */
.mescroll-body {
	padding-bottom: calc(env(safe-area-inset-bottom) + 120rpx);
}

/* 奢华标签相关动画 */
@keyframes subtle-shimmer {

	0%,
	100% {
		opacity: 0.2;
		background-position: 0% 50%;
	}

	50% {
		opacity: 0.6;
		background-position: 100% 50%;
	}
}

@keyframes soft-glow {

	0%,
	100% {
		opacity: 0;
		box-shadow: 0 0 5px rgba(236, 203, 135, 0);
	}

	50% {
		opacity: 0.5;
		box-shadow: 0 0 10px rgba(236, 203, 135, 0.4);
	}
}

@keyframes dot-twinkle {

	0%,
	100% {
		opacity: 0.3;
		transform: scale(0.8);
	}

	50% {
		opacity: 0.8;
		transform: scale(1.3);
	}
}

/* 奢华标签样式 */
.luxurious-tag {
	overflow: hidden;
	isolation: isolate;
}

.luxurious-tag .glow-effect {
	background: linear-gradient(90deg, rgba(236, 203, 135, 0.2), rgba(176, 151, 106, 0.4), rgba(236, 203, 135, 0.2));
	background-size: 200% 100%;
	animation: subtle-shimmer 4s infinite, soft-glow 6s infinite;
}

.luxurious-tag .shimmer-dot {
	animation: dot-twinkle 3s infinite ease-in-out;
}

.luxurious-tag:hover .glow-effect {
	opacity: 0.6;
	transition: opacity 0.3s ease;
}
</style>