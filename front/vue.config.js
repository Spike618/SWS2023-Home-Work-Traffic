const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    proxy: {
      '/api': {
        target: 'https://10.120.2.2:8848/',
        changeOrigin: true,
        pathRewrite: {
          '^/api': '/'
        }
      }
    }
  }
})
