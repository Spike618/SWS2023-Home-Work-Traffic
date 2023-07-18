import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
import ElementPlus from "element-plus";
import "element-plus/dist/index.css";
import * as ElementPlusIconsVue from "@element-plus/icons-vue";
import axios from "axios";

// createApp(App).use(router).use.mount("#app");

const app = createApp(App);
app.use(router);
app.use(ElementPlus);
app.config.globalProperties.$axios = axios;

// Vue.prototype.$axios = axios
//配置请求的根路径
// axios.defaults.baseURL = 'http://10.120.2.2:8848/'


app.mount("#app");

for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
    app.component(key, component);
}
