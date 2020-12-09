<template>
  <hy-card imgSrc="blockchain1.jpg">
    <div class="cardBody">
      <p title>Grant Credit Assets to Other Companies</p>
      <p title>向其他公司转移信用额度</p>
      <div id="form">
        <div>
          SenderCompanyName:
          <el-input placeholder="companyNameA" v-model="companyNameA">
          </el-input>
        </div>
        <div>
          ReceiverCompanyName:
          <el-input placeholder="companyNameB" v-model="companyNameB">
          </el-input>
        </div>
        <div>
          CreditAmount:
          <el-input placeholder="100" v-model="creditAmount"> </el-input>
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
      companyNameA: "",
      companyNameB: "",
      creditAmount: 0
    };
  },
  computed: {
    ...mapState(["conflux", "contract", "account", "currentUser"])
  },
  methods: {
    confirmButton() {
      if (this.companyNameA == "") {
        this.$alert("公司名称不能为空！", "提示", {
          confirmButtonText: "确定"
        });
      } else if (this.companyNameB == "") {
        this.$alert("公司名称不能为空！", "提示", {
          confirmButtonText: "确定"
        });
      } else if (this.creditAmount <= 0) {
        this.$alert("转移信用额度不能小于1", "提示", {
          confirmButtonText: "确定"
        });
      } else {
        var information =
          '公司"' +
          this.companyNameA +
          '"确认转移信用额度"' +
          String(this.creditAmount) +
          '"到公司"' +
          this.companyNameB +
          '"吗?';
        this.$confirm(information, "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        })
          .then(() => {
            this.companyA_giveCreditAssetTo_companyB();
          })
          .catch(() => {
            this.$message({
              type: "warning",
              message: "发送申请失败!"
            });
          });
      }
    },
    companyA_giveCreditAssetTo_companyB() {
      this.contract
        .companyA_giveCreditAssetTo_companyB(
          this.companyNameA,
          this.companyNameB,
          this.creditAmount
        )
        .sendTransaction({
          from: this.account
        })
        .then(result => {
          this.$message({
            type: "success",
            message: "信用额度转移成功!"
          });
          console.log(result);
        })
        .catch(err => {
          this.$message({
            type: "info",
            message: "信用额度转移失败!"
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
