import HeyiUI from "components/common/heyi/heyi-ui";
import ElementUI from "element-ui";
import "element-ui/lib/theme-chalk/index.css";
import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";

Vue.use(ElementUI);

Vue.use(HeyiUI);

Vue.config.productionTip = false;

store.dispatch("init");

new Vue({
  render: h => h(App),
  router,
  store: store
}).$mount("#app");
