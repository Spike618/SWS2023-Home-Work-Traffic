<template>
  <el-form
      ref="Register"
      :rules="registerRules"
      :model="registerUser"
      label-width="100px"
      class="Register_Form sign-up-form"
  >
    <el-form-item class="item_style" label="Email" prop="email">
      <el-input
          class="input-transparent"
          v-model="registerUser.email"
          placeholder="Enter email"
      />
    </el-form-item>
    <el-form-item class="item_style" label="Username" prop="name">
      <el-input
          class="input-transparent"
          v-model="registerUser.name"
          placeholder="Enter username"
      />
    </el-form-item>
    <el-form-item class="item_style" label="Password" prop="password">
      <el-input
          class="input-transparent"
          v-model="registerUser.password"
          type="password"
          show-password
          placeholder="Enter password"
      />
    </el-form-item>
    <el-form-item class="item_style" label="Verify" prop="password2">
      <el-input
          class="input-transparent"
          v-model="registerUser.password2"
          type="password"
          show-password
          placeholder="Enter password again"
      />
    </el-form-item>
    <el-form-item>
      <el-button @click="Justic_Register('Register')" type="primary" class="submit_btn">注册</el-button>
    </el-form-item>
  </el-form>
</template>

<script lang="ts">
import {getCurrentInstance} from "vue";
import {useRouter} from "vue-router";
import {register} from "@/api/api";
import {ElMessage} from "element-plus";

export default {
  props: {
    registerUser: {
      type: Object,
      required: true,
    },
    registerRules: {
      type: Object,
      required: true,
    }
  },
  setup(props: any) {
    //@ts-ignore
    const {ctx} = getCurrentInstance()
    const router = useRouter()
    const Justic_Register = (foreName: string) => {
      console.log(ctx)
      ctx.$refs[foreName].validate((valid: boolean) => {
        if (valid) {
          const data = {
            "email": (props.registerUser.email),
            "password": (props.registerUser.password),
            "name": (props.registerUser.name),
          }

          console.log("data",data)
          register(JSON.stringify(data)).then((res: any) => {
            console.log("res",res.data["code"])
            if (res.data['code'] == 0) {
              alert("Register successfully!")
              router.push('/route')
            }

            if (res.data['code'] == -1) {
              ElMessage.error(res.data["msg"])
              router.push('/')
            }

          })
        } else {
          console.log('error submit!')
          return false
        }
      });
    }
    const success = () => {
      ElMessage('create user successfully')
    }
    return {Justic_Register}
  },
};
</script>

<style scoped>
.Register_Form {
  margin-bottom: 100px;
  background-image: linear-gradient(-45deg, #236b7f 0%, #08a5d1 100%);
  padding: 40px 40px 30px 20px;
  border-radius: 5px;
  box-shadow: 0px 5px 10px #08a5d1;
}

.submit_btn {
  background-image: linear-gradient(-45deg, #236b7f 0%, #08a5d1 100%);
  border-radius: 10px;
  border: 2px solid #08a5d1;
  width: 100%;
}

.input-transparent >>> .el-input__wrapper {
  background-color: transparent;
  border: 2px solid #08a5d1;
  box-shadow: none;
}

.input-transparent >>> .el-input__wrapper .el-input__inner {
  color: #e8f0f2;
}

.item_style >>> .el-form-item__label {
  color: white;
}
</style>
