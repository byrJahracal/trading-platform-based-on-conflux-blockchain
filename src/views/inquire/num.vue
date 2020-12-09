<template>
  <hy-card imgSrc="blockchain2.jpg">
    <div class="cardBody">
      <p title>Check the Total Number of Banks and Companies</p>
      <p title>查询银行和公司总数</p>
      <div id="form">
        <div class="infoDiv" comment v-if="isQuired">
          The Total Number of Banks
        </div>
        <div class="infoDiv" comment v-if="isQuired">
          (银行总数):{{ bankNum }}
        </div>
        <div class="infoDiv" comment v-if="isQuired">
          The Total Number of Companies
        </div>
        <div class="infoDiv" comment v-if="isQuired">
          (公司总数):{{ companyNum }}
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
      companyNum: "",
      bankNum: "",
      isQuired: false
    };
  },
  computed: {
    ...mapState(["conflux", "contract", "account", "currentUser"])
  },
  methods: {
    confirmButton() {
      this.getNum();
    },
    getNum() {
      this.contract
        .getBankNum()
        .then(result => {
          this.bankNum = result[0];
        })
        .catch(err => {
          console.error(err);
          this.$message({
            type: "info",
            message: "查询失败!"
          });
        });
      this.contract
        .getCompanyNum()
        .then(result => {
          this.companyNum = result[0];
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
