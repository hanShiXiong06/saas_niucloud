<template>
	<view class="tool uni-row uni-center" ref="commentElement">
		<view class="zan uni-row uni-center" @click="dianzan">
			<uni-icons type="heart" color="#fff"></uni-icons>
			<text class="color-white font-14">赞</text>
		</view>
		<view class="comment uni-row uni-center" @click="pinglun">
			<uni-icons type="chat" color="#fff"></uni-icons>
			<text class="color-white font-14">评论</text>
		</view>
	</view>
</template>

<script setup lang="ts">
	import { reactive, ref, onMounted } from 'vue'
	const commentElement = ref(null);
	const commentToolStatus = ref(false);

	const dianzan = () => {
		hideCommentPopup();
		uni.showToast({ title: '点赞', icon: 'none' });
	};
	const pinglun = (e) => {
		hideCommentPopup();
		uni.$emit('commentScrollEvent', e.y);
		uni.showToast({ title: '评论', icon: 'none' });
	};
	const showCommentPopup = (y) => {
		if (!commentToolStatus.value) {
			const element = commentElement.value as HTMLElement;
			element.style.top = `${y}px`;
			element.style.width = '160px';
			element.style.opacity = '1';
			commentToolStatus.value = true;
		} else {
			hideCommentPopup();
		}
	};
	const hideCommentPopup = () => {
		if (!commentToolStatus.value) return;
		const element = commentElement.value as HTMLElement;
		element.style.width = '0px';
		element.style.opacity = '0';
		commentToolStatus.value = false;
	};
</script>

<style scoped lang="scss">
	.tool {
		position: absolute;
		right: 60px;
		z-index: 999;
		width: 110px;
		height: 35px;
		background-color: #666;
		border-radius: 3px;
		opacity: 0;
		transition-property: width, opacity;
		transition-duration: 100ms;

		.comment,
		.zan {
			width: 80px;
		}

		.zan {
			border-right: 0.5px solid #555;
		}
	}
</style>