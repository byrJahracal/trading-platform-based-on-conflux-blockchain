import portal from "network/conflux-portal";
import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    conflux: null, //portal.conflux
    contract: null, //portal.contract
    account: null, //portal.getAccount()
    currentUser: {
      name: "administrator"
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
