module.exports = {
  configureWebpack: {
    resolve: {
      //extensions: [],
      alias: {
        //"@": "src"
        "assets": "@/assets",
        "common": "@/common",
        "components": "@/components",
        "network": "@/network",
        "views": "@/views",
        "image": "@/assets/image",
        "heyi": "@/components/common/heyi",
        "store": "@/store"
      }
    }
  }
}
