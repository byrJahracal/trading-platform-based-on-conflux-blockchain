<template>
  <div body-horizontal id="mainDiv">
    <add-bank></add-bank>
    <add-company></add-company>
  </div>
</template>

<script>
import AddBank from "./add-bank";
import AddCompany from "./add-company.vue";
export default {
  components: { AddBank, AddCompany },
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
