<template>
  <div body-horizontal id="mainDiv">
    <give-credit></give-credit>
    <give-money></give-money>
  </div>
</template>

<script>
import GiveCredit from "./give-credit.vue";
import GiveMoney from "./give-money.vue";
export default {
  components: {
    GiveCredit,
    GiveMoney
  },
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
