<template>
  <div body-horizontal id="mainDiv">
    <give-credit-to-company></give-credit-to-company>
    <repaid></repaid>
    <finish></finish>
  </div>
</template>

<script>
import Finish from "./finish.vue";
import GiveCreditToCompany from "./give-credit-to-company.vue";
import Repaid from "./repaid.vue";
export default {
  components: { GiveCreditToCompany, Repaid, Finish },
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
  background-image: url("/background.jpg");
}
</style>
