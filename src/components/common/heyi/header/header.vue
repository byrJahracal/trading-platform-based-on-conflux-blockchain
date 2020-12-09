<template>
  <div class="header" header>
    <img :src="icon" />
    <h3>{{ title }}</h3>
    <div id="slot"><slot name="right"></slot></div>
  </div>
</template>

<script>
export default {
  name: "HyHeader",
  props: {
    title: {
      default: "Hello World"
    },
    icon: null
  },
  components: {},
  data() {
    return {};
  },
  computed: {},
  methods: {}
};
</script>

<style scoped lang="scss">
.header {
  img {
    margin: 3px 7px;
    height: 44px;
    width: auto;
  }
  h3 {
    display: inline-block;
    margin: 3px 2px;
    font-size: 22px;
  }
  #slot {
    margin-left: auto;
  }
}
</style>
