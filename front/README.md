








#### 1. 环境依赖

vue3

npm：8.15.0

node.js：16.17.0



#### 2. 开发工具

WebStorm  v2023.1.2



#### 3. 管理员端目录结构描述
```
│  .browserslistrc
│  .gitignore
│  babel.config.js
│  package-lock.json
│  package.json
│  README.md
│  tsconfig.json
│  vue.config.js
│
├─public
│  │  favicon.ico
│  │  index.html
│  │
│  └─css
│          reset.css
│
└─src
    │  App.vue
    │  main.ts
    │  shims-vue.d.ts
    │
    ├─api
    │      api.ts
    │      request.ts
    │
    ├─assets
    │  │  404-not-found.gif
    │  │
    │  └─img
    │          1.svg
    │          2.svg
    │          log.svg
    │          register.svg
    │
    ├─class
    │      ChargeReport.ts
    │      UserOrder.ts
    │
    ├─components
    │      Detail.vue
    │      LoginForm.vue
    │      Report.vue
    │      ShowReport.vue
    │      SingleCharge.vue
    │      welcome.vue
    │
    │
    ├─router
    │      index.ts
    │
    ├─store
    │      index.ts
    │
    ├─utils
    │      Login.ts
    │      Register.ts
    │
    └─views
            Admin.vue
            Login_Register.vue
            NotFound.vue
```


#### 4. 部署说明

##### 4.1 Project Setup

```sh
npm install
```

  在启动程序之前首先进行依赖的安装，将原有的module文件夹删除，然后在终端上执行上述命令即可。

##### 4.2 Port Setting

```
target:'http://121.43.119.64:8848/',
```

  在vue.config.js这一文件中找到该行，然后修改对应的服务端ip地址即可

##### 4.3 Compile and Hot-Reload for Development

```sh
npm run serve
```

安装了对应依赖并配置正确的IP地址之后，利用上述命令进行执行即可。

##### 4.4 Type-Check, Compile and Minify for Production

```sh
npm run build
```



