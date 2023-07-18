import service from "@/http/index/request";


export function register(data) {
  return service({
    url: '/client/register',
    method: 'POST',
    data: data
  })
}

export function login(data) {
  return service({
    url: '/client/login',
    method: 'POST',
    data: data
  })
}

export function getAllMessage(data) {
  return service({
    url: '/admin/index/manage',
    method: 'GET',
    data: data
  })
}

export function fuck() {
  return service({
    url: '/admin/test',
    method: 'GET',
  })
}
