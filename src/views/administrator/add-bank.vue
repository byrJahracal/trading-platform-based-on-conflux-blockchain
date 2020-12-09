<template>
  <hy-card imgSrc="blockchain1.jpg">
    <div class="cardBody">
      <p title>Add a Bank</p>
      <p title>添加银行</p>
      <div id="form">
        <div>
          Name:
          <el-input placeholder="bank1" v-model="name"> </el-input>
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
      name
    };
  },
  computed: {
    ...mapState(["conflux", "contract", "account", "currentUser"])
  },
  methods: {
    confirmButton() {
      if (this.name == "") {
        this.$alert("银行名称不能为空！", "提示", {
          confirmButtonText: "确定"
        });
      } else {
        var information = '确认新建名称为:"' + this.name + '"的银行吗?';
        this.$confirm(information, "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        })
          .then(() => {
            this.addBank();
          })
          .catch(() => {
            this.$message({
              type: "warning",
              message: "发送申请失败!"
            });
          });
      }
    },
    addBank() {
      this.contract
        .addBank(this.name)
        .sendTransaction({
          from: this.account
        })
        .then(result => {
          this.$message({
            type: "success",
            message: "新建银行成功!"
          });
          console.log(result);
        })
        .catch(err => {
          this.$message({
            type: "info",
            message: "新建银行失败!"
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
