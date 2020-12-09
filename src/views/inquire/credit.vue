<template>
  <hy-card imgSrc="blockchain3.jpg">
    <div class="cardBody">
      <p title>Check a Company's Credit Limit at a Bank</p>
      <p title>查询某公司在某银行的信用额度</p>

      <div id="form">
        <div>
          bankName:
          <el-input placeholder="bank1" v-model="bankName"> </el-input>
        </div>
        <div>
          companyName:
          <el-input placeholder="company1" v-model="companyName"> </el-input>
        </div>
        <div class="infoDiv" comment v-if="isQuired">
          Credit Limit
        </div>
        <div class="infoDiv" comment v-if="isQuired">
          (信用额度):{{ ownedCredit }}
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
      companyName: "",
      bankName: "",
      ownedCredit: 0,
      isQuired: false
    };
  },
  computed: {
    ...mapState(["conflux", "contract", "account", "currentUser"])
  },
  methods: {
    confirmButton() {
      if (this.companyName == "") {
        this.$alert("公司名称不能为空！", "提示", {
          confirmButtonText: "确定"
        });
      } else if (this.bankName == "") {
        this.$alert("银行名称不能为空！", "提示", {
          confirmButtonText: "确定"
        });
      } else {
        this.getAmountOfCreditAsset_bankGiveToTrustedCompany();
      }
    },
    getAmountOfCreditAsset_bankGiveToTrustedCompany() {
      this.contract
        .getAmountOfCreditAsset_bankGiveToTrustedCompany(
          this.bankName,
          this.companyName
        )
        .then(result => {
          this.ownedCredit = result[0];
          this.isQuired = true;
          this.$message({
            type: "success",
            message: "查询成功!"
          });
        })
        .catch(err => {
          console.error(err);
          this.$message({
            type: "info",
            message: "查询失败!"
          });
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
.infoDiv {
  padding: 3px;
  background-color: rgb(246, 255, 240);
  border: 1px solid rgba(255, 229, 156, 0.651);
  border-radius: 5px;
}
</style>
