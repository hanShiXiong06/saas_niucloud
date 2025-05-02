<template>
  <span class="text-[20px]">{{ hello_world_text }}123</span>
</template>

<script lang="ts" setup>
import { getHelloWorld } from '@/addon/running/api/hello_world'
import { ref } from 'vue'

const hello_world_text = ref('')
const getHelloWorldInfo = async () => {
  hello_world_text.value = await (await getHelloWorld()).data
}
getHelloWorldInfo()
</script>

<style lang="scss" scoped></style>
