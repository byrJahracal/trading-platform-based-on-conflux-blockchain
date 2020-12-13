import portal from "network/conflux-portal";
import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

//const users = require("./public.json");

export default new Vuex.Store({
  state: {
    conflux: null, //portal.conflux
    contract: null, //portal.contract
    account: null, //portal.getAccount()
    currentUser: {
      name: ""
    }
  },
  mutations: {
    initState(state) {
      state.conflux = portal.conflux;
      state.contract = portal.contract;
      state.account = portal.getAccount();
    }
  },
  actions: {
    init({ commit }) {
      portal
        .init()
        .then(() => {
          commit("initState");
        })
        .catch(err => {
          console.error(err);
        });
    }
  },
  modules: {}
});
