import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
const app = createApp(App)
app.use(store).use(router).mount('#app')
app.use(ElementPlus)
const debounce = (fn:any, delay:any) => {
  let timer:any = null;
  return function () {
    // @ts-ignore
      let context = this;
    let args = arguments;
    clearTimeout(timer);
    timer = setTimeout(function () {
      fn.apply(context, args);
    }, delay);
  }
}

const _ResizeObserver = window.ResizeObserver;
window.ResizeObserver = class ResizeObserver extends _ResizeObserver{
  constructor(callback:any) {
    callback = debounce(callback, 16);
    super(callback);
  }
}
