<template>
    <!-- 内容 -->
    <div class="content-wrap" v-show="diyStore.editTab == 'content'">
        <div class="edit-attr-item-wrap">
            <h3 class="mb-[10px]">{{ t('graphicNavModeTitle') }}</h3>
            <el-form label-width="90px" class="px-[10px]">

                <el-form-item :label="t('layoutMode')">
                    <el-radio-group v-model="diyStore.editComponent.layout">
                        <el-radio :label="'horizontal'">{{ t('layoutModeHorizontal') }}</el-radio>
                        <el-radio :label="'vertical'">{{ t('layoutModeVertical') }}</el-radio>
                    </el-radio-group>
                </el-form-item>

                <el-form-item :label="t('graphicNavSelectMode')">
                    <el-radio-group v-model="diyStore.editComponent.mode">
                        <el-radio :label="'graphic'">{{ t('graphicNavModeGraphic') }}</el-radio>
                        <el-radio :label="'img'">{{ t('graphicNavModeImg') }}</el-radio>
                        <el-radio :label="'text'">{{ t('graphicNavModeText') }}</el-radio>
                    </el-radio-group>
                </el-form-item>

                <view v-show="diyStore.editComponent.layout == 'horizontal'">

                    <el-form-item :label="t('graphicNavPageCount')">
                        <el-radio-group v-model="diyStore.editComponent.pageCount" @change="changePageCount">
                            <el-radio :label="1">{{ t('singleLine') }}</el-radio>
                            <el-radio :label="2">{{ t('multiline') }}</el-radio>
                        </el-radio-group>
                    </el-form-item>

                    <el-form-item :label="t('graphicNavShowStyle')">
                        <el-radio-group v-model="diyStore.editComponent.showStyle" @change="changeShowStyle">
                            <el-radio :label="'fixed'">{{ t('graphicNavStyleFixed') }}</el-radio>
                            <el-radio :label="'singleSlide'">{{ diyStore.editComponent.pageCount == 2 ? t('graphicNavStyleMultiLine') : t('graphicNavStyleSingleSlide') }}</el-radio>
                            <el-radio :label="'pageSlide'">{{ t('graphicNavStylePageSlide') }}</el-radio>
                        </el-radio-group>
                    </el-form-item>

                    <el-form-item :label="t('graphicNavRowCount')">
                        <el-radio-group v-model="diyStore.editComponent.rowCount">
                            <el-radio :label="3">3{{ t('piece') }}</el-radio>
                            <el-radio :label="4">4{{ t('piece') }}</el-radio>
                            <el-radio :label="5">5{{ t('piece') }}</el-radio>
                        </el-radio-group>
                    </el-form-item>
                </view>
            </el-form>
        </div>
        <div class="edit-attr-item-wrap">
            <h3 class="mb-[10px]">{{ t('graphicNavSetLabel') }}</h3>
            <el-form label-width="90px" class="px-[10px]">

                <p class="text-sm text-gray-400 mb-[10px]">{{ t('graphicNavTips') }}</p>

                <div ref="imageBoxRef">
                    <div v-for="(item,index) in diyStore.editComponent.list" :key="item.id"
                         class="item-wrap p-[10px] pb-0 relative border border-dashed border-gray-300 mb-[16px]">
                        <el-form-item :label="t('image')" v-show="diyStore.editComponent.mode === 'graphic' || diyStore.editComponent.mode === 'img'">
                            <upload-image v-model="item.imageUrl" :limit="1" />
                        </el-form-item>

                        <el-form-item :label="t('graphicNavTitle')" v-show="diyStore.editComponent.mode === 'graphic' || diyStore.editComponent.mode === 'text'">
                            <el-input v-model.trim="item.title" :placeholder="t('graphicNavTitlePlaceholder')" clearable maxlength="20" show-word-limit />
                        </el-form-item>

                        <div class="del absolute cursor-pointer z-[2] top-[-8px] right-[-8px]"
                             v-show="diyStore.editComponent.list.length > 1"
                             @click="diyStore.editComponent.list.splice(index,1)">
                            <icon name="element CircleCloseFilled" color="#bbb" size="20px" />
                        </div>

                        <el-form-item :label="t('link')">
                            <diy-link v-model="item.link" />
                        </el-form-item>
                    </div>
                </div>

                <el-button v-show="diyStore.editComponent.list.length < 50" class="w-full" @click="addGraphicNav">
                    {{ t('addGraphicNav') }}
                </el-button>

            </el-form>
        </div>
    </div>

    <!-- 样式 -->
    <div class="style-wrap" v-show="diyStore.editTab == 'style'">
        <div class="edit-attr-item-wrap" v-show="['graphic','img'].includes(diyStore.editComponent.mode)">
            <h3 class="mb-[10px]">{{ t('graphicNavImageSet') }}</h3>
            <el-form label-width="90px" class="px-[10px]">
                <el-form-item :label="t('graphicNavImageSize')">
                    <el-slider v-model="diyStore.editComponent.imageSize" show-input size="small" class="ml-[10px] diy-nav-slider" :min="20" :max="60" />
                </el-form-item>
                <el-form-item :label="t('graphicNavAroundRadius')">
                    <el-slider v-model="diyStore.editComponent.aroundRadius" show-input size="small" class="ml-[10px] diy-nav-slider" :max="50" />
                </el-form-item>
            </el-form>
        </div>
        <div class="edit-attr-item-wrap" v-show="['graphic','text'].includes(diyStore.editComponent.mode)">
            <h3 class="mb-[10px]">{{ t('textSet') }}</h3>
            <el-form label-width="90px" class="px-[10px]">
                <el-form-item :label="t('textFontSize')">
                    <el-slider v-model="diyStore.editComponent.font.size" show-input size="small" class="ml-[10px] diy-nav-slider" :min="12" :max="16" />
                </el-form-item>
                <el-form-item :label="t('textFontWeight')">
                    <el-radio-group v-model="diyStore.editComponent.font.weight">
                        <el-radio :label="'normal'">{{ t('fontWeightNormal') }}</el-radio>
                        <el-radio :label="'bold'">{{ t('fontWeightBold') }}</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item :label="t('textColor')">
                    <el-color-picker v-model="diyStore.editComponent.font.color" show-alpha :predefine="diyStore.predefineColors" />
                </el-form-item>

            </el-form>
        </div>
        <div class="edit-attr-item-wrap" v-show="diyStore.editComponent.showStyle == 'pageSlide' && diyStore.editComponent.layout == 'horizontal'">
            <h3 class="mb-[10px]">{{ t('carouselSearchSwiperIndicatorSet') }}</h3>
            <el-form label-width="100px" class="px-[10px]">
                <el-form-item :label="t('carouselSearchSwiperIndicatorStyle')">
                    <el-radio-group v-model="diyStore.editComponent.swiper.indicatorStyle">
                        <el-radio label="style-1">{{ t('carouselSearchSwiperIndicatorStyle1') }}</el-radio>
                        <el-radio label="style-2">{{ t('carouselSearchSwiperIndicatorStyle2') }}</el-radio>
                        <el-radio label="style-3">{{ t('carouselSearchSwiperIndicatorStyle3') }}</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item :label="t('carouselSearchSwiperIndicatorAlign')">
                    <el-radio-group v-model="diyStore.editComponent.swiper.indicatorAlign">
                        <el-radio label="left">{{ t('alignLeft') }}</el-radio>
                        <el-radio label="center">{{ t('alignCenter') }}</el-radio>
                        <el-radio label="right">{{ t('alignRight') }}</el-radio>
                    </el-radio-group>
                </el-form-item>
                <el-form-item :label="t('noColor')">
                    <el-color-picker v-model="diyStore.editComponent.swiper.indicatorColor" show-alpha :predefine="diyStore.predefineColors" />
                </el-form-item>
                <el-form-item :label="t('selectColor')">
                    <el-color-picker v-model="diyStore.editComponent.swiper.indicatorActiveColor" show-alpha :predefine="diyStore.predefineColors" />
                </el-form-item>
            </el-form>
        </div>

        <!-- 组件样式 -->
        <slot name="style"></slot>

    </div>

</template>

<script lang="ts" setup>
import { ref, watch, onMounted, nextTick } from 'vue'
import { t } from '@/lang'
import Sortable from 'sortablejs'
import { img } from '@/utils/common'
import { range } from 'lodash-es'

import useDiyStore from '@/stores/modules/diy'

const diyStore = useDiyStore()
diyStore.editComponent.ignore = [] // 忽略公共属性
// 组件验证
diyStore.editComponent.verify = (index: number) => {
    const res = { code: true, message: '' }

    diyStore.value[index].list.forEach((item: any) => {
        if ((diyStore.value[index].mode === 'graphic' || diyStore.value[index].mode === 'img') && item.imageUrl === '') {
            res.code = false
            res.message = t('imageUrlTip')
            return res
        }
        if ((diyStore.value[index].mode === 'graphic' || diyStore.value[index].mode === 'text') && item.title === '') {
            res.code = false
            res.message = t('graphicNavTitlePlaceholder')
            return res
        }
    })
    return res
}

diyStore.editComponent.list.forEach((item: any) => {
    if (!item.id) item.id = diyStore.generateRandom()
})

watch(
    () => diyStore.editComponent.list,
    (newValue, oldValue) => {
        // 设置图片宽高
        diyStore.editComponent.list.forEach((item: any) => {
            const image = new Image()
            image.src = img(item.imageUrl)
            image.onload = async() => {
                item.imgWidth = image.width
                item.imgHeight = image.height
            }
        })
    },
    { deep: true }
)

const addGraphicNav = () => {
    diyStore.editComponent.list.push({
        id: diyStore.generateRandom(),
        title: '',
        imageUrl: '',
        imgWidth: 0,
        imgHeight: 0,
        link: { name: '' },
        label: {
            control: false,
            text: '热门',
            textColor: '#FFFFFF',
            bgColorStart: '#F83287',
            bgColorEnd: '#FE3423'
        }
    })
}

const imageBoxRef = ref()

onMounted(() => {
    nextTick(() => {
        const sortable = Sortable.create(imageBoxRef.value, {
            group: 'item-wrap',
            animation: 200,
            onEnd: event => {
                const temp = diyStore.editComponent.list[event.oldIndex!]
                diyStore.editComponent.list.splice(event.oldIndex!, 1)
                diyStore.editComponent.list.splice(event.newIndex!, 0, temp)
                sortable.sort(
                    range(diyStore.editComponent.list.length).map(value => {
                        return value.toString()
                    })
                )
            }
        })
    })
})

const changePageCount = (value: any) => {
    if (value == '1') {
        diyStore.editComponent.showStyle = 'singleSlide';
    } else if (value == '2') {
        diyStore.editComponent.showStyle = 'fixed';
    }
}

defineExpose({})

</script>

<style lang="scss" scoped>
.edit-graphic-nav {

    .item-wrap {
        .del {
            display: none;
        }

        &:hover {
            .del {
                display: block;
            }
        }
    }
}
</style>
