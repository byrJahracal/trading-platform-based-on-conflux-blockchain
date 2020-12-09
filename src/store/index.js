import { Conflux } from "js-conflux-sdk";
import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

var conflux = new Conflux({
  url: "https://wallet-test.confluxrpc.org",
  logger: console
});
var contract = conflux.Contract({
  address: "0x86c13a2e09b220fd8d317fb5c2b1a41ac823a00c",
  abi: require("network/api.json")
});
var account = conflux.wallet.addPrivateKey(
  "" //privateKey
);

export default new Vuex.Store({
  state: {
    conflux: conflux,
    contract: contract,
    account: account,
    currentUser: {
      name: "administrator"
    }
  },
  mutations: {},
  actions: {},
  modules: {}
});
