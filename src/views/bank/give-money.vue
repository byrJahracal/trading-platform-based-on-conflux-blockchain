<template>
  <hy-card imgSrc="blockchain4.jpg">
    <div class="cardBody">
      <p title>Grant Funds to a Company</p>
      <p title>向公司发放资金</p>
      <div id="form">
        <div>
          bankName:
          <el-input placeholder="bank1" v-model="bankName"> </el-input>
        </div>
        <div>
          companyName:
          <el-input placeholder="company1" v-model="companyName"> </el-input>
        </div>
        <div>
          moneyAmount:
          <el-input placeholder="100" v-model="moneyAmount"> </el-input>
        </div>
      </div>
      <div id="confirmDiv">
        <el-button @click="confirmButton()">submit</el-button>
      </div>
    </div>
  </hy-card>
</template>

<script>
import { mapState } from "vuex";
export default {
  components: {},
  props: {},
  data() {
    return {
      bankName: "",
      companyName: "",
      moneyAmount: 0
    };
  },
  computed: {
    ...mapState(["conflux", "contract", "account", "currentUser"])
  },
  methods: {
    confirmButton() {
      if (this.bankName == "") {
        this.$alert("银行名称不能为空！", "提示", {
          confirmButtonText: "确定"
        });
      } else if (this.companyName == "") {
        this.$alert("公司名称不能为空！", "提示", {
          confirmButtonText: "确定"
        });
      } else if (this.moneyAmount <= 0) {
        this.$alert("转移资金不能小于1", "提示", {
          confirmButtonText: "确定"
        });
      } else {
        var information =
          '银行"' +
          this.bankName +
          '"确认授予资金"' +
          String(this.moneyAmount) +
          '"到公司"' +
          this.companyName +
          '"吗?';
        this.$confirm(information, "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        })
          .then(() => {
            this.bank_giveRealMoneyTo_company();
          })
          .catch(() => {
            this.$message({
              type: "warning",
              message: "发送申请失败!"
            });
          });
      }
    },
    async bank_giveRealMoneyTo_company() {
      console.log(this.currentUser.name);
      const result = await this.contract
        .bank_giveRealMoneyTo_company(
          this.bankName,
          this.companyName,
          this.moneyAmount
        )
        .sendTransaction({
          from: this.account
        });

      if (result) {
        this.$message({
          type: "success",
          message: "资金授予成功!"
        });
      } else {
        this.$message({
          type: "info",
          message: "资金授予失败!"
        });
      }
    }
  }
};
</script>

<style scoped lang="scss">
.cardBody {
  padding-left: 8px;
  padding-top: 3px;
  padding-bottom: 5px;
}
#form {
  margin-top: 5px;
  margin-right: 10px;
  margin-bottom: 10px;
  > div {
    margin-top: 3px;
    line-height: 1.5;
  }
}
#confirmDiv {
  text-align: right;
  height: max-content;
  margin-bottom: 5px;
  padding-right: 10px;
}
</style>
