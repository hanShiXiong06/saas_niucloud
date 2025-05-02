<template>
  <span class="text-[20px]">{{ hello_world_text }}</span>
</template>

<script lang="ts" setup>
import { ref } from 'vue'

const hello_world_text = ref('hello world')
</script>

<style lang="scss" scoped></style>
