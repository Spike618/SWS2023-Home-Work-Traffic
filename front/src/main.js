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

app.mount("#app");

for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
    app.component(key, component);
}
