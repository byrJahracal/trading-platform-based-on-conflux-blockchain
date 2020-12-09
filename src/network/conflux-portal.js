class ConfluxPortal {
  constructor(conflux) {
    if (typeof conflux === "undefined") {
      throw new Error("No Conflux detected");
    }
    if (!conflux.isConfluxPortal) {
      console.debug("Unknown Conflux.");
    }
    this.conflux = conflux;
  }

  async init() {
    this.accounts = await this.conflux.enable();
    this.contract = window.confluxJS.Contract({
      address: "0x86c13a2e09b220fd8d317fb5c2b1a41ac823a00c",
      abi: require("network/api.json")
    });
    console.log("Conflux portal enable success!");
  }

  getAccount() {
    if (!this.accounts) {
      throw new Error("Please enable Conflux Portal first");
    }
    return this.accounts[0];
  }
}

export default new ConfluxPortal(window.conflux);
