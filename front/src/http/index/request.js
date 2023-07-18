import axios from "axios"
// @ts-ignore
import {ElLoading} from "element-plus";


const service = axios.create({
  baseURL: "/api",
  timeout: 500000,
  headers: {
    "Content-Type": "application/json;charset=utf-8"
  }
})

let loading;
const startloading = () => {

  const options = {
    lock: true,
    text: "加载中",
    background: 'rgba(0,0,0,0.7)'
  }
  loading = ElLoading.service(options);
}
const endloading = () => {
  loading.close();
}

//请求拦截
service.interceptors.request.use(config => {
  startloading()
  config.headers = config.headers || {}
  if (localStorage.getItem('token')) {
    config.headers.token = localStorage.getItem('token') || ""
  }
  return config
})

service.interceptors.response.use(res => {
  endloading()
  const code = res.data.code
  if (code == 200 || code == 0) {
    return Promise.resolve(res.data)
  }
  return res
}, error => {
  endloading()
  return Promise.reject(error)
})
export default service
