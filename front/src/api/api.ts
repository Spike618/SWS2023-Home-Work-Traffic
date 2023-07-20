import service from "@/api/request";


export function register(data:any){
    return service({
        url:'/user/register',
        method:'POST',
        data: data
    })
}

export function login(data:any){
    return service({
        url:'/user/login',
        method:'POST',
        data: data
    })
}

export function getAllMessage(data:any){
    return service({
        url:'/admin/index/manage',
        method:'GET',
        data:data
    })
}
export function changeMode(mode:string,id:any){
    let id_array = [id.toString()]
    let postdata = {
        "mode":mode,
        "switch_array":id_array
    }
    return service({
        url:'/admin/index/manage',
        method:'POST',
        data:postdata
    })
}

export function test() {
    return service({
        url: '/test',
        method: 'POST',
    })
}
