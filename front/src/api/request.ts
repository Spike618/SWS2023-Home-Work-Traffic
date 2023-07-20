import axios from "axios"
import { ElLoading } from 'element-plus'



const service=axios.create({
    baseURL:"api/",
    timeout:100000,
    headers:{
        "Content-Type":"application/json;charset=utf-8"
    }
})

let loading: any;
const startloading = ()=>{
    interface Options{
        lock: boolean,
        text: string,
        background: string
    }

    const options:Options = {
        lock:true,
        text:"loading...",
        background:'rgba(0,0,0,0.7)'
    }
    loading = ElLoading.service(options);
}
const endloading = () => {
    loading.close();
}

//请求拦截
service.interceptors.request.use(config => {
    startloading()
    config.headers=config.headers || {}
    if (localStorage.getItem('token')){
        config.headers.token=localStorage.getItem('token') || ""
    }
    return config
})

service.interceptors.response.use(res => {
    endloading()
    const code:number=res.data.code
    if (code==200 || code==0){
        return Promise.resolve(res.data)
    }
    return res
},error => {
    endloading()
    return Promise.reject(error)
})
export default service
