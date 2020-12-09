<template>
  <hy-card imgSrc="blockchain4.jpg">
    <div class="cardBody">
      <p title>Pay Off the Debt to The Bank</p>
      <p title>向银行偿还债务</p>
      <div id="form">
        <div>
          companyName:
          <el-input placeholder="company1" v-model="companyName"> </el-input>
        </div>
        <div>
          bankName:
          <el-input placeholder="bank1" v-model="bankName"> </el-input>
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
        this.$alert("偿还资金不能小于1", "提示", {
          confirmButtonText: "确定"
        });
      } else {
        var information =
          '公司"' +
          this.companyName +
          '"确认偿还资金"' +
          String(this.moneyAmount) +
          '"到银行"' +
          this.bankName +
          '"吗?';
        this.$confirm(information, "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        })
          .then(() => {
            this.trustedCompany_repaidTo_bank();
          })
          .catch(() => {
            this.$message({
              type: "warning",
              message: "发送申请失败!"
            });
          });
      }
    },
    trustedCompany_repaidTo_bank() {
      this.contract
        .trustedCompany_repaidTo_bank(
          this.companyName,
          this.bankName,
          this.moneyAmount
        )
        .sendTransaction({
          from: this.account
        })
        .then(result => {
          this.$message({
            type: "success",
            message: "资金偿还成功!"
          });
          console.log(result);
        })
        .catch(err => {
          this.$message({
            type: "info",
            message: "资金偿还失败!"
          });
          console.error(err);
        });
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
