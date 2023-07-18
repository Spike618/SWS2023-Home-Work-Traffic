import axios from "axios";
import qs from 'qs'

export const getCurrentOrder = () => {
  let token = localStorage.getItem("token")
  console.log("token", token)
  let config = {
    headers: {
      token: token
    },
    params: {
      mode: "CURRENT"
    }

  }
  return axios.get("/api/client/index/order", config)
}

export const getHistoryOrder = () => {
  let token = localStorage.getItem("token")
  console.log("token", token)
  let config = {
    headers: {
      token: token
    },
    params: {
      mode: "HISTORY"
    }

  }
  return axios.get("/api/client/index/order", config)
}
export const postOrder = (data) => {
  let token = localStorage.getItem("token")
  console.log("token", token, "data", data)
  let config = {
    headers: {
      token: token
    },

  }
  return axios.post("/api/client/index/order", data, config)
}

export const patchOrder = (data) => {
  let token = localStorage.getItem("token")
  console.log("token", token, "data", data)
  let config = {
    headers: {
      token: token
    },

  }
  return axios.patch("/api/client/index/order", data, config)
}
export const deleteOrder = (data) => {
  let token = localStorage.getItem("token")
  console.log("token", token, "data", data)
  let config = {
    headers: {
      token: token
    },
    data: data

  }
  return axios.delete("/api/client/index/order", config)
}


export const getUserMsg = () => {
  let token = localStorage.getItem("token")
  console.log("token", token)
  let config = {
    headers: {
      token: token
    }
  }
  return axios.get("/api/client/index/information", config)
}

export const postUserMsg = (data) => {
  let token = localStorage.getItem("token")
  console.log("token", token, "data", data)
  let config = {
    headers: {
      token: token
    },
  }
  return axios.post("/api/client/index/information", data, config)
}


export const getCarMsg = () => {
  let token = localStorage.getItem("token")
  console.log("token", token)
  let config = {
    headers: {
      token: token
    }
  }
  return axios.get("/api/client/index/car", config)
}
export const postCarMsg = (data) => {
  let token = localStorage.getItem("token")
  console.log("token", token, "data", data)
  let config = {
    headers: {
      token: token
    }
  }
  return axios.post("/api/client/index/car", data, config)
}

export const patchCarMsg = (data) => {
  let token = localStorage.getItem("token")
  console.log("token", token, "data", data)
  let config = {
    headers: {
      token: token
    }
  }
  return axios.patch("/api/client/index/car", data, config)
}


