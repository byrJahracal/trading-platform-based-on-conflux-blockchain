import Vue from "vue";
import VueRouter from "vue-router";
const Bank = () => import("views/bank/bank");
const Compony = () => import("views/company/company");
const Administrator = () => import("views/administrator/administrator");
const Inquire = () => import("views/inquire/inquire");
Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    redirect: "/administrator"
  },
  {
    path: "/bank",
    component: Bank
  },
  {
    path: "/company",
    component: Compony
  },
  {
    path: "/administrator",
    component: Administrator
  },
  {
    path: "/inquire",
    component: Inquire
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

export default router;
