import axios from "axios";
import qs from 'qs'

export const getAllCar=()=>{
    let postdata:any=qs.stringify(localStorage.getItem("token"))
    return axios.get("http://127.0.0.1:4523/m1/2726825-0-default/admin/index/manage",postdata)
}

export const change=(mode:string,id:any)=>{
    let id_array = [id.toString()]
    let postdata = {
        "mode":mode,
        "switch_array":id_array
    }
    return axios.post("http://127.0.0.1:4523/m1/2726825-0-default/admin/index/manage",qs.stringify(postdata))
}