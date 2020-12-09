<template>
  <div id="footer" footer>
    <h5>Team: UMA-33-CulchainTech</h5>
    <img src="conflux-footer.png" />
    <h5>Members: Yuhang Liu, Wang Siyuan</h5>
  </div>
</template>

<script>
export default {
  created() {},
  components: {},
  data() {
    return {};
  },
  computed: {},
  methods: {}
};
</script>

<style scoped lang="scss">
#footer {
  img {
    width: auto;
    height: 90%;
  }
  max-height: 50px;
  margin-top: auto;
  overflow: hidden;
  flex-shrink: 0;
  display: flex;
  justify-content: space-around;
  align-items: center;
}
</style>
