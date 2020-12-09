<template>
  <hy-card imgSrc="blockchain1.jpg">
    <div class="cardBody">
      <p title>Inquire Company Information</p>
      <p title>查询公司信息</p>
      <div id="form">
        <div>
          CompanyName:
          <el-input placeholder="company1" v-model="name"> </el-input>
        </div>
        <div class="infoDiv" comment v-if="isQuired">
          Company Name(公司名称):{{ companyName }}
        </div>
        <div class="infoDiv" comment v-if="isQuired">
          Company Type(公司类型):{{ companyType }}
        </div>
        <div class="infoDiv" comment v-if="isQuired">
          Reputation(信誉情况):{{ isTrustString }}
        </div>
        <div class="infoDiv" comment v-if="isQuired">
          Credit Limit(信用额度):{{ ownedCredit }}
        </div>
        <div class="infoDiv" comment v-if="isQuired">
          Funds(现有资金):{{ ownedMoney }}
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
      name: "",
      companyType: "",
      companyName: "",
      isTrustString: "",
      ownedCredit: 0,
      ownedMoney: 0,
      isQuired: false
    };
  },
  computed: {
    ...mapState(["conflux", "contract", "account", "currentUser"])
  },
  methods: {
    confirmButton() {
      if (this.name == "") {
        this.$alert("公司名称不能为空！", "提示", {
          confirmButtonText: "确定"
        });
      } else {
        this.getCompanyInfoByName();
      }
    },
    getCompanyInfoByName() {
      this.contract
        .getCompanyInfoByName(this.name)
        .then(result => {
          this.companyName = result[0];
          this.companyType = result[1];
          this.isTrustString = result[2] ? "受信公司" : "非受信公司";
          this.ownedCredit = result[3][0];
          this.ownedMoney = result[4][0];
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
