<template>
  <div side id="menu">
    <el-menu
      heyi
      default-active="0"
      class="el-menu-vertical-demo"
      background-color="#545c64"
      text-color="#fff"
      active-text-color="#ffd04b"
      router
    >
      <el-menu-item index="/administrator">
        <i class="el-icon-view"></i>
        <span>Arbitration(仲裁)</span>
      </el-menu-item>
      <el-menu-item index="/bank">
        <i class="el-icon-s-home"></i>
        <span>Bank(银行)</span>
      </el-menu-item>
      <el-menu-item index="company">
        <i class="el-icon-s-cooperation"></i>
        <span>Company(公司)</span>
      </el-menu-item>
      <el-menu-item index="inquire">
        <i class="el-icon-zoom-in"></i>
        <span>Inquire(查询)</span>
      </el-menu-item>
    </el-menu>
  </div>
</template>

<script>
export default {
  components: {},
  data() {
    return {};
  },
  computed: {},
  methods: {}
};
</script>

<style scoped>
#menu {
  width: 200px;
}
</style>
