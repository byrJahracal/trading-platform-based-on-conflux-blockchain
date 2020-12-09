<template>
  <hy-card imgSrc="blockchain2.jpg">
    <div class="cardBody">
      <p title>Add a Company</p>
      <p title>添加公司</p>
      <div id="form">
        <div>
          name:
          <el-input placeholder="company1" v-model="name"> </el-input>
        </div>
        <div>
          companyType:
          <el-input placeholder="technical" v-model="companyType"> </el-input>
        </div>
        <div>
          <el-radio v-model="isTrustString" label="true"
            >Trusted Company</el-radio
          >
          <el-radio v-model="isTrustString" label="false"
            >Non-trusted Company</el-radio
          >
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
      isTrustString: "false"
    };
  },
  computed: {
    ...mapState(["conflux", "contract", "account", "currentUser"]),
    isTrust() {
      if (this.isTrustString == "true") {
        return true;
      } else {
        return false;
      }
    }
  },
  methods: {
    confirmButton() {
      if (this.name == "") {
        this.$alert("公司名称不能为空！", "提示", {
          confirmButtonText: "确定"
        });
      } else {
        var information = '确认新建名称为:"' + this.name + '"的公司吗?';
        this.$confirm(information, "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        })
          .then(() => {
            this.addCompany();
          })
          .catch(() => {
            this.$message({
              type: "warning",
              message: "发送申请失败!"
            });
          });
      }
    },
    async addCompany() {
      console.log(this.currentUser.name);
      const result = await this.contract
        .addCompany(this.name, this.companyType, this.isTrust)
        .sendTransaction({
          from: this.account
        });

      if (result) {
        this.$message({
          type: "success",
          message: "新建公司成功!"
        });
      } else {
        this.$message({
          type: "info",
          message: "新建公司失败!"
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
