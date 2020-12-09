<template>
  <div id="app">
    <hy-header
      icon="chain.png"
      title="Financial Supply Chain Trading Platform Based on Conflux Blockchain"
    >
      <div slot="right">
        {{ currentUser.name }}
      </div>
    </hy-header>
    <div body-horizontal>
      <hy-menu></hy-menu>
      <div main>
        <router-view></router-view>
      </div>
    </div>
    <hy-footer></hy-footer>
  </div>
</template>

<script>
import HyFooter from "components/content/hy-footer";
import { mapState } from "vuex";
import HyMenu from "./components/content/hy-menu";
export default {
  name: "App",
  components: {
    HyFooter,
    HyMenu
  },
  computed: {
    ...mapState(["currentUser"])
  },
  method: {}
};
</script>

<style lang="scss">
@import "assets/css/base.css";
@import "assets/css/heyi/heyi.scss";
</style>
