<template>
  <div body-horizontal id="mainDiv">
    <company-info></company-info>
    <credit></credit>
    <num></num>
  </div>
</template>

<script>
import CompanyInfo from "./company-info.vue";
import Credit from "./credit.vue";
import Num from "./num.vue";

export default {
  components: { CompanyInfo, Credit, Num },
  props: {},
  data() {
    return {};
  },
  computed: {},
  methods: {}
};
</script>

<style scoped lang="scss">
#mainDiv {
  flex-wrap: wrap;
}
</style>
