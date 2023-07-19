<template>
  <el-form
      ref="Login"
      :rules="rules"
      :model="loginUser"
      label-width="120px"
      class="Login_Form sign-in-form"
  >
    <el-form-item class="item_style" label="用户名" prop="username">
      <el-input
          class="input-transparent"
          v-model="loginUser.username"
          placeholder="Enter username"
      />
    </el-form-item>
    <el-form-item class="item_style" label="密码" prop="password">
      <el-input
          class="input-transparent"
          v-model="loginUser.password"
          type="password"
          show-password
          placeholder="Enter password"
      />
    </el-form-item>

    <el-form-item>
      <el-button color="#0000000" @click="Justic_Login('Login')" class="submit_btn">登录</el-button>
    </el-form-item>
  </el-form>
</template>

<script lang="ts">
import {getCurrentInstance} from "vue";
import {login} from "@/api/api";
import {ElMessage} from "element-plus";
import router from "@/router";

export default {
  props: {
    loginUser: {
      type: Object,
      required: true,
    },
    rules: {
      type: Object,
      required: true,
    },
    signUpMode: {
      type: Object,
      required: true,
    }
  },
  setup(props:any) {
    //@ts-ignore
    const {ctx} = getCurrentInstance()
    const Justic_Login = (foreName: string) => {
      ctx.$refs[foreName].validate((valid: boolean) => {
        if (valid) {
          const data = {"account":(props.loginUser.username),"password":(props.loginUser.password)}
          login(JSON.stringify(data)).then((res:any)=>{
            console.log(res)
            if (res['code']==0)
            {
              const token = res.data['token']
              localStorage.setItem("token",token)
              router.push('/admin')
            }
            if (res.data['code']==-1)
            {
              console.log(res)
              failure()
            }
          })
        } else {
          console.log('error submit!')
          return false
        }
      });
    };
    const failure = ()=>{
      ElMessage('用户名或密码错误。')
      console.log()
    }
    return {Justic_Login}
  }
}
</script>

<style scoped>
.Login_Form {
  margin-top: 100px;
  background-image: linear-gradient(-45deg, #000000 0%, #236b7f 100%);
  padding: 40px 40px 30px 20px;
  border-radius: 5px;
  box-shadow: 0px 5px 10px #085f77;
}
.submit_btn{
  background-image: linear-gradient(-45deg, #000000 0%, #236b7f 100%);
  border-radius: 10px;
  border: 2px solid #085f77;
  width: 100%;
}
.input-transparent >>> .el-input__wrapper {
  background-color: transparent;
  border: 2px solid #085f77;
  box-shadow: none;
}
.input-transparent >>> .el-input__wrapper .el-input__inner {
  color: white;
}
.item_style >>> .el-form-item__label{
  color: white;
}
</style>
