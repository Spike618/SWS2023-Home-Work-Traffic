<template>
  <div class="login">
    <div class="title">Commute Ease: Make City Better</div>
    <div class="mylogin" align="center">
      <el-row type="flex" justify="end">
        <el-switch v-model="LoginOrRegister" inline-prompt active-text="Login" inactive-text="Register"/>
      </el-row>


      <!-- 接下来是一个登录/注册界面框 -->

      <el-form :model="form" :rules="rules" ref="form" label-width="0px">
        <el-form-item label="" prop="account" style="margin-top: 10px">
          <el-input class="inps" placeholder="account" v-model="form.account" prefix-icon="User"></el-input>
        </el-form-item>
        <el-form-item label="" prop="password">
          <el-input class="inps" type="password" placeholder="password" v-model="form.password" prefix-icon="Lock"
                    show-password></el-input>
        </el-form-item>
        <el-form-item label="" prop="confirmPassword" v-if="!LoginOrRegister">
          <el-input class="inps" type="password" placeholder="verify password" v-model="form.confirmPassword"
                    prefix-icon="Lock" show-password></el-input>
        </el-form-item>
        <el-button v-if="!LoginOrRegister" type="warning" round class="submitBtn absolute-btn" @click="register">
          Register
        </el-button>
        <el-button v-else type="primary" round class="submitBtn absolute-btn" @click="login">
          Login
        </el-button>
      </el-form>
    </div>

  </div>
</template>

<script>
export default {
  data() {
    return {
      form: {
        account: "",
        password: "",
        confirmPassword: "",
        user_type: 1, //0为管理员，1为用户
      },
      rules: {
        account: [{required: true, message: "请输入账号", trigger: "blur"}],
        password: [
          {
            required: true,
            message: "请输入密码",
            trigger: "blur",
          },
          {
            validator: this.validatePassword,
            trigger: "blur",
          },
        ],
        confirmPassword: [
          {required: true, message: "请确认密码", trigger: "blur"},
        ],
      },
      LoginOrRegister: true,
    };
  },
  methods: {
    //登陆
    login() {
      const {account, password} = this.form;

      if (!account) {
        return this.$message({
          type: "error",
          message: "Account can't be empty!",
        });
      }

      if (!password) {
        return this.$message({
          type: "error",
          message: "Password can't be empty!",
        });
      }

      console.log("执行登录逻辑...");
      // 创建FormData对象
      const formData = new FormData();
      formData.append("username", account);
      formData.append("password", password);
      // 发送POST请求
      this.$axios
          .post("/users/login", formData)
          .then((response) => {
            // 解包后端返回的数据
            const {user_type, message} = response.data;

            console.log("登录成功！用户类型:", user_type);
            console.log("登录成功！消息:", message);

            // 显示成功消息
            this.$message.success("Login Successfully!");
            //切换页面
            if (user_type === 0) {
              // 导航到管理员界面
              sessionStorage.setItem("user_name", this.form.account); // 替换为从后端返回的用户名字段
              this.$router.push("/admin");
            } else {
              sessionStorage.setItem("user_name", this.form.account); // 替换为从后端返回的用户名字段
              // 导航到用户界面
              this.$router.push({
                path: "/user",
              });
            }
          })
          .catch((error) => {
            // 处理请求错误
            console.error("登录失败！", error);
            this.$message.error("登录失败，请检查账号和密码是否正确！");
          });
    },
    //注册
    register() {
      const {account, password, confirmPassword} = this.form;

      if (!account) {
        return this.$message({
          type: "error",
          message: "账号不能为空！",
        });
      }

      if (account === "all") {
        return this.$message({
          type: "error",
          message: "all为管理员账号，不允许注册！",
        });
      }
      if (!password) {
        return this.$message({
          type: "error",
          message: "密码不能为空！",
        });
      }

      if (!confirmPassword) {
        return this.$message({
          type: "error",
          message: "请确认密码！",
        });
      }

      if (confirmPassword !== password) {
        return this.$message({
          type: "error",
          message: "两次输入密码不一致！",
        });
      }
      console.log("执行注册逻辑...");
      // 创建FormData对象
      const formData = new FormData();
      formData.append("username", account);
      formData.append("password", password);
      // 发送POST请求
      this.$axios
          .post("/users/sign", formData)
          .then((response) => {
            // 解包后端返回的数据
            const {user_type, message} = response.data;

            console.log("注册成功！用户类型:", user_type);
            console.log("注册成功！消息:", message);
            //与后端同步，设置一下数据
            this.form.account = account;
            this.form.password = password;
            this.form.user_type = user_type;
            // 显示成功消息
            this.$message.success("注册成功，请直接登录！");
            // 切换到登录界面
            this.LoginOrRegister = true;
          })
          .catch((error) => {
            // 处理请求错误
            console.error("注册失败！", error);
            this.$message.error("注册失败，请稍后重试！");
          });
    },

    // 校验密码长度和字符
    validatePassword(rule, value, callback) {
      if (!value) {
        callback(new Error("请输入密码"));
      } else if (value.length < 8) {
        callback(new Error("密码长度不能少于8个字符"));
      } else if (!/[a-zA-Z]/.test(value) || !/\d/.test(value)) {
        callback(new Error("密码必须包含字母和数字"));
      } else {
        callback();
      }
    },
  },
};
</script>

<style scoped>
.title {
  height: 72px;
  margin: 14px 0 0 30px;
  line-height: 60px;
  float: left;
  color: #fff;
  font-size: 32px;
}

.login {
  width: 100%;
  height: 100%;
  background-image: url("../assets/background.jpg");
  background-size: cover;
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  margin: 0;
  padding: 0;
}

.mylogin {
  width: 400px;
  height: 250px;
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  margin: auto;
  padding: 50px 40px 40px 40px;
  opacity: 1;
  background: #fcfafa;
  border-radius: 10px;
}

.inps {
  display: flex;
  justify-content: center;
  align-items: center;
  color: #000000;
  background-color: transparent;
  font-size: 12px;
  text-align: center;
}

.submitBtn {
  width: 200px;
  display: block;
  margin: 0 auto;
}

.absolute-btn {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, 350%);
}

.label-text {
  width: 100px;
  /* 调整宽度以适应您的需求 */
}
</style>
