<template>
  <div class="zone">
    <el-input v-model="keyVal" :type="inputType" :autocomplete="false" />
    <el-button @click="flag = !flag" :icon="elIcon" circle />
  </div>
</template>

<script>
export default {
  data() {
    return {
      flag: false,
    };
  },
  props: {
    modelValue: {
      type: String,
      default: () => {
        return "";
      },
    },
  },
  computed: {
    keyVal: {
      get() {
        return this.modelValue;
      },
      set(value) {
        this.$emit("update:modelValue", value);
      },
    },
    inputType() {
      return this.flag ? "text" : "password";
    },
    elIcon() {
      return this.flag ? "Hide" : "View";
    },
  },
};
</script>
<style lang="scss" scoped>
.zone {
  display: flex;
  margin: 0 5px;
  min-width: 310px;
}
</style>
